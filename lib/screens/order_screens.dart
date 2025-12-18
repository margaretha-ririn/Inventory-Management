// lib/screens/order_screen.dart
import 'package:flutter/material.dart';
import '../services/analytics_service.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    AnalyticsService.logScreenView('Order Screen');
    
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final tabs = ['Semua', 'Tertunda', 'Diproses', 'Dikirim'];
        AnalyticsService.logButtonClick('order_tab_${tabs[_tabController.index]}');
      }
    });
  }

  void _onSearch(String query) async {
    if (query.isNotEmpty) {
      await AnalyticsService.logSearch(query, category: 'orders');
    }
  }

  void _onOrderClick(String orderId, String customer, double amount) async {
    await AnalyticsService.logButtonClick('view_order_details', parameters: {
      'order_id': orderId,
      'customer': customer,
      'amount': amount,
    });
    _showSnackBar('Membuka detail pesanan $orderId');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      AnalyticsService.logButtonClick('order_back');
                      Navigator.pop(context);
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'Pesanan',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearch,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Cari berdasarkan ID, Pelanggan...',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1A2332),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2332),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.blue,
                indicatorWeight: 3,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: 'Semua'),
                  Tab(text: 'Tertunda'),
                  Tab(text: 'Diproses'),
                  Tab(text: 'Dikirim'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOrdersList(),
                  _buildOrdersList(),
                  _buildOrdersList(),
                  _buildOrdersList(),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: FloatingActionButton(
                onPressed: () async {
                  await AnalyticsService.logButtonClick('create_new_order');
                  
                  // Simulate order creation
                  await AnalyticsService.logOrderCreated(
                    orderId: 'INV-2024-${DateTime.now().millisecondsSinceEpoch}',
                    totalAmount: 2500000,
                    itemCount: 5,
                    customerName: 'PT Maju Mundur',
                  );
                  
                  _showSnackBar('Pesanan baru dibuat');
                },
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildOrderItem('INV-2023-1024', '28 Okt 2023', 'PT Maju Mundur', 'Rp 2,500,000', 'Selesai', Colors.green, 2500000),
        _buildOrderItem('INV-2023-1025', '25 Okt 2023', 'Toko Sejahtera', 'Rp 1,500,000', 'Tertunda', Colors.orange, 1500000),
        _buildOrderItem('INV-2023-1026', '24 Okt 2023', 'CV Berkah Abadi', 'Rp 8,750,000', 'Diproses', Colors.blue, 8750000),
        _buildOrderItem('INV-2023-1027', '23 Okt 2023', 'Warung Pak Budi', 'Rp 500,000', 'Dibatalkan', Colors.red, 500000),
      ],
    );
  }

  Widget _buildOrderItem(String orderId, String date, String customer, String total, String status, Color statusColor, double amount) {
    return GestureDetector(
      onTap: () => _onOrderClick(orderId, customer, amount),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2332),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(orderId, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 8),
            Text(customer, style: const TextStyle(color: Colors.white, fontSize: 13)),
            const SizedBox(height: 8),
            Text('Total: $total', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}