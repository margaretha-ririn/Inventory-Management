import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/inventory_model.dart';

class InventoryService {
  // Get all items
  Future<List<InventoryModel>> getItems() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.itemsRead));

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          if (data['success'] == true) {
            final List<dynamic> itemsJson = data['data'];
            return itemsJson.map((json) => InventoryModel.fromJson(json)).toList();
          }
        } catch (e) {
          print('JSON Parse Error in getItems: $e');
          print('Raw Response: ${response.body}');
        }
      } else {
         print('HTTP Error getItems: ${response.statusCode}');
         print('Raw Response: ${response.body}');
      }
      return [];
    } catch (e) {
      print('Error fetching items: $e');
      return [];
    }
  }

  // Add Item
  Future<bool> addItem(InventoryModel item, int userId) async {
    try {
      print('=== ADD ITEM REQUEST ===');
      print('URL: ${ApiConfig.itemsCreate}');
      
      final requestBody = {
        'item_name': item.itemName,
        'description': item.description,
        'quantity': item.quantity,
        'category_id': 1,
        'location_id': 1,
        'min_stock': item.minStock,
        'unit_price': item.unitPrice,
        'condition_status': item.conditionStatus ?? 'good',
        'image_url': item.imageUrl,
        'sku': 'SKU-${DateTime.now().millisecondsSinceEpoch}',
        'created_by': userId
      };
      
      print('Request Body: ${jsonEncode(requestBody)}');
      
      final response = await http.post(
        Uri.parse(ApiConfig.itemsCreate),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else {
        print('ERROR: HTTP ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('EXCEPTION adding item: $e');
      return false;
    }
  }

  // Delete Item
  Future<bool> deleteItem(int itemId) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.itemsDelete),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'item_id': itemId}), // Check backend if it expects POST body or ID param
      );

      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      print('Error deleting item: $e');
      return false;
    }
  }
}
