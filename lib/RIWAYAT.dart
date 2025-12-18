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
  static const Color kPrimary = Color(0xFF2196F3);
  static const Color kBg = Color(0xFFF6F7FB);

  int _selectedFilter = 0; // 0: Semua, 1: Masuk/Keluar, 2: Perbaikan

  final List<_HistoryEvent> _events = const [
    _HistoryEvent(
      type: _HistoryType.inOut,
      title: 'Dipinjam',
      time: '10:00 AM',
      subtitle: 'Oleh Andi Saputra',
      location: 'Gudang → Lab Mobile',
      icon: Icons.arrow_upward_rounded,
      bg: Color(0xFFFFF4E6),
      fg: Color(0xFFFF9800),
    ),
    _HistoryEvent(
      type: _HistoryType.inOut,
      title: 'Dipindahkan',
      time: '09:30 AM',
      subtitle: 'Oleh Asisten Lab',
      location: 'Gudang Utama → Gudang',
      icon: Icons.sync_alt_rounded,
      bg: Color(0xFFE3F2FD),
      fg: Color(0xFF2196F3),
    ),
    _HistoryEvent(
      type: _HistoryType.repair,
      title: 'Selesai Perbaikan',
      time: 'Kemarin, 14:00',
      subtitle: 'Unit kembali dari servis rutin. Kondisi normal.',
      location: null,
      icon: Icons.build_rounded,
      bg: Color(0xFFF3F4F6),
      fg: Color(0xFF374151),
    ),
    _HistoryEvent(
      type: _HistoryType.inOut,
      title: 'Barang Masuk',
      time: '20 Okt 2023',
      subtitle: 'Dari Vendor Elektronika Jaya',
      location: 'Stok Awal → Gudang Utama',
      icon: Icons.add_circle_rounded,
      bg: Color(0xFFE8F5E9),
      fg: Color(0xFF4CAF50),
    ),
  ];

  List<_HistoryEvent> get _filteredEvents {
    if (_selectedFilter == 0) return _events;
    if (_selectedFilter == 1) return _events.where((e) => e.type == _HistoryType.inOut).toList();
    return _events.where((e) => e.type == _HistoryType.repair).toList();
  }

  @override
  Widget build(BuildContext context) {
    final events = _filteredEvents;

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Riwayat Barang',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header Card
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _pill(
                        text: 'Sedang Dipinjam',
                        bg: const Color(0xFFFFF4E6),
                        fg: const Color(0xFFFF9800),
                        icon: Icons.schedule_rounded,
                      ),
                      const Spacer(),
                      _pill(
                        text: 'Baik',
                        bg: const Color(0xFFE8F5E9),
                        fg: const Color(0xFF2E7D32),
                        icon: Icons.verified_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
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
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '#INV-2023-001',
                              style: TextStyle(
                                fontSize: 13.5,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 74,
                        height: 74,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F4F8),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE9EDF3)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            'https://via.placeholder.com/80x80/E3F2FD/1976D2?text=Arduino',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.memory, size: 36, color: kPrimary);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: const [
                      Expanded(
                        child: _miniInfo(
                          label: 'Lokasi Saat Ini',
                          value: 'Lab Mobile',
                          icon: Icons.location_on_outlined,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _miniInfo(
                          label: 'Status',
                          value: 'Dipinjam',
                          icon: Icons.info_outline_rounded,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Filter
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _choiceChip('Semua', 0, Icons.list_rounded),
                  const SizedBox(width: 10),
                  _choiceChip('Masuk/Keluar', 1, Icons.sync_alt_rounded),
                  const SizedBox(width: 10),
                  _choiceChip('Perbaikan', 2, Icons.build_rounded),
                ],
              ),
            ),
          ),

          // Timeline
          Expanded(
            child: events.isEmpty
                ? Center(
                    child: Text(
                      'Tidak ada riwayat untuk filter ini.',
                      style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w700),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final e = events[index];
                      final isFirst = index == 0;
                      final isLast = index == events.length - 1;
                      return _timelineTile(event: e, isFirst: isFirst, isLast: isLast);
                    },
                  ),
          ),
        ],
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
          selectedItemColor: kPrimary,
          unselectedItemColor: Colors.grey[400],
          currentIndex: 3,
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const InventoryHomePage()),
              );
            } else if (index == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ManajemenBarangPage()),
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
        backgroundColor: kPrimary,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Scan QR/Barcode (belum dihubungkan)')),
          );
        },
        child: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _choiceChip(String label, int index, IconData icon) {
    final isSelected = _selectedFilter == index;
    return ChoiceChip(
      selected: isSelected,
      onSelected: (_) => setState(() => _selectedFilter = index),
      selectedColor: kPrimary,
      backgroundColor: Colors.white,
      side: BorderSide(color: isSelected ? kPrimary : const Color(0xFFE5E7EB), width: 1.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white : const Color(0xFF6B7280)),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 13,
              color: isSelected ? Colors.white : const Color(0xFF111827),
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    );
  }

  Widget _timelineTile({
    required _HistoryEvent event,
    required bool isFirst,
    required bool isLast,
  }) {
    final dot = event.type == _HistoryType.inOut ? const Color(0xFF2196F3) : const Color(0xFF6B7280);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 54,
          child: Column(
            children: [
              if (!isFirst) Container(width: 2, height: 12, color: const Color(0xFFE5E7EB)),
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: event.bg,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE9EDF3)),
                ),
                child: Icon(event.icon, color: event.fg, size: 24),
              ),
              if (!isLast) Container(width: 2, height: 48, color: const Color(0xFFE5E7EB)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            child: _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 8, height: 8, decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          event.title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                        ),
                      ),
                      Text(
                        event.time,
                        style: TextStyle(fontSize: 12.5, color: Colors.grey[600], fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    event.subtitle,
                    style: TextStyle(fontSize: 13.8, color: Colors.grey[700], height: 1.4, fontWeight: FontWeight.w600),
                  ),
                  if (event.location != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            event.location!,
                            style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9EDF3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 14, offset: const Offset(0, 8)),
        ],
      ),
      child: child,
    );
  }

  static Widget _pill({
    required String text,
    required Color bg,
    required Color fg,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: fg, fontSize: 12.5, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

enum _HistoryType { inOut, repair }

class _HistoryEvent {
  final _HistoryType type;
  final String title;
  final String time;
  final String subtitle;
  final String? location;
  final IconData icon;
  final Color bg;
  final Color fg;

  const _HistoryEvent({
    required this.type,
    required this.title,
    required this.time,
    required this.subtitle,
    required this.location,
    required this.icon,
    required this.bg,
    required this.fg,
  });
}

class _miniInfo extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _miniInfo({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9EDF3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF6B7280)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280), fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: Color(0xFF111827))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}