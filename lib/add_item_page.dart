import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  // Controller Input
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  int _qty = 1;
  String _selectedLocation = "Gudang Utama";
  final List<String> _locations = [
    "Gudang Utama",
    "Lab Mobile",
    "Lab Jaringan",
    "Ruang Dosen",
  ];

  bool _isLoading = false;

  // Warna UI
  final Color bgMain = const Color(0xFF0F161C);
  final Color cardDark = const Color(0xFF192229);
  final Color accentBlue = const Color(0xFF00C6FF);
  final Color textGrey = const Color(0xFF8B959E);

  // Fungsi Simpan Barang
  Future<void> _saveItem() async {
    if (_nameController.text.isEmpty || _skuController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Nama dan Barcode wajib diisi!"),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    String url = "http://127.0.0.1/inventory_api/add_item.php";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'name': _nameController.text,
          'sku': _skuController.text,
          'stock': _qty.toString(),
          'description': _descController.text,
          'location': _selectedLocation,
        },
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(data['message']),
          ),
        );
        Navigator.pop(context, true); // Kembali ke Dashboard & Refresh
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(data['message'])),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
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
          "Tambah Barang",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              _skuController.clear();
              _nameController.clear();
              _descController.clear();
              setState(() => _qty = 1);
            },
            child: Text("Reset", style: TextStyle(color: accentBlue)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. AREA FOTO (Placeholder)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: cardDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: textGrey.withOpacity(0.3),
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 40, color: accentBlue),
                  const SizedBox(height: 10),
                  Text("Tap to add photo", style: TextStyle(color: textGrey)),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // 2. TOMBOL SCAN & GALLERY
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {}, // Nanti dihubungkan ke Scanner
                    icon: Icon(Icons.qr_code_scanner, color: accentBlue),
                    label: Text(
                      "Scan Barcode",
                      style: TextStyle(color: accentBlue),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: accentBlue.withOpacity(0.5)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.image, color: Colors.white),
                    label: const Text(
                      "Gallery",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFFD35400,
                      ), // Warna Orange Bata sesuai UI
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // 3. FORM INPUT
            _buildLabel("Barcode ID"),
            _buildInput(_skuController, "Scan or type ID", icon: Icons.qr_code),

            const SizedBox(height: 15),
            _buildLabel("Nama Barang"),
            _buildInput(_nameController, "Contoh: Laptop Asus ROG"),

            const SizedBox(height: 15),

            // Row Jumlah & Lokasi
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Jumlah"),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: cardDark,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF2A353E)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () => setState(() {
                                if (_qty > 1) _qty--;
                              }),
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "$_qty",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () => setState(() => _qty++),
                              icon: const Icon(Icons.add, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Lokasi"),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: cardDark,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF2A353E)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedLocation,
                            dropdownColor: cardDark,
                            isDense: true,
                            isExpanded: true,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                            style: const TextStyle(color: Colors.white),
                            items: _locations.map((String loc) {
                              return DropdownMenuItem(
                                value: loc,
                                child: Text(loc),
                              );
                            }).toList(),
                            onChanged: (val) =>
                                setState(() => _selectedLocation = val!),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),
            _buildLabel("Deskripsi"),
            _buildInput(
              _descController,
              "Tambahkan catatan kondisi barang...",
              maxLines: 3,
            ),

            const SizedBox(height: 30),

            // 4. TOMBOL SIMPAN
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _saveItem,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save, color: Colors.white),
                label: Text(
                  _isLoading ? "Menyimpan..." : "Simpan Barang",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  shadowColor: accentBlue.withOpacity(0.4),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String hint, {
    IconData? icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: cardDark,
        hintText: hint,
        hintStyle: TextStyle(color: textGrey),
        prefixIcon: icon != null ? Icon(icon, color: textGrey) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2A353E)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2A353E)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentBlue),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
