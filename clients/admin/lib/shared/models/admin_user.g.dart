// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdminUserImpl _$$AdminUserImplFromJson(Map<String, dynamic> json) =>
    _$AdminUserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      middleName: json['middleName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      profilePicture: json['profilePicture'] as String?,
      role: $enumDecode(_$AdminRoleEnumMap, json['role']),
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => $enumDecode(_$PermissionEnumMap, e))
          .toList(),
      status: $enumDecode(_$UserStatusEnumMap, json['status']),
      isEmailVerified: json['isEmailVerified'] as bool,
      isMfaEnabled: json['isMfaEnabled'] as bool,
      mfaMethods: (json['mfaMethods'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$MfaMethodEnumMap, e))
          .toList(),
      department: json['department'] as String?,
      jobTitle: json['jobTitle'] as String?,
      employeeId: json['employeeId'] as String?,
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
      lastLoginIp: json['lastLoginIp'] as String?,
      loginCount: (json['loginCount'] as num?)?.toInt(),
      passwordChangedAt: json['passwordChangedAt'] == null
          ? null
          : DateTime.parse(json['passwordChangedAt'] as String),
      mustChangePassword: json['mustChangePassword'] as bool?,
      allowedIpRanges: (json['allowedIpRanges'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      preferences: json['preferences'] as Map<String, dynamic>?,
      settings: json['settings'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
      suspendedAt: json['suspendedAt'] == null
          ? null
          : DateTime.parse(json['suspendedAt'] as String),
      suspendedBy: json['suspendedBy'] as String?,
      suspensionReason: json['suspensionReason'] as String?,
    );

Map<String, dynamic> _$$AdminUserImplToJson(_$AdminUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'middleName': instance.middleName,
      'phoneNumber': instance.phoneNumber,
      'profilePicture': instance.profilePicture,
      'role': _$AdminRoleEnumMap[instance.role]!,
      'permissions':
          instance.permissions.map((e) => _$PermissionEnumMap[e]!).toList(),
      'status': _$UserStatusEnumMap[instance.status]!,
      'isEmailVerified': instance.isEmailVerified,
      'isMfaEnabled': instance.isMfaEnabled,
      'mfaMethods':
          instance.mfaMethods?.map((e) => _$MfaMethodEnumMap[e]!).toList(),
      'department': instance.department,
      'jobTitle': instance.jobTitle,
      'employeeId': instance.employeeId,
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
      'lastLoginIp': instance.lastLoginIp,
      'loginCount': instance.loginCount,
      'passwordChangedAt': instance.passwordChangedAt?.toIso8601String(),
      'mustChangePassword': instance.mustChangePassword,
      'allowedIpRanges': instance.allowedIpRanges,
      'preferences': instance.preferences,
      'settings': instance.settings,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'suspendedAt': instance.suspendedAt?.toIso8601String(),
      'suspendedBy': instance.suspendedBy,
      'suspensionReason': instance.suspensionReason,
    };

const _$AdminRoleEnumMap = {
  AdminRole.superAdmin: 'super_admin',
  AdminRole.admin: 'admin',
  AdminRole.moderator: 'moderator',
  AdminRole.analyst: 'analyst',
  AdminRole.support: 'support',
  AdminRole.viewer: 'viewer',
};

const _$PermissionEnumMap = {
  Permission.usersView: 'users.view',
  Permission.usersCreate: 'users.create',
  Permission.usersEdit: 'users.edit',
  Permission.usersDelete: 'users.delete',
  Permission.usersSuspend: 'users.suspend',
  Permission.usersExport: 'users.export',
  Permission.farmersView: 'farmers.view',
  Permission.farmersVerify: 'farmers.verify',
  Permission.farmersEdit: 'farmers.edit',
  Permission.farmersSuspend: 'farmers.suspend',
  Permission.farmersAnalytics: 'farmers.analytics',
  Permission.providersView: 'providers.view',
  Permission.providersVerify: 'providers.verify',
  Permission.providersApprove: 'providers.approve',
  Permission.providersSuspend: 'providers.suspend',
  Permission.providersAnalytics: 'providers.analytics',
  Permission.financeView: 'finance.view',
  Permission.financeTransactions: 'finance.transactions',
  Permission.financeReports: 'finance.reports',
  Permission.financeRefunds: 'finance.refunds',
  Permission.contentView: 'content.view',
  Permission.contentCreate: 'content.create',
  Permission.contentEdit: 'content.edit',
  Permission.contentPublish: 'content.publish',
  Permission.contentDelete: 'content.delete',
  Permission.systemView: 'system.view',
  Permission.systemConfigure: 'system.configure',
  Permission.systemMaintenance: 'system.maintenance',
  Permission.systemBackup: 'system.backup',
  Permission.analyticsView: 'analytics.view',
  Permission.analyticsExport: 'analytics.export',
  Permission.analyticsAdvanced: 'analytics.advanced',
  Permission.auditView: 'audit.view',
  Permission.auditExport: 'audit.export',
  Permission.notificationsView: 'notifications.view',
  Permission.notificationsSend: 'notifications.send',
  Permission.notificationsBroadcast: 'notifications.broadcast',
  Permission.reportsView: 'reports.view',
  Permission.reportsGenerate: 'reports.generate',
  Permission.reportsSchedule: 'reports.schedule',
};

const _$UserStatusEnumMap = {
  UserStatus.active: 'active',
  UserStatus.inactive: 'inactive',
  UserStatus.suspended: 'suspended',
  UserStatus.pendingVerification: 'pending_verification',
  UserStatus.locked: 'locked',
};

const _$MfaMethodEnumMap = {
  MfaMethod.totp: 'totp',
  MfaMethod.sms: 'sms',
  MfaMethod.email: 'email',
  MfaMethod.backupCodes: 'backup_codes',
};
