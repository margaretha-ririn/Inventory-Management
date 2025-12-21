<?php
// --- FILE: analytics.php ---
$host = "localhost"; $user = "root"; $pass = ""; $db = "inventory_app";
$connect = new mysqli($host, $user, $pass, $db);

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// 1. STATISTIK UTAMA
$q1 = $connect->query("SELECT SUM(price * stock) as total_asset FROM items");
$row1 = $q1->fetch_assoc();
$total_asset = $row1['total_asset'] ?? 0;

$q2 = $connect->query("SELECT COUNT(*) as low_stock FROM items WHERE stock <= 5");
$row2 = $q2->fetch_assoc();
$low_stock = $row2['low_stock'] ?? 0;

$q3 = $connect->query("SELECT COUNT(*) as total_items FROM items");
$row3 = $q3->fetch_assoc();
$total_items = $row3['total_items'] ?? 0;

$q4 = $connect->query("SELECT COUNT(*) as out_of_stock FROM items WHERE stock = 0");
$row4 = $q4->fetch_assoc();
$out_of_stock = $row4['out_of_stock'] ?? 0;

// 2. PRODUK TERLARIS (Top 3 dari Transaksi Keluar)
$qTop = $connect->query("
    SELECT i.name, SUM(t.quantity) as sold, c.name as category
    FROM transactions t
    JOIN items i ON t.item_id = i.id
    LEFT JOIN categories c ON i.category_id = c.id
    WHERE t.type = 'out'
    GROUP BY t.item_id
    ORDER BY sold DESC
    LIMIT 3
");

$top_products = [];
while ($row = $qTop->fetch_assoc()) {
    $top_products[] = $row;
}

// 3. LOW STOCK LIST (Untuk 'Perlu Perhatian')
$qLow = $connect->query("SELECT name, stock FROM items WHERE stock <= 5 LIMIT 3");
$low_stock_list = [];
while ($row = $qLow->fetch_assoc()) {
    $low_stock_list[] = $row;
}

echo json_encode([
    "success" => true,
    "stats" => [
        "total_asset" => $total_asset,
        "low_stock" => $low_stock,
        "total_items" => $total_items,
        "out_of_stock" => $out_of_stock
    ],
    "top_products" => $top_products,
    "low_stock_list" => $low_stock_list
]);
?>