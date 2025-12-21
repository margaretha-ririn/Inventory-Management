<?php
// --- FILE: add_item.php ---
$host = "localhost"; $user = "root"; $pass = ""; $db = "inventory_app";
$connect = new mysqli($host, $user, $pass, $db);

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$name = $_POST['name'] ?? '';
$sku  = $_POST['sku'] ?? '';
$stock = $_POST['stock'] ?? 0;
$desc = $_POST['description'] ?? '';
$loc  = $_POST['location'] ?? 'Gudang Utama';

// Validasi Sederhana
if (empty($name) || empty($sku)) {
    echo json_encode(["success" => false, "message" => "Nama dan SKU wajib diisi"]);
    exit();
}

// Cek apakah SKU sudah ada
$check = $connect->query("SELECT id FROM items WHERE sku = '$sku'");
if ($check->num_rows > 0) {
    echo json_encode(["success" => false, "message" => "SKU sudah digunakan barang lain!"]);
    exit();
}

// Simpan ke Database (Default harga 0 dulu karena di UI gak ada input harga)
$sql = "INSERT INTO items (name, sku, stock, price, description, category_id, created_at) 
        VALUES ('$name', '$sku', $stock, 0, '$desc', 1, NOW())";

if ($connect->query($sql)) {
    echo json_encode(["success" => true, "message" => "Barang berhasil ditambahkan!"]);
} else {
    echo json_encode(["success" => false, "message" => "Gagal simpan: " . $connect->error]);
}
?>