import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/permission_manager.dart';
import '../../../../shared/models/admin_user.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../providers/content_providers.dart';
import '../widgets/content_stats_cards.dart';
import '../widgets/content_filters_widget.dart';
import '../widgets/notification_composer_widget.dart';
import '../widgets/announcement_editor_widget.dart';
import '../widgets/educational_content_widget.dart';
import '../widgets/policy_management_widget.dart';
import '../widgets/communication_channels_widget.dart';

class ContentManagementScreen extends ConsumerStatefulWidget {
  const ContentManagementScreen({super.key});

  @override
  ConsumerState<ContentManagementScreen> createState() =>
      _ContentManagementScreenState();
}

class _ContentManagementScreenState
    extends ConsumerState<ContentManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final Set<String> _selectedContent = {};
  ContentSearchFilters _currentFilters = const ContentSearchFilters();

  final List<String> _tabs = [
    'Notifications',
    'Announcements',
    'Educational Content',
    'Policy Updates',
    'Communication Channels',
    'Templates',
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
    ref.read(notificationListProvider.notifier).loadNotifications();
    ref.read(announcementListProvider.notifier).loadAnnouncements();
    ref.read(contentStatisticsProvider.notifier).loadStatistics();
    ref.read(educationalContentProvider.notifier).loadContent();
    ref.read(policyUpdatesProvider.notifier).loadPolicies();
    ref.read(communicationChannelsProvider.notifier).loadChannels();
  }

  @override
  Widget build(BuildContext context) {
    final permissionManager = ref.watch(permissionManagerProvider);
    
    // Check permissions
    if (!permissionManager.checkCategoryAccess(PermissionCategory.contentManagement).granted) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('Access Denied'),
              Text('You don\'t have permission to access content management.'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildStatsSection(),
          _buildTabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNotificationsTab(),
                _buildAnnouncementsTab(),
                _buildEducationalContentTab(),
                _buildPolicyUpdatesTab(),
                _buildCommunicationChannelsTab(),
                _buildTemplatesTab(),
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
          const Icon(Icons.campaign, size: 32, color: Color(0xFFE65100)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Content Management & Communication',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Manage notifications, announcements, educational content, and communications',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const Spacer(),
          if (_selectedContent.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE65100).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${_selectedContent.length} selected',
                style: const TextStyle(
                  color: Color(0xFFE65100),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh Data',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportContent,
            tooltip: 'Export Content',
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

  Widget _buildStatsSection() {
    final statisticsAsync = ref.watch(contentStatisticsProvider);
    
    return statisticsAsync.when(
      data: (statistics) => ContentStatsCards(statistics: statistics),
      loading: () => const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => SizedBox(
        height: 120,
        child: Center(
          child: Text('Error loading statistics: $error'),
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
        labelColor: const Color(0xFFE65100),
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: const Color(0xFFE65100),
      ),
    );
  }

  Widget _buildNotificationsTab() {
    return Column(
      children: [
        ContentFiltersWidget(
          filters: _currentFilters,
          onFiltersChanged: (filters) {
            setState(() {
              _currentFilters = filters;
            });
            ref.read(notificationListProvider.notifier).loadNotifications(filters: filters);
          },
        ),
        Expanded(
          child: _buildNotificationsList(),
        ),
      ],
    );
  }

  Widget _buildNotificationsList() {
    final notificationsAsync = ref.watch(notificationListProvider);
    
    return notificationsAsync.when(
      data: (notificationsData) {
        final notifications = notificationsData['notifications'] as List<AppNotification>;
        final total = notificationsData['total'] as int;
        
        if (notifications.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No notifications found'),
                Text('Create your first notification'),
              ],
            ),
          );
        }
        
        return Card(
          margin: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: _selectedContent.length == notifications.length,
                      tristate: true,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedContent.addAll(notifications.map((n) => n.id));
                          } else {
                            _selectedContent.clear();
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Showing ${notifications.length} of $total notifications',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    if (_selectedContent.isNotEmpty)
                      Text(
                        '${_selectedContent.length} selected',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFFE65100),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: DataTable2(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 1400,
                  columns: const [
                    DataColumn2(label: Text(''), size: ColumnSize.S),
                    DataColumn2(label: Text('Title'), size: ColumnSize.L),
                    DataColumn2(label: Text('Type'), size: ColumnSize.S),
                    DataColumn2(label: Text('Target Audience'), size: ColumnSize.M),
                    DataColumn2(label: Text('Status'), size: ColumnSize.S),
                    DataColumn2(label: Text('Sent'), size: ColumnSize.M),
                    DataColumn2(label: Text('Engagement'), size: ColumnSize.M),
                    DataColumn2(label: Text('Created'), size: ColumnSize.M),
                    DataColumn2(label: Text('Actions'), size: ColumnSize.M),
                  ],
                  rows: notifications.map((notification) => _buildNotificationRow(notification)).toList(),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const LoadingWidget(),
      error: (error, stack) => ErrorWidget(
        error: error.toString(),
        onRetry: () => ref.read(notificationListProvider.notifier).loadNotifications(),
      ),
    );
  }

  DataRow _buildNotificationRow(AppNotification notification) {
    final isSelected = _selectedContent.contains(notification.id);
    
    return DataRow(
      selected: isSelected,
      onSelectChanged: (selected) {
        setState(() {
          if (selected == true) {
            _selectedContent.add(notification.id);
          } else {
            _selectedContent.remove(notification.id);
          }
        });
      },
      cells: [
        DataCell(
          Checkbox(
            value: isSelected,
            onChanged: (selected) {
              setState(() {
                if (selected == true) {
                  _selectedContent.add(notification.id);
                } else {
                  _selectedContent.remove(notification.id);
                }
              });
            },
          ),
        ),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                notification.title,
                style: const TextStyle(fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                notification.message,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getNotificationTypeColor(notification.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              notification.type,
              style: TextStyle(
                color: _getNotificationTypeColor(notification.type),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        DataCell(
          Text(
            notification.targetAudience,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getNotificationStatusColor(notification.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              notification.status,
              style: TextStyle(
                color: _getNotificationStatusColor(notification.status),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        DataCell(
          Text(
            '${notification.sentCount}/${notification.totalRecipients}',
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.visibility, size: 12, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '${notification.openRate.toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            _formatDate(notification.createdAt),
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.visibility, size: 16),
                onPressed: () => _viewNotificationDetails(notification.id),
                tooltip: 'View Details',
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 16),
                onPressed: () => _editNotification(notification.id),
                tooltip: 'Edit',
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 16),
                onSelected: (action) => _handleNotificationAction(action, notification.id),
                itemBuilder: (context) => [
                  if (notification.status == 'draft')
                    const PopupMenuItem(
                      value: 'send',
                      child: Text('Send Now'),
                    ),
                  const PopupMenuItem(
                    value: 'duplicate',
                    child: Text('Duplicate'),
                  ),
                  const PopupMenuItem(
                    value: 'analytics',
                    child: Text('View Analytics'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnnouncementsTab() {
    return const AnnouncementEditorWidget();
  }

  Widget _buildEducationalContentTab() {
    return const EducationalContentWidget();
  }

  Widget _buildPolicyUpdatesTab() {
    return const PolicyManagementWidget();
  }

  Widget _buildCommunicationChannelsTab() {
    return const CommunicationChannelsWidget();
  }

  Widget _buildTemplatesTab() {
    return const Center(child: Text('Templates - Coming Soon'));
  }

  Widget? _buildFloatingActionButton() {
    final currentTab = _tabController.index;
    final permissionManager = ref.watch(permissionManagerProvider);
    
    switch (currentTab) {
      case 0: // Notifications
        if (permissionManager.checkPermission(Permission.notificationsCreate).granted) {
          return FloatingActionButton.extended(
            onPressed: _createNotification,
            icon: const Icon(Icons.add),
            label: const Text('New Notification'),
          );
        }
        break;
      case 1: // Announcements
        if (permissionManager.checkPermission(Permission.announcementsCreate).granted) {
          return FloatingActionButton.extended(
            onPressed: _createAnnouncement,
            icon: const Icon(Icons.add),
            label: const Text('New Announcement'),
          );
        }
        break;
      case 2: // Educational Content
        if (permissionManager.checkPermission(Permission.contentCreate).granted) {
          return FloatingActionButton.extended(
            onPressed: _createEducationalContent,
            icon: const Icon(Icons.add),
            label: const Text('New Content'),
          );
        }
        break;
      case 3: // Policy Updates
        if (permissionManager.checkPermission(Permission.policiesCreate).granted) {
          return FloatingActionButton.extended(
            onPressed: _createPolicyUpdate,
            icon: const Icon(Icons.add),
            label: const Text('New Policy'),
          );
        }
        break;
    }
    return null;
  }

  Color _getNotificationTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'info':
        return Colors.blue;
      case 'warning':
        return Colors.orange;
      case 'success':
        return Colors.green;
      case 'error':
        return Colors.red;
      case 'marketing':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getNotificationStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'sent':
        return Colors.green;
      case 'draft':
        return Colors.orange;
      case 'scheduled':
        return Colors.blue;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Action handlers
  void _refreshData() {
    _loadInitialData();
  }

  void _exportContent() {
    // TODO: Implement export functionality
  }

  void _openSettings() {
    // TODO: Implement settings
  }

  void _createNotification() {
    // TODO: Implement create notification
  }

  void _createAnnouncement() {
    // TODO: Implement create announcement
  }

  void _createEducationalContent() {
    // TODO: Implement create educational content
  }

  void _createPolicyUpdate() {
    // TODO: Implement create policy update
  }

  void _viewNotificationDetails(String notificationId) {
    // TODO: Implement view notification details
  }

  void _editNotification(String notificationId) {
    // TODO: Implement edit notification
  }

  void _handleNotificationAction(String action, String notificationId) {
    // TODO: Implement notification actions
  }
}
