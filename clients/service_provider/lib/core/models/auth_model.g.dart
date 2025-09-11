// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthStateImpl _$$AuthStateImplFromJson(Map<String, dynamic> json) =>
    _$AuthStateImpl(
      isAuthenticated: json['isAuthenticated'] as bool? ?? false,
      isLoading: json['isLoading'] as bool? ?? false,
      isBiometricEnabled: json['isBiometricEnabled'] as bool? ?? false,
      isBiometricAvailable: json['isBiometricAvailable'] as bool? ?? false,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String?,
      refreshToken: json['refreshToken'] as String?,
      error: json['error'] as String?,
      tokenExpiresAt: json['tokenExpiresAt'] == null
          ? null
          : DateTime.parse(json['tokenExpiresAt'] as String),
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
      loginAttempts: (json['loginAttempts'] as num?)?.toInt(),
      lockoutUntil: json['lockoutUntil'] == null
          ? null
          : DateTime.parse(json['lockoutUntil'] as String),
    );

Map<String, dynamic> _$$AuthStateImplToJson(_$AuthStateImpl instance) =>
    <String, dynamic>{
      'isAuthenticated': instance.isAuthenticated,
      'isLoading': instance.isLoading,
      'isBiometricEnabled': instance.isBiometricEnabled,
      'isBiometricAvailable': instance.isBiometricAvailable,
      'user': instance.user,
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'error': instance.error,
      'tokenExpiresAt': instance.tokenExpiresAt?.toIso8601String(),
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
      'loginAttempts': instance.loginAttempts,
      'lockoutUntil': instance.lockoutUntil?.toIso8601String(),
    };

_$LoginRequestImpl _$$LoginRequestImplFromJson(Map<String, dynamic> json) =>
    _$LoginRequestImpl(
      email: json['email'] as String,
      password: json['password'] as String,
      deviceId: json['deviceId'] as String?,
      deviceName: json['deviceName'] as String?,
      fcmToken: json['fcmToken'] as String?,
      rememberMe: json['rememberMe'] as bool?,
      biometricSignature: json['biometricSignature'] as String?,
    );

Map<String, dynamic> _$$LoginRequestImplToJson(_$LoginRequestImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'deviceId': instance.deviceId,
      'deviceName': instance.deviceName,
      'fcmToken': instance.fcmToken,
      'rememberMe': instance.rememberMe,
      'biometricSignature': instance.biometricSignature,
    };

_$LoginResponseImpl _$$LoginResponseImplFromJson(Map<String, dynamic> json) =>
    _$LoginResponseImpl(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      message: json['message'] as String?,
      requiresVerification: json['requiresVerification'] as bool?,
      requiresProfileSetup: json['requiresProfileSetup'] as bool?,
      requiresTwoFactor: json['requiresTwoFactor'] as bool?,
      twoFactorMethod: json['twoFactorMethod'] as String?,
    );

Map<String, dynamic> _$$LoginResponseImplToJson(_$LoginResponseImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'user': instance.user,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'message': instance.message,
      'requiresVerification': instance.requiresVerification,
      'requiresProfileSetup': instance.requiresProfileSetup,
      'requiresTwoFactor': instance.requiresTwoFactor,
      'twoFactorMethod': instance.twoFactorMethod,
    };

_$RegisterRequestImpl _$$RegisterRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$RegisterRequestImpl(
      email: json['email'] as String,
      password: json['password'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      providerType:
          $enumDecode(_$ServiceProviderTypeEnumMap, json['providerType']),
      registrationType: $enumDecodeNullable(
              _$RegistrationTypeEnumMap, json['registrationType']) ??
          RegistrationType.business,
      confirmPassword: json['confirmPassword'] as String?,
      county: json['county'] as String?,
      subCounty: json['subCounty'] as String?,
      ward: json['ward'] as String?,
      businessName: json['businessName'] as String?,
      businessRegistrationNumber: json['businessRegistrationNumber'] as String?,
      location: json['location'] as String?,
      bio: json['bio'] as String?,
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      referralCode: json['referralCode'] as String?,
      deviceId: json['deviceId'] as String?,
      deviceName: json['deviceName'] as String?,
      fcmToken: json['fcmToken'] as String?,
      agreeToTerms: json['agreeToTerms'] as bool?,
      agreeToPrivacyPolicy: json['agreeToPrivacyPolicy'] as bool?,
      subscribeToNewsletter: json['subscribeToNewsletter'] as bool?,
    );

Map<String, dynamic> _$$RegisterRequestImplToJson(
        _$RegisterRequestImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'providerType': _$ServiceProviderTypeEnumMap[instance.providerType]!,
      'registrationType': _$RegistrationTypeEnumMap[instance.registrationType]!,
      'confirmPassword': instance.confirmPassword,
      'county': instance.county,
      'subCounty': instance.subCounty,
      'ward': instance.ward,
      'businessName': instance.businessName,
      'businessRegistrationNumber': instance.businessRegistrationNumber,
      'location': instance.location,
      'bio': instance.bio,
      'services': instance.services,
      'referralCode': instance.referralCode,
      'deviceId': instance.deviceId,
      'deviceName': instance.deviceName,
      'fcmToken': instance.fcmToken,
      'agreeToTerms': instance.agreeToTerms,
      'agreeToPrivacyPolicy': instance.agreeToPrivacyPolicy,
      'subscribeToNewsletter': instance.subscribeToNewsletter,
    };

const _$ServiceProviderTypeEnumMap = {
  ServiceProviderType.veterinarian: 'veterinarian',
  ServiceProviderType.agrovet: 'agrovet',
  ServiceProviderType.feedSupplier: 'feed_supplier',
  ServiceProviderType.seedsSupplier: 'seeds_supplier',
  ServiceProviderType.fertiliserSupplier: 'fertiliser_supplier',
  ServiceProviderType.machineryProvider: 'machinery_provider',
  ServiceProviderType.agriculturalConsultant: 'agricultural_consultant',
  ServiceProviderType.generalRetailer: 'general_retailer',
  ServiceProviderType.logisticsTransportation: 'logistics_transportation',
  ServiceProviderType.insurance: 'insurance',
  ServiceProviderType.trainingProvider: 'training_provider',
  ServiceProviderType.financialServices: 'financial_services',
  ServiceProviderType.marketLinkage: 'market_linkage',
};

const _$RegistrationTypeEnumMap = {
  RegistrationType.business: 'business',
  RegistrationType.self: 'self',
};

_$RegisterResponseImpl _$$RegisterResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$RegisterResponseImpl(
      message: json['message'] as String,
      userId: json['userId'] as String,
      verificationToken: json['verificationToken'] as String?,
      requiresEmailVerification: json['requiresEmailVerification'] as bool?,
      requiresPhoneVerification: json['requiresPhoneVerification'] as bool?,
      nextStep: json['nextStep'] as String?,
    );

Map<String, dynamic> _$$RegisterResponseImplToJson(
        _$RegisterResponseImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'userId': instance.userId,
      'verificationToken': instance.verificationToken,
      'requiresEmailVerification': instance.requiresEmailVerification,
      'requiresPhoneVerification': instance.requiresPhoneVerification,
      'nextStep': instance.nextStep,
    };

_$ForgotPasswordRequestImpl _$$ForgotPasswordRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ForgotPasswordRequestImpl(
      email: json['email'] as String,
      resetMethod: json['resetMethod'] as String?,
    );

Map<String, dynamic> _$$ForgotPasswordRequestImplToJson(
        _$ForgotPasswordRequestImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'resetMethod': instance.resetMethod,
    };

_$ForgotPasswordResponseImpl _$$ForgotPasswordResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ForgotPasswordResponseImpl(
      message: json['message'] as String,
      resetToken: json['resetToken'] as String,
      resetMethod: json['resetMethod'] as String?,
      expiresInMinutes: (json['expiresInMinutes'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ForgotPasswordResponseImplToJson(
        _$ForgotPasswordResponseImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'resetToken': instance.resetToken,
      'resetMethod': instance.resetMethod,
      'expiresInMinutes': instance.expiresInMinutes,
    };

_$ResetPasswordRequestImpl _$$ResetPasswordRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ResetPasswordRequestImpl(
      resetToken: json['resetToken'] as String,
      newPassword: json['newPassword'] as String,
      confirmPassword: json['confirmPassword'] as String,
    );

Map<String, dynamic> _$$ResetPasswordRequestImplToJson(
        _$ResetPasswordRequestImpl instance) =>
    <String, dynamic>{
      'resetToken': instance.resetToken,
      'newPassword': instance.newPassword,
      'confirmPassword': instance.confirmPassword,
    };

_$VerifyOtpRequestImpl _$$VerifyOtpRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$VerifyOtpRequestImpl(
      token: json['token'] as String,
      otp: json['otp'] as String,
      type: $enumDecode(_$OtpTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$$VerifyOtpRequestImplToJson(
        _$VerifyOtpRequestImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'otp': instance.otp,
      'type': _$OtpTypeEnumMap[instance.type]!,
    };

const _$OtpTypeEnumMap = {
  OtpType.emailVerification: 'email_verification',
  OtpType.phoneVerification: 'phone_verification',
  OtpType.passwordReset: 'password_reset',
  OtpType.twoFactorAuth: 'two_factor_auth',
  OtpType.loginVerification: 'login_verification',
};

_$VerifyOtpResponseImpl _$$VerifyOtpResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$VerifyOtpResponseImpl(
      message: json['message'] as String,
      isVerified: json['isVerified'] as bool,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      nextStep: json['nextStep'] as String?,
    );

Map<String, dynamic> _$$VerifyOtpResponseImplToJson(
        _$VerifyOtpResponseImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'isVerified': instance.isVerified,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'user': instance.user,
      'nextStep': instance.nextStep,
    };

_$ResendOtpRequestImpl _$$ResendOtpRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ResendOtpRequestImpl(
      token: json['token'] as String,
      type: $enumDecode(_$OtpTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$$ResendOtpRequestImplToJson(
        _$ResendOtpRequestImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'type': _$OtpTypeEnumMap[instance.type]!,
    };

_$ChangePasswordRequestImpl _$$ChangePasswordRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ChangePasswordRequestImpl(
      currentPassword: json['currentPassword'] as String,
      newPassword: json['newPassword'] as String,
      confirmPassword: json['confirmPassword'] as String,
    );

Map<String, dynamic> _$$ChangePasswordRequestImplToJson(
        _$ChangePasswordRequestImpl instance) =>
    <String, dynamic>{
      'currentPassword': instance.currentPassword,
      'newPassword': instance.newPassword,
      'confirmPassword': instance.confirmPassword,
    };

_$BiometricAuthRequestImpl _$$BiometricAuthRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$BiometricAuthRequestImpl(
      userId: json['userId'] as String,
      biometricSignature: json['biometricSignature'] as String,
      deviceId: json['deviceId'] as String,
      biometricType: json['biometricType'] as String?,
    );

Map<String, dynamic> _$$BiometricAuthRequestImplToJson(
        _$BiometricAuthRequestImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'biometricSignature': instance.biometricSignature,
      'deviceId': instance.deviceId,
      'biometricType': instance.biometricType,
    };

_$TwoFactorAuthRequestImpl _$$TwoFactorAuthRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$TwoFactorAuthRequestImpl(
      token: json['token'] as String,
      code: json['code'] as String,
      method: $enumDecode(_$TwoFactorMethodEnumMap, json['method']),
    );

Map<String, dynamic> _$$TwoFactorAuthRequestImplToJson(
        _$TwoFactorAuthRequestImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'code': instance.code,
      'method': _$TwoFactorMethodEnumMap[instance.method]!,
    };

const _$TwoFactorMethodEnumMap = {
  TwoFactorMethod.sms: 'sms',
  TwoFactorMethod.email: 'email',
  TwoFactorMethod.authenticator: 'authenticator',
  TwoFactorMethod.backupCodes: 'backup_codes',
};

_$RefreshTokenRequestImpl _$$RefreshTokenRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$RefreshTokenRequestImpl(
      refreshToken: json['refreshToken'] as String,
      deviceId: json['deviceId'] as String?,
    );

Map<String, dynamic> _$$RefreshTokenRequestImplToJson(
        _$RefreshTokenRequestImpl instance) =>
    <String, dynamic>{
      'refreshToken': instance.refreshToken,
      'deviceId': instance.deviceId,
    };

_$RefreshTokenResponseImpl _$$RefreshTokenResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$RefreshTokenResponseImpl(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$RefreshTokenResponseImplToJson(
        _$RefreshTokenResponseImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'user': instance.user,
    };

_$LogoutRequestImpl _$$LogoutRequestImplFromJson(Map<String, dynamic> json) =>
    _$LogoutRequestImpl(
      deviceId: json['deviceId'] as String?,
      logoutAllDevices: json['logoutAllDevices'] as bool?,
    );

Map<String, dynamic> _$$LogoutRequestImplToJson(_$LogoutRequestImpl instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'logoutAllDevices': instance.logoutAllDevices,
    };

_$DeviceInfoImpl _$$DeviceInfoImplFromJson(Map<String, dynamic> json) =>
    _$DeviceInfoImpl(
      deviceId: json['deviceId'] as String,
      deviceName: json['deviceName'] as String,
      platform: json['platform'] as String,
      osVersion: json['osVersion'] as String,
      appVersion: json['appVersion'] as String,
      model: json['model'] as String?,
      manufacturer: json['manufacturer'] as String?,
      fcmToken: json['fcmToken'] as String?,
      lastActiveAt: json['lastActiveAt'] == null
          ? null
          : DateTime.parse(json['lastActiveAt'] as String),
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$$DeviceInfoImplToJson(_$DeviceInfoImpl instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'deviceName': instance.deviceName,
      'platform': instance.platform,
      'osVersion': instance.osVersion,
      'appVersion': instance.appVersion,
      'model': instance.model,
      'manufacturer': instance.manufacturer,
      'fcmToken': instance.fcmToken,
      'lastActiveAt': instance.lastActiveAt?.toIso8601String(),
      'isActive': instance.isActive,
    };

_$SecuritySettingsImpl _$$SecuritySettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$SecuritySettingsImpl(
      isTwoFactorEnabled: json['isTwoFactorEnabled'] as bool? ?? false,
      isBiometricEnabled: json['isBiometricEnabled'] as bool? ?? false,
      isEmailNotificationEnabled:
          json['isEmailNotificationEnabled'] as bool? ?? false,
      isSmsNotificationEnabled:
          json['isSmsNotificationEnabled'] as bool? ?? false,
      isPushNotificationEnabled:
          json['isPushNotificationEnabled'] as bool? ?? false,
      sessionTimeoutMinutes:
          (json['sessionTimeoutMinutes'] as num?)?.toInt() ?? 30,
      maxLoginAttempts: (json['maxLoginAttempts'] as num?)?.toInt() ?? 5,
      lockoutDurationMinutes:
          (json['lockoutDurationMinutes'] as num?)?.toInt() ?? 15,
      trustedDevices: (json['trustedDevices'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      blockedDevices: (json['blockedDevices'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      lastPasswordChange: json['lastPasswordChange'] == null
          ? null
          : DateTime.parse(json['lastPasswordChange'] as String),
      lastSecurityUpdate: json['lastSecurityUpdate'] == null
          ? null
          : DateTime.parse(json['lastSecurityUpdate'] as String),
    );

Map<String, dynamic> _$$SecuritySettingsImplToJson(
        _$SecuritySettingsImpl instance) =>
    <String, dynamic>{
      'isTwoFactorEnabled': instance.isTwoFactorEnabled,
      'isBiometricEnabled': instance.isBiometricEnabled,
      'isEmailNotificationEnabled': instance.isEmailNotificationEnabled,
      'isSmsNotificationEnabled': instance.isSmsNotificationEnabled,
      'isPushNotificationEnabled': instance.isPushNotificationEnabled,
      'sessionTimeoutMinutes': instance.sessionTimeoutMinutes,
      'maxLoginAttempts': instance.maxLoginAttempts,
      'lockoutDurationMinutes': instance.lockoutDurationMinutes,
      'trustedDevices': instance.trustedDevices,
      'blockedDevices': instance.blockedDevices,
      'lastPasswordChange': instance.lastPasswordChange?.toIso8601String(),
      'lastSecurityUpdate': instance.lastSecurityUpdate?.toIso8601String(),
    };
