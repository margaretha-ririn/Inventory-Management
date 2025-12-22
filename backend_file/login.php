<?php
// --- BAGIAN KONEKSI DATABASE (LANGSUNG DISINI AJA) ---
$host = "localhost";
$user = "root";
$pass = "";
$db   = "inventory_app";

// Kita bikin variabel koneksi namanya $connect
$connect = new mysqli($host, $user, $pass, $db);

if ($connect->connect_error) {
    die(json_encode([
        "success" => false,
        "message" => "Database Error: " . $connect->connect_error
    ]));
}
// -----------------------------------------------------

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// Menerima input
$emailOrUsername = $_POST['username'] ?? ''; // Pake '??' biar gak error kalau kosong
$password        = $_POST['password'] ?? '';

// Cek jika input kosong
if (empty($emailOrUsername) || empty($password)) {
    echo json_encode([
        "success" => false,
        "message" => "Username atau Password tidak boleh kosong"
    ]);
    exit();
}

// Cek User & Password
$sql = "SELECT * FROM users 
        WHERE (email = '$emailOrUsername' OR username = '$emailOrUsername') 
        AND password = MD5('$password')";

$result = $connect->query($sql);

if ($result && $result->num_rows > 0) {
    $user = $result->fetch_assoc();
    echo json_encode([
        "success" => true,
        "message" => "Login Berhasil",
        "data"    => $user
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Username/Email atau Password salah"
    ]);
}
?>