import 'package:flutter/material.dart';
import 'login_page.dart'; // Import buat Logout

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isNotifOn = false; // State untuk switch notifikasi

  // Warna UI
  final Color bgMain = const Color(0xFF0F161C);
  final Color cardDark = const Color(0xFF192229);
  final Color cardBlue2 = const Color(0xFF00C6FF);
  final Color textGrey = const Color(0xFF8B959E);
  final Color textWhite = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgMain,
      appBar: AppBar(
        backgroundColor: bgMain,
        elevation: 0,
        automaticallyImplyLeading:
            false, // Hilangkan tombol back karena ini Tab
        centerTitle: true,
        title: const Text(
          "Pengaturan",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. PROFIL SECTION
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                "https://i.pravatar.cc/150?img=12",
              ), // Foto Dummy
            ),
            const SizedBox(height: 15),
            const Text(
              "Andi Saputra",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "NIM: 2201534089 • Mobile Programming A",
              style: TextStyle(color: textGrey, fontSize: 12),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: cardBlue2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Edit Profil Saya",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 2. LIST MENU (AKUN)
            _buildSectionLabel("AKUN"),
            _buildMenuItem(Icons.lock_outline, "Ubah Password", onTap: () {}),
            _buildMenuItem(
              Icons.email_outlined,
              "Email & Notifikasi",
              onTap: () {},
            ),

            const SizedBox(height: 20),

            // 3. LIST MENU (PREFERENSI)
            _buildSectionLabel("PREFERENSI"),
            _buildMenuItem(
              Icons.palette_outlined,
              "Tema Aplikasi",
              trailing: Text("Terang", style: TextStyle(color: textGrey)),
              onTap: () {},
            ),
            _buildMenuItem(
              Icons.language,
              "Bahasa",
              trailing: Text("Indonesia", style: TextStyle(color: textGrey)),
              onTap: () {},
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: cardDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2A353E)),
              ),
              child: SwitchListTile(
                title: const Text(
                  "Notifikasi Stok",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1BEE7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.notifications_active,
                    color: Colors.purple,
                  ),
                ),
                value: _isNotifOn,
                activeColor: cardBlue2,
                onChanged: (val) => setState(() => _isNotifOn = val),
              ),
            ),

            const SizedBox(height: 20),

            // 4. LIST MENU (TENTANG)
            _buildSectionLabel("TENTANG"),
            _buildMenuItem(
              Icons.description_outlined,
              "Syarat & Ketentuan",
              iconColor: Colors.orange,
              bgColor: const Color(0xFFFFE0B2),
              onTap: () {},
            ),
            _buildMenuItem(
              Icons.info_outline,
              "Versi App",
              iconColor: Colors.orange,
              bgColor: const Color(0xFFFFE0B2),
              trailing: Text("v1.0.0 Beta", style: TextStyle(color: textGrey)),
              onTap: () {},
            ),

            const SizedBox(height: 30),

            // 5. LOGOUT BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Logout Logic: Kembali ke Login Page & Hapus History Navigasi
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: Color(0xFFE53935)),
                label: const Text(
                  "Keluar dari Akun",
                  style: TextStyle(
                    color: Color(0xFFE53935),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFEBEE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Inventory Manager Mobile © 2025",
              style: TextStyle(color: textGrey.withOpacity(0.5), fontSize: 10),
            ),
            const SizedBox(height: 80), // Space buat Navbar
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: TextStyle(
            color: textGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title, {
    Widget? trailing,
    VoidCallback? onTap,
    Color? iconColor,
    Color? bgColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A353E)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: bgColor ?? const Color(0xFFB3E5FC),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor ?? const Color(0xFF0288D1)),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        trailing:
            trailing ??
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}
