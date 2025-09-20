import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/models/farmer.dart';
import '../../../../shared/services/farmer_service.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../providers/farmer_providers.dart';
import '../widgets/farmer_details_dialog.dart';
import '../widgets/farmer_filters_widget.dart';
import '../widgets/farmer_stats_cards.dart';
import '../widgets/bulk_actions_widget.dart';

class FarmerManagementScreen extends ConsumerStatefulWidget {
  const FarmerManagementScreen({super.key});

  @override
  ConsumerState<FarmerManagementScreen> createState() => _FarmerManagementScreenState();
}

class _FarmerManagementScreenState extends ConsumerState<FarmerManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final Set<String> _selectedFarmers = {};
  FarmerSearchFilters _currentFilters = const FarmerSearchFilters();

  final List<String> _tabs = [
    'All Farmers',
    'Verification Queue',
    'Performance Analytics',
    'Activity Logs',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(farmerListProvider.notifier).loadFarmers();
      ref.read(farmerStatisticsProvider.notifier).loadStatistics();
    });
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
          _buildStatsSection(),
          _buildTabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllFarmersTab(),
                _buildVerificationQueueTab(),
                _buildPerformanceAnalyticsTab(),
                _buildActivityLogsTab(),
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
          const Icon(Icons.agriculture, size: 32, color: Color(0xFF2E7D32)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Farmer Management',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Manage farmer profiles, verification, and performance',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const Spacer(),
          if (_selectedFarmers.isNotEmpty) ...[
            BulkActionsWidget(
              selectedCount: _selectedFarmers.length,
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
            onPressed: _exportFarmers,
            tooltip: 'Export Farmers',
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    final statisticsAsync = ref.watch(farmerStatisticsProvider);
    
    return statisticsAsync.when(
      data: (statistics) => FarmerStatsCards(statistics: statistics),
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
        tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        labelColor: const Color(0xFF2E7D32),
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: const Color(0xFF2E7D32),
      ),
    );
  }

  Widget _buildAllFarmersTab() {
    return Column(
      children: [
        FarmerFiltersWidget(
          filters: _currentFilters,
          onFiltersChanged: (filters) {
            setState(() {
              _currentFilters = filters;
            });
            ref.read(farmerListProvider.notifier).loadFarmers(filters: filters);
          },
        ),
        Expanded(
          child: _buildFarmersList(),
        ),
      ],
    );
  }

  Widget _buildFarmersList() {
    final farmersAsync = ref.watch(farmerListProvider);
    
    return farmersAsync.when(
      data: (farmersData) {
        final farmers = farmersData['farmers'] as List<Farmer>;
        final total = farmersData['total'] as int;
        
        if (farmers.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.agriculture, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No farmers found'),
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
                      value: _selectedFarmers.length == farmers.length,
                      tristate: true,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedFarmers.addAll(farmers.map((f) => f.id));
                          } else {
                            _selectedFarmers.clear();
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Showing ${farmers.length} of $total farmers',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    if (_selectedFarmers.isNotEmpty)
                      Text(
                        '${_selectedFarmers.length} selected',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF2E7D32),
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
                  minWidth: 1200,
                  columns: const [
                    DataColumn2(label: Text(''), size: ColumnSize.S),
                    DataColumn2(label: Text('Farmer'), size: ColumnSize.L),
                    DataColumn2(label: Text('Farm Details'), size: ColumnSize.L),
                    DataColumn2(label: Text('Location'), size: ColumnSize.M),
                    DataColumn2(label: Text('Status'), size: ColumnSize.S),
                    DataColumn2(label: Text('Performance'), size: ColumnSize.M),
                    DataColumn2(label: Text('Joined'), size: ColumnSize.S),
                    DataColumn2(label: Text('Actions'), size: ColumnSize.M),
                  ],
                  rows: farmers.map((farmer) => _buildFarmerRow(farmer)).toList(),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const LoadingWidget(),
      error: (error, stack) => ErrorWidget(
        error: error.toString(),
        onRetry: () => ref.read(farmerListProvider.notifier).loadFarmers(),
      ),
    );
  }

  DataRow _buildFarmerRow(Farmer farmer) {
    final isSelected = _selectedFarmers.contains(farmer.id);
    
    return DataRow(
      selected: isSelected,
      onSelectChanged: (selected) {
        setState(() {
          if (selected == true) {
            _selectedFarmers.add(farmer.id);
          } else {
            _selectedFarmers.remove(farmer.id);
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
                  _selectedFarmers.add(farmer.id);
                } else {
                  _selectedFarmers.remove(farmer.id);
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
                backgroundImage: farmer.profilePicture != null
                    ? NetworkImage(farmer.profilePicture!)
                    : null,
                child: farmer.profilePicture == null
                    ? Text(farmer.initials)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      farmer.fullName,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      farmer.email,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      farmer.phoneNumber,
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
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                farmer.farmName ?? 'Unnamed Farm',
                style: const TextStyle(fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${farmer.farmSize} acres',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                farmer.primaryFarmTypeDisplayName,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                farmer.farmLocation.county,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              if (farmer.farmLocation.subCounty != null)
                Text(
                  farmer.farmLocation.subCounty!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
        ),
        DataCell(_buildStatusChip(farmer)),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${farmer.performanceScore.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: _getPerformanceColor(farmer.performanceScore),
                ),
              ),
              Text(
                'KES ${farmer.performanceMetrics.totalRevenue.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            '${farmer.daysSinceJoining} days ago',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.visibility, size: 18),
                onPressed: () => _viewFarmerDetails(farmer),
                tooltip: 'View Details',
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 18),
                onPressed: () => _editFarmer(farmer),
                tooltip: 'Edit',
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 18),
                onSelected: (action) => _handleFarmerAction(farmer, action),
                itemBuilder: (context) => [
                  if (farmer.needsVerification)
                    const PopupMenuItem(
                      value: 'verify',
                      child: Row(
                        children: [
                          Icon(Icons.verified, size: 16),
                          SizedBox(width: 8),
                          Text('Verify'),
                        ],
                      ),
                    ),
                  if (farmer.isActive)
                    const PopupMenuItem(
                      value: 'suspend',
                      child: Row(
                        children: [
                          Icon(Icons.block, size: 16),
                          SizedBox(width: 8),
                          Text('Suspend'),
                        ],
                      ),
                    )
                  else
                    const PopupMenuItem(
                      value: 'reactivate',
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, size: 16),
                          SizedBox(width: 8),
                          Text('Reactivate'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'notify',
                    child: Row(
                      children: [
                        Icon(Icons.notifications, size: 16),
                        SizedBox(width: 8),
                        Text('Send Notification'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(Farmer farmer) {
    Color color;
    String label;
    
    if (farmer.isSuspended) {
      color = Colors.red;
      label = 'Suspended';
    } else if (farmer.isVerified) {
      color = Colors.green;
      label = 'Verified';
    } else if (farmer.needsVerification) {
      color = Colors.orange;
      label = 'Pending';
    } else {
      color = Colors.grey;
      label = 'Inactive';
    }
    
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
    );
  }

  Color _getPerformanceColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  Widget _buildVerificationQueueTab() {
    return const Center(child: Text('Verification Queue - Coming Soon'));
  }

  Widget _buildPerformanceAnalyticsTab() {
    return const Center(child: Text('Performance Analytics - Coming Soon'));
  }

  Widget _buildActivityLogsTab() {
    return const Center(child: Text('Activity Logs - Coming Soon'));
  }

  Widget? _buildFloatingActionButton() {
    final currentTab = _tabController.index;
    
    switch (currentTab) {
      case 0: // All Farmers
        return FloatingActionButton.extended(
          onPressed: _addFarmer,
          icon: const Icon(Icons.add),
          label: const Text('Add Farmer'),
        );
      default:
        return null;
    }
  }

  // Action handlers
  void _refreshData() {
    ref.read(farmerListProvider.notifier).loadFarmers(filters: _currentFilters);
    ref.read(farmerStatisticsProvider.notifier).loadStatistics();
  }

  void _exportFarmers() {
    // TODO: Implement export functionality
  }

  void _viewFarmerDetails(Farmer farmer) {
    showDialog(
      context: context,
      builder: (context) => FarmerDetailsDialog(farmer: farmer),
    );
  }

  void _editFarmer(Farmer farmer) {
    // TODO: Implement edit functionality
  }

  void _handleFarmerAction(Farmer farmer, String action) {
    // TODO: Implement farmer actions
  }

  void _addFarmer() {
    // TODO: Implement add farmer functionality
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
