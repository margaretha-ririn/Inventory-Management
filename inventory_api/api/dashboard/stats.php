<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

// Total items and value
$query1 = "SELECT 
            COUNT(*) as total_items,
            SUM(quantity) as total_quantity,
            SUM(total_value) as total_value
           FROM items WHERE is_active = 1";
$stmt1 = $db->prepare($query1);
$stmt1->execute();
$stats = $stmt1->fetch(PDO::FETCH_ASSOC);

// Low stock items
$query2 = "SELECT COUNT(*) as low_stock_count 
           FROM items WHERE quantity <= min_stock AND is_active = 1";
$stmt2 = $db->prepare($query2);
$stmt2->execute();
$low_stock = $stmt2->fetch(PDO::FETCH_ASSOC);

// Active loans
$query3 = "SELECT COUNT(*) as active_loans 
           FROM loans WHERE status IN ('active', 'overdue')";
$stmt3 = $db->prepare($query3);
$stmt3->execute();
$loans = $stmt3->fetch(PDO::FETCH_ASSOC);

// Category distribution
$query4 = "SELECT c.category_name, COUNT(i.item_id) as count
           FROM categories c
           LEFT JOIN items i ON c.category_id = i.category_id AND i.is_active = 1
           GROUP BY c.category_id
           ORDER BY count DESC";
$stmt4 = $db->prepare($query4);
$stmt4->execute();
$categories = $stmt4->fetchAll(PDO::FETCH_ASSOC);

// Recent activities
$query5 = "SELECT 
            sm.movement_id, sm.movement_type, sm.quantity, sm.movement_date,
            i.item_name, u.full_name as performed_by
           FROM stock_movements sm
           JOIN items i ON sm.item_id = i.item_id
           JOIN users u ON sm.performed_by = u.user_id
           ORDER BY sm.movement_date DESC
           LIMIT 10";
$stmt5 = $db->prepare($query5);
$stmt5->execute();
$activities = $stmt5->fetchAll(PDO::FETCH_ASSOC);

http_response_code(200);
echo json_encode([
    "success" => true,
    "data" => [
        "total_items" => (int)$stats['total_items'],
        "total_quantity" => (int)$stats['total_quantity'],
        "total_value" => (float)$stats['total_value'],
        "low_stock_count" => (int)$low_stock['low_stock_count'],
        "active_loans" => (int)$loans['active_loans'],
        "category_distribution" => $categories,
        "recent_activities" => $activities
    ]
]);
?>