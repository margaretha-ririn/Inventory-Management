// config/database.php
<?php
class Database {
    public function connect() {
        return null; // sementara
    }
}

class Database {
    private $host = "localhost";
    private $db_name = "inventory_management";
    private $username = "root";  // sesuaikan dengan konfigurasi server
    private $password = "";      // sesuaikan dengan konfigurasi server (kosong jika default XAMPP)
    private $charset = "utf8mb4";
    public $conn;

    public function getConnection() {
        $this->conn = null;

        try {
            // Build DSN with charset
            $dsn = "mysql:host=" . $this->host .
                   ";dbname=" . $this->db_name .
                   ";charset=" . $this->charset;

            $this->conn = new PDO($dsn, $this->username, $this->password);

            // Set PDO attributes for better security and performance
            $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            $this->conn->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
            $this->conn->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
            $this->conn->setAttribute(PDO::ATTR_STRINGIFY_FETCHES, false);

            // Set timezone to UTC for consistency
            $this->conn->exec("SET time_zone = '+00:00'");
            $this->conn->exec("SET sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE'");

        } catch(PDOException $exception) {
            // Log error instead of echoing in production
            error_log("Database connection error: " . $exception->getMessage());

            // Return error response for API
            http_response_code(500);
            echo json_encode([
                "success" => false,
                "message" => "Database connection failed",
                "error" => "Internal server error"
            ]);
            exit();
        }

        return $this->conn;
    }

    // Method to test database connection
    public function testConnection() {
        try {
            $this->getConnection();
            $this->conn->query('SELECT 1');
            return true;
        } catch(PDOException $e) {
            return false;
        }
    }

    // Method to close connection
    public function closeConnection() {
        $this->conn = null;
    }
}
