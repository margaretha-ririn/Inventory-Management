import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/user_model.dart';

class AuthService {
  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      try {
        final data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['success'] == true) {
          await _saveUserSession(data['user']);
          return {'success': true, 'message': data['message'], 'user': data['user']};
        } else {
          return {'success': false, 'message': data['message'] ?? 'Login failed'};
        }
      } catch (e) {
        print('JSON Parse Error Login: $e');
        print('Raw Response: ${response.body}');
        return {'success': false, 'message': 'Server Error (Invalid JSON)'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // Register
  Future<Map<String, dynamic>> register(String fullName, String email, String password, {String? nim, String? programStudi}) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'full_name': fullName,
          'email': email,
          'password': password,
          'nim': nim,
          'program_studi': programStudi,
        }),
      ).timeout(const Duration(seconds: 10));

      try {
        final data = jsonDecode(response.body);
        if (response.statusCode == 201 && data['success'] == true) {
          return {'success': true, 'message': data['message']};
        } else {
          return {'success': false, 'message': data['message'] ?? 'Registration failed'};
        }
      } catch (e) {
        print('JSON Parse Error Register: $e');
        print('Raw Response: ${response.body}');
        return {'success': false, 'message': 'Server Error (Invalid JSON)'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // Save User Session
  Future<void> _saveUserSession(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('user', jsonEncode(user));
  }

  // Get Current User
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('user')) return null;
    
    final userStr = prefs.getString('user');
    if (userStr != null) {
      return UserModel.fromJson(jsonDecode(userStr));
    }
    return null;
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Check if logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
