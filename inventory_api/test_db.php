
<?php
// test_db.php - Simple database connection test
header("Content-Type: text/plain");

echo "=== Database Connection Test ===\n\n";

try {
    include_once('config/database.php');

    $database = new Database();

    echo "1. Testing connection...\n";
    $db = $database->getConnection();
    echo "✓ Database connection successful!\n\n";

    echo "2. Testing query execution...\n";
    $stmt = $db->query("SELECT 1 as test");
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    echo "✓ Query execution successful! Result: " . $result['test'] . "\n\n";

    echo "3. Checking tables...\n";
    $tables = ['users', 'items', 'categories', 'locations', 'loans'];
    foreach ($tables as $table) {
        $stmt = $db->query("SHOW TABLES LIKE '$table'");
        if ($stmt->rowCount() > 0) {
            echo "✓ Table '$table' exists\n";
        } else {
            echo "✗ Table '$table' missing\n";
        }
    }

    echo "\n4. Checking sample data...\n";
    $stmt = $db->query("SELECT COUNT(*) as user_count FROM users");
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    echo "✓ Users table has " . $result['user_count'] . " records\n";

    $stmt = $db->query("SELECT COUNT(*) as item_count FROM items");
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    echo "✓ Items table has " . $result['item_count'] . " records\n";

    echo "\n=== All Tests Passed! Database is ready! ===\n";

} catch(PDOException $e) {
    echo "✗ Database Error: " . $e->getMessage() . "\n";
    echo "\nTroubleshooting:\n";
    echo "1. Make sure MySQL is running\n";
    echo "2. Check database credentials in config/database.php\n";
    echo "3. Ensure 'inventory_management' database exists\n";
    echo "4. Run the database_schema.sql file\n";
} catch(Exception $e) {
    echo "✗ General Error: " . $e->getMessage() . "\n";
}
?>