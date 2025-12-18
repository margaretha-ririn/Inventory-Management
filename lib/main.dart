// main.dart
import 'package:flutter/material.dart';
import 'screens/login_screens.dart';
import 'screens/register_screens.dart';
import 'screens/dashboard_screens.dart';
import 'screens/warehouse_screens.dart';
import 'screens/inventory_screens.dart';
import 'screens/order_screens.dart';
import 'screens/report_screen.dart';
import 'screens/profile_screen.dart';

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
        scaffoldBackgroundColor: const Color(0xFFB8B8B8),
        brightness: Brightness.dark,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/warehouse': (context) => const WarehouseScreen(),
        '/inventory': (context) => const InventoryScreen(),
        '/orders': (context) => const OrderScreen(),
        '/reports': (context) => const ReportScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}