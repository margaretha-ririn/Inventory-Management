<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: *");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

require_once __DIR__ . '/../../config/database.php';

// ================= READ INPUT DATA =================
// Handle both JSON and form data
$contentType = isset($_SERVER["CONTENT_TYPE"]) ? trim($_SERVER["CONTENT_TYPE"]) : '';

if (strpos($contentType, 'application/json') !== false) {
    // JSON input
    $input = json_decode(file_get_contents("php://input"), true);
    $email = $input['email'] ?? '';
    $password = $input['password'] ?? '';
} else {
    // Form data input
    $email = $_POST['email'] ?? '';
    $password = $_POST['password'] ?? '';
}

if ($email === '' || $password === '') {
    echo json_encode([
        "success" => false,
        "message" => "Email dan password wajib diisi"
    ]);
    exit;
}

try {
    $database = new Database();
    $db = $database->getConnection();

    $sql = "SELECT user_id, email, full_name, password_hash, role, nim, program_studi
            FROM users
            WHERE email = :email
            AND is_active = 1
            LIMIT 1";

    $stmt = $db->prepare($sql);
    $stmt->bindParam(":email", $email);
    $stmt->execute();

    if ($stmt->rowCount() === 0) {
        echo json_encode([
            "success" => false,
            "message" => "Email tidak ditemukan"
        ]);
        exit;
    }

    $user = $stmt->fetch();

    if (!password_verify($password, $user['password_hash'])) {
        echo json_encode([
            "success" => false,
            "message" => "Password salah"
        ]);
        exit;
    }

    echo json_encode([
        "success" => true,
        "message" => "Login berhasil",
        "user" => [
            "user_id" => $user['user_id'],
            "username" => $user['email'], // Use email as username since column is missing
            "email" => $user['email'],
            "full_name" => $user['full_name'],
            "role" => $user['role'],
            "nim" => $user['nim'],
            "program_studi" => $user['program_studi']
        ]
    ]);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => "Terjadi kesalahan sistem: " . $e->getMessage()
    ]);
}
