class ApiConfig {
  // Use 10.0.2.2 for Android Emulator, 127.0.0.1 for Chrome/Web
  // static const String baseUrl = 'http://10.0.2.2/inventory_api/api'; 
  static const String baseUrl = 'http://127.0.0.1/inventory_api/api';
  
  // Auth Endpoints
  static const String login = '$baseUrl/auth/login.php';
  static const String register = '$baseUrl/auth/register.php';
  
  // Inventory Endpoints
  static const String itemsRead = '$baseUrl/items/read.php';
  static const String itemsCreate = '$baseUrl/items/create.php';
  static const String itemsUpdate = '$baseUrl/items/update.php';
  static const String itemsDelete = '$baseUrl/items/delete.php';
}
