import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = kIsWeb
      ? 'http://localhost/inventory_api/api'
      : 'http://10.0.2.2/inventory_api/api';

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login.php'),
      body: {
        'email': email,
        'password': password,
      },
    );

    // 🔥 PROTEKSI ERROR
    try {
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Response bukan JSON:\n${response.body}');
    }
  }

  static Future<void> saveUserData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(data));
  }
}
