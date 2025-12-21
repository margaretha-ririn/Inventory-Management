<?php
// --- search.php ---
$host = "localhost"; $user = "root"; $pass = ""; $db = "inventory_app";
$connect = new mysqli($host, $user, $pass, $db);

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$keyword = $_GET['query'] ?? '';

// Cari berdasarkan Nama Barang ATAU SKU
$sql = "SELECT * FROM items WHERE name LIKE '%$keyword%' OR sku LIKE '%$keyword%'";
$result = $connect->query($sql);

$items = [];
while ($row = $result->fetch_assoc()) {
    $items[] = $row;
}

echo json_encode([
    "success" => true,
    "data" => $items
]);
?>