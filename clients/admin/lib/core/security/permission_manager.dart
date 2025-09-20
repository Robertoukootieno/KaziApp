import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/admin_user.dart';
import 'auth_manager.dart';

/// Permission check result
class PermissionResult {
  final bool granted;
  final String? reason;
  final List<Permission>? requiredPermissions;

  const PermissionResult({
    required this.granted,
    this.reason,
    this.requiredPermissions,
  });

  factory PermissionResult.granted() {
    return const PermissionResult(granted: true);
  }

  factory PermissionResult.denied({
    String? reason,
    List<Permission>? requiredPermissions,
  }) {
    return PermissionResult(
      granted: false,
      reason: reason,
      requiredPermissions: requiredPermissions,
    );
  }
}

/// Permission manager for role-based access control
class PermissionManager {
  final AdminUser? _currentUser;

  PermissionManager(this._currentUser);

  /// Check if user has a specific permission
  PermissionResult checkPermission(Permission permission) {
    if (_currentUser == null) {
      return PermissionResult.denied(
        reason: 'User not authenticated',
        requiredPermissions: [permission],
      );
    }

    if (!_currentUser!.isActive) {
      return PermissionResult.denied(
        reason: 'User account is not active',
      );
    }

    if (_currentUser!.hasPermission(permission)) {
      return PermissionResult.granted();
    }

    return PermissionResult.denied(
      reason: 'Insufficient permissions',
      requiredPermissions: [permission],
    );
  }

  /// Check if user has any of the specified permissions
  PermissionResult checkAnyPermission(List<Permission> permissions) {
    if (_currentUser == null) {
      return PermissionResult.denied(
        reason: 'User not authenticated',
        requiredPermissions: permissions,
      );
    }

    if (!_currentUser!.isActive) {
      return PermissionResult.denied(
        reason: 'User account is not active',
      );
    }

    if (_currentUser!.hasAnyPermission(permissions)) {
      return PermissionResult.granted();
    }

    return PermissionResult.denied(
      reason: 'Insufficient permissions',
      requiredPermissions: permissions,
    );
  }

  /// Check if user has all of the specified permissions
  PermissionResult checkAllPermissions(List<Permission> permissions) {
    if (_currentUser == null) {
      return PermissionResult.denied(
        reason: 'User not authenticated',
        requiredPermissions: permissions,
      );
    }

    if (!_currentUser!.isActive) {
      return PermissionResult.denied(
        reason: 'User account is not active',
      );
    }

    if (_currentUser!.hasAllPermissions(permissions)) {
      return PermissionResult.granted();
    }

    final missingPermissions = permissions
        .where((permission) => !_currentUser!.hasPermission(permission))
        .toList();

    return PermissionResult.denied(
      reason: 'Missing required permissions',
      requiredPermissions: missingPermissions,
    );
  }

  /// Check if user can access a category
  PermissionResult checkCategoryAccess(PermissionCategory category) {
    if (_currentUser == null) {
      return PermissionResult.denied(
        reason: 'User not authenticated',
      );
    }

    if (!_currentUser!.isActive) {
      return PermissionResult.denied(
        reason: 'User account is not active',
      );
    }

    if (_currentUser!.canAccessCategory(category)) {
      return PermissionResult.granted();
    }

    return PermissionResult.denied(
      reason: 'No access to ${category.name} category',
    );
  }

  /// Check if user can perform CRUD operations
  PermissionResult checkCrudPermission(String resource, CrudOperation operation) {
    final permission = _getCrudPermission(resource, operation);
    if (permission == null) {
      return PermissionResult.denied(
        reason: 'Invalid resource or operation',
      );
    }

    return checkPermission(permission);
  }

  /// Get CRUD permission for resource and operation
  Permission? _getCrudPermission(String resource, CrudOperation operation) {
    switch (resource.toLowerCase()) {
      case 'users':
        switch (operation) {
          case CrudOperation.create:
            return Permission.usersCreate;
          case CrudOperation.read:
            return Permission.usersView;
          case CrudOperation.update:
            return Permission.usersEdit;
          case CrudOperation.delete:
            return Permission.usersDelete;
        }
      case 'farmers':
        switch (operation) {
          case CrudOperation.create:
            return Permission.farmersVerify;
          case CrudOperation.read:
            return Permission.farmersView;
          case CrudOperation.update:
            return Permission.farmersEdit;
          case CrudOperation.delete:
            return Permission.farmersSuspend;
        }
      case 'providers':
        switch (operation) {
          case CrudOperation.create:
            return Permission.providersApprove;
          case CrudOperation.read:
            return Permission.providersView;
          case CrudOperation.update:
            return Permission.providersVerify;
          case CrudOperation.delete:
            return Permission.providersSuspend;
        }
      case 'content':
        switch (operation) {
          case CrudOperation.create:
            return Permission.contentCreate;
          case CrudOperation.read:
            return Permission.contentView;
          case CrudOperation.update:
            return Permission.contentEdit;
          case CrudOperation.delete:
            return Permission.contentDelete;
        }
      default:
        return null;
    }
  }

  /// Check if user is super admin
  bool get isSuperAdmin => _currentUser?.role == AdminRole.superAdmin;

  /// Check if user is admin or higher
  bool get isAdmin => _currentUser?.role == AdminRole.admin || isSuperAdmin;

  /// Check if user is moderator or higher
  bool get isModerator => 
      _currentUser?.role == AdminRole.moderator || isAdmin;

  /// Get user's role level (higher number = more permissions)
  int get roleLevel {
    switch (_currentUser?.role) {
      case AdminRole.superAdmin:
        return 6;
      case AdminRole.admin:
        return 5;
      case AdminRole.moderator:
        return 4;
      case AdminRole.analyst:
        return 3;
      case AdminRole.support:
        return 2;
      case AdminRole.viewer:
        return 1;
      case null:
        return 0;
    }
  }

  /// Check if user can manage another user (based on role hierarchy)
  bool canManageUser(AdminUser targetUser) {
    if (_currentUser == null) return false;
    if (!_currentUser!.isActive) return false;
    if (_currentUser!.id == targetUser.id) return true; // Can manage self
    
    final currentLevel = roleLevel;
    final targetLevel = _getRoleLevel(targetUser.role);
    
    return currentLevel > targetLevel;
  }

  /// Get role level for a specific role
  int _getRoleLevel(AdminRole role) {
    switch (role) {
      case AdminRole.superAdmin:
        return 6;
      case AdminRole.admin:
        return 5;
      case AdminRole.moderator:
        return 4;
      case AdminRole.analyst:
        return 3;
      case AdminRole.support:
        return 2;
      case AdminRole.viewer:
        return 1;
    }
  }

  /// Get all permissions for current user
  List<Permission> get userPermissions => _currentUser?.permissions ?? [];

  /// Get accessible categories for current user
  List<PermissionCategory> get accessibleCategories {
    if (_currentUser == null) return [];
    
    return PermissionCategory.values
        .where((category) => _currentUser!.canAccessCategory(category))
        .toList();
  }
}

/// CRUD operations
enum CrudOperation {
  create,
  read,
  update,
  delete,
}

/// Permission manager provider
final permissionManagerProvider = Provider<PermissionManager>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  return PermissionManager(currentUser);
});

/// Permission check providers
final hasPermissionProvider = Provider.family<bool, Permission>((ref, permission) {
  final permissionManager = ref.watch(permissionManagerProvider);
  return permissionManager.checkPermission(permission).granted;
});

final hasAnyPermissionProvider = Provider.family<bool, List<Permission>>((ref, permissions) {
  final permissionManager = ref.watch(permissionManagerProvider);
  return permissionManager.checkAnyPermission(permissions).granted;
});

final hasAllPermissionsProvider = Provider.family<bool, List<Permission>>((ref, permissions) {
  final permissionManager = ref.watch(permissionManagerProvider);
  return permissionManager.checkAllPermissions(permissions).granted;
});

final canAccessCategoryProvider = Provider.family<bool, PermissionCategory>((ref, category) {
  final permissionManager = ref.watch(permissionManagerProvider);
  return permissionManager.checkCategoryAccess(category).granted;
});

final canPerformCrudProvider = Provider.family<bool, ({String resource, CrudOperation operation})>((ref, params) {
  final permissionManager = ref.watch(permissionManagerProvider);
  return permissionManager.checkCrudPermission(params.resource, params.operation).granted;
});
