import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/stat_card.dart';

class UsersScreen extends ConsumerStatefulWidget {
  final String? userType;

  const UsersScreen({
    super.key,
    this.userType,
  });

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedStatus = 'all';

  final List<String> _userTypes = [
    'All Users',
    'Farmers',
    'Service Providers',
    'Veterinarians',
    'Buyers',
    'Vendors',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _userTypes.length, vsync: this);
    
    // Set initial tab based on userType parameter
    if (widget.userType != null) {
      final index = _getTabIndexForUserType(widget.userType!);
      if (index != -1) {
        _tabController.index = index;
      }
    }
  }

  int _getTabIndexForUserType(String userType) {
    switch (userType) {
      case 'farmer':
        return 1;
      case 'service_provider':
        return 2;
      case 'veterinarian':
        return 3;
      case 'buyer':
        return 4;
      case 'vendor':
        return 5;
      default:
        return 0;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header with stats
          _buildHeader(),
          
          // Filters and search
          _buildFilters(),
          
          // Tabs
          _buildTabs(),
          
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _userTypes.map((type) => _buildUserList(type)).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddUserDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add User'),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Management',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          
          // Stats cards
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= AppConstants.desktopBreakpoint;
              final crossAxisCount = isDesktop ? 5 : 3;
              
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: AppConstants.defaultPadding,
                mainAxisSpacing: AppConstants.defaultPadding,
                childAspectRatio: 1.8,
                children: [
                  StatCard(
                    title: 'Total Users',
                    value: '12,543',
                    icon: Icons.people,
                    color: AppTheme.primarySwatch,
                  ),
                  StatCard(
                    title: 'Farmers',
                    value: '8,234',
                    icon: Icons.agriculture,
                    color: Colors.green,
                  ),
                  StatCard(
                    title: 'Service Providers',
                    value: '2,156',
                    icon: Icons.business,
                    color: Colors.blue,
                  ),
                  StatCard(
                    title: 'Veterinarians',
                    value: '1,432',
                    icon: Icons.medical_services,
                    color: Colors.red,
                  ),
                  StatCard(
                    title: 'Active Today',
                    value: '3,421',
                    icon: Icons.online_prediction,
                    color: Colors.orange,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: Row(
        children: [
          // Search
          Expanded(
            flex: 2,
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search users...',
                prefixIcon: Icon(Icons.search),
                isDense: true,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          const SizedBox(width: AppConstants.defaultPadding),
          
          // Status filter
          DropdownButton<String>(
            value: _selectedStatus,
            items: const [
              DropdownMenuItem(value: 'all', child: Text('All Status')),
              DropdownMenuItem(value: 'active', child: Text('Active')),
              DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
              DropdownMenuItem(value: 'suspended', child: Text('Suspended')),
              DropdownMenuItem(value: 'pending', child: Text('Pending')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedStatus = value!;
              });
            },
          ),
          const SizedBox(width: AppConstants.defaultPadding),
          
          // Export button
          OutlinedButton.icon(
            onPressed: _exportUsers,
            icon: const Icon(Icons.download),
            label: const Text('Export'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabs: _userTypes.map((type) => Tab(text: type)).toList(),
      ),
    );
  }

  Widget _buildUserList(String userType) {
    return Card(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      child: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 800,
        columns: const [
          DataColumn2(label: Text('Name'), size: ColumnSize.L),
          DataColumn2(label: Text('Email'), size: ColumnSize.L),
          DataColumn2(label: Text('Phone'), size: ColumnSize.M),
          DataColumn2(label: Text('Location'), size: ColumnSize.M),
          DataColumn2(label: Text('Status'), size: ColumnSize.S),
          DataColumn2(label: Text('Joined'), size: ColumnSize.M),
          DataColumn2(label: Text('Actions'), size: ColumnSize.S),
        ],
        rows: _generateUserRows(userType),
      ),
    );
  }

  List<DataRow> _generateUserRows(String userType) {
    // Mock data - replace with actual data from provider
    return List.generate(10, (index) {
      return DataRow(
        cells: [
          DataCell(
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  child: Text('${index + 1}'),
                ),
                const SizedBox(width: 8),
                Text('User ${index + 1}'),
              ],
            ),
          ),
          DataCell(Text('user${index + 1}@example.com')),
          DataCell(Text('+254712345${index.toString().padLeft(3, '0')}')),
          DataCell(Text(AppConstants.kenyanCounties[index % AppConstants.kenyanCounties.length])),
          DataCell(_buildStatusChip(index % 4)),
          DataCell(Text('${index + 1} days ago')),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () => _editUser(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 18),
                  onPressed: () => _deleteUser(index),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildStatusChip(int statusIndex) {
    final statuses = ['Active', 'Inactive', 'Suspended', 'Pending'];
    final colors = [Colors.green, Colors.grey, Colors.red, Colors.orange];
    
    return Chip(
      label: Text(
        statuses[statusIndex],
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: colors[statusIndex].withOpacity(0.2),
      labelStyle: TextStyle(color: colors[statusIndex]),
    );
  }

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User'),
        content: const Text('Add user functionality coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _editUser(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit user ${index + 1} - Coming soon')),
    );
  }

  void _deleteUser(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete User ${index + 1}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User deleted successfully')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _exportUsers() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export functionality coming soon')),
    );
  }
}
