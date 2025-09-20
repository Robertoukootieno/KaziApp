// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AdminUser _$AdminUserFromJson(Map<String, dynamic> json) {
  return _AdminUser.fromJson(json);
}

/// @nodoc
mixin _$AdminUser {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get middleName => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get profilePicture => throw _privateConstructorUsedError;
  AdminRole get role => throw _privateConstructorUsedError;
  List<Permission> get permissions => throw _privateConstructorUsedError;
  UserStatus get status => throw _privateConstructorUsedError;
  bool get isEmailVerified => throw _privateConstructorUsedError;
  bool get isMfaEnabled => throw _privateConstructorUsedError;
  List<MfaMethod>? get mfaMethods => throw _privateConstructorUsedError;
  String? get department => throw _privateConstructorUsedError;
  String? get jobTitle => throw _privateConstructorUsedError;
  String? get employeeId => throw _privateConstructorUsedError;
  DateTime? get lastLoginAt => throw _privateConstructorUsedError;
  String? get lastLoginIp => throw _privateConstructorUsedError;
  int? get loginCount => throw _privateConstructorUsedError;
  DateTime? get passwordChangedAt => throw _privateConstructorUsedError;
  bool? get mustChangePassword => throw _privateConstructorUsedError;
  List<String>? get allowedIpRanges => throw _privateConstructorUsedError;
  Map<String, dynamic>? get preferences => throw _privateConstructorUsedError;
  Map<String, dynamic>? get settings => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  String? get updatedBy => throw _privateConstructorUsedError;
  DateTime? get suspendedAt => throw _privateConstructorUsedError;
  String? get suspendedBy => throw _privateConstructorUsedError;
  String? get suspensionReason => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AdminUserCopyWith<AdminUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminUserCopyWith<$Res> {
  factory $AdminUserCopyWith(AdminUser value, $Res Function(AdminUser) then) =
      _$AdminUserCopyWithImpl<$Res, AdminUser>;
  @useResult
  $Res call(
      {String id,
      String email,
      String firstName,
      String lastName,
      String? middleName,
      String? phoneNumber,
      String? profilePicture,
      AdminRole role,
      List<Permission> permissions,
      UserStatus status,
      bool isEmailVerified,
      bool isMfaEnabled,
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
      DateTime createdAt,
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy,
      DateTime? suspendedAt,
      String? suspendedBy,
      String? suspensionReason});
}

/// @nodoc
class _$AdminUserCopyWithImpl<$Res, $Val extends AdminUser>
    implements $AdminUserCopyWith<$Res> {
  _$AdminUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? middleName = freezed,
    Object? phoneNumber = freezed,
    Object? profilePicture = freezed,
    Object? role = null,
    Object? permissions = null,
    Object? status = null,
    Object? isEmailVerified = null,
    Object? isMfaEnabled = null,
    Object? mfaMethods = freezed,
    Object? department = freezed,
    Object? jobTitle = freezed,
    Object? employeeId = freezed,
    Object? lastLoginAt = freezed,
    Object? lastLoginIp = freezed,
    Object? loginCount = freezed,
    Object? passwordChangedAt = freezed,
    Object? mustChangePassword = freezed,
    Object? allowedIpRanges = freezed,
    Object? preferences = freezed,
    Object? settings = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
    Object? suspendedAt = freezed,
    Object? suspendedBy = freezed,
    Object? suspensionReason = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      middleName: freezed == middleName
          ? _value.middleName
          : middleName // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePicture: freezed == profilePicture
          ? _value.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as AdminRole,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<Permission>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UserStatus,
      isEmailVerified: null == isEmailVerified
          ? _value.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isMfaEnabled: null == isMfaEnabled
          ? _value.isMfaEnabled
          : isMfaEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      mfaMethods: freezed == mfaMethods
          ? _value.mfaMethods
          : mfaMethods // ignore: cast_nullable_to_non_nullable
              as List<MfaMethod>?,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      jobTitle: freezed == jobTitle
          ? _value.jobTitle
          : jobTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      employeeId: freezed == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastLoginIp: freezed == lastLoginIp
          ? _value.lastLoginIp
          : lastLoginIp // ignore: cast_nullable_to_non_nullable
              as String?,
      loginCount: freezed == loginCount
          ? _value.loginCount
          : loginCount // ignore: cast_nullable_to_non_nullable
              as int?,
      passwordChangedAt: freezed == passwordChangedAt
          ? _value.passwordChangedAt
          : passwordChangedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      mustChangePassword: freezed == mustChangePassword
          ? _value.mustChangePassword
          : mustChangePassword // ignore: cast_nullable_to_non_nullable
              as bool?,
      allowedIpRanges: freezed == allowedIpRanges
          ? _value.allowedIpRanges
          : allowedIpRanges // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      preferences: freezed == preferences
          ? _value.preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      suspendedAt: freezed == suspendedAt
          ? _value.suspendedAt
          : suspendedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      suspendedBy: freezed == suspendedBy
          ? _value.suspendedBy
          : suspendedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      suspensionReason: freezed == suspensionReason
          ? _value.suspensionReason
          : suspensionReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdminUserImplCopyWith<$Res>
    implements $AdminUserCopyWith<$Res> {
  factory _$$AdminUserImplCopyWith(
          _$AdminUserImpl value, $Res Function(_$AdminUserImpl) then) =
      __$$AdminUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String firstName,
      String lastName,
      String? middleName,
      String? phoneNumber,
      String? profilePicture,
      AdminRole role,
      List<Permission> permissions,
      UserStatus status,
      bool isEmailVerified,
      bool isMfaEnabled,
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
      DateTime createdAt,
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy,
      DateTime? suspendedAt,
      String? suspendedBy,
      String? suspensionReason});
}

/// @nodoc
class __$$AdminUserImplCopyWithImpl<$Res>
    extends _$AdminUserCopyWithImpl<$Res, _$AdminUserImpl>
    implements _$$AdminUserImplCopyWith<$Res> {
  __$$AdminUserImplCopyWithImpl(
      _$AdminUserImpl _value, $Res Function(_$AdminUserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? middleName = freezed,
    Object? phoneNumber = freezed,
    Object? profilePicture = freezed,
    Object? role = null,
    Object? permissions = null,
    Object? status = null,
    Object? isEmailVerified = null,
    Object? isMfaEnabled = null,
    Object? mfaMethods = freezed,
    Object? department = freezed,
    Object? jobTitle = freezed,
    Object? employeeId = freezed,
    Object? lastLoginAt = freezed,
    Object? lastLoginIp = freezed,
    Object? loginCount = freezed,
    Object? passwordChangedAt = freezed,
    Object? mustChangePassword = freezed,
    Object? allowedIpRanges = freezed,
    Object? preferences = freezed,
    Object? settings = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
    Object? suspendedAt = freezed,
    Object? suspendedBy = freezed,
    Object? suspensionReason = freezed,
  }) {
    return _then(_$AdminUserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      middleName: freezed == middleName
          ? _value.middleName
          : middleName // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePicture: freezed == profilePicture
          ? _value.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as AdminRole,
      permissions: null == permissions
          ? _value._permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<Permission>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UserStatus,
      isEmailVerified: null == isEmailVerified
          ? _value.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isMfaEnabled: null == isMfaEnabled
          ? _value.isMfaEnabled
          : isMfaEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      mfaMethods: freezed == mfaMethods
          ? _value._mfaMethods
          : mfaMethods // ignore: cast_nullable_to_non_nullable
              as List<MfaMethod>?,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      jobTitle: freezed == jobTitle
          ? _value.jobTitle
          : jobTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      employeeId: freezed == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastLoginIp: freezed == lastLoginIp
          ? _value.lastLoginIp
          : lastLoginIp // ignore: cast_nullable_to_non_nullable
              as String?,
      loginCount: freezed == loginCount
          ? _value.loginCount
          : loginCount // ignore: cast_nullable_to_non_nullable
              as int?,
      passwordChangedAt: freezed == passwordChangedAt
          ? _value.passwordChangedAt
          : passwordChangedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      mustChangePassword: freezed == mustChangePassword
          ? _value.mustChangePassword
          : mustChangePassword // ignore: cast_nullable_to_non_nullable
              as bool?,
      allowedIpRanges: freezed == allowedIpRanges
          ? _value._allowedIpRanges
          : allowedIpRanges // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      preferences: freezed == preferences
          ? _value._preferences
          : preferences // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      settings: freezed == settings
          ? _value._settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      suspendedAt: freezed == suspendedAt
          ? _value.suspendedAt
          : suspendedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      suspendedBy: freezed == suspendedBy
          ? _value.suspendedBy
          : suspendedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      suspensionReason: freezed == suspensionReason
          ? _value.suspensionReason
          : suspensionReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdminUserImpl implements _AdminUser {
  const _$AdminUserImpl(
      {required this.id,
      required this.email,
      required this.firstName,
      required this.lastName,
      this.middleName,
      this.phoneNumber,
      this.profilePicture,
      required this.role,
      required final List<Permission> permissions,
      required this.status,
      required this.isEmailVerified,
      required this.isMfaEnabled,
      final List<MfaMethod>? mfaMethods,
      this.department,
      this.jobTitle,
      this.employeeId,
      this.lastLoginAt,
      this.lastLoginIp,
      this.loginCount,
      this.passwordChangedAt,
      this.mustChangePassword,
      final List<String>? allowedIpRanges,
      final Map<String, dynamic>? preferences,
      final Map<String, dynamic>? settings,
      required this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy,
      this.suspendedAt,
      this.suspendedBy,
      this.suspensionReason})
      : _permissions = permissions,
        _mfaMethods = mfaMethods,
        _allowedIpRanges = allowedIpRanges,
        _preferences = preferences,
        _settings = settings;

  factory _$AdminUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdminUserImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? middleName;
  @override
  final String? phoneNumber;
  @override
  final String? profilePicture;
  @override
  final AdminRole role;
  final List<Permission> _permissions;
  @override
  List<Permission> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  @override
  final UserStatus status;
  @override
  final bool isEmailVerified;
  @override
  final bool isMfaEnabled;
  final List<MfaMethod>? _mfaMethods;
  @override
  List<MfaMethod>? get mfaMethods {
    final value = _mfaMethods;
    if (value == null) return null;
    if (_mfaMethods is EqualUnmodifiableListView) return _mfaMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? department;
  @override
  final String? jobTitle;
  @override
  final String? employeeId;
  @override
  final DateTime? lastLoginAt;
  @override
  final String? lastLoginIp;
  @override
  final int? loginCount;
  @override
  final DateTime? passwordChangedAt;
  @override
  final bool? mustChangePassword;
  final List<String>? _allowedIpRanges;
  @override
  List<String>? get allowedIpRanges {
    final value = _allowedIpRanges;
    if (value == null) return null;
    if (_allowedIpRanges is EqualUnmodifiableListView) return _allowedIpRanges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _preferences;
  @override
  Map<String, dynamic>? get preferences {
    final value = _preferences;
    if (value == null) return null;
    if (_preferences is EqualUnmodifiableMapView) return _preferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _settings;
  @override
  Map<String, dynamic>? get settings {
    final value = _settings;
    if (value == null) return null;
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? createdBy;
  @override
  final String? updatedBy;
  @override
  final DateTime? suspendedAt;
  @override
  final String? suspendedBy;
  @override
  final String? suspensionReason;

  @override
  String toString() {
    return 'AdminUser(id: $id, email: $email, firstName: $firstName, lastName: $lastName, middleName: $middleName, phoneNumber: $phoneNumber, profilePicture: $profilePicture, role: $role, permissions: $permissions, status: $status, isEmailVerified: $isEmailVerified, isMfaEnabled: $isMfaEnabled, mfaMethods: $mfaMethods, department: $department, jobTitle: $jobTitle, employeeId: $employeeId, lastLoginAt: $lastLoginAt, lastLoginIp: $lastLoginIp, loginCount: $loginCount, passwordChangedAt: $passwordChangedAt, mustChangePassword: $mustChangePassword, allowedIpRanges: $allowedIpRanges, preferences: $preferences, settings: $settings, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy, suspendedAt: $suspendedAt, suspendedBy: $suspendedBy, suspensionReason: $suspensionReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.middleName, middleName) ||
                other.middleName == middleName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.profilePicture, profilePicture) ||
                other.profilePicture == profilePicture) &&
            (identical(other.role, role) || other.role == role) &&
            const DeepCollectionEquality()
                .equals(other._permissions, _permissions) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isEmailVerified, isEmailVerified) ||
                other.isEmailVerified == isEmailVerified) &&
            (identical(other.isMfaEnabled, isMfaEnabled) ||
                other.isMfaEnabled == isMfaEnabled) &&
            const DeepCollectionEquality()
                .equals(other._mfaMethods, _mfaMethods) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.jobTitle, jobTitle) ||
                other.jobTitle == jobTitle) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt) &&
            (identical(other.lastLoginIp, lastLoginIp) ||
                other.lastLoginIp == lastLoginIp) &&
            (identical(other.loginCount, loginCount) ||
                other.loginCount == loginCount) &&
            (identical(other.passwordChangedAt, passwordChangedAt) ||
                other.passwordChangedAt == passwordChangedAt) &&
            (identical(other.mustChangePassword, mustChangePassword) ||
                other.mustChangePassword == mustChangePassword) &&
            const DeepCollectionEquality()
                .equals(other._allowedIpRanges, _allowedIpRanges) &&
            const DeepCollectionEquality()
                .equals(other._preferences, _preferences) &&
            const DeepCollectionEquality().equals(other._settings, _settings) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy) &&
            (identical(other.suspendedAt, suspendedAt) ||
                other.suspendedAt == suspendedAt) &&
            (identical(other.suspendedBy, suspendedBy) ||
                other.suspendedBy == suspendedBy) &&
            (identical(other.suspensionReason, suspensionReason) ||
                other.suspensionReason == suspensionReason));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        email,
        firstName,
        lastName,
        middleName,
        phoneNumber,
        profilePicture,
        role,
        const DeepCollectionEquality().hash(_permissions),
        status,
        isEmailVerified,
        isMfaEnabled,
        const DeepCollectionEquality().hash(_mfaMethods),
        department,
        jobTitle,
        employeeId,
        lastLoginAt,
        lastLoginIp,
        loginCount,
        passwordChangedAt,
        mustChangePassword,
        const DeepCollectionEquality().hash(_allowedIpRanges),
        const DeepCollectionEquality().hash(_preferences),
        const DeepCollectionEquality().hash(_settings),
        createdAt,
        updatedAt,
        createdBy,
        updatedBy,
        suspendedAt,
        suspendedBy,
        suspensionReason
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminUserImplCopyWith<_$AdminUserImpl> get copyWith =>
      __$$AdminUserImplCopyWithImpl<_$AdminUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdminUserImplToJson(
      this,
    );
  }
}

abstract class _AdminUser implements AdminUser {
  const factory _AdminUser(
      {required final String id,
      required final String email,
      required final String firstName,
      required final String lastName,
      final String? middleName,
      final String? phoneNumber,
      final String? profilePicture,
      required final AdminRole role,
      required final List<Permission> permissions,
      required final UserStatus status,
      required final bool isEmailVerified,
      required final bool isMfaEnabled,
      final List<MfaMethod>? mfaMethods,
      final String? department,
      final String? jobTitle,
      final String? employeeId,
      final DateTime? lastLoginAt,
      final String? lastLoginIp,
      final int? loginCount,
      final DateTime? passwordChangedAt,
      final bool? mustChangePassword,
      final List<String>? allowedIpRanges,
      final Map<String, dynamic>? preferences,
      final Map<String, dynamic>? settings,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final String? createdBy,
      final String? updatedBy,
      final DateTime? suspendedAt,
      final String? suspendedBy,
      final String? suspensionReason}) = _$AdminUserImpl;

  factory _AdminUser.fromJson(Map<String, dynamic> json) =
      _$AdminUserImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String? get middleName;
  @override
  String? get phoneNumber;
  @override
  String? get profilePicture;
  @override
  AdminRole get role;
  @override
  List<Permission> get permissions;
  @override
  UserStatus get status;
  @override
  bool get isEmailVerified;
  @override
  bool get isMfaEnabled;
  @override
  List<MfaMethod>? get mfaMethods;
  @override
  String? get department;
  @override
  String? get jobTitle;
  @override
  String? get employeeId;
  @override
  DateTime? get lastLoginAt;
  @override
  String? get lastLoginIp;
  @override
  int? get loginCount;
  @override
  DateTime? get passwordChangedAt;
  @override
  bool? get mustChangePassword;
  @override
  List<String>? get allowedIpRanges;
  @override
  Map<String, dynamic>? get preferences;
  @override
  Map<String, dynamic>? get settings;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get createdBy;
  @override
  String? get updatedBy;
  @override
  DateTime? get suspendedAt;
  @override
  String? get suspendedBy;
  @override
  String? get suspensionReason;
  @override
  @JsonKey(ignore: true)
  _$$AdminUserImplCopyWith<_$AdminUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
