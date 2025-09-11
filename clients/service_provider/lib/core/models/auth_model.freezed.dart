// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuthState _$AuthStateFromJson(Map<String, dynamic> json) {
  return _AuthState.fromJson(json);
}

/// @nodoc
mixin _$AuthState {
  bool get isAuthenticated => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isBiometricEnabled => throw _privateConstructorUsedError;
  bool get isBiometricAvailable => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;
  String? get token => throw _privateConstructorUsedError;
  String? get refreshToken => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  DateTime? get tokenExpiresAt => throw _privateConstructorUsedError;
  DateTime? get lastLoginAt => throw _privateConstructorUsedError;
  int? get loginAttempts => throw _privateConstructorUsedError;
  DateTime? get lockoutUntil => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthStateCopyWith<AuthState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
  @useResult
  $Res call(
      {bool isAuthenticated,
      bool isLoading,
      bool isBiometricEnabled,
      bool isBiometricAvailable,
      User? user,
      String? token,
      String? refreshToken,
      String? error,
      DateTime? tokenExpiresAt,
      DateTime? lastLoginAt,
      int? loginAttempts,
      DateTime? lockoutUntil});

  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isAuthenticated = null,
    Object? isLoading = null,
    Object? isBiometricEnabled = null,
    Object? isBiometricAvailable = null,
    Object? user = freezed,
    Object? token = freezed,
    Object? refreshToken = freezed,
    Object? error = freezed,
    Object? tokenExpiresAt = freezed,
    Object? lastLoginAt = freezed,
    Object? loginAttempts = freezed,
    Object? lockoutUntil = freezed,
  }) {
    return _then(_value.copyWith(
      isAuthenticated: null == isAuthenticated
          ? _value.isAuthenticated
          : isAuthenticated // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isBiometricEnabled: null == isBiometricEnabled
          ? _value.isBiometricEnabled
          : isBiometricEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isBiometricAvailable: null == isBiometricAvailable
          ? _value.isBiometricAvailable
          : isBiometricAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      tokenExpiresAt: freezed == tokenExpiresAt
          ? _value.tokenExpiresAt
          : tokenExpiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      loginAttempts: freezed == loginAttempts
          ? _value.loginAttempts
          : loginAttempts // ignore: cast_nullable_to_non_nullable
              as int?,
      lockoutUntil: freezed == lockoutUntil
          ? _value.lockoutUntil
          : lockoutUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthStateImplCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory _$$AuthStateImplCopyWith(
          _$AuthStateImpl value, $Res Function(_$AuthStateImpl) then) =
      __$$AuthStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isAuthenticated,
      bool isLoading,
      bool isBiometricEnabled,
      bool isBiometricAvailable,
      User? user,
      String? token,
      String? refreshToken,
      String? error,
      DateTime? tokenExpiresAt,
      DateTime? lastLoginAt,
      int? loginAttempts,
      DateTime? lockoutUntil});

  @override
  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class __$$AuthStateImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthStateImpl>
    implements _$$AuthStateImplCopyWith<$Res> {
  __$$AuthStateImplCopyWithImpl(
      _$AuthStateImpl _value, $Res Function(_$AuthStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isAuthenticated = null,
    Object? isLoading = null,
    Object? isBiometricEnabled = null,
    Object? isBiometricAvailable = null,
    Object? user = freezed,
    Object? token = freezed,
    Object? refreshToken = freezed,
    Object? error = freezed,
    Object? tokenExpiresAt = freezed,
    Object? lastLoginAt = freezed,
    Object? loginAttempts = freezed,
    Object? lockoutUntil = freezed,
  }) {
    return _then(_$AuthStateImpl(
      isAuthenticated: null == isAuthenticated
          ? _value.isAuthenticated
          : isAuthenticated // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isBiometricEnabled: null == isBiometricEnabled
          ? _value.isBiometricEnabled
          : isBiometricEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isBiometricAvailable: null == isBiometricAvailable
          ? _value.isBiometricAvailable
          : isBiometricAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      tokenExpiresAt: freezed == tokenExpiresAt
          ? _value.tokenExpiresAt
          : tokenExpiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      loginAttempts: freezed == loginAttempts
          ? _value.loginAttempts
          : loginAttempts // ignore: cast_nullable_to_non_nullable
              as int?,
      lockoutUntil: freezed == lockoutUntil
          ? _value.lockoutUntil
          : lockoutUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthStateImpl implements _AuthState {
  const _$AuthStateImpl(
      {this.isAuthenticated = false,
      this.isLoading = false,
      this.isBiometricEnabled = false,
      this.isBiometricAvailable = false,
      this.user,
      this.token,
      this.refreshToken,
      this.error,
      this.tokenExpiresAt,
      this.lastLoginAt,
      this.loginAttempts,
      this.lockoutUntil});

  factory _$AuthStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthStateImplFromJson(json);

  @override
  @JsonKey()
  final bool isAuthenticated;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isBiometricEnabled;
  @override
  @JsonKey()
  final bool isBiometricAvailable;
  @override
  final User? user;
  @override
  final String? token;
  @override
  final String? refreshToken;
  @override
  final String? error;
  @override
  final DateTime? tokenExpiresAt;
  @override
  final DateTime? lastLoginAt;
  @override
  final int? loginAttempts;
  @override
  final DateTime? lockoutUntil;

  @override
  String toString() {
    return 'AuthState(isAuthenticated: $isAuthenticated, isLoading: $isLoading, isBiometricEnabled: $isBiometricEnabled, isBiometricAvailable: $isBiometricAvailable, user: $user, token: $token, refreshToken: $refreshToken, error: $error, tokenExpiresAt: $tokenExpiresAt, lastLoginAt: $lastLoginAt, loginAttempts: $loginAttempts, lockoutUntil: $lockoutUntil)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthStateImpl &&
            (identical(other.isAuthenticated, isAuthenticated) ||
                other.isAuthenticated == isAuthenticated) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isBiometricEnabled, isBiometricEnabled) ||
                other.isBiometricEnabled == isBiometricEnabled) &&
            (identical(other.isBiometricAvailable, isBiometricAvailable) ||
                other.isBiometricAvailable == isBiometricAvailable) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.tokenExpiresAt, tokenExpiresAt) ||
                other.tokenExpiresAt == tokenExpiresAt) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt) &&
            (identical(other.loginAttempts, loginAttempts) ||
                other.loginAttempts == loginAttempts) &&
            (identical(other.lockoutUntil, lockoutUntil) ||
                other.lockoutUntil == lockoutUntil));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isAuthenticated,
      isLoading,
      isBiometricEnabled,
      isBiometricAvailable,
      user,
      token,
      refreshToken,
      error,
      tokenExpiresAt,
      lastLoginAt,
      loginAttempts,
      lockoutUntil);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      __$$AuthStateImplCopyWithImpl<_$AuthStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthStateImplToJson(
      this,
    );
  }
}

abstract class _AuthState implements AuthState {
  const factory _AuthState(
      {final bool isAuthenticated,
      final bool isLoading,
      final bool isBiometricEnabled,
      final bool isBiometricAvailable,
      final User? user,
      final String? token,
      final String? refreshToken,
      final String? error,
      final DateTime? tokenExpiresAt,
      final DateTime? lastLoginAt,
      final int? loginAttempts,
      final DateTime? lockoutUntil}) = _$AuthStateImpl;

  factory _AuthState.fromJson(Map<String, dynamic> json) =
      _$AuthStateImpl.fromJson;

  @override
  bool get isAuthenticated;
  @override
  bool get isLoading;
  @override
  bool get isBiometricEnabled;
  @override
  bool get isBiometricAvailable;
  @override
  User? get user;
  @override
  String? get token;
  @override
  String? get refreshToken;
  @override
  String? get error;
  @override
  DateTime? get tokenExpiresAt;
  @override
  DateTime? get lastLoginAt;
  @override
  int? get loginAttempts;
  @override
  DateTime? get lockoutUntil;
  @override
  @JsonKey(ignore: true)
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) {
  return _LoginRequest.fromJson(json);
}

/// @nodoc
mixin _$LoginRequest {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String? get deviceId => throw _privateConstructorUsedError;
  String? get deviceName => throw _privateConstructorUsedError;
  String? get fcmToken => throw _privateConstructorUsedError;
  bool? get rememberMe => throw _privateConstructorUsedError;
  String? get biometricSignature => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LoginRequestCopyWith<LoginRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginRequestCopyWith<$Res> {
  factory $LoginRequestCopyWith(
          LoginRequest value, $Res Function(LoginRequest) then) =
      _$LoginRequestCopyWithImpl<$Res, LoginRequest>;
  @useResult
  $Res call(
      {String email,
      String password,
      String? deviceId,
      String? deviceName,
      String? fcmToken,
      bool? rememberMe,
      String? biometricSignature});
}

/// @nodoc
class _$LoginRequestCopyWithImpl<$Res, $Val extends LoginRequest>
    implements $LoginRequestCopyWith<$Res> {
  _$LoginRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? deviceId = freezed,
    Object? deviceName = freezed,
    Object? fcmToken = freezed,
    Object? rememberMe = freezed,
    Object? biometricSignature = freezed,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceName: freezed == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String?,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
      rememberMe: freezed == rememberMe
          ? _value.rememberMe
          : rememberMe // ignore: cast_nullable_to_non_nullable
              as bool?,
      biometricSignature: freezed == biometricSignature
          ? _value.biometricSignature
          : biometricSignature // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoginRequestImplCopyWith<$Res>
    implements $LoginRequestCopyWith<$Res> {
  factory _$$LoginRequestImplCopyWith(
          _$LoginRequestImpl value, $Res Function(_$LoginRequestImpl) then) =
      __$$LoginRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String email,
      String password,
      String? deviceId,
      String? deviceName,
      String? fcmToken,
      bool? rememberMe,
      String? biometricSignature});
}

/// @nodoc
class __$$LoginRequestImplCopyWithImpl<$Res>
    extends _$LoginRequestCopyWithImpl<$Res, _$LoginRequestImpl>
    implements _$$LoginRequestImplCopyWith<$Res> {
  __$$LoginRequestImplCopyWithImpl(
      _$LoginRequestImpl _value, $Res Function(_$LoginRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? deviceId = freezed,
    Object? deviceName = freezed,
    Object? fcmToken = freezed,
    Object? rememberMe = freezed,
    Object? biometricSignature = freezed,
  }) {
    return _then(_$LoginRequestImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceName: freezed == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String?,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
      rememberMe: freezed == rememberMe
          ? _value.rememberMe
          : rememberMe // ignore: cast_nullable_to_non_nullable
              as bool?,
      biometricSignature: freezed == biometricSignature
          ? _value.biometricSignature
          : biometricSignature // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginRequestImpl implements _LoginRequest {
  const _$LoginRequestImpl(
      {required this.email,
      required this.password,
      this.deviceId,
      this.deviceName,
      this.fcmToken,
      this.rememberMe,
      this.biometricSignature});

  factory _$LoginRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginRequestImplFromJson(json);

  @override
  final String email;
  @override
  final String password;
  @override
  final String? deviceId;
  @override
  final String? deviceName;
  @override
  final String? fcmToken;
  @override
  final bool? rememberMe;
  @override
  final String? biometricSignature;

  @override
  String toString() {
    return 'LoginRequest(email: $email, password: $password, deviceId: $deviceId, deviceName: $deviceName, fcmToken: $fcmToken, rememberMe: $rememberMe, biometricSignature: $biometricSignature)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginRequestImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.deviceName, deviceName) ||
                other.deviceName == deviceName) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken) &&
            (identical(other.rememberMe, rememberMe) ||
                other.rememberMe == rememberMe) &&
            (identical(other.biometricSignature, biometricSignature) ||
                other.biometricSignature == biometricSignature));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, email, password, deviceId,
      deviceName, fcmToken, rememberMe, biometricSignature);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      __$$LoginRequestImplCopyWithImpl<_$LoginRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginRequestImplToJson(
      this,
    );
  }
}

abstract class _LoginRequest implements LoginRequest {
  const factory _LoginRequest(
      {required final String email,
      required final String password,
      final String? deviceId,
      final String? deviceName,
      final String? fcmToken,
      final bool? rememberMe,
      final String? biometricSignature}) = _$LoginRequestImpl;

  factory _LoginRequest.fromJson(Map<String, dynamic> json) =
      _$LoginRequestImpl.fromJson;

  @override
  String get email;
  @override
  String get password;
  @override
  String? get deviceId;
  @override
  String? get deviceName;
  @override
  String? get fcmToken;
  @override
  bool? get rememberMe;
  @override
  String? get biometricSignature;
  @override
  @JsonKey(ignore: true)
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return _LoginResponse.fromJson(json);
}

/// @nodoc
mixin _$LoginResponse {
  String get accessToken => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;
  User get user => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  bool? get requiresVerification => throw _privateConstructorUsedError;
  bool? get requiresProfileSetup => throw _privateConstructorUsedError;
  bool? get requiresTwoFactor => throw _privateConstructorUsedError;
  String? get twoFactorMethod => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LoginResponseCopyWith<LoginResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginResponseCopyWith<$Res> {
  factory $LoginResponseCopyWith(
          LoginResponse value, $Res Function(LoginResponse) then) =
      _$LoginResponseCopyWithImpl<$Res, LoginResponse>;
  @useResult
  $Res call(
      {String accessToken,
      String refreshToken,
      User user,
      DateTime expiresAt,
      String? message,
      bool? requiresVerification,
      bool? requiresProfileSetup,
      bool? requiresTwoFactor,
      String? twoFactorMethod});

  $UserCopyWith<$Res> get user;
}

/// @nodoc
class _$LoginResponseCopyWithImpl<$Res, $Val extends LoginResponse>
    implements $LoginResponseCopyWith<$Res> {
  _$LoginResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? user = null,
    Object? expiresAt = null,
    Object? message = freezed,
    Object? requiresVerification = freezed,
    Object? requiresProfileSetup = freezed,
    Object? requiresTwoFactor = freezed,
    Object? twoFactorMethod = freezed,
  }) {
    return _then(_value.copyWith(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      requiresVerification: freezed == requiresVerification
          ? _value.requiresVerification
          : requiresVerification // ignore: cast_nullable_to_non_nullable
              as bool?,
      requiresProfileSetup: freezed == requiresProfileSetup
          ? _value.requiresProfileSetup
          : requiresProfileSetup // ignore: cast_nullable_to_non_nullable
              as bool?,
      requiresTwoFactor: freezed == requiresTwoFactor
          ? _value.requiresTwoFactor
          : requiresTwoFactor // ignore: cast_nullable_to_non_nullable
              as bool?,
      twoFactorMethod: freezed == twoFactorMethod
          ? _value.twoFactorMethod
          : twoFactorMethod // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LoginResponseImplCopyWith<$Res>
    implements $LoginResponseCopyWith<$Res> {
  factory _$$LoginResponseImplCopyWith(
          _$LoginResponseImpl value, $Res Function(_$LoginResponseImpl) then) =
      __$$LoginResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String accessToken,
      String refreshToken,
      User user,
      DateTime expiresAt,
      String? message,
      bool? requiresVerification,
      bool? requiresProfileSetup,
      bool? requiresTwoFactor,
      String? twoFactorMethod});

  @override
  $UserCopyWith<$Res> get user;
}

/// @nodoc
class __$$LoginResponseImplCopyWithImpl<$Res>
    extends _$LoginResponseCopyWithImpl<$Res, _$LoginResponseImpl>
    implements _$$LoginResponseImplCopyWith<$Res> {
  __$$LoginResponseImplCopyWithImpl(
      _$LoginResponseImpl _value, $Res Function(_$LoginResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? user = null,
    Object? expiresAt = null,
    Object? message = freezed,
    Object? requiresVerification = freezed,
    Object? requiresProfileSetup = freezed,
    Object? requiresTwoFactor = freezed,
    Object? twoFactorMethod = freezed,
  }) {
    return _then(_$LoginResponseImpl(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      requiresVerification: freezed == requiresVerification
          ? _value.requiresVerification
          : requiresVerification // ignore: cast_nullable_to_non_nullable
              as bool?,
      requiresProfileSetup: freezed == requiresProfileSetup
          ? _value.requiresProfileSetup
          : requiresProfileSetup // ignore: cast_nullable_to_non_nullable
              as bool?,
      requiresTwoFactor: freezed == requiresTwoFactor
          ? _value.requiresTwoFactor
          : requiresTwoFactor // ignore: cast_nullable_to_non_nullable
              as bool?,
      twoFactorMethod: freezed == twoFactorMethod
          ? _value.twoFactorMethod
          : twoFactorMethod // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginResponseImpl implements _LoginResponse {
  const _$LoginResponseImpl(
      {required this.accessToken,
      required this.refreshToken,
      required this.user,
      required this.expiresAt,
      this.message,
      this.requiresVerification,
      this.requiresProfileSetup,
      this.requiresTwoFactor,
      this.twoFactorMethod});

  factory _$LoginResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginResponseImplFromJson(json);

  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  final User user;
  @override
  final DateTime expiresAt;
  @override
  final String? message;
  @override
  final bool? requiresVerification;
  @override
  final bool? requiresProfileSetup;
  @override
  final bool? requiresTwoFactor;
  @override
  final String? twoFactorMethod;

  @override
  String toString() {
    return 'LoginResponse(accessToken: $accessToken, refreshToken: $refreshToken, user: $user, expiresAt: $expiresAt, message: $message, requiresVerification: $requiresVerification, requiresProfileSetup: $requiresProfileSetup, requiresTwoFactor: $requiresTwoFactor, twoFactorMethod: $twoFactorMethod)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginResponseImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.requiresVerification, requiresVerification) ||
                other.requiresVerification == requiresVerification) &&
            (identical(other.requiresProfileSetup, requiresProfileSetup) ||
                other.requiresProfileSetup == requiresProfileSetup) &&
            (identical(other.requiresTwoFactor, requiresTwoFactor) ||
                other.requiresTwoFactor == requiresTwoFactor) &&
            (identical(other.twoFactorMethod, twoFactorMethod) ||
                other.twoFactorMethod == twoFactorMethod));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      accessToken,
      refreshToken,
      user,
      expiresAt,
      message,
      requiresVerification,
      requiresProfileSetup,
      requiresTwoFactor,
      twoFactorMethod);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginResponseImplCopyWith<_$LoginResponseImpl> get copyWith =>
      __$$LoginResponseImplCopyWithImpl<_$LoginResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginResponseImplToJson(
      this,
    );
  }
}

abstract class _LoginResponse implements LoginResponse {
  const factory _LoginResponse(
      {required final String accessToken,
      required final String refreshToken,
      required final User user,
      required final DateTime expiresAt,
      final String? message,
      final bool? requiresVerification,
      final bool? requiresProfileSetup,
      final bool? requiresTwoFactor,
      final String? twoFactorMethod}) = _$LoginResponseImpl;

  factory _LoginResponse.fromJson(Map<String, dynamic> json) =
      _$LoginResponseImpl.fromJson;

  @override
  String get accessToken;
  @override
  String get refreshToken;
  @override
  User get user;
  @override
  DateTime get expiresAt;
  @override
  String? get message;
  @override
  bool? get requiresVerification;
  @override
  bool? get requiresProfileSetup;
  @override
  bool? get requiresTwoFactor;
  @override
  String? get twoFactorMethod;
  @override
  @JsonKey(ignore: true)
  _$$LoginResponseImplCopyWith<_$LoginResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) {
  return _RegisterRequest.fromJson(json);
}

/// @nodoc
mixin _$RegisterRequest {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  ServiceProviderType get providerType => throw _privateConstructorUsedError;
  RegistrationType get registrationType => throw _privateConstructorUsedError;
  String? get confirmPassword => throw _privateConstructorUsedError;
  String? get county => throw _privateConstructorUsedError;
  String? get subCounty => throw _privateConstructorUsedError;
  String? get ward => throw _privateConstructorUsedError;
  String? get businessName => throw _privateConstructorUsedError;
  String? get businessRegistrationNumber => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  List<String>? get services => throw _privateConstructorUsedError;
  String? get referralCode => throw _privateConstructorUsedError;
  String? get deviceId => throw _privateConstructorUsedError;
  String? get deviceName => throw _privateConstructorUsedError;
  String? get fcmToken => throw _privateConstructorUsedError;
  bool? get agreeToTerms => throw _privateConstructorUsedError;
  bool? get agreeToPrivacyPolicy => throw _privateConstructorUsedError;
  bool? get subscribeToNewsletter => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RegisterRequestCopyWith<RegisterRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterRequestCopyWith<$Res> {
  factory $RegisterRequestCopyWith(
          RegisterRequest value, $Res Function(RegisterRequest) then) =
      _$RegisterRequestCopyWithImpl<$Res, RegisterRequest>;
  @useResult
  $Res call(
      {String email,
      String password,
      String firstName,
      String lastName,
      String phoneNumber,
      ServiceProviderType providerType,
      RegistrationType registrationType,
      String? confirmPassword,
      String? county,
      String? subCounty,
      String? ward,
      String? businessName,
      String? businessRegistrationNumber,
      String? location,
      String? bio,
      List<String>? services,
      String? referralCode,
      String? deviceId,
      String? deviceName,
      String? fcmToken,
      bool? agreeToTerms,
      bool? agreeToPrivacyPolicy,
      bool? subscribeToNewsletter});
}

/// @nodoc
class _$RegisterRequestCopyWithImpl<$Res, $Val extends RegisterRequest>
    implements $RegisterRequestCopyWith<$Res> {
  _$RegisterRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? phoneNumber = null,
    Object? providerType = null,
    Object? registrationType = null,
    Object? confirmPassword = freezed,
    Object? county = freezed,
    Object? subCounty = freezed,
    Object? ward = freezed,
    Object? businessName = freezed,
    Object? businessRegistrationNumber = freezed,
    Object? location = freezed,
    Object? bio = freezed,
    Object? services = freezed,
    Object? referralCode = freezed,
    Object? deviceId = freezed,
    Object? deviceName = freezed,
    Object? fcmToken = freezed,
    Object? agreeToTerms = freezed,
    Object? agreeToPrivacyPolicy = freezed,
    Object? subscribeToNewsletter = freezed,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      providerType: null == providerType
          ? _value.providerType
          : providerType // ignore: cast_nullable_to_non_nullable
              as ServiceProviderType,
      registrationType: null == registrationType
          ? _value.registrationType
          : registrationType // ignore: cast_nullable_to_non_nullable
              as RegistrationType,
      confirmPassword: freezed == confirmPassword
          ? _value.confirmPassword
          : confirmPassword // ignore: cast_nullable_to_non_nullable
              as String?,
      county: freezed == county
          ? _value.county
          : county // ignore: cast_nullable_to_non_nullable
              as String?,
      subCounty: freezed == subCounty
          ? _value.subCounty
          : subCounty // ignore: cast_nullable_to_non_nullable
              as String?,
      ward: freezed == ward
          ? _value.ward
          : ward // ignore: cast_nullable_to_non_nullable
              as String?,
      businessName: freezed == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String?,
      businessRegistrationNumber: freezed == businessRegistrationNumber
          ? _value.businessRegistrationNumber
          : businessRegistrationNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      services: freezed == services
          ? _value.services
          : services // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      referralCode: freezed == referralCode
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceName: freezed == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String?,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
      agreeToTerms: freezed == agreeToTerms
          ? _value.agreeToTerms
          : agreeToTerms // ignore: cast_nullable_to_non_nullable
              as bool?,
      agreeToPrivacyPolicy: freezed == agreeToPrivacyPolicy
          ? _value.agreeToPrivacyPolicy
          : agreeToPrivacyPolicy // ignore: cast_nullable_to_non_nullable
              as bool?,
      subscribeToNewsletter: freezed == subscribeToNewsletter
          ? _value.subscribeToNewsletter
          : subscribeToNewsletter // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegisterRequestImplCopyWith<$Res>
    implements $RegisterRequestCopyWith<$Res> {
  factory _$$RegisterRequestImplCopyWith(_$RegisterRequestImpl value,
          $Res Function(_$RegisterRequestImpl) then) =
      __$$RegisterRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String email,
      String password,
      String firstName,
      String lastName,
      String phoneNumber,
      ServiceProviderType providerType,
      RegistrationType registrationType,
      String? confirmPassword,
      String? county,
      String? subCounty,
      String? ward,
      String? businessName,
      String? businessRegistrationNumber,
      String? location,
      String? bio,
      List<String>? services,
      String? referralCode,
      String? deviceId,
      String? deviceName,
      String? fcmToken,
      bool? agreeToTerms,
      bool? agreeToPrivacyPolicy,
      bool? subscribeToNewsletter});
}

/// @nodoc
class __$$RegisterRequestImplCopyWithImpl<$Res>
    extends _$RegisterRequestCopyWithImpl<$Res, _$RegisterRequestImpl>
    implements _$$RegisterRequestImplCopyWith<$Res> {
  __$$RegisterRequestImplCopyWithImpl(
      _$RegisterRequestImpl _value, $Res Function(_$RegisterRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? phoneNumber = null,
    Object? providerType = null,
    Object? registrationType = null,
    Object? confirmPassword = freezed,
    Object? county = freezed,
    Object? subCounty = freezed,
    Object? ward = freezed,
    Object? businessName = freezed,
    Object? businessRegistrationNumber = freezed,
    Object? location = freezed,
    Object? bio = freezed,
    Object? services = freezed,
    Object? referralCode = freezed,
    Object? deviceId = freezed,
    Object? deviceName = freezed,
    Object? fcmToken = freezed,
    Object? agreeToTerms = freezed,
    Object? agreeToPrivacyPolicy = freezed,
    Object? subscribeToNewsletter = freezed,
  }) {
    return _then(_$RegisterRequestImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      providerType: null == providerType
          ? _value.providerType
          : providerType // ignore: cast_nullable_to_non_nullable
              as ServiceProviderType,
      registrationType: null == registrationType
          ? _value.registrationType
          : registrationType // ignore: cast_nullable_to_non_nullable
              as RegistrationType,
      confirmPassword: freezed == confirmPassword
          ? _value.confirmPassword
          : confirmPassword // ignore: cast_nullable_to_non_nullable
              as String?,
      county: freezed == county
          ? _value.county
          : county // ignore: cast_nullable_to_non_nullable
              as String?,
      subCounty: freezed == subCounty
          ? _value.subCounty
          : subCounty // ignore: cast_nullable_to_non_nullable
              as String?,
      ward: freezed == ward
          ? _value.ward
          : ward // ignore: cast_nullable_to_non_nullable
              as String?,
      businessName: freezed == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String?,
      businessRegistrationNumber: freezed == businessRegistrationNumber
          ? _value.businessRegistrationNumber
          : businessRegistrationNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      services: freezed == services
          ? _value._services
          : services // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      referralCode: freezed == referralCode
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceName: freezed == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String?,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
      agreeToTerms: freezed == agreeToTerms
          ? _value.agreeToTerms
          : agreeToTerms // ignore: cast_nullable_to_non_nullable
              as bool?,
      agreeToPrivacyPolicy: freezed == agreeToPrivacyPolicy
          ? _value.agreeToPrivacyPolicy
          : agreeToPrivacyPolicy // ignore: cast_nullable_to_non_nullable
              as bool?,
      subscribeToNewsletter: freezed == subscribeToNewsletter
          ? _value.subscribeToNewsletter
          : subscribeToNewsletter // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterRequestImpl implements _RegisterRequest {
  const _$RegisterRequestImpl(
      {required this.email,
      required this.password,
      required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.providerType,
      this.registrationType = RegistrationType.business,
      this.confirmPassword,
      this.county,
      this.subCounty,
      this.ward,
      this.businessName,
      this.businessRegistrationNumber,
      this.location,
      this.bio,
      final List<String>? services,
      this.referralCode,
      this.deviceId,
      this.deviceName,
      this.fcmToken,
      this.agreeToTerms,
      this.agreeToPrivacyPolicy,
      this.subscribeToNewsletter})
      : _services = services;

  factory _$RegisterRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegisterRequestImplFromJson(json);

  @override
  final String email;
  @override
  final String password;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String phoneNumber;
  @override
  final ServiceProviderType providerType;
  @override
  @JsonKey()
  final RegistrationType registrationType;
  @override
  final String? confirmPassword;
  @override
  final String? county;
  @override
  final String? subCounty;
  @override
  final String? ward;
  @override
  final String? businessName;
  @override
  final String? businessRegistrationNumber;
  @override
  final String? location;
  @override
  final String? bio;
  final List<String>? _services;
  @override
  List<String>? get services {
    final value = _services;
    if (value == null) return null;
    if (_services is EqualUnmodifiableListView) return _services;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? referralCode;
  @override
  final String? deviceId;
  @override
  final String? deviceName;
  @override
  final String? fcmToken;
  @override
  final bool? agreeToTerms;
  @override
  final bool? agreeToPrivacyPolicy;
  @override
  final bool? subscribeToNewsletter;

  @override
  String toString() {
    return 'RegisterRequest(email: $email, password: $password, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, providerType: $providerType, registrationType: $registrationType, confirmPassword: $confirmPassword, county: $county, subCounty: $subCounty, ward: $ward, businessName: $businessName, businessRegistrationNumber: $businessRegistrationNumber, location: $location, bio: $bio, services: $services, referralCode: $referralCode, deviceId: $deviceId, deviceName: $deviceName, fcmToken: $fcmToken, agreeToTerms: $agreeToTerms, agreeToPrivacyPolicy: $agreeToPrivacyPolicy, subscribeToNewsletter: $subscribeToNewsletter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterRequestImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.providerType, providerType) ||
                other.providerType == providerType) &&
            (identical(other.registrationType, registrationType) ||
                other.registrationType == registrationType) &&
            (identical(other.confirmPassword, confirmPassword) ||
                other.confirmPassword == confirmPassword) &&
            (identical(other.county, county) || other.county == county) &&
            (identical(other.subCounty, subCounty) ||
                other.subCounty == subCounty) &&
            (identical(other.ward, ward) || other.ward == ward) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.businessRegistrationNumber,
                    businessRegistrationNumber) ||
                other.businessRegistrationNumber ==
                    businessRegistrationNumber) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            const DeepCollectionEquality().equals(other._services, _services) &&
            (identical(other.referralCode, referralCode) ||
                other.referralCode == referralCode) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.deviceName, deviceName) ||
                other.deviceName == deviceName) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken) &&
            (identical(other.agreeToTerms, agreeToTerms) ||
                other.agreeToTerms == agreeToTerms) &&
            (identical(other.agreeToPrivacyPolicy, agreeToPrivacyPolicy) ||
                other.agreeToPrivacyPolicy == agreeToPrivacyPolicy) &&
            (identical(other.subscribeToNewsletter, subscribeToNewsletter) ||
                other.subscribeToNewsletter == subscribeToNewsletter));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        email,
        password,
        firstName,
        lastName,
        phoneNumber,
        providerType,
        registrationType,
        confirmPassword,
        county,
        subCounty,
        ward,
        businessName,
        businessRegistrationNumber,
        location,
        bio,
        const DeepCollectionEquality().hash(_services),
        referralCode,
        deviceId,
        deviceName,
        fcmToken,
        agreeToTerms,
        agreeToPrivacyPolicy,
        subscribeToNewsletter
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterRequestImplCopyWith<_$RegisterRequestImpl> get copyWith =>
      __$$RegisterRequestImplCopyWithImpl<_$RegisterRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterRequestImplToJson(
      this,
    );
  }
}

abstract class _RegisterRequest implements RegisterRequest {
  const factory _RegisterRequest(
      {required final String email,
      required final String password,
      required final String firstName,
      required final String lastName,
      required final String phoneNumber,
      required final ServiceProviderType providerType,
      final RegistrationType registrationType,
      final String? confirmPassword,
      final String? county,
      final String? subCounty,
      final String? ward,
      final String? businessName,
      final String? businessRegistrationNumber,
      final String? location,
      final String? bio,
      final List<String>? services,
      final String? referralCode,
      final String? deviceId,
      final String? deviceName,
      final String? fcmToken,
      final bool? agreeToTerms,
      final bool? agreeToPrivacyPolicy,
      final bool? subscribeToNewsletter}) = _$RegisterRequestImpl;

  factory _RegisterRequest.fromJson(Map<String, dynamic> json) =
      _$RegisterRequestImpl.fromJson;

  @override
  String get email;
  @override
  String get password;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String get phoneNumber;
  @override
  ServiceProviderType get providerType;
  @override
  RegistrationType get registrationType;
  @override
  String? get confirmPassword;
  @override
  String? get county;
  @override
  String? get subCounty;
  @override
  String? get ward;
  @override
  String? get businessName;
  @override
  String? get businessRegistrationNumber;
  @override
  String? get location;
  @override
  String? get bio;
  @override
  List<String>? get services;
  @override
  String? get referralCode;
  @override
  String? get deviceId;
  @override
  String? get deviceName;
  @override
  String? get fcmToken;
  @override
  bool? get agreeToTerms;
  @override
  bool? get agreeToPrivacyPolicy;
  @override
  bool? get subscribeToNewsletter;
  @override
  @JsonKey(ignore: true)
  _$$RegisterRequestImplCopyWith<_$RegisterRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RegisterResponse _$RegisterResponseFromJson(Map<String, dynamic> json) {
  return _RegisterResponse.fromJson(json);
}

/// @nodoc
mixin _$RegisterResponse {
  String get message => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get verificationToken => throw _privateConstructorUsedError;
  bool? get requiresEmailVerification => throw _privateConstructorUsedError;
  bool? get requiresPhoneVerification => throw _privateConstructorUsedError;
  String? get nextStep => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RegisterResponseCopyWith<RegisterResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterResponseCopyWith<$Res> {
  factory $RegisterResponseCopyWith(
          RegisterResponse value, $Res Function(RegisterResponse) then) =
      _$RegisterResponseCopyWithImpl<$Res, RegisterResponse>;
  @useResult
  $Res call(
      {String message,
      String userId,
      String? verificationToken,
      bool? requiresEmailVerification,
      bool? requiresPhoneVerification,
      String? nextStep});
}

/// @nodoc
class _$RegisterResponseCopyWithImpl<$Res, $Val extends RegisterResponse>
    implements $RegisterResponseCopyWith<$Res> {
  _$RegisterResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? userId = null,
    Object? verificationToken = freezed,
    Object? requiresEmailVerification = freezed,
    Object? requiresPhoneVerification = freezed,
    Object? nextStep = freezed,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      verificationToken: freezed == verificationToken
          ? _value.verificationToken
          : verificationToken // ignore: cast_nullable_to_non_nullable
              as String?,
      requiresEmailVerification: freezed == requiresEmailVerification
          ? _value.requiresEmailVerification
          : requiresEmailVerification // ignore: cast_nullable_to_non_nullable
              as bool?,
      requiresPhoneVerification: freezed == requiresPhoneVerification
          ? _value.requiresPhoneVerification
          : requiresPhoneVerification // ignore: cast_nullable_to_non_nullable
              as bool?,
      nextStep: freezed == nextStep
          ? _value.nextStep
          : nextStep // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegisterResponseImplCopyWith<$Res>
    implements $RegisterResponseCopyWith<$Res> {
  factory _$$RegisterResponseImplCopyWith(_$RegisterResponseImpl value,
          $Res Function(_$RegisterResponseImpl) then) =
      __$$RegisterResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String message,
      String userId,
      String? verificationToken,
      bool? requiresEmailVerification,
      bool? requiresPhoneVerification,
      String? nextStep});
}

/// @nodoc
class __$$RegisterResponseImplCopyWithImpl<$Res>
    extends _$RegisterResponseCopyWithImpl<$Res, _$RegisterResponseImpl>
    implements _$$RegisterResponseImplCopyWith<$Res> {
  __$$RegisterResponseImplCopyWithImpl(_$RegisterResponseImpl _value,
      $Res Function(_$RegisterResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? userId = null,
    Object? verificationToken = freezed,
    Object? requiresEmailVerification = freezed,
    Object? requiresPhoneVerification = freezed,
    Object? nextStep = freezed,
  }) {
    return _then(_$RegisterResponseImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      verificationToken: freezed == verificationToken
          ? _value.verificationToken
          : verificationToken // ignore: cast_nullable_to_non_nullable
              as String?,
      requiresEmailVerification: freezed == requiresEmailVerification
          ? _value.requiresEmailVerification
          : requiresEmailVerification // ignore: cast_nullable_to_non_nullable
              as bool?,
      requiresPhoneVerification: freezed == requiresPhoneVerification
          ? _value.requiresPhoneVerification
          : requiresPhoneVerification // ignore: cast_nullable_to_non_nullable
              as bool?,
      nextStep: freezed == nextStep
          ? _value.nextStep
          : nextStep // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterResponseImpl implements _RegisterResponse {
  const _$RegisterResponseImpl(
      {required this.message,
      required this.userId,
      this.verificationToken,
      this.requiresEmailVerification,
      this.requiresPhoneVerification,
      this.nextStep});

  factory _$RegisterResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegisterResponseImplFromJson(json);

  @override
  final String message;
  @override
  final String userId;
  @override
  final String? verificationToken;
  @override
  final bool? requiresEmailVerification;
  @override
  final bool? requiresPhoneVerification;
  @override
  final String? nextStep;

  @override
  String toString() {
    return 'RegisterResponse(message: $message, userId: $userId, verificationToken: $verificationToken, requiresEmailVerification: $requiresEmailVerification, requiresPhoneVerification: $requiresPhoneVerification, nextStep: $nextStep)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterResponseImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.verificationToken, verificationToken) ||
                other.verificationToken == verificationToken) &&
            (identical(other.requiresEmailVerification,
                    requiresEmailVerification) ||
                other.requiresEmailVerification == requiresEmailVerification) &&
            (identical(other.requiresPhoneVerification,
                    requiresPhoneVerification) ||
                other.requiresPhoneVerification == requiresPhoneVerification) &&
            (identical(other.nextStep, nextStep) ||
                other.nextStep == nextStep));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      message,
      userId,
      verificationToken,
      requiresEmailVerification,
      requiresPhoneVerification,
      nextStep);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterResponseImplCopyWith<_$RegisterResponseImpl> get copyWith =>
      __$$RegisterResponseImplCopyWithImpl<_$RegisterResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterResponseImplToJson(
      this,
    );
  }
}

abstract class _RegisterResponse implements RegisterResponse {
  const factory _RegisterResponse(
      {required final String message,
      required final String userId,
      final String? verificationToken,
      final bool? requiresEmailVerification,
      final bool? requiresPhoneVerification,
      final String? nextStep}) = _$RegisterResponseImpl;

  factory _RegisterResponse.fromJson(Map<String, dynamic> json) =
      _$RegisterResponseImpl.fromJson;

  @override
  String get message;
  @override
  String get userId;
  @override
  String? get verificationToken;
  @override
  bool? get requiresEmailVerification;
  @override
  bool? get requiresPhoneVerification;
  @override
  String? get nextStep;
  @override
  @JsonKey(ignore: true)
  _$$RegisterResponseImplCopyWith<_$RegisterResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ForgotPasswordRequest _$ForgotPasswordRequestFromJson(
    Map<String, dynamic> json) {
  return _ForgotPasswordRequest.fromJson(json);
}

/// @nodoc
mixin _$ForgotPasswordRequest {
  String get email => throw _privateConstructorUsedError;
  String? get resetMethod => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ForgotPasswordRequestCopyWith<ForgotPasswordRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForgotPasswordRequestCopyWith<$Res> {
  factory $ForgotPasswordRequestCopyWith(ForgotPasswordRequest value,
          $Res Function(ForgotPasswordRequest) then) =
      _$ForgotPasswordRequestCopyWithImpl<$Res, ForgotPasswordRequest>;
  @useResult
  $Res call({String email, String? resetMethod});
}

/// @nodoc
class _$ForgotPasswordRequestCopyWithImpl<$Res,
        $Val extends ForgotPasswordRequest>
    implements $ForgotPasswordRequestCopyWith<$Res> {
  _$ForgotPasswordRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? resetMethod = freezed,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      resetMethod: freezed == resetMethod
          ? _value.resetMethod
          : resetMethod // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ForgotPasswordRequestImplCopyWith<$Res>
    implements $ForgotPasswordRequestCopyWith<$Res> {
  factory _$$ForgotPasswordRequestImplCopyWith(
          _$ForgotPasswordRequestImpl value,
          $Res Function(_$ForgotPasswordRequestImpl) then) =
      __$$ForgotPasswordRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String? resetMethod});
}

/// @nodoc
class __$$ForgotPasswordRequestImplCopyWithImpl<$Res>
    extends _$ForgotPasswordRequestCopyWithImpl<$Res,
        _$ForgotPasswordRequestImpl>
    implements _$$ForgotPasswordRequestImplCopyWith<$Res> {
  __$$ForgotPasswordRequestImplCopyWithImpl(_$ForgotPasswordRequestImpl _value,
      $Res Function(_$ForgotPasswordRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? resetMethod = freezed,
  }) {
    return _then(_$ForgotPasswordRequestImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      resetMethod: freezed == resetMethod
          ? _value.resetMethod
          : resetMethod // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ForgotPasswordRequestImpl implements _ForgotPasswordRequest {
  const _$ForgotPasswordRequestImpl({required this.email, this.resetMethod});

  factory _$ForgotPasswordRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ForgotPasswordRequestImplFromJson(json);

  @override
  final String email;
  @override
  final String? resetMethod;

  @override
  String toString() {
    return 'ForgotPasswordRequest(email: $email, resetMethod: $resetMethod)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForgotPasswordRequestImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.resetMethod, resetMethod) ||
                other.resetMethod == resetMethod));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, email, resetMethod);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ForgotPasswordRequestImplCopyWith<_$ForgotPasswordRequestImpl>
      get copyWith => __$$ForgotPasswordRequestImplCopyWithImpl<
          _$ForgotPasswordRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ForgotPasswordRequestImplToJson(
      this,
    );
  }
}

abstract class _ForgotPasswordRequest implements ForgotPasswordRequest {
  const factory _ForgotPasswordRequest(
      {required final String email,
      final String? resetMethod}) = _$ForgotPasswordRequestImpl;

  factory _ForgotPasswordRequest.fromJson(Map<String, dynamic> json) =
      _$ForgotPasswordRequestImpl.fromJson;

  @override
  String get email;
  @override
  String? get resetMethod;
  @override
  @JsonKey(ignore: true)
  _$$ForgotPasswordRequestImplCopyWith<_$ForgotPasswordRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ForgotPasswordResponse _$ForgotPasswordResponseFromJson(
    Map<String, dynamic> json) {
  return _ForgotPasswordResponse.fromJson(json);
}

/// @nodoc
mixin _$ForgotPasswordResponse {
  String get message => throw _privateConstructorUsedError;
  String get resetToken => throw _privateConstructorUsedError;
  String? get resetMethod => throw _privateConstructorUsedError;
  int? get expiresInMinutes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ForgotPasswordResponseCopyWith<ForgotPasswordResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForgotPasswordResponseCopyWith<$Res> {
  factory $ForgotPasswordResponseCopyWith(ForgotPasswordResponse value,
          $Res Function(ForgotPasswordResponse) then) =
      _$ForgotPasswordResponseCopyWithImpl<$Res, ForgotPasswordResponse>;
  @useResult
  $Res call(
      {String message,
      String resetToken,
      String? resetMethod,
      int? expiresInMinutes});
}

/// @nodoc
class _$ForgotPasswordResponseCopyWithImpl<$Res,
        $Val extends ForgotPasswordResponse>
    implements $ForgotPasswordResponseCopyWith<$Res> {
  _$ForgotPasswordResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? resetToken = null,
    Object? resetMethod = freezed,
    Object? expiresInMinutes = freezed,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      resetToken: null == resetToken
          ? _value.resetToken
          : resetToken // ignore: cast_nullable_to_non_nullable
              as String,
      resetMethod: freezed == resetMethod
          ? _value.resetMethod
          : resetMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresInMinutes: freezed == expiresInMinutes
          ? _value.expiresInMinutes
          : expiresInMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ForgotPasswordResponseImplCopyWith<$Res>
    implements $ForgotPasswordResponseCopyWith<$Res> {
  factory _$$ForgotPasswordResponseImplCopyWith(
          _$ForgotPasswordResponseImpl value,
          $Res Function(_$ForgotPasswordResponseImpl) then) =
      __$$ForgotPasswordResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String message,
      String resetToken,
      String? resetMethod,
      int? expiresInMinutes});
}

/// @nodoc
class __$$ForgotPasswordResponseImplCopyWithImpl<$Res>
    extends _$ForgotPasswordResponseCopyWithImpl<$Res,
        _$ForgotPasswordResponseImpl>
    implements _$$ForgotPasswordResponseImplCopyWith<$Res> {
  __$$ForgotPasswordResponseImplCopyWithImpl(
      _$ForgotPasswordResponseImpl _value,
      $Res Function(_$ForgotPasswordResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? resetToken = null,
    Object? resetMethod = freezed,
    Object? expiresInMinutes = freezed,
  }) {
    return _then(_$ForgotPasswordResponseImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      resetToken: null == resetToken
          ? _value.resetToken
          : resetToken // ignore: cast_nullable_to_non_nullable
              as String,
      resetMethod: freezed == resetMethod
          ? _value.resetMethod
          : resetMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresInMinutes: freezed == expiresInMinutes
          ? _value.expiresInMinutes
          : expiresInMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ForgotPasswordResponseImpl implements _ForgotPasswordResponse {
  const _$ForgotPasswordResponseImpl(
      {required this.message,
      required this.resetToken,
      this.resetMethod,
      this.expiresInMinutes});

  factory _$ForgotPasswordResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ForgotPasswordResponseImplFromJson(json);

  @override
  final String message;
  @override
  final String resetToken;
  @override
  final String? resetMethod;
  @override
  final int? expiresInMinutes;

  @override
  String toString() {
    return 'ForgotPasswordResponse(message: $message, resetToken: $resetToken, resetMethod: $resetMethod, expiresInMinutes: $expiresInMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForgotPasswordResponseImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.resetToken, resetToken) ||
                other.resetToken == resetToken) &&
            (identical(other.resetMethod, resetMethod) ||
                other.resetMethod == resetMethod) &&
            (identical(other.expiresInMinutes, expiresInMinutes) ||
                other.expiresInMinutes == expiresInMinutes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, message, resetToken, resetMethod, expiresInMinutes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ForgotPasswordResponseImplCopyWith<_$ForgotPasswordResponseImpl>
      get copyWith => __$$ForgotPasswordResponseImplCopyWithImpl<
          _$ForgotPasswordResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ForgotPasswordResponseImplToJson(
      this,
    );
  }
}

abstract class _ForgotPasswordResponse implements ForgotPasswordResponse {
  const factory _ForgotPasswordResponse(
      {required final String message,
      required final String resetToken,
      final String? resetMethod,
      final int? expiresInMinutes}) = _$ForgotPasswordResponseImpl;

  factory _ForgotPasswordResponse.fromJson(Map<String, dynamic> json) =
      _$ForgotPasswordResponseImpl.fromJson;

  @override
  String get message;
  @override
  String get resetToken;
  @override
  String? get resetMethod;
  @override
  int? get expiresInMinutes;
  @override
  @JsonKey(ignore: true)
  _$$ForgotPasswordResponseImplCopyWith<_$ForgotPasswordResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ResetPasswordRequest _$ResetPasswordRequestFromJson(Map<String, dynamic> json) {
  return _ResetPasswordRequest.fromJson(json);
}

/// @nodoc
mixin _$ResetPasswordRequest {
  String get resetToken => throw _privateConstructorUsedError;
  String get newPassword => throw _privateConstructorUsedError;
  String get confirmPassword => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ResetPasswordRequestCopyWith<ResetPasswordRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResetPasswordRequestCopyWith<$Res> {
  factory $ResetPasswordRequestCopyWith(ResetPasswordRequest value,
          $Res Function(ResetPasswordRequest) then) =
      _$ResetPasswordRequestCopyWithImpl<$Res, ResetPasswordRequest>;
  @useResult
  $Res call({String resetToken, String newPassword, String confirmPassword});
}

/// @nodoc
class _$ResetPasswordRequestCopyWithImpl<$Res,
        $Val extends ResetPasswordRequest>
    implements $ResetPasswordRequestCopyWith<$Res> {
  _$ResetPasswordRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resetToken = null,
    Object? newPassword = null,
    Object? confirmPassword = null,
  }) {
    return _then(_value.copyWith(
      resetToken: null == resetToken
          ? _value.resetToken
          : resetToken // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
      confirmPassword: null == confirmPassword
          ? _value.confirmPassword
          : confirmPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResetPasswordRequestImplCopyWith<$Res>
    implements $ResetPasswordRequestCopyWith<$Res> {
  factory _$$ResetPasswordRequestImplCopyWith(_$ResetPasswordRequestImpl value,
          $Res Function(_$ResetPasswordRequestImpl) then) =
      __$$ResetPasswordRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String resetToken, String newPassword, String confirmPassword});
}

/// @nodoc
class __$$ResetPasswordRequestImplCopyWithImpl<$Res>
    extends _$ResetPasswordRequestCopyWithImpl<$Res, _$ResetPasswordRequestImpl>
    implements _$$ResetPasswordRequestImplCopyWith<$Res> {
  __$$ResetPasswordRequestImplCopyWithImpl(_$ResetPasswordRequestImpl _value,
      $Res Function(_$ResetPasswordRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resetToken = null,
    Object? newPassword = null,
    Object? confirmPassword = null,
  }) {
    return _then(_$ResetPasswordRequestImpl(
      resetToken: null == resetToken
          ? _value.resetToken
          : resetToken // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
      confirmPassword: null == confirmPassword
          ? _value.confirmPassword
          : confirmPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResetPasswordRequestImpl implements _ResetPasswordRequest {
  const _$ResetPasswordRequestImpl(
      {required this.resetToken,
      required this.newPassword,
      required this.confirmPassword});

  factory _$ResetPasswordRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResetPasswordRequestImplFromJson(json);

  @override
  final String resetToken;
  @override
  final String newPassword;
  @override
  final String confirmPassword;

  @override
  String toString() {
    return 'ResetPasswordRequest(resetToken: $resetToken, newPassword: $newPassword, confirmPassword: $confirmPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResetPasswordRequestImpl &&
            (identical(other.resetToken, resetToken) ||
                other.resetToken == resetToken) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword) &&
            (identical(other.confirmPassword, confirmPassword) ||
                other.confirmPassword == confirmPassword));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, resetToken, newPassword, confirmPassword);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ResetPasswordRequestImplCopyWith<_$ResetPasswordRequestImpl>
      get copyWith =>
          __$$ResetPasswordRequestImplCopyWithImpl<_$ResetPasswordRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResetPasswordRequestImplToJson(
      this,
    );
  }
}

abstract class _ResetPasswordRequest implements ResetPasswordRequest {
  const factory _ResetPasswordRequest(
      {required final String resetToken,
      required final String newPassword,
      required final String confirmPassword}) = _$ResetPasswordRequestImpl;

  factory _ResetPasswordRequest.fromJson(Map<String, dynamic> json) =
      _$ResetPasswordRequestImpl.fromJson;

  @override
  String get resetToken;
  @override
  String get newPassword;
  @override
  String get confirmPassword;
  @override
  @JsonKey(ignore: true)
  _$$ResetPasswordRequestImplCopyWith<_$ResetPasswordRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

VerifyOtpRequest _$VerifyOtpRequestFromJson(Map<String, dynamic> json) {
  return _VerifyOtpRequest.fromJson(json);
}

/// @nodoc
mixin _$VerifyOtpRequest {
  String get token => throw _privateConstructorUsedError;
  String get otp => throw _privateConstructorUsedError;
  OtpType get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VerifyOtpRequestCopyWith<VerifyOtpRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerifyOtpRequestCopyWith<$Res> {
  factory $VerifyOtpRequestCopyWith(
          VerifyOtpRequest value, $Res Function(VerifyOtpRequest) then) =
      _$VerifyOtpRequestCopyWithImpl<$Res, VerifyOtpRequest>;
  @useResult
  $Res call({String token, String otp, OtpType type});
}

/// @nodoc
class _$VerifyOtpRequestCopyWithImpl<$Res, $Val extends VerifyOtpRequest>
    implements $VerifyOtpRequestCopyWith<$Res> {
  _$VerifyOtpRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? otp = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as OtpType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VerifyOtpRequestImplCopyWith<$Res>
    implements $VerifyOtpRequestCopyWith<$Res> {
  factory _$$VerifyOtpRequestImplCopyWith(_$VerifyOtpRequestImpl value,
          $Res Function(_$VerifyOtpRequestImpl) then) =
      __$$VerifyOtpRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String token, String otp, OtpType type});
}

/// @nodoc
class __$$VerifyOtpRequestImplCopyWithImpl<$Res>
    extends _$VerifyOtpRequestCopyWithImpl<$Res, _$VerifyOtpRequestImpl>
    implements _$$VerifyOtpRequestImplCopyWith<$Res> {
  __$$VerifyOtpRequestImplCopyWithImpl(_$VerifyOtpRequestImpl _value,
      $Res Function(_$VerifyOtpRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? otp = null,
    Object? type = null,
  }) {
    return _then(_$VerifyOtpRequestImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as OtpType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerifyOtpRequestImpl implements _VerifyOtpRequest {
  const _$VerifyOtpRequestImpl(
      {required this.token, required this.otp, required this.type});

  factory _$VerifyOtpRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerifyOtpRequestImplFromJson(json);

  @override
  final String token;
  @override
  final String otp;
  @override
  final OtpType type;

  @override
  String toString() {
    return 'VerifyOtpRequest(token: $token, otp: $otp, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyOtpRequestImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.otp, otp) || other.otp == otp) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, token, otp, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyOtpRequestImplCopyWith<_$VerifyOtpRequestImpl> get copyWith =>
      __$$VerifyOtpRequestImplCopyWithImpl<_$VerifyOtpRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerifyOtpRequestImplToJson(
      this,
    );
  }
}

abstract class _VerifyOtpRequest implements VerifyOtpRequest {
  const factory _VerifyOtpRequest(
      {required final String token,
      required final String otp,
      required final OtpType type}) = _$VerifyOtpRequestImpl;

  factory _VerifyOtpRequest.fromJson(Map<String, dynamic> json) =
      _$VerifyOtpRequestImpl.fromJson;

  @override
  String get token;
  @override
  String get otp;
  @override
  OtpType get type;
  @override
  @JsonKey(ignore: true)
  _$$VerifyOtpRequestImplCopyWith<_$VerifyOtpRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VerifyOtpResponse _$VerifyOtpResponseFromJson(Map<String, dynamic> json) {
  return _VerifyOtpResponse.fromJson(json);
}

/// @nodoc
mixin _$VerifyOtpResponse {
  String get message => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  String? get accessToken => throw _privateConstructorUsedError;
  String? get refreshToken => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;
  String? get nextStep => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VerifyOtpResponseCopyWith<VerifyOtpResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerifyOtpResponseCopyWith<$Res> {
  factory $VerifyOtpResponseCopyWith(
          VerifyOtpResponse value, $Res Function(VerifyOtpResponse) then) =
      _$VerifyOtpResponseCopyWithImpl<$Res, VerifyOtpResponse>;
  @useResult
  $Res call(
      {String message,
      bool isVerified,
      String? accessToken,
      String? refreshToken,
      User? user,
      String? nextStep});

  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class _$VerifyOtpResponseCopyWithImpl<$Res, $Val extends VerifyOtpResponse>
    implements $VerifyOtpResponseCopyWith<$Res> {
  _$VerifyOtpResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? isVerified = null,
    Object? accessToken = freezed,
    Object? refreshToken = freezed,
    Object? user = freezed,
    Object? nextStep = freezed,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      nextStep: freezed == nextStep
          ? _value.nextStep
          : nextStep // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VerifyOtpResponseImplCopyWith<$Res>
    implements $VerifyOtpResponseCopyWith<$Res> {
  factory _$$VerifyOtpResponseImplCopyWith(_$VerifyOtpResponseImpl value,
          $Res Function(_$VerifyOtpResponseImpl) then) =
      __$$VerifyOtpResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String message,
      bool isVerified,
      String? accessToken,
      String? refreshToken,
      User? user,
      String? nextStep});

  @override
  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class __$$VerifyOtpResponseImplCopyWithImpl<$Res>
    extends _$VerifyOtpResponseCopyWithImpl<$Res, _$VerifyOtpResponseImpl>
    implements _$$VerifyOtpResponseImplCopyWith<$Res> {
  __$$VerifyOtpResponseImplCopyWithImpl(_$VerifyOtpResponseImpl _value,
      $Res Function(_$VerifyOtpResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? isVerified = null,
    Object? accessToken = freezed,
    Object? refreshToken = freezed,
    Object? user = freezed,
    Object? nextStep = freezed,
  }) {
    return _then(_$VerifyOtpResponseImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      nextStep: freezed == nextStep
          ? _value.nextStep
          : nextStep // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerifyOtpResponseImpl implements _VerifyOtpResponse {
  const _$VerifyOtpResponseImpl(
      {required this.message,
      required this.isVerified,
      this.accessToken,
      this.refreshToken,
      this.user,
      this.nextStep});

  factory _$VerifyOtpResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerifyOtpResponseImplFromJson(json);

  @override
  final String message;
  @override
  final bool isVerified;
  @override
  final String? accessToken;
  @override
  final String? refreshToken;
  @override
  final User? user;
  @override
  final String? nextStep;

  @override
  String toString() {
    return 'VerifyOtpResponse(message: $message, isVerified: $isVerified, accessToken: $accessToken, refreshToken: $refreshToken, user: $user, nextStep: $nextStep)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyOtpResponseImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.nextStep, nextStep) ||
                other.nextStep == nextStep));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message, isVerified, accessToken,
      refreshToken, user, nextStep);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyOtpResponseImplCopyWith<_$VerifyOtpResponseImpl> get copyWith =>
      __$$VerifyOtpResponseImplCopyWithImpl<_$VerifyOtpResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerifyOtpResponseImplToJson(
      this,
    );
  }
}

abstract class _VerifyOtpResponse implements VerifyOtpResponse {
  const factory _VerifyOtpResponse(
      {required final String message,
      required final bool isVerified,
      final String? accessToken,
      final String? refreshToken,
      final User? user,
      final String? nextStep}) = _$VerifyOtpResponseImpl;

  factory _VerifyOtpResponse.fromJson(Map<String, dynamic> json) =
      _$VerifyOtpResponseImpl.fromJson;

  @override
  String get message;
  @override
  bool get isVerified;
  @override
  String? get accessToken;
  @override
  String? get refreshToken;
  @override
  User? get user;
  @override
  String? get nextStep;
  @override
  @JsonKey(ignore: true)
  _$$VerifyOtpResponseImplCopyWith<_$VerifyOtpResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ResendOtpRequest _$ResendOtpRequestFromJson(Map<String, dynamic> json) {
  return _ResendOtpRequest.fromJson(json);
}

/// @nodoc
mixin _$ResendOtpRequest {
  String get token => throw _privateConstructorUsedError;
  OtpType get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ResendOtpRequestCopyWith<ResendOtpRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResendOtpRequestCopyWith<$Res> {
  factory $ResendOtpRequestCopyWith(
          ResendOtpRequest value, $Res Function(ResendOtpRequest) then) =
      _$ResendOtpRequestCopyWithImpl<$Res, ResendOtpRequest>;
  @useResult
  $Res call({String token, OtpType type});
}

/// @nodoc
class _$ResendOtpRequestCopyWithImpl<$Res, $Val extends ResendOtpRequest>
    implements $ResendOtpRequestCopyWith<$Res> {
  _$ResendOtpRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as OtpType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResendOtpRequestImplCopyWith<$Res>
    implements $ResendOtpRequestCopyWith<$Res> {
  factory _$$ResendOtpRequestImplCopyWith(_$ResendOtpRequestImpl value,
          $Res Function(_$ResendOtpRequestImpl) then) =
      __$$ResendOtpRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String token, OtpType type});
}

/// @nodoc
class __$$ResendOtpRequestImplCopyWithImpl<$Res>
    extends _$ResendOtpRequestCopyWithImpl<$Res, _$ResendOtpRequestImpl>
    implements _$$ResendOtpRequestImplCopyWith<$Res> {
  __$$ResendOtpRequestImplCopyWithImpl(_$ResendOtpRequestImpl _value,
      $Res Function(_$ResendOtpRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? type = null,
  }) {
    return _then(_$ResendOtpRequestImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as OtpType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResendOtpRequestImpl implements _ResendOtpRequest {
  const _$ResendOtpRequestImpl({required this.token, required this.type});

  factory _$ResendOtpRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResendOtpRequestImplFromJson(json);

  @override
  final String token;
  @override
  final OtpType type;

  @override
  String toString() {
    return 'ResendOtpRequest(token: $token, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResendOtpRequestImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, token, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ResendOtpRequestImplCopyWith<_$ResendOtpRequestImpl> get copyWith =>
      __$$ResendOtpRequestImplCopyWithImpl<_$ResendOtpRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResendOtpRequestImplToJson(
      this,
    );
  }
}

abstract class _ResendOtpRequest implements ResendOtpRequest {
  const factory _ResendOtpRequest(
      {required final String token,
      required final OtpType type}) = _$ResendOtpRequestImpl;

  factory _ResendOtpRequest.fromJson(Map<String, dynamic> json) =
      _$ResendOtpRequestImpl.fromJson;

  @override
  String get token;
  @override
  OtpType get type;
  @override
  @JsonKey(ignore: true)
  _$$ResendOtpRequestImplCopyWith<_$ResendOtpRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChangePasswordRequest _$ChangePasswordRequestFromJson(
    Map<String, dynamic> json) {
  return _ChangePasswordRequest.fromJson(json);
}

/// @nodoc
mixin _$ChangePasswordRequest {
  String get currentPassword => throw _privateConstructorUsedError;
  String get newPassword => throw _privateConstructorUsedError;
  String get confirmPassword => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChangePasswordRequestCopyWith<ChangePasswordRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChangePasswordRequestCopyWith<$Res> {
  factory $ChangePasswordRequestCopyWith(ChangePasswordRequest value,
          $Res Function(ChangePasswordRequest) then) =
      _$ChangePasswordRequestCopyWithImpl<$Res, ChangePasswordRequest>;
  @useResult
  $Res call(
      {String currentPassword, String newPassword, String confirmPassword});
}

/// @nodoc
class _$ChangePasswordRequestCopyWithImpl<$Res,
        $Val extends ChangePasswordRequest>
    implements $ChangePasswordRequestCopyWith<$Res> {
  _$ChangePasswordRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPassword = null,
    Object? newPassword = null,
    Object? confirmPassword = null,
  }) {
    return _then(_value.copyWith(
      currentPassword: null == currentPassword
          ? _value.currentPassword
          : currentPassword // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
      confirmPassword: null == confirmPassword
          ? _value.confirmPassword
          : confirmPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChangePasswordRequestImplCopyWith<$Res>
    implements $ChangePasswordRequestCopyWith<$Res> {
  factory _$$ChangePasswordRequestImplCopyWith(
          _$ChangePasswordRequestImpl value,
          $Res Function(_$ChangePasswordRequestImpl) then) =
      __$$ChangePasswordRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String currentPassword, String newPassword, String confirmPassword});
}

/// @nodoc
class __$$ChangePasswordRequestImplCopyWithImpl<$Res>
    extends _$ChangePasswordRequestCopyWithImpl<$Res,
        _$ChangePasswordRequestImpl>
    implements _$$ChangePasswordRequestImplCopyWith<$Res> {
  __$$ChangePasswordRequestImplCopyWithImpl(_$ChangePasswordRequestImpl _value,
      $Res Function(_$ChangePasswordRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPassword = null,
    Object? newPassword = null,
    Object? confirmPassword = null,
  }) {
    return _then(_$ChangePasswordRequestImpl(
      currentPassword: null == currentPassword
          ? _value.currentPassword
          : currentPassword // ignore: cast_nullable_to_non_nullable
              as String,
      newPassword: null == newPassword
          ? _value.newPassword
          : newPassword // ignore: cast_nullable_to_non_nullable
              as String,
      confirmPassword: null == confirmPassword
          ? _value.confirmPassword
          : confirmPassword // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChangePasswordRequestImpl implements _ChangePasswordRequest {
  const _$ChangePasswordRequestImpl(
      {required this.currentPassword,
      required this.newPassword,
      required this.confirmPassword});

  factory _$ChangePasswordRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChangePasswordRequestImplFromJson(json);

  @override
  final String currentPassword;
  @override
  final String newPassword;
  @override
  final String confirmPassword;

  @override
  String toString() {
    return 'ChangePasswordRequest(currentPassword: $currentPassword, newPassword: $newPassword, confirmPassword: $confirmPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangePasswordRequestImpl &&
            (identical(other.currentPassword, currentPassword) ||
                other.currentPassword == currentPassword) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword) &&
            (identical(other.confirmPassword, confirmPassword) ||
                other.confirmPassword == confirmPassword));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, currentPassword, newPassword, confirmPassword);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangePasswordRequestImplCopyWith<_$ChangePasswordRequestImpl>
      get copyWith => __$$ChangePasswordRequestImplCopyWithImpl<
          _$ChangePasswordRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChangePasswordRequestImplToJson(
      this,
    );
  }
}

abstract class _ChangePasswordRequest implements ChangePasswordRequest {
  const factory _ChangePasswordRequest(
      {required final String currentPassword,
      required final String newPassword,
      required final String confirmPassword}) = _$ChangePasswordRequestImpl;

  factory _ChangePasswordRequest.fromJson(Map<String, dynamic> json) =
      _$ChangePasswordRequestImpl.fromJson;

  @override
  String get currentPassword;
  @override
  String get newPassword;
  @override
  String get confirmPassword;
  @override
  @JsonKey(ignore: true)
  _$$ChangePasswordRequestImplCopyWith<_$ChangePasswordRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

BiometricAuthRequest _$BiometricAuthRequestFromJson(Map<String, dynamic> json) {
  return _BiometricAuthRequest.fromJson(json);
}

/// @nodoc
mixin _$BiometricAuthRequest {
  String get userId => throw _privateConstructorUsedError;
  String get biometricSignature => throw _privateConstructorUsedError;
  String get deviceId => throw _privateConstructorUsedError;
  String? get biometricType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BiometricAuthRequestCopyWith<BiometricAuthRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BiometricAuthRequestCopyWith<$Res> {
  factory $BiometricAuthRequestCopyWith(BiometricAuthRequest value,
          $Res Function(BiometricAuthRequest) then) =
      _$BiometricAuthRequestCopyWithImpl<$Res, BiometricAuthRequest>;
  @useResult
  $Res call(
      {String userId,
      String biometricSignature,
      String deviceId,
      String? biometricType});
}

/// @nodoc
class _$BiometricAuthRequestCopyWithImpl<$Res,
        $Val extends BiometricAuthRequest>
    implements $BiometricAuthRequestCopyWith<$Res> {
  _$BiometricAuthRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? biometricSignature = null,
    Object? deviceId = null,
    Object? biometricType = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      biometricSignature: null == biometricSignature
          ? _value.biometricSignature
          : biometricSignature // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      biometricType: freezed == biometricType
          ? _value.biometricType
          : biometricType // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BiometricAuthRequestImplCopyWith<$Res>
    implements $BiometricAuthRequestCopyWith<$Res> {
  factory _$$BiometricAuthRequestImplCopyWith(_$BiometricAuthRequestImpl value,
          $Res Function(_$BiometricAuthRequestImpl) then) =
      __$$BiometricAuthRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String biometricSignature,
      String deviceId,
      String? biometricType});
}

/// @nodoc
class __$$BiometricAuthRequestImplCopyWithImpl<$Res>
    extends _$BiometricAuthRequestCopyWithImpl<$Res, _$BiometricAuthRequestImpl>
    implements _$$BiometricAuthRequestImplCopyWith<$Res> {
  __$$BiometricAuthRequestImplCopyWithImpl(_$BiometricAuthRequestImpl _value,
      $Res Function(_$BiometricAuthRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? biometricSignature = null,
    Object? deviceId = null,
    Object? biometricType = freezed,
  }) {
    return _then(_$BiometricAuthRequestImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      biometricSignature: null == biometricSignature
          ? _value.biometricSignature
          : biometricSignature // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      biometricType: freezed == biometricType
          ? _value.biometricType
          : biometricType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BiometricAuthRequestImpl implements _BiometricAuthRequest {
  const _$BiometricAuthRequestImpl(
      {required this.userId,
      required this.biometricSignature,
      required this.deviceId,
      this.biometricType});

  factory _$BiometricAuthRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$BiometricAuthRequestImplFromJson(json);

  @override
  final String userId;
  @override
  final String biometricSignature;
  @override
  final String deviceId;
  @override
  final String? biometricType;

  @override
  String toString() {
    return 'BiometricAuthRequest(userId: $userId, biometricSignature: $biometricSignature, deviceId: $deviceId, biometricType: $biometricType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BiometricAuthRequestImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.biometricSignature, biometricSignature) ||
                other.biometricSignature == biometricSignature) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.biometricType, biometricType) ||
                other.biometricType == biometricType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, userId, biometricSignature, deviceId, biometricType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BiometricAuthRequestImplCopyWith<_$BiometricAuthRequestImpl>
      get copyWith =>
          __$$BiometricAuthRequestImplCopyWithImpl<_$BiometricAuthRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BiometricAuthRequestImplToJson(
      this,
    );
  }
}

abstract class _BiometricAuthRequest implements BiometricAuthRequest {
  const factory _BiometricAuthRequest(
      {required final String userId,
      required final String biometricSignature,
      required final String deviceId,
      final String? biometricType}) = _$BiometricAuthRequestImpl;

  factory _BiometricAuthRequest.fromJson(Map<String, dynamic> json) =
      _$BiometricAuthRequestImpl.fromJson;

  @override
  String get userId;
  @override
  String get biometricSignature;
  @override
  String get deviceId;
  @override
  String? get biometricType;
  @override
  @JsonKey(ignore: true)
  _$$BiometricAuthRequestImplCopyWith<_$BiometricAuthRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TwoFactorAuthRequest _$TwoFactorAuthRequestFromJson(Map<String, dynamic> json) {
  return _TwoFactorAuthRequest.fromJson(json);
}

/// @nodoc
mixin _$TwoFactorAuthRequest {
  String get token => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  TwoFactorMethod get method => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TwoFactorAuthRequestCopyWith<TwoFactorAuthRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TwoFactorAuthRequestCopyWith<$Res> {
  factory $TwoFactorAuthRequestCopyWith(TwoFactorAuthRequest value,
          $Res Function(TwoFactorAuthRequest) then) =
      _$TwoFactorAuthRequestCopyWithImpl<$Res, TwoFactorAuthRequest>;
  @useResult
  $Res call({String token, String code, TwoFactorMethod method});
}

/// @nodoc
class _$TwoFactorAuthRequestCopyWithImpl<$Res,
        $Val extends TwoFactorAuthRequest>
    implements $TwoFactorAuthRequestCopyWith<$Res> {
  _$TwoFactorAuthRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? code = null,
    Object? method = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as TwoFactorMethod,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TwoFactorAuthRequestImplCopyWith<$Res>
    implements $TwoFactorAuthRequestCopyWith<$Res> {
  factory _$$TwoFactorAuthRequestImplCopyWith(_$TwoFactorAuthRequestImpl value,
          $Res Function(_$TwoFactorAuthRequestImpl) then) =
      __$$TwoFactorAuthRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String token, String code, TwoFactorMethod method});
}

/// @nodoc
class __$$TwoFactorAuthRequestImplCopyWithImpl<$Res>
    extends _$TwoFactorAuthRequestCopyWithImpl<$Res, _$TwoFactorAuthRequestImpl>
    implements _$$TwoFactorAuthRequestImplCopyWith<$Res> {
  __$$TwoFactorAuthRequestImplCopyWithImpl(_$TwoFactorAuthRequestImpl _value,
      $Res Function(_$TwoFactorAuthRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? code = null,
    Object? method = null,
  }) {
    return _then(_$TwoFactorAuthRequestImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as TwoFactorMethod,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TwoFactorAuthRequestImpl implements _TwoFactorAuthRequest {
  const _$TwoFactorAuthRequestImpl(
      {required this.token, required this.code, required this.method});

  factory _$TwoFactorAuthRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$TwoFactorAuthRequestImplFromJson(json);

  @override
  final String token;
  @override
  final String code;
  @override
  final TwoFactorMethod method;

  @override
  String toString() {
    return 'TwoFactorAuthRequest(token: $token, code: $code, method: $method)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TwoFactorAuthRequestImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.method, method) || other.method == method));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, token, code, method);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TwoFactorAuthRequestImplCopyWith<_$TwoFactorAuthRequestImpl>
      get copyWith =>
          __$$TwoFactorAuthRequestImplCopyWithImpl<_$TwoFactorAuthRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TwoFactorAuthRequestImplToJson(
      this,
    );
  }
}

abstract class _TwoFactorAuthRequest implements TwoFactorAuthRequest {
  const factory _TwoFactorAuthRequest(
      {required final String token,
      required final String code,
      required final TwoFactorMethod method}) = _$TwoFactorAuthRequestImpl;

  factory _TwoFactorAuthRequest.fromJson(Map<String, dynamic> json) =
      _$TwoFactorAuthRequestImpl.fromJson;

  @override
  String get token;
  @override
  String get code;
  @override
  TwoFactorMethod get method;
  @override
  @JsonKey(ignore: true)
  _$$TwoFactorAuthRequestImplCopyWith<_$TwoFactorAuthRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

RefreshTokenRequest _$RefreshTokenRequestFromJson(Map<String, dynamic> json) {
  return _RefreshTokenRequest.fromJson(json);
}

/// @nodoc
mixin _$RefreshTokenRequest {
  String get refreshToken => throw _privateConstructorUsedError;
  String? get deviceId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RefreshTokenRequestCopyWith<RefreshTokenRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefreshTokenRequestCopyWith<$Res> {
  factory $RefreshTokenRequestCopyWith(
          RefreshTokenRequest value, $Res Function(RefreshTokenRequest) then) =
      _$RefreshTokenRequestCopyWithImpl<$Res, RefreshTokenRequest>;
  @useResult
  $Res call({String refreshToken, String? deviceId});
}

/// @nodoc
class _$RefreshTokenRequestCopyWithImpl<$Res, $Val extends RefreshTokenRequest>
    implements $RefreshTokenRequestCopyWith<$Res> {
  _$RefreshTokenRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? refreshToken = null,
    Object? deviceId = freezed,
  }) {
    return _then(_value.copyWith(
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RefreshTokenRequestImplCopyWith<$Res>
    implements $RefreshTokenRequestCopyWith<$Res> {
  factory _$$RefreshTokenRequestImplCopyWith(_$RefreshTokenRequestImpl value,
          $Res Function(_$RefreshTokenRequestImpl) then) =
      __$$RefreshTokenRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String refreshToken, String? deviceId});
}

/// @nodoc
class __$$RefreshTokenRequestImplCopyWithImpl<$Res>
    extends _$RefreshTokenRequestCopyWithImpl<$Res, _$RefreshTokenRequestImpl>
    implements _$$RefreshTokenRequestImplCopyWith<$Res> {
  __$$RefreshTokenRequestImplCopyWithImpl(_$RefreshTokenRequestImpl _value,
      $Res Function(_$RefreshTokenRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? refreshToken = null,
    Object? deviceId = freezed,
  }) {
    return _then(_$RefreshTokenRequestImpl(
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RefreshTokenRequestImpl implements _RefreshTokenRequest {
  const _$RefreshTokenRequestImpl({required this.refreshToken, this.deviceId});

  factory _$RefreshTokenRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefreshTokenRequestImplFromJson(json);

  @override
  final String refreshToken;
  @override
  final String? deviceId;

  @override
  String toString() {
    return 'RefreshTokenRequest(refreshToken: $refreshToken, deviceId: $deviceId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefreshTokenRequestImpl &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, refreshToken, deviceId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RefreshTokenRequestImplCopyWith<_$RefreshTokenRequestImpl> get copyWith =>
      __$$RefreshTokenRequestImplCopyWithImpl<_$RefreshTokenRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RefreshTokenRequestImplToJson(
      this,
    );
  }
}

abstract class _RefreshTokenRequest implements RefreshTokenRequest {
  const factory _RefreshTokenRequest(
      {required final String refreshToken,
      final String? deviceId}) = _$RefreshTokenRequestImpl;

  factory _RefreshTokenRequest.fromJson(Map<String, dynamic> json) =
      _$RefreshTokenRequestImpl.fromJson;

  @override
  String get refreshToken;
  @override
  String? get deviceId;
  @override
  @JsonKey(ignore: true)
  _$$RefreshTokenRequestImplCopyWith<_$RefreshTokenRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RefreshTokenResponse _$RefreshTokenResponseFromJson(Map<String, dynamic> json) {
  return _RefreshTokenResponse.fromJson(json);
}

/// @nodoc
mixin _$RefreshTokenResponse {
  String get accessToken => throw _privateConstructorUsedError;
  String get refreshToken => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RefreshTokenResponseCopyWith<RefreshTokenResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefreshTokenResponseCopyWith<$Res> {
  factory $RefreshTokenResponseCopyWith(RefreshTokenResponse value,
          $Res Function(RefreshTokenResponse) then) =
      _$RefreshTokenResponseCopyWithImpl<$Res, RefreshTokenResponse>;
  @useResult
  $Res call(
      {String accessToken,
      String refreshToken,
      DateTime expiresAt,
      User? user});

  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class _$RefreshTokenResponseCopyWithImpl<$Res,
        $Val extends RefreshTokenResponse>
    implements $RefreshTokenResponseCopyWith<$Res> {
  _$RefreshTokenResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? expiresAt = null,
    Object? user = freezed,
  }) {
    return _then(_value.copyWith(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RefreshTokenResponseImplCopyWith<$Res>
    implements $RefreshTokenResponseCopyWith<$Res> {
  factory _$$RefreshTokenResponseImplCopyWith(_$RefreshTokenResponseImpl value,
          $Res Function(_$RefreshTokenResponseImpl) then) =
      __$$RefreshTokenResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String accessToken,
      String refreshToken,
      DateTime expiresAt,
      User? user});

  @override
  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class __$$RefreshTokenResponseImplCopyWithImpl<$Res>
    extends _$RefreshTokenResponseCopyWithImpl<$Res, _$RefreshTokenResponseImpl>
    implements _$$RefreshTokenResponseImplCopyWith<$Res> {
  __$$RefreshTokenResponseImplCopyWithImpl(_$RefreshTokenResponseImpl _value,
      $Res Function(_$RefreshTokenResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? expiresAt = null,
    Object? user = freezed,
  }) {
    return _then(_$RefreshTokenResponseImpl(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RefreshTokenResponseImpl implements _RefreshTokenResponse {
  const _$RefreshTokenResponseImpl(
      {required this.accessToken,
      required this.refreshToken,
      required this.expiresAt,
      this.user});

  factory _$RefreshTokenResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefreshTokenResponseImplFromJson(json);

  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  final DateTime expiresAt;
  @override
  final User? user;

  @override
  String toString() {
    return 'RefreshTokenResponse(accessToken: $accessToken, refreshToken: $refreshToken, expiresAt: $expiresAt, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefreshTokenResponseImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, accessToken, refreshToken, expiresAt, user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RefreshTokenResponseImplCopyWith<_$RefreshTokenResponseImpl>
      get copyWith =>
          __$$RefreshTokenResponseImplCopyWithImpl<_$RefreshTokenResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RefreshTokenResponseImplToJson(
      this,
    );
  }
}

abstract class _RefreshTokenResponse implements RefreshTokenResponse {
  const factory _RefreshTokenResponse(
      {required final String accessToken,
      required final String refreshToken,
      required final DateTime expiresAt,
      final User? user}) = _$RefreshTokenResponseImpl;

  factory _RefreshTokenResponse.fromJson(Map<String, dynamic> json) =
      _$RefreshTokenResponseImpl.fromJson;

  @override
  String get accessToken;
  @override
  String get refreshToken;
  @override
  DateTime get expiresAt;
  @override
  User? get user;
  @override
  @JsonKey(ignore: true)
  _$$RefreshTokenResponseImplCopyWith<_$RefreshTokenResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

LogoutRequest _$LogoutRequestFromJson(Map<String, dynamic> json) {
  return _LogoutRequest.fromJson(json);
}

/// @nodoc
mixin _$LogoutRequest {
  String? get deviceId => throw _privateConstructorUsedError;
  bool? get logoutAllDevices => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LogoutRequestCopyWith<LogoutRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogoutRequestCopyWith<$Res> {
  factory $LogoutRequestCopyWith(
          LogoutRequest value, $Res Function(LogoutRequest) then) =
      _$LogoutRequestCopyWithImpl<$Res, LogoutRequest>;
  @useResult
  $Res call({String? deviceId, bool? logoutAllDevices});
}

/// @nodoc
class _$LogoutRequestCopyWithImpl<$Res, $Val extends LogoutRequest>
    implements $LogoutRequestCopyWith<$Res> {
  _$LogoutRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = freezed,
    Object? logoutAllDevices = freezed,
  }) {
    return _then(_value.copyWith(
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      logoutAllDevices: freezed == logoutAllDevices
          ? _value.logoutAllDevices
          : logoutAllDevices // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LogoutRequestImplCopyWith<$Res>
    implements $LogoutRequestCopyWith<$Res> {
  factory _$$LogoutRequestImplCopyWith(
          _$LogoutRequestImpl value, $Res Function(_$LogoutRequestImpl) then) =
      __$$LogoutRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? deviceId, bool? logoutAllDevices});
}

/// @nodoc
class __$$LogoutRequestImplCopyWithImpl<$Res>
    extends _$LogoutRequestCopyWithImpl<$Res, _$LogoutRequestImpl>
    implements _$$LogoutRequestImplCopyWith<$Res> {
  __$$LogoutRequestImplCopyWithImpl(
      _$LogoutRequestImpl _value, $Res Function(_$LogoutRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = freezed,
    Object? logoutAllDevices = freezed,
  }) {
    return _then(_$LogoutRequestImpl(
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      logoutAllDevices: freezed == logoutAllDevices
          ? _value.logoutAllDevices
          : logoutAllDevices // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LogoutRequestImpl implements _LogoutRequest {
  const _$LogoutRequestImpl({this.deviceId, this.logoutAllDevices});

  factory _$LogoutRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$LogoutRequestImplFromJson(json);

  @override
  final String? deviceId;
  @override
  final bool? logoutAllDevices;

  @override
  String toString() {
    return 'LogoutRequest(deviceId: $deviceId, logoutAllDevices: $logoutAllDevices)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogoutRequestImpl &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.logoutAllDevices, logoutAllDevices) ||
                other.logoutAllDevices == logoutAllDevices));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, deviceId, logoutAllDevices);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LogoutRequestImplCopyWith<_$LogoutRequestImpl> get copyWith =>
      __$$LogoutRequestImplCopyWithImpl<_$LogoutRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LogoutRequestImplToJson(
      this,
    );
  }
}

abstract class _LogoutRequest implements LogoutRequest {
  const factory _LogoutRequest(
      {final String? deviceId,
      final bool? logoutAllDevices}) = _$LogoutRequestImpl;

  factory _LogoutRequest.fromJson(Map<String, dynamic> json) =
      _$LogoutRequestImpl.fromJson;

  @override
  String? get deviceId;
  @override
  bool? get logoutAllDevices;
  @override
  @JsonKey(ignore: true)
  _$$LogoutRequestImplCopyWith<_$LogoutRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) {
  return _DeviceInfo.fromJson(json);
}

/// @nodoc
mixin _$DeviceInfo {
  String get deviceId => throw _privateConstructorUsedError;
  String get deviceName => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;
  String get osVersion => throw _privateConstructorUsedError;
  String get appVersion => throw _privateConstructorUsedError;
  String? get model => throw _privateConstructorUsedError;
  String? get manufacturer => throw _privateConstructorUsedError;
  String? get fcmToken => throw _privateConstructorUsedError;
  DateTime? get lastActiveAt => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DeviceInfoCopyWith<DeviceInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceInfoCopyWith<$Res> {
  factory $DeviceInfoCopyWith(
          DeviceInfo value, $Res Function(DeviceInfo) then) =
      _$DeviceInfoCopyWithImpl<$Res, DeviceInfo>;
  @useResult
  $Res call(
      {String deviceId,
      String deviceName,
      String platform,
      String osVersion,
      String appVersion,
      String? model,
      String? manufacturer,
      String? fcmToken,
      DateTime? lastActiveAt,
      bool? isActive});
}

/// @nodoc
class _$DeviceInfoCopyWithImpl<$Res, $Val extends DeviceInfo>
    implements $DeviceInfoCopyWith<$Res> {
  _$DeviceInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? deviceName = null,
    Object? platform = null,
    Object? osVersion = null,
    Object? appVersion = null,
    Object? model = freezed,
    Object? manufacturer = freezed,
    Object? fcmToken = freezed,
    Object? lastActiveAt = freezed,
    Object? isActive = freezed,
  }) {
    return _then(_value.copyWith(
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      deviceName: null == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
      osVersion: null == osVersion
          ? _value.osVersion
          : osVersion // ignore: cast_nullable_to_non_nullable
              as String,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      manufacturer: freezed == manufacturer
          ? _value.manufacturer
          : manufacturer // ignore: cast_nullable_to_non_nullable
              as String?,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
      lastActiveAt: freezed == lastActiveAt
          ? _value.lastActiveAt
          : lastActiveAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeviceInfoImplCopyWith<$Res>
    implements $DeviceInfoCopyWith<$Res> {
  factory _$$DeviceInfoImplCopyWith(
          _$DeviceInfoImpl value, $Res Function(_$DeviceInfoImpl) then) =
      __$$DeviceInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String deviceId,
      String deviceName,
      String platform,
      String osVersion,
      String appVersion,
      String? model,
      String? manufacturer,
      String? fcmToken,
      DateTime? lastActiveAt,
      bool? isActive});
}

/// @nodoc
class __$$DeviceInfoImplCopyWithImpl<$Res>
    extends _$DeviceInfoCopyWithImpl<$Res, _$DeviceInfoImpl>
    implements _$$DeviceInfoImplCopyWith<$Res> {
  __$$DeviceInfoImplCopyWithImpl(
      _$DeviceInfoImpl _value, $Res Function(_$DeviceInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? deviceName = null,
    Object? platform = null,
    Object? osVersion = null,
    Object? appVersion = null,
    Object? model = freezed,
    Object? manufacturer = freezed,
    Object? fcmToken = freezed,
    Object? lastActiveAt = freezed,
    Object? isActive = freezed,
  }) {
    return _then(_$DeviceInfoImpl(
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      deviceName: null == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
      osVersion: null == osVersion
          ? _value.osVersion
          : osVersion // ignore: cast_nullable_to_non_nullable
              as String,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      manufacturer: freezed == manufacturer
          ? _value.manufacturer
          : manufacturer // ignore: cast_nullable_to_non_nullable
              as String?,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
      lastActiveAt: freezed == lastActiveAt
          ? _value.lastActiveAt
          : lastActiveAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeviceInfoImpl implements _DeviceInfo {
  const _$DeviceInfoImpl(
      {required this.deviceId,
      required this.deviceName,
      required this.platform,
      required this.osVersion,
      required this.appVersion,
      this.model,
      this.manufacturer,
      this.fcmToken,
      this.lastActiveAt,
      this.isActive});

  factory _$DeviceInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeviceInfoImplFromJson(json);

  @override
  final String deviceId;
  @override
  final String deviceName;
  @override
  final String platform;
  @override
  final String osVersion;
  @override
  final String appVersion;
  @override
  final String? model;
  @override
  final String? manufacturer;
  @override
  final String? fcmToken;
  @override
  final DateTime? lastActiveAt;
  @override
  final bool? isActive;

  @override
  String toString() {
    return 'DeviceInfo(deviceId: $deviceId, deviceName: $deviceName, platform: $platform, osVersion: $osVersion, appVersion: $appVersion, model: $model, manufacturer: $manufacturer, fcmToken: $fcmToken, lastActiveAt: $lastActiveAt, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceInfoImpl &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.deviceName, deviceName) ||
                other.deviceName == deviceName) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.osVersion, osVersion) ||
                other.osVersion == osVersion) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.manufacturer, manufacturer) ||
                other.manufacturer == manufacturer) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken) &&
            (identical(other.lastActiveAt, lastActiveAt) ||
                other.lastActiveAt == lastActiveAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      deviceId,
      deviceName,
      platform,
      osVersion,
      appVersion,
      model,
      manufacturer,
      fcmToken,
      lastActiveAt,
      isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceInfoImplCopyWith<_$DeviceInfoImpl> get copyWith =>
      __$$DeviceInfoImplCopyWithImpl<_$DeviceInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeviceInfoImplToJson(
      this,
    );
  }
}

abstract class _DeviceInfo implements DeviceInfo {
  const factory _DeviceInfo(
      {required final String deviceId,
      required final String deviceName,
      required final String platform,
      required final String osVersion,
      required final String appVersion,
      final String? model,
      final String? manufacturer,
      final String? fcmToken,
      final DateTime? lastActiveAt,
      final bool? isActive}) = _$DeviceInfoImpl;

  factory _DeviceInfo.fromJson(Map<String, dynamic> json) =
      _$DeviceInfoImpl.fromJson;

  @override
  String get deviceId;
  @override
  String get deviceName;
  @override
  String get platform;
  @override
  String get osVersion;
  @override
  String get appVersion;
  @override
  String? get model;
  @override
  String? get manufacturer;
  @override
  String? get fcmToken;
  @override
  DateTime? get lastActiveAt;
  @override
  bool? get isActive;
  @override
  @JsonKey(ignore: true)
  _$$DeviceInfoImplCopyWith<_$DeviceInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SecuritySettings _$SecuritySettingsFromJson(Map<String, dynamic> json) {
  return _SecuritySettings.fromJson(json);
}

/// @nodoc
mixin _$SecuritySettings {
  bool get isTwoFactorEnabled => throw _privateConstructorUsedError;
  bool get isBiometricEnabled => throw _privateConstructorUsedError;
  bool get isEmailNotificationEnabled => throw _privateConstructorUsedError;
  bool get isSmsNotificationEnabled => throw _privateConstructorUsedError;
  bool get isPushNotificationEnabled => throw _privateConstructorUsedError;
  int get sessionTimeoutMinutes => throw _privateConstructorUsedError;
  int get maxLoginAttempts => throw _privateConstructorUsedError;
  int get lockoutDurationMinutes => throw _privateConstructorUsedError;
  List<String>? get trustedDevices => throw _privateConstructorUsedError;
  List<String>? get blockedDevices => throw _privateConstructorUsedError;
  DateTime? get lastPasswordChange => throw _privateConstructorUsedError;
  DateTime? get lastSecurityUpdate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SecuritySettingsCopyWith<SecuritySettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SecuritySettingsCopyWith<$Res> {
  factory $SecuritySettingsCopyWith(
          SecuritySettings value, $Res Function(SecuritySettings) then) =
      _$SecuritySettingsCopyWithImpl<$Res, SecuritySettings>;
  @useResult
  $Res call(
      {bool isTwoFactorEnabled,
      bool isBiometricEnabled,
      bool isEmailNotificationEnabled,
      bool isSmsNotificationEnabled,
      bool isPushNotificationEnabled,
      int sessionTimeoutMinutes,
      int maxLoginAttempts,
      int lockoutDurationMinutes,
      List<String>? trustedDevices,
      List<String>? blockedDevices,
      DateTime? lastPasswordChange,
      DateTime? lastSecurityUpdate});
}

/// @nodoc
class _$SecuritySettingsCopyWithImpl<$Res, $Val extends SecuritySettings>
    implements $SecuritySettingsCopyWith<$Res> {
  _$SecuritySettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isTwoFactorEnabled = null,
    Object? isBiometricEnabled = null,
    Object? isEmailNotificationEnabled = null,
    Object? isSmsNotificationEnabled = null,
    Object? isPushNotificationEnabled = null,
    Object? sessionTimeoutMinutes = null,
    Object? maxLoginAttempts = null,
    Object? lockoutDurationMinutes = null,
    Object? trustedDevices = freezed,
    Object? blockedDevices = freezed,
    Object? lastPasswordChange = freezed,
    Object? lastSecurityUpdate = freezed,
  }) {
    return _then(_value.copyWith(
      isTwoFactorEnabled: null == isTwoFactorEnabled
          ? _value.isTwoFactorEnabled
          : isTwoFactorEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isBiometricEnabled: null == isBiometricEnabled
          ? _value.isBiometricEnabled
          : isBiometricEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isEmailNotificationEnabled: null == isEmailNotificationEnabled
          ? _value.isEmailNotificationEnabled
          : isEmailNotificationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isSmsNotificationEnabled: null == isSmsNotificationEnabled
          ? _value.isSmsNotificationEnabled
          : isSmsNotificationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isPushNotificationEnabled: null == isPushNotificationEnabled
          ? _value.isPushNotificationEnabled
          : isPushNotificationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      sessionTimeoutMinutes: null == sessionTimeoutMinutes
          ? _value.sessionTimeoutMinutes
          : sessionTimeoutMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      maxLoginAttempts: null == maxLoginAttempts
          ? _value.maxLoginAttempts
          : maxLoginAttempts // ignore: cast_nullable_to_non_nullable
              as int,
      lockoutDurationMinutes: null == lockoutDurationMinutes
          ? _value.lockoutDurationMinutes
          : lockoutDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      trustedDevices: freezed == trustedDevices
          ? _value.trustedDevices
          : trustedDevices // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      blockedDevices: freezed == blockedDevices
          ? _value.blockedDevices
          : blockedDevices // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      lastPasswordChange: freezed == lastPasswordChange
          ? _value.lastPasswordChange
          : lastPasswordChange // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSecurityUpdate: freezed == lastSecurityUpdate
          ? _value.lastSecurityUpdate
          : lastSecurityUpdate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SecuritySettingsImplCopyWith<$Res>
    implements $SecuritySettingsCopyWith<$Res> {
  factory _$$SecuritySettingsImplCopyWith(_$SecuritySettingsImpl value,
          $Res Function(_$SecuritySettingsImpl) then) =
      __$$SecuritySettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isTwoFactorEnabled,
      bool isBiometricEnabled,
      bool isEmailNotificationEnabled,
      bool isSmsNotificationEnabled,
      bool isPushNotificationEnabled,
      int sessionTimeoutMinutes,
      int maxLoginAttempts,
      int lockoutDurationMinutes,
      List<String>? trustedDevices,
      List<String>? blockedDevices,
      DateTime? lastPasswordChange,
      DateTime? lastSecurityUpdate});
}

/// @nodoc
class __$$SecuritySettingsImplCopyWithImpl<$Res>
    extends _$SecuritySettingsCopyWithImpl<$Res, _$SecuritySettingsImpl>
    implements _$$SecuritySettingsImplCopyWith<$Res> {
  __$$SecuritySettingsImplCopyWithImpl(_$SecuritySettingsImpl _value,
      $Res Function(_$SecuritySettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isTwoFactorEnabled = null,
    Object? isBiometricEnabled = null,
    Object? isEmailNotificationEnabled = null,
    Object? isSmsNotificationEnabled = null,
    Object? isPushNotificationEnabled = null,
    Object? sessionTimeoutMinutes = null,
    Object? maxLoginAttempts = null,
    Object? lockoutDurationMinutes = null,
    Object? trustedDevices = freezed,
    Object? blockedDevices = freezed,
    Object? lastPasswordChange = freezed,
    Object? lastSecurityUpdate = freezed,
  }) {
    return _then(_$SecuritySettingsImpl(
      isTwoFactorEnabled: null == isTwoFactorEnabled
          ? _value.isTwoFactorEnabled
          : isTwoFactorEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isBiometricEnabled: null == isBiometricEnabled
          ? _value.isBiometricEnabled
          : isBiometricEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isEmailNotificationEnabled: null == isEmailNotificationEnabled
          ? _value.isEmailNotificationEnabled
          : isEmailNotificationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isSmsNotificationEnabled: null == isSmsNotificationEnabled
          ? _value.isSmsNotificationEnabled
          : isSmsNotificationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isPushNotificationEnabled: null == isPushNotificationEnabled
          ? _value.isPushNotificationEnabled
          : isPushNotificationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      sessionTimeoutMinutes: null == sessionTimeoutMinutes
          ? _value.sessionTimeoutMinutes
          : sessionTimeoutMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      maxLoginAttempts: null == maxLoginAttempts
          ? _value.maxLoginAttempts
          : maxLoginAttempts // ignore: cast_nullable_to_non_nullable
              as int,
      lockoutDurationMinutes: null == lockoutDurationMinutes
          ? _value.lockoutDurationMinutes
          : lockoutDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      trustedDevices: freezed == trustedDevices
          ? _value._trustedDevices
          : trustedDevices // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      blockedDevices: freezed == blockedDevices
          ? _value._blockedDevices
          : blockedDevices // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      lastPasswordChange: freezed == lastPasswordChange
          ? _value.lastPasswordChange
          : lastPasswordChange // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSecurityUpdate: freezed == lastSecurityUpdate
          ? _value.lastSecurityUpdate
          : lastSecurityUpdate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SecuritySettingsImpl implements _SecuritySettings {
  const _$SecuritySettingsImpl(
      {this.isTwoFactorEnabled = false,
      this.isBiometricEnabled = false,
      this.isEmailNotificationEnabled = false,
      this.isSmsNotificationEnabled = false,
      this.isPushNotificationEnabled = false,
      this.sessionTimeoutMinutes = 30,
      this.maxLoginAttempts = 5,
      this.lockoutDurationMinutes = 15,
      final List<String>? trustedDevices,
      final List<String>? blockedDevices,
      this.lastPasswordChange,
      this.lastSecurityUpdate})
      : _trustedDevices = trustedDevices,
        _blockedDevices = blockedDevices;

  factory _$SecuritySettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SecuritySettingsImplFromJson(json);

  @override
  @JsonKey()
  final bool isTwoFactorEnabled;
  @override
  @JsonKey()
  final bool isBiometricEnabled;
  @override
  @JsonKey()
  final bool isEmailNotificationEnabled;
  @override
  @JsonKey()
  final bool isSmsNotificationEnabled;
  @override
  @JsonKey()
  final bool isPushNotificationEnabled;
  @override
  @JsonKey()
  final int sessionTimeoutMinutes;
  @override
  @JsonKey()
  final int maxLoginAttempts;
  @override
  @JsonKey()
  final int lockoutDurationMinutes;
  final List<String>? _trustedDevices;
  @override
  List<String>? get trustedDevices {
    final value = _trustedDevices;
    if (value == null) return null;
    if (_trustedDevices is EqualUnmodifiableListView) return _trustedDevices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _blockedDevices;
  @override
  List<String>? get blockedDevices {
    final value = _blockedDevices;
    if (value == null) return null;
    if (_blockedDevices is EqualUnmodifiableListView) return _blockedDevices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? lastPasswordChange;
  @override
  final DateTime? lastSecurityUpdate;

  @override
  String toString() {
    return 'SecuritySettings(isTwoFactorEnabled: $isTwoFactorEnabled, isBiometricEnabled: $isBiometricEnabled, isEmailNotificationEnabled: $isEmailNotificationEnabled, isSmsNotificationEnabled: $isSmsNotificationEnabled, isPushNotificationEnabled: $isPushNotificationEnabled, sessionTimeoutMinutes: $sessionTimeoutMinutes, maxLoginAttempts: $maxLoginAttempts, lockoutDurationMinutes: $lockoutDurationMinutes, trustedDevices: $trustedDevices, blockedDevices: $blockedDevices, lastPasswordChange: $lastPasswordChange, lastSecurityUpdate: $lastSecurityUpdate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SecuritySettingsImpl &&
            (identical(other.isTwoFactorEnabled, isTwoFactorEnabled) ||
                other.isTwoFactorEnabled == isTwoFactorEnabled) &&
            (identical(other.isBiometricEnabled, isBiometricEnabled) ||
                other.isBiometricEnabled == isBiometricEnabled) &&
            (identical(other.isEmailNotificationEnabled,
                    isEmailNotificationEnabled) ||
                other.isEmailNotificationEnabled ==
                    isEmailNotificationEnabled) &&
            (identical(
                    other.isSmsNotificationEnabled, isSmsNotificationEnabled) ||
                other.isSmsNotificationEnabled == isSmsNotificationEnabled) &&
            (identical(other.isPushNotificationEnabled,
                    isPushNotificationEnabled) ||
                other.isPushNotificationEnabled == isPushNotificationEnabled) &&
            (identical(other.sessionTimeoutMinutes, sessionTimeoutMinutes) ||
                other.sessionTimeoutMinutes == sessionTimeoutMinutes) &&
            (identical(other.maxLoginAttempts, maxLoginAttempts) ||
                other.maxLoginAttempts == maxLoginAttempts) &&
            (identical(other.lockoutDurationMinutes, lockoutDurationMinutes) ||
                other.lockoutDurationMinutes == lockoutDurationMinutes) &&
            const DeepCollectionEquality()
                .equals(other._trustedDevices, _trustedDevices) &&
            const DeepCollectionEquality()
                .equals(other._blockedDevices, _blockedDevices) &&
            (identical(other.lastPasswordChange, lastPasswordChange) ||
                other.lastPasswordChange == lastPasswordChange) &&
            (identical(other.lastSecurityUpdate, lastSecurityUpdate) ||
                other.lastSecurityUpdate == lastSecurityUpdate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isTwoFactorEnabled,
      isBiometricEnabled,
      isEmailNotificationEnabled,
      isSmsNotificationEnabled,
      isPushNotificationEnabled,
      sessionTimeoutMinutes,
      maxLoginAttempts,
      lockoutDurationMinutes,
      const DeepCollectionEquality().hash(_trustedDevices),
      const DeepCollectionEquality().hash(_blockedDevices),
      lastPasswordChange,
      lastSecurityUpdate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SecuritySettingsImplCopyWith<_$SecuritySettingsImpl> get copyWith =>
      __$$SecuritySettingsImplCopyWithImpl<_$SecuritySettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SecuritySettingsImplToJson(
      this,
    );
  }
}

abstract class _SecuritySettings implements SecuritySettings {
  const factory _SecuritySettings(
      {final bool isTwoFactorEnabled,
      final bool isBiometricEnabled,
      final bool isEmailNotificationEnabled,
      final bool isSmsNotificationEnabled,
      final bool isPushNotificationEnabled,
      final int sessionTimeoutMinutes,
      final int maxLoginAttempts,
      final int lockoutDurationMinutes,
      final List<String>? trustedDevices,
      final List<String>? blockedDevices,
      final DateTime? lastPasswordChange,
      final DateTime? lastSecurityUpdate}) = _$SecuritySettingsImpl;

  factory _SecuritySettings.fromJson(Map<String, dynamic> json) =
      _$SecuritySettingsImpl.fromJson;

  @override
  bool get isTwoFactorEnabled;
  @override
  bool get isBiometricEnabled;
  @override
  bool get isEmailNotificationEnabled;
  @override
  bool get isSmsNotificationEnabled;
  @override
  bool get isPushNotificationEnabled;
  @override
  int get sessionTimeoutMinutes;
  @override
  int get maxLoginAttempts;
  @override
  int get lockoutDurationMinutes;
  @override
  List<String>? get trustedDevices;
  @override
  List<String>? get blockedDevices;
  @override
  DateTime? get lastPasswordChange;
  @override
  DateTime? get lastSecurityUpdate;
  @override
  @JsonKey(ignore: true)
  _$$SecuritySettingsImplCopyWith<_$SecuritySettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
