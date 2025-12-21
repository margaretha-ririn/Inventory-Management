import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

// --- IMPORT HALAMAN LAIN ---
import 'barcode_page.dart';
import 'history_page.dart';
import 'add_item_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // --- Variabel Data ---
  Map<String, dynamic>? dashboardData;
  bool isLoadingDashboard = true;
  bool isError = false;

  // --- Variabel Search ---
  TextEditingController _searchController = TextEditingController();
  List<dynamic> searchResults = [];
  bool isSearching = false;
  bool isLoadingSearch = false;
  int _selectedIndex = 0;

  // --- Warna UI (Dark Theme) ---
  final Color bgMain = const Color(0xFF0F161C);
  final Color cardBlue1 = const Color(0xFF007AFF);
  final Color cardBlue2 = const Color(0xFF00C6FF);
  final Color textWhite = Colors.white;
  final Color textGrey = const Color(0xFF8B959E);
  final Color cardDark = const Color(0xFF192229);
  final Color alertRed = const Color(0xFFE53935);
  final Color accentGreen = const Color(0xFF00E676);

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  // 1. FUNGSI AMBIL DATA DASHBOARD
  Future<void> _fetchDashboardData() async {
    String url = "http://127.0.0.1/inventory_api/dashboard.php";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          dashboardData = jsonDecode(response.body);
          isLoadingDashboard = false;
          isError = false;
        });
      } else {
        throw Exception("Gagal load data");
      }
    } catch (e) {
      print("Error dashboard: $e");
      setState(() {
        isLoadingDashboard = false;
        isError = true;
      });
    }
  }

  // 2. FUNGSI PENCARIAN
  Future<void> _searchItems(String query) async {
    if (query.isEmpty) {
      setState(() {
        isSearching = false;
        searchResults = [];
      });
      return;
    }

    setState(() {
      isSearching = true;
      isLoadingSearch = true;
    });

    String url = "http://127.0.0.1/inventory_api/search.php?query=$query";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          searchResults = data['data'];
          isLoadingSearch = false;
        });
      }
    } catch (e) {
      setState(() => isLoadingSearch = false);
    }
  }

  // 3. FUNGSI RESTOCK (UPDATE STOK)
  Future<void> _submitRestock(String id, String qty) async {
    String url = "http://127.0.0.1/inventory_api/restock.php";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {'id': id, 'quantity': qty},
      );
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(data['message']),
          ),
        );
        _fetchDashboardData(); // Refresh Dashboard otomatis
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(data['message'])),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  // 4. DIALOG RESTOCK
  Future<void> _showRestockDialog(String id, String name) async {
    TextEditingController qtyController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: cardDark,
          title: const Text(
            "Restock Barang",
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tambah stok untuk:",
                style: TextStyle(color: textGrey, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                style: TextStyle(
                  color: cardBlue2,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: bgMain,
                  hintText: "Masukkan jumlah (misal: 10)",
                  hintStyle: TextStyle(color: textGrey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Batal", style: TextStyle(color: textGrey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: accentGreen),
              onPressed: () async {
                if (qtyController.text.isNotEmpty) {
                  await _submitRestock(id, qtyController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "Simpan",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // 5. POP-UP NOTIFIKASI
  void _showNotifications() {
    List lowStockItems =
        (dashboardData != null && dashboardData!['low_stock'] != null)
        ? dashboardData!['low_stock']
        : [];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 400,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardDark,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: textGrey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(
                    Icons.notifications_active_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Notifikasi Stok",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: lowStockItems.isEmpty
                    ? Center(
                        child: Text(
                          "Aman! Tidak ada stok menipis.",
                          style: TextStyle(color: textGrey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: lowStockItems.length,
                        itemBuilder: (context, index) {
                          var item = lowStockItems[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: bgMain,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: alertRed.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: alertRed,
                                  size: 30,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Sisa Stok: ${item['stock']} Unit",
                                        style: TextStyle(
                                          color: textGrey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: alertRed.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "Segera Restock",
                                    style: TextStyle(
                                      color: alertRed,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  String formatRupiah(var number) {
    if (number == null) return "Rp 0";
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return currencyFormatter.format(double.tryParse(number.toString()) ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgMain,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER & SEARCH BAR ---
            Container(
              padding: const EdgeInsets.all(20),
              color: bgMain,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                              "https://i.pravatar.cc/150?img=12",
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "DASHBOARD",
                                style: TextStyle(
                                  color: textGrey,
                                  fontSize: 10,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Row(
                                children: [
                                  Text(
                                    "Halo, Mahasiswa",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text("👋", style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: _showNotifications,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: cardDark,
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            children: [
                              Icon(
                                Icons.notifications_outlined,
                                color: textGrey,
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _searchController,
                    style: TextStyle(color: textWhite),
                    onChanged: (value) => _searchItems(value),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: cardDark,
                      hintText: "Cari barang, SKU...",
                      hintStyle: TextStyle(color: textGrey),
                      prefixIcon: Icon(Icons.search, color: textGrey),
                      suffixIcon: isSearching
                          ? IconButton(
                              icon: const Icon(Icons.close, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                _searchItems("");
                                FocusScope.of(context).unfocus();
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // --- KONTEN ---
            Expanded(
              child: isSearching
                  ? _buildSearchResults()
                  : _buildDashboardContent(),
            ),
          ],
        ),
      ),

      // --- FAB SCANNER ---
      floatingActionButton: Container(
        height: 65,
        width: 65,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: cardBlue2.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BarcodePage()),
            );
          },
          backgroundColor: cardBlue2,
          shape: const CircleBorder(),
          elevation: 0,
          child: const Icon(
            Icons.qr_code_scanner,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // --- BOTTOM NAVBAR ---
      bottomNavigationBar: BottomAppBar(
        color: cardDark,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.grid_view_rounded, "Beranda", 0),
              _buildNavItem(Icons.inventory_2_outlined, "Barang", 1),
              const SizedBox(width: 40),
              _buildNavItem(Icons.insert_chart_outlined, "Laporan", 2),
              _buildNavItem(Icons.settings_outlined, "Setting", 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    if (isLoadingDashboard)
      return Center(child: CircularProgressIndicator(color: cardBlue1));
    if (isError || dashboardData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 10),
            Text("Gagal memuat data", style: TextStyle(color: textGrey)),
            TextButton(
              onPressed: _fetchDashboardData,
              child: const Text("Coba Lagi"),
            ),
          ],
        ),
      );
    }

    var stats = dashboardData?['stats'];
    var lowStock = dashboardData?['low_stock'] as List?;
    var activity = dashboardData?['recent_activity'] as List?;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          // Total Aset Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [cardBlue1, cardBlue2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: cardBlue1.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Total Aset",
                          style: TextStyle(
                            color: textWhite.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          Icons.info_outline,
                          color: textWhite.withOpacity(0.7),
                          size: 16,
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.inventory_2,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  formatRupiah(stats?['total_asset']),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildSubStat(
                      "Total Barang",
                      "${stats?['total_items'] ?? 0} Unit",
                    ),
                    const SizedBox(width: 15),
                    _buildSubStat(
                      "Kategori",
                      "${stats?['total_cat'] ?? 0} Jenis",
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // AKSI CEPAT (GRID MENU)
          const Text(
            "Aksi Cepat",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionIcon(
                Icons.qr_code_scanner,
                "Scan",
                Colors.indigoAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BarcodePage(),
                    ),
                  );
                },
              ),
              _buildActionIcon(
                Icons.add_box_outlined,
                "Tambah",
                Colors.teal,
                onTap: () async {
                  // Navigasi dan tunggu hasilnya (apakah ada barang baru?)
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddItemPage(),
                    ),
                  );

                  // Kalau sukses nambah barang, refresh dashboard otomatis
                  if (result == true) {
                    _fetchDashboardData();
                  }
                },
              ),

              // --- NAVIGASI KE RIWAYAT ---
              _buildActionIcon(
                Icons.history,
                "Riwayat",
                Colors.purple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryPage(),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 30),
          // LOW STOCK LIST
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.amber,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Perlu Perhatian",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                "Lihat Semua",
                style: TextStyle(
                  color: cardBlue2,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 170,
            child: (lowStock == null || lowStock.isEmpty)
                ? Center(
                    child: Text(
                      "Semua stok aman!",
                      style: TextStyle(color: textGrey),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: lowStock.length,
                    itemBuilder: (context, index) {
                      var item = lowStock[index];
                      return _buildAlertCard(
                        item['id'].toString(),
                        item['name'],
                        item['sku'],
                        item['stock'].toString(),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 30),

          // RECENT ACTIVITY
          const Row(
            children: [
              Icon(
                Icons.history_toggle_off,
                color: Colors.purpleAccent,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                "Aktivitas Terbaru",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          (activity == null || activity.isEmpty)
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Belum ada aktivitas",
                      style: TextStyle(color: textGrey),
                    ),
                  ),
                )
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: activity.length,
                  itemBuilder: (context, index) {
                    var act = activity[index];
                    return _buildActivityItem(act);
                  },
                ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // --- WIDGET HELPER ---
  Widget _buildSearchResults() {
    if (isLoadingSearch)
      return Center(child: CircularProgressIndicator(color: cardBlue2));
    if (searchResults.isEmpty)
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: textGrey.withOpacity(0.3)),
            const SizedBox(height: 10),
            Text("Tidak ditemukan barang.", style: TextStyle(color: textGrey)),
          ],
        ),
      );
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        var item = searchResults[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF2A353E)),
          ),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: cardBlue1.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.inventory_2_outlined, color: cardBlue2),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "SKU: ${item['sku']}",
                        style: TextStyle(color: textGrey, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatRupiah(item['price']),
                    style: TextStyle(
                      color: cardBlue2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Stok: ${item['stock']}",
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubStat(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: textWhite.withOpacity(0.8), fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Update: Tambahkan onTap
  Widget _buildActionIcon(
    IconData icon,
    String label,
    Color color, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: cardDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF2A353E)),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: textGrey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildAlertCard(String id, String name, String sku, String stock) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: alertRed.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.block, color: alertRed, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                "STOK HABIS",
                style: TextStyle(
                  color: alertRed,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tersedia: $stock Unit",
                style: TextStyle(color: textGrey, fontSize: 12),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "SKU: $sku",
                  style: TextStyle(color: textGrey, fontSize: 10),
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _showRestockDialog(id, name),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: alertRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: alertRed.withOpacity(0.3)),
              ),
              child: Center(
                child: Text(
                  "Restock Segera",
                  style: TextStyle(
                    color: alertRed,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map act) {
    bool isOut = act['type'] == 'out';
    bool isIn = act['type'] == 'in';
    Color color = isOut ? alertRed : (isIn ? accentGreen : Colors.amber);
    String symbol = isOut ? "-" : (isIn ? "+" : "");
    String status = isOut ? "Keluar" : (isIn ? "Masuk" : "Penyesuaian");
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isOut ? Icons.output : Icons.input,
              color: textGrey,
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  act['item_name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "$status • Baru saja",
                      style: TextStyle(color: textGrey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "$symbol${act['quantity']}",
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("Qty", style: TextStyle(color: textGrey, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? cardBlue2 : textGrey, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? cardBlue2 : textGrey,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
