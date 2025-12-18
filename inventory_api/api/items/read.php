<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

$query = "SELECT 
            i.item_id, i.barcode, i.item_name, i.description, 
            i.quantity, i.min_stock, i.unit_price, i.total_value,
            i.condition_status, i.image_url, i.sku, i.created_at,
            c.category_name, c.category_id,
            l.location_name, l.location_id, l.building, l.room_number
          FROM items i
          LEFT JOIN categories c ON i.category_id = c.category_id
          LEFT JOIN locations l ON i.location_id = l.location_id
          WHERE i.is_active = 1
          ORDER BY i.created_at DESC";

$stmt = $db->prepare($query);
$stmt->execute();

$items = $stmt->fetchAll(PDO::FETCH_ASSOC);

http_response_code(200);
echo json_encode([
    "success" => true,
    "count" => count($items),
    "data" => $items
]);
?>