<?php
// --- FILE: history.php ---
$host = "localhost"; $user = "root"; $pass = ""; $db = "inventory_app";
$connect = new mysqli($host, $user, $pass, $db);

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// Ambil data transaksi JOIN dengan tabel barang biar tau nama barangnya
$sql = "SELECT t.*, i.name as item_name, i.sku 
        FROM transactions t 
        JOIN items i ON t.item_id = i.id 
        ORDER BY t.date DESC";

$result = $connect->query($sql);

$history = [];
while ($row = $result->fetch_assoc()) {
    $history[] = $row;
}

echo json_encode([
    "success" => true,
    "data" => $history
]);
?>