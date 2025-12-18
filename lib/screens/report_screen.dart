// lib/screens/report_screen.dart
import 'package:flutter/material.dart';
import '../services/analytics_service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _startDate = '01/08/2023';
  String _endDate = '31/08/2023';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    AnalyticsService.logScreenView('Report Screen');
    
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final tabs = ['Stok', 'Penjualan', 'Pergerakan'];
        AnalyticsService.logButtonClick('report_tab_${tabs[_tabController.index]}');
      }
    });
  }

  void _generateReport() async {
    final tabs = ['stock', 'sales', 'movement'];
    final reportType = tabs[_tabController.index];
    
    await AnalyticsService.logReportGenerated(
      reportType: reportType,
      dateRange: '$_startDate - $_endDate',
      itemCount: 150,
      format: 'pdf',
    );
    
    _showSnackBar('Laporan $reportType berhasil dibuat!');
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
                      AnalyticsService.logButtonClick('report_back');
                      Navigator.pop(context);
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'Laporan',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            
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
                labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: 'Stok'),
                  Tab(text: 'Penjualan'),
                  Tab(text: 'Pergerakan'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildStockReport(),
                  _buildSalesReport(),
                  _buildMovementReport(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await AnalyticsService.logButtonClick('add_report');
          _showSnackBar('Buat laporan baru');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStockReport() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildReportTypeCard(),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(child: _buildDateField('Tanggal Mulai', _startDate, true)),
              const SizedBox(width: 12),
              Expanded(child: _buildDateField('Tanggal Selesai', _endDate, false)),
            ],
          ),
          const SizedBox(height: 16),
          
          TextButton.icon(
            onPressed: () {
              AnalyticsService.logButtonClick('advanced_filter');
            },
            icon: const Icon(Icons.filter_list, color: Colors.blue),
            label: const Text('Filter Lanjutan', style: TextStyle(color: Colors.blue)),
          ),
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A2332),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.description_outlined, size: 48, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Buat Laporan Anda',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pilih jenis laporan dan rentang tanggal,\nlalu klik tombol di bawah untuk melihat\nhasilnya.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _generateReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      'Buat Laporan',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesReport() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bar_chart, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Laporan Penjualan', style: TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _generateReport,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Generate Report'),
          ),
        ],
      ),
    );
  }

  Widget _buildMovementReport() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.trending_up, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Laporan Pergerakan', style: TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _generateReport,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Generate Report'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportTypeCard() {
    return GestureDetector(
      onTap: () {
        AnalyticsService.logButtonClick('change_report_type');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2332),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Text('Jenis Laporan', style: TextStyle(color: Colors.white, fontSize: 13)),
            Spacer(),
            Text('Stok Saat Ini', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(String label, String date, bool isStart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            AnalyticsService.logButtonClick('select_${isStart ? "start" : "end"}_date');
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2332),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(date, style: const TextStyle(color: Colors.white)),
                const Spacer(),
                const Icon(Icons.calendar_today, color: Colors.grey, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}