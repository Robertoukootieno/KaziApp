import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/service_provider.dart';
import '../../../../shared/widgets/stat_card.dart';

class ServiceProviderManagementScreen extends ConsumerStatefulWidget {
  const ServiceProviderManagementScreen({super.key});

  @override
  ConsumerState<ServiceProviderManagementScreen> createState() => _ServiceProviderManagementScreenState();
}

class _ServiceProviderManagementScreenState extends ConsumerState<ServiceProviderManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  ServiceProviderType? _selectedType;
  VerificationStatus? _selectedStatus;

  final List<String> _tabs = [
    'All Providers',
    'Verification Queue',
    'Performance Analytics',
    'Documents Review',
    'Compliance Monitor',
  ];

  // Mock data for demonstration
  final List<ServiceProvider> _mockProviders = [];
  final List<VerificationRequest> _mockVerificationRequests = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _generateMockData();
  }

  void _generateMockData() {
    // Generate mock service providers
    for (int i = 1; i <= 20; i++) {
      _mockProviders.add(ServiceProvider(
        id: 'sp_$i',
        userId: 'user_$i',
        email: 'provider$i@example.com',
        firstName: 'Provider',
        lastName: '$i',
        phoneNumber: '+254712345${i.toString().padLeft(3, '0')}',
        profilePicture: '',
        providerType: ServiceProviderType.values[i % ServiceProviderType.values.length],
        verificationStatus: VerificationStatus.values[i % VerificationStatus.values.length],
        businessRegistration: BusinessRegistration(
          businessName: 'Business $i',
          registrationNumber: 'REG$i',
          taxId: 'TAX$i',
          businessType: 'LLC',
          registrationCountry: 'Kenya',
          registrationState: 'Nairobi',
          registrationCity: 'Nairobi',
          registrationDate: DateTime.now().subtract(Duration(days: i * 30)),
        ),
        qualifications: [],
        services: [],
        documents: [],
        performanceMetrics: PerformanceMetrics(
          providerId: 'sp_$i',
          totalBookings: i * 10,
          completedBookings: i * 8,
          cancelledBookings: i * 2,
          completionRate: 80.0 + (i % 20),
          averageRating: 3.0 + (i % 3),
          totalReviews: i * 5,
          responseTime: 2.0 + (i % 5),
          onTimeRate: 85.0 + (i % 15),
          repeatCustomers: i * 3,
          revenue: i * 1000.0,
          lastUpdated: DateTime.now(),
        ),
        serviceAreas: ['Nairobi', 'Kiambu'],
        address: 'Address $i',
        city: 'Nairobi',
        state: 'Nairobi',
        country: 'Kenya',
        postalCode: '00100',
        isActive: i % 4 != 0,
        isAvailable: i % 3 != 0,
        joinedAt: DateTime.now().subtract(Duration(days: i * 30)),
      ));
    }

    // Generate mock verification requests
    for (int i = 1; i <= 10; i++) {
      _mockVerificationRequests.add(VerificationRequest(
        id: 'vr_$i',
        providerId: 'sp_$i',
        providerName: 'Provider $i',
        providerEmail: 'provider$i@example.com',
        providerType: ServiceProviderType.values[i % ServiceProviderType.values.length],
        status: VerificationStatus.values[i % 3], // Only pending, under_review, verified
        documentIds: ['doc_${i}_1', 'doc_${i}_2'],
        requestedBy: 'provider$i@example.com',
        requestedAt: DateTime.now().subtract(Duration(days: i)),
        priority: i % 3 + 1,
      ));
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
          _buildHeader(),
          _buildTabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllProvidersTab(),
                _buildVerificationQueueTab(),
                _buildPerformanceAnalyticsTab(),
                _buildDocumentsReviewTab(),
                _buildComplianceMonitorTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.business_center,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service Provider Management',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'Manage verification, performance monitoring, and compliance for service providers',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          _buildStatsCards(),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    final totalProviders = _mockProviders.length;
    final verifiedProviders = _mockProviders.where((p) => p.verificationStatus == VerificationStatus.verified).length;
    final pendingVerification = _mockProviders.where((p) => p.verificationStatus == VerificationStatus.pending).length;
    final activeProviders = _mockProviders.where((p) => p.isActive).length;
    final suspendedProviders = _mockProviders.where((p) => p.verificationStatus == VerificationStatus.suspended).length;
    
    return LayoutBuilder(
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
              title: 'Total Providers',
              value: totalProviders.toString(),
              icon: Icons.business,
              color: AppTheme.primarySwatch,
            ),
            StatCard(
              title: 'Verified',
              value: verifiedProviders.toString(),
              icon: Icons.verified,
              color: Colors.green,
            ),
            StatCard(
              title: 'Pending Verification',
              value: pendingVerification.toString(),
              icon: Icons.pending,
              color: Colors.orange,
            ),
            StatCard(
              title: 'Active',
              value: activeProviders.toString(),
              icon: Icons.check_circle,
              color: Colors.blue,
            ),
            StatCard(
              title: 'Suspended',
              value: suspendedProviders.toString(),
              icon: Icons.block,
              color: Colors.red,
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  Widget _buildAllProvidersTab() {
    return Column(
      children: [
        _buildFilters(),
        Expanded(
          child: Card(
            margin: const EdgeInsets.all(AppConstants.defaultPadding),
            child: _buildProvidersTable(),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search providers...',
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
          DropdownButton<ServiceProviderType?>(
            hint: const Text('All Types'),
            value: _selectedType,
            items: [
              const DropdownMenuItem<ServiceProviderType?>(value: null, child: Text('All Types')),
              ...ServiceProviderType.values.map((type) => DropdownMenuItem(
                value: type,
                child: Text(ServiceProviderHelper.getProviderTypeLabel(type)),
              )),
            ],
            onChanged: (type) {
              setState(() {
                _selectedType = type;
              });
            },
          ),
          const SizedBox(width: AppConstants.defaultPadding),
          DropdownButton<VerificationStatus?>(
            hint: const Text('All Status'),
            value: _selectedStatus,
            items: [
              const DropdownMenuItem<VerificationStatus?>(value: null, child: Text('All Status')),
              ...VerificationStatus.values.map((status) => DropdownMenuItem(
                value: status,
                child: Text(ServiceProviderHelper.getVerificationStatusLabel(status)),
              )),
            ],
            onChanged: (status) {
              setState(() {
                _selectedStatus = status;
              });
            },
          ),
          const SizedBox(width: AppConstants.defaultPadding),
          OutlinedButton.icon(
            onPressed: _exportProviders,
            icon: const Icon(Icons.download),
            label: const Text('Export'),
          ),
        ],
      ),
    );
  }

  Widget _buildProvidersTable() {
    final filteredProviders = _mockProviders.where((provider) {
      if (_searchQuery.isNotEmpty && 
          !provider.firstName.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !provider.lastName.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !provider.email.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      if (_selectedType != null && provider.providerType != _selectedType) {
        return false;
      }
      if (_selectedStatus != null && provider.verificationStatus != _selectedStatus) {
        return false;
      }
      return true;
    }).toList();

    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 1200,
      columns: const [
        DataColumn2(label: Text('Provider'), size: ColumnSize.L),
        DataColumn2(label: Text('Type'), size: ColumnSize.M),
        DataColumn2(label: Text('Status'), size: ColumnSize.S),
        DataColumn2(label: Text('Rating'), size: ColumnSize.S),
        DataColumn2(label: Text('Bookings'), size: ColumnSize.S),
        DataColumn2(label: Text('Revenue'), size: ColumnSize.M),
        DataColumn2(label: Text('Joined'), size: ColumnSize.M),
        DataColumn2(label: Text('Actions'), size: ColumnSize.M),
      ],
      rows: filteredProviders.map((provider) => _buildProviderRow(provider)).toList(),
    );
  }

  DataRow _buildProviderRow(ServiceProvider provider) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: provider.profilePicture.isNotEmpty
                    ? NetworkImage(provider.profilePicture)
                    : null,
                child: provider.profilePicture.isEmpty
                    ? Text('${provider.firstName[0]}${provider.lastName[0]}')
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${provider.firstName} ${provider.lastName}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      provider.email,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            ServiceProviderHelper.getProviderTypeLabel(provider.providerType),
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell(_buildStatusChip(provider.verificationStatus)),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star,
                size: 16,
                color: Colors.amber,
              ),
              const SizedBox(width: 4),
              Text(
                provider.performanceMetrics.averageRating.toStringAsFixed(1),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            provider.performanceMetrics.totalBookings.toString(),
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell(
          Text(
            'KSh ${provider.performanceMetrics.revenue.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell(
          Text(
            _formatDate(provider.joinedAt),
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.visibility, size: 18),
                onPressed: () => _viewProvider(provider),
                tooltip: 'View Details',
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 18),
                onPressed: () => _editProvider(provider),
                tooltip: 'Edit',
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 18),
                onSelected: (action) => _handleProviderAction(provider, action),
                itemBuilder: (context) => [
                  if (provider.verificationStatus == VerificationStatus.pending)
                    const PopupMenuItem(value: 'verify', child: Text('Verify')),
                  if (provider.isActive)
                    const PopupMenuItem(value: 'suspend', child: Text('Suspend'))
                  else
                    const PopupMenuItem(value: 'activate', child: Text('Activate')),
                  const PopupMenuItem(value: 'message', child: Text('Send Message')),
                  const PopupMenuItem(value: 'analytics', child: Text('View Analytics')),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(VerificationStatus status) {
    Color color;
    switch (status) {
      case VerificationStatus.verified:
        color = Colors.green;
        break;
      case VerificationStatus.pending:
        color = Colors.orange;
        break;
      case VerificationStatus.underReview:
        color = Colors.blue;
        break;
      case VerificationStatus.rejected:
        color = Colors.red;
        break;
      case VerificationStatus.suspended:
        color = Colors.red;
        break;
      case VerificationStatus.expired:
        color = Colors.grey;
        break;
    }
    
    return Chip(
      label: Text(
        ServiceProviderHelper.getVerificationStatusLabel(status),
        style: const TextStyle(fontSize: 10),
      ),
      backgroundColor: color.withValues(alpha: 0.2),
      labelStyle: TextStyle(color: color),
    );
  }

  Widget _buildVerificationQueueTab() {
    return const Center(child: Text('Verification Queue - Coming Soon'));
  }

  Widget _buildPerformanceAnalyticsTab() {
    return const Center(child: Text('Performance Analytics - Coming Soon'));
  }

  Widget _buildDocumentsReviewTab() {
    return const Center(child: Text('Documents Review - Coming Soon'));
  }

  Widget _buildComplianceMonitorTab() {
    return const Center(child: Text('Compliance Monitor - Coming Soon'));
  }

  Widget? _buildFloatingActionButton() {
    final currentTab = _tabController.index;
    
    switch (currentTab) {
      case 0: // All Providers
        return FloatingActionButton.extended(
          onPressed: _addProvider,
          icon: const Icon(Icons.add),
          label: const Text('Add Provider'),
        );
      default:
        return null;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else {
      return 'Today';
    }
  }

  void _viewProvider(ServiceProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${provider.firstName} ${provider.lastName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${ServiceProviderHelper.getProviderTypeLabel(provider.providerType)}'),
            Text('Status: ${ServiceProviderHelper.getVerificationStatusLabel(provider.verificationStatus)}'),
            Text('Rating: ${provider.performanceMetrics.averageRating.toStringAsFixed(1)}'),
            Text('Total Bookings: ${provider.performanceMetrics.totalBookings}'),
            Text('Revenue: KSh ${provider.performanceMetrics.revenue.toStringAsFixed(0)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _editProvider(ServiceProvider provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${provider.firstName} ${provider.lastName} - Coming soon')),
    );
  }

  void _handleProviderAction(ServiceProvider provider, String action) {
    switch (action) {
      case 'verify':
        _verifyProvider(provider);
        break;
      case 'suspend':
        _suspendProvider(provider);
        break;
      case 'activate':
        _activateProvider(provider);
        break;
      case 'message':
        _sendMessage(provider);
        break;
      case 'analytics':
        _viewAnalytics(provider);
        break;
    }
  }

  void _verifyProvider(ServiceProvider provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Verify ${provider.firstName} ${provider.lastName} - Coming soon')),
    );
  }

  void _suspendProvider(ServiceProvider provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Suspend ${provider.firstName} ${provider.lastName} - Coming soon')),
    );
  }

  void _activateProvider(ServiceProvider provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Activate ${provider.firstName} ${provider.lastName} - Coming soon')),
    );
  }

  void _sendMessage(ServiceProvider provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Send message to ${provider.firstName} ${provider.lastName} - Coming soon')),
    );
  }

  void _viewAnalytics(ServiceProvider provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View analytics for ${provider.firstName} ${provider.lastName} - Coming soon')),
    );
  }

  void _addProvider() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add provider functionality coming soon')),
    );
  }

  void _exportProviders() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export functionality coming soon')),
    );
  }
}
