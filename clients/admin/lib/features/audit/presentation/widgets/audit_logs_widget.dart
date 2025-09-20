import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as custom_error;
import '../providers/audit_providers.dart';

class AuditLogsWidget extends ConsumerStatefulWidget {
  const AuditLogsWidget({super.key});

  @override
  ConsumerState<AuditLogsWidget> createState() => _AuditLogsWidgetState();
}

class _AuditLogsWidgetState extends ConsumerState<AuditLogsWidget> {
  String _selectedLevel = 'all';
  String _selectedService = 'all';
  String _searchQuery = '';
  DateTimeRange? _dateRange;

  final List<String> _logLevels = [
    'all',
    'info',
    'warning',
    'error',
    'critical',
  ];

  final List<String> _services = [
    'all',
    'authentication',
    'user_management',
    'financial',
    'analytics',
    'system',
  ];

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(auditLogsProvider);

    return Column(
      children: [
        _buildFilters(),
        const SizedBox(height: 16),
        Expanded(
          child: logsAsync.when(
            data: (logs) => _buildLogsContent(logs),
            loading: () => const LoadingWidget(),
            error: (error, stack) => custom_error.CustomErrorWidget(
              error: error.toString(),
              onRetry: () => ref.read(auditLogsProvider.notifier).loadAuditLogs(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Search field
              Expanded(
                flex: 2,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search audit logs...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              
              // Level filter
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedLevel,
                  decoration: const InputDecoration(
                    labelText: 'Level',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _logLevels.map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text(level.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedLevel = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              
              // Service filter
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedService,
                  decoration: const InputDecoration(
                    labelText: 'Service',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _services.map((service) {
                    return DropdownMenuItem(
                      value: service,
                      child: Text(service.replaceAll('_', ' ').toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedService = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Date range picker
              Expanded(
                child: InkWell(
                  onTap: _selectDateRange,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.date_range, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          _dateRange != null
                              ? '${_formatDate(_dateRange!.start)} - ${_formatDate(_dateRange!.end)}'
                              : 'Select date range',
                          style: TextStyle(
                            color: _dateRange != null ? Colors.black : Colors.grey[600],
                          ),
                        ),
                        const Spacer(),
                        if (_dateRange != null)
                          IconButton(
                            icon: const Icon(Icons.clear, size: 16),
                            onPressed: () {
                              setState(() {
                                _dateRange = null;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Export button
              ElevatedButton.icon(
                onPressed: _exportLogs,
                icon: const Icon(Icons.download),
                label: const Text('Export'),
              ),
              const SizedBox(width: 8),
              
              // Refresh button
              IconButton(
                onPressed: () => ref.read(auditLogsProvider.notifier).loadAuditLogs(),
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogsContent(List<AuditLog> logs) {
    final filteredLogs = _filterLogs(logs);

    if (filteredLogs.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      itemCount: filteredLogs.length,
      itemBuilder: (context, index) {
        final log = filteredLogs[index];
        return _buildLogItem(log);
      },
    );
  }

  Widget _buildLogItem(AuditLog log) {
    final levelColor = _getLevelColor(log.severity);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: levelColor,
            shape: BoxShape.circle,
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: levelColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                log.severity.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: levelColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                log.action,
                style: const TextStyle(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              _formatDateTime(log.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Icon(Icons.person, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                log.userName,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.computer, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                log.resource,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                log.ipAddress,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full action details
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${log.action} on ${log.resource}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),

                if (log.details.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Details:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      _formatMetadata(log.details),
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
                
                const SizedBox(height: 12),
                
                // Actions
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => _viewLogDetails(log),
                      icon: const Icon(Icons.visibility, size: 16),
                      label: const Text('View Details'),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () => _copyLogToClipboard(log),
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('Copy'),
                    ),
                    if (log.severity == 'high' || log.severity == 'critical') ...[
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () => _createIncident(log),
                        icon: const Icon(Icons.report_problem, size: 16),
                        label: const Text('Create Incident'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Audit Logs Found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or date range',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  List<AuditLog> _filterLogs(List<AuditLog> logs) {
    return logs.where((log) {
      final matchesSearch = _searchQuery.isEmpty ||
          log.action.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          log.userName.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesLevel = _selectedLevel == 'all' || log.severity == _selectedLevel;

      final matchesService = _selectedService == 'all' || log.resource == _selectedService;

      final matchesDate = _dateRange == null ||
          (log.timestamp.isAfter(_dateRange!.start) &&
           log.timestamp.isBefore(_dateRange!.end.add(const Duration(days: 1))));

      return matchesSearch && matchesLevel && matchesService && matchesDate;
    }).toList();
  }

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'critical':
        return Colors.red[800]!;
      case 'error':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      case 'info':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatMetadata(Map<String, dynamic> metadata) {
    final buffer = StringBuffer();
    metadata.forEach((key, value) {
      buffer.writeln('$key: $value');
    });
    return buffer.toString().trim();
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
    );
    
    if (picked != null) {
      setState(() {
        _dateRange = picked;
      });
    }
  }

  void _exportLogs() {
    // TODO: Implement export logs
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting audit logs...')),
    );
  }

  void _viewLogDetails(AuditLog log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Log Details - ${log.severity.toUpperCase()}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Timestamp', _formatDateTime(log.timestamp)),
              _buildDetailRow('Severity', log.severity.toUpperCase()),
              _buildDetailRow('Resource', log.resource),
              _buildDetailRow('User', log.userName),
              _buildDetailRow('IP Address', log.ipAddress),
              const SizedBox(height: 12),
              const Text(
                'Action:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(log.action),
              if (log.details.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text(
                  'Details:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _formatMetadata(log.details),
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _copyLogToClipboard(AuditLog log) {
    // TODO: Implement copy to clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Log copied to clipboard')),
    );
  }

  void _createIncident(AuditLog log) {
    // TODO: Implement create incident
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Incident created from log')),
    );
  }
}
