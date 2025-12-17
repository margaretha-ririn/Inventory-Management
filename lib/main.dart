import 'package:flutter/material.dart';

// --- IMPORT FILE TEMAN (DARI MAIN) ---
// Pastikan file 'login.dart' ini beneran ada di foldermu ya.
// Kalau nama filenya beda (misal: screens/login_screen.dart), sesuaikan baris ini.
import 'login.dart'; 

// --- IMPORT SEMUA SCREEN YANG KAMU BUAT ---
import 'screens/peminjaman_barang.dart';
import 'screens/analitik_stok.dart';
import 'screens/barcode.dart';

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
      
      // Kita pakai Theme punya KAMU karena lebih lengkap (ada background color)
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        useMaterial3: true,
      ),

      // --- PENGATURAN HALAMAN AWAL ---
      // Karena ini masih tahap develop fiturmu, kita set ke '/peminjaman' atau '/barcode' dulu.
      // Nanti kalau sudah fix semua, ganti string ini jadi '/login'
      initialRoute: '/peminjaman', 

      routes: {
        // --- ROUTE PUNYA KAMU ---
        '/peminjaman': (context) => const PeminjamanBarangScreen(),
        '/analitik': (context) => const AnalitikStokScreen(),
        '/barcode': (context) => const BarcodeScreen(),

        // --- ROUTE PUNYA TEMAN (LOGIN) ---
        // Pastikan class di dalam login.dart namanya 'LoginScreen'
        '/login': (context) => const LoginScreen(), 
      },
    );
  }
}