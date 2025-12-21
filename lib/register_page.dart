import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controller Input
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _isObscurePass = true; // Untuk password utama
  bool _isObscureConfirm = true; // Untuk confirm password

  // Fungsi Register
  Future<void> _register() async {
    // 1. Validasi Lokal: Password harus sama dengan Confirm Password
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Password dan Confirm Password tidak sama!"),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String url = "http://127.0.0.1/inventory_api/register.php";

    // 2. Trik Auto-Username: Ambil teks sebelum @ dari email
    // Misal: budi.santoso@gmail.com -> Username: budi.santoso
    String generatedUsername = _emailController.text.split('@')[0];

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'full_name': _fullNameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          // Kita kirim username otomatis biar database gak error
          'username': generatedUsername,
        },
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (data['success'] == true) {
        // Sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(data['message']),
          ),
        );
        Navigator.pop(context); // Kembali ke Login
      } else {
        // Gagal (Misal email duplikat)
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

  // Widget Helper untuk Input Field biar kodenya rapi
  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    Widget? suffixIcon,
    bool isObscure = false,
  }) {
    // Definisi Warna Lokal
    const Color bgInput = Color(0xFF192229);
    const Color borderInput = Color(0xFF2A353E);
    const Color textWhite = Colors.white;
    const Color textGrey = Color(0xFF8B959E);
    const Color accentBlue = Color(0xFF0ABDF8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: textWhite, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isObscure,
          style: const TextStyle(color: textWhite),
          decoration: InputDecoration(
            filled: true,
            fillColor: bgInput,
            hintText: hint,
            hintStyle: const TextStyle(color: textGrey),
            suffixIcon: suffixIcon, // Icon ditaruh di KANAN sesuai desain
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color bgMain = Color(0xFF0F161C);
    const Color accentBlue = Color(0xFF0ABDF8);
    const Color textWhite = Colors.white;
    const Color textGrey = Color(0xFF8B959E);
    const Color bgIcon = Color(0xFF192229); // Warna background icon header

    return Scaffold(
      backgroundColor: bgMain,
      // AppBar Sesuai Desain
      appBar: AppBar(
        backgroundColor: bgMain,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Daftar Akun",
          style: TextStyle(
            color: textWhite,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: textWhite,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            children: [
              // 1. Header Icon & Text
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: bgIcon,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20), // Agak kotak tumpul
                ),
                child: const Icon(
                  Icons.person_add_outlined,
                  size: 40,
                  color: accentBlue,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Daftar Akun Baru",
                style: TextStyle(
                  color: textWhite,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Create a new account for a user or\nadministrator to access the inventory system.",
                textAlign: TextAlign.center,
                style: TextStyle(color: textGrey, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 30),

              // 2. Form Fields (Pakai Widget Helper biar rapi)
              _buildTextField(
                label: "Full Name",
                hint: "e.g. Budi Santoso",
                controller: _fullNameController,
                suffixIcon: const Icon(Icons.person_outline, color: textGrey),
              ),
              _buildTextField(
                label: "Email Address",
                hint: "student@university.ac.id",
                controller: _emailController,
                suffixIcon: const Icon(Icons.email_outlined, color: textGrey),
              ),

              // Password
              _buildTextField(
                label: "Password",
                hint: "••••••••",
                controller: _passwordController,
                isObscure: _isObscurePass,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscurePass
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: textGrey,
                  ),
                  onPressed: () =>
                      setState(() => _isObscurePass = !_isObscurePass),
                ),
              ),

              // Confirm Password
              _buildTextField(
                label: "Confirm Password",
                hint: "••••••••",
                controller: _confirmPasswordController,
                isObscure: _isObscureConfirm,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscureConfirm
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: textGrey,
                  ),
                  onPressed: () =>
                      setState(() => _isObscureConfirm = !_isObscureConfirm),
                ),
              ),

              const SizedBox(height: 10),

              // 3. Register Button (Dengan Panah)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
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
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // 4. Footer Links
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: textGrey),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: accentBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // 5. Terms Text
              const Text(
                "By registering, you agree to our Terms of Service and Privacy Policy.",
                textAlign: TextAlign.center,
                style: TextStyle(color: textGrey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
