import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/admin_user.dart';
import '../../../../shared/services/user_management_service.dart';

/// User search filters
class UserSearchFilters {
  final String? search;
  final String? role;
  final String? status;
  final DateTime? createdAfter;
  final DateTime? createdBefore;
  final DateTime? lastLoginAfter;
  final DateTime? lastLoginBefore;
  final bool? isActive;
  final String? sortBy;
  final String? sortOrder;

  const UserSearchFilters({
    this.search,
    this.role,
    this.status,
    this.createdAfter,
    this.createdBefore,
    this.lastLoginAfter,
    this.lastLoginBefore,
    this.isActive,
    this.sortBy,
    this.sortOrder,
  });

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};
    
    if (search != null && search!.isNotEmpty) params['search'] = search;
    if (role != null) params['role'] = role;
    if (status != null) params['status'] = status;
    if (createdAfter != null) params['created_after'] = createdAfter!.toIso8601String();
    if (createdBefore != null) params['created_before'] = createdBefore!.toIso8601String();
    if (lastLoginAfter != null) params['last_login_after'] = lastLoginAfter!.toIso8601String();
    if (lastLoginBefore != null) params['last_login_before'] = lastLoginBefore!.toIso8601String();
    if (isActive != null) params['is_active'] = isActive;
    if (sortBy != null) params['sort_by'] = sortBy;
    if (sortOrder != null) params['sort_order'] = sortOrder;
    
    return params;
  }
}

/// User statistics
class UserStatistics {
  final int totalUsers;
  final int activeUsers;
  final int inactiveUsers;
  final int adminUsers;
  final int newUsersThisMonth;
  final Map<String, int> usersByRole;
  final Map<String, int> usersByStatus;
  final Map<String, int> loginActivity;
  final double averageSessionDuration;

  const UserStatistics({
    required this.totalUsers,
    required this.activeUsers,
    required this.inactiveUsers,
    required this.adminUsers,
    required this.newUsersThisMonth,
    required this.usersByRole,
    required this.usersByStatus,
    required this.loginActivity,
    required this.averageSessionDuration,
  });

  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    return UserStatistics(
      totalUsers: json['total_users'] as int,
      activeUsers: json['active_users'] as int,
      inactiveUsers: json['inactive_users'] as int,
      adminUsers: json['admin_users'] as int,
      newUsersThisMonth: json['new_users_this_month'] as int,
      usersByRole: Map<String, int>.from(json['users_by_role'] as Map),
      usersByStatus: Map<String, int>.from(json['users_by_status'] as Map),
      loginActivity: Map<String, int>.from(json['login_activity'] as Map),
      averageSessionDuration: (json['average_session_duration'] as num).toDouble(),
    );
  }
}

/// Access request model
class AccessRequest {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String requestType;
  final String requestedRole;
  final List<String> requestedPermissions;
  final String justification;
  final String status;
  final DateTime createdAt;
  final DateTime? reviewedAt;
  final String? reviewedBy;
  final String? reviewNotes;

  const AccessRequest({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.requestType,
    required this.requestedRole,
    required this.requestedPermissions,
    required this.justification,
    required this.status,
    required this.createdAt,
    this.reviewedAt,
    this.reviewedBy,
    this.reviewNotes,
  });

  factory AccessRequest.fromJson(Map<String, dynamic> json) {
    return AccessRequest(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      userEmail: json['user_email'] as String,
      requestType: json['request_type'] as String,
      requestedRole: json['requested_role'] as String,
      requestedPermissions: List<String>.from(json['requested_permissions'] as List),
      justification: json['justification'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      reviewedAt: json['reviewed_at'] != null 
          ? DateTime.parse(json['reviewed_at'] as String)
          : null,
      reviewedBy: json['reviewed_by'] as String?,
      reviewNotes: json['review_notes'] as String?,
    );
  }
}

/// Audit trail entry model
class AuditTrailEntry {
  final String id;
  final String userId;
  final String userName;
  final String action;
  final String resource;
  final String resourceId;
  final Map<String, dynamic>? oldValues;
  final Map<String, dynamic>? newValues;
  final String ipAddress;
  final String userAgent;
  final DateTime timestamp;

  const AuditTrailEntry({
    required this.id,
    required this.userId,
    required this.userName,
    required this.action,
    required this.resource,
    required this.resourceId,
    this.oldValues,
    this.newValues,
    required this.ipAddress,
    required this.userAgent,
    required this.timestamp,
  });

  factory AuditTrailEntry.fromJson(Map<String, dynamic> json) {
    return AuditTrailEntry(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      action: json['action'] as String,
      resource: json['resource'] as String,
      resourceId: json['resource_id'] as String,
      oldValues: json['old_values'] as Map<String, dynamic>?,
      newValues: json['new_values'] as Map<String, dynamic>?,
      ipAddress: json['ip_address'] as String,
      userAgent: json['user_agent'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

/// User list state notifier
class UserListNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final UserManagementService _service;

  UserListNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadUsers({
    int page = 1,
    int limit = 50,
    UserSearchFilters? filters,
  }) async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getAllUsers(
        page: page,
        limit: limit,
        filters: filters?.toQueryParameters(),
      );
      state = AsyncValue.data(result);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Admin user list state notifier
class AdminUserListNotifier extends StateNotifier<AsyncValue<List<AdminUser>>> {
  final UserManagementService _service;

  AdminUserListNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadAdminUsers() async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getAdminUsers();
      final adminUsers = (result['users'] as List)
          .map((json) => AdminUser.fromJson(json))
          .toList();
      state = AsyncValue.data(adminUsers);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createAdminUser(AdminUser adminUser) async {
    try {
      await _service.createAdminUser(adminUser.toJson());
      await loadAdminUsers(); // Refresh the list
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateAdminUser(String userId, Map<String, dynamic> updates) async {
    try {
      await _service.updateAdminUser(userId, updates);
      await loadAdminUsers(); // Refresh the list
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteAdminUser(String userId) async {
    try {
      await _service.deleteAdminUser(userId);
      await loadAdminUsers(); // Refresh the list
    } catch (error) {
      rethrow;
    }
  }
}

/// User statistics state notifier
class UserStatisticsNotifier extends StateNotifier<AsyncValue<UserStatistics>> {
  final UserManagementService _service;

  UserStatisticsNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadStatistics() async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getUserStatistics();
      state = AsyncValue.data(UserStatistics.fromJson(result));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Access requests state notifier
class AccessRequestsNotifier extends StateNotifier<AsyncValue<List<AccessRequest>>> {
  final UserManagementService _service;

  AccessRequestsNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadRequests({String? status}) async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getAccessRequests(status: status);
      final requests = (result['requests'] as List)
          .map((json) => AccessRequest.fromJson(json))
          .toList();
      state = AsyncValue.data(requests);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> approveRequest(String requestId, {String? notes}) async {
    try {
      await _service.approveAccessRequest(requestId, notes: notes);
      await loadRequests(); // Refresh the list
    } catch (error) {
      rethrow;
    }
  }

  Future<void> rejectRequest(String requestId, String reason) async {
    try {
      await _service.rejectAccessRequest(requestId, reason);
      await loadRequests(); // Refresh the list
    } catch (error) {
      rethrow;
    }
  }
}

/// Audit trail state notifier
class AuditTrailNotifier extends StateNotifier<AsyncValue<List<AuditTrailEntry>>> {
  final UserManagementService _service;

  AuditTrailNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadAuditTrail({
    String? userId,
    String? action,
    String? resource,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getAuditTrail(
        userId: userId,
        action: action,
        resource: resource,
        startDate: startDate,
        endDate: endDate,
        limit: limit,
      );
      final entries = (result['entries'] as List)
          .map((json) => AuditTrailEntry.fromJson(json))
          .toList();
      state = AsyncValue.data(entries);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Providers
final userListProvider = StateNotifierProvider<UserListNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  final service = ref.watch(userManagementServiceProvider);
  return UserListNotifier(service);
});

final adminUserListProvider = StateNotifierProvider<AdminUserListNotifier, AsyncValue<List<AdminUser>>>((ref) {
  final service = ref.watch(userManagementServiceProvider);
  return AdminUserListNotifier(service);
});

final userStatisticsProvider = StateNotifierProvider<UserStatisticsNotifier, AsyncValue<UserStatistics>>((ref) {
  final service = ref.watch(userManagementServiceProvider);
  return UserStatisticsNotifier(service);
});

final accessRequestsProvider = StateNotifierProvider<AccessRequestsNotifier, AsyncValue<List<AccessRequest>>>((ref) {
  final service = ref.watch(userManagementServiceProvider);
  return AccessRequestsNotifier(service);
});

final auditTrailProvider = StateNotifierProvider<AuditTrailNotifier, AsyncValue<List<AuditTrailEntry>>>((ref) {
  final service = ref.watch(userManagementServiceProvider);
  return AuditTrailNotifier(service);
});

/// Selected user provider
final selectedUserProvider = StateProvider<String?>((ref) => null);

/// User details provider
final userDetailsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, userId) async {
  final service = ref.watch(userManagementServiceProvider);
  return await service.getUserById(userId);
});

/// User permissions provider
final userPermissionsProvider = FutureProvider.family<List<String>, String>((ref, userId) async {
  final service = ref.watch(userManagementServiceProvider);
  final result = await service.getUserPermissions(userId);
  return List<String>.from(result['permissions'] as List);
});

/// Available roles provider
final availableRolesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.watch(userManagementServiceProvider);
  final result = await service.getAvailableRoles();
  return List<Map<String, dynamic>>.from(result['roles'] as List);
});

/// Pending access requests count provider
final pendingAccessRequestsCountProvider = Provider<int>((ref) {
  final requestsAsync = ref.watch(accessRequestsProvider);
  return requestsAsync.when(
    data: (requests) => requests.where((request) => request.status == 'pending').length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});
