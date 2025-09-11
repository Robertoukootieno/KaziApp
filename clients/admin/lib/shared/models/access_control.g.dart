// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_control.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PermissionImpl _$$PermissionImplFromJson(Map<String, dynamic> json) =>
    _$PermissionImpl(
      id: json['id'] as String,
      resource: $enumDecode(_$ResourceTypeEnumMap, json['resource']),
      type: $enumDecode(_$PermissionTypeEnumMap, json['type']),
      platform: $enumDecode(_$AppPlatformEnumMap, json['platform']),
      description: json['description'] as String?,
      constraints: json['constraints'] as Map<String, dynamic>?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$PermissionImplToJson(_$PermissionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'resource': _$ResourceTypeEnumMap[instance.resource]!,
      'type': _$PermissionTypeEnumMap[instance.type]!,
      'platform': _$AppPlatformEnumMap[instance.platform]!,
      'description': instance.description,
      'constraints': instance.constraints,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$ResourceTypeEnumMap = {
  ResourceType.users: 'users',
  ResourceType.farmers: 'farmers',
  ResourceType.serviceProviders: 'service_providers',
  ResourceType.bookings: 'bookings',
  ResourceType.payments: 'payments',
  ResourceType.analytics: 'analytics',
  ResourceType.systemSettings: 'system_settings',
  ResourceType.auditLogs: 'audit_logs',
  ResourceType.notifications: 'notifications',
  ResourceType.reports: 'reports',
};

const _$PermissionTypeEnumMap = {
  PermissionType.read: 'read',
  PermissionType.write: 'write',
  PermissionType.delete: 'delete',
  PermissionType.admin: 'admin',
  PermissionType.moderate: 'moderate',
  PermissionType.approve: 'approve',
  PermissionType.suspend: 'suspend',
  PermissionType.export: 'export',
};

const _$AppPlatformEnumMap = {
  AppPlatform.mkulima: 'mkulima',
  AppPlatform.serviceProvider: 'service_provider',
  AppPlatform.admin: 'admin',
  AppPlatform.web: 'web',
  AppPlatform.ussd: 'ussd',
};

_$RolePermissionImpl _$$RolePermissionImplFromJson(Map<String, dynamic> json) =>
    _$RolePermissionImpl(
      id: json['id'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => Permission.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$RolePermissionImplToJson(
        _$RolePermissionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': _$UserRoleEnumMap[instance.role]!,
      'permissions': instance.permissions,
      'description': instance.description,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.superAdmin: 'super_admin',
  UserRole.admin: 'admin',
  UserRole.moderator: 'moderator',
  UserRole.farmer: 'farmer',
  UserRole.serviceProvider: 'service_provider',
  UserRole.veterinarian: 'veterinarian',
  UserRole.buyer: 'buyer',
  UserRole.vendor: 'vendor',
  UserRole.guest: 'guest',
};

_$UserAccessImpl _$$UserAccessImplFromJson(Map<String, dynamic> json) =>
    _$UserAccessImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      roles: (json['roles'] as List<dynamic>)
          .map((e) => $enumDecode(_$UserRoleEnumMap, e))
          .toList(),
      allowedPlatforms: (json['allowedPlatforms'] as List<dynamic>)
          .map((e) => $enumDecode(_$AppPlatformEnumMap, e))
          .toList(),
      customPermissions: (json['customPermissions'] as List<dynamic>)
          .map((e) => Permission.fromJson(e as Map<String, dynamic>))
          .toList(),
      isActive: json['isActive'] as bool? ?? true,
      isLocked: json['isLocked'] as bool? ?? false,
      requiresPasswordReset: json['requiresPasswordReset'] as bool? ?? false,
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
      lockedAt: json['lockedAt'] == null
          ? null
          : DateTime.parse(json['lockedAt'] as String),
      lockedReason: json['lockedReason'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
    );

Map<String, dynamic> _$$UserAccessImplToJson(_$UserAccessImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'email': instance.email,
      'fullName': instance.fullName,
      'roles': instance.roles.map((e) => _$UserRoleEnumMap[e]!).toList(),
      'allowedPlatforms': instance.allowedPlatforms
          .map((e) => _$AppPlatformEnumMap[e]!)
          .toList(),
      'customPermissions': instance.customPermissions,
      'isActive': instance.isActive,
      'isLocked': instance.isLocked,
      'requiresPasswordReset': instance.requiresPasswordReset,
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
      'lockedAt': instance.lockedAt?.toIso8601String(),
      'lockedReason': instance.lockedReason,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
    };

_$AccessRequestImpl _$$AccessRequestImplFromJson(Map<String, dynamic> json) =>
    _$AccessRequestImpl(
      id: json['id'] as String,
      requesterId: json['requesterId'] as String,
      requesterName: json['requesterName'] as String,
      requesterEmail: json['requesterEmail'] as String,
      targetUserId: json['targetUserId'] as String,
      targetUserName: json['targetUserName'] as String,
      targetUserEmail: json['targetUserEmail'] as String,
      type: $enumDecode(_$AccessRequestTypeEnumMap, json['type']),
      status: $enumDecode(_$AccessRequestStatusEnumMap, json['status']),
      requestedRoles: (json['requestedRoles'] as List<dynamic>)
          .map((e) => $enumDecode(_$UserRoleEnumMap, e))
          .toList(),
      requestedPlatforms: (json['requestedPlatforms'] as List<dynamic>)
          .map((e) => $enumDecode(_$AppPlatformEnumMap, e))
          .toList(),
      requestedPermissions: (json['requestedPermissions'] as List<dynamic>)
          .map((e) => Permission.fromJson(e as Map<String, dynamic>))
          .toList(),
      justification: json['justification'] as String,
      approverComments: json['approverComments'] as String?,
      approvedBy: json['approvedBy'] as String?,
      approvedAt: json['approvedAt'] == null
          ? null
          : DateTime.parse(json['approvedAt'] as String),
      rejectedBy: json['rejectedBy'] as String?,
      rejectedAt: json['rejectedAt'] == null
          ? null
          : DateTime.parse(json['rejectedAt'] as String),
      rejectionReason: json['rejectionReason'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$AccessRequestImplToJson(_$AccessRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requesterId': instance.requesterId,
      'requesterName': instance.requesterName,
      'requesterEmail': instance.requesterEmail,
      'targetUserId': instance.targetUserId,
      'targetUserName': instance.targetUserName,
      'targetUserEmail': instance.targetUserEmail,
      'type': _$AccessRequestTypeEnumMap[instance.type]!,
      'status': _$AccessRequestStatusEnumMap[instance.status]!,
      'requestedRoles':
          instance.requestedRoles.map((e) => _$UserRoleEnumMap[e]!).toList(),
      'requestedPlatforms': instance.requestedPlatforms
          .map((e) => _$AppPlatformEnumMap[e]!)
          .toList(),
      'requestedPermissions': instance.requestedPermissions,
      'justification': instance.justification,
      'approverComments': instance.approverComments,
      'approvedBy': instance.approvedBy,
      'approvedAt': instance.approvedAt?.toIso8601String(),
      'rejectedBy': instance.rejectedBy,
      'rejectedAt': instance.rejectedAt?.toIso8601String(),
      'rejectionReason': instance.rejectionReason,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$AccessRequestTypeEnumMap = {
  AccessRequestType.grantAccess: 'grant_access',
  AccessRequestType.modifyAccess: 'modify_access',
  AccessRequestType.revokeAccess: 'revoke_access',
  AccessRequestType.unlockUser: 'unlock_user',
  AccessRequestType.resetPassword: 'reset_password',
};

const _$AccessRequestStatusEnumMap = {
  AccessRequestStatus.pending: 'pending',
  AccessRequestStatus.approved: 'approved',
  AccessRequestStatus.rejected: 'rejected',
  AccessRequestStatus.cancelled: 'cancelled',
};

_$AccessAuditLogImpl _$$AccessAuditLogImplFromJson(Map<String, dynamic> json) =>
    _$AccessAuditLogImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      action: json['action'] as String,
      resource: json['resource'] as String,
      platform: $enumDecode(_$AppPlatformEnumMap, json['platform']),
      details: json['details'] as Map<String, dynamic>,
      ipAddress: json['ipAddress'] as String,
      userAgent: json['userAgent'] as String,
      success: json['success'] as bool? ?? true,
      errorMessage: json['errorMessage'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$AccessAuditLogImplToJson(
        _$AccessAuditLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'action': instance.action,
      'resource': instance.resource,
      'platform': _$AppPlatformEnumMap[instance.platform]!,
      'details': instance.details,
      'ipAddress': instance.ipAddress,
      'userAgent': instance.userAgent,
      'success': instance.success,
      'errorMessage': instance.errorMessage,
      'timestamp': instance.timestamp.toIso8601String(),
    };

_$AccessControlConfigImpl _$$AccessControlConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$AccessControlConfigImpl(
      maxFailedLoginAttempts:
          (json['maxFailedLoginAttempts'] as num?)?.toInt() ?? 3,
      lockoutDurationMinutes:
          (json['lockoutDurationMinutes'] as num?)?.toInt() ?? 30,
      passwordExpiryDays: (json['passwordExpiryDays'] as num?)?.toInt() ?? 90,
      requireMfaForAdmins: json['requireMfaForAdmins'] as bool? ?? true,
      requireApprovalForRoleChanges:
          json['requireApprovalForRoleChanges'] as bool? ?? true,
      allowSelfServicePasswordReset:
          json['allowSelfServicePasswordReset'] as bool? ?? false,
      sessionTimeoutHours: (json['sessionTimeoutHours'] as num?)?.toInt() ?? 24,
      logAllAccessAttempts: json['logAllAccessAttempts'] as bool? ?? true,
      notifyOnSuspiciousActivity:
          json['notifyOnSuspiciousActivity'] as bool? ?? true,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      updatedBy: json['updatedBy'] as String,
    );

Map<String, dynamic> _$$AccessControlConfigImplToJson(
        _$AccessControlConfigImpl instance) =>
    <String, dynamic>{
      'maxFailedLoginAttempts': instance.maxFailedLoginAttempts,
      'lockoutDurationMinutes': instance.lockoutDurationMinutes,
      'passwordExpiryDays': instance.passwordExpiryDays,
      'requireMfaForAdmins': instance.requireMfaForAdmins,
      'requireApprovalForRoleChanges': instance.requireApprovalForRoleChanges,
      'allowSelfServicePasswordReset': instance.allowSelfServicePasswordReset,
      'sessionTimeoutHours': instance.sessionTimeoutHours,
      'logAllAccessAttempts': instance.logAllAccessAttempts,
      'notifyOnSuspiciousActivity': instance.notifyOnSuspiciousActivity,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'updatedBy': instance.updatedBy,
    };
