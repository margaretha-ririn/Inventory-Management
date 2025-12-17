import 'package:flutter/material.dart';

// --- IMPORT SEMUA SCREEN YANG SUDAH DIBUAT ---
import 'screens/peminjaman_barang.dart';
import 'screens/analitik_stok.dart';
import 'screens/barcode.dart';

// Import screen lain (Login, Dashboard, dll) biarkan dikomentar dulu
// sampai kamu benar-benar membuat filenya agar tidak error.
// import 'screens/login_screen.dart';
// import 'screens/dashboard_screen.dart';

void main() {
  runApp(const InventoryApp());
}

class InventoryApp extends StatelessWidget {
  const InventoryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Set background default agar sesuai desain
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        useMaterial3: true,
      ),

      // --- PENGATURAN HALAMAN AWAL ---
      // Ganti string ini untuk menentukan halaman mana yang muncul duluan:
      // '/peminjaman' -> Halaman Peminjaman Barang
      // '/analitik'   -> Halaman Analitik Stok
      // '/barcode'    -> Halaman Scan Barcode (Tes Kamera)
      initialRoute: '/barcode',

      routes: {
        // --- DAFTAR ROUTE YANG SUDAH JADI ---
        '/peminjaman': (context) => const PeminjamanBarangScreen(),
        '/analitik': (context) => const AnalitikStokScreen(),
        '/barcode': (context) => const BarcodeScreen(),

        // --- ROUTE LAINNYA (UNCOMMENT JIKA FILENYA SUDAH ADA) ---
        // '/login': (context) => const LoginScreen(),
        // '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
