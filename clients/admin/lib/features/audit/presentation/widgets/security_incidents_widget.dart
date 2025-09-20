import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../providers/audit_providers.dart';

class SecurityIncidentsWidget extends ConsumerStatefulWidget {
  const SecurityIncidentsWidget({super.key});

  @override
  ConsumerState<SecurityIncidentsWidget> createState() => _SecurityIncidentsWidgetState();
}

class _SecurityIncidentsWidgetState extends ConsumerState<SecurityIncidentsWidget> {
  String _selectedSeverity = 'all';
  String _selectedStatus = 'all';

  @override
  Widget build(BuildContext context) {
    final incidentsData = ref.watch(securityIncidentsProvider);

    return incidentsData.when(
      loading: () => const LoadingWidget(),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading security incidents: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(securityIncidentsProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (data) => _buildIncidentsContent(data),
    );
  }

  Widget _buildIncidentsContent(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildSecurityOverview(data),
        const SizedBox(height: 24),
        _buildIncidentsList(data),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Security Incidents',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Row(
          children: [
            _buildSeverityFilter(),
            const SizedBox(width: 16),
            _buildStatusFilter(),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _createIncident,
              icon: const Icon(Icons.add),
              label: const Text('Report Incident'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSeverityFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSeverity,
          items: const [
            DropdownMenuItem(value: 'all', child: Text('All Severities')),
            DropdownMenuItem(value: 'critical', child: Text('Critical')),
            DropdownMenuItem(value: 'high', child: Text('High')),
            DropdownMenuItem(value: 'medium', child: Text('Medium')),
            DropdownMenuItem(value: 'low', child: Text('Low')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedSeverity = value;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedStatus,
          items: const [
            DropdownMenuItem(value: 'all', child: Text('All Status')),
            DropdownMenuItem(value: 'open', child: Text('Open')),
            DropdownMenuItem(value: 'investigating', child: Text('Investigating')),
            DropdownMenuItem(value: 'resolved', child: Text('Resolved')),
            DropdownMenuItem(value: 'closed', child: Text('Closed')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedStatus = value;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildSecurityOverview(Map<String, dynamic> data) {
    final overview = data['overview'] as Map<String, dynamic>? ?? {};
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Security Overview',
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
                      _buildSecurityMetric(
                        'Total Incidents',
                        '${overview['totalIncidents'] ?? 45}',
                        Icons.security,
                        Colors.blue,
                        '3 this week',
                      ),
                      const SizedBox(height: 16),
                      _buildSecurityMetric(
                        'Critical',
                        '${overview['criticalIncidents'] ?? 2}',
                        Icons.error,
                        Colors.red,
                        '1 active',
                      ),
                      const SizedBox(height: 16),
                      _buildSecurityMetric(
                        'Resolved',
                        '${overview['resolvedIncidents'] ?? 38}',
                        Icons.check_circle,
                        Colors.green,
                        '84% resolution rate',
                      ),
                      const SizedBox(height: 16),
                      _buildSecurityMetric(
                        'Avg Response Time',
                        '${overview['avgResponseTime'] ?? 2.5}h',
                        Icons.timer,
                        Colors.orange,
                        'Target: <4h',
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
                            child: _buildSecurityMetric(
                              'Total Incidents',
                              '${overview['totalIncidents'] ?? 45}',
                              Icons.security,
                              Colors.blue,
                              '3 this week',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSecurityMetric(
                              'Critical',
                              '${overview['criticalIncidents'] ?? 2}',
                              Icons.error,
                              Colors.red,
                              '1 active',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSecurityMetric(
                              'Resolved',
                              '${overview['resolvedIncidents'] ?? 38}',
                              Icons.check_circle,
                              Colors.green,
                              '84% resolution rate',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildSecurityMetric(
                              'Avg Response Time',
                              '${overview['avgResponseTime'] ?? 2.5}h',
                              Icons.timer,
                              Colors.orange,
                              'Target: <4h',
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
                        child: _buildSecurityMetric(
                          'Total Incidents',
                          '${overview['totalIncidents'] ?? 45}',
                          Icons.security,
                          Colors.blue,
                          '3 this week',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSecurityMetric(
                          'Critical',
                          '${overview['criticalIncidents'] ?? 2}',
                          Icons.error,
                          Colors.red,
                          '1 active',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSecurityMetric(
                          'Resolved',
                          '${overview['resolvedIncidents'] ?? 38}',
                          Icons.check_circle,
                          Colors.green,
                          '84% resolution rate',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSecurityMetric(
                          'Avg Response Time',
                          '${overview['avgResponseTime'] ?? 2.5}h',
                          Icons.timer,
                          Colors.orange,
                          'Target: <4h',
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

  Widget _buildSecurityMetric(String title, String value, IconData icon, Color color, String subtitle) {
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

  Widget _buildIncidentsList(Map<String, dynamic> data) {
    final incidents = data['incidents'] as List<dynamic>? ?? _getSampleIncidents();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Security Incidents',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: incidents.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final incident = incidents[index] as Map<String, dynamic>;
                return _buildIncidentItem(incident);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentItem(Map<String, dynamic> incident) {
    final severity = incident['severity'] as String;
    final status = incident['status'] as String;
    
    Color severityColor;
    switch (severity) {
      case 'critical':
        severityColor = Colors.red;
        break;
      case 'high':
        severityColor = Colors.orange;
        break;
      case 'medium':
        severityColor = Colors.yellow.shade700;
        break;
      case 'low':
        severityColor = Colors.green;
        break;
      default:
        severityColor = Colors.grey;
    }

    Color statusColor;
    IconData statusIcon;
    switch (status) {
      case 'open':
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      case 'investigating':
        statusColor = Colors.orange;
        statusIcon = Icons.search;
        break;
      case 'resolved':
        statusColor = Colors.blue;
        statusIcon = Icons.check;
        break;
      case 'closed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return ExpansionTile(
      leading: CircleAvatar(
        backgroundColor: severityColor.withValues(alpha: 0.1),
        child: Icon(Icons.security, color: severityColor),
      ),
      title: Text(
        incident['title'] as String,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: severityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  severity.toUpperCase(),
                  style: TextStyle(
                    color: severityColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 12, color: statusColor),
                    const SizedBox(width: 2),
                    Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('Reported: ${incident['reportedDate']} • Assigned: ${incident['assignedTo']}'),
        ],
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) => _handleIncidentAction(value, incident),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'view',
            child: Row(
              children: [
                Icon(Icons.visibility, size: 16),
                SizedBox(width: 8),
                Text('View Details'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit, size: 16),
                SizedBox(width: 8),
                Text('Edit'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'assign',
            child: Row(
              children: [
                Icon(Icons.person_add, size: 16),
                SizedBox(width: 8),
                Text('Assign'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'resolve',
            child: Row(
              children: [
                Icon(Icons.check, size: 16),
                SizedBox(width: 8),
                Text('Mark Resolved'),
              ],
            ),
          ),
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Description:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(incident['description'] as String),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Impact:',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(incident['impact'] as String),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Affected Systems:',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text((incident['affectedSystems'] as List).join(', ')),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _viewIncidentTimeline(incident),
                    icon: const Icon(Icons.timeline),
                    label: const Text('View Timeline'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _addIncidentUpdate(incident),
                    icon: const Icon(Icons.add_comment),
                    label: const Text('Add Update'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getSampleIncidents() {
    return [
      {
        'id': 'INC-001',
        'title': 'Suspicious Login Attempts',
        'description': 'Multiple failed login attempts detected from unusual IP addresses',
        'severity': 'high',
        'status': 'investigating',
        'reportedDate': '2024-01-15 14:30',
        'assignedTo': 'Security Team',
        'impact': 'Potential account compromise risk',
        'affectedSystems': ['Authentication Service', 'User Database'],
      },
      {
        'id': 'INC-002',
        'title': 'DDoS Attack Detected',
        'description': 'Distributed denial of service attack targeting API endpoints',
        'severity': 'critical',
        'status': 'open',
        'reportedDate': '2024-01-15 16:45',
        'assignedTo': 'Infrastructure Team',
        'impact': 'Service degradation and potential downtime',
        'affectedSystems': ['API Gateway', 'Load Balancer'],
      },
      {
        'id': 'INC-003',
        'title': 'Data Breach Attempt',
        'description': 'Unauthorized access attempt to sensitive user data',
        'severity': 'critical',
        'status': 'resolved',
        'reportedDate': '2024-01-12 09:15',
        'assignedTo': 'Security Team',
        'impact': 'Potential data exposure',
        'affectedSystems': ['User Database', 'Payment System'],
      },
      {
        'id': 'INC-004',
        'title': 'Malware Detection',
        'description': 'Malicious software detected on admin workstation',
        'severity': 'medium',
        'status': 'closed',
        'reportedDate': '2024-01-10 11:20',
        'assignedTo': 'IT Support',
        'impact': 'Potential system compromise',
        'affectedSystems': ['Admin Workstation'],
      },
    ];
  }

  void _createIncident() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Security Incident'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Incident Title'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Severity'),
              items: const [
                DropdownMenuItem(value: 'low', child: Text('Low')),
                DropdownMenuItem(value: 'medium', child: Text('Medium')),
                DropdownMenuItem(value: 'high', child: Text('High')),
                DropdownMenuItem(value: 'critical', child: Text('Critical')),
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
                  content: Text('Security incident reported successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  void _handleIncidentAction(String action, Map<String, dynamic> incident) {
    switch (action) {
      case 'view':
        _viewIncidentDetails(incident);
        break;
      case 'edit':
        _editIncident(incident);
        break;
      case 'assign':
        _assignIncident(incident);
        break;
      case 'resolve':
        _resolveIncident(incident);
        break;
    }
  }

  void _viewIncidentDetails(Map<String, dynamic> incident) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Incident Details: ${incident['id']}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Title: ${incident['title']}'),
              const SizedBox(height: 8),
              Text('Description: ${incident['description']}'),
              const SizedBox(height: 8),
              Text('Severity: ${incident['severity']}'),
              const SizedBox(height: 8),
              Text('Status: ${incident['status']}'),
              const SizedBox(height: 8),
              Text('Reported: ${incident['reportedDate']}'),
              const SizedBox(height: 8),
              Text('Assigned To: ${incident['assignedTo']}'),
              const SizedBox(height: 8),
              Text('Impact: ${incident['impact']}'),
              const SizedBox(height: 8),
              Text('Affected Systems: ${(incident['affectedSystems'] as List).join(', ')}'),
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

  void _editIncident(Map<String, dynamic> incident) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editing incident: ${incident['id']}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _assignIncident(Map<String, dynamic> incident) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Assigning incident: ${incident['id']}'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _resolveIncident(Map<String, dynamic> incident) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Resolving incident: ${incident['id']}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _viewIncidentTimeline(Map<String, dynamic> incident) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing timeline for: ${incident['id']}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _addIncidentUpdate(Map<String, dynamic> incident) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Adding update to: ${incident['id']}'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
