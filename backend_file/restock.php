<?php
// --- FILE: restock.php ---
$host = "localhost"; $user = "root"; $pass = ""; $db = "inventory_app";
$connect = new mysqli($host, $user, $pass, $db);

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$id  = $_POST['id'] ?? '';
$qty = $_POST['quantity'] ?? 0;

if (empty($id) || empty($qty) || $qty <= 0) {
    echo json_encode(["success" => false, "message" => "Data tidak valid"]);
    exit();
}

// 1. Update Stok Barang
$sql = "UPDATE items SET stock = stock + $qty WHERE id = $id";
if ($connect->query($sql)) {
    
    // 2. Catat Riwayat Transaksi (IN)
    $connect->query("INSERT INTO transactions (item_id, type, quantity, date) VALUES ($id, 'in', $qty, NOW())");

    echo json_encode(["success" => true, "message" => "Stok berhasil ditambahkan!"]);
} else {
    echo json_encode(["success" => false, "message" => "Gagal update: " . $connect->error]);
}
?>