import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/permission_manager.dart';
import '../../../../shared/models/admin_user.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../providers/user_management_providers.dart';
import '../widgets/user_details_dialog.dart';
import '../widgets/user_filters_widget.dart';
import '../widgets/user_stats_cards.dart';
import '../widgets/role_management_widget.dart';
import '../widgets/access_request_widget.dart';
import '../widgets/audit_trail_widget.dart';
import '../widgets/bulk_user_actions_widget.dart';

class AdvancedUserManagementScreen extends ConsumerStatefulWidget {
  const AdvancedUserManagementScreen({super.key});

  @override
  ConsumerState<AdvancedUserManagementScreen> createState() =>
      _AdvancedUserManagementScreenState();
}

class _AdvancedUserManagementScreenState
    extends ConsumerState<AdvancedUserManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final Set<String> _selectedUsers = {};
  UserSearchFilters _currentFilters = const UserSearchFilters();

  final List<String> _tabs = [
    'All Users',
    'Admin Users',
    'Role Management',
    'Access Requests',
    'Audit Trail',
    'Compliance Reports',
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
    ref.read(userListProvider.notifier).loadUsers();
    ref.read(adminUserListProvider.notifier).loadAdminUsers();
    ref.read(userStatisticsProvider.notifier).loadStatistics();
    ref.read(accessRequestsProvider.notifier).loadRequests();
    ref.read(auditTrailProvider.notifier).loadAuditTrail();
  }

  @override
  Widget build(BuildContext context) {
    final permissionManager = ref.watch(permissionManagerProvider);
    
    // Check permissions
    if (!permissionManager.checkCategoryAccess(PermissionCategory.userManagement).granted) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('Access Denied'),
              Text('You don\'t have permission to access user management.'),
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
                _buildAllUsersTab(),
                _buildAdminUsersTab(),
                _buildRoleManagementTab(),
                _buildAccessRequestsTab(),
                _buildAuditTrailTab(),
                _buildComplianceReportsTab(),
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
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.people, size: 32, color: Color(0xFF7B1FA2)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Management & Access Control',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Manage users, roles, permissions, and access control',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const Spacer(),
          if (_selectedUsers.isNotEmpty) ...[
            BulkUserActionsWidget(
              selectedCount: _selectedUsers.length,
              onBulkActivate: _handleBulkActivate,
              onBulkDeactivate: _handleBulkDeactivate,
              onBulkRoleChange: _handleBulkRoleChange,
              onBulkExport: _handleBulkExport,
              onBulkNotify: _handleBulkNotify,
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
            onPressed: _exportUsers,
            tooltip: 'Export Users',
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
    final statisticsAsync = ref.watch(userStatisticsProvider);
    
    return statisticsAsync.when(
      data: (statistics) => UserStatsCards(statistics: statistics),
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
        labelColor: const Color(0xFF7B1FA2),
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: const Color(0xFF7B1FA2),
      ),
    );
  }

  Widget _buildAllUsersTab() {
    return Column(
      children: [
        UserFiltersWidget(
          filters: _currentFilters,
          onFiltersChanged: (filters) {
            setState(() {
              _currentFilters = filters;
            });
            ref.read(userListProvider.notifier).loadUsers(filters: filters);
          },
        ),
        Expanded(
          child: _buildUsersList(),
        ),
      ],
    );
  }

  Widget _buildUsersList() {
    final usersAsync = ref.watch(userListProvider);
    
    return usersAsync.when(
      data: (usersData) {
        final users = usersData['users'] as List<Map<String, dynamic>>;
        final total = usersData['total'] as int;
        
        if (users.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No users found'),
                Text('Try adjusting your filters'),
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
                      value: _selectedUsers.length == users.length,
                      tristate: true,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedUsers.addAll(users.map((u) => u['id'] as String));
                          } else {
                            _selectedUsers.clear();
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Showing ${users.length} of $total users',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    if (_selectedUsers.isNotEmpty)
                      Text(
                        '${_selectedUsers.length} selected',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF7B1FA2),
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
                    DataColumn2(label: Text('User'), size: ColumnSize.L),
                    DataColumn2(label: Text('Role'), size: ColumnSize.M),
                    DataColumn2(label: Text('Status'), size: ColumnSize.S),
                    DataColumn2(label: Text('Last Login'), size: ColumnSize.M),
                    DataColumn2(label: Text('Permissions'), size: ColumnSize.M),
                    DataColumn2(label: Text('Created'), size: ColumnSize.S),
                    DataColumn2(label: Text('Actions'), size: ColumnSize.M),
                  ],
                  rows: users.map((user) => _buildUserRow(user)).toList(),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const LoadingWidget(),
      error: (error, stack) => ErrorWidget(
        error: error.toString(),
        onRetry: () => ref.read(userListProvider.notifier).loadUsers(),
      ),
    );
  }

  DataRow _buildUserRow(Map<String, dynamic> user) {
    final userId = user['id'] as String;
    final isSelected = _selectedUsers.contains(userId);
    
    return DataRow(
      selected: isSelected,
      onSelectChanged: (selected) {
        setState(() {
          if (selected == true) {
            _selectedUsers.add(userId);
          } else {
            _selectedUsers.remove(userId);
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
                  _selectedUsers.add(userId);
                } else {
                  _selectedUsers.remove(userId);
                }
              });
            },
          ),
        ),
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: user['profile_picture'] != null && user['profile_picture'].isNotEmpty
                    ? NetworkImage(user['profile_picture'])
                    : null,
                child: user['profile_picture'] == null || user['profile_picture'].isEmpty
                    ? Text('${user['first_name'][0]}${user['last_name'][0]}')
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${user['first_name']} ${user['last_name']}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      user['email'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (user['phone_number'] != null)
                      Text(
                        user['phone_number'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getRoleColor(user['role']).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              user['role'],
              style: TextStyle(
                color: _getRoleColor(user['role']),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(user['status']).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              user['status'],
              style: TextStyle(
                color: _getStatusColor(user['status']),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        DataCell(
          Text(
            user['last_login'] != null
                ? _formatDate(DateTime.parse(user['last_login']))
                : 'Never',
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell(
          Text(
            '${user['permissions_count'] ?? 0} permissions',
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell(
          Text(
            _formatDate(DateTime.parse(user['created_at'])),
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.visibility, size: 16),
                onPressed: () => _viewUserDetails(userId),
                tooltip: 'View Details',
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 16),
                onPressed: () => _editUser(userId),
                tooltip: 'Edit User',
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 16),
                onSelected: (action) => _handleUserAction(action, userId),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'reset_password',
                    child: Text('Reset Password'),
                  ),
                  const PopupMenuItem(
                    value: 'change_role',
                    child: Text('Change Role'),
                  ),
                  const PopupMenuItem(
                    value: 'view_audit',
                    child: Text('View Audit Trail'),
                  ),
                  PopupMenuItem(
                    value: user['status'] == 'active' ? 'deactivate' : 'activate',
                    child: Text(user['status'] == 'active' ? 'Deactivate' : 'Activate'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdminUsersTab() {
    final adminUsersAsync = ref.watch(adminUserListProvider);
    
    return adminUsersAsync.when(
      data: (adminUsers) => ListView.builder(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: adminUsers.length,
        itemBuilder: (context, index) {
          final adminUser = adminUsers[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: adminUser.profilePicture.isNotEmpty
                    ? NetworkImage(adminUser.profilePicture)
                    : null,
                child: adminUser.profilePicture.isEmpty
                    ? Text('${adminUser.firstName[0]}${adminUser.lastName[0]}')
                    : null,
              ),
              title: Text('${adminUser.firstName} ${adminUser.lastName}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(adminUser.email),
                  Text('Role: ${adminUser.role.name}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: adminUser.isActive ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      adminUser.isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        color: adminUser.isActive ? Colors.green : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    onSelected: (action) => _handleAdminUserAction(action, adminUser.id),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'permissions',
                        child: Text('Manage Permissions'),
                      ),
                      const PopupMenuItem(
                        value: 'audit',
                        child: Text('View Audit Trail'),
                      ),
                      PopupMenuItem(
                        value: adminUser.isActive ? 'deactivate' : 'activate',
                        child: Text(adminUser.isActive ? 'Deactivate' : 'Activate'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      loading: () => const LoadingWidget(),
      error: (error, stack) => ErrorWidget(
        error: error.toString(),
        onRetry: () => ref.read(adminUserListProvider.notifier).loadAdminUsers(),
      ),
    );
  }

  Widget _buildRoleManagementTab() {
    return const RoleManagementWidget();
  }

  Widget _buildAccessRequestsTab() {
    return const AccessRequestWidget();
  }

  Widget _buildAuditTrailTab() {
    return const AuditTrailWidget();
  }

  Widget _buildComplianceReportsTab() {
    return const Center(child: Text('Compliance Reports - Coming Soon'));
  }

  Widget? _buildFloatingActionButton() {
    final currentTab = _tabController.index;
    final permissionManager = ref.watch(permissionManagerProvider);
    
    switch (currentTab) {
      case 0: // All Users
      case 1: // Admin Users
        if (permissionManager.checkPermission(Permission.usersCreate).granted) {
          return FloatingActionButton.extended(
            onPressed: _createUser,
            icon: const Icon(Icons.person_add),
            label: Text(currentTab == 1 ? 'Add Admin User' : 'Add User'),
          );
        }
        break;
      case 2: // Role Management
        if (permissionManager.checkPermission(Permission.rolesCreate).granted) {
          return FloatingActionButton.extended(
            onPressed: _createRole,
            icon: const Icon(Icons.add),
            label: const Text('Create Role'),
          );
        }
        break;
    }
    return null;
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'super_admin':
        return Colors.red;
      case 'admin':
        return Colors.orange;
      case 'manager':
        return Colors.blue;
      case 'moderator':
        return Colors.green;
      case 'analyst':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      case 'suspended':
        return Colors.orange;
      case 'pending':
        return Colors.blue;
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

  void _exportUsers() {
    // TODO: Implement export functionality
  }

  void _openSettings() {
    // TODO: Implement settings
  }

  void _createUser() {
    // TODO: Implement create user
  }

  void _createRole() {
    // TODO: Implement create role
  }

  void _viewUserDetails(String userId) {
    // TODO: Implement view user details
  }

  void _editUser(String userId) {
    // TODO: Implement edit user
  }

  void _handleUserAction(String action, String userId) {
    // TODO: Implement user actions
  }

  void _handleAdminUserAction(String action, String userId) {
    // TODO: Implement admin user actions
  }

  void _handleBulkActivate() {
    // TODO: Implement bulk activate
  }

  void _handleBulkDeactivate() {
    // TODO: Implement bulk deactivate
  }

  void _handleBulkRoleChange() {
    // TODO: Implement bulk role change
  }

  void _handleBulkExport() {
    // TODO: Implement bulk export
  }

  void _handleBulkNotify() {
    // TODO: Implement bulk notify
  }
}
