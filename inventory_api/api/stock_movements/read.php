<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

// Get optional item_id filter
$item_id = isset($_GET['item_id']) ? $_GET['item_id'] : null;

$query = "SELECT 
            sm.movement_id, sm.movement_type, sm.quantity, sm.movement_date,
            sm.reference_number, sm.notes,
            i.item_id, i.item_name, i.barcode,
            l1.location_name as from_location,
            l2.location_name as to_location,
            u.full_name as performed_by_name
          FROM stock_movements sm
          JOIN items i ON sm.item_id = i.item_id
          LEFT JOIN locations l1 ON sm.from_location_id = l1.location_id
          LEFT JOIN locations l2 ON sm.to_location_id = l2.location_id
          JOIN users u ON sm.performed_by = u.user_id";

if ($item_id) {
    $query .= " WHERE sm.item_id = :item_id";
}

$query .= " ORDER BY sm.movement_date DESC LIMIT 100";

$stmt = $db->prepare($query);

if ($item_id) {
    $stmt->bindParam(":item_id", $item_id);
}

$stmt->execute();

$movements = $stmt->fetchAll(PDO::FETCH_ASSOC);

http_response_code(200);
echo json_encode([
    "success" => true,
    "count" => count($movements),
    "data" => $movements
]);
?>