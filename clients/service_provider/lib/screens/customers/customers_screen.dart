import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../services/services.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen>
    with SingleTickerProviderStateMixin {
  final CustomerService _customerService = CustomerService();

  late TabController _tabController;
  List<Customer> _customers = [];
  List<Customer> _filteredCustomers = [];
  bool _isLoading = true;
  String _searchQuery = '';
  CustomerType? _typeFilter;
  String _sortBy = 'name'; // name, totalSpent, lastBooking

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadCustomers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final customers = await _customerService.getCustomers();
      setState(() {
        _customers = customers;
        _filteredCustomers = customers;
        _isLoading = false;
      });
      _sortCustomers();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading customers: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filterCustomers() {
    setState(() {
      _filteredCustomers = _customers.where((customer) {
        // Search filter
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          if (!customer.name.toLowerCase().contains(query) &&
              !customer.email.toLowerCase().contains(query) &&
              !customer.phoneNumber.contains(_searchQuery) &&
              !customer.location.toLowerCase().contains(query)) {
            return false;
          }
        }

        // Type filter
        if (_typeFilter != null && customer.customerType != _typeFilter) {
          return false;
        }

        return true;
      }).toList();
    });
    _sortCustomers();
  }

  void _sortCustomers() {
    setState(() {
      switch (_sortBy) {
        case 'name':
          _filteredCustomers.sort((a, b) => a.name.compareTo(b.name));
          break;
        case 'totalSpent':
          _filteredCustomers.sort((a, b) => b.totalSpent.compareTo(a.totalSpent));
          break;
        case 'lastBooking':
          _filteredCustomers.sort((a, b) {
            if (a.lastBookingDate == null && b.lastBookingDate == null) return 0;
            if (a.lastBookingDate == null) return 1;
            if (b.lastBookingDate == null) return -1;
            return b.lastBookingDate!.compareTo(a.lastBookingDate!);
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.list), text: 'All'),
            Tab(icon: Icon(Icons.star), text: 'Top'),
            Tab(icon: Icon(Icons.schedule), text: 'Recent'),
            Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _showFilterDialog,
            icon: const Icon(Icons.filter_list),
          ),
          IconButton(
            onPressed: _showSortDialog,
            icon: const Icon(Icons.sort),
          ),
          IconButton(
            onPressed: _loadCustomers,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildAllCustomersTab(),
                _buildTopCustomersTab(),
                _buildRecentCustomersTab(),
                _buildAnalyticsTab(),
              ],
            ),
    );
  }

  Widget _buildAllCustomersTab() {
    return Column(
      children: [
        // Search Bar
        Container(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search customers...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              _filterCustomers();
            },
          ),
        ),

        // Customers List
        Expanded(
          child: _filteredCustomers.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadCustomers,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredCustomers.length,
                    itemBuilder: (context, index) {
                      final customer = _filteredCustomers[index];
                      return _buildCustomerCard(customer);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildTopCustomersTab() {
    final topCustomers = _customers
        .where((c) => c.totalSpent > 0)
        .toList()
      ..sort((a, b) => b.totalSpent.compareTo(a.totalSpent));

    return topCustomers.isEmpty
        ? _buildEmptyState('No customer data available')
        : RefreshIndicator(
            onRefresh: _loadCustomers,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: topCustomers.take(20).length,
              itemBuilder: (context, index) {
                final customer = topCustomers[index];
                return _buildCustomerCard(
                  customer,
                  showRank: true,
                  rank: index + 1,
                );
              },
            ),
          );
  }

  Widget _buildRecentCustomersTab() {
    final recentCustomers = _customers
        .where((c) => c.lastBookingDate != null)
        .toList()
      ..sort((a, b) => b.lastBookingDate!.compareTo(a.lastBookingDate!));

    return recentCustomers.isEmpty
        ? _buildEmptyState('No recent customer activity')
        : RefreshIndicator(
            onRefresh: _loadCustomers,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: recentCustomers.take(20).length,
              itemBuilder: (context, index) {
                final customer = recentCustomers[index];
                return _buildCustomerCard(customer, showLastBooking: true);
              },
            ),
          );
  }

  Widget _buildAnalyticsTab() {
    if (_customers.isEmpty) {
      return _buildEmptyState('No customer data for analytics');
    }

    final totalCustomers = _customers.length;
    final activeCustomers = _customers.where((c) => c.isActive).length;
    final totalRevenue = _customers.fold(0.0, (sum, c) => sum + c.totalSpent);
    final averageSpend = totalRevenue / totalCustomers;

    final customersByType = <CustomerType, int>{};
    for (final type in CustomerType.values) {
      customersByType[type] = _customers.where((c) => c.customerType == type).length;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Customers',
                  totalCustomers.toString(),
                  Icons.people,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Active Customers',
                  activeCustomers.toString(),
                  Icons.how_to_reg,
                  Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Revenue',
                  'KSh ${totalRevenue.toStringAsFixed(0)}',
                  Icons.attach_money,
                  const Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Avg. Spend',
                  'KSh ${averageSpend.toStringAsFixed(0)}',
                  Icons.trending_up,
                  Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Customer Types
          const Text(
            'Customer Types',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          ...customersByType.entries.map((entry) {
            final percentage = totalCustomers > 0
                ? (entry.value / totalCustomers * 100)
                : 0.0;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(entry.key.icon, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.key.displayName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        '${entry.value} (${percentage.toStringAsFixed(1)}%)',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyState([String? message]) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            message ?? 'No customers found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Customers will appear here when they book your services',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(
    Customer customer, {
    bool showRank = false,
    int? rank,
    bool showLastBooking = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showCustomerDetails(customer),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (showRank && rank != null) ...[
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: _getRankColor(rank).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          '#$rank',
                          style: TextStyle(
                            color: _getRankColor(rank),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],

                  CircleAvatar(
                    backgroundColor: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                    child: Text(
                      customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          customer.customerType.displayName,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'KSh ${customer.totalSpent.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      Text(
                        '${customer.totalBookings} bookings',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Icon(
                    Icons.phone,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    customer.phoneNumber,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      customer.location,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              if (showLastBooking && customer.lastBookingDate != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Last booking: ${DateFormat('MMM d, y').format(customer.lastBookingDate!)}',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],

              if (customer.farmDetails != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.agriculture,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${customer.farmDetails!.farmSize} acres',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                    if (customer.farmDetails!.cropTypes.isNotEmpty) ...[
                      const SizedBox(width: 16),
                      Icon(
                        Icons.eco,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          customer.farmDetails!.cropTypes.take(2).join(', '),
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return const Color(0xFF2E7D32);
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Customers'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Filter by customer type:'),
            const SizedBox(height: 16),
            ...CustomerType.values.map((type) {
              final isSelected = _typeFilter == type;
              return ListTile(
                title: Row(
                  children: [
                    Text(type.icon, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Text(type.displayName),
                  ],
                ),
                leading: Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: isSelected ? const Color(0xFF2E7D32) : Colors.grey,
                ),
                onTap: () {
                  setState(() {
                    _typeFilter = type;
                  });
                },
              );
            }),
            ListTile(
              title: const Text('All Types'),
              leading: Icon(
                _typeFilter == null ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: _typeFilter == null ? const Color(0xFF2E7D32) : Colors.grey,
              ),
              onTap: () {
                setState(() {
                  _typeFilter = null;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _filterCustomers();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort Customers'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Name (A-Z)'),
              leading: Icon(
                _sortBy == 'name' ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: _sortBy == 'name' ? const Color(0xFF2E7D32) : Colors.grey,
              ),
              onTap: () {
                setState(() {
                  _sortBy = 'name';
                });
              },
            ),
            ListTile(
              title: const Text('Total Spent (High to Low)'),
              leading: Icon(
                _sortBy == 'totalSpent' ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: _sortBy == 'totalSpent' ? const Color(0xFF2E7D32) : Colors.grey,
              ),
              onTap: () {
                setState(() {
                  _sortBy = 'totalSpent';
                });
              },
            ),
            ListTile(
              title: const Text('Last Booking (Recent First)'),
              leading: Icon(
                _sortBy == 'lastBooking' ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: _sortBy == 'lastBooking' ? const Color(0xFF2E7D32) : Colors.grey,
              ),
              onTap: () {
                setState(() {
                  _sortBy = 'lastBooking';
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _sortCustomers();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showCustomerDetails(Customer customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerDetailsScreen(customer: customer),
      ),
    );
  }
}

// Placeholder for CustomerDetailsScreen - would be implemented separately
class CustomerDetailsScreen extends StatelessWidget {
  final Customer customer;

  const CustomerDetailsScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(customer.name),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Customer Details - To be implemented'),
      ),
    );
  }
}
