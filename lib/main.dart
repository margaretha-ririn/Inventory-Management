import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // PENTING: Untuk pengaturan Mouse
import 'login_page.dart';

void main() {
  runApp(const MyApp());
}

// 1. CLASS KHUSUS: Agar bisa scroll pakai Mouse (Drag) di Windows
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory App',

      // 2. TERAPKAN SCROLL BEHAVIOR DI SINI
      scrollBehavior: MyCustomScrollBehavior(),

      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F161C),
        useMaterial3: true,

        // 3. JURUS ANTI-CRASH (Disable Tooltip Hover)
        // Kita set durasi tunggunya jadi setahun, jadi tooltip gak akan pernah trigger otomatis
        // Ini mencegah Flutter bingung melacak posisi mouse saat ganti halaman
        tooltipTheme: const TooltipThemeData(
          waitDuration: Duration(days: 365),
          showDuration: Duration(milliseconds: 0),
          triggerMode: TooltipTriggerMode.manual,
        ),
      ),
      home: const LoginPage(),
    );
  }
}
