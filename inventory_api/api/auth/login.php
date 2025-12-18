<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

// FIX PATH
require_once __DIR__ . '/../config/database.php';

$email = $_POST['email'] ?? '';
$password = $_POST['password'] ?? '';

if ($email === '' || $password === '') {
    echo json_encode([
        "success" => false,
        "message" => "Email dan password wajib diisi"
    ]);
    exit;
}

// ====== LOGIN DUMMY (AMAN UNTUK TEST) ======
if ($email === "ririn@gmail.com" && $password === "123456") {
    echo json_encode([
        "success" => true,
        "data" => [
            "id" => 1,
            "full_name" => "Ririn",
            "email" => $email
        ]
    ]);
    exit;
}

echo json_encode([
    "success" => false,
    "message" => "Email atau password salah"
]);
