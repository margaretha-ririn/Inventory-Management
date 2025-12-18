<?php
// Test create item endpoint
$url = "http://localhost/inventory_api/api/items/create.php";

$data = [
    'item_name' => 'Test Item ' . time(),
    'description' => 'Test description',
    'category_id' => 1,
    'location_id' => 1,
    'quantity' => 10,
    'min_stock' => 5,
    'unit_price' => 50000,
    'condition_status' => 'good',
    'sku' => 'TEST-' . time(),
    'created_by' => 1
];

$ch = curl_init($url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

echo "HTTP Code: $httpCode\n";
echo "Response:\n";
echo $response;
echo "\n";
?>
