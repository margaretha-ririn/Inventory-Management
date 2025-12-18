<?php
// test_login.php - Test login API
header("Content-Type: application/json");

echo "=== Testing Login API ===\n\n";

// Test data
$testData = [
    'email' => 'admin@inventory.com',
    'password' => 'admin123'
];

// Simulate POST request
$_POST = $testData;

// Include login script
ob_start();
include('api/auth/login.php');
$result = ob_get_clean();

echo "Request Data:\n";
echo json_encode($testData, JSON_PRETTY_PRINT) . "\n\n";

echo "Response:\n";
echo $result . "\n\n";

// Try to decode response
$responseData = json_decode($result, true);
if ($responseData && isset($responseData['success'])) {
    if ($responseData['success']) {
        echo "✅ Login berhasil!\n";
        echo "Token: " . ($responseData['token'] ?? 'N/A') . "\n";
        echo "User: " . ($responseData['data']['full_name'] ?? $responseData['data']['username']) . "\n";
    } else {
        echo "❌ Login gagal: " . ($responseData['message'] ?? 'Unknown error') . "\n";
    }
} else {
    echo "❌ Invalid JSON response\n";
}
?>