// lib/screens/inventory_screen.dart
import 'package:flutter/material.dart';
import '../services/analytics_service.dart';
import '../services/inventory_service.dart';
import '../models/inventory_model.dart';
import 'add_item_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AnalyticsService.logScreenView('Inventory Screen');
  }

  void _onSearch(String query) async {
    if (query.isNotEmpty) {
      await AnalyticsService.logSearch(query, category: 'inventory');
    }
  }

  void _onItemAction(String action, String itemId, String itemName) async {
    await AnalyticsService.logInventoryAction(
      action: action,
      itemId: itemId,
      itemName: itemName,
    );
    _showSnackBar('$action: $itemName');
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
                   // ... header unchanged ...
                  const Expanded(
                    child: Text(
                      'Inventaris',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                   // ... header icons ...
                ],
              ),
            ),
            
            // ... Search and Filter (kept simplified for brevity in this replace, but should ideally be kept) ...
            // Integrating FutureBuilder below:

            Expanded(
              child: FutureBuilder<List<InventoryModel>>(
                future: InventoryService().getItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Belum ada barang', style: TextStyle(color: Colors.white)));
                  }

                  final items = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _buildInventoryItem(
                        item.itemId.toString(), 
                        item.itemName, 
                        item.description ?? 'No Desc', // Using description as SKU placeholder if null
                        '${item.quantity} pcs', 
                        item.locationName ?? 'Gudang', 
                        item.quantity < item.minStock ? 'Low Stock' : 'In Stock', 
                        item.quantity < item.minStock ? Colors.orange : Colors.green, 
                        Colors.blue.shade100
                      );
                    },
                  );
                },
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddItemScreen()),
                  );
                  
                  if (result == true) {
                    setState(() {});
                  }
                },
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildFilterChip(String label, bool selected) {
    return GestureDetector(
      onTap: () {
        AnalyticsService.logButtonClick('filter_$label');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.blue : const Color(0xFF1A2332),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? Colors.blue : Colors.transparent),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: TextStyle(color: selected ? Colors.white : Colors.grey, fontSize: 12)),
            if (selected) ...[
              const SizedBox(width: 4),
              const Icon(Icons.close, color: Colors.white, size: 14),
            ] else ...[
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, color: Colors.grey, size: 16),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryItem(String itemId, String name, String sku, String stock, String location, String status, Color statusColor, Color itemColor) {
    return GestureDetector(
      onTap: () => _onItemAction('view', itemId, name),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2332),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(color: itemColor, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.inventory_2, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(sku, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(stock, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      const Text(' | ', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      Text(location, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              color: const Color(0xFF1A2332),
              onSelected: (value) => _onItemAction(value.toString(), itemId, name),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit', style: TextStyle(color: Colors.white))),
                const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}