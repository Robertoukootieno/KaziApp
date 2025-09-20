import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../providers/audit_providers.dart';

class AuditTrailWidget extends ConsumerStatefulWidget {
  const AuditTrailWidget({super.key});

  @override
  ConsumerState<AuditTrailWidget> createState() => _AuditTrailWidgetState();
}

class _AuditTrailWidgetState extends ConsumerState<AuditTrailWidget> {
  String _selectedAction = 'all';
  String _selectedUser = 'all';
  String _selectedTimeRange = '24h';

  @override
  Widget build(BuildContext context) {
    final auditData = ref.watch(auditTrailProvider);

    return auditData.when(
      loading: () => const LoadingWidget(),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading audit trail: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(auditTrailProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (data) => _buildAuditContent(data),
    );
  }

  Widget _buildAuditContent(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildAuditOverview(data),
        const SizedBox(height: 24),
        _buildAuditTable(data),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Audit Trail',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Row(
          children: [
            _buildActionFilter(),
            const SizedBox(width: 16),
            _buildUserFilter(),
            const SizedBox(width: 16),
            _buildTimeRangeFilter(),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _exportAuditLog,
              icon: const Icon(Icons.file_download),
              label: const Text('Export'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedAction,
          items: const [
            DropdownMenuItem(value: 'all', child: Text('All Actions')),
            DropdownMenuItem(value: 'login', child: Text('Login')),
            DropdownMenuItem(value: 'logout', child: Text('Logout')),
            DropdownMenuItem(value: 'create', child: Text('Create')),
            DropdownMenuItem(value: 'update', child: Text('Update')),
            DropdownMenuItem(value: 'delete', child: Text('Delete')),
            DropdownMenuItem(value: 'view', child: Text('View')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedAction = value;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildUserFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedUser,
          items: const [
            DropdownMenuItem(value: 'all', child: Text('All Users')),
            DropdownMenuItem(value: 'admin', child: Text('Admin Users')),
            DropdownMenuItem(value: 'moderator', child: Text('Moderators')),
            DropdownMenuItem(value: 'support', child: Text('Support Staff')),
            DropdownMenuItem(value: 'system', child: Text('System')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedUser = value;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildTimeRangeFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedTimeRange,
          items: const [
            DropdownMenuItem(value: '1h', child: Text('Last Hour')),
            DropdownMenuItem(value: '24h', child: Text('Last 24 Hours')),
            DropdownMenuItem(value: '7d', child: Text('Last 7 Days')),
            DropdownMenuItem(value: '30d', child: Text('Last 30 Days')),
            DropdownMenuItem(value: '90d', child: Text('Last 90 Days')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedTimeRange = value;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildAuditOverview(Map<String, dynamic> data) {
    final overview = data['overview'] as Map<String, dynamic>? ?? {};
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Audit Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;

                if (screenWidth < 600) {
                  // Mobile: Stack cards vertically
                  return Column(
                    children: [
                      _buildOverviewCard(
                        'Total Events',
                        '${overview['totalEvents'] ?? 1245}',
                        Icons.event,
                        Colors.blue,
                        'Last 24 hours',
                      ),
                      const SizedBox(height: 16),
                      _buildOverviewCard(
                        'Unique Users',
                        '${overview['uniqueUsers'] ?? 89}',
                        Icons.people,
                        Colors.green,
                        'Active today',
                      ),
                      const SizedBox(height: 16),
                      _buildOverviewCard(
                        'Failed Actions',
                        '${overview['failedActions'] ?? 12}',
                        Icons.error,
                        Colors.red,
                        '0.96% failure rate',
                      ),
                      const SizedBox(height: 16),
                      _buildOverviewCard(
                        'Critical Events',
                        '${overview['criticalEvents'] ?? 3}',
                        Icons.warning,
                        Colors.orange,
                        'Requires attention',
                      ),
                    ],
                  );
                } else if (screenWidth < 900) {
                  // Tablet: 2x2 grid
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildOverviewCard(
                              'Total Events',
                              '${overview['totalEvents'] ?? 1245}',
                              Icons.event,
                              Colors.blue,
                              'Last 24 hours',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildOverviewCard(
                              'Unique Users',
                              '${overview['uniqueUsers'] ?? 89}',
                              Icons.people,
                              Colors.green,
                              'Active today',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildOverviewCard(
                              'Failed Actions',
                              '${overview['failedActions'] ?? 12}',
                              Icons.error,
                              Colors.red,
                              '0.96% failure rate',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildOverviewCard(
                              'Critical Events',
                              '${overview['criticalEvents'] ?? 3}',
                              Icons.warning,
                              Colors.orange,
                              'Requires attention',
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  // Desktop: Single row
                  return Row(
                    children: [
                      Expanded(
                        child: _buildOverviewCard(
                          'Total Events',
                          '${overview['totalEvents'] ?? 1245}',
                          Icons.event,
                          Colors.blue,
                          'Last 24 hours',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildOverviewCard(
                          'Unique Users',
                          '${overview['uniqueUsers'] ?? 89}',
                          Icons.people,
                          Colors.green,
                          'Active today',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildOverviewCard(
                          'Failed Actions',
                          '${overview['failedActions'] ?? 12}',
                          Icons.error,
                          Colors.red,
                          '0.96% failure rate',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildOverviewCard(
                          'Critical Events',
                          '${overview['criticalEvents'] ?? 3}',
                          Icons.warning,
                          Colors.orange,
                          'Requires attention',
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditTable(Map<String, dynamic> data) {
    final auditLogs = data['logs'] as List<dynamic>? ?? _getSampleAuditLogs();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Audit Logs',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 500,
              child: DataTable2(
                columnSpacing: 12,
                horizontalMargin: 12,
                minWidth: 1000,
                columns: const [
                  DataColumn2(
                    label: Text('Timestamp'),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text('User'),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text('Action'),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Text('Resource'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Status'),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Text('IP Address'),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text('Details'),
                    size: ColumnSize.S,
                  ),
                ],
                rows: auditLogs.map((log) => _buildAuditRow(log)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildAuditRow(Map<String, dynamic> log) {
    final status = log['status'] as String;
    final action = log['action'] as String;
    
    Color statusColor;
    IconData statusIcon;
    
    switch (status) {
      case 'success':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'failed':
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      case 'warning':
        statusColor = Colors.orange;
        statusIcon = Icons.warning;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    Color actionColor;
    switch (action) {
      case 'create':
        actionColor = Colors.green;
        break;
      case 'update':
        actionColor = Colors.blue;
        break;
      case 'delete':
        actionColor = Colors.red;
        break;
      case 'login':
        actionColor = Colors.purple;
        break;
      case 'logout':
        actionColor = Colors.grey;
        break;
      default:
        actionColor = Colors.blue;
    }

    return DataRow(
      cells: [
        DataCell(Text(log['timestamp'] as String)),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                log['user'] as String,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                log['userRole'] as String,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: actionColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              action.toUpperCase(),
              style: TextStyle(
                color: actionColor,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ),
        DataCell(
          Text(
            log['resource'] as String,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(statusIcon, color: statusColor, size: 16),
              const SizedBox(width: 4),
              Text(
                status.toUpperCase(),
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(log['ipAddress'] as String)),
        DataCell(
          IconButton(
            icon: const Icon(Icons.visibility, size: 16),
            onPressed: () => _viewAuditDetails(log),
            tooltip: 'View Details',
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getSampleAuditLogs() {
    return [
      {
        'timestamp': '2024-01-15 16:45:23',
        'user': 'admin@kaziapp.com',
        'userRole': 'Super Admin',
        'action': 'login',
        'resource': 'Admin Dashboard',
        'status': 'success',
        'ipAddress': '192.168.1.100',
        'details': 'Successful login from trusted location',
      },
      {
        'timestamp': '2024-01-15 16:42:15',
        'user': 'moderator@kaziapp.com',
        'userRole': 'Content Moderator',
        'action': 'update',
        'resource': 'User Profile: farmer_001',
        'status': 'success',
        'ipAddress': '192.168.1.105',
        'details': 'Updated farmer verification status',
      },
      {
        'timestamp': '2024-01-15 16:38:47',
        'user': 'support@kaziapp.com',
        'userRole': 'Support Agent',
        'action': 'view',
        'resource': 'Service Provider: vet_clinic_123',
        'status': 'success',
        'ipAddress': '192.168.1.110',
        'details': 'Viewed service provider details for support ticket',
      },
      {
        'timestamp': '2024-01-15 16:35:12',
        'user': 'unknown_user',
        'userRole': 'Unknown',
        'action': 'login',
        'resource': 'Admin Dashboard',
        'status': 'failed',
        'ipAddress': '203.0.113.45',
        'details': 'Failed login attempt - invalid credentials',
      },
      {
        'timestamp': '2024-01-15 16:30:08',
        'user': 'admin@kaziapp.com',
        'userRole': 'Super Admin',
        'action': 'delete',
        'resource': 'Spam Content: post_456',
        'status': 'success',
        'ipAddress': '192.168.1.100',
        'details': 'Removed spam content reported by users',
      },
      {
        'timestamp': '2024-01-15 16:25:33',
        'user': 'system',
        'userRole': 'System',
        'action': 'create',
        'resource': 'Backup: daily_backup_20240115',
        'status': 'success',
        'ipAddress': '127.0.0.1',
        'details': 'Automated daily backup completed successfully',
      },
      {
        'timestamp': '2024-01-15 16:20:19',
        'user': 'finance@kaziapp.com',
        'userRole': 'Finance Manager',
        'action': 'view',
        'resource': 'Financial Report: Q4_2023',
        'status': 'success',
        'ipAddress': '192.168.1.115',
        'details': 'Accessed quarterly financial report',
      },
      {
        'timestamp': '2024-01-15 16:15:44',
        'user': 'moderator@kaziapp.com',
        'userRole': 'Content Moderator',
        'action': 'update',
        'resource': 'Content Policy: community_guidelines',
        'status': 'warning',
        'ipAddress': '192.168.1.105',
        'details': 'Updated community guidelines - requires approval',
      },
    ];
  }

  void _exportAuditLog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Audit Log'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Export Format'),
              items: const [
                DropdownMenuItem(value: 'csv', child: Text('CSV')),
                DropdownMenuItem(value: 'excel', child: Text('Excel')),
                DropdownMenuItem(value: 'pdf', child: Text('PDF')),
                DropdownMenuItem(value: 'json', child: Text('JSON')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Time Range'),
              items: const [
                DropdownMenuItem(value: '24h', child: Text('Last 24 Hours')),
                DropdownMenuItem(value: '7d', child: Text('Last 7 Days')),
                DropdownMenuItem(value: '30d', child: Text('Last 30 Days')),
                DropdownMenuItem(value: '90d', child: Text('Last 90 Days')),
              ],
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Exporting audit log...'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _viewAuditDetails(Map<String, dynamic> log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Audit Log Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Timestamp', log['timestamp'] as String),
              _buildDetailRow('User', log['user'] as String),
              _buildDetailRow('User Role', log['userRole'] as String),
              _buildDetailRow('Action', log['action'] as String),
              _buildDetailRow('Resource', log['resource'] as String),
              _buildDetailRow('Status', log['status'] as String),
              _buildDetailRow('IP Address', log['ipAddress'] as String),
              _buildDetailRow('Details', log['details'] as String),
            ],
          ),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
