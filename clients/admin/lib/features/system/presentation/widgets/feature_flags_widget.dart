import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as custom_error;
import '../providers/system_providers.dart';

class FeatureFlagsWidget extends ConsumerStatefulWidget {
  final VoidCallback? onChanged;

  const FeatureFlagsWidget({
    super.key,
    this.onChanged,
  });

  @override
  ConsumerState<FeatureFlagsWidget> createState() => _FeatureFlagsWidgetState();
}

class _FeatureFlagsWidgetState extends ConsumerState<FeatureFlagsWidget> {
  String _selectedEnvironment = 'all';
  String _searchQuery = '';

  final List<String> _environments = [
    'all',
    'development',
    'staging',
    'production',
  ];

  @override
  Widget build(BuildContext context) {
    final flagsAsync = ref.watch(featureFlagsProvider);

    return flagsAsync.when(
      data: (flags) => _buildFlagsContent(flags),
      loading: () => const LoadingWidget(),
      error: (error, stack) => custom_error.CustomErrorWidget(
        error: error.toString(),
        onRetry: () => ref.read(featureFlagsProvider.notifier).loadFeatureFlags(),
      ),
    );
  }

  Widget _buildFlagsContent(List<FeatureFlag> flags) {
    final filteredFlags = _filterFlags(flags);

    return Column(
      children: [
        _buildControls(),
        const SizedBox(height: 16),
        Expanded(
          child: filteredFlags.isEmpty
              ? _buildEmptyState()
              : _buildFlagsList(filteredFlags),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Search field
          Expanded(
            flex: 2,
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search feature flags...',
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
          
          // Environment filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedEnvironment,
              decoration: const InputDecoration(
                labelText: 'Environment',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: _environments.map((env) {
                return DropdownMenuItem(
                  value: env,
                  child: Text(env.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedEnvironment = value!;
                });
              },
            ),
          ),
          const SizedBox(width: 16),
          
          // Add flag button
          ElevatedButton.icon(
            onPressed: _createFeatureFlag,
            icon: const Icon(Icons.add),
            label: const Text('Add Flag'),
          ),
        ],
      ),
    );
  }

  Widget _buildFlagsList(List<FeatureFlag> flags) {
    return ListView.builder(
      itemCount: flags.length,
      itemBuilder: (context, index) {
        final flag = flags[index];
        return _buildFlagCard(flag);
      },
    );
  }

  Widget _buildFlagCard(FeatureFlag flag) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        flag.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        flag.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                
                // Environment badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getEnvironmentColor(flag.environment).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    flag.environment.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _getEnvironmentColor(flag.environment),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Toggle switch
                Switch(
                  value: flag.isEnabled,
                  onChanged: (value) => _toggleFlag(flag, value),
                ),
                
                // More options
                PopupMenuButton<String>(
                  itemBuilder: (context) => [
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
                      value: 'duplicate',
                      child: Row(
                        children: [
                          Icon(Icons.copy, size: 16),
                          SizedBox(width: 8),
                          Text('Duplicate'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 16),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) => _handleFlagAction(flag, value),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Configuration preview
            if (flag.configuration.isNotEmpty) ...[
              ExpansionTile(
                title: const Text(
                  'Configuration',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _formatConfiguration(flag.configuration),
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
            ],
            
            // Metadata
            Row(
              children: [
                Icon(Icons.person, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Created by ${flag.createdBy}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Created ${_formatDateTime(flag.createdAt)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                if (flag.updatedAt != null) ...[
                  const SizedBox(width: 16),
                  Icon(Icons.update, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Updated ${_formatDateTime(flag.updatedAt!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flag,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Feature Flags Found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first feature flag to get started',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _createFeatureFlag,
            icon: const Icon(Icons.add),
            label: const Text('Create Feature Flag'),
          ),
        ],
      ),
    );
  }

  List<FeatureFlag> _filterFlags(List<FeatureFlag> flags) {
    return flags.where((flag) {
      final matchesSearch = _searchQuery.isEmpty ||
          flag.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          flag.description.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesEnvironment = _selectedEnvironment == 'all' ||
          flag.environment == _selectedEnvironment;
      
      return matchesSearch && matchesEnvironment;
    }).toList();
  }

  Color _getEnvironmentColor(String environment) {
    switch (environment.toLowerCase()) {
      case 'production':
        return Colors.red;
      case 'staging':
        return Colors.orange;
      case 'development':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatConfiguration(Map<String, dynamic> config) {
    final buffer = StringBuffer();
    config.forEach((key, value) {
      buffer.writeln('$key: $value');
    });
    return buffer.toString().trim();
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _toggleFlag(FeatureFlag flag, bool value) async {
    try {
      await ref.read(featureFlagsProvider.notifier).updateFeatureFlag(flag.id, value);
      widget.onChanged?.call();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Feature flag "${flag.name}" ${value ? 'enabled' : 'disabled'}'),
            backgroundColor: value ? Colors.green : Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update feature flag: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleFlagAction(FeatureFlag flag, String action) {
    switch (action) {
      case 'edit':
        _editFlag(flag);
        break;
      case 'duplicate':
        _duplicateFlag(flag);
        break;
      case 'delete':
        _deleteFlag(flag);
        break;
    }
  }

  void _createFeatureFlag() {
    // TODO: Implement create feature flag dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Feature Flag'),
        content: const Text('Feature flag creation dialog would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onChanged?.call();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _editFlag(FeatureFlag flag) {
    // TODO: Implement edit feature flag dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${flag.name}'),
        content: const Text('Feature flag editing dialog would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onChanged?.call();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _duplicateFlag(FeatureFlag flag) {
    // TODO: Implement duplicate feature flag
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Duplicated feature flag "${flag.name}"'),
        backgroundColor: Colors.blue,
      ),
    );
    widget.onChanged?.call();
  }

  void _deleteFlag(FeatureFlag flag) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Feature Flag'),
        content: Text('Are you sure you want to delete "${flag.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement delete feature flag
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deleted feature flag "${flag.name}"'),
                  backgroundColor: Colors.red,
                ),
              );
              widget.onChanged?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
