<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

$query = "SELECT 
            category_id, category_name, description, icon_name,
            (SELECT COUNT(*) FROM items WHERE category_id = c.category_id AND is_active = 1) as item_count
          FROM categories c
          ORDER BY category_name ASC";

$stmt = $db->prepare($query);
$stmt->execute();

$categories = $stmt->fetchAll(PDO::FETCH_ASSOC);

http_response_code(200);
echo json_encode([
    "success" => true,
    "count" => count($categories),
    "data" => $categories
]);
?>

