import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../providers/audit_providers.dart';

class RegulatoryReportsWidget extends ConsumerStatefulWidget {
  const RegulatoryReportsWidget({super.key});

  @override
  ConsumerState<RegulatoryReportsWidget> createState() => _RegulatoryReportsWidgetState();
}

class _RegulatoryReportsWidgetState extends ConsumerState<RegulatoryReportsWidget> {
  String _selectedReportType = 'all';
  String _selectedPeriod = 'monthly';

  @override
  Widget build(BuildContext context) {
    final reportsData = ref.watch(regulatoryReportsProvider);

    return reportsData.when(
      loading: () => const LoadingWidget(),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading regulatory reports: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(regulatoryReportsProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (data) => _buildReportsContent(data),
    );
  }

  Widget _buildReportsContent(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildReportsOverview(data),
        const SizedBox(height: 24),
        _buildReportsList(data),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Regulatory Reports',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Row(
          children: [
            _buildReportTypeFilter(),
            const SizedBox(width: 16),
            _buildPeriodFilter(),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _generateNewReport,
              icon: const Icon(Icons.add),
              label: const Text('Generate Report'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReportTypeFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedReportType,
          items: const [
            DropdownMenuItem(value: 'all', child: Text('All Reports')),
            DropdownMenuItem(value: 'financial', child: Text('Financial')),
            DropdownMenuItem(value: 'compliance', child: Text('Compliance')),
            DropdownMenuItem(value: 'security', child: Text('Security')),
            DropdownMenuItem(value: 'operational', child: Text('Operational')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedReportType = value;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildPeriodFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedPeriod,
          items: const [
            DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
            DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
            DropdownMenuItem(value: 'quarterly', child: Text('Quarterly')),
            DropdownMenuItem(value: 'annually', child: Text('Annually')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedPeriod = value;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildReportsOverview(Map<String, dynamic> data) {
    final overview = data['overview'] as Map<String, dynamic>? ?? {};
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reports Overview',
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
                        'Total Reports',
                        '${overview['totalReports'] ?? 45}',
                        Icons.description,
                        Colors.blue,
                        '+3 this month',
                        isLast: false,
                      ),
                      const SizedBox(height: 16),
                      _buildOverviewCard(
                        'Pending',
                        '${overview['pendingReports'] ?? 5}',
                        Icons.pending_actions,
                        Colors.orange,
                        '2 overdue',
                        isLast: false,
                      ),
                      const SizedBox(height: 16),
                      _buildOverviewCard(
                        'Submitted',
                        '${overview['submittedReports'] ?? 38}',
                        Icons.check_circle,
                        Colors.green,
                        'On time: 95%',
                        isLast: false,
                      ),
                      const SizedBox(height: 16),
                      _buildOverviewCard(
                        'Compliance Rate',
                        '${overview['complianceRate'] ?? 92}%',
                        Icons.assessment,
                        Colors.purple,
                        '+2% this quarter',
                        isLast: true,
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
                              'Total Reports',
                              '${overview['totalReports'] ?? 45}',
                              Icons.description,
                              Colors.blue,
                              '+3 this month',
                              isLast: false,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildOverviewCard(
                              'Pending',
                              '${overview['pendingReports'] ?? 5}',
                              Icons.pending_actions,
                              Colors.orange,
                              '2 overdue',
                              isLast: false,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildOverviewCard(
                              'Submitted',
                              '${overview['submittedReports'] ?? 38}',
                              Icons.check_circle,
                              Colors.green,
                              'On time: 95%',
                              isLast: false,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildOverviewCard(
                              'Compliance Rate',
                              '${overview['complianceRate'] ?? 92}%',
                              Icons.assessment,
                              Colors.purple,
                              '+2% this quarter',
                              isLast: true,
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
                          'Total Reports',
                          '${overview['totalReports'] ?? 45}',
                          Icons.description,
                          Colors.blue,
                          '+3 this month',
                          isLast: false,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildOverviewCard(
                          'Pending',
                          '${overview['pendingReports'] ?? 5}',
                          Icons.pending_actions,
                          Colors.orange,
                          '2 overdue',
                          isLast: false,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildOverviewCard(
                          'Submitted',
                          '${overview['submittedReports'] ?? 38}',
                          Icons.check_circle,
                          Colors.green,
                          'On time: 95%',
                          isLast: false,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildOverviewCard(
                          'Compliance Rate',
                          '${overview['complianceRate'] ?? 92}%',
                          Icons.assessment,
                          Colors.purple,
                          '+2% this quarter',
                          isLast: true,
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

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color, String subtitle, {bool isLast = false}) {
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

  Widget _buildReportsList(Map<String, dynamic> data) {
    final reports = data['reports'] as List<dynamic>? ?? _getSampleReports();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Reports',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reports.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final report = reports[index] as Map<String, dynamic>;
                return _buildReportItem(report);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportItem(Map<String, dynamic> report) {
    final status = report['status'] as String;
    Color statusColor;
    IconData statusIcon;
    
    switch (status) {
      case 'submitted':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case 'overdue':
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      case 'draft':
        statusColor = Colors.grey;
        statusIcon = Icons.edit;
        break;
      default:
        statusColor = Colors.blue;
        statusIcon = Icons.description;
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: statusColor.withValues(alpha: 0.1),
        child: Icon(statusIcon, color: statusColor),
      ),
      title: Text(
        report['title'] as String,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Type: ${report['type']} • Period: ${report['period']}'),
          const SizedBox(height: 4),
          Text('Due: ${report['dueDate']} • Generated: ${report['generatedDate']}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status.toUpperCase(),
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            onSelected: (value) => _handleReportAction(value, report),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'view',
                child: Row(
                  children: [
                    Icon(Icons.visibility, size: 16),
                    SizedBox(width: 8),
                    Text('View'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'download',
                child: Row(
                  children: [
                    Icon(Icons.download, size: 16),
                    SizedBox(width: 8),
                    Text('Download'),
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
                value: 'submit',
                child: Row(
                  children: [
                    Icon(Icons.send, size: 16),
                    SizedBox(width: 8),
                    Text('Submit'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getSampleReports() {
    return [
      {
        'title': 'Monthly Financial Compliance Report',
        'type': 'Financial',
        'period': 'January 2024',
        'status': 'submitted',
        'dueDate': '2024-02-05',
        'generatedDate': '2024-02-03',
      },
      {
        'title': 'Quarterly Security Assessment',
        'type': 'Security',
        'period': 'Q4 2023',
        'status': 'pending',
        'dueDate': '2024-01-31',
        'generatedDate': '2024-01-28',
      },
      {
        'title': 'Annual Data Protection Report',
        'type': 'Compliance',
        'period': '2023',
        'status': 'draft',
        'dueDate': '2024-03-15',
        'generatedDate': '2024-01-20',
      },
      {
        'title': 'Weekly Operational Summary',
        'type': 'Operational',
        'period': 'Week 3, Jan 2024',
        'status': 'overdue',
        'dueDate': '2024-01-22',
        'generatedDate': '2024-01-21',
      },
      {
        'title': 'Monthly User Activity Report',
        'type': 'Operational',
        'period': 'December 2023',
        'status': 'submitted',
        'dueDate': '2024-01-10',
        'generatedDate': '2024-01-08',
      },
    ];
  }

  void _generateNewReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate New Report'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Report Type'),
              items: const [
                DropdownMenuItem(value: 'financial', child: Text('Financial')),
                DropdownMenuItem(value: 'compliance', child: Text('Compliance')),
                DropdownMenuItem(value: 'security', child: Text('Security')),
                DropdownMenuItem(value: 'operational', child: Text('Operational')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Period'),
              items: const [
                DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                DropdownMenuItem(value: 'quarterly', child: Text('Quarterly')),
                DropdownMenuItem(value: 'annually', child: Text('Annually')),
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
                  content: Text('Generating report...'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }

  void _handleReportAction(String action, Map<String, dynamic> report) {
    switch (action) {
      case 'view':
        _viewReport(report);
        break;
      case 'download':
        _downloadReport(report);
        break;
      case 'edit':
        _editReport(report);
        break;
      case 'submit':
        _submitReport(report);
        break;
    }
  }

  void _viewReport(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(report['title'] as String),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${report['type']}'),
            Text('Period: ${report['period']}'),
            Text('Status: ${report['status']}'),
            Text('Due Date: ${report['dueDate']}'),
            Text('Generated: ${report['generatedDate']}'),
            const SizedBox(height: 16),
            const Text('Report content would be displayed here...'),
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

  void _downloadReport(Map<String, dynamic> report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading ${report['title']}...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _editReport(Map<String, dynamic> report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editing ${report['title']}...'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _submitReport(Map<String, dynamic> report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Submitting ${report['title']}...'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
