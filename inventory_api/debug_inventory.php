<?php
header("Content-Type: text/plain");
require_once 'config/database.php';

echo "=== Inventory Diagnostics ===\n";

$database = new Database();
$db = $database->getConnection();

// 1. Check Categories and Locations
echo "\n[Checking Foreign Keys]\n";
$stmt = $db->query("SELECT COUNT(*) as count FROM categories");
$cats = $stmt->fetch()['count'];
echo "Categories count: $cats\n";

$stmt = $db->query("SELECT COUNT(*) as count FROM locations");
$locs = $stmt->fetch()['count'];
echo "Locations count: $locs\n";

if ($cats == 0 || $locs == 0) {
    echo "WARNING: Categories or Locations are empty. Insert will fail.\n";
}

// 2. Check Items Table Columns
echo "\n[Checking Items Table Columns]\n";
$stmt = $db->query("DESCRIBE items");
$columns = $stmt->fetchAll(PDO::FETCH_COLUMN);
print_r($columns);

if (!in_array('created_by', $columns)) {
    echo "Note: 'created_by' column is MISSING (as expected from schema).\n";
} else {
    echo "Note: 'created_by' column EXISTS.\n";
}

// 3. Test Insert
echo "\n[Testing Insert]\n";
$query = "INSERT INTO items 
          (item_name, description, category_id, location_id, quantity, min_stock, unit_price, condition_status, sku)
          VALUES 
          (:item_name, :description, 1, 1, 10, 5, 1000, 'good', :sku)";

try {
    $stmt = $db->prepare($query);
    $name = "Test Item " . time();
    $desc = "Test Description";
    $sku = "TEST-SKU-" . time();
    
    $stmt->bindParam(":item_name", $name);
    $stmt->bindParam(":description", $desc);
    $stmt->bindParam(":sku", $sku);
    
    if ($stmt->execute()) {
        echo "SUCCESS: Test insert worked! New ID: " . $db->lastInsertId() . "\n";
        // Clean up
        $db->query("DELETE FROM items WHERE item_id = " . $db->lastInsertId());
    } else {
        echo "FAILED: Execute returned false.\n";
        print_r($stmt->errorInfo());
    }
} catch (Exception $e) {
    echo "EXCEPTION: " . $e->getMessage() . "\n";
}
?>
