import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/access_control.dart';
import '../../../../shared/widgets/stat_card.dart';
import '../../providers/access_control_providers.dart';
// import '../widgets/user_access_dialog.dart';
// import '../widgets/access_request_dialog.dart';
// import '../widgets/audit_log_viewer.dart';

class AccessControlScreen extends ConsumerStatefulWidget {
  const AccessControlScreen({super.key});

  @override
  ConsumerState<AccessControlScreen> createState() => _AccessControlScreenState();
}

class _AccessControlScreenState extends ConsumerState<AccessControlScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final String _searchQuery = '';

  final List<String> _tabs = [
    'User Access',
    'Access Requests',
    'Audit Logs',
    'Role Permissions',
    'Configuration',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userAccessProvider.notifier).loadUsers();
      ref.read(accessRequestProvider.notifier).loadRequests();
      ref.read(auditLogProvider.notifier).loadLogs();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildTabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUserAccessTab(),
                _buildAccessRequestsTab(),
                _buildAuditLogsTab(),
                _buildRolePermissionsTab(),
                _buildConfigurationTab(),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.security,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Access Control & Provisioning',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'Manage user permissions across KaziApp Mkulima and Service Provider platforms',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          _buildStatsCards(),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    final userAccessState = ref.watch(userAccessProvider);
    final accessRequestState = ref.watch(accessRequestProvider);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= AppConstants.desktopBreakpoint;
        final crossAxisCount = isDesktop ? 5 : 3;
        
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: AppConstants.defaultPadding,
          mainAxisSpacing: AppConstants.defaultPadding,
          childAspectRatio: 1.8,
          children: [
            StatCard(
              title: 'Total Users',
              value: userAccessState.users.length.toString(),
              icon: Icons.people,
              color: AppTheme.primarySwatch,
            ),
            StatCard(
              title: 'Active Users',
              value: userAccessState.users.where((u) => u.isActive && !u.isLocked).length.toString(),
              icon: Icons.verified_user,
              color: Colors.green,
            ),
            StatCard(
              title: 'Locked Users',
              value: userAccessState.users.where((u) => u.isLocked).length.toString(),
              icon: Icons.lock,
              color: Colors.red,
            ),
            StatCard(
              title: 'Pending Requests',
              value: accessRequestState.requests.where((r) => r.status == AccessRequestStatus.pending).length.toString(),
              icon: Icons.pending_actions,
              color: Colors.orange,
            ),
            StatCard(
              title: 'Platforms',
              value: '3',
              icon: Icons.apps,
              color: Colors.blue,
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  Widget _buildUserAccessTab() {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(userAccessProvider);
        
        return Column(
          children: [
            _buildUserAccessFilters(),
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(AppConstants.defaultPadding),
                child: state.isLoading && state.users.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : state.error != null
                        ? Center(child: Text('Error: ${state.error}'))
                        : _buildUserAccessTable(state.users),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserAccessFilters() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search users...',
                prefixIcon: Icon(Icons.search),
                isDense: true,
              ),
              onChanged: (value) {
                ref.read(userAccessProvider.notifier).setSearchQuery(value.isEmpty ? null : value);
              },
            ),
          ),
          const SizedBox(width: AppConstants.defaultPadding),
          DropdownButton<UserRole?>(
            hint: const Text('All Roles'),
            value: ref.watch(userAccessProvider).selectedRole,
            items: [
              const DropdownMenuItem<UserRole?>(value: null, child: Text('All Roles')),
              ...UserRole.values.map((role) => DropdownMenuItem(
                value: role,
                child: Text(role.name.toUpperCase()),
              )),
            ],
            onChanged: (role) {
              ref.read(userAccessProvider.notifier).setRoleFilter(role);
            },
          ),
          const SizedBox(width: AppConstants.defaultPadding),
          DropdownButton<AppPlatform?>(
            hint: const Text('All Platforms'),
            value: ref.watch(userAccessProvider).selectedPlatform,
            items: [
              const DropdownMenuItem<AppPlatform?>(value: null, child: Text('All Platforms')),
              ...AppPlatform.values.map((platform) => DropdownMenuItem(
                value: platform,
                child: Text(platform.name.toUpperCase()),
              )),
            ],
            onChanged: (platform) {
              ref.read(userAccessProvider.notifier).setPlatformFilter(platform);
            },
          ),
          const SizedBox(width: AppConstants.defaultPadding),
          OutlinedButton.icon(
            onPressed: _exportUserAccess,
            icon: const Icon(Icons.download),
            label: const Text('Export'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserAccessTable(List<UserAccess> users) {
    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 1000,
      columns: const [
        DataColumn2(label: Text('User'), size: ColumnSize.L),
        DataColumn2(label: Text('Roles'), size: ColumnSize.M),
        DataColumn2(label: Text('Platforms'), size: ColumnSize.M),
        DataColumn2(label: Text('Status'), size: ColumnSize.S),
        DataColumn2(label: Text('Last Login'), size: ColumnSize.M),
        DataColumn2(label: Text('Actions'), size: ColumnSize.M),
      ],
      rows: users.map((user) => _buildUserAccessRow(user)).toList(),
    );
  }

  DataRow _buildUserAccessRow(UserAccess user) {
    return DataRow(
      cells: [
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user.fullName,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                user.email,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Wrap(
            spacing: 4,
            children: user.roles.map((role) => Chip(
              label: Text(
                role.name.toUpperCase(),
                style: const TextStyle(fontSize: 10),
              ),
              backgroundColor: _getRoleColor(role).withValues(alpha: 0.2),
              labelStyle: TextStyle(color: _getRoleColor(role)),
            )).toList(),
          ),
        ),
        DataCell(
          Wrap(
            spacing: 4,
            children: user.allowedPlatforms.map((platform) => Chip(
              label: Text(
                platform.name.toUpperCase(),
                style: const TextStyle(fontSize: 10),
              ),
              backgroundColor: Colors.blue.withValues(alpha: 0.2),
              labelStyle: const TextStyle(color: Colors.blue),
            )).toList(),
          ),
        ),
        DataCell(_buildUserStatusChip(user)),
        DataCell(
          Text(
            user.lastLoginAt != null
                ? _formatDateTime(user.lastLoginAt!)
                : 'Never',
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 18),
                onPressed: () => _editUserAccess(user),
                tooltip: 'Edit Access',
              ),
              IconButton(
                icon: Icon(
                  user.isLocked ? Icons.lock_open : Icons.lock,
                  size: 18,
                ),
                onPressed: () => _toggleUserLock(user),
                tooltip: user.isLocked ? 'Unlock User' : 'Lock User',
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 18),
                onPressed: () => _resetUserPassword(user),
                tooltip: 'Reset Password',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserStatusChip(UserAccess user) {
    Color color;
    String label;
    
    if (user.isLocked) {
      color = Colors.red;
      label = 'LOCKED';
    } else if (!user.isActive) {
      color = Colors.grey;
      label = 'INACTIVE';
    } else if (user.requiresPasswordReset) {
      color = Colors.orange;
      label = 'RESET REQUIRED';
    } else {
      color = Colors.green;
      label = 'ACTIVE';
    }
    
    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 10),
      ),
      backgroundColor: color.withValues(alpha: 0.2),
      labelStyle: TextStyle(color: color),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return Colors.purple;
      case UserRole.admin:
        return Colors.red;
      case UserRole.moderator:
        return Colors.orange;
      case UserRole.farmer:
        return Colors.green;
      case UserRole.serviceProvider:
        return Colors.blue;
      case UserRole.veterinarian:
        return Colors.teal;
      case UserRole.buyer:
        return Colors.indigo;
      case UserRole.vendor:
        return Colors.brown;
      case UserRole.guest:
        return Colors.grey;
    }
  }

  Widget _buildAccessRequestsTab() {
    return const Center(child: Text('Access Requests - Coming Soon'));
  }

  Widget _buildAuditLogsTab() {
    return const Center(child: Text('Audit Logs - Coming Soon'));
  }

  Widget _buildRolePermissionsTab() {
    return const Center(child: Text('Role Permissions - Coming Soon'));
  }

  Widget _buildConfigurationTab() {
    return const Center(child: Text('Configuration - Coming Soon'));
  }

  Widget? _buildFloatingActionButton() {
    final currentTab = _tabController.index;
    
    switch (currentTab) {
      case 0: // User Access
        return FloatingActionButton.extended(
          onPressed: _addUserAccess,
          icon: const Icon(Icons.person_add),
          label: const Text('Add User'),
        );
      case 1: // Access Requests
        return FloatingActionButton.extended(
          onPressed: _createAccessRequest,
          icon: const Icon(Icons.request_page),
          label: const Text('New Request'),
        );
      default:
        return null;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _editUserAccess(UserAccess user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit User Access'),
        content: Text('Edit access for ${user.fullName} - Coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _toggleUserLock(UserAccess user) {
    final notifier = ref.read(userAccessProvider.notifier);
    
    if (user.isLocked) {
      notifier.toggleUserLock(user.userId, false, null);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Lock User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to lock ${user.fullName}?'),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Reason for locking',
                  hintText: 'Enter reason...',
                ),
                onChanged: (value) {
                  // Store reason
                },
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
                notifier.toggleUserLock(user.userId, true, 'Manual lock by admin');
              },
              child: const Text('Lock User'),
            ),
          ],
        ),
      );
    }
  }

  void _resetUserPassword(UserAccess user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Text('Reset password for ${user.fullName}? They will be required to set a new password on next login.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(userAccessProvider.notifier).resetUserPassword(user.userId);
            },
            child: const Text('Reset Password'),
          ),
        ],
      ),
    );
  }

  void _addUserAccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add User Access'),
        content: const Text('Add user access functionality coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _createAccessRequest() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Access Request'),
        content: const Text('Create access request functionality coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _exportUserAccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export functionality coming soon')),
    );
  }
}
