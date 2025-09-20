import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../providers/audit_providers.dart';

class ComplianceMonitoringWidget extends ConsumerStatefulWidget {
  const ComplianceMonitoringWidget({super.key});

  @override
  ConsumerState<ComplianceMonitoringWidget> createState() => _ComplianceMonitoringWidgetState();
}

class _ComplianceMonitoringWidgetState extends ConsumerState<ComplianceMonitoringWidget> {
  String _selectedCompliance = 'all';
  String _selectedStatus = 'all';

  @override
  Widget build(BuildContext context) {
    final complianceData = ref.watch(complianceMonitoringProvider);

    return complianceData.when(
      loading: () => const LoadingWidget(),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading compliance data: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(complianceMonitoringProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (data) => _buildComplianceContent(data),
    );
  }

  Widget _buildComplianceContent(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildComplianceOverview(data),
        const SizedBox(height: 24),
        _buildComplianceTable(data),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Compliance Monitoring',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Row(
          children: [
            _buildComplianceFilter(),
            const SizedBox(width: 16),
            _buildStatusFilter(),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _generateComplianceReport,
              icon: const Icon(Icons.file_download),
              label: const Text('Generate Report'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildComplianceFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCompliance,
          items: const [
            DropdownMenuItem(value: 'all', child: Text('All Compliance')),
            DropdownMenuItem(value: 'gdpr', child: Text('GDPR')),
            DropdownMenuItem(value: 'financial', child: Text('Financial')),
            DropdownMenuItem(value: 'security', child: Text('Security')),
            DropdownMenuItem(value: 'operational', child: Text('Operational')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedCompliance = value;
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
            DropdownMenuItem(value: 'compliant', child: Text('Compliant')),
            DropdownMenuItem(value: 'non_compliant', child: Text('Non-Compliant')),
            DropdownMenuItem(value: 'pending', child: Text('Pending Review')),
            DropdownMenuItem(value: 'at_risk', child: Text('At Risk')),
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

  Widget _buildComplianceOverview(Map<String, dynamic> data) {
    final overview = data['overview'] as Map<String, dynamic>? ?? {};
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Compliance Overview',
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
                      _buildComplianceMetric(
                        'Overall Score',
                        '${overview['overallScore'] ?? 85}%',
                        Icons.assessment,
                        Colors.blue,
                        'Good',
                      ),
                      const SizedBox(height: 16),
                      _buildComplianceMetric(
                        'Compliant Items',
                        '${overview['compliantItems'] ?? 142}',
                        Icons.check_circle,
                        Colors.green,
                        '+5 this week',
                      ),
                      const SizedBox(height: 16),
                      _buildComplianceMetric(
                        'Non-Compliant',
                        '${overview['nonCompliantItems'] ?? 8}',
                        Icons.error,
                        Colors.red,
                        '-2 this week',
                      ),
                      const SizedBox(height: 16),
                      _buildComplianceMetric(
                        'Pending Review',
                        '${overview['pendingItems'] ?? 12}',
                        Icons.pending,
                        Colors.orange,
                        '3 urgent',
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
                            child: _buildComplianceMetric(
                              'Overall Score',
                              '${overview['overallScore'] ?? 85}%',
                              Icons.assessment,
                              Colors.blue,
                              'Good',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildComplianceMetric(
                              'Compliant Items',
                              '${overview['compliantItems'] ?? 142}',
                              Icons.check_circle,
                              Colors.green,
                              '+5 this week',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildComplianceMetric(
                              'Non-Compliant',
                              '${overview['nonCompliantItems'] ?? 8}',
                              Icons.error,
                              Colors.red,
                              '-2 this week',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildComplianceMetric(
                              'Pending Review',
                              '${overview['pendingItems'] ?? 12}',
                              Icons.pending,
                              Colors.orange,
                              '3 urgent',
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
                        child: _buildComplianceMetric(
                          'Overall Score',
                          '${overview['overallScore'] ?? 85}%',
                          Icons.assessment,
                          Colors.blue,
                          'Good',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildComplianceMetric(
                          'Compliant Items',
                          '${overview['compliantItems'] ?? 142}',
                          Icons.check_circle,
                          Colors.green,
                          '+5 this week',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildComplianceMetric(
                          'Non-Compliant',
                          '${overview['nonCompliantItems'] ?? 8}',
                          Icons.error,
                          Colors.red,
                          '-2 this week',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildComplianceMetric(
                          'Pending Review',
                          '${overview['pendingItems'] ?? 12}',
                          Icons.pending,
                          Colors.orange,
                          '3 urgent',
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

  Widget _buildComplianceMetric(String title, String value, IconData icon, Color color, String subtitle) {
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

  Widget _buildComplianceTable(Map<String, dynamic> data) {
    final complianceItems = data['items'] as List<dynamic>? ?? _getSampleComplianceItems();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Compliance Items',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 400,
              child: DataTable2(
                columnSpacing: 12,
                horizontalMargin: 12,
                minWidth: 800,
                columns: const [
                  DataColumn2(
                    label: Text('Compliance Area'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Requirement'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Status'),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Text('Last Check'),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text('Next Review'),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text('Actions'),
                    size: ColumnSize.S,
                  ),
                ],
                rows: complianceItems.map((item) => _buildComplianceRow(item)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildComplianceRow(Map<String, dynamic> item) {
    final status = item['status'] as String;
    Color statusColor;
    IconData statusIcon;
    
    switch (status) {
      case 'compliant':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'non_compliant':
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case 'at_risk':
        statusColor = Colors.amber;
        statusIcon = Icons.warning;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return DataRow(
      cells: [
        DataCell(Text(item['area'] as String)),
        DataCell(
          Text(
            item['requirement'] as String,
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
                status.replaceAll('_', ' ').toUpperCase(),
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(item['lastCheck'] as String)),
        DataCell(Text(item['nextReview'] as String)),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.visibility, size: 16),
                onPressed: () => _viewComplianceDetails(item),
                tooltip: 'View Details',
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 16),
                onPressed: () => _editCompliance(item),
                tooltip: 'Edit',
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getSampleComplianceItems() {
    return [
      {
        'area': 'Data Protection',
        'requirement': 'GDPR compliance for user data handling',
        'status': 'compliant',
        'lastCheck': '2024-01-15',
        'nextReview': '2024-04-15',
      },
      {
        'area': 'Financial',
        'requirement': 'PCI DSS compliance for payment processing',
        'status': 'compliant',
        'lastCheck': '2024-01-10',
        'nextReview': '2024-04-10',
      },
      {
        'area': 'Security',
        'requirement': 'ISO 27001 security management',
        'status': 'pending',
        'lastCheck': '2024-01-05',
        'nextReview': '2024-02-05',
      },
      {
        'area': 'Operational',
        'requirement': 'Service level agreement compliance',
        'status': 'at_risk',
        'lastCheck': '2024-01-12',
        'nextReview': '2024-02-12',
      },
      {
        'area': 'Legal',
        'requirement': 'Terms of service updates',
        'status': 'non_compliant',
        'lastCheck': '2023-12-20',
        'nextReview': '2024-01-20',
      },
    ];
  }

  void _generateComplianceReport() {
    // TODO: Implement compliance report generation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Generating compliance report...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _viewComplianceDetails(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Compliance Details: ${item['area']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Requirement: ${item['requirement']}'),
            const SizedBox(height: 8),
            Text('Status: ${item['status']}'),
            const SizedBox(height: 8),
            Text('Last Check: ${item['lastCheck']}'),
            const SizedBox(height: 8),
            Text('Next Review: ${item['nextReview']}'),
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

  void _editCompliance(Map<String, dynamic> item) {
    // TODO: Implement compliance editing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editing compliance item: ${item['area']}'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
