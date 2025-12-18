<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

include_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

$data = json_decode(file_get_contents("php://input"));

if (!empty($data->item_name) && !empty($data->category_id)) {
    $query = "INSERT INTO items 
              (barcode, item_name, description, category_id, location_id, 
               quantity, min_stock, unit_price, condition_status, image_url, sku, created_by)
              VALUES 
              (:barcode, :item_name, :description, :category_id, :location_id,
               :quantity, :min_stock, :unit_price, :condition_status, :image_url, :sku, :created_by)";
    
    $stmt = $db->prepare($query);
    
    $stmt->bindParam(":barcode", $data->barcode);
    $stmt->bindParam(":item_name", $data->item_name);
    $stmt->bindParam(":description", $data->description);
    $stmt->bindParam(":category_id", $data->category_id);
    $stmt->bindParam(":location_id", $data->location_id);
    $stmt->bindParam(":quantity", $data->quantity);
    $min_stock = isset($data->min_stock) ? $data->min_stock : 5;
    $stmt->bindParam(":min_stock", $min_stock);
    $stmt->bindParam(":unit_price", $data->unit_price);
    $condition = isset($data->condition_status) ? $data->condition_status : 'good';
    $stmt->bindParam(":condition_status", $condition);
    $stmt->bindParam(":image_url", $data->image_url);
    $stmt->bindParam(":sku", $data->sku);
    $stmt->bindParam(":created_by", $data->created_by);
    
    if ($stmt->execute()) {
        http_response_code(201);
        echo json_encode([
            "success" => true,
            "message" => "Item created successfully",
            "item_id" => $db->lastInsertId()
        ]);
    } else {
        http_response_code(500);
        echo json_encode([
            "success" => false,
            "message" => "Unable to create item"
        ]);
    }
} else {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Item name and category required"
    ]);
}
?>
