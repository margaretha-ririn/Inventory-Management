import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  List<dynamic> items = [];
  bool isLoading = true;
  String errorMessage = "";

  // --- STATE SEARCH & FILTER ---
  bool isSearching = false; // Mode cari aktif/tidak
  TextEditingController searchController = TextEditingController();
  String selectedSort = 'newest'; // Default filter: Terbaru

  // Warna UI
  final Color bgMain = const Color(0xFF0F161C);
  final Color cardDark = const Color(0xFF192229);
  final Color accentBlue = const Color(0xFF00C6FF);
  final Color textGrey = const Color(0xFF8B959E);
  final Color alertRed = const Color(0xFFE53935);
  final Color successGreen = const Color(0xFF00E676);

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  // --- FUNGSI AMBIL DATA (PINTAR) ---
  Future<void> _fetchItems({String query = ""}) async {
    setState(() => isLoading = true);

    // Kirim parameter search & sort ke PHP
    String url =
        "http://127.0.0.1/inventory_api/items.php?search=$query&sort=$selectedSort";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          items = data['data'];
          isLoading = false;
          errorMessage = "";
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Koneksi Gagal: $e";
      });
    }
  }

  // --- FUNGSI TAMPILKAN FILTER ---
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Urutkan Berdasarkan",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              _buildFilterOption("Terbaru Ditambahkan", 'newest'),
              _buildFilterOption("Stok Paling Sedikit", 'low_stock'),
              _buildFilterOption("Harga: Rendah ke Tinggi", 'lowest_price'),
              _buildFilterOption("Harga: Tinggi ke Rendah", 'highest_price'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String label, String value) {
    bool isSelected = selectedSort == value;
    return ListTile(
      title: Text(
        label,
        style: TextStyle(color: isSelected ? accentBlue : Colors.white),
      ),
      trailing: isSelected ? Icon(Icons.check, color: accentBlue) : null,
      onTap: () {
        setState(() => selectedSort = value); // Ubah filter
        _fetchItems(query: searchController.text); // Refresh data
        Navigator.pop(context); // Tutup modal
      },
    );
  }

  String formatRupiah(var number) {
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
      appBar: AppBar(
        backgroundColor: bgMain,
        elevation: 0,
        automaticallyImplyLeading: false,
        // --- LOGIKA JUDUL SEARCH BAR ---
        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Cari nama / SKU...",
                  hintStyle: TextStyle(color: textGrey),
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  // Otomatis cari saat ngetik (Delay dikit biar smooth)
                  _fetchItems(query: val);
                },
              )
            : const Text(
                "Daftar Barang",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

        actions: [
          // TOMBOL SEARCH
          IconButton(
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: textGrey,
            ),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  // Kalau ditutup, reset pencarian
                  isSearching = false;
                  searchController.clear();
                  _fetchItems(); // Ambil semua data lagi
                } else {
                  isSearching = true;
                }
              });
            },
          ),
          // TOMBOL FILTER
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: selectedSort == 'newest' ? textGrey : accentBlue,
            ),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: accentBlue))
          : errorMessage.isNotEmpty
          ? Center(
              child: Text(errorMessage, style: TextStyle(color: alertRed)),
            )
          : items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 60,
                    color: textGrey.withOpacity(0.3),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Barang tidak ditemukan",
                    style: TextStyle(color: textGrey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: items.length,
              itemBuilder: (context, index) {
                var item = items[index];
                int stock = int.tryParse(item['stock'].toString()) ?? 0;
                double price = double.tryParse(item['price'].toString()) ?? 0;
                bool isLow = stock <= 5;

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF2A353E)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isLow
                              ? alertRed.withOpacity(0.1)
                              : accentBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.inventory_2_outlined,
                          color: isLow ? alertRed : accentBlue,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'] ?? "Tanpa Nama",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "SKU: ${item['sku']}",
                              style: TextStyle(color: textGrey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatRupiah(price),
                            style: TextStyle(
                              color: accentBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isLow
                                  ? alertRed.withOpacity(0.2)
                                  : successGreen.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isLow ? "Stok: $stock" : "$stock Unit",
                              style: TextStyle(
                                color: isLow ? alertRed : successGreen,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
