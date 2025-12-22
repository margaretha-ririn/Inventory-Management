<?php
include 'conn.php'; // Pastikan punya file conn.php atau copy koneksi manual kayak sebelumnya

// Koneksi Manual (jaga-jaga)
$host = "localhost"; $user = "root"; $pass = ""; $db = "inventory_app";
$connect = new mysqli($host, $user, $pass, $db);

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// 1. Hitung Total Aset (Sum of Price * Stock)
$qAset = $connect->query("SELECT SUM(price * stock) as total_asset FROM items");
$dAset = $qAset->fetch_assoc();

// 2. Hitung Jumlah Barang & Kategori
$qItems = $connect->query("SELECT SUM(stock) as total_items FROM items");
$dItems = $qItems->fetch_assoc();

$qCat = $connect->query("SELECT COUNT(*) as total_cat FROM categories");
$dCat = $qCat->fetch_assoc();

// 3. Ambil Barang Stok Habis (Untuk bagian 'Perlu Perhatian')
$qLow = $connect->query("SELECT name, sku, stock, category_id FROM items WHERE stock <= 5");
$lowStock = [];
while ($row = $qLow->fetch_assoc()) {
    $lowStock[] = $row;
}

// 4. Ambil Aktivitas Terbaru (Join dengan nama barang)
$qAct = $connect->query("SELECT t.*, i.name as item_name 
                         FROM transactions t 
                         JOIN items i ON t.item_id = i.id 
                         ORDER BY t.date DESC LIMIT 5");
$activities = [];
while ($row = $qAct->fetch_assoc()) {
    $activities[] = $row;
}

// Kirim semua data dalam 1 paket JSON
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