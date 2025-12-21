<?php
// --- FILE: C:\xampp\htdocs\inventory_api\dashboard.php ---

$host = "localhost"; $user = "root"; $pass = ""; $db = "inventory_app";
$connect = new mysqli($host, $user, $pass, $db);

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// 1. Total Aset
$qAset = $connect->query("SELECT SUM(price * stock) as total_asset FROM items");
$dAset = $qAset->fetch_assoc();

// 2. Statistik
$qItems = $connect->query("SELECT SUM(stock) as total_items FROM items");
$dItems = $qItems->fetch_assoc();

$qCat = $connect->query("SELECT COUNT(*) as total_cat FROM categories");
$dCat = $qCat->fetch_assoc();

// 3. LOW STOCK (PENTING: Kita tambah 'id' disini)
$qLow = $connect->query("SELECT id, name, sku, stock, category_id FROM items WHERE stock <= 5");
$lowStock = [];
while ($row = $qLow->fetch_assoc()) {
    $lowStock[] = $row;
}

// 4. Aktivitas
$qAct = $connect->query("SELECT t.*, i.name as item_name FROM transactions t JOIN items i ON t.item_id = i.id ORDER BY t.date DESC LIMIT 5");
$activities = [];
while ($row = $qAct->fetch_assoc()) {
    $activities[] = $row;
}

echo json_encode([
    "success" => true,
    "stats" => [
        "total_asset" => $dAset['total_asset'] ?? 0,
        "total_items" => $dItems['total_items'] ?? 0,
        "total_cat"   => $dCat['total_cat'] ?? 0
    ],
    "low_stock" => $lowStock,
    "recent_activity" => $activities
]);
?>