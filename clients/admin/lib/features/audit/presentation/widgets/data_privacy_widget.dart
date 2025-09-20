import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../providers/audit_providers.dart';

class DataPrivacyWidget extends ConsumerStatefulWidget {
  const DataPrivacyWidget({super.key});

  @override
  ConsumerState<DataPrivacyWidget> createState() => _DataPrivacyWidgetState();
}

class _DataPrivacyWidgetState extends ConsumerState<DataPrivacyWidget> {
  String _selectedCategory = 'all';

  @override
  Widget build(BuildContext context) {
    final privacyData = ref.watch(dataPrivacyProvider);

    return privacyData.when(
      loading: () => const LoadingWidget(),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading privacy data: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(dataPrivacyProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (data) => _buildPrivacyContent(data),
    );
  }

  Widget _buildPrivacyContent(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildPrivacyOverview(data),
        const SizedBox(height: 24),
        _buildDataRequests(data),
        const SizedBox(height: 24),
        _buildPrivacyPolicies(data),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Data Privacy Management',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Row(
          children: [
            _buildCategoryFilter(),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _generatePrivacyReport,
              icon: const Icon(Icons.file_download),
              label: const Text('Privacy Report'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          items: const [
            DropdownMenuItem(value: 'all', child: Text('All Categories')),
            DropdownMenuItem(value: 'gdpr', child: Text('GDPR')),
            DropdownMenuItem(value: 'ccpa', child: Text('CCPA')),
            DropdownMenuItem(value: 'data_requests', child: Text('Data Requests')),
            DropdownMenuItem(value: 'consent', child: Text('Consent Management')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedCategory = value;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildPrivacyOverview(Map<String, dynamic> data) {
    final overview = data['overview'] as Map<String, dynamic>? ?? {};
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Overview',
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
                      _buildPrivacyMetric(
                        'Total Users',
                        '${overview['totalUsers'] ?? 15234}',
                        Icons.people,
                        Colors.blue,
                        'Active data subjects',
                      ),
                      const SizedBox(height: 16),
                      _buildPrivacyMetric(
                        'Consent Rate',
                        '${overview['consentRate'] ?? 94}%',
                        Icons.check_circle,
                        Colors.green,
                        '+2% this month',
                      ),
                      const SizedBox(height: 16),
                      _buildPrivacyMetric(
                        'Data Requests',
                        '${overview['dataRequests'] ?? 23}',
                        Icons.request_page,
                        Colors.orange,
                        '5 pending',
                      ),
                      const SizedBox(height: 16),
                      _buildPrivacyMetric(
                        'Compliance Score',
                        '${overview['complianceScore'] ?? 96}%',
                        Icons.security,
                        Colors.purple,
                        'Excellent',
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
                            child: _buildPrivacyMetric(
                              'Total Users',
                              '${overview['totalUsers'] ?? 15234}',
                              Icons.people,
                              Colors.blue,
                              'Active data subjects',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildPrivacyMetric(
                              'Consent Rate',
                              '${overview['consentRate'] ?? 94}%',
                              Icons.check_circle,
                              Colors.green,
                              '+2% this month',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildPrivacyMetric(
                              'Data Requests',
                              '${overview['dataRequests'] ?? 23}',
                              Icons.request_page,
                              Colors.orange,
                              '5 pending',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildPrivacyMetric(
                              'Compliance Score',
                              '${overview['complianceScore'] ?? 96}%',
                              Icons.security,
                              Colors.purple,
                              'Excellent',
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
                        child: _buildPrivacyMetric(
                          'Total Users',
                          '${overview['totalUsers'] ?? 15234}',
                          Icons.people,
                          Colors.blue,
                          'Active data subjects',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildPrivacyMetric(
                          'Consent Rate',
                          '${overview['consentRate'] ?? 94}%',
                          Icons.check_circle,
                          Colors.green,
                          '+2% this month',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildPrivacyMetric(
                          'Data Requests',
                          '${overview['dataRequests'] ?? 23}',
                          Icons.request_page,
                          Colors.orange,
                          '5 pending',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildPrivacyMetric(
                          'Compliance Score',
                          '${overview['complianceScore'] ?? 96}%',
                          Icons.security,
                          Colors.purple,
                          'Excellent',
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

  Widget _buildPrivacyMetric(String title, String value, IconData icon, Color color, String subtitle) {
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

  Widget _buildDataRequests(Map<String, dynamic> data) {
    final requests = data['requests'] as List<dynamic>? ?? _getSampleDataRequests();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Data Subject Requests',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton.icon(
                  onPressed: _viewAllRequests,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: requests.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final request = requests[index] as Map<String, dynamic>;
                return _buildRequestItem(request);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestItem(Map<String, dynamic> request) {
    final type = request['type'] as String;
    final status = request['status'] as String;
    
    Color statusColor;
    IconData statusIcon;
    
    switch (status) {
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case 'processing':
        statusColor = Colors.blue;
        statusIcon = Icons.hourglass_empty;
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }



    return ListTile(
      leading: CircleAvatar(
        backgroundColor: statusColor.withValues(alpha: 0.1),
        child: Icon(statusIcon, color: statusColor),
      ),
      title: Text(
        '${type.toUpperCase()} Request - ${request['userId']}',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Submitted: ${request['submittedDate']}'),
          Text('Due: ${request['dueDate']}'),
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
            onSelected: (value) => _handleRequestAction(value, request),
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
                value: 'process',
                child: Row(
                  children: [
                    Icon(Icons.play_arrow, size: 16),
                    SizedBox(width: 8),
                    Text('Process'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'complete',
                child: Row(
                  children: [
                    Icon(Icons.check, size: 16),
                    SizedBox(width: 8),
                    Text('Mark Complete'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyPolicies(Map<String, dynamic> data) {
    final policies = data['policies'] as List<dynamic>? ?? _getSamplePolicies();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Privacy Policies & Consent',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                ElevatedButton.icon(
                  onPressed: _updatePolicies,
                  icon: const Icon(Icons.update),
                  label: const Text('Update Policies'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.5,
              children: policies.map((policy) => _buildPolicyCard(policy)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyCard(Map<String, dynamic> policy) {
    final isActive = policy['isActive'] as bool;
    final consentRate = policy['consentRate'] as double;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? Colors.green.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                policy['name'] as String,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Icon(
                isActive ? Icons.check_circle : Icons.pause_circle,
                color: isActive ? Colors.green : Colors.grey,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Version: ${policy['version']}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            'Updated: ${policy['lastUpdated']}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Consent Rate',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '${(consentRate * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: consentRate > 0.9 ? Colors.green : Colors.orange,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getSampleDataRequests() {
    return [
      {
        'userId': 'user_12345',
        'type': 'access',
        'status': 'pending',
        'submittedDate': '2024-01-15',
        'dueDate': '2024-02-14',
      },
      {
        'userId': 'user_67890',
        'type': 'deletion',
        'status': 'processing',
        'submittedDate': '2024-01-12',
        'dueDate': '2024-02-11',
      },
      {
        'userId': 'user_54321',
        'type': 'portability',
        'status': 'completed',
        'submittedDate': '2024-01-08',
        'dueDate': '2024-02-07',
      },
      {
        'userId': 'user_98765',
        'type': 'rectification',
        'status': 'pending',
        'submittedDate': '2024-01-10',
        'dueDate': '2024-02-09',
      },
    ];
  }

  List<Map<String, dynamic>> _getSamplePolicies() {
    return [
      {
        'name': 'Privacy Policy',
        'version': '2.1',
        'lastUpdated': '2024-01-01',
        'isActive': true,
        'consentRate': 0.94,
      },
      {
        'name': 'Cookie Policy',
        'version': '1.3',
        'lastUpdated': '2023-12-15',
        'isActive': true,
        'consentRate': 0.87,
      },
      {
        'name': 'Data Processing Agreement',
        'version': '1.0',
        'lastUpdated': '2023-11-20',
        'isActive': true,
        'consentRate': 0.96,
      },
      {
        'name': 'Marketing Consent',
        'version': '1.2',
        'lastUpdated': '2023-10-10',
        'isActive': false,
        'consentRate': 0.72,
      },
    ];
  }

  void _generatePrivacyReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Generating privacy compliance report...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _viewAllRequests() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening detailed data requests view...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _handleRequestAction(String action, Map<String, dynamic> request) {
    switch (action) {
      case 'view':
        _viewRequestDetails(request);
        break;
      case 'process':
        _processRequest(request);
        break;
      case 'complete':
        _completeRequest(request);
        break;
    }
  }

  void _viewRequestDetails(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${request['type'].toString().toUpperCase()} Request Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User ID: ${request['userId']}'),
            Text('Type: ${request['type']}'),
            Text('Status: ${request['status']}'),
            Text('Submitted: ${request['submittedDate']}'),
            Text('Due: ${request['dueDate']}'),
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

  void _processRequest(Map<String, dynamic> request) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Processing ${request['type']} request for ${request['userId']}...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _completeRequest(Map<String, dynamic> request) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Marking ${request['type']} request as complete...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _updatePolicies() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening policy management interface...'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
