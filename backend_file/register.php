<?php
// --- FILE: register.php ---

// 1. Koneksi Database
$host = "localhost";
$user = "root";
$pass = "";
$db   = "inventory_app";

$connect = new mysqli($host, $user, $pass, $db);

// Header wajib biar Flutter bisa baca JSON
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// 2. Terima Data dari Flutter
$username = $_POST['username'] ?? '';
$email    = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';
$fullName = $_POST['full_name'] ?? '';

// 3. Validasi: Gak boleh ada yang kosong
if (empty($username) || empty($email) || empty($password) || empty($fullName)) {
    echo json_encode(["success" => false, "message" => "Semua kolom wajib diisi!"]);
    exit();
}

// 4. Cek Duplikat: Apakah username/email sudah dipakai?
$check = $connect->query("SELECT * FROM users WHERE username = '$username' OR email = '$email'");

if ($check->num_rows > 0) {
    echo json_encode(["success" => false, "message" => "Email atau Username sudah terdaftar!"]);
} else {
    // 5. Simpan Data Baru (Password di-MD5)
    $sql = "INSERT INTO users (username, email, password, full_name) 
            VALUES ('$username', '$email', MD5('$password'), '$fullName')";
    
    if ($connect->query($sql)) {
        echo json_encode(["success" => true, "message" => "Registrasi Berhasil! Silakan Login."]);
    } else {
        echo json_encode(["success" => false, "message" => "Gagal mendaftar: " . $connect->error]);
    }
}
?>