import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/permission_manager.dart';
import '../../../../shared/models/admin_user.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../providers/analytics_providers.dart';
import '../widgets/analytics_stats_cards.dart';
import '../widgets/custom_dashboard_widget.dart';
import '../widgets/predictive_analytics_widget.dart';
import '../widgets/user_behavior_widget.dart';
import '../widgets/business_intelligence_widget.dart';
import '../widgets/data_export_widget.dart';

class AnalyticsDashboardScreen extends ConsumerStatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  ConsumerState<AnalyticsDashboardScreen> createState() =>
      _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState
    extends ConsumerState<AnalyticsDashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimeRange = '30d';
  List<String> _selectedMetrics = ['users', 'revenue', 'engagement'];

  final List<String> _tabs = [
    'Overview',
    'Custom Dashboards',
    'Predictive Analytics',
    'User Behavior',
    'Business Intelligence',
    'Data Export',
  ];

  final List<String> _timeRanges = [
    '7d',
    '30d',
    '90d',
    '1y',
    'custom',
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
    ref.read(analyticsOverviewProvider.notifier).loadOverview(
      timeRange: _selectedTimeRange,
      metrics: _selectedMetrics,
    );
    ref.read(customDashboardsProvider.notifier).loadDashboards();
    ref.read(predictiveAnalyticsProvider.notifier).loadPredictions();
    ref.read(userBehaviorAnalyticsProvider.notifier).loadBehaviorData();
    ref.read(businessIntelligenceProvider.notifier).loadBIData();
  }

  @override
  Widget build(BuildContext context) {
    final permissionManager = ref.watch(permissionManagerProvider);
    
    // Check permissions
    if (!permissionManager.checkCategoryAccess(PermissionCategory.analytics).granted) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('Access Denied'),
              Text('You don\'t have permission to access analytics.'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildControlsSection(),
          _buildStatsSection(),
          _buildTabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildCustomDashboardsTab(),
                _buildPredictiveAnalyticsTab(),
                _buildUserBehaviorTab(),
                _buildBusinessIntelligenceTab(),
                _buildDataExportTab(),
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
          const Icon(Icons.analytics, size: 32, color: Color(0xFF6A1B9A)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Advanced Analytics & Business Intelligence',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Comprehensive analytics, predictive insights, and business intelligence',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh Data',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportAnalytics,
            tooltip: 'Export Analytics',
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

  Widget _buildControlsSection() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          // Time range selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedTimeRange,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedTimeRange = value;
                    });
                    _loadInitialData();
                  }
                },
                items: _timeRanges.map((range) {
                  return DropdownMenuItem(
                    value: range,
                    child: Text(_getTimeRangeLabel(range)),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Metrics selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: PopupMenuButton<String>(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Metrics (${_selectedMetrics.length})'),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
              onSelected: (metric) {
                setState(() {
                  if (_selectedMetrics.contains(metric)) {
                    _selectedMetrics.remove(metric);
                  } else {
                    _selectedMetrics.add(metric);
                  }
                });
                _loadInitialData();
              },
              itemBuilder: (context) => [
                'users',
                'revenue',
                'engagement',
                'transactions',
                'retention',
                'conversion',
              ].map((metric) {
                return CheckedPopupMenuItem<String>(
                  value: metric,
                  checked: _selectedMetrics.contains(metric),
                  child: Text(_getMetricLabel(metric)),
                );
              }).toList(),
            ),
          ),
          const Spacer(),
          
          // Real-time indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Live Data',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    final overviewAsync = ref.watch(analyticsOverviewProvider);
    
    return overviewAsync.when(
      data: (overview) => AnalyticsStatsCards(
        overview: overview,
        timeRange: _selectedTimeRange,
      ),
      loading: () => const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => SizedBox(
        height: 120,
        child: Center(
          child: Text('Error loading analytics: $error'),
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
        labelColor: const Color(0xFF6A1B9A),
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: const Color(0xFF6A1B9A),
      ),
    );
  }

  Widget _buildOverviewTab() {
    final overviewAsync = ref.watch(analyticsOverviewProvider);
    
    return overviewAsync.when(
      data: (overview) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            // Key metrics charts
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= AppConstants.desktopBreakpoint;
                
                if (isDesktop) {
                  return Row(
                    children: [
                      Expanded(child: _buildUserGrowthChart(overview)),
                      const SizedBox(width: AppConstants.defaultPadding),
                      Expanded(child: _buildRevenueChart(overview)),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildUserGrowthChart(overview),
                      const SizedBox(height: AppConstants.defaultPadding),
                      _buildRevenueChart(overview),
                    ],
                  );
                }
              },
            ),
            
            const SizedBox(height: AppConstants.largePadding),
            
            // Engagement and conversion metrics
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= AppConstants.desktopBreakpoint;
                
                if (isDesktop) {
                  return Row(
                    children: [
                      Expanded(child: _buildEngagementChart(overview)),
                      const SizedBox(width: AppConstants.defaultPadding),
                      Expanded(child: _buildConversionFunnelChart(overview)),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildEngagementChart(overview),
                      const SizedBox(height: AppConstants.defaultPadding),
                      _buildConversionFunnelChart(overview),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
      loading: () => const LoadingWidget(),
      error: (error, stack) => ErrorWidget(
        error: error.toString(),
        onRetry: () => ref.read(analyticsOverviewProvider.notifier).loadOverview(
          timeRange: _selectedTimeRange,
          metrics: _selectedMetrics,
        ),
      ),
    );
  }

  Widget _buildUserGrowthChart(AnalyticsOverview overview) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Growth',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateUserGrowthSpots(overview.userGrowthHistory),
                      isCurved: true,
                      color: const Color(0xFF6A1B9A),
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFF6A1B9A).withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart(AnalyticsOverview overview) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revenue Trends',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxRevenueValue(overview.revenueHistory),
                  barGroups: _generateRevenueBars(overview.revenueHistory),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEngagementChart(AnalyticsOverview overview) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Engagement',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: _generateEngagementSections(overview.engagementMetrics),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversionFunnelChart(AnalyticsOverview overview) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Conversion Funnel',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: Column(
                children: overview.conversionFunnel.entries.map((entry) {
                  final percentage = (entry.value / overview.conversionFunnel.values.first) * 100;
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 120,
                          child: Text(
                            entry.key,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: percentage / 100,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color.lerp(Colors.red, Colors.green, percentage / 100)!,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomDashboardsTab() {
    return const CustomDashboardWidget();
  }

  Widget _buildPredictiveAnalyticsTab() {
    return const PredictiveAnalyticsWidget();
  }

  Widget _buildUserBehaviorTab() {
    return const UserBehaviorWidget();
  }

  Widget _buildBusinessIntelligenceTab() {
    return const BusinessIntelligenceWidget();
  }

  Widget _buildDataExportTab() {
    return const DataExportWidget();
  }

  Widget? _buildFloatingActionButton() {
    final currentTab = _tabController.index;
    final permissionManager = ref.watch(permissionManagerProvider);
    
    switch (currentTab) {
      case 1: // Custom Dashboards
        if (permissionManager.checkPermission(Permission.analyticsCreate).granted) {
          return FloatingActionButton.extended(
            onPressed: _createCustomDashboard,
            icon: const Icon(Icons.dashboard),
            label: const Text('New Dashboard'),
          );
        }
        break;
      case 5: // Data Export
        return FloatingActionButton.extended(
          onPressed: _exportAllData,
          icon: const Icon(Icons.download),
          label: const Text('Export All'),
        );
    }
    return null;
  }

  // Helper methods
  String _getTimeRangeLabel(String range) {
    switch (range) {
      case '7d':
        return 'Last 7 days';
      case '30d':
        return 'Last 30 days';
      case '90d':
        return 'Last 90 days';
      case '1y':
        return 'Last year';
      case 'custom':
        return 'Custom range';
      default:
        return range;
    }
  }

  String _getMetricLabel(String metric) {
    switch (metric) {
      case 'users':
        return 'Users';
      case 'revenue':
        return 'Revenue';
      case 'engagement':
        return 'Engagement';
      case 'transactions':
        return 'Transactions';
      case 'retention':
        return 'Retention';
      case 'conversion':
        return 'Conversion';
      default:
        return metric;
    }
  }

  List<FlSpot> _generateUserGrowthSpots(List<Map<String, dynamic>> history) {
    return history.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), (entry.value['users'] as num).toDouble());
    }).toList();
  }

  List<BarChartGroupData> _generateRevenueBars(List<Map<String, dynamic>> history) {
    return history.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: (entry.value['revenue'] as num).toDouble(),
            color: const Color(0xFF6A1B9A),
            width: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }).toList();
  }

  List<PieChartSectionData> _generateEngagementSections(Map<String, dynamic> metrics) {
    final colors = [
      const Color(0xFF6A1B9A),
      const Color(0xFF9C27B0),
      const Color(0xFFE91E63),
      const Color(0xFF2196F3),
    ];
    
    return metrics.entries.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: (data.value as num).toDouble(),
        title: '${data.key}\n${data.value}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  double _getMaxRevenueValue(List<Map<String, dynamic>> history) {
    if (history.isEmpty) return 100;
    return history.map((h) => (h['revenue'] as num).toDouble()).reduce((a, b) => a > b ? a : b);
  }

  // Action handlers
  void _refreshData() {
    _loadInitialData();
  }

  void _exportAnalytics() {
    // TODO: Implement export functionality
  }

  void _openSettings() {
    // TODO: Implement settings
  }

  void _createCustomDashboard() {
    // TODO: Implement create custom dashboard
  }

  void _exportAllData() {
    // TODO: Implement export all data
  }
}
