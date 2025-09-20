import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/permission_manager.dart';
import '../../../../shared/models/service_provider.dart';
import '../../../../shared/models/admin_user.dart';
import '../../../../shared/services/service_provider_service.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../providers/service_provider_providers.dart';
import '../widgets/service_provider_details_dialog.dart';
import '../widgets/service_provider_filters_widget.dart';
import '../widgets/service_provider_stats_cards.dart';
import '../widgets/verification_workflow_widget.dart';
import '../widgets/performance_analytics_widget.dart';
import '../widgets/compliance_monitor_widget.dart';
import '../widgets/bulk_actions_widget.dart';

class AdvancedServiceProviderManagementScreen extends ConsumerStatefulWidget {
  const AdvancedServiceProviderManagementScreen({super.key});

  @override
  ConsumerState<AdvancedServiceProviderManagementScreen> createState() =>
      _AdvancedServiceProviderManagementScreenState();
}

class _AdvancedServiceProviderManagementScreenState
    extends ConsumerState<AdvancedServiceProviderManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final Set<String> _selectedProviders = {};
  ServiceProviderSearchFilters _currentFilters = const ServiceProviderSearchFilters();

  final List<String> _tabs = [
    'All Providers',
    'Verification Queue',
    'Performance Analytics',
    'Documents Review',
    'Compliance Monitor',
    'Service Catalog',
    'Quality Assurance',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    ref.read(serviceProviderListProvider.notifier).loadProviders();
    ref.read(serviceProviderStatisticsProvider.notifier).loadStatistics();
    ref.read(verificationQueueProvider.notifier).loadQueue();
    ref.read(complianceMetricsProvider.notifier).loadMetrics();
  }

  @override
  Widget build(BuildContext context) {
    final permissionManager = ref.watch(permissionManagerProvider);
    
    // Check permissions
    if (!permissionManager.checkCategoryAccess(PermissionCategory.serviceProviderManagement).granted) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('Access Denied'),
              Text('You don\'t have permission to access service provider management.'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildStatsSection(),
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
                _buildServiceCatalogTab(),
                _buildQualityAssuranceTab(),
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
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.business, size: 32, color: Color(0xFF1976D2)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Service Provider Management',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Manage service providers, verification, and quality assurance',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const Spacer(),
          if (_selectedProviders.isNotEmpty) ...[
            BulkActionsWidget(
              selectedCount: _selectedProviders.length,
              onBulkVerify: _handleBulkVerify,
              onBulkSuspend: _handleBulkSuspend,
              onBulkExport: _handleBulkExport,
              onBulkNotify: _handleBulkNotify,
            ),
            const SizedBox(width: 16),
          ],
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh Data',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportProviders,
            tooltip: 'Export Providers',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
            tooltip: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    final statisticsAsync = ref.watch(serviceProviderStatisticsProvider);
    
    return statisticsAsync.when(
      data: (statistics) => ServiceProviderStatsCards(statistics: statistics),
      loading: () => const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => SizedBox(
        height: 120,
        child: Center(
          child: Text('Error loading statistics: $error'),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        labelColor: const Color(0xFF1976D2),
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: const Color(0xFF1976D2),
      ),
    );
  }

  Widget _buildAllProvidersTab() {
    return Column(
      children: [
        ServiceProviderFiltersWidget(
          filters: _currentFilters,
          onFiltersChanged: (filters) {
            setState(() {
              _currentFilters = filters;
            });
            ref.read(serviceProviderListProvider.notifier).loadProviders(filters: filters);
          },
        ),
        Expanded(
          child: _buildProvidersList(),
        ),
      ],
    );
  }

  Widget _buildProvidersList() {
    final providersAsync = ref.watch(serviceProviderListProvider);
    
    return providersAsync.when(
      data: (providersData) {
        final providers = providersData['providers'] as List<ServiceProvider>;
        final total = providersData['total'] as int;
        
        if (providers.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.business, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No service providers found'),
                Text('Try adjusting your filters'),
              ],
            ),
          );
        }
        
        return Card(
          margin: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: _selectedProviders.length == providers.length,
                      tristate: true,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedProviders.addAll(providers.map((p) => p.id));
                          } else {
                            _selectedProviders.clear();
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Showing ${providers.length} of $total providers',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    if (_selectedProviders.isNotEmpty)
                      Text(
                        '${_selectedProviders.length} selected',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF1976D2),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: DataTable2(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 1400,
                  columns: const [
                    DataColumn2(label: Text(''), size: ColumnSize.S),
                    DataColumn2(label: Text('Provider'), size: ColumnSize.L),
                    DataColumn2(label: Text('Business'), size: ColumnSize.L),
                    DataColumn2(label: Text('Services'), size: ColumnSize.M),
                    DataColumn2(label: Text('Location'), size: ColumnSize.M),
                    DataColumn2(label: Text('Status'), size: ColumnSize.S),
                    DataColumn2(label: Text('Performance'), size: ColumnSize.M),
                    DataColumn2(label: Text('Joined'), size: ColumnSize.S),
                    DataColumn2(label: Text('Actions'), size: ColumnSize.M),
                  ],
                  rows: providers.map((provider) => _buildProviderRow(provider)).toList(),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const LoadingWidget(),
      error: (error, stack) => ErrorWidget(
        error: error.toString(),
        onRetry: () => ref.read(serviceProviderListProvider.notifier).loadProviders(),
      ),
    );
  }

  DataRow _buildProviderRow(ServiceProvider provider) {
    final isSelected = _selectedProviders.contains(provider.id);
    
    return DataRow(
      selected: isSelected,
      onSelectChanged: (selected) {
        setState(() {
          if (selected == true) {
            _selectedProviders.add(provider.id);
          } else {
            _selectedProviders.remove(provider.id);
          }
        });
      },
      cells: [
        DataCell(
          Checkbox(
            value: isSelected,
            onChanged: (selected) {
              setState(() {
                if (selected == true) {
                  _selectedProviders.add(provider.id);
                } else {
                  _selectedProviders.remove(provider.id);
                }
              });
            },
          ),
        ),
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: provider.profilePicture.isNotEmpty
                    ? NetworkImage(provider.profilePicture)
                    : null,
                child: provider.profilePicture.isEmpty
                    ? Text('${provider.firstName[0]}${provider.lastName[0]}')
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${provider.firstName} ${provider.lastName}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      provider.email,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      provider.phoneNumber,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Additional cells will be added in the next chunk
        const DataCell(Text('Business Info')),
        const DataCell(Text('Services')),
        const DataCell(Text('Location')),
        const DataCell(Text('Status')),
        const DataCell(Text('Performance')),
        const DataCell(Text('Joined')),
        const DataCell(Text('Actions')),
      ],
    );
  }

  Widget _buildVerificationQueueTab() {
    return const VerificationWorkflowWidget();
  }

  Widget _buildPerformanceAnalyticsTab() {
    return const PerformanceAnalyticsWidget();
  }

  Widget _buildDocumentsReviewTab() {
    return const Center(child: Text('Documents Review - Coming Soon'));
  }

  Widget _buildComplianceMonitorTab() {
    return const ComplianceMonitorWidget();
  }

  Widget _buildServiceCatalogTab() {
    return const Center(child: Text('Service Catalog - Coming Soon'));
  }

  Widget _buildQualityAssuranceTab() {
    return const Center(child: Text('Quality Assurance - Coming Soon'));
  }

  Widget? _buildFloatingActionButton() {
    final currentTab = _tabController.index;
    final permissionManager = ref.watch(permissionManagerProvider);
    
    switch (currentTab) {
      case 0: // All Providers
        if (permissionManager.checkPermission(Permission.providersApprove).granted) {
          return FloatingActionButton.extended(
            onPressed: _addProvider,
            icon: const Icon(Icons.add),
            label: const Text('Add Provider'),
          );
        }
        break;
      case 1: // Verification Queue
        if (permissionManager.checkPermission(Permission.providersVerify).granted) {
          return FloatingActionButton.extended(
            onPressed: _processVerifications,
            icon: const Icon(Icons.verified),
            label: const Text('Process Queue'),
          );
        }
        break;
    }
    return null;
  }

  // Action handlers
  void _refreshData() {
    ref.read(serviceProviderListProvider.notifier).loadProviders(filters: _currentFilters);
    ref.read(serviceProviderStatisticsProvider.notifier).loadStatistics();
  }

  void _exportProviders() {
    // TODO: Implement export functionality
  }

  void _openSettings() {
    // TODO: Implement settings
  }

  void _addProvider() {
    // TODO: Implement add provider functionality
  }

  void _processVerifications() {
    // TODO: Implement verification processing
  }

  void _handleBulkVerify() {
    // TODO: Implement bulk verify
  }

  void _handleBulkSuspend() {
    // TODO: Implement bulk suspend
  }

  void _handleBulkExport() {
    // TODO: Implement bulk export
  }

  void _handleBulkNotify() {
    // TODO: Implement bulk notify
  }
}
