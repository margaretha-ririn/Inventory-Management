<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

// Get item_id from URL parameter
$item_id = isset($_GET['item_id']) ? $_GET['item_id'] : null;

if ($item_id) {
    $query = "SELECT 
                i.item_id, i.barcode, i.item_name, i.description, 
                i.quantity, i.min_stock, i.unit_price, i.total_value,
                i.condition_status, i.image_url, i.sku, i.created_at, i.updated_at,
                c.category_name, c.category_id,
                l.location_name, l.location_id, l.building, l.floor, l.room_number,
                u.full_name as created_by_name
              FROM items i
              LEFT JOIN categories c ON i.category_id = c.category_id
              LEFT JOIN locations l ON i.location_id = l.location_id
              LEFT JOIN users u ON i.created_by = u.user_id
              WHERE i.item_id = :item_id AND i.is_active = 1";
    
    $stmt = $db->prepare($query);
    $stmt->bindParam(":item_id", $item_id);
    $stmt->execute();
    
    if ($stmt->rowCount() > 0) {
        $item = $stmt->fetch(PDO::FETCH_ASSOC);
        
        http_response_code(200);
        echo json_encode([
            "success" => true,
            "data" => $item
        ]);
    } else {
        http_response_code(404);
        echo json_encode([
            "success" => false,
            "message" => "Item not found"
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