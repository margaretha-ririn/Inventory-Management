// api/locations/read.php
<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

$query = "SELECT 
            location_id, location_name, building, floor, room_number, description, capacity,
            (SELECT COUNT(*) FROM items WHERE location_id = l.location_id AND is_active = 1) as item_count,
            (SELECT SUM(quantity) FROM items WHERE location_id = l.location_id AND is_active = 1) as total_quantity
          FROM locations l
          ORDER BY building ASC, floor ASC, location_name ASC";

$stmt = $db->prepare($query);
$stmt->execute();

$locations = $stmt->fetchAll(PDO::FETCH_ASSOC);

http_response_code(200);
echo json_encode([
    "success" => true,
    "count" => count($locations),
    "data" => $locations
]);
?>
