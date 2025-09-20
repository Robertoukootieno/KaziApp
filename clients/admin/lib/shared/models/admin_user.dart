import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_user.freezed.dart';
part 'admin_user.g.dart';

/// Admin user roles with hierarchical permissions
enum AdminRole {
  @JsonValue('super_admin')
  superAdmin,
  @JsonValue('admin')
  admin,
  @JsonValue('moderator')
  moderator,
  @JsonValue('analyst')
  analyst,
  @JsonValue('support')
  support,
  @JsonValue('viewer')
  viewer,
}

/// Permission categories
enum PermissionCategory {
  @JsonValue('user_management')
  userManagement,
  @JsonValue('farmer_management')
  farmerManagement,
  @JsonValue('service_provider_management')
  serviceProviderManagement,
  @JsonValue('financial_management')
  financialManagement,
  @JsonValue('content_management')
  contentManagement,
  @JsonValue('system_configuration')
  systemConfiguration,
  @JsonValue('analytics')
  analytics,
  @JsonValue('audit_logs')
  auditLogs,
  @JsonValue('notifications')
  notifications,
  @JsonValue('reports')
  reports,
}

/// Specific permissions
enum Permission {
  // User Management
  @JsonValue('users.view')
  usersView,
  @JsonValue('users.create')
  usersCreate,
  @JsonValue('users.edit')
  usersEdit,
  @JsonValue('users.delete')
  usersDelete,
  @JsonValue('users.suspend')
  usersSuspend,
  @JsonValue('users.export')
  usersExport,

  // Farmer Management
  @JsonValue('farmers.view')
  farmersView,
  @JsonValue('farmers.verify')
  farmersVerify,
  @JsonValue('farmers.edit')
  farmersEdit,
  @JsonValue('farmers.suspend')
  farmersSuspend,
  @JsonValue('farmers.analytics')
  farmersAnalytics,

  // Service Provider Management
  @JsonValue('providers.view')
  providersView,
  @JsonValue('providers.verify')
  providersVerify,
  @JsonValue('providers.approve')
  providersApprove,
  @JsonValue('providers.suspend')
  providersSuspend,
  @JsonValue('providers.analytics')
  providersAnalytics,

  // Financial Management
  @JsonValue('finance.view')
  financeView,
  @JsonValue('finance.transactions')
  financeTransactions,
  @JsonValue('finance.reports')
  financeReports,
  @JsonValue('finance.refunds')
  financeRefunds,

  // Content Management
  @JsonValue('content.view')
  contentView,
  @JsonValue('content.create')
  contentCreate,
  @JsonValue('content.edit')
  contentEdit,
  @JsonValue('content.publish')
  contentPublish,
  @JsonValue('content.delete')
  contentDelete,

  // System Configuration
  @JsonValue('system.view')
  systemView,
  @JsonValue('system.configure')
  systemConfigure,
  @JsonValue('system.maintenance')
  systemMaintenance,
  @JsonValue('system.backup')
  systemBackup,

  // Analytics
  @JsonValue('analytics.view')
  analyticsView,
  @JsonValue('analytics.export')
  analyticsExport,
  @JsonValue('analytics.advanced')
  analyticsAdvanced,

  // Audit Logs
  @JsonValue('audit.view')
  auditView,
  @JsonValue('audit.export')
  auditExport,

  // Notifications
  @JsonValue('notifications.view')
  notificationsView,
  @JsonValue('notifications.send')
  notificationsSend,
  @JsonValue('notifications.broadcast')
  notificationsBroadcast,

  // Reports
  @JsonValue('reports.view')
  reportsView,
  @JsonValue('reports.generate')
  reportsGenerate,
  @JsonValue('reports.schedule')
  reportsSchedule,
}

/// User status
enum UserStatus {
  @JsonValue('active')
  active,
  @JsonValue('inactive')
  inactive,
  @JsonValue('suspended')
  suspended,
  @JsonValue('pending_verification')
  pendingVerification,
  @JsonValue('locked')
  locked,
}

/// MFA method
enum MfaMethod {
  @JsonValue('totp')
  totp,
  @JsonValue('sms')
  sms,
  @JsonValue('email')
  email,
  @JsonValue('backup_codes')
  backupCodes,
}

/// Admin user profile
@freezed
class AdminUser with _$AdminUser {
  const factory AdminUser({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    String? middleName,
    String? phoneNumber,
    String? profilePicture,
    required AdminRole role,
    required List<Permission> permissions,
    required UserStatus status,
    required bool isEmailVerified,
    required bool isMfaEnabled,
    List<MfaMethod>? mfaMethods,
    String? department,
    String? jobTitle,
    String? employeeId,
    DateTime? lastLoginAt,
    String? lastLoginIp,
    int? loginCount,
    DateTime? passwordChangedAt,
    bool? mustChangePassword,
    List<String>? allowedIpRanges,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? settings,
    required DateTime createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    DateTime? suspendedAt,
    String? suspendedBy,
    String? suspensionReason,
  }) = _AdminUser;

  factory AdminUser.fromJson(Map<String, dynamic> json) =>
      _$AdminUserFromJson(json);
}

/// Extension for permission checking
extension AdminUserPermissions on AdminUser {
  /// Check if user has a specific permission
  bool hasPermission(Permission permission) {
    return permissions.contains(permission);
  }

  /// Check if user has any of the specified permissions
  bool hasAnyPermission(List<Permission> permissionList) {
    return permissionList.any((permission) => permissions.contains(permission));
  }

  /// Check if user has all of the specified permissions
  bool hasAllPermissions(List<Permission> permissionList) {
    return permissionList.every((permission) => permissions.contains(permission));
  }

  /// Check if user can access a specific category
  bool canAccessCategory(PermissionCategory category) {
    switch (category) {
      case PermissionCategory.userManagement:
        return hasAnyPermission([
          Permission.usersView,
          Permission.usersCreate,
          Permission.usersEdit,
          Permission.usersDelete,
        ]);
      case PermissionCategory.farmerManagement:
        return hasAnyPermission([
          Permission.farmersView,
          Permission.farmersVerify,
          Permission.farmersEdit,
        ]);
      case PermissionCategory.serviceProviderManagement:
        return hasAnyPermission([
          Permission.providersView,
          Permission.providersVerify,
          Permission.providersApprove,
        ]);
      case PermissionCategory.financialManagement:
        return hasAnyPermission([
          Permission.financeView,
          Permission.financeTransactions,
          Permission.financeReports,
        ]);
      case PermissionCategory.contentManagement:
        return hasAnyPermission([
          Permission.contentView,
          Permission.contentCreate,
          Permission.contentEdit,
        ]);
      case PermissionCategory.systemConfiguration:
        return hasAnyPermission([
          Permission.systemView,
          Permission.systemConfigure,
          Permission.systemMaintenance,
        ]);
      case PermissionCategory.analytics:
        return hasAnyPermission([
          Permission.analyticsView,
          Permission.analyticsExport,
        ]);
      case PermissionCategory.auditLogs:
        return hasPermission(Permission.auditView);
      case PermissionCategory.notifications:
        return hasAnyPermission([
          Permission.notificationsView,
          Permission.notificationsSend,
        ]);
      case PermissionCategory.reports:
        return hasAnyPermission([
          Permission.reportsView,
          Permission.reportsGenerate,
        ]);
    }
  }

  /// Get user's full name
  String get fullName {
    final parts = [firstName, middleName, lastName]
        .where((part) => part != null && part.isNotEmpty)
        .toList();
    return parts.join(' ');
  }

  /// Get user's initials
  String get initials {
    final firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }

  /// Check if user is active
  bool get isActive => status == UserStatus.active;

  /// Check if user is suspended
  bool get isSuspended => status == UserStatus.suspended;

  /// Check if user is locked
  bool get isLocked => status == UserStatus.locked;

  /// Check if user needs to change password
  bool get needsPasswordChange => mustChangePassword ?? false;

  /// Get role display name
  String get roleDisplayName {
    switch (role) {
      case AdminRole.superAdmin:
        return 'Super Administrator';
      case AdminRole.admin:
        return 'Administrator';
      case AdminRole.moderator:
        return 'Moderator';
      case AdminRole.analyst:
        return 'Analyst';
      case AdminRole.support:
        return 'Support';
      case AdminRole.viewer:
        return 'Viewer';
    }
  }

  /// Get status display name
  String get statusDisplayName {
    switch (status) {
      case UserStatus.active:
        return 'Active';
      case UserStatus.inactive:
        return 'Inactive';
      case UserStatus.suspended:
        return 'Suspended';
      case UserStatus.pendingVerification:
        return 'Pending Verification';
      case UserStatus.locked:
        return 'Locked';
    }
  }
}
