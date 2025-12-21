import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<dynamic> historyData = [];
  bool isLoading = true;

  // Warna UI
  final Color bgMain = const Color(0xFF0F161C);
  final Color cardDark = const Color(0xFF192229);
  final Color textWhite = Colors.white;
  final Color textGrey = const Color(0xFF8B959E);
  final Color accentBlue = const Color(0xFF00C6FF);

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    String url = "http://127.0.0.1/inventory_api/history.php";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          historyData = data['data'];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  // Format Tanggal (Contoh: 20 Okt 2023)
  String formatDate(String dateStr) {
    try {
      DateTime date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy, HH:mm').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          "Riwayat Transaksi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. FILTER TABS (Bagian Atas)
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildFilterTab("SEMUA", true),
                _buildFilterTab("MASUK", false),
                _buildFilterTab("KELUAR", false),
              ],
            ),
          ),

          // 2. TIMELINE LIST
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator(color: accentBlue))
                : historyData.isEmpty
                ? Center(
                    child: Text(
                      "Belum ada riwayat",
                      style: TextStyle(color: textGrey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    itemCount: historyData.length,
                    itemBuilder: (context, index) {
                      var item = historyData[index];
                      bool isLast = index == historyData.length - 1;
                      return _buildTimelineItem(item, isLast);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? accentBlue : cardDark,
        borderRadius: BorderRadius.circular(20),
        border: isActive ? null : Border.all(color: textGrey.withOpacity(0.3)),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : textGrey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem(Map data, bool isLast) {
    // Tentukan Warna & Icon berdasarkan Tipe Transaksi
    bool isIn = data['type'] == 'in';
    bool isOut = data['type'] == 'out';

    Color typeColor = isIn
        ? const Color(0xFF00E676)
        : (isOut ? const Color(0xFFFFC107) : Colors.blue);
    IconData typeIcon = isIn
        ? Icons.arrow_downward
        : (isOut ? Icons.arrow_upward : Icons.tune);
    String title = isIn
        ? "Barang Masuk"
        : (isOut ? "Barang Keluar" : "Penyesuaian Stok");
    String desc = isIn
        ? "Stok bertambah dari Restock/Pembelian"
        : "Barang keluar atau dipinjam user";

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BAGIAN KIRI: GARIS TIMELINE
          Column(
            children: [
              // Icon Bulat
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: cardDark,
                  shape: BoxShape.circle,
                  border: Border.all(color: typeColor, width: 2),
                ),
                child: Icon(typeIcon, color: typeColor, size: 14),
              ),
              // Garis Vertikal (Kecuali item terakhir)
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: cardDark, // Warna garis samar
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 15),

          // BAGIAN KANAN: CARD KONTEN
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF2A353E)),
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
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        formatDate(data['date']),
                        style: TextStyle(color: textGrey, fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Detail Barang
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.inventory_2_outlined,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['item_name'] ?? 'Unknown Item',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Jumlah: ${data['quantity']} Unit",
                              style: TextStyle(
                                color: typeColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  // Lokasi / Keterangan Dummy (Biar persis gambar)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: bgMain,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isIn ? Icons.login : Icons.logout,
                          color: textGrey,
                          size: 14,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            desc,
                            style: TextStyle(color: textGrey, fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
