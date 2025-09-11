import 'package:freezed_annotation/freezed_annotation.dart';

part 'access_control.freezed.dart';
part 'access_control.g.dart';

/// User roles across the KaziApp ecosystem
enum UserRole {
  @JsonValue('super_admin')
  superAdmin,
  @JsonValue('admin')
  admin,
  @JsonValue('moderator')
  moderator,
  @JsonValue('farmer')
  farmer,
  @JsonValue('service_provider')
  serviceProvider,
  @JsonValue('veterinarian')
  veterinarian,
  @JsonValue('buyer')
  buyer,
  @JsonValue('vendor')
  vendor,
  @JsonValue('guest')
  guest,
}

/// Application platforms
enum AppPlatform {
  @JsonValue('mkulima')
  mkulima,
  @JsonValue('service_provider')
  serviceProvider,
  @JsonValue('admin')
  admin,
  @JsonValue('web')
  web,
  @JsonValue('ussd')
  ussd,
}

/// Permission types
enum PermissionType {
  @JsonValue('read')
  read,
  @JsonValue('write')
  write,
  @JsonValue('delete')
  delete,
  @JsonValue('admin')
  admin,
  @JsonValue('moderate')
  moderate,
  @JsonValue('approve')
  approve,
  @JsonValue('suspend')
  suspend,
  @JsonValue('export')
  export,
}

/// Resource types that can be controlled
enum ResourceType {
  @JsonValue('users')
  users,
  @JsonValue('farmers')
  farmers,
  @JsonValue('service_providers')
  serviceProviders,
  @JsonValue('bookings')
  bookings,
  @JsonValue('payments')
  payments,
  @JsonValue('analytics')
  analytics,
  @JsonValue('system_settings')
  systemSettings,
  @JsonValue('audit_logs')
  auditLogs,
  @JsonValue('notifications')
  notifications,
  @JsonValue('reports')
  reports,
}

@freezed
class Permission with _$Permission {
  const factory Permission({
    required String id,
    required ResourceType resource,
    required PermissionType type,
    required AppPlatform platform,
    String? description,
    Map<String, dynamic>? constraints,
    @Default(true) bool isActive,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Permission;

  factory Permission.fromJson(Map<String, dynamic> json) =>
      _$PermissionFromJson(json);
}

@freezed
class RolePermission with _$RolePermission {
  const factory RolePermission({
    required String id,
    required UserRole role,
    required List<Permission> permissions,
    String? description,
    @Default(true) bool isActive,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _RolePermission;

  factory RolePermission.fromJson(Map<String, dynamic> json) =>
      _$RolePermissionFromJson(json);
}

@freezed
class UserAccess with _$UserAccess {
  const factory UserAccess({
    required String id,
    required String userId,
    required String email,
    required String fullName,
    required List<UserRole> roles,
    required List<AppPlatform> allowedPlatforms,
    required List<Permission> customPermissions,
    @Default(true) bool isActive,
    @Default(false) bool isLocked,
    @Default(false) bool requiresPasswordReset,
    DateTime? lastLoginAt,
    DateTime? lockedAt,
    String? lockedReason,
    required DateTime createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) = _UserAccess;

  factory UserAccess.fromJson(Map<String, dynamic> json) =>
      _$UserAccessFromJson(json);
}

@freezed
class AccessRequest with _$AccessRequest {
  const factory AccessRequest({
    required String id,
    required String requesterId,
    required String requesterName,
    required String requesterEmail,
    required String targetUserId,
    required String targetUserName,
    required String targetUserEmail,
    required AccessRequestType type,
    required AccessRequestStatus status,
    required List<UserRole> requestedRoles,
    required List<AppPlatform> requestedPlatforms,
    required List<Permission> requestedPermissions,
    required String justification,
    String? approverComments,
    String? approvedBy,
    DateTime? approvedAt,
    String? rejectedBy,
    DateTime? rejectedAt,
    String? rejectionReason,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _AccessRequest;

  factory AccessRequest.fromJson(Map<String, dynamic> json) =>
      _$AccessRequestFromJson(json);
}

enum AccessRequestType {
  @JsonValue('grant_access')
  grantAccess,
  @JsonValue('modify_access')
  modifyAccess,
  @JsonValue('revoke_access')
  revokeAccess,
  @JsonValue('unlock_user')
  unlockUser,
  @JsonValue('reset_password')
  resetPassword,
}

enum AccessRequestStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('approved')
  approved,
  @JsonValue('rejected')
  rejected,
  @JsonValue('cancelled')
  cancelled,
}

@freezed
class AccessAuditLog with _$AccessAuditLog {
  const factory AccessAuditLog({
    required String id,
    required String userId,
    required String userName,
    required String action,
    required String resource,
    required AppPlatform platform,
    required Map<String, dynamic> details,
    required String ipAddress,
    required String userAgent,
    @Default(true) bool success,
    String? errorMessage,
    required DateTime timestamp,
  }) = _AccessAuditLog;

  factory AccessAuditLog.fromJson(Map<String, dynamic> json) =>
      _$AccessAuditLogFromJson(json);
}

/// Access control configuration
@freezed
class AccessControlConfig with _$AccessControlConfig {
  const factory AccessControlConfig({
    @Default(3) int maxFailedLoginAttempts,
    @Default(30) int lockoutDurationMinutes,
    @Default(90) int passwordExpiryDays,
    @Default(true) bool requireMfaForAdmins,
    @Default(true) bool requireApprovalForRoleChanges,
    @Default(false) bool allowSelfServicePasswordReset,
    @Default(24) int sessionTimeoutHours,
    @Default(true) bool logAllAccessAttempts,
    @Default(true) bool notifyOnSuspiciousActivity,
    required DateTime updatedAt,
    required String updatedBy,
  }) = _AccessControlConfig;

  factory AccessControlConfig.fromJson(Map<String, dynamic> json) =>
      _$AccessControlConfigFromJson(json);
}

/// Helper class for role-based access control
class AccessControlHelper {
  static const Map<UserRole, List<Permission>> defaultRolePermissions = {
    // Define default permissions for each role
  };

  static bool hasPermission(
    UserAccess userAccess,
    ResourceType resource,
    PermissionType permissionType,
    AppPlatform platform,
  ) {
    // Check custom permissions first
    for (final permission in userAccess.customPermissions) {
      if (permission.resource == resource &&
          permission.type == permissionType &&
          permission.platform == platform &&
          permission.isActive) {
        return true;
      }
    }

    // Check role-based permissions
    for (final role in userAccess.roles) {
      final rolePermissions = defaultRolePermissions[role] ?? [];
      for (final permission in rolePermissions) {
        if (permission.resource == resource &&
            permission.type == permissionType &&
            permission.platform == platform &&
            permission.isActive) {
          return true;
        }
      }
    }

    return false;
  }

  static bool canAccessPlatform(UserAccess userAccess, AppPlatform platform) {
    return userAccess.isActive &&
        !userAccess.isLocked &&
        userAccess.allowedPlatforms.contains(platform);
  }

  static List<Permission> getAllPermissions(UserAccess userAccess) {
    final allPermissions = <Permission>[];
    
    // Add custom permissions
    allPermissions.addAll(userAccess.customPermissions);
    
    // Add role-based permissions
    for (final role in userAccess.roles) {
      final rolePermissions = defaultRolePermissions[role] ?? [];
      allPermissions.addAll(rolePermissions);
    }
    
    return allPermissions.where((p) => p.isActive).toList();
  }
}
