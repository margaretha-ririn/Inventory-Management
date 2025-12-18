// api/items/update.php
<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST, PUT");
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

if (!empty($data->item_id)) {
    // Validate item_id is numeric
    if (!is_numeric($data->item_id)) {
        http_response_code(400);
        echo json_encode([
            "success" => false,
            "message" => "Invalid item ID"
        ]);
        exit();
    }

    // Build dynamic update query
    $updates = [];
    $params = [':item_id' => $data->item_id];
    
    // Validate and add fields
    if (isset($data->item_name)) {
        if (empty(trim($data->item_name))) {
            http_response_code(400);
            echo json_encode([
                "success" => false,
                "message" => "Item name cannot be empty"
            ]);
            exit();
        }
        $updates[] = "item_name = :item_name";
        $params[':item_name'] = trim($data->item_name);
    }
    
    if (isset($data->barcode)) {
        $updates[] = "barcode = :barcode";
        $params[':barcode'] = $data->barcode;
    }
    
    if (isset($data->description)) {
        $updates[] = "description = :description";
        $params[':description'] = $data->description;
    }
    
    if (isset($data->category_id)) {
        if (!is_numeric($data->category_id)) {
            http_response_code(400);
            echo json_encode([
                "success" => false,
                "message" => "Invalid category ID"
            ]);
            exit();
        }
        $updates[] = "category_id = :category_id";
        $params[':category_id'] = $data->category_id;
    }
    
    if (isset($data->location_id)) {
        if (!is_numeric($data->location_id)) {
            http_response_code(400);
            echo json_encode([
                "success" => false,
                "message" => "Invalid location ID"
            ]);
            exit();
        }
        $updates[] = "location_id = :location_id";
        $params[':location_id'] = $data->location_id;
    }
    
    if (isset($data->quantity)) {
        if (!is_numeric($data->quantity) || $data->quantity < 0) {
            http_response_code(400);
            echo json_encode([
                "success" => false,
                "message" => "Quantity must be a non-negative number"
            ]);
            exit();
        }
        $updates[] = "quantity = :quantity";
        $params[':quantity'] = $data->quantity;
    }
    
    if (isset($data->min_stock)) {
        if (!is_numeric($data->min_stock) || $data->min_stock < 0) {
            http_response_code(400);
            echo json_encode([
                "success" => false,
                "message" => "Minimum stock must be a non-negative number"
            ]);
            exit();
        }
        $updates[] = "min_stock = :min_stock";
        $params[':min_stock'] = $data->min_stock;
    }
    
    if (isset($data->unit_price)) {
        if (!is_numeric($data->unit_price) || $data->unit_price < 0) {
            http_response_code(400);
            echo json_encode([
                "success" => false,
                "message" => "Unit price must be a non-negative number"
            ]);
            exit();
        }
        $updates[] = "unit_price = :unit_price";
        $params[':unit_price'] = $data->unit_price;
    }
    
    if (isset($data->condition_status)) {
        $valid_conditions = ['good', 'damaged', 'maintenance'];
        if (!in_array($data->condition_status, $valid_conditions)) {
            http_response_code(400);
            echo json_encode([
                "success" => false,
                "message" => "Invalid condition status. Must be: good, damaged, or maintenance"
            ]);
            exit();
        }
        $updates[] = "condition_status = :condition_status";
        $params[':condition_status'] = $data->condition_status;
    }
    
    if (isset($data->image_url)) {
        $updates[] = "image_url = :image_url";
        $params[':image_url'] = $data->image_url;
    }
    
    if (isset($data->sku)) {
        $updates[] = "sku = :sku";
        $params[':sku'] = $data->sku;
    }
    
    if (empty($updates)) {
        http_response_code(400);
        echo json_encode([
            "success" => false,
            "message" => "No valid fields to update"
        ]);
        exit();
    }
    
    // Always update timestamp and user
    $updates[] = "updated_at = NOW()";
    $updates[] = "updated_by = :updated_by";
    $params[':updated_by'] = $userId;
    
    // If quantity or unit_price changed, recalculate total_value
    $shouldRecalculateTotal = isset($data->quantity) || isset($data->unit_price);
    if ($shouldRecalculateTotal) {
        // Get current values if not provided
        $currentQuery = "SELECT quantity, unit_price FROM items WHERE item_id = :item_id";
        $currentStmt = $db->prepare($currentQuery);
        $currentStmt->bindParam(":item_id", $data->item_id);
        $currentStmt->execute();
        $currentItem = $currentStmt->fetch(PDO::FETCH_ASSOC);
        
        $finalQuantity = isset($data->quantity) ? $data->quantity : $currentItem['quantity'];
        $finalUnitPrice = isset($data->unit_price) ? $data->unit_price : $currentItem['unit_price'];
        
        $totalValue = $finalQuantity * $finalUnitPrice;
        $updates[] = "total_value = :total_value";
        $params[':total_value'] = $totalValue;
    }
    
    $query = "UPDATE items SET " . implode(", ", $updates) . " WHERE item_id = :item_id AND is_active = 1";
    
    try {
        $stmt = $db->prepare($query);
        
        foreach ($params as $key => $value) {
            $stmt->bindValue($key, $value);
        }
        
        if ($stmt->execute()) {
            // Check if any row was actually updated
            if ($stmt->rowCount() > 0) {
                http_response_code(200);
                echo json_encode([
                    "success" => true,
                    "message" => "Item updated successfully"
                ]);
            } else {
                http_response_code(404);
                echo json_encode([
                    "success" => false,
                    "message" => "Item not found or no changes made"
                ]);
            }
        } else {
            http_response_code(500);
            echo json_encode([
                "success" => false,
                "message" => "Unable to update item"
            ]);
        }
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode([
            "success" => false,
            "message" => "Database error: " . $e->getMessage()
        ]);
    }
} else {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Item ID required"
    ]);
}
?>