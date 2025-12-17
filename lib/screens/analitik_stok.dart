import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnalitikStokScreen extends StatefulWidget {
  const AnalitikStokScreen({Key? key}) : super(key: key);

  @override
  State<AnalitikStokScreen> createState() => _AnalitikStokScreenState();
}

class _AnalitikStokScreenState extends State<AnalitikStokScreen> {
  // State untuk navigasi bawah (Default: 1 = Analitik)
  int _bottomNavIndex = 1;

  @override
  Widget build(BuildContext context) {
    // Definisi Warna sesuai Desain
    const Color kPrimaryBlue = Color(0xFF0095FF);
    const Color kBgColor = Color(0xFFF5F7FA);

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Analitik Stok',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: const [
                Icon(Icons.calendar_today, size: 14, color: kPrimaryBlue),
                SizedBox(width: 6),
                Text(
                  'Bulan Ini',
                  style: TextStyle(
                    color: kPrimaryBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, size: 16, color: kPrimaryBlue),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. SECTION SUMMARY CARDS (GRID 2x2)
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Total Nilai',
                      value: 'Rp 15jt',
                      subText: '+12%',
                      subTextColor: Colors.green,
                      icon: Icons.monetization_on_outlined,
                      iconBg: Colors.blue.shade50,
                      iconColor: Colors.blue,
                      isArrowUp: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Stok Rendah',
                      value: '5 Item',
                      subText: 'Perlu Restok',
                      subTextColor: Colors.orange,
                      icon: Icons.inventory_2_outlined,
                      iconBg: Colors.orange.shade50,
                      iconColor: Colors.orange,
                      isWarning: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Total Produk',
                      value: '142',
                      subText: '+ 10 baru',
                      subTextColor: Colors.green,
                      icon: Icons.category_outlined,
                      iconBg: Colors.purple.shade50,
                      iconColor: Colors.purple,
                      isPlus: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Habis',
                      value: '2 Item',
                      subText: 'Mendesak',
                      subTextColor: Colors.red,
                      icon: Icons.remove_shopping_cart_outlined,
                      iconBg: Colors.red.shade50,
                      iconColor: Colors.red,
                      isDanger: true,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              // 2. SECTION DISTRIBUSI KATEGORI (DONUT CHART)
              const Text(
                'Distribusi Kategori',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    // Custom Painter Donut Chart
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CustomPaint(
                        painter: DonutChartPainter(),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '100%',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Legends
                    Expanded(
                      child: Column(
                        children: [
                          _buildLegendItem(
                            color: Colors.blue,
                            label: 'Elektronik',
                            percent: '40%',
                          ),
                          const SizedBox(height: 12),
                          _buildLegendItem(
                            color: Colors.orange,
                            label: 'Buku',
                            percent: '30%',
                          ),
                          const SizedBox(height: 12),
                          _buildLegendItem(
                            color: Colors.deepPurpleAccent,
                            label: 'Lainnya',
                            percent: '30%',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // 3. SECTION PERGERAKAN STOK (BAR CHART)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pergerakan Stok',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Minggu Ini',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Area Grafik Batang Dummy
                    SizedBox(
                      height: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildBarGroup('Sn', 30, 20),
                          _buildBarGroup('Sl', 45, 15),
                          _buildBarGroup('Rb', 25, 40),
                          _buildBarGroup('Km', 60, 30),
                          _buildBarGroup('Jm', 50, 25),
                          _buildBarGroup('Sb', 20, 10),
                          _buildBarGroup('Mg', 10, 5),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Legend Chart
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildDotLegend(Colors.blue, 'Masuk'),
                        const SizedBox(width: 16),
                        _buildDotLegend(Colors.redAccent, 'Keluar'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // 4. SECTION PERLU PERHATIAN
              const Text(
                'Perlu Perhatian',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildAttentionCard(
                name: 'USB Cable Type-C',
                stock: 'Sisa Stok: 2',
                action: 'Restok',
                icon: Icons.cable,
                colorTheme: Colors.red,
              ),
              const SizedBox(height: 12),
              _buildAttentionCard(
                name: 'Kertas HVS A4',
                stock: 'Sisa Stok: 5',
                action: 'Order',
                icon: Icons.print,
                colorTheme: Colors.orange,
              ),

              const SizedBox(height: 24),
              // 5. SECTION PRODUK TERLARIS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Produk Terlaris',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Lihat Semua',
                    style: TextStyle(
                      color: kPrimaryBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildTopProductItem(
                      1,
                      'Wireless Mouse',
                      'Elektronik',
                      '50',
                      Icons.mouse,
                    ),
                    const Divider(height: 1),
                    _buildTopProductItem(
                      2,
                      'Mech Keyboard',
                      'Elektronik',
                      '32',
                      Icons.keyboard,
                    ),
                    const Divider(height: 1),
                    _buildTopProductItem(
                      3,
                      'Notebook A5',
                      'Buku',
                      '28',
                      Icons.menu_book,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40), // Spacer bottom
            ],
          ),
        ),
      ),

      // BOTTOM NAVIGATION BAR
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aksi tombol QR Scan
        },
        backgroundColor: kPrimaryBlue,
        child: const Icon(Icons.qr_code_scanner, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // MENGGUNAKAN LOGIKA _bottomNavIndex == 0
                  _buildNavItem(
                    0,
                    Icons.home_filled,
                    'Beranda',
                    _bottomNavIndex == 0,
                  ),
                  _buildNavItem(
                    1,
                    Icons.analytics,
                    'Analitik',
                    _bottomNavIndex == 1,
                  ),
                ],
              ),
              Row(
                children: [
                  _buildNavItem(
                    2,
                    Icons.inventory_2,
                    'Stok',
                    _bottomNavIndex == 2,
                  ),
                  _buildNavItem(
                    3,
                    Icons.person,
                    'Profil',
                    _bottomNavIndex == 3,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildNavItem(int index, IconData icon, String label, bool isActive) {
    return MaterialButton(
      minWidth: 40,
      onPressed: () {
        setState(() {
          _bottomNavIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            // Warna berubah dinamis berdasarkan isActive
            color: isActive ? const Color(0xFF0095FF) : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isActive ? const Color(0xFF0095FF) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String subText,
    required Color subTextColor,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    bool isArrowUp = false,
    bool isPlus = false,
    bool isWarning = false,
    bool isDanger = false,
  }) {
    IconData? subIcon;
    if (isArrowUp) subIcon = Icons.trending_up;
    if (isPlus) subIcon = Icons.add;
    if (isWarning) subIcon = Icons.warning_amber_rounded;
    if (isDanger) subIcon = Icons.error_outline;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (subIcon != null) Icon(subIcon, size: 14, color: subTextColor),
              const SizedBox(width: 4),
              Text(
                subText,
                style: TextStyle(
                  color: subTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required String percent,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ],
        ),
        Text(
          percent,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildBarGroup(String day, double inHeight, double outHeight) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Batang Masuk
            Container(
              width: 6,
              height: inHeight,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 4),
            // Batang Keluar
            Container(
              width: 6,
              height: outHeight,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(day, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildDotLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildAttentionCard({
    required String name,
    required String stock,
    required String action,
    required IconData icon,
    required Color colorTheme,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: colorTheme, width: 4),
        ), // Garis warna di kiri
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorTheme.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: colorTheme, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(stock, style: TextStyle(color: colorTheme, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colorTheme.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              action,
              style: TextStyle(
                color: colorTheme,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopProductItem(
    int rank,
    String name,
    String category,
    String sold,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.yellow.shade100,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.orange,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: Colors.grey.shade700),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  category,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                sold,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Text(
                'Terjual',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- CUSTOM PAINTER UNTUK DONUT CHART ---
class DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 12.0;
    final rect = Rect.fromCircle(
      center: center,
      radius: radius - strokeWidth / 2,
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Segment 1: Elektronik (Blue) 40%
    paint.color = Colors.blue;
    double startAngle = -math.pi / 2; // Mulai dari atas (jam 12)
    double sweepAngle = 2 * math.pi * 0.4;
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);

    // Segment 2: Buku (Orange) 30%
    paint.color = Colors.orange;
    startAngle += sweepAngle;
    sweepAngle = 2 * math.pi * 0.3;
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);

    // Segment 3: Lainnya (Purple) 30%
    paint.color = Colors.deepPurpleAccent;
    startAngle += sweepAngle;
    sweepAngle = 2 * math.pi * 0.3;
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
