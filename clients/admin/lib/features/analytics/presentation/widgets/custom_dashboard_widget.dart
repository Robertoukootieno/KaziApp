import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/loading_widget.dart';

import '../providers/analytics_providers.dart';

class CustomDashboardWidget extends ConsumerStatefulWidget {
  const CustomDashboardWidget({super.key});

  @override
  ConsumerState<CustomDashboardWidget> createState() => _CustomDashboardWidgetState();
}

class _CustomDashboardWidgetState extends ConsumerState<CustomDashboardWidget> {
  String? _selectedDashboardId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(customDashboardsProvider.notifier).loadDashboards();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardsAsync = ref.watch(customDashboardsProvider);

    return dashboardsAsync.when(
      data: (dashboards) => _buildDashboardContent(dashboards),
      loading: () => const LoadingWidget(),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading dashboard: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(customDashboardsProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent(List<CustomDashboard> dashboards) {
    if (dashboards.isEmpty) {
      return _buildEmptyState();
    }

    final selectedDashboard = _selectedDashboardId != null
        ? dashboards.firstWhere(
            (d) => d.id == _selectedDashboardId,
            orElse: () => dashboards.first,
          )
        : dashboards.first;

    return Column(
      children: [
        _buildDashboardSelector(dashboards),
        const SizedBox(height: 16),
        Expanded(
          child: _buildDashboardView(selectedDashboard),
        ),
      ],
    );
  }

  Widget _buildDashboardSelector(List<CustomDashboard> dashboards) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Dashboard:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedDashboardId ?? dashboards.first.id,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: dashboards.map((dashboard) {
                return DropdownMenuItem(
                  value: dashboard.id,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        dashboard.name,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      if (dashboard.description.isNotEmpty)
                        Text(
                          dashboard.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDashboardId = value;
                });
              },
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editDashboard(dashboards.firstWhere((d) => d.id == (_selectedDashboardId ?? dashboards.first.id))),
            tooltip: 'Edit Dashboard',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteDashboard(dashboards.firstWhere((d) => d.id == (_selectedDashboardId ?? dashboards.first.id))),
            tooltip: 'Delete Dashboard',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardView(CustomDashboard dashboard) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dashboard info
          Card(
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
                              dashboard.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (dashboard.description.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                dashboard.description,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: dashboard.isPublic ? Colors.green.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          dashboard.isPublic ? 'Public' : 'Private',
                          style: TextStyle(
                            fontSize: 12,
                            color: dashboard.isPublic ? Colors.green : Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Created by ${dashboard.createdBy}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Updated ${_formatDateTime(dashboard.updatedAt)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Dashboard widgets
          if (dashboard.widgets.isNotEmpty) ...[
            Text(
              'Widgets (${dashboard.widgets.length})',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildWidgetGrid(dashboard.widgets),
          ] else
            _buildNoWidgetsState(),
        ],
      ),
    );
  }

  Widget _buildWidgetGrid(List<DashboardWidget> widgets) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1200;
        final isTablet = constraints.maxWidth >= 768;
        
        int crossAxisCount;
        if (isDesktop) {
          crossAxisCount = 3;
        } else if (isTablet) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 1;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
          ),
          itemCount: widgets.length,
          itemBuilder: (context, index) {
            final widget = widgets[index];
            return _buildWidgetCard(widget);
          },
        );
      },
    );
  }

  Widget _buildWidgetCard(DashboardWidget widget) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getWidgetIcon(widget.type),
                  size: 20,
                  color: _getWidgetColor(widget.type),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
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
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        _editWidget(widget);
                        break;
                      case 'delete':
                        _deleteWidget(widget);
                        break;
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getWidgetIcon(widget.type),
                        size: 32,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.type.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
            Icons.dashboard,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Custom Dashboards',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first custom dashboard to get started',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _createDashboard,
            icon: const Icon(Icons.add),
            label: const Text('Create Dashboard'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoWidgetsState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.widgets,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No Widgets',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add widgets to customize this dashboard',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _addWidget,
                icon: const Icon(Icons.add),
                label: const Text('Add Widget'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getWidgetIcon(String type) {
    switch (type.toLowerCase()) {
      case 'chart':
        return Icons.bar_chart;
      case 'metric':
        return Icons.speed;
      case 'table':
        return Icons.table_chart;
      case 'map':
        return Icons.map;
      default:
        return Icons.widgets;
    }
  }

  Color _getWidgetColor(String type) {
    switch (type.toLowerCase()) {
      case 'chart':
        return Colors.blue;
      case 'metric':
        return Colors.green;
      case 'table':
        return Colors.orange;
      case 'map':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  // Action handlers
  void _createDashboard() {
    // TODO: Implement create dashboard
  }

  void _editDashboard(CustomDashboard dashboard) {
    // TODO: Implement edit dashboard
  }

  void _deleteDashboard(CustomDashboard dashboard) {
    // TODO: Implement delete dashboard
  }

  void _addWidget() {
    // TODO: Implement add widget
  }

  void _editWidget(DashboardWidget widget) {
    // TODO: Implement edit widget
  }

  void _deleteWidget(DashboardWidget widget) {
    // TODO: Implement delete widget
  }
}
