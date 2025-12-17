import 'package:flutter/material.dart';

class PeminjamanBarangScreen extends StatefulWidget {
  const PeminjamanBarangScreen({Key? key}) : super(key: key);

  @override
  State<PeminjamanBarangScreen> createState() => _PeminjamanBarangScreenState();
}

class _PeminjamanBarangScreenState extends State<PeminjamanBarangScreen> {
  // --- STATE VARIABLES ---
  int _selectedTabIndex = 0; // 0 = Active Loans, 1 = History
  int _bottomNavIndex = 0;
  bool _isAscendingSort = true;
  String _searchQuery = ''; // Untuk menyimpan text pencarian

  // --- DATA DUMMY ---
  // Kita tambahkan status 'returned' untuk simulasi history
  List<LoanItemModel> allLoanItems = [
    LoanItemModel(
      id: '1',
      itemName: 'MacBook Pro M1',
      borrowerName: 'Siti Aminah',
      imageUrl: 'https://picsum.photos/id/1/100/100',
      dueDate: DateTime(2023, 10, 20),
      status: LoanStatus.overdue,
    ),
    LoanItemModel(
      id: '2',
      itemName: 'Arduino Uno Kit',
      borrowerName: 'Budi Santoso',
      imageUrl: 'https://picsum.photos/id/2/100/100',
      dueDate: DateTime(2023, 10, 25),
      status: LoanStatus.active,
    ),
    LoanItemModel(
      id: '3',
      itemName: 'Samsung S21 Test Device',
      borrowerName: 'Ahmad Rizky',
      imageUrl: 'https://picsum.photos/id/3/100/100',
      dueDate: DateTime(2023, 10, 30),
      status: LoanStatus.active,
    ),
    LoanItemModel(
      id: '4',
      itemName: 'Projector Epson',
      borrowerName: 'Dewi Lestari',
      imageUrl: 'https://picsum.photos/id/4/100/100',
      dueDate: DateTime(2023, 10, 18),
      status: LoanStatus.overdue,
    ),
    // Item History (Sudah dikembalikan)
    LoanItemModel(
      id: '5',
      itemName: 'DSLR Canon 5D',
      borrowerName: 'Rina Nose',
      imageUrl: 'https://picsum.photos/id/5/100/100',
      dueDate: DateTime(2023, 9, 10),
      status: LoanStatus.returned,
    ),
    LoanItemModel(
      id: '6',
      itemName: 'Wacom Tablet',
      borrowerName: 'Eko Patrio',
      imageUrl: 'https://picsum.photos/id/6/100/100',
      dueDate: DateTime(2023, 9, 15),
      status: LoanStatus.returned,
    ),
  ];

  // --- LOGIC FUNCTIONS ---

  // Mendapatkan list yang sudah difilter (berdasarkan Tab & Search)
  List<LoanItemModel> get filteredItems {
    // 1. Filter by Tab (Active/Overdue vs Returned)
    List<LoanItemModel> items;
    if (_selectedTabIndex == 0) {
      items = allLoanItems
          .where((item) => item.status != LoanStatus.returned)
          .toList();
    } else {
      items = allLoanItems
          .where((item) => item.status == LoanStatus.returned)
          .toList();
    }

    // 2. Filter by Search Query
    if (_searchQuery.isNotEmpty) {
      items = items.where((item) {
        final query = _searchQuery.toLowerCase();
        return item.itemName.toLowerCase().contains(query) ||
            item.borrowerName.toLowerCase().contains(query);
      }).toList();
    }

    // 3. Sorting
    items.sort((a, b) {
      if (_isAscendingSort) {
        return a.dueDate.compareTo(b.dueDate);
      } else {
        return b.dueDate.compareTo(a.dueDate);
      }
    });

    return items;
  }

  void _handleMarkReturned(String id) {
    setState(() {
      final index = allLoanItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        // Ubah status jadi returned (pindah ke tab History)
        allLoanItems[index].status = LoanStatus.returned;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item moved to History'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color kPrimaryBlue = Color(0xFF2F80ED);
    const Color kOverdueRed = Color(0xFFFFE5E5);
    const Color kOverdueTextRed = Color(0xFFD32F2F);
    const Color kBgColor = Color(0xFFF5F7FA);

    // Hitung statistik realtime
    int activeCount = allLoanItems
        .where(
          (i) =>
              i.status == LoanStatus.active || i.status == LoanStatus.overdue,
        )
        .length;
    int overdueCount = allLoanItems
        .where((i) => i.status == LoanStatus.overdue)
        .length;

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        title: const Text(
          'Peminjaman Barang',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black54),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filter feature clicked')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // --- SEARCH BAR (AKTIF) ---
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search item or student name...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- SUMMARY CARDS (DYNAMIC COUNT) ---
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    title: 'DIPINJAM',
                    count: activeCount.toString(),
                    icon: Icons.inventory_2_outlined,
                    iconColor: Colors.blue,
                    bgColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    title: 'TERLAMBAT',
                    count: overdueCount.toString(),
                    icon: Icons.warning_amber_rounded,
                    iconColor: kOverdueTextRed,
                    bgColor: kOverdueRed,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- TAB SWITCHER (Active Loans / History) ---
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildTabButton(0, 'Active Loans'),
                  _buildTabButton(1, 'History'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- HEADER & SORT ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedTabIndex == 0 ? 'Current Loans' : 'Loan History',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isAscendingSort = !_isAscendingSort;
                    });
                  },
                  icon: Icon(
                    _isAscendingSort
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    size: 16,
                    color: Colors.blueGrey,
                  ),
                  label: const Text(
                    'Sort by: Due Date',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // --- LIST VIEW (FILTERED) ---
            Expanded(
              child: filteredItems.isEmpty
                  ? Center(
                      child: Text(
                        "No items found",
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredItems.length,
                      padding: const EdgeInsets.only(
                        bottom: 80,
                      ), // Padding bawah agar tidak tertutup FAB
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return _buildLoanCard(item);
                      },
                    ),
            ),
          ],
        ),
      ),

      // --- TOMBOL + (FAB) DIPERBAIKI POSISINYA ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Add Loan clicked')));
        },
        backgroundColor: kPrimaryBlue,
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
      ),
      // Menggunakan standard location (pojok kanan bawah, floating) agar tidak merusak navbar
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // --- BOTTOM NAVIGATION BAR (SIMETRIS) ---
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _bottomNavIndex,
        selectedItemColor: kPrimaryBlue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type:
            BottomNavigationBarType.fixed, // Memastikan jarak antar item tetap
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_outlined),
            label: 'Loans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: 'Items',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Students',
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildTabButton(int index, String text) {
    bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String count,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            count,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanCard(LoanItemModel item) {
    const Color kPrimaryBlue = Color(0xFF2F80ED);
    const Color kOverdueTextRed = Color(0xFFD32F2F);
    const Color kOverdueRed = Color(0xFFFFE5E5);
    const Color kActiveGreenText = Color(0xFF2E7D32);
    const Color kActiveGreenBg = Color(0xFFE8F5E9);

    bool isOverdue = item.status == LoanStatus.overdue;
    bool isReturned = item.status == LoanStatus.returned;
    String formattedDate = "${item.dueDate.day} Oct ${item.dueDate.year}";

    Color statusBgColor;
    Color statusTextColor;
    String statusText;
    Color stripColor;

    if (isReturned) {
      statusBgColor = Colors.grey[200]!;
      statusTextColor = Colors.grey[600]!;
      statusText = 'RETURNED';
      stripColor = Colors.grey;
    } else if (isOverdue) {
      statusBgColor = kOverdueRed;
      statusTextColor = kOverdueTextRed;
      statusText = 'OVERDUE';
      stripColor = kOverdueTextRed;
    } else {
      statusBgColor = kActiveGreenBg;
      statusTextColor = kActiveGreenText;
      statusText = 'ACTIVE';
      stripColor = kPrimaryBlue;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 6, color: stripColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.itemName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Borrowed by',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  item.borrowerName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusBgColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              statusText,
                              style: TextStyle(
                                color: statusTextColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.grey[200], height: 1),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 16,
                                color: isOverdue
                                    ? kOverdueTextRed
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Due: $formattedDate',
                                style: TextStyle(
                                  color: isOverdue
                                      ? kOverdueTextRed
                                      : Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          // Hanya tampilkan tombol Mark Returned jika barang belum dikembalikan
                          if (!isReturned)
                            InkWell(
                              onTap: () => _handleMarkReturned(item.id),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'Mark Returned',
                                  style: TextStyle(
                                    color: kPrimaryBlue,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- ENUM & MODEL BARU ---
enum LoanStatus { active, overdue, returned }

class LoanItemModel {
  final String id;
  final String itemName;
  final String borrowerName;
  final String imageUrl;
  final DateTime dueDate;
  LoanStatus status; // Field baru

  LoanItemModel({
    required this.id,
    required this.itemName,
    required this.borrowerName,
    required this.imageUrl,
    required this.dueDate,
    required this.status,
  });
}
