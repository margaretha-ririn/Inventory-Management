// api/loans/read.php
<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

// Get optional status filter
$status = isset($_GET['status']) ? $_GET['status'] : null;
$borrower_id = isset($_GET['borrower_id']) ? $_GET['borrower_id'] : null;

$query = "SELECT 
            ln.loan_id, ln.loan_date, ln.due_date, ln.return_date, ln.quantity,
            ln.status, ln.condition_borrowed, ln.condition_returned, ln.notes,
            i.item_id, i.item_name, i.barcode, i.image_url,
            u.user_id as borrower_id, u.full_name as borrower_name, u.nim,
            DATEDIFF(ln.due_date, NOW()) as days_remaining
          FROM loans ln
          JOIN items i ON ln.item_id = i.item_id
          JOIN users u ON ln.borrower_id = u.user_id";

$conditions = [];
$params = [];

if ($status) {
    $conditions[] = "ln.status = :status";
    $params[':status'] = $status;
}

if ($borrower_id) {
    $conditions[] = "ln.borrower_id = :borrower_id";
    $params[':borrower_id'] = $borrower_id;
}

if (!empty($conditions)) {
    $query .= " WHERE " . implode(" AND ", $conditions);
}

$query .= " ORDER BY ln.loan_date DESC";

$stmt = $db->prepare($query);

foreach ($params as $key => $value) {
    $stmt->bindValue($key, $value);
}

$stmt->execute();

$loans = $stmt->fetchAll(PDO::FETCH_ASSOC);

http_response_code(200);
echo json_encode([
    "success" => true,
    "count" => count($loans),
    "data" => $loans
]);
?>
