import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'manajemen.dart';
import 'pengaturan.dart';

class RiwayatBarangPage extends StatefulWidget {
  const RiwayatBarangPage({super.key});

  @override
  State<RiwayatBarangPage> createState() => _RiwayatBarangPageState();
}

class _RiwayatBarangPageState extends State<RiwayatBarangPage> {
  int _selectedFilter = 0; // 0: Semua, 1: Masuk/Keluar, 2: Perbaikan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // ← PERBAIKAN: Tambahkan navigasi back
          },
        ),
        title: const Text(
          'Riwayat Barang',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Item Header Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4E6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Sedang Dipinjam',
                        style: TextStyle(
                          color: Color(0xFFFF9800),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Arduino Uno R3 - Kit A',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '#INV-2023-001',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          'https://via.placeholder.com/80x80/E3F2FD/1976D2?text=Arduino',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.memory,
                              size: 40,
                              color: Colors.blue,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kondisi',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 8,
                                color: Color(0xFF4CAF50),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Baik',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lokasi Saat Ini',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Lab Mobile',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Filter Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip('Semua', 0),
                const SizedBox(width: 8),
                _buildFilterChip('Masuk/Keluar', 1),
                const SizedBox(width: 8),
                _buildFilterChip('Perbaikan', 2),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Timeline
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildTimelineItem(
                      icon: Icons.arrow_upward,
                      iconColor: const Color(0xFFFFF4E6),
                      iconBgColor: const Color(0xFFFF9800),
                      title: 'Dipinjam',
                      time: '10:00 AM',
                      subtitle: 'Oleh Andi Saputra',
                      location: 'Gudang → Lab Mobile',
                      isFirst: true,
                    ),
                    _buildTimelineItem(
                      icon: Icons.sync_alt,
                      iconColor: const Color(0xFFE3F2FD),
                      iconBgColor: const Color(0xFF2196F3),
                      title: 'Dipindahkan',
                      time: '09:30 AM',
                      subtitle: 'Oleh Asisten Lab',
                      location: 'Gudang Utama → Gudang',
                      isFirst: false,
                    ),
                    _buildTimelineItem(
                      icon: Icons.build,
                      iconColor: Colors.grey[200]!,
                      iconBgColor: Colors.grey[700]!,
                      title: 'Selesai Perbaikan',
                      time: 'Kemarin, 14:00',
                      subtitle: 'Unit kembali dari servis rutin. Kondisi normal.',
                      location: null,
                      isFirst: false,
                    ),
                    _buildTimelineItem(
                      icon: Icons.add_circle,
                      iconColor: const Color(0xFFE8F5E9),
                      iconBgColor: const Color(0xFF4CAF50),
                      title: 'Barang Masuk',
                      time: '20 Okt 2023',
                      subtitle: 'Dari Vendor Elektronika Jaya',
                      location: 'Stok Awal → Gudang Utama',
                      isFirst: false,
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
          currentIndex: 3,
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          onTap: (index) {
            if (index == 0) {
              // Ke Dashboard
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const InventoryHomePage()),
              );
            } else if (index == 1) {
              // Ke Manajemen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const ManajemenBarangPage()),
              );
            } else if (index == 3) {
              // Sudah di Laporan/Riwayat
            } else if (index == 4) {
              // Ke Pengaturan
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const PengaturanPage()),
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
      floatingActionButton: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(32.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2196F3).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(
          Icons.qr_code_scanner_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2196F3) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF2196F3) : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label == 'Masuk/Keluar')
              Icon(
                Icons.sync_alt,
                size: 16,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            if (label == 'Perbaikan')
              Icon(
                Icons.build,
                size: 16,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            if (label == 'Semua')
              Icon(
                Icons.list,
                size: 16,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            if (label != 'Semua') const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String time,
    required String subtitle,
    String? location,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              if (!isFirst)
                Container(
                  width: 2,
                  height: 20,
                  color: Colors.grey[300],
                ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconBgColor,
                  size: 24,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey[300],
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  if (location != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          location.contains('→')
                              ? Icons.location_on_outlined
                              : Icons.warehouse_outlined,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            location,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}