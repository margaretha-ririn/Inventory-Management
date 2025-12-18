<?php
// ===== CORS =====
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

// Handle preflight request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

include_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

// Ambil data JSON
$data = json_decode(file_get_contents("php://input"), true);

// Validasi wajib
if (!empty($data['item_name']) && !empty($data['category_id'])) {

    // ===== DEFAULT VALUE (ANTI ERROR) =====
    $barcode        = $data['barcode']        ?? null;
    $item_name      = $data['item_name'];
    $description    = $data['description']    ?? null;
    $category_id    = $data['category_id'];
    $location_id    = $data['location_id']    ?? null;
    $quantity       = $data['quantity']       ?? 0;
    $min_stock      = $data['min_stock']      ?? 5;
    $unit_price     = $data['unit_price']     ?? 0;
    $condition      = $data['condition_status'] ?? 'good';
    $image_url      = $data['image_url']      ?? null;
    $sku            = $data['sku']            ?? null;
    $created_by     = $data['created_by']     ?? null;

    $query = "INSERT INTO items (
                barcode, item_name, description, category_id, location_id,
                quantity, min_stock, unit_price, condition_status,
                image_url, sku, created_by
              ) VALUES (
                :barcode, :item_name, :description, :category_id, :location_id,
                :quantity, :min_stock, :unit_price, :condition_status,
                :image_url, :sku, :created_by
              )";

    try {
        $stmt = $db->prepare($query);

        $stmt->bindParam(":barcode", $barcode);
        $stmt->bindParam(":item_name", $item_name);
        $stmt->bindParam(":description", $description);
        $stmt->bindParam(":category_id", $category_id);
        $stmt->bindParam(":location_id", $location_id);
        $stmt->bindParam(":quantity", $quantity);
        $stmt->bindParam(":min_stock", $min_stock);
        $stmt->bindParam(":unit_price", $unit_price);
        $stmt->bindParam(":condition_status", $condition);
        $stmt->bindParam(":image_url", $image_url);
        $stmt->bindParam(":sku", $sku);
        $stmt->bindParam(":created_by", $created_by);

        if ($stmt->execute()) {
            http_response_code(201);
            echo json_encode([
                "success" => true,
                "message" => "Item berhasil ditambahkan",
                "item_id" => $db->lastInsertId()
            ]);
        } else {
            throw new Exception("Gagal mengeksekusi query");
        }

    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode([
            "success" => false,
            "message" => "Server error: " . $e->getMessage()
        ]);
    }

} else {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "item_name dan category_id wajib diisi"
    ]);
}
?>
