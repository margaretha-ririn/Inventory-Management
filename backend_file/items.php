<?php
// Matikan error HTML biar Flutter gak crash
error_reporting(0);

$host = "localhost"; 
$user = "root"; 
$pass = ""; 
$db   = "inventory_app"; // Pastikan nama DB bener

$connect = new mysqli($host, $user, $pass, $db);

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// Cek Koneksi
if ($connect->connect_error) {
    echo json_encode([
        "success" => false, 
        "message" => "Koneksi DB Gagal: " . $connect->connect_error
    ]);
    exit();
}

// Ambil data
$sql = "SELECT * FROM items ORDER BY id DESC"; // Ganti created_at jadi id kalau kolom created_at belum ada
$result = $connect->query($sql);

if (!$result) {
    echo json_encode([
        "success" => false, 
        "message" => "Query Error: " . $connect->error
    ]);
    exit();
}

$items = [];
while ($row = $result->fetch_assoc()) {
    $items[] = $row;
}

echo json_encode([
    "success" => true,
    "data" => $items
]);
?>