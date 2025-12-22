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
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  String selectedSort = 'newest';

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

  // --- FUNGSI AMBIL DATA ---
  Future<void> _fetchItems({String query = ""}) async {
    setState(() => isLoading = true);
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

  // --- FUNGSI UPDATE DATA (KE PHP) ---
  Future<void> _updateItemSimple(var id, String newQty, String newPrice) async {
    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1/inventory_api/update_item_simple.php"),
        body: {"id": id.toString(), "stock": newQty, "price": newPrice},
      );

      // Cek apakah response berupa JSON
      final resData = jsonDecode(response.body);

      if (resData['success'] == true) {
        if (!mounted) return;
        Navigator.pop(context); // Tutup dialog
        _fetchItems(query: searchController.text); // Refresh data
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Berhasil diupdate!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        debugPrint("Server Error: ${resData['message']}");
      }
    } catch (e) {
      // Jika muncul FormatException, biasanya PHP kamu kirim Error HTML bukannya JSON
      debugPrint("Update error (Biasanya PHP Error): $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal Update: Cek file PHP kamu"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // --- DIALOG EDIT POP-UP ---
  void _showQuickEditDialog(Map item) {
    TextEditingController qtyController = TextEditingController(
      text: item['stock'].toString(),
    );
    TextEditingController priceController = TextEditingController(
      text: item['price'].toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Edit ${item['name']}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPopupInput(qtyController, "Jumlah Stok", Icons.inventory),
            const SizedBox(height: 15),
            _buildPopupInput(priceController, "Harga (Rp)", Icons.payments),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal", style: TextStyle(color: textGrey)),
          ),
          // TOMBOL SIMPAN YANG SUDAH DIPERBAIKI
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: accentBlue,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              _updateItemSimple(
                item['id'],
                qtyController.text,
                priceController.text,
              );
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
      ),
    );
  }

  Widget _buildPopupInput(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textGrey, fontSize: 12),
        prefixIcon: Icon(icon, color: accentBlue, size: 20),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: textGrey.withOpacity(0.3)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: accentBlue),
        ),
      ),
    );
  }

  // --- FUNGSI FILTER ---
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
        setState(() => selectedSort = value);
        _fetchItems(query: searchController.text);
        Navigator.pop(context);
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
                onChanged: (val) => _fetchItems(query: val),
              )
            : const Text(
                "Daftar Barang",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: textGrey,
            ),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  isSearching = false;
                  searchController.clear();
                  _fetchItems();
                } else {
                  isSearching = true;
                }
              });
            },
          ),
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

                return InkWell(
                  onTap: () => _showQuickEditDialog(item),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
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
                  ),
                );
              },
            ),
    );
  }
}
