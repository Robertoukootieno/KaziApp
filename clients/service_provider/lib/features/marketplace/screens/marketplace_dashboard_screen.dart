import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/marketplace_models.dart';
import 'product_management_screen.dart';
import 'order_management_screen.dart';
import 'inventory_screen.dart';
import 'customer_management_screen.dart';
import 'analytics_screen.dart';
import 'promotions_screen.dart';
import '../../../widgets/profile_app_bar.dart';

class MarketplaceDashboardScreen extends StatefulWidget {
  const MarketplaceDashboardScreen({super.key});

  @override
  State<MarketplaceDashboardScreen> createState() => _MarketplaceDashboardScreenState();
}

class _MarketplaceDashboardScreenState extends State<MarketplaceDashboardScreen> {
  // Mock data for dashboard
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Maize Seeds - Hybrid 614',
      description: 'High-yield hybrid maize seeds suitable for all seasons',
      category: ProductCategory.seeds,
      status: ProductStatus.active,
      price: 450.0,
      discountPrice: 400.0,
      unit: 'kg',
      stockQuantity: 150,
      minStockLevel: 20,
      brand: 'Kenya Seed',
      imageUrls: ['assets/images/maize_seeds.jpg'],
      tags: ['hybrid', 'high-yield', 'drought-resistant'],
      specifications: {'variety': 'Hybrid 614', 'maturity': '120 days'},
      isFeatured: true,
      rating: 4.5,
      reviewCount: 23,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Product(
      id: '2',
      name: 'NPK Fertilizer 17:17:17',
      description: 'Balanced NPK fertilizer for optimal crop growth',
      category: ProductCategory.fertilizers,
      status: ProductStatus.active,
      price: 3200.0,
      unit: '50kg bag',
      stockQuantity: 45,
      minStockLevel: 10,
      brand: 'Yara',
      imageUrls: ['assets/images/npk_fertilizer.jpg'],
      tags: ['balanced', 'npk', 'crop-nutrition'],
      specifications: {'N': '17%', 'P': '17%', 'K': '17%'},
      isFeatured: false,
      rating: 4.2,
      reviewCount: 18,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  final List<Order> _recentOrders = [
    Order(
      id: 'ORD001',
      customerId: 'cust1',
      customerName: 'John Mwangi',
      customerPhone: '+254712345678',
      customerEmail: 'john@example.com',
      items: [],
      subtotal: 4500.0,
      taxAmount: 720.0,
      shippingFee: 200.0,
      discountAmount: 0.0,
      totalAmount: 5420.0,
      status: OrderStatus.confirmed,
      paymentMethod: 'M-Pesa',
      paymentStatus: 'paid',
      shippingAddress: 'Kiambu, Kenya',
      orderDate: DateTime.now().subtract(const Duration(hours: 2)),
      confirmedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Order(
      id: 'ORD002',
      customerId: 'cust2',
      customerName: 'Mary Wanjiku',
      customerPhone: '+254723456789',
      customerEmail: 'mary@example.com',
      items: [],
      subtotal: 3200.0,
      taxAmount: 512.0,
      shippingFee: 150.0,
      discountAmount: 200.0,
      totalAmount: 3662.0,
      status: OrderStatus.processing,
      paymentMethod: 'Bank Transfer',
      paymentStatus: 'paid',
      shippingAddress: 'Nakuru, Kenya',
      orderDate: DateTime.now().subtract(const Duration(hours: 5)),
      confirmedAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: ProfileAppBar(
        title: 'Marketplace Dashboard',
        backgroundColor: const Color(0xFF1976D2),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Show notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Show settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.store,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome to Your Marketplace',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Manage your products, orders, and grow your business',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Statistics Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Products',
                    '${_products.length}',
                    Icons.inventory,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Active Orders',
                    '${_recentOrders.where((o) => o.status != OrderStatus.delivered && o.status != OrderStatus.cancelled).length}',
                    Icons.shopping_cart,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Low Stock Items',
                    '${_products.where((p) => p.isLowStock).length}',
                    Icons.warning,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Today\'s Revenue',
                    'KSh ${_calculateTodayRevenue().toStringAsFixed(0)}',
                    Icons.attach_money,
                    Colors.green,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                _buildQuickActionCard(
                  'Products',
                  Icons.inventory_2,
                  Colors.blue,
                  () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductManagementScreen())),
                ),
                _buildQuickActionCard(
                  'Orders',
                  Icons.receipt_long,
                  Colors.orange,
                  () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderManagementScreen())),
                ),
                _buildQuickActionCard(
                  'Inventory',
                  Icons.warehouse,
                  Colors.purple,
                  () => Navigator.push(context, MaterialPageRoute(builder: (context) => const InventoryScreen())),
                ),
                _buildQuickActionCard(
                  'Customers',
                  Icons.people,
                  Colors.teal,
                  () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerManagementScreen())),
                ),
                _buildQuickActionCard(
                  'Analytics',
                  Icons.analytics,
                  Colors.indigo,
                  () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AnalyticsScreen())),
                ),
                _buildQuickActionCard(
                  'Promotions',
                  Icons.local_offer,
                  Colors.pink,
                  () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PromotionsScreen())),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Recent Orders
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Orders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderManagementScreen())),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentOrders.take(3).length,
              itemBuilder: (context, index) {
                final order = _recentOrders[index];
                return _buildOrderCard(order);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductManagementScreen())),
        backgroundColor: const Color(0xFF1976D2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: order.status.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(order.status.icon, color: order.status.color, size: 20),
        ),
        title: Text('Order ${order.id}'),
        subtitle: Text('${order.customerName} • ${DateFormat('MMM dd, HH:mm').format(order.orderDate)}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'KSh ${order.totalAmount.toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: order.status.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                order.status.displayName,
                style: TextStyle(
                  fontSize: 10,
                  color: order.status.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          // Show order details
        },
      ),
    );
  }

  double _calculateTodayRevenue() {
    final today = DateTime.now();
    return _recentOrders
        .where((order) => 
            order.orderDate.day == today.day &&
            order.orderDate.month == today.month &&
            order.orderDate.year == today.year &&
            order.status == OrderStatus.delivered)
        .fold(0.0, (sum, order) => sum + order.totalAmount);
  }
}
