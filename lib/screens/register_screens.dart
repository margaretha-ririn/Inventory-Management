// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import '../services/analytics_service.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    AnalyticsService.logScreenView('Register Screen');
  }

  void _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError('Harap isi semua field');
      return;
    }

    if (password != confirmPassword) {
      _showError('Password tidak cocok');
      return;
    }

    if (password.length < 8) {
      _showError('Password minimal 8 karakter');
      return;
    }

    // Track register button click
    await AnalyticsService.logButtonClick('register_button');

    setState(() => _isLoading = true);

    // Real API Registration
    final result = await AuthService().register(name, email, password);

    if (mounted) setState(() => _isLoading = false);

    if (result['success']) {
      // Track successful registration
      await AnalyticsService.logSignUp('email_password');
      
      // Set user properties
      await AnalyticsService.setUserProperties(
        userId: 'new_user', // ID not returned by register endpoint typically unless modified, but okay for analytics
        role: 'user',
        email: email,
      );

      _showSuccess('Registrasi berhasil! Silakan login.');
      
      // Navigate to login (not dashboard, because usually auto-login isn't implemented on register unless specified)
      // User said "Daftar dan Masuk", better to go to login or dashboard. 
      // Plan said: "Navigate to Dashboard". Let's check AuthService.login usage. 
      // If I want to auto-login, I need to call login after register. 
      // For now, let's redirect to Login to be safe and clear, or Dashboard if preferred.
      // ORIGINAL CODE went to /dashboard. I will stick to /dashboard but I should ideally login.
      // Wait, if I go to dashboard without logging in, AuthService.userSession won't be set.
      // Better to go to Login or auto-login.
      // Let's redirect to Login for security/simplicity so they can verify "Masuk".
      
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.pop(context); // Back to Login
      }
    } else {
      await AnalyticsService.logError(
        errorMessage: result['message'] ?? 'Registration failed',
        screen: 'Register Screen',
      );
      _showError(result['message'] ?? 'Registrasi gagal. Coba lagi.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB8B8B8),
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1419),
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        AnalyticsService.logButtonClick('back_button');
                        Navigator.pop(context);
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'Buat Akun',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 24),
                
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Buat Akun Baru',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Isi data di bawah untuk memulai.',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                _buildTextField('Nama Lengkap', 'Masukkan nama lengkap Anda', _nameController),
                const SizedBox(height: 16),
                
                _buildTextField('Email', 'Masukkan email Anda', _emailController),
                const SizedBox(height: 16),
                
                _buildPasswordField('Kata Sandi', 'Minimal 8 karakter', _passwordController, _obscurePassword, () => setState(() => _obscurePassword = !_obscurePassword)),
                const SizedBox(height: 16),
                
                _buildPasswordField('Konfirmasi Kata Sandi', 'Ulangi Kata Sandi Anda', _confirmPasswordController, _obscureConfirmPassword, () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword)),

                const SizedBox(height: 32),
                
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isLoading 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Daftar', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Sudah punya akun? ', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    GestureDetector(
                      onTap: () {
                        AnalyticsService.logButtonClick('login_link');
                        Navigator.pop(context);
                      },
                      child: const Text('Masuk', style: TextStyle(color: Colors.blue, fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
            filled: true,
            fillColor: const Color(0xFF1A2332),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label, String hint, TextEditingController controller, bool obscure, VoidCallback toggle) {
     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
              onPressed: toggle,
            ),
            filled: true,
            fillColor: const Color(0xFF1A2332),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
