import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/permission_manager.dart';
import '../../../../shared/models/admin_user.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../providers/audit_providers.dart';
import '../widgets/audit_logs_widget.dart';
import '../widgets/compliance_monitoring_widget.dart';
import '../widgets/regulatory_reports_widget.dart';
import '../widgets/data_privacy_widget.dart';
import '../widgets/security_incidents_widget.dart';
import '../widgets/audit_trail_widget.dart';

class AuditComplianceScreen extends ConsumerStatefulWidget {
  const AuditComplianceScreen({super.key});

  @override
  ConsumerState<AuditComplianceScreen> createState() =>
      _AuditComplianceScreenState();
}

class _AuditComplianceScreenState
    extends ConsumerState<AuditComplianceScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimeRange = '30d';
  String _selectedSeverity = 'all';

  final List<String> _tabs = [
    'Audit Logs',
    'Compliance Monitoring',
    'Regulatory Reports',
    'Data Privacy',
    'Security Incidents',
    'Audit Trail',
  ];

  final List<String> _timeRanges = [
    '24h',
    '7d',
    '30d',
    '90d',
    '1y',
    'custom',
  ];

  final List<String> _severityLevels = [
    'all',
    'critical',
    'high',
    'medium',
    'low',
    'info',
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
    ref.read(auditLogsProvider.notifier).loadAuditLogs(
      timeRange: _selectedTimeRange,
      severity: _selectedSeverity,
    );
    ref.read(complianceStatusProvider.notifier).loadComplianceStatus();
    ref.read(regulatoryReportsProvider.notifier).loadReports();
    ref.read(dataPrivacyStatusProvider.notifier).loadPrivacyStatus();
    ref.read(securityIncidentsProvider.notifier).loadIncidents();
    ref.read(auditTrailProvider.notifier).loadAuditTrail();
  }

  @override
  Widget build(BuildContext context) {
    final permissionManager = ref.watch(permissionManagerProvider);
    
    // Check permissions
    if (!permissionManager.checkCategoryAccess(PermissionCategory.auditCompliance).granted) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('Access Denied'),
              Text('You don\'t have permission to access audit and compliance.'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildComplianceStatusBar(),
          _buildControlsSection(),
          _buildTabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAuditLogsTab(),
                _buildComplianceMonitoringTab(),
                _buildRegulatoryReportsTab(),
                _buildDataPrivacyTab(),
                _buildSecurityIncidentsTab(),
                _buildAuditTrailTab(),
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
          const Icon(Icons.security, size: 32, color: Color(0xFF1565C0)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Audit & Compliance Management',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Comprehensive audit logging, compliance monitoring, and regulatory reporting',
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
            onPressed: _exportAuditData,
            tooltip: 'Export Audit Data',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openAuditSettings,
            tooltip: 'Audit Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceStatusBar() {
    final complianceAsync = ref.watch(complianceStatusProvider);
    
    return complianceAsync.when(
      data: (compliance) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _getComplianceColor(compliance.overallScore).withValues(alpha: 0.1),
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        child: Row(
          children: [
            Icon(
              _getComplianceIcon(compliance.overallScore),
              size: 20,
              color: _getComplianceColor(compliance.overallScore),
            ),
            const SizedBox(width: 8),
            Text(
              'Compliance Score: ${compliance.overallScore}%',
              style: TextStyle(
                color: _getComplianceColor(compliance.overallScore),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 24),
            Icon(
              Icons.warning,
              size: 16,
              color: Colors.orange,
            ),
            const SizedBox(width: 4),
            Text(
              '${compliance.activeViolations} Active Violations',
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 24),
            Icon(
              Icons.schedule,
              size: 16,
              color: Colors.blue,
            ),
            const SizedBox(width: 4),
            Text(
              '${compliance.pendingReviews} Pending Reviews',
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              'Last Audit: ${_formatDateTime(compliance.lastAuditDate)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      loading: () => const SizedBox(height: 44),
      error: (_, __) => const SizedBox(height: 44),
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
          
          // Severity selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedSeverity,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedSeverity = value;
                    });
                    _loadInitialData();
                  }
                },
                items: _severityLevels.map((severity) {
                  return DropdownMenuItem(
                    value: severity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (severity != 'all') ...[
                          Icon(
                            Icons.circle,
                            size: 12,
                            color: _getSeverityColor(severity),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(_getSeverityLabel(severity)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const Spacer(),
          
          // Real-time monitoring indicator
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
                  'Real-time Monitoring',
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
        labelColor: const Color(0xFF1565C0),
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: const Color(0xFF1565C0),
      ),
    );
  }

  Widget _buildAuditLogsTab() {
    return AuditLogsWidget(
      timeRange: _selectedTimeRange,
      severity: _selectedSeverity,
    );
  }

  Widget _buildComplianceMonitoringTab() {
    return const ComplianceMonitoringWidget();
  }

  Widget _buildRegulatoryReportsTab() {
    return const RegulatoryReportsWidget();
  }

  Widget _buildDataPrivacyTab() {
    return const DataPrivacyWidget();
  }

  Widget _buildSecurityIncidentsTab() {
    return const SecurityIncidentsWidget();
  }

  Widget _buildAuditTrailTab() {
    return const AuditTrailWidget();
  }

  Widget? _buildFloatingActionButton() {
    final currentTab = _tabController.index;
    final permissionManager = ref.watch(permissionManagerProvider);
    
    switch (currentTab) {
      case 1: // Compliance Monitoring
        if (permissionManager.checkPermission(Permission.auditComplianceCreate).granted) {
          return FloatingActionButton.extended(
            onPressed: _createComplianceCheck,
            icon: const Icon(Icons.rule),
            label: const Text('New Compliance Check'),
          );
        }
        break;
      case 2: // Regulatory Reports
        return FloatingActionButton.extended(
          onPressed: _generateReport,
          icon: const Icon(Icons.assessment),
          label: const Text('Generate Report'),
        );
      case 4: // Security Incidents
        if (permissionManager.checkPermission(Permission.auditComplianceCreate).granted) {
          return FloatingActionButton.extended(
            onPressed: _reportIncident,
            icon: const Icon(Icons.report_problem),
            label: const Text('Report Incident'),
          );
        }
        break;
    }
    return null;
  }

  // Helper methods
  Color _getComplianceColor(double score) {
    if (score >= 90) return Colors.green;
    if (score >= 70) return Colors.orange;
    return Colors.red;
  }

  IconData _getComplianceIcon(double score) {
    if (score >= 90) return Icons.check_circle;
    if (score >= 70) return Icons.warning;
    return Icons.error;
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.yellow;
      case 'low':
        return Colors.blue;
      case 'info':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getTimeRangeLabel(String range) {
    switch (range) {
      case '24h':
        return 'Last 24 hours';
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

  String _getSeverityLabel(String severity) {
    switch (severity) {
      case 'all':
        return 'All Severities';
      case 'critical':
        return 'Critical';
      case 'high':
        return 'High';
      case 'medium':
        return 'Medium';
      case 'low':
        return 'Low';
      case 'info':
        return 'Info';
      default:
        return severity;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // Action handlers
  void _refreshData() {
    _loadInitialData();
  }

  void _exportAuditData() {
    // TODO: Implement export audit data
  }

  void _openAuditSettings() {
    // TODO: Implement audit settings
  }

  void _createComplianceCheck() {
    // TODO: Implement create compliance check
  }

  void _generateReport() {
    // TODO: Implement generate report
  }

  void _reportIncident() {
    // TODO: Implement report incident
  }
}
