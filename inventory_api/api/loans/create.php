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
    $query = "SELECT user_id FROM users WHERE user_id = :user_id AND is_active = 1";
    $stmt = $db->prepare($query);
    $stmt->bindParam(":user_id", $userId);
    $stmt->execute();

    if ($stmt->rowCount() === 0) {
        return false;
    }

    return $userId; // Return user_id if valid
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
    $userId = verifyToken($token, $db);

    if (!$userId) {
        http_response_code(401);
        echo json_encode(["success" => false, "message" => "Invalid or expired token"]);
        exit();
    }

    return $userId;
}

$database = new Database();
$db = $database->getConnection();

// Verify token
$userId = getAuthUser($db);

$data = json_decode(file_get_contents("php://input"));

if (!empty($data->item_id) && !empty($data->borrower_id) && !empty($data->due_date)) {
    
    // Validate inputs
    if (!is_numeric($data->item_id) || !is_numeric($data->borrower_id)) {
        http_response_code(400);
        echo json_encode([
            "success" => false,
            "message" => "Item ID and borrower ID must be numeric"
        ]);
        exit();
    }
    
    // Validate due date format (YYYY-MM-DD)
    if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $data->due_date)) {
        http_response_code(400);
        echo json_encode([
            "success" => false,
            "message" => "Due date must be in YYYY-MM-DD format"
        ]);
        exit();
    }
    
    // Check if due date is not in the past
    if (strtotime($data->due_date) < strtotime(date('Y-m-d'))) {
        http_response_code(400);
        echo json_encode([
            "success" => false,
            "message" => "Due date cannot be in the past"
        ]);
        exit();
    }
    
    // Check if item has sufficient quantity
    $check_query = "SELECT quantity FROM items WHERE item_id = :item_id AND is_active = 1";
    $check_stmt = $db->prepare($check_query);
    $check_stmt->bindParam(":item_id", $data->item_id);
    $check_stmt->execute();
    
    if ($check_stmt->rowCount() == 0) {
        http_response_code(404);
        echo json_encode([
            "success" => false,
            "message" => "Item not found"
        ]);
        exit();
    }
    
    $item = $check_stmt->fetch(PDO::FETCH_ASSOC);
    $quantity = isset($data->quantity) ? $data->quantity : 1;
    
    if (!is_numeric($quantity) || $quantity <= 0) {
        http_response_code(400);
        echo json_encode([
            "success" => false,
            "message" => "Quantity must be a positive number"
        ]);
        exit();
    }
    
    if ($item['quantity'] < $quantity) {
        http_response_code(400);
        echo json_encode([
            "success" => false,
            "message" => "Insufficient stock. Available: " . $item['quantity']
        ]);
        exit();
    }
    
    // Validate condition if provided
    if (isset($data->condition_borrowed)) {
        $valid_conditions = ['good', 'damaged', 'maintenance'];
        if (!in_array($data->condition_borrowed, $valid_conditions)) {
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
        
        // Insert loan
        $query = "INSERT INTO loans 
                  (item_id, borrower_id, quantity, due_date, condition_borrowed, notes, approved_by)
                  VALUES 
                  (:item_id, :borrower_id, :quantity, :due_date, :condition_borrowed, :notes, :approved_by)";
        
        $stmt = $db->prepare($query);
        
        $stmt->bindParam(":item_id", $data->item_id);
        $stmt->bindParam(":borrower_id", $data->borrower_id);
        $stmt->bindParam(":quantity", $quantity);
        $stmt->bindParam(":due_date", $data->due_date);
        $condition = isset($data->condition_borrowed) ? $data->condition_borrowed : 'good';
        $stmt->bindParam(":condition_borrowed", $condition);
        $stmt->bindParam(":notes", $data->notes);
        $stmt->bindParam(":approved_by", $userId); // Use authenticated user
        
        $stmt->execute();
        $loan_id = $db->lastInsertId();
        
        // Update item quantity
        $update_query = "UPDATE items SET quantity = quantity - :quantity WHERE item_id = :item_id";
        $update_stmt = $db->prepare($update_query);
        $update_stmt->bindParam(":quantity", $quantity);
        $update_stmt->bindParam(":item_id", $data->item_id);
        $update_stmt->execute();
        
        // Log stock movement
        $log_query = "INSERT INTO stock_movements 
                      (item_id, movement_type, quantity, notes, performed_by)
                      VALUES 
                      (:item_id, 'out', :quantity, :notes, :performed_by)";
        $log_stmt = $db->prepare($log_query);
        $log_stmt->bindParam(":item_id", $data->item_id);
        $log_stmt->bindParam(":quantity", $quantity);
        $log_notes = "Borrowed - Loan ID: " . $loan_id;
        $log_stmt->bindParam(":notes", $log_notes);
        $log_stmt->bindParam(":performed_by", $userId); // Use authenticated user
        $log_stmt->execute();
        
        $db->commit();
        
        http_response_code(201);
        echo json_encode([
            "success" => true,
            "message" => "Loan created successfully",
            "loan_id" => $loan_id
        ]);
        
    } catch (Exception $e) {
        $db->rollBack();
        http_response_code(500);
        echo json_encode([
            "success" => false,
            "message" => "Failed to create loan: " . $e->getMessage()
        ]);
    }
    
} else {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Item ID, borrower ID, and due date required"
    ]);
}
?>