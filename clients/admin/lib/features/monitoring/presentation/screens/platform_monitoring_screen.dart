import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/permission_manager.dart';
import '../../../../shared/models/admin_user.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../providers/monitoring_providers.dart';
import '../widgets/system_health_widget.dart';
import '../widgets/performance_metrics_widget.dart';
import '../widgets/alert_management_widget.dart';
import '../widgets/real_time_charts_widget.dart';
import '../widgets/service_status_widget.dart';

class PlatformMonitoringScreen extends ConsumerStatefulWidget {
  const PlatformMonitoringScreen({super.key});

  @override
  ConsumerState<PlatformMonitoringScreen> createState() => _PlatformMonitoringScreenState();
}

class _PlatformMonitoringScreenState extends ConsumerState<PlatformMonitoringScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Timer? _refreshTimer;
  bool _isRealTimeEnabled = true;

  final List<String> _tabs = [
    'System Health',
    'Performance Metrics',
    'Real-time Analytics',
    'Service Status',
    'Alert Management',
    'Reports',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
      _startRealTimeUpdates();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _loadInitialData() {
    ref.read(systemHealthProvider.notifier).loadSystemHealth();
    ref.read(performanceMetricsProvider.notifier).loadMetrics();
    ref.read(serviceStatusProvider.notifier).loadServiceStatus();
    ref.read(alertsProvider.notifier).loadAlerts();
    ref.read(realTimeAnalyticsProvider.notifier).loadAnalytics();
  }

  void _startRealTimeUpdates() {
    if (_isRealTimeEnabled) {
      _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
        _loadInitialData();
      });
    }
  }

  void _stopRealTimeUpdates() {
    _refreshTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final permissionManager = ref.watch(permissionManagerProvider);
    
    // Check permissions
    if (!permissionManager.checkCategoryAccess(PermissionCategory.systemConfiguration).granted) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('Access Denied'),
              Text('You don\'t have permission to access system monitoring.'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildSystemOverview(),
          _buildTabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSystemHealthTab(),
                _buildPerformanceMetricsTab(),
                _buildRealTimeAnalyticsTab(),
                _buildServiceStatusTab(),
                _buildAlertManagementTab(),
                _buildReportsTab(),
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
          const Icon(Icons.monitor, size: 32, color: Color(0xFF2E7D32)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Platform Monitoring',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Real-time system health and performance monitoring',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const Spacer(),
          // Real-time toggle
          Row(
            children: [
              Icon(
                _isRealTimeEnabled ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: _isRealTimeEnabled ? Colors.green : Colors.grey,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'Real-time',
                style: TextStyle(
                  color: _isRealTimeEnabled ? Colors.green : Colors.grey,
                  fontSize: 12,
                ),
              ),
              Switch(
                value: _isRealTimeEnabled,
                onChanged: (value) {
                  setState(() {
                    _isRealTimeEnabled = value;
                  });
                  if (value) {
                    _startRealTimeUpdates();
                  } else {
                    _stopRealTimeUpdates();
                  }
                },
                activeColor: Colors.green,
              ),
            ],
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh Data',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportReport,
            tooltip: 'Export Report',
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

  Widget _buildSystemOverview() {
    final systemHealthAsync = ref.watch(systemHealthProvider);
    
    return systemHealthAsync.when(
      data: (health) => Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Row(
          children: [
            Expanded(
              child: _buildOverviewCard(
                'System Status',
                health.overallStatus,
                _getStatusColor(health.overallStatus),
                Icons.computer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildOverviewCard(
                'Active Users',
                health.activeUsers.toString(),
                Colors.blue,
                Icons.people,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildOverviewCard(
                'Response Time',
                '${health.averageResponseTime}ms',
                _getResponseTimeColor(health.averageResponseTime),
                Icons.speed,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildOverviewCard(
                'Uptime',
                '${health.uptime.toStringAsFixed(2)}%',
                _getUptimeColor(health.uptime),
                Icons.trending_up,
              ),
            ),
          ],
        ),
      ),
      loading: () => const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => SizedBox(
        height: 100,
        child: Center(
          child: Text('Error loading system overview: $error'),
        ),
      ),
    );
  }

  Widget _buildOverviewCard(String title, String value, Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
        labelColor: const Color(0xFF2E7D32),
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: const Color(0xFF2E7D32),
      ),
    );
  }

  Widget _buildSystemHealthTab() {
    return const SystemHealthWidget();
  }

  Widget _buildPerformanceMetricsTab() {
    return const PerformanceMetricsWidget();
  }

  Widget _buildRealTimeAnalyticsTab() {
    return const RealTimeChartsWidget();
  }

  Widget _buildServiceStatusTab() {
    return const ServiceStatusWidget();
  }

  Widget _buildAlertManagementTab() {
    return const AlertManagementWidget();
  }

  Widget _buildReportsTab() {
    return const Center(child: Text('Reports - Coming Soon'));
  }

  Widget? _buildFloatingActionButton() {
    final currentTab = _tabController.index;
    
    switch (currentTab) {
      case 4: // Alert Management
        return FloatingActionButton.extended(
          onPressed: _createAlert,
          icon: const Icon(Icons.add_alert),
          label: const Text('Create Alert'),
        );
      case 5: // Reports
        return FloatingActionButton.extended(
          onPressed: _generateReport,
          icon: const Icon(Icons.assessment),
          label: const Text('Generate Report'),
        );
      default:
        return null;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'healthy':
      case 'operational':
        return Colors.green;
      case 'warning':
      case 'degraded':
        return Colors.orange;
      case 'critical':
      case 'down':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getResponseTimeColor(int responseTime) {
    if (responseTime < 200) return Colors.green;
    if (responseTime < 500) return Colors.orange;
    return Colors.red;
  }

  Color _getUptimeColor(double uptime) {
    if (uptime >= 99.9) return Colors.green;
    if (uptime >= 99.0) return Colors.orange;
    return Colors.red;
  }

  // Action handlers
  void _refreshData() {
    _loadInitialData();
  }

  void _exportReport() {
    // TODO: Implement export functionality
  }

  void _openSettings() {
    // TODO: Implement settings
  }

  void _createAlert() {
    // TODO: Implement create alert
  }

  void _generateReport() {
    // TODO: Implement generate report
  }
}
