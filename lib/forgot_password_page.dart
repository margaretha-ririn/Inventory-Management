import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isObscure = true;

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    // URL Backend (Sesuaikan IP jika perlu)
    String url = "http://127.0.0.1/inventory_api/reset_password.php";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'email': _emailController.text,
          'new_password': _newPasswordController.text,
        },
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (data['success'] == true) {
        // Jika Berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(data['message']),
          ),
        );
        Navigator.pop(context); // Kembali ke halaman Login
      } else {
        // Jika Gagal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(data['message'])),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Gagal konek ke server.")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Definisi Warna (KONSISTEN dengan Login Page)
    const Color bgMain = Color(0xFF0F161C);
    const Color bgInput = Color(0xFF192229);
    const Color borderInput = Color(0xFF2A353E);
    const Color accentBlue = Color(0xFF0ABDF8);
    const Color textWhite = Colors.white;
    const Color textGrey = Color(0xFF8B959E);

    return Scaffold(
      backgroundColor: bgMain,
      appBar: AppBar(
        backgroundColor: bgMain,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: textWhite),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Icon Kunci Besar
              Center(
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: bgInput,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_reset,
                    size: 50,
                    color: accentBlue,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                "Reset Password",
                style: TextStyle(
                  color: textWhite,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Enter your email and new password to reset access to your account.",
                style: TextStyle(color: textGrey, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 40),

              // Input Email
              const Text(
                "Registered Email",
                style: TextStyle(color: textWhite, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: textWhite),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: bgInput,
                  hintText: "admin@inventory.com",
                  hintStyle: const TextStyle(color: textGrey),
                  prefixIcon: const Icon(Icons.email_outlined, color: textGrey),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: borderInput),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: accentBlue),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Input New Password
              const Text(
                "New Password",
                style: TextStyle(color: textWhite, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _newPasswordController,
                obscureText: _isObscure,
                style: const TextStyle(color: textWhite),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: bgInput,
                  hintText: "Create new password",
                  hintStyle: const TextStyle(color: textGrey),
                  prefixIcon: const Icon(Icons.lock_outline, color: textGrey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      color: textGrey,
                    ),
                    onPressed: () => setState(() => _isObscure = !_isObscure),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: borderInput),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: accentBlue),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Button Reset
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Reset Password",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
