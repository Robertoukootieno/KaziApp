import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/access_control.dart';
import '../../../shared/services/access_control_service.dart';

// State classes
class UserAccessState {
  final List<UserAccess> users;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final bool hasMore;
  final String? searchQuery;
  final UserRole? selectedRole;
  final AppPlatform? selectedPlatform;

  const UserAccessState({
    this.users = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
    this.searchQuery,
    this.selectedRole,
    this.selectedPlatform,
  });

  UserAccessState copyWith({
    List<UserAccess>? users,
    bool? isLoading,
    String? error,
    int? currentPage,
    bool? hasMore,
    String? searchQuery,
    UserRole? selectedRole,
    AppPlatform? selectedPlatform,
  }) {
    return UserAccessState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedRole: selectedRole ?? this.selectedRole,
      selectedPlatform: selectedPlatform ?? this.selectedPlatform,
    );
  }
}

class AccessRequestState {
  final List<AccessRequest> requests;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final bool hasMore;
  final AccessRequestStatus? selectedStatus;
  final AccessRequestType? selectedType;

  const AccessRequestState({
    this.requests = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
    this.selectedStatus,
    this.selectedType,
  });

  AccessRequestState copyWith({
    List<AccessRequest>? requests,
    bool? isLoading,
    String? error,
    int? currentPage,
    bool? hasMore,
    AccessRequestStatus? selectedStatus,
    AccessRequestType? selectedType,
  }) {
    return AccessRequestState(
      requests: requests ?? this.requests,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedType: selectedType ?? this.selectedType,
    );
  }
}

class AuditLogState {
  final List<AccessAuditLog> logs;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final bool hasMore;
  final String? selectedUserId;
  final String? selectedAction;
  final AppPlatform? selectedPlatform;
  final DateTime? startDate;
  final DateTime? endDate;

  const AuditLogState({
    this.logs = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
    this.selectedUserId,
    this.selectedAction,
    this.selectedPlatform,
    this.startDate,
    this.endDate,
  });

  AuditLogState copyWith({
    List<AccessAuditLog>? logs,
    bool? isLoading,
    String? error,
    int? currentPage,
    bool? hasMore,
    String? selectedUserId,
    String? selectedAction,
    AppPlatform? selectedPlatform,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return AuditLogState(
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      selectedUserId: selectedUserId ?? this.selectedUserId,
      selectedAction: selectedAction ?? this.selectedAction,
      selectedPlatform: selectedPlatform ?? this.selectedPlatform,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

// Notifier classes
class UserAccessNotifier extends StateNotifier<UserAccessState> {
  final AccessControlService _service;

  UserAccessNotifier(this._service) : super(const UserAccessState());

  Future<void> loadUsers({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(currentPage: 1, hasMore: true);
    }

    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final users = await _service.getAllUserAccess(
        page: state.currentPage,
        search: state.searchQuery,
        role: state.selectedRole,
        platform: state.selectedPlatform,
      );

      final updatedUsers = refresh ? users : [...state.users, ...users];
      
      state = state.copyWith(
        users: updatedUsers,
        isLoading: false,
        currentPage: state.currentPage + 1,
        hasMore: users.length >= 50, // Assuming 50 is the page size
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void setSearchQuery(String? query) {
    state = state.copyWith(searchQuery: query);
    loadUsers(refresh: true);
  }

  void setRoleFilter(UserRole? role) {
    state = state.copyWith(selectedRole: role);
    loadUsers(refresh: true);
  }

  void setPlatformFilter(AppPlatform? platform) {
    state = state.copyWith(selectedPlatform: platform);
    loadUsers(refresh: true);
  }

  Future<void> toggleUserLock(String userId, bool isLocked, String? reason) async {
    try {
      await _service.toggleUserLock(userId, isLocked, reason);
      
      // Update local state
      final updatedUsers = state.users.map((user) {
        if (user.userId == userId) {
          return user.copyWith(
            isLocked: isLocked,
            lockedAt: isLocked ? DateTime.now() : null,
            lockedReason: reason,
          );
        }
        return user;
      }).toList();

      state = state.copyWith(users: updatedUsers);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> resetUserPassword(String userId) async {
    try {
      await _service.resetUserPassword(userId, true);
      
      // Update local state
      final updatedUsers = state.users.map((user) {
        if (user.userId == userId) {
          return user.copyWith(requiresPasswordReset: true);
        }
        return user;
      }).toList();

      state = state.copyWith(users: updatedUsers);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateUserAccess(String userId, UserAccess updatedAccess) async {
    try {
      final updated = await _service.updateUserAccess(userId, updatedAccess);
      
      // Update local state
      final updatedUsers = state.users.map((user) {
        if (user.userId == userId) {
          return updated;
        }
        return user;
      }).toList();

      state = state.copyWith(users: updatedUsers);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

class AccessRequestNotifier extends StateNotifier<AccessRequestState> {
  final AccessControlService _service;

  AccessRequestNotifier(this._service) : super(const AccessRequestState());

  Future<void> loadRequests({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(currentPage: 1, hasMore: true);
    }

    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final requests = await _service.getAccessRequests(
        page: state.currentPage,
        status: state.selectedStatus,
        type: state.selectedType,
      );

      final updatedRequests = refresh ? requests : [...state.requests, ...requests];
      
      state = state.copyWith(
        requests: updatedRequests,
        isLoading: false,
        currentPage: state.currentPage + 1,
        hasMore: requests.length >= 50,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void setStatusFilter(AccessRequestStatus? status) {
    state = state.copyWith(selectedStatus: status);
    loadRequests(refresh: true);
  }

  void setTypeFilter(AccessRequestType? type) {
    state = state.copyWith(selectedType: type);
    loadRequests(refresh: true);
  }

  Future<void> approveRequest(String requestId, String comments) async {
    try {
      final updated = await _service.approveAccessRequest(requestId, comments);
      
      // Update local state
      final updatedRequests = state.requests.map((request) {
        if (request.id == requestId) {
          return updated;
        }
        return request;
      }).toList();

      state = state.copyWith(requests: updatedRequests);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> rejectRequest(String requestId, String reason) async {
    try {
      final updated = await _service.rejectAccessRequest(requestId, reason);
      
      // Update local state
      final updatedRequests = state.requests.map((request) {
        if (request.id == requestId) {
          return updated;
        }
        return request;
      }).toList();

      state = state.copyWith(requests: updatedRequests);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

class AuditLogNotifier extends StateNotifier<AuditLogState> {
  final AccessControlService _service;

  AuditLogNotifier(this._service) : super(const AuditLogState());

  Future<void> loadLogs({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(currentPage: 1, hasMore: true);
    }

    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final logs = await _service.getAuditLogs(
        page: state.currentPage,
        userId: state.selectedUserId,
        action: state.selectedAction,
        platform: state.selectedPlatform,
        startDate: state.startDate,
        endDate: state.endDate,
      );

      final updatedLogs = refresh ? logs : [...state.logs, ...logs];
      
      state = state.copyWith(
        logs: updatedLogs,
        isLoading: false,
        currentPage: state.currentPage + 1,
        hasMore: logs.length >= 50,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void setFilters({
    String? userId,
    String? action,
    AppPlatform? platform,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    state = state.copyWith(
      selectedUserId: userId,
      selectedAction: action,
      selectedPlatform: platform,
      startDate: startDate,
      endDate: endDate,
    );
    loadLogs(refresh: true);
  }
}

// Providers
final userAccessProvider = StateNotifierProvider<UserAccessNotifier, UserAccessState>((ref) {
  final service = ref.watch(accessControlServiceProvider);
  return UserAccessNotifier(service);
});

final accessRequestProvider = StateNotifierProvider<AccessRequestNotifier, AccessRequestState>((ref) {
  final service = ref.watch(accessControlServiceProvider);
  return AccessRequestNotifier(service);
});

final auditLogProvider = StateNotifierProvider<AuditLogNotifier, AuditLogState>((ref) {
  final service = ref.watch(accessControlServiceProvider);
  return AuditLogNotifier(service);
});

// Additional providers for configuration and permissions
final accessControlConfigProvider = FutureProvider<AccessControlConfig>((ref) {
  final service = ref.watch(accessControlServiceProvider);
  return service.getAccessControlConfig();
});

final rolePermissionsProvider = FutureProvider<List<RolePermission>>((ref) {
  final service = ref.watch(accessControlServiceProvider);
  return service.getRolePermissions();
});

final availablePermissionsProvider = FutureProvider<List<Permission>>((ref) {
  final service = ref.watch(accessControlServiceProvider);
  return service.getAvailablePermissions();
});
