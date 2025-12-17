import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Pastikan import ini sesuai dengan nama project kamu di pubspec.yaml
import 'package:inventory_management/main.dart';

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    // Ganti MyApp() menjadi InventoryApp()
    await tester.pumpWidget(const InventoryApp());

    // Kita cuma cek apakah aplikasi berhasil di-build tanpa crash
    // Tidak usah cek angka 0 atau tombol +, karena fiturnya sudah beda.
  });
}
