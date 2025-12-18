<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: *");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

include_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

$data = json_decode(file_get_contents("php://input"));

if (!empty($data->full_name) && !empty($data->email) && !empty($data->password)) {
    // Check if email already exists
    $check_query = "SELECT user_id FROM users WHERE email = :email";
    $check_stmt = $db->prepare($check_query);
    $check_stmt->bindParam(":email", $data->email);
    $check_stmt->execute();
    
    if ($check_stmt->rowCount() > 0) {
        http_response_code(409);
        echo json_encode([
            "success" => false,
            "message" => "Email already exists"
        ]);
        exit();
    }
    
    $query = "INSERT INTO users (full_name, email, password_hash, nim, program_studi) 
              VALUES (:full_name, :email, :password_hash, :nim, :program_studi)";
    
    $stmt = $db->prepare($query);
    
    $stmt->bindParam(":full_name", $data->full_name);
    $stmt->bindParam(":email", $data->email);
    $password_hash = password_hash($data->password, PASSWORD_BCRYPT);
    $stmt->bindParam(":password_hash", $password_hash);
    $nim = isset($data->nim) ? $data->nim : null;
    $stmt->bindParam(":nim", $nim);
    $program_studi = isset($data->program_studi) ? $data->program_studi : null;
    $stmt->bindParam(":program_studi", $program_studi);
    
    if ($stmt->execute()) {
        http_response_code(201);
        echo json_encode([
            "success" => true,
            "message" => "User registered successfully",
            "user_id" => $db->lastInsertId()
        ]);
    } else {
        http_response_code(500);
        echo json_encode([
            "success" => false,
            "message" => "Unable to register user"
        ]);
    }
} else {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Full name, email, and password required"
    ]);
}
?>