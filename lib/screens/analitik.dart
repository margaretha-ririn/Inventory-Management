import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:inventory/services/api_service.dart';
import 'package:inventory/models/user_model.dart';
import 'package:inventory/screens/dashboard.dart';
   // dst...

class AnalitikStokScreen extends StatelessWidget {
  const AnalitikStokScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Analitik Stok',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.calendar_today, size: 16, color: Color(0xFF42A5F5)),
                              SizedBox(width: 6),
                              Text(
                                'Bulan Ini',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF42A5F5),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF42A5F5)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Cards Grid
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.account_balance_wallet,
                            iconColor: const Color(0xFF42A5F5),
                            iconBg: const Color(0xFFE3F2FD),
                            title: 'Total Nilai',
                            value: 'Rp 15jt',
                            subtitle: '+12%',
                            subtitleColor: const Color(0xFF4CAF50),
                            hasArrow: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.inventory_2,
                            iconColor: const Color(0xFFFF9800),
                            iconBg: const Color(0xFFFFF3E0),
                            title: 'Stok Rendah',
                            value: '5 Item',
                            subtitle: 'Perlu Restok',
                            subtitleColor: const Color(0xFFFF9800),
                            hasWarning: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.shopping_bag,
                            iconColor: const Color(0xFF9C27B0),
                            iconBg: const Color(0xFFF3E5F5),
                            title: 'Total Produk',
                            value: '142',
                            subtitle: '10 baru',
                            subtitleColor: const Color(0xFF4CAF50),
                            hasPlus: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.remove_shopping_cart,
                            iconColor: const Color(0xFFF44336),
                            iconBg: const Color(0xFFFFEBEE),
                            title: 'Habis',
                            value: '2 Item',
                            subtitle: 'Mendesak',
                            subtitleColor: const Color(0xFFF44336),
                            hasDot: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Distribusi Kategori
                    const Text(
                      'Distribusi Kategori',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
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
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: Stack(
                              children: [
                                CustomPaint(
                                  size: const Size(120, 120),
                                  painter: DonutChartPainter(),
                                ),
                                const Center(
                                  child: Text(
                                    'Total\n100%',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLegendItem('Elektronik', '40%', const Color(0xFF42A5F5)),
                                const SizedBox(height: 12),
                                _buildLegendItem('Buku', '30%', const Color(0xFFFF9800)),
                                const SizedBox(height: 12),
                                _buildLegendItem('Lainnya', '30%', const Color(0xFF9C27B0)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Pergerakan Stok
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pergerakan Stok',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Minggu Ini',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 200,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: CustomPaint(
                              size: const Size(double.infinity, 150),
                              painter: LineChartPainter(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              Text('Sn', style: TextStyle(fontSize: 11, color: Colors.grey)),
                              Text('Sl', style: TextStyle(fontSize: 11, color: Colors.grey)),
                              Text('Rb', style: TextStyle(fontSize: 11, color: Colors.grey)),
                              Text('Km', style: TextStyle(fontSize: 11, color: Colors.grey)),
                              Text('Jm', style: TextStyle(fontSize: 11, color: Colors.grey)),
                              Text('Sb', style: TextStyle(fontSize: 11, color: Colors.grey)),
                              Text('Mg', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildChartLegend('Masuk', const Color(0xFF42A5F5)),
                              const SizedBox(width: 20),
                              _buildChartLegend('Keluar', const Color(0xFFF44336)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Perlu Perhatian
                    const Text(
                      'Perlu Perhatian',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildAttentionCard(
                      icon: Icons.cable,
                      iconColor: const Color(0xFFF44336),
                      title: 'USB Cable Type-C',
                      subtitle: 'Sisa Stok: 2',
                      badge: 'Restok',
                      badgeColor: const Color(0xFFF44336),
                    ),
                    const SizedBox(height: 12),
                    _buildAttentionCard(
                      icon: Icons.description,
                      iconColor: const Color(0xFFFF9800),
                      title: 'Kertas HVS A4',
                      subtitle: 'Sisa Stok: 5',
                      badge: 'Order',
                      badgeColor: const Color(0xFFFF9800),
                    ),
                    const SizedBox(height: 24),
                    // Produk Terlaris
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Produk Terlaris',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Lihat Semua',
                          style: TextStyle(
                            fontSize: 13,
                            color: const Color(0xFF42A5F5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildProductCard(1, Icons.mouse, 'Wireless Mouse', 'Elektronik', '50'),
                    const SizedBox(height: 12),
                    _buildProductCard(2, Icons.keyboard, 'Mech Keyboard', 'Elektronik', '32'),
                    const SizedBox(height: 12),
                    _buildProductCard(3, Icons.laptop_chromebook, 'Notebook A5', 'Buku', '28'),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String value,
    required String subtitle,
    required Color subtitleColor,
    bool hasArrow = false,
    bool hasWarning = false,
    bool hasPlus = false,
    bool hasDot = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              if (hasArrow)
                Icon(Icons.trending_up, size: 14, color: subtitleColor),
              if (hasWarning)
                Icon(Icons.warning, size: 14, color: subtitleColor),
              if (hasPlus)
                Icon(Icons.add, size: 14, color: subtitleColor),
              if (hasDot)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: subtitleColor,
                    shape: BoxShape.circle,
                  ),
                ),
              const SizedBox(width: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: subtitleColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, String percentage, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        const Spacer(),
        Text(
          percentage,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildChartLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildAttentionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String badge,
    required Color badgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: iconColor, width: 4),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badge,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: badgeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(int rank, IconData icon, String name, String category, String sold) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9C4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.grey[700], size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
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
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Terjual',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, 'Beranda', false),
          _buildNavItem(Icons.bar_chart, 'Analitik', true),
          _buildNavItem(Icons.shopping_cart, '', false, isCenter: true),
          _buildNavItem(Icons.inventory_2_outlined, 'Stok', false),
          _buildNavItem(Icons.person_outline, 'Profil', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, {bool isCenter = false}) {
    if (isCenter) {
      return Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: Color(0xFF42A5F5),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.shopping_cart, color: Colors.white, size: 28),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFF42A5F5) : Colors.grey[400],
          size: 26,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isActive ? const Color(0xFF42A5F5) : Colors.grey[400],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 16.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Elektronik (40%) - Biru
    paint.color = const Color(0xFF42A5F5);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2,
      math.pi * 2 * 0.4,
      false,
      paint,
    );

    // Buku (30%) - Orange
    paint.color = const Color(0xFFFF9800);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2 + math.pi * 2 * 0.4,
      math.pi * 2 * 0.3,
      false,
      paint,
    );

    // Lainnya (30%) - Purple
    paint.color = const Color(0xFF9C27B0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2 + math.pi * 2 * 0.7,
      math.pi * 2 * 0.3,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintMasuk = Paint()
      ..color = const Color(0xFF42A5F5)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final paintKeluar = Paint()
      ..color = const Color(0xFFF44336)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final pointsMasuk = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.16, size.height * 0.5),
      Offset(size.width * 0.33, size.height * 0.6),
      Offset(size.width * 0.5, size.height * 0.3),
      Offset(size.width * 0.66, size.height * 0.4),
      Offset(size.width * 0.83, size.height * 0.2),
      Offset(size.width, size.height * 0.35),
    ];

    final pointsKeluar = [
      Offset(0, size.height * 0.5),
      Offset(size.width * 0.16, size.height * 0.6),
      Offset(size.width * 0.33, size.height * 0.4),
      Offset(size.width * 0.5, size.height * 0.55),
      Offset(size.width * 0.66, size.height * 0.5),
      Offset(size.width * 0.83, size.height * 0.65),
      Offset(size.width, size.height * 0.6),
    ];

    final pathMasuk = Path()..moveTo(pointsMasuk[0].dx, pointsMasuk[0].dy);
    for (var point in pointsMasuk.skip(1)) {
      pathMasuk.lineTo(point.dx, point.dy);
    }

    final pathKeluar = Path()..moveTo(pointsKeluar[0].dx, pointsKeluar[0].dy);
    for (var point in pointsKeluar.skip(1)) {
      pathKeluar.lineTo(point.dx, point.dy);
    }

    canvas.drawPath(pathMasuk, paintMasuk);
    canvas.drawPath(pathKeluar, paintKeluar);

    // Draw dots
    final dotPaint = Paint()..style = PaintingStyle.fill;

    for (var point in pointsMasuk) {
      dotPaint.color = const Color(0xFF42A5F5);
      canvas.drawCircle(point, 4, dotPaint);
    }

    for (var point in pointsKeluar) {
      dotPaint.color = const Color(0xFFF44336);
      canvas.drawCircle(point, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}