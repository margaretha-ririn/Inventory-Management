// screens/dashboard_screen.dart
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dasbor',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Text
                    const Text(
                      'Selamat datang!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Stats Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Total Barang',
                            '1,240',
                            Colors.transparent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Nilai Inventaris',
                            'Rp186jt',
                            Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Low Stock Warning
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3D2410),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.warning_amber, color: Colors.orange, size: 24),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Stok Rendah',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '15 Items',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            context,
                            'Pindai Barang',
                            Icons.qr_code_scanner,
                            Colors.blue,
                            () {},
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildActionButton(
                            context,
                            'Tambah Barang',
                            Icons.add_box_outlined,
                            const Color(0xFF1A2332),
                            () => Navigator.pushNamed(context, '/inventory'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            context,
                            'Buat Pesanan',
                            Icons.description_outlined,
                            const Color(0xFF1A2332),
                            () => Navigator.pushNamed(context, '/orders'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildActionButton(
                            context,
                            'Lihat Laporan',
                            Icons.bar_chart,
                            const Color(0xFF1A2332),
                            () => Navigator.pushNamed(context, '/reports'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Stock Section
                    const Text(
                      'Stok Hampir Habis',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildStockItem(
                      'Kopi Arabika Gayo',
                      'Sisa: 5 buah',
                      'Pesan',
                      Colors.blue,
                    ),
                    _buildStockItem(
                      'Teh Hijau Organik',
                      'Sisa: 8 buah',
                      'Pesan',
                      Colors.blue,
                    ),
                    _buildStockItem(
                      'Gula Aren Cair',
                      'Sisa: 3 botol',
                      'Pesan',
                      Colors.blue,
                    ),
                    const SizedBox(height: 24),
                    
                    // Recent Activity
                    const Text(
                      'Aktivitas Terkini',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildActivityItem(
                      Icons.inventory_2,
                      'Stok diperbarui untuk \'Kopi Robusta\'',
                      '2 jam yang lalu',
                      Colors.blue,
                    ),
                    _buildActivityItem(
                      Icons.shopping_cart,
                      'Pesanan #PO-2024-051 baru dibuat',
                      '5 jam yang lalu',
                      Colors.blue,
                    ),
                    _buildActivityItem(
                      Icons.add_box,
                      '\'Susu Oat\' ditambahkan ke inventaris',
                      '1 hari yang lalu',
                      Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom Navigation
            _buildBottomNav(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockItem(String name, String stock, String action, Color actionColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.brown,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.coffee, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  stock,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(action, style: TextStyle(color: actionColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(IconData icon, String text, String time, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.dashboard, 'Dasbor', true, () {}),
          _buildNavItem(Icons.inventory_2_outlined, 'Inventaris', false,
              () => Navigator.pushNamed(context, '/inventory')),
          _buildNavItem(Icons.shopping_cart_outlined, 'Pesanan', false,
              () => Navigator.pushNamed(context, '/orders')),
          _buildNavItem(Icons.bar_chart, 'Laporan', false,
              () => Navigator.pushNamed(context, '/reports')),
          _buildNavItem(Icons.person_outline, 'Profil', false,
              () => Navigator.pushNamed(context, '/profile')),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: active ? Colors.blue : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.blue : Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}