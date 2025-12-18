<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../../config/database.php';

// ================= SECRET KEY =================
define('SECRET_KEY', 'your_secret_key_change_this_in_production');

// ================= VERIFY TOKEN =================
function verifyToken($token, $db) {
    $decoded = base64_decode($token);
    $parts = explode(':', $decoded);

    if (count($parts) !== 3) {
        return false;
    }

    $userId = $parts[0];
    $timestamp = $parts[1];
    $signature = $parts[2];

    $payload = $userId . ':' . $timestamp;
    $expectedSignature = hash_hmac('sha256', $payload, SECRET_KEY);

    if (!hash_equals($signature, $expectedSignature)) {
        return false;
    }

    // Check if token is not expired (24 hours)
    if (time() - $timestamp > 86400) {
        return false;
    }

    // Check if user exists and is active
    $query = "SELECT user_id, role FROM users WHERE user_id = :user_id AND is_active = 1";
    $stmt = $db->prepare($query);
    $stmt->bindParam(":user_id", $userId);
    $stmt->execute();

    if ($stmt->rowCount() === 0) {
        return false;
    }

    $user = $stmt->fetch(PDO::FETCH_ASSOC);
    return $user; // Return user data including role
}

// ================= GET USER FROM TOKEN =================
function getAuthUser($db) {
    $headers = getallheaders();
    if (!isset($headers['Authorization'])) {
        http_response_code(401);
        echo json_encode(["success" => false, "message" => "Authorization header missing"]);
        exit();
    }

    $authHeader = $headers['Authorization'];
    if (!preg_match('/Bearer\s+(.*)$/i', $authHeader, $matches)) {
        http_response_code(401);
        echo json_encode(["success" => false, "message" => "Invalid authorization format"]);
        exit();
    }

    $token = $matches[1];
    $user = verifyToken($token, $db);

    if (!$user) {
        http_response_code(401);
        echo json_encode(["success" => false, "message" => "Invalid or expired token"]);
        exit();
    }

    return $user;
}

$database = new Database();
$db = $database->getConnection();

// Verify token and get user info
$user = getAuthUser($db);
$userId = $user['user_id'];
$userRole = $user['role'];

$data = json_decode(file_get_contents("php://input"));

if (!empty($data->loan_id)) {
    
    // Validate loan_id
    if (!is_numeric($data->loan_id)) {
        http_response_code(400);
        echo json_encode([
            "success" => false,
            "message" => "Loan ID must be numeric"
        ]);
        exit();
    }
    
    // Get loan details with authorization check
    $check_query = "SELECT ln.*, i.item_id, i.quantity as current_stock
                    FROM loans ln
                    JOIN items i ON ln.item_id = i.item_id
                    WHERE ln.loan_id = :loan_id AND ln.status IN ('active', 'overdue')";
    
    // Add authorization: users can only return their own loans, admins can return any
    if ($userRole !== 'admin') {
        $check_query .= " AND ln.borrower_id = :borrower_id";
    }
    
    $check_stmt = $db->prepare($check_query);
    $check_stmt->bindParam(":loan_id", $data->loan_id);
    if ($userRole !== 'admin') {
        $check_stmt->bindParam(":borrower_id", $userId);
    }
    $check_stmt->execute();
    
    if ($check_stmt->rowCount() == 0) {
        http_response_code(404);
        echo json_encode([
            "success" => false,
            "message" => "Active loan not found or access denied"
        ]);
        exit();
    }
    
    $loan = $check_stmt->fetch(PDO::FETCH_ASSOC);
    
    // Validate condition if provided
    if (isset($data->condition_returned)) {
        $valid_conditions = ['good', 'damaged', 'maintenance'];
        if (!in_array($data->condition_returned, $valid_conditions)) {
            http_response_code(400);
            echo json_encode([
                "success" => false,
                "message" => "Invalid condition. Must be: good, damaged, or maintenance"
            ]);
            exit();
        }
    }
    
    try {
        $db->beginTransaction();
        
        // Update loan status
        $query = "UPDATE loans 
                  SET status = 'returned',
                      return_date = NOW(),
                      condition_returned = :condition_returned,
                      notes = :notes,
                      returned_to = :returned_to
                  WHERE loan_id = :loan_id";
        
        $stmt = $db->prepare($query);
        
        $condition = isset($data->condition_returned) ? $data->condition_returned : 'good';
        $stmt->bindParam(":condition_returned", $condition);
        $notes = isset($data->notes) ? $data->notes : null;
        $stmt->bindParam(":notes", $notes);
        $stmt->bindParam(":returned_to", $userId); // Use authenticated user
        $stmt->bindParam(":loan_id", $data->loan_id);
        
        $stmt->execute();
        
        // Update item quantity
        $update_query = "UPDATE items SET quantity = quantity + :quantity WHERE item_id = :item_id";
        $update_stmt = $db->prepare($update_query);
        $update_stmt->bindParam(":quantity", $loan['quantity']);
        $update_stmt->bindParam(":item_id", $loan['item_id']);
        $update_stmt->execute();
        
        // Update item condition if damaged
        if ($condition != 'good') {
            $condition_query = "UPDATE items SET condition_status = :condition WHERE item_id = :item_id";
            $condition_stmt = $db->prepare($condition_query);
            $condition_stmt->bindParam(":condition", $condition);
            $condition_stmt->bindParam(":item_id", $loan['item_id']);
            $condition_stmt->execute();
        }
        
        // Log stock movement
        $log_query = "INSERT INTO stock_movements 
                      (item_id, movement_type, quantity, notes, performed_by)
                      VALUES 
                      (:item_id, 'in', :quantity, :notes, :performed_by)";
        $log_stmt = $db->prepare($log_query);
        $log_stmt->bindParam(":item_id", $loan['item_id']);
        $log_stmt->bindParam(":quantity", $loan['quantity']);
        $log_notes = "Returned - Loan ID: " . $data->loan_id;
        $log_stmt->bindParam(":notes", $log_notes);
        $log_stmt->bindParam(":performed_by", $userId); // Use authenticated user
        $log_stmt->execute();
        
        $db->commit();
        
        http_response_code(200);
        echo json_encode([
            "success" => true,
            "message" => "Item returned successfully"
        ]);
        
    } catch (Exception $e) {
        $db->rollBack();
        http_response_code(500);
        echo json_encode([
            "success" => false,
            "message" => "Failed to return item: " . $e->getMessage()
        ]);
    }
    
} else {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Loan ID required"
    ]);
}
?>