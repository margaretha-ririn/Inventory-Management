import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'RIWAYAT.dart';
import 'pengaturan.dart';
import 'package:inventory/services/api_service.dart';
   import 'package:inventory/models/user_model.dart';
   import 'package:inventory/screens/dashboard.dart';
   // dst...

class ManajemenBarangPage extends StatefulWidget {
  const ManajemenBarangPage({Key? key}) : super(key: key);

  @override
  State<ManajemenBarangPage> createState() => _ManajemenBarangPageState();
}

class _ManajemenBarangPageState extends State<ManajemenBarangPage> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'Manajemen Lokasi',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Color(0xFF03A9F4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Kelola tempat penyimpanan barang',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari lokasi, gedung, atau ruangan...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade400,
                    size: 24,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),

            // Filter Tabs
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('Semua', 0),
                    const SizedBox(width: 12),
                    _buildFilterChip('Gedung A', 1),
                    const SizedBox(width: 12),
                    _buildFilterChip('Gedung B', 2),
                    const SizedBox(width: 12),
                    _buildFilterChip('Laboratoriu', 3),
                  ],
                ),
              ),
            ),

            // Location List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _buildLocationItem(
                    'Gudang Utama',
                    'Gedung A, Lantai 1',
                    '45 Barang',
                    const Color(0xFFE3F2FD),
                    const Color(0xFF2196F3),
                    Icons.warehouse,
                    true,
                  ),
                  const SizedBox(height: 16),
                  _buildLocationItem(
                    'Lab Komputer 1',
                    'Gedung B, Lantai 2',
                    '12 Barang',
                    const Color(0xFFF3E5F5),
                    const Color(0xFF9C27B0),
                    Icons.computer,
                    true,
                  ),
                  const SizedBox(height: 16),
                  _buildLocationItem(
                    'Lemari Penyimpanan',
                    'Ruang Staff',
                    '8 Barang',
                    const Color(0xFFFFF3E0),
                    const Color(0xFFFF9800),
                    Icons.inventory_2,
                    false,
                    isOrange: true,
                  ),
                  const SizedBox(height: 16),
                  _buildLocationItem(
                    'Ruang Rapat Utama',
                    'Gedung A, Lantai 3',
                    'Kosong',
                    const Color(0xFFE8F5E9),
                    const Color(0xFF4CAF50),
                    Icons.meeting_room,
                    false,
                    isGrey: true,
                  ),
                  const SizedBox(height: 16),
                  _buildLocationItem(
                    'Kantin Mahasiswa',
                    'Area Outdoor',
                    '24 Barang',
                    const Color(0xFFFFEBEE),
                    const Color(0xFFF44336),
                    Icons.restaurant,
                    true,
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF2196F3),
          unselectedItemColor: Colors.grey[400],
          currentIndex: 1,
          elevation: 0,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const InventoryHomePage()),
              );
            } else if (index == 1) {
              // Sudah di Manajemen
            } else if (index == 3) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RiwayatBarangPage()),
              );
            } else if (index == 4) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PengaturanPage()),
              );
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              label: 'Dasbor',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2),
              label: 'Barang',
            ),
            BottomNavigationBarItem(
              icon: SizedBox.shrink(),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              label: 'Laporan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: 'Setting',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF03A9F4),
        child: const Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildFilterChip(String label, int index) {
    bool isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF03A9F4) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFF03A9F4) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationItem(
    String title,
    String subtitle,
    String count,
    Color bgColor,
    Color iconColor,
    IconData icon,
    bool showGreenDot, {
    bool isOrange = false,
    bool isGrey = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isGrey
                            ? Colors.grey.shade400
                            : (isOrange ? Colors.orange : Colors.green),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      count,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.edit,
            color: Colors.grey.shade400,
            size: 24,
          ),
        ],
      ),
    );
  }
}

