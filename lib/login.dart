import 'package:flutter/material.dart';
import 'dashboard.dart'; // Import halaman dashboard

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController(text: 'student@university.edu');
  final TextEditingController _passwordController = TextEditingController(text: '........');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                // Logo dan ilustrasi
                Center(
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8C4A0),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Box besar kiri
                        Positioned(
                          bottom: 80,
                          left: 60,
                          child: _buildBox(80, 60, const Color(0xFFB8905F)),
                        ),
                        // Box besar tengah
                        Positioned(
                          bottom: 80,
                          child: _buildBox(100, 70, const Color(0xFFD4A574)),
                        ),
                        // Box besar kanan
                        Positioned(
                          bottom: 80,
                          right: 55,
                          child: _buildBox(90, 65, const Color(0xFFB8905F)),
                        ),
                        // Box kecil kanan
                        Positioned(
                          bottom: 85,
                          right: 75,
                          child: _buildBox(45, 40, const Color(0xFFD4A574)),
                        ),
                        // Clipboard
                        Positioned(
                          top: 85,
                          left: 80,
                          child: _buildClipboard(),
                        ),
                        // Pensil
                        Positioned(
                          top: 115,
                          right: 70,
                          child: _buildPencil(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Title
                const Text(
                  'Login Akun',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Subtitle
                const Text(
                  'Manage your inventory efficiently.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF808080),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Email field
                const Text(
                  'Email or Username',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: const Icon(Icons.email_outlined, color: Color(0xFF808080)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  ),
                  style: const TextStyle(fontSize: 16, color: Color(0xFF808080)),
                ),
                const SizedBox(height: 24),
                // Password field
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: const Color(0xFF808080),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),
                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFF00A5E0),
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Login Button - PERBAIKAN DISINI
                ElevatedButton(
                  onPressed: () {
                    // Navigasi ke dashboard setelah login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const InventoryHomePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0BA9E6),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Create Account - PERBAIKAN DISINI
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'New here?  ',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF808080),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigasi ke halaman register
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterPage()),
                        );
                      },
                      child: const Text(
                        'Create an Account',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF00A5E0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBox(double width, double height, Color color) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF8B6F47), width: 2),
      ),
    );
  }

  Widget _buildClipboard() {
    return Container(
      width: 70,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF8B6F47), width: 2),
      ),
      child: Column(
        children: [
          // Clip top
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 30,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFF8B6F47),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 8),
          // Checkboxes
          _buildCheckItem(),
          _buildCheckItem(),
          _buildCheckItem(),
          _buildCheckItem(),
        ],
      ),
    );
  }

  Widget _buildCheckItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF8B6F47), width: 1.5),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                color: const Color(0xFFD4A574),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPencil() {
    return Transform.rotate(
      angle: 0.5,
      child: Container(
        width: 6,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF8B6F47),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Column(
          children: [
            Container(
              width: 6,
              height: 10,
              decoration: const BoxDecoration(
                color: Color(0xFFD4A574),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder untuk RegisterPage (buat file register.dart nanti)
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: const Center(child: Text('Register Page - Coming Soon')),
    );
  }
}