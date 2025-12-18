// api/search/items.php
<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// ================= SECRET KEY =================
define('SECRET_KEY', 'your_secret_key_change_this_in_production');

// ================= VERIFY TOKEN =================
function verifyToken($token, $db) {
    $decoded = base64_decode($token);
    $parts = explode(':', $decoded);

    if (count($parts) !== 3) {
        return false;
    }

    $userId = $parts[0];
    $timestamp = $parts[1];
    $signature = $parts[2];

    $payload = $userId . ':' . $timestamp;
    $expectedSignature = hash_hmac('sha256', $payload, SECRET_KEY);

    if (!hash_equals($signature, $expectedSignature)) {
        return false;
    }

    // Check if token is not expired (24 hours)
    if (time() - $timestamp > 86400) {
        return false;
    }

    // Check if user exists and is active
    $query = "SELECT user_id FROM users WHERE user_id = :user_id AND is_active = 1";
    $stmt = $db->prepare($query);
    $stmt->bindParam(":user_id", $userId);
    $stmt->execute();

    if ($stmt->rowCount() === 0) {
        return false;
    }

    return $userId; // Return user_id if valid
}

// ================= AUTHENTICATION =================
function getAuthUser($db) {
    $headers = getallheaders();

    if (!isset($headers['Authorization'])) {
        http_response_code(401);
        echo json_encode(["success" => false, "message" => "Authorization header required"]);
        exit();
    }

    $authHeader = $headers['Authorization'];
    if (!preg_match('/Bearer\s+(.*)$/i', $authHeader, $matches)) {
        http_response_code(401);
        echo json_encode(["success" => false, "message" => "Invalid authorization format"]);
        exit();
    }

    $token = $matches[1];
    $userId = verifyToken($token, $db);

    if (!$userId) {
        http_response_code(401);
        echo json_encode(["success" => false, "message" => "Invalid or expired token"]);
        exit();
    }

    return $userId;
}

// ================= INPUT VALIDATION =================
function validateSearchQuery($query) {
    // Trim whitespace
    $query = trim($query);

    // Check if empty after trimming
    if (empty($query)) {
        return false;
    }

    // Check minimum length
    if (strlen($query) < 2) {
        return false;
    }

    // Check maximum length to prevent abuse
    if (strlen($query) > 100) {
        return false;
    }

    // Basic sanitization - remove potentially harmful characters
    $query = filter_var($query, FILTER_SANITIZE_STRING, FILTER_FLAG_NO_ENCODE_QUOTES);

    return $query;
}

include_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

// Verify token
$userId = getAuthUser($db);

// Get and validate search query
$search = isset($_GET['q']) ? $_GET['q'] : '';

$validatedSearch = validateSearchQuery($search);
if (!$validatedSearch) {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Search query must be 2-100 characters long"
    ]);
    exit();
}

try {
    $query = "SELECT
                i.item_id, i.barcode, i.item_name, i.description,
                i.quantity, i.min_stock, i.condition_status, i.image_url,
                c.category_name,
                l.location_name
              FROM items i
              LEFT JOIN categories c ON i.category_id = c.category_id
              LEFT JOIN locations l ON i.location_id = l.location_id
              WHERE i.is_active = 1
              AND (
                  i.item_name LIKE :search
                  OR i.barcode LIKE :search
                  OR i.sku LIKE :search
                  OR i.description LIKE :search
                  OR c.category_name LIKE :search
              )
              ORDER BY i.item_name ASC
              LIMIT 50";

    $stmt = $db->prepare($query);
    $search_param = '%' . $validatedSearch . '%';
    $stmt->bindParam(":search", $search_param);
    $stmt->execute();

    $results = $stmt->fetchAll(PDO::FETCH_ASSOC);

    http_response_code(200);
    echo json_encode([
        "success" => true,
        "count" => count($results),
        "data" => $results
    ]);

} catch(PDOException $e) {
    error_log("Search items error: " . $e->getMessage());
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => "Search failed",
        "error" => "Internal server error"
    ]);
}
?>