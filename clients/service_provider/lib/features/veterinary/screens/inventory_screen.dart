import 'package:flutter/material.dart';
import '../models/veterinary_models.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Mock inventory data
  final List<InventoryItem> _inventoryItems = [
    InventoryItem(
      id: '1',
      name: 'Penicillin Injectable',
      category: 'Antibiotics',
      type: 'Medicine',
      currentStock: 25,
      minimumStock: 10,
      unit: 'vials',
      unitPrice: 150.0,
      supplier: 'VetMed Supplies',
      expiryDate: DateTime.now().add(const Duration(days: 180)),
      batchNumber: 'PEN2024001',
      description: 'Broad-spectrum antibiotic for bacterial infections',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    InventoryItem(
      id: '2',
      name: 'Foot and Mouth Vaccine',
      category: 'Vaccines',
      type: 'Vaccine',
      currentStock: 5,
      minimumStock: 15,
      unit: 'doses',
      unitPrice: 80.0,
      supplier: 'Kenya Veterinary Vaccines',
      expiryDate: DateTime.now().add(const Duration(days: 45)),
      batchNumber: 'FMD2024002',
      description: 'Vaccine for foot and mouth disease prevention',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    InventoryItem(
      id: '3',
      name: 'Disposable Syringes 10ml',
      category: 'Equipment',
      type: 'Consumable',
      currentStock: 100,
      minimumStock: 50,
      unit: 'pieces',
      unitPrice: 15.0,
      supplier: 'Medical Supplies Ltd',
      batchNumber: 'SYR2024003',
      description: 'Sterile disposable syringes for injections',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Inventory Management'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'All Items'),
            Tab(text: 'Low Stock'),
            Tab(text: 'Expiring'),
            Tab(text: 'Categories'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInventoryList(_inventoryItems),
          _buildInventoryList(_getLowStockItems()),
          _buildInventoryList(_getExpiringSoonItems()),
          _buildCategoriesView(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        backgroundColor: const Color(0xFF1976D2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  List<InventoryItem> _getLowStockItems() {
    return _inventoryItems.where((item) => item.isLowStock).toList();
  }

  List<InventoryItem> _getExpiringSoonItems() {
    return _inventoryItems.where((item) => item.isExpiringSoon).toList();
  }

  Widget _buildInventoryList(List<InventoryItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No items found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildInventoryCard(item);
      },
    );
  }

  Widget _buildInventoryCard(InventoryItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showItemDetails(item),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.category} • ${item.type}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStockStatusColor(item).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${item.currentStock} ${item.unit}',
                          style: TextStyle(
                            fontSize: 14,
                            color: _getStockStatusColor(item),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (item.isLowStock) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'LOW STOCK',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      if (item.isExpiringSoon) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'EXPIRING',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.attach_money,
                      label: 'Unit Price',
                      value: 'KSh ${item.unitPrice.toStringAsFixed(0)}',
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.business,
                      label: 'Supplier',
                      value: item.supplier ?? 'Not specified',
                    ),
                  ),
                ],
              ),
              
              if (item.expiryDate != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Expires: ${_formatDate(item.expiryDate!)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: item.isExpiringSoon ? Colors.red : Colors.grey.shade600,
                        fontWeight: item.isExpiringSoon ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
              
              if (item.batchNumber != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.qr_code,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Batch: ${item.batchNumber}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesView() {
    final categories = _inventoryItems.map((item) => item.category).toSet().toList();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final categoryItems = _inventoryItems.where((item) => item.category == category).toList();
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            title: Text(
              category,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${categoryItems.length} items'),
            children: categoryItems.map((item) => ListTile(
              title: Text(item.name),
              subtitle: Text('${item.currentStock} ${item.unit}'),
              trailing: Text('KSh ${item.unitPrice.toStringAsFixed(0)}'),
              onTap: () => _showItemDetails(item),
            )).toList(),
          ),
        );
      },
    );
  }

  Color _getStockStatusColor(InventoryItem item) {
    if (item.isLowStock) {
      return Colors.orange;
    } else if (item.currentStock > item.minimumStock * 2) {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference < 0) {
      return 'Expired';
    } else if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference < 30) {
      return '$difference days';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showItemDetails(InventoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Category: ${item.category}'),
              Text('Type: ${item.type}'),
              Text('Current Stock: ${item.currentStock} ${item.unit}'),
              Text('Minimum Stock: ${item.minimumStock} ${item.unit}'),
              Text('Unit Price: KSh ${item.unitPrice.toStringAsFixed(2)}'),
              if (item.supplier != null) Text('Supplier: ${item.supplier}'),
              if (item.expiryDate != null) Text('Expiry Date: ${_formatDate(item.expiryDate!)}'),
              if (item.batchNumber != null) Text('Batch Number: ${item.batchNumber}'),
              if (item.description != null) ...[
                const SizedBox(height: 8),
                const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(item.description!),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showUpdateStockDialog(item);
            },
            child: const Text('Update Stock'),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Item'),
        content: const Text('Add new inventory item feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showUpdateStockDialog(InventoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Stock - ${item.name}'),
        content: const Text('Update stock feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
