import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'RIWAYAT.dart';
import 'pengaturan.dart';

class ManajemenBarangPage extends StatefulWidget {
  const ManajemenBarangPage({Key? key}) : super(key: key);

  @override
  State<ManajemenBarangPage> createState() => _ManajemenBarangPageState();
}

class _ManajemenBarangPageState extends State<ManajemenBarangPage> {
  static const Color kPrimary = Color(0xFF03A9F4);

  int selectedFilter = 0; // 0: Semua, 1: Gedung A, 2: Gedung B, 3: Laboratorium
  String query = "";

  final List<_Location> _locations = const [
    _Location(
      title: 'Gudang Utama',
      subtitle: 'Gedung A, Lantai 1',
      countText: '45 Barang',
      buildingTag: 'Gedung A',
      icon: Icons.warehouse,
      iconBg: Color(0xFFE3F2FD),
      iconColor: Color(0xFF2196F3),
      status: _Status.active,
    ),
    _Location(
      title: 'Lab Komputer 1',
      subtitle: 'Gedung B, Lantai 2',
      countText: '12 Barang',
      buildingTag: 'Gedung B',
      icon: Icons.computer,
      iconBg: Color(0xFFF3E5F5),
      iconColor: Color(0xFF9C27B0),
      status: _Status.active,
    ),
    _Location(
      title: 'Lemari Penyimpanan',
      subtitle: 'Ruang Staff',
      countText: '8 Barang',
      buildingTag: 'Semua',
      icon: Icons.inventory_2,
      iconBg: Color(0xFFFFF3E0),
      iconColor: Color(0xFFFF9800),
      status: _Status.warning,
    ),
    _Location(
      title: 'Ruang Rapat Utama',
      subtitle: 'Gedung A, Lantai 3',
      countText: 'Kosong',
      buildingTag: 'Gedung A',
      icon: Icons.meeting_room,
      iconBg: Color(0xFFE8F5E9),
      iconColor: Color(0xFF4CAF50),
      status: _Status.inactive,
    ),
    _Location(
      title: 'Kantin Mahasiswa',
      subtitle: 'Area Outdoor',
      countText: '24 Barang',
      buildingTag: 'Semua',
      icon: Icons.restaurant,
      iconBg: Color(0xFFFFEBEE),
      iconColor: Color(0xFFF44336),
      status: _Status.active,
    ),
  ];

  String _filterLabel(int idx) {
    switch (idx) {
      case 1:
        return "Gedung A";
      case 2:
        return "Gedung B";
      case 3:
        return "Laboratorium";
      default:
        return "Semua";
    }
  }

  List<_Location> get _filteredLocations {
    final filterLabel = _filterLabel(selectedFilter);
    final q = query.trim().toLowerCase();

    return _locations.where((item) {
      final matchesFilter = selectedFilter == 0
          ? true
          : (item.buildingTag == filterLabel) ||
              (filterLabel == "Laboratorium" &&
                  (item.title.toLowerCase().contains("lab") ||
                      item.subtitle.toLowerCase().contains("lab")));

      final matchesQuery = q.isEmpty
          ? true
          : item.title.toLowerCase().contains(q) ||
              item.subtitle.toLowerCase().contains(q);

      return matchesFilter && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredLocations;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
              child: Column(
                children: [
                  SizedBox(
                    height: 44,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _roundIcon(
                            icon: Icons.arrow_back,
                            onTap: () => Navigator.pop(context),
                          ),
                        ),
                        const Center(
                          child: Text(
                            'Manajemen Lokasi',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _roundIcon(
                            icon: Icons.add,
                            bg: kPrimary,
                            iconColor: Colors.white,
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kelola tempat penyimpanan barang',
                    style: TextStyle(
                      fontSize: 14.5,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // Search
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F8),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE9EDF3)),
                ),
                child: TextField(
                  onChanged: (v) => setState(() => query = v),
                  decoration: InputDecoration(
                    hintText: 'Cari lokasi, gedung, atau ruangan...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade500, size: 22),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  ),
                ),
              ),
            ),

            // Filter
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _chip('Semua', 0),
                    const SizedBox(width: 10),
                    _chip('Gedung A', 1),
                    const SizedBox(width: 10),
                    _chip('Gedung B', 2),
                    const SizedBox(width: 10),
                    _chip('Laboratorium', 3),
                  ],
                ),
              ),
            ),

            // List
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        'Data tidak ditemukan.',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => _locationCard(items[index]),
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
              color: Colors.black.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, -8),
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
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dasbor'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Barang'),
            BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Laporan'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Setting'),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: kPrimary,
        child: const Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _chip(String label, int index) {
    final isSelected = selectedFilter == index;
    return ChoiceChip(
      selected: isSelected,
      onSelected: (_) => setState(() => selectedFilter = index),
      selectedColor: kPrimary,
      backgroundColor: Colors.white,
      side: BorderSide(color: isSelected ? kPrimary : const Color(0xFFE5E7EB), width: 1.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      label: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          color: isSelected ? Colors.white : const Color(0xFF111827),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    );
  }

  Widget _locationCard(_Location item) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {},
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE9EDF3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: item.iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(item.icon, color: item.iconColor, size: 30),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _statusColor(item.status),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.countText,
                        style: TextStyle(
                          fontSize: 13.5,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            _roundIcon(
              icon: Icons.edit,
              size: 20,
              bg: const Color(0xFFF2F4F8),
              iconColor: const Color(0xFF6B7280),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  static Widget _roundIcon({
    required IconData icon,
    required VoidCallback onTap,
    Color bg = const Color(0xFFF2F4F8),
    Color iconColor = const Color(0xFF111827),
    double size = 22,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE9EDF3)),
        ),
        child: Icon(icon, color: iconColor, size: size),
      ),
    );
  }

  static Color _statusColor(_Status s) {
    switch (s) {
      case _Status.active:
        return const Color(0xFF22C55E);
      case _Status.warning:
        return const Color(0xFFF59E0B);
      case _Status.inactive:
        return const Color(0xFF9CA3AF);
    }
  }
}

enum _Status { active, warning, inactive }

class _Location {
  final String title;
  final String subtitle;
  final String countText;
  final String buildingTag;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final _Status status;

  const _Location({
    required this.title,
    required this.subtitle,
    required this.countText,
    required this.buildingTag,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.status,
  });
}