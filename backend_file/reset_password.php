<?php
// Koneksi Database (Langsung disini biar anti-ribet)
$host = "localhost";
$user = "root";
$pass = "";
$db   = "inventory_app";

$connect = new mysqli($host, $user, $pass, $db);

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$email       = $_POST['email'] ?? '';
$newPassword = $_POST['new_password'] ?? '';

if (empty($email) || empty($newPassword)) {
    echo json_encode(["success" => false, "message" => "Email dan Password Baru wajib diisi"]);
    exit();
}

// 1. Cek dulu apakah email ada?
$checkEmail = $connect->query("SELECT * FROM users WHERE email = '$email'");

if ($checkEmail->num_rows > 0) {
    // 2. Kalau ada, Update Passwordnya
    $update = $connect->query("UPDATE users SET password = MD5('$newPassword') WHERE email = '$email'");
    
    if ($update) {
        echo json_encode(["success" => true, "message" => "Password berhasil diubah! Silakan login."]);
    } else {
        echo json_encode(["success" => false, "message" => "Gagal update database."]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Email tidak ditemukan!"]);
}
?>