import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Import halaman-halaman lain agar navigasi berfungsi
import 'register_page.dart';
import 'forgot_password_page.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk mengambil teks inputan
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true; // Untuk fitur show/hide password
  bool _isLoading = false; // Untuk animasi loading saat tombol ditekan

  // Fungsi Login ke API PHP
  Future<void> _login() async {
    // Validasi input kosong sederhana
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Email dan Password tidak boleh kosong!"),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // PENTING: Gunakan 127.0.0.1 untuk Windows Desktop App
    String url = "http://127.0.0.1/inventory_api/login.php";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'username': _usernameController.text,
          'password': _passwordController.text,
        },
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (data['success'] == true) {
        // --- LOGIN SUKSES ---
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Login Berhasil! Welcome ${data['data']['full_name']}",
            ),
          ),
        );

        // Pindah ke Dashboard & Hapus Login dari Back Stack
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
      } else {
        // --- LOGIN GAGAL ---
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(data['message'])),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error: Gagal konek ke server. Cek XAMPP!"),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Definisi Warna Sesuai Analisis UI
    const Color bgMain = Color(0xFF0F161C);
    const Color bgInput = Color(0xFF192229);
    const Color borderInput = Color(0xFF2A353E);
    const Color accentBlue = Color(0xFF0ABDF8);
    const Color textWhite = Colors.white;
    const Color textGrey = Color(0xFF8B959E);

    return Scaffold(
      backgroundColor: bgMain, // Set Background Gelap
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri
            children: [
              // 1. Logo Section (Placeholder Icon gantiin Gambar)
              Center(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: bgInput,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: accentBlue.withOpacity(0.5),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 2. Title & Subtitle
              const Center(
                child: Text(
                  "Login Akun",
                  style: TextStyle(
                    color: textWhite,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "Welcome back to your inventory.\nPlease sign in to continue.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textGrey, fontSize: 14, height: 1.5),
                ),
              ),
              const SizedBox(height: 40),

              // 3. Input Email/Username
              const Text(
                "Email or Username",
                style: TextStyle(color: textWhite, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _usernameController,
                style: const TextStyle(color: textWhite),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: bgInput,
                  hintText: "student@university.edu",
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

              // 4. Input Password
              const Text(
                "Password",
                style: TextStyle(color: textWhite, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _isObscure, // Logic hide/show
                style: const TextStyle(color: textWhite),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: bgInput,
                  hintText: "••••••••",
                  hintStyle: const TextStyle(color: textGrey),
                  prefixIcon: const Icon(Icons.lock_outline, color: textGrey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      color: textGrey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
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

              // 5. Forgot Password Link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Navigasi ke Forgot Password Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: accentBlue),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 6. Login Button (Full Width)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : _login, // Disable kalau lagi loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // 7. Register Text & Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: textGrey),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigasi ke Register Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: accentBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
