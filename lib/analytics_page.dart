import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Wajib install fl_chart dulu
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  bool isLoading = true;
  Map<String, dynamic>? data;

  // Warna UI (Sesuai Desain)
  final Color bgMain = const Color(0xFF0F161C);
  final Color cardDark = const Color(0xFF192229);
  final Color accentBlue = const Color(0xFF00C6FF);
  final Color textGrey = const Color(0xFF8B959E);
  final Color alertRed = const Color(0xFFE53935);
  final Color warnYellow = const Color(0xFFFFC107);
  final Color successGreen = const Color(0xFF00E676);
  final Color purpleChart = const Color(0xFF9C27B0);

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    String url = "http://127.0.0.1/inventory_api/analytics.php";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          data = jsonDecode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() => isLoading = false);
    }
  }

  String formatRupiah(var number) {
    if (number == null) return "Rp 0";
    // Format singkatan (contoh: 15jt) biar muat di kartu kecil
    double val = double.tryParse(number.toString()) ?? 0;
    if (val >= 1000000) {
      return "Rp ${(val / 1000000).toStringAsFixed(1)}jt";
    }
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return currencyFormatter.format(val);
  }

  @override
  Widget build(BuildContext context) {
    var stats = data?['stats'];
    var topProducts = data?['top_products'] as List?;
    var lowStockList = data?['low_stock_list'] as List?;

    return Scaffold(
      backgroundColor: bgMain,
      appBar: AppBar(
        backgroundColor: bgMain,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Analitik Stok",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: cardDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: accentBlue),
                const SizedBox(width: 6),
                Text(
                  "Bulan Ini",
                  style: TextStyle(
                    color: accentBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: accentBlue))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. GRID STATISTIK (4 KARTU)
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.4,
                    children: [
                      _buildStatCard(
                        "Total Nilai",
                        formatRupiah(stats?['total_asset']),
                        Icons.monetization_on,
                        accentBlue,
                      ),
                      _buildStatCard(
                        "Stok Rendah",
                        "${stats?['low_stock']} Item",
                        Icons.warning_amber_rounded,
                        warnYellow,
                        isAlert: true,
                      ),
                      _buildStatCard(
                        "Total Produk",
                        "${stats?['total_items']}",
                        Icons.inventory_2,
                        purpleChart,
                      ),
                      _buildStatCard(
                        "Habis",
                        "${stats?['out_of_stock']} Item",
                        Icons.remove_shopping_cart,
                        alertRed,
                        isAlert: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // 2. CHART DISTRIBUSI KATEGORI
                  const Text(
                    "Distribusi Kategori",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardDark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        // Pie Chart
                        SizedBox(
                          height: 120,
                          width: 120,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 0,
                              centerSpaceRadius: 40,
                              sections: [
                                PieChartSectionData(
                                  color: accentBlue,
                                  value: 40,
                                  title: "40%",
                                  radius: 15,
                                  titleStyle: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  color: warnYellow,
                                  value: 30,
                                  title: "30%",
                                  radius: 15,
                                  titleStyle: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  color: purpleChart,
                                  value: 30,
                                  title: "30%",
                                  radius: 15,
                                  titleStyle: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Legend
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLegend(accentBlue, "Elektronik", "40%"),
                              const SizedBox(height: 10),
                              _buildLegend(warnYellow, "Buku & Alat", "30%"),
                              const SizedBox(height: 10),
                              _buildLegend(purpleChart, "Lainnya", "30%"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 3. PERLU PERHATIAN (Stok Menipis)
                  const Text(
                    "Perlu Perhatian",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  if (lowStockList != null)
                    ...lowStockList.map(
                      (item) => _buildAttentionItem(
                        item['name'],
                        item['stock'].toString(),
                      ),
                    ),

                  const SizedBox(height: 25),

                  // 4. PRODUK TERLARIS (Top 3)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Produk Terlaris",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Lihat Semua",
                        style: TextStyle(color: accentBlue, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: cardDark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: topProducts == null || topProducts.isEmpty
                          ? [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  "Belum ada penjualan",
                                  style: TextStyle(color: textGrey),
                                ),
                              ),
                            ]
                          : topProducts.asMap().entries.map((entry) {
                              int idx = entry.key + 1;
                              var prod = entry.value;
                              return _buildTopProductItem(
                                idx,
                                prod['name'],
                                prod['category'] ?? 'Umum',
                                prod['sold'],
                              );
                            }).toList(),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    bool isAlert = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(color: textGrey, fontSize: 10)),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isAlert)
            Row(
              children: [
                Icon(Icons.error_outline, color: alertRed, size: 12),
                const SizedBox(width: 4),
                Text(
                  "Perlu Restok",
                  style: TextStyle(
                    color: alertRed,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          else
            Text(
              "+12% naik",
              style: TextStyle(color: successGreen, fontSize: 10),
            ),
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, String label, String percent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        Text(
          percent,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildAttentionItem(String name, String stock) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgMain,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: alertRed.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: alertRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.inventory, color: alertRed, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Sisa Stok: $stock",
                    style: TextStyle(color: alertRed, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: alertRed.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Restok",
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
  }

  Widget _buildTopProductItem(
    int rank,
    String name,
    String category,
    String sold,
  ) {
    Color rankColor = rank == 1
        ? const Color(0xFFFFD700)
        : (rank == 2 ? const Color(0xFFC0C0C0) : const Color(0xFFCD7F32));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: rankColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Text(
              "$rank",
              style: TextStyle(
                color: rankColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.devices, color: Colors.white70, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(category, style: TextStyle(color: textGrey, fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                sold,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text("Terjual", style: TextStyle(color: textGrey, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}
