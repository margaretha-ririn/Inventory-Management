// api/items/delete.php
<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

$data = json_decode(file_get_contents("php://input"));

if (!empty($data->item_id)) {
    // Soft delete - set is_active to 0
    $query = "UPDATE items SET is_active = 0 WHERE item_id = :item_id";
    
    try {
        $stmt = $db->prepare($query);
        $stmt->bindParam(":item_id", $data->item_id);
        
        if ($stmt->execute()) {
            if ($stmt->rowCount() > 0) {
                http_response_code(200);
                echo json_encode([
                    "success" => true,
                    "message" => "Item deleted successfully"
                ]);
            } else {
                http_response_code(404);
                echo json_encode([
                    "success" => false,
                    "message" => "Item not found"
                ]);
            }
        } else {
            http_response_code(500);
            echo json_encode([
                "success" => false,
                "message" => "Unable to delete item"
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