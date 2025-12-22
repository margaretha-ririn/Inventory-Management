<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

// Koneksi ke Database
$connect = new mysqli("localhost", "root", "", "inventory_app");

// Cek Koneksi
if ($connect->connect_error) {
    die(json_encode(["success" => false, "message" => "Gagal konek database"]));
}

// Ambil Data dari Flutter
$id = $_POST['id'] ?? '';
$stock = $_POST['stock'] ?? '0';
$price = $_POST['price'] ?? '0';

if (empty($id)) {
    echo json_encode(["success" => false, "message" => "ID tidak boleh kosong"]);
    exit;
}

// Update Data
$sql = "UPDATE items SET stock = '$stock', price = '$price' WHERE id = $id";

if ($connect->query($sql)) {
    echo json_encode(["success" => true, "message" => "Update Berhasil"]);
} else {
    echo json_encode(["success" => false, "message" => "Gagal: " . $connect->error]);
}
?>