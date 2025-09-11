// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'access_control.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Permission _$PermissionFromJson(Map<String, dynamic> json) {
  return _Permission.fromJson(json);
}

/// @nodoc
mixin _$Permission {
  String get id => throw _privateConstructorUsedError;
  ResourceType get resource => throw _privateConstructorUsedError;
  PermissionType get type => throw _privateConstructorUsedError;
  AppPlatform get platform => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Map<String, dynamic>? get constraints => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PermissionCopyWith<Permission> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PermissionCopyWith<$Res> {
  factory $PermissionCopyWith(
          Permission value, $Res Function(Permission) then) =
      _$PermissionCopyWithImpl<$Res, Permission>;
  @useResult
  $Res call(
      {String id,
      ResourceType resource,
      PermissionType type,
      AppPlatform platform,
      String? description,
      Map<String, dynamic>? constraints,
      bool isActive,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$PermissionCopyWithImpl<$Res, $Val extends Permission>
    implements $PermissionCopyWith<$Res> {
  _$PermissionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? resource = null,
    Object? type = null,
    Object? platform = null,
    Object? description = freezed,
    Object? constraints = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      resource: null == resource
          ? _value.resource
          : resource // ignore: cast_nullable_to_non_nullable
              as ResourceType,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PermissionType,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as AppPlatform,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      constraints: freezed == constraints
          ? _value.constraints
          : constraints // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PermissionImplCopyWith<$Res>
    implements $PermissionCopyWith<$Res> {
  factory _$$PermissionImplCopyWith(
          _$PermissionImpl value, $Res Function(_$PermissionImpl) then) =
      __$$PermissionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      ResourceType resource,
      PermissionType type,
      AppPlatform platform,
      String? description,
      Map<String, dynamic>? constraints,
      bool isActive,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$PermissionImplCopyWithImpl<$Res>
    extends _$PermissionCopyWithImpl<$Res, _$PermissionImpl>
    implements _$$PermissionImplCopyWith<$Res> {
  __$$PermissionImplCopyWithImpl(
      _$PermissionImpl _value, $Res Function(_$PermissionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? resource = null,
    Object? type = null,
    Object? platform = null,
    Object? description = freezed,
    Object? constraints = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$PermissionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      resource: null == resource
          ? _value.resource
          : resource // ignore: cast_nullable_to_non_nullable
              as ResourceType,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PermissionType,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as AppPlatform,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      constraints: freezed == constraints
          ? _value._constraints
          : constraints // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PermissionImpl implements _Permission {
  const _$PermissionImpl(
      {required this.id,
      required this.resource,
      required this.type,
      required this.platform,
      this.description,
      final Map<String, dynamic>? constraints,
      this.isActive = true,
      required this.createdAt,
      this.updatedAt})
      : _constraints = constraints;

  factory _$PermissionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PermissionImplFromJson(json);

  @override
  final String id;
  @override
  final ResourceType resource;
  @override
  final PermissionType type;
  @override
  final AppPlatform platform;
  @override
  final String? description;
  final Map<String, dynamic>? _constraints;
  @override
  Map<String, dynamic>? get constraints {
    final value = _constraints;
    if (value == null) return null;
    if (_constraints is EqualUnmodifiableMapView) return _constraints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Permission(id: $id, resource: $resource, type: $type, platform: $platform, description: $description, constraints: $constraints, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.resource, resource) ||
                other.resource == resource) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._constraints, _constraints) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      resource,
      type,
      platform,
      description,
      const DeepCollectionEquality().hash(_constraints),
      isActive,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PermissionImplCopyWith<_$PermissionImpl> get copyWith =>
      __$$PermissionImplCopyWithImpl<_$PermissionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PermissionImplToJson(
      this,
    );
  }
}

abstract class _Permission implements Permission {
  const factory _Permission(
      {required final String id,
      required final ResourceType resource,
      required final PermissionType type,
      required final AppPlatform platform,
      final String? description,
      final Map<String, dynamic>? constraints,
      final bool isActive,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$PermissionImpl;

  factory _Permission.fromJson(Map<String, dynamic> json) =
      _$PermissionImpl.fromJson;

  @override
  String get id;
  @override
  ResourceType get resource;
  @override
  PermissionType get type;
  @override
  AppPlatform get platform;
  @override
  String? get description;
  @override
  Map<String, dynamic>? get constraints;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$PermissionImplCopyWith<_$PermissionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RolePermission _$RolePermissionFromJson(Map<String, dynamic> json) {
  return _RolePermission.fromJson(json);
}

/// @nodoc
mixin _$RolePermission {
  String get id => throw _privateConstructorUsedError;
  UserRole get role => throw _privateConstructorUsedError;
  List<Permission> get permissions => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RolePermissionCopyWith<RolePermission> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RolePermissionCopyWith<$Res> {
  factory $RolePermissionCopyWith(
          RolePermission value, $Res Function(RolePermission) then) =
      _$RolePermissionCopyWithImpl<$Res, RolePermission>;
  @useResult
  $Res call(
      {String id,
      UserRole role,
      List<Permission> permissions,
      String? description,
      bool isActive,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$RolePermissionCopyWithImpl<$Res, $Val extends RolePermission>
    implements $RolePermissionCopyWith<$Res> {
  _$RolePermissionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? permissions = null,
    Object? description = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<Permission>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RolePermissionImplCopyWith<$Res>
    implements $RolePermissionCopyWith<$Res> {
  factory _$$RolePermissionImplCopyWith(_$RolePermissionImpl value,
          $Res Function(_$RolePermissionImpl) then) =
      __$$RolePermissionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      UserRole role,
      List<Permission> permissions,
      String? description,
      bool isActive,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$RolePermissionImplCopyWithImpl<$Res>
    extends _$RolePermissionCopyWithImpl<$Res, _$RolePermissionImpl>
    implements _$$RolePermissionImplCopyWith<$Res> {
  __$$RolePermissionImplCopyWithImpl(
      _$RolePermissionImpl _value, $Res Function(_$RolePermissionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? permissions = null,
    Object? description = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$RolePermissionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      permissions: null == permissions
          ? _value._permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<Permission>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RolePermissionImpl implements _RolePermission {
  const _$RolePermissionImpl(
      {required this.id,
      required this.role,
      required final List<Permission> permissions,
      this.description,
      this.isActive = true,
      required this.createdAt,
      this.updatedAt})
      : _permissions = permissions;

  factory _$RolePermissionImpl.fromJson(Map<String, dynamic> json) =>
      _$$RolePermissionImplFromJson(json);

  @override
  final String id;
  @override
  final UserRole role;
  final List<Permission> _permissions;
  @override
  List<Permission> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  @override
  final String? description;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'RolePermission(id: $id, role: $role, permissions: $permissions, description: $description, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RolePermissionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            const DeepCollectionEquality()
                .equals(other._permissions, _permissions) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      role,
      const DeepCollectionEquality().hash(_permissions),
      description,
      isActive,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RolePermissionImplCopyWith<_$RolePermissionImpl> get copyWith =>
      __$$RolePermissionImplCopyWithImpl<_$RolePermissionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RolePermissionImplToJson(
      this,
    );
  }
}

abstract class _RolePermission implements RolePermission {
  const factory _RolePermission(
      {required final String id,
      required final UserRole role,
      required final List<Permission> permissions,
      final String? description,
      final bool isActive,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$RolePermissionImpl;

  factory _RolePermission.fromJson(Map<String, dynamic> json) =
      _$RolePermissionImpl.fromJson;

  @override
  String get id;
  @override
  UserRole get role;
  @override
  List<Permission> get permissions;
  @override
  String? get description;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$RolePermissionImplCopyWith<_$RolePermissionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserAccess _$UserAccessFromJson(Map<String, dynamic> json) {
  return _UserAccess.fromJson(json);
}

/// @nodoc
mixin _$UserAccess {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  List<UserRole> get roles => throw _privateConstructorUsedError;
  List<AppPlatform> get allowedPlatforms => throw _privateConstructorUsedError;
  List<Permission> get customPermissions => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isLocked => throw _privateConstructorUsedError;
  bool get requiresPasswordReset => throw _privateConstructorUsedError;
  DateTime? get lastLoginAt => throw _privateConstructorUsedError;
  DateTime? get lockedAt => throw _privateConstructorUsedError;
  String? get lockedReason => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  String? get updatedBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserAccessCopyWith<UserAccess> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserAccessCopyWith<$Res> {
  factory $UserAccessCopyWith(
          UserAccess value, $Res Function(UserAccess) then) =
      _$UserAccessCopyWithImpl<$Res, UserAccess>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String email,
      String fullName,
      List<UserRole> roles,
      List<AppPlatform> allowedPlatforms,
      List<Permission> customPermissions,
      bool isActive,
      bool isLocked,
      bool requiresPasswordReset,
      DateTime? lastLoginAt,
      DateTime? lockedAt,
      String? lockedReason,
      DateTime createdAt,
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy});
}

/// @nodoc
class _$UserAccessCopyWithImpl<$Res, $Val extends UserAccess>
    implements $UserAccessCopyWith<$Res> {
  _$UserAccessCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? email = null,
    Object? fullName = null,
    Object? roles = null,
    Object? allowedPlatforms = null,
    Object? customPermissions = null,
    Object? isActive = null,
    Object? isLocked = null,
    Object? requiresPasswordReset = null,
    Object? lastLoginAt = freezed,
    Object? lockedAt = freezed,
    Object? lockedReason = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      roles: null == roles
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<UserRole>,
      allowedPlatforms: null == allowedPlatforms
          ? _value.allowedPlatforms
          : allowedPlatforms // ignore: cast_nullable_to_non_nullable
              as List<AppPlatform>,
      customPermissions: null == customPermissions
          ? _value.customPermissions
          : customPermissions // ignore: cast_nullable_to_non_nullable
              as List<Permission>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isLocked: null == isLocked
          ? _value.isLocked
          : isLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      requiresPasswordReset: null == requiresPasswordReset
          ? _value.requiresPasswordReset
          : requiresPasswordReset // ignore: cast_nullable_to_non_nullable
              as bool,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lockedAt: freezed == lockedAt
          ? _value.lockedAt
          : lockedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lockedReason: freezed == lockedReason
          ? _value.lockedReason
          : lockedReason // ignore: cast_nullable_to_non_nullable
              as String?,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserAccessImplCopyWith<$Res>
    implements $UserAccessCopyWith<$Res> {
  factory _$$UserAccessImplCopyWith(
          _$UserAccessImpl value, $Res Function(_$UserAccessImpl) then) =
      __$$UserAccessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String email,
      String fullName,
      List<UserRole> roles,
      List<AppPlatform> allowedPlatforms,
      List<Permission> customPermissions,
      bool isActive,
      bool isLocked,
      bool requiresPasswordReset,
      DateTime? lastLoginAt,
      DateTime? lockedAt,
      String? lockedReason,
      DateTime createdAt,
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy});
}

/// @nodoc
class __$$UserAccessImplCopyWithImpl<$Res>
    extends _$UserAccessCopyWithImpl<$Res, _$UserAccessImpl>
    implements _$$UserAccessImplCopyWith<$Res> {
  __$$UserAccessImplCopyWithImpl(
      _$UserAccessImpl _value, $Res Function(_$UserAccessImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? email = null,
    Object? fullName = null,
    Object? roles = null,
    Object? allowedPlatforms = null,
    Object? customPermissions = null,
    Object? isActive = null,
    Object? isLocked = null,
    Object? requiresPasswordReset = null,
    Object? lastLoginAt = freezed,
    Object? lockedAt = freezed,
    Object? lockedReason = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(_$UserAccessImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      roles: null == roles
          ? _value._roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<UserRole>,
      allowedPlatforms: null == allowedPlatforms
          ? _value._allowedPlatforms
          : allowedPlatforms // ignore: cast_nullable_to_non_nullable
              as List<AppPlatform>,
      customPermissions: null == customPermissions
          ? _value._customPermissions
          : customPermissions // ignore: cast_nullable_to_non_nullable
              as List<Permission>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isLocked: null == isLocked
          ? _value.isLocked
          : isLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      requiresPasswordReset: null == requiresPasswordReset
          ? _value.requiresPasswordReset
          : requiresPasswordReset // ignore: cast_nullable_to_non_nullable
              as bool,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lockedAt: freezed == lockedAt
          ? _value.lockedAt
          : lockedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lockedReason: freezed == lockedReason
          ? _value.lockedReason
          : lockedReason // ignore: cast_nullable_to_non_nullable
              as String?,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserAccessImpl implements _UserAccess {
  const _$UserAccessImpl(
      {required this.id,
      required this.userId,
      required this.email,
      required this.fullName,
      required final List<UserRole> roles,
      required final List<AppPlatform> allowedPlatforms,
      required final List<Permission> customPermissions,
      this.isActive = true,
      this.isLocked = false,
      this.requiresPasswordReset = false,
      this.lastLoginAt,
      this.lockedAt,
      this.lockedReason,
      required this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy})
      : _roles = roles,
        _allowedPlatforms = allowedPlatforms,
        _customPermissions = customPermissions;

  factory _$UserAccessImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserAccessImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String email;
  @override
  final String fullName;
  final List<UserRole> _roles;
  @override
  List<UserRole> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  final List<AppPlatform> _allowedPlatforms;
  @override
  List<AppPlatform> get allowedPlatforms {
    if (_allowedPlatforms is EqualUnmodifiableListView)
      return _allowedPlatforms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allowedPlatforms);
  }

  final List<Permission> _customPermissions;
  @override
  List<Permission> get customPermissions {
    if (_customPermissions is EqualUnmodifiableListView)
      return _customPermissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_customPermissions);
  }

  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isLocked;
  @override
  @JsonKey()
  final bool requiresPasswordReset;
  @override
  final DateTime? lastLoginAt;
  @override
  final DateTime? lockedAt;
  @override
  final String? lockedReason;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? createdBy;
  @override
  final String? updatedBy;

  @override
  String toString() {
    return 'UserAccess(id: $id, userId: $userId, email: $email, fullName: $fullName, roles: $roles, allowedPlatforms: $allowedPlatforms, customPermissions: $customPermissions, isActive: $isActive, isLocked: $isLocked, requiresPasswordReset: $requiresPasswordReset, lastLoginAt: $lastLoginAt, lockedAt: $lockedAt, lockedReason: $lockedReason, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserAccessImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            const DeepCollectionEquality()
                .equals(other._allowedPlatforms, _allowedPlatforms) &&
            const DeepCollectionEquality()
                .equals(other._customPermissions, _customPermissions) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isLocked, isLocked) ||
                other.isLocked == isLocked) &&
            (identical(other.requiresPasswordReset, requiresPasswordReset) ||
                other.requiresPasswordReset == requiresPasswordReset) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt) &&
            (identical(other.lockedAt, lockedAt) ||
                other.lockedAt == lockedAt) &&
            (identical(other.lockedReason, lockedReason) ||
                other.lockedReason == lockedReason) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      email,
      fullName,
      const DeepCollectionEquality().hash(_roles),
      const DeepCollectionEquality().hash(_allowedPlatforms),
      const DeepCollectionEquality().hash(_customPermissions),
      isActive,
      isLocked,
      requiresPasswordReset,
      lastLoginAt,
      lockedAt,
      lockedReason,
      createdAt,
      updatedAt,
      createdBy,
      updatedBy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserAccessImplCopyWith<_$UserAccessImpl> get copyWith =>
      __$$UserAccessImplCopyWithImpl<_$UserAccessImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserAccessImplToJson(
      this,
    );
  }
}

abstract class _UserAccess implements UserAccess {
  const factory _UserAccess(
      {required final String id,
      required final String userId,
      required final String email,
      required final String fullName,
      required final List<UserRole> roles,
      required final List<AppPlatform> allowedPlatforms,
      required final List<Permission> customPermissions,
      final bool isActive,
      final bool isLocked,
      final bool requiresPasswordReset,
      final DateTime? lastLoginAt,
      final DateTime? lockedAt,
      final String? lockedReason,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final String? createdBy,
      final String? updatedBy}) = _$UserAccessImpl;

  factory _UserAccess.fromJson(Map<String, dynamic> json) =
      _$UserAccessImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get email;
  @override
  String get fullName;
  @override
  List<UserRole> get roles;
  @override
  List<AppPlatform> get allowedPlatforms;
  @override
  List<Permission> get customPermissions;
  @override
  bool get isActive;
  @override
  bool get isLocked;
  @override
  bool get requiresPasswordReset;
  @override
  DateTime? get lastLoginAt;
  @override
  DateTime? get lockedAt;
  @override
  String? get lockedReason;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get createdBy;
  @override
  String? get updatedBy;
  @override
  @JsonKey(ignore: true)
  _$$UserAccessImplCopyWith<_$UserAccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AccessRequest _$AccessRequestFromJson(Map<String, dynamic> json) {
  return _AccessRequest.fromJson(json);
}

/// @nodoc
mixin _$AccessRequest {
  String get id => throw _privateConstructorUsedError;
  String get requesterId => throw _privateConstructorUsedError;
  String get requesterName => throw _privateConstructorUsedError;
  String get requesterEmail => throw _privateConstructorUsedError;
  String get targetUserId => throw _privateConstructorUsedError;
  String get targetUserName => throw _privateConstructorUsedError;
  String get targetUserEmail => throw _privateConstructorUsedError;
  AccessRequestType get type => throw _privateConstructorUsedError;
  AccessRequestStatus get status => throw _privateConstructorUsedError;
  List<UserRole> get requestedRoles => throw _privateConstructorUsedError;
  List<AppPlatform> get requestedPlatforms =>
      throw _privateConstructorUsedError;
  List<Permission> get requestedPermissions =>
      throw _privateConstructorUsedError;
  String get justification => throw _privateConstructorUsedError;
  String? get approverComments => throw _privateConstructorUsedError;
  String? get approvedBy => throw _privateConstructorUsedError;
  DateTime? get approvedAt => throw _privateConstructorUsedError;
  String? get rejectedBy => throw _privateConstructorUsedError;
  DateTime? get rejectedAt => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AccessRequestCopyWith<AccessRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccessRequestCopyWith<$Res> {
  factory $AccessRequestCopyWith(
          AccessRequest value, $Res Function(AccessRequest) then) =
      _$AccessRequestCopyWithImpl<$Res, AccessRequest>;
  @useResult
  $Res call(
      {String id,
      String requesterId,
      String requesterName,
      String requesterEmail,
      String targetUserId,
      String targetUserName,
      String targetUserEmail,
      AccessRequestType type,
      AccessRequestStatus status,
      List<UserRole> requestedRoles,
      List<AppPlatform> requestedPlatforms,
      List<Permission> requestedPermissions,
      String justification,
      String? approverComments,
      String? approvedBy,
      DateTime? approvedAt,
      String? rejectedBy,
      DateTime? rejectedAt,
      String? rejectionReason,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$AccessRequestCopyWithImpl<$Res, $Val extends AccessRequest>
    implements $AccessRequestCopyWith<$Res> {
  _$AccessRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requesterId = null,
    Object? requesterName = null,
    Object? requesterEmail = null,
    Object? targetUserId = null,
    Object? targetUserName = null,
    Object? targetUserEmail = null,
    Object? type = null,
    Object? status = null,
    Object? requestedRoles = null,
    Object? requestedPlatforms = null,
    Object? requestedPermissions = null,
    Object? justification = null,
    Object? approverComments = freezed,
    Object? approvedBy = freezed,
    Object? approvedAt = freezed,
    Object? rejectedBy = freezed,
    Object? rejectedAt = freezed,
    Object? rejectionReason = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requesterId: null == requesterId
          ? _value.requesterId
          : requesterId // ignore: cast_nullable_to_non_nullable
              as String,
      requesterName: null == requesterName
          ? _value.requesterName
          : requesterName // ignore: cast_nullable_to_non_nullable
              as String,
      requesterEmail: null == requesterEmail
          ? _value.requesterEmail
          : requesterEmail // ignore: cast_nullable_to_non_nullable
              as String,
      targetUserId: null == targetUserId
          ? _value.targetUserId
          : targetUserId // ignore: cast_nullable_to_non_nullable
              as String,
      targetUserName: null == targetUserName
          ? _value.targetUserName
          : targetUserName // ignore: cast_nullable_to_non_nullable
              as String,
      targetUserEmail: null == targetUserEmail
          ? _value.targetUserEmail
          : targetUserEmail // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AccessRequestType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AccessRequestStatus,
      requestedRoles: null == requestedRoles
          ? _value.requestedRoles
          : requestedRoles // ignore: cast_nullable_to_non_nullable
              as List<UserRole>,
      requestedPlatforms: null == requestedPlatforms
          ? _value.requestedPlatforms
          : requestedPlatforms // ignore: cast_nullable_to_non_nullable
              as List<AppPlatform>,
      requestedPermissions: null == requestedPermissions
          ? _value.requestedPermissions
          : requestedPermissions // ignore: cast_nullable_to_non_nullable
              as List<Permission>,
      justification: null == justification
          ? _value.justification
          : justification // ignore: cast_nullable_to_non_nullable
              as String,
      approverComments: freezed == approverComments
          ? _value.approverComments
          : approverComments // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rejectedBy: freezed == rejectedBy
          ? _value.rejectedBy
          : rejectedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectedAt: freezed == rejectedAt
          ? _value.rejectedAt
          : rejectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccessRequestImplCopyWith<$Res>
    implements $AccessRequestCopyWith<$Res> {
  factory _$$AccessRequestImplCopyWith(
          _$AccessRequestImpl value, $Res Function(_$AccessRequestImpl) then) =
      __$$AccessRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String requesterId,
      String requesterName,
      String requesterEmail,
      String targetUserId,
      String targetUserName,
      String targetUserEmail,
      AccessRequestType type,
      AccessRequestStatus status,
      List<UserRole> requestedRoles,
      List<AppPlatform> requestedPlatforms,
      List<Permission> requestedPermissions,
      String justification,
      String? approverComments,
      String? approvedBy,
      DateTime? approvedAt,
      String? rejectedBy,
      DateTime? rejectedAt,
      String? rejectionReason,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$AccessRequestImplCopyWithImpl<$Res>
    extends _$AccessRequestCopyWithImpl<$Res, _$AccessRequestImpl>
    implements _$$AccessRequestImplCopyWith<$Res> {
  __$$AccessRequestImplCopyWithImpl(
      _$AccessRequestImpl _value, $Res Function(_$AccessRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? requesterId = null,
    Object? requesterName = null,
    Object? requesterEmail = null,
    Object? targetUserId = null,
    Object? targetUserName = null,
    Object? targetUserEmail = null,
    Object? type = null,
    Object? status = null,
    Object? requestedRoles = null,
    Object? requestedPlatforms = null,
    Object? requestedPermissions = null,
    Object? justification = null,
    Object? approverComments = freezed,
    Object? approvedBy = freezed,
    Object? approvedAt = freezed,
    Object? rejectedBy = freezed,
    Object? rejectedAt = freezed,
    Object? rejectionReason = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$AccessRequestImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      requesterId: null == requesterId
          ? _value.requesterId
          : requesterId // ignore: cast_nullable_to_non_nullable
              as String,
      requesterName: null == requesterName
          ? _value.requesterName
          : requesterName // ignore: cast_nullable_to_non_nullable
              as String,
      requesterEmail: null == requesterEmail
          ? _value.requesterEmail
          : requesterEmail // ignore: cast_nullable_to_non_nullable
              as String,
      targetUserId: null == targetUserId
          ? _value.targetUserId
          : targetUserId // ignore: cast_nullable_to_non_nullable
              as String,
      targetUserName: null == targetUserName
          ? _value.targetUserName
          : targetUserName // ignore: cast_nullable_to_non_nullable
              as String,
      targetUserEmail: null == targetUserEmail
          ? _value.targetUserEmail
          : targetUserEmail // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AccessRequestType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AccessRequestStatus,
      requestedRoles: null == requestedRoles
          ? _value._requestedRoles
          : requestedRoles // ignore: cast_nullable_to_non_nullable
              as List<UserRole>,
      requestedPlatforms: null == requestedPlatforms
          ? _value._requestedPlatforms
          : requestedPlatforms // ignore: cast_nullable_to_non_nullable
              as List<AppPlatform>,
      requestedPermissions: null == requestedPermissions
          ? _value._requestedPermissions
          : requestedPermissions // ignore: cast_nullable_to_non_nullable
              as List<Permission>,
      justification: null == justification
          ? _value.justification
          : justification // ignore: cast_nullable_to_non_nullable
              as String,
      approverComments: freezed == approverComments
          ? _value.approverComments
          : approverComments // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rejectedBy: freezed == rejectedBy
          ? _value.rejectedBy
          : rejectedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectedAt: freezed == rejectedAt
          ? _value.rejectedAt
          : rejectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccessRequestImpl implements _AccessRequest {
  const _$AccessRequestImpl(
      {required this.id,
      required this.requesterId,
      required this.requesterName,
      required this.requesterEmail,
      required this.targetUserId,
      required this.targetUserName,
      required this.targetUserEmail,
      required this.type,
      required this.status,
      required final List<UserRole> requestedRoles,
      required final List<AppPlatform> requestedPlatforms,
      required final List<Permission> requestedPermissions,
      required this.justification,
      this.approverComments,
      this.approvedBy,
      this.approvedAt,
      this.rejectedBy,
      this.rejectedAt,
      this.rejectionReason,
      required this.createdAt,
      this.updatedAt})
      : _requestedRoles = requestedRoles,
        _requestedPlatforms = requestedPlatforms,
        _requestedPermissions = requestedPermissions;

  factory _$AccessRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccessRequestImplFromJson(json);

  @override
  final String id;
  @override
  final String requesterId;
  @override
  final String requesterName;
  @override
  final String requesterEmail;
  @override
  final String targetUserId;
  @override
  final String targetUserName;
  @override
  final String targetUserEmail;
  @override
  final AccessRequestType type;
  @override
  final AccessRequestStatus status;
  final List<UserRole> _requestedRoles;
  @override
  List<UserRole> get requestedRoles {
    if (_requestedRoles is EqualUnmodifiableListView) return _requestedRoles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requestedRoles);
  }

  final List<AppPlatform> _requestedPlatforms;
  @override
  List<AppPlatform> get requestedPlatforms {
    if (_requestedPlatforms is EqualUnmodifiableListView)
      return _requestedPlatforms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requestedPlatforms);
  }

  final List<Permission> _requestedPermissions;
  @override
  List<Permission> get requestedPermissions {
    if (_requestedPermissions is EqualUnmodifiableListView)
      return _requestedPermissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requestedPermissions);
  }

  @override
  final String justification;
  @override
  final String? approverComments;
  @override
  final String? approvedBy;
  @override
  final DateTime? approvedAt;
  @override
  final String? rejectedBy;
  @override
  final DateTime? rejectedAt;
  @override
  final String? rejectionReason;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'AccessRequest(id: $id, requesterId: $requesterId, requesterName: $requesterName, requesterEmail: $requesterEmail, targetUserId: $targetUserId, targetUserName: $targetUserName, targetUserEmail: $targetUserEmail, type: $type, status: $status, requestedRoles: $requestedRoles, requestedPlatforms: $requestedPlatforms, requestedPermissions: $requestedPermissions, justification: $justification, approverComments: $approverComments, approvedBy: $approvedBy, approvedAt: $approvedAt, rejectedBy: $rejectedBy, rejectedAt: $rejectedAt, rejectionReason: $rejectionReason, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccessRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.requesterId, requesterId) ||
                other.requesterId == requesterId) &&
            (identical(other.requesterName, requesterName) ||
                other.requesterName == requesterName) &&
            (identical(other.requesterEmail, requesterEmail) ||
                other.requesterEmail == requesterEmail) &&
            (identical(other.targetUserId, targetUserId) ||
                other.targetUserId == targetUserId) &&
            (identical(other.targetUserName, targetUserName) ||
                other.targetUserName == targetUserName) &&
            (identical(other.targetUserEmail, targetUserEmail) ||
                other.targetUserEmail == targetUserEmail) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._requestedRoles, _requestedRoles) &&
            const DeepCollectionEquality()
                .equals(other._requestedPlatforms, _requestedPlatforms) &&
            const DeepCollectionEquality()
                .equals(other._requestedPermissions, _requestedPermissions) &&
            (identical(other.justification, justification) ||
                other.justification == justification) &&
            (identical(other.approverComments, approverComments) ||
                other.approverComments == approverComments) &&
            (identical(other.approvedBy, approvedBy) ||
                other.approvedBy == approvedBy) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
            (identical(other.rejectedBy, rejectedBy) ||
                other.rejectedBy == rejectedBy) &&
            (identical(other.rejectedAt, rejectedAt) ||
                other.rejectedAt == rejectedAt) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        requesterId,
        requesterName,
        requesterEmail,
        targetUserId,
        targetUserName,
        targetUserEmail,
        type,
        status,
        const DeepCollectionEquality().hash(_requestedRoles),
        const DeepCollectionEquality().hash(_requestedPlatforms),
        const DeepCollectionEquality().hash(_requestedPermissions),
        justification,
        approverComments,
        approvedBy,
        approvedAt,
        rejectedBy,
        rejectedAt,
        rejectionReason,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AccessRequestImplCopyWith<_$AccessRequestImpl> get copyWith =>
      __$$AccessRequestImplCopyWithImpl<_$AccessRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccessRequestImplToJson(
      this,
    );
  }
}

abstract class _AccessRequest implements AccessRequest {
  const factory _AccessRequest(
      {required final String id,
      required final String requesterId,
      required final String requesterName,
      required final String requesterEmail,
      required final String targetUserId,
      required final String targetUserName,
      required final String targetUserEmail,
      required final AccessRequestType type,
      required final AccessRequestStatus status,
      required final List<UserRole> requestedRoles,
      required final List<AppPlatform> requestedPlatforms,
      required final List<Permission> requestedPermissions,
      required final String justification,
      final String? approverComments,
      final String? approvedBy,
      final DateTime? approvedAt,
      final String? rejectedBy,
      final DateTime? rejectedAt,
      final String? rejectionReason,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$AccessRequestImpl;

  factory _AccessRequest.fromJson(Map<String, dynamic> json) =
      _$AccessRequestImpl.fromJson;

  @override
  String get id;
  @override
  String get requesterId;
  @override
  String get requesterName;
  @override
  String get requesterEmail;
  @override
  String get targetUserId;
  @override
  String get targetUserName;
  @override
  String get targetUserEmail;
  @override
  AccessRequestType get type;
  @override
  AccessRequestStatus get status;
  @override
  List<UserRole> get requestedRoles;
  @override
  List<AppPlatform> get requestedPlatforms;
  @override
  List<Permission> get requestedPermissions;
  @override
  String get justification;
  @override
  String? get approverComments;
  @override
  String? get approvedBy;
  @override
  DateTime? get approvedAt;
  @override
  String? get rejectedBy;
  @override
  DateTime? get rejectedAt;
  @override
  String? get rejectionReason;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$AccessRequestImplCopyWith<_$AccessRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AccessAuditLog _$AccessAuditLogFromJson(Map<String, dynamic> json) {
  return _AccessAuditLog.fromJson(json);
}

/// @nodoc
mixin _$AccessAuditLog {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;
  String get resource => throw _privateConstructorUsedError;
  AppPlatform get platform => throw _privateConstructorUsedError;
  Map<String, dynamic> get details => throw _privateConstructorUsedError;
  String get ipAddress => throw _privateConstructorUsedError;
  String get userAgent => throw _privateConstructorUsedError;
  bool get success => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AccessAuditLogCopyWith<AccessAuditLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccessAuditLogCopyWith<$Res> {
  factory $AccessAuditLogCopyWith(
          AccessAuditLog value, $Res Function(AccessAuditLog) then) =
      _$AccessAuditLogCopyWithImpl<$Res, AccessAuditLog>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String userName,
      String action,
      String resource,
      AppPlatform platform,
      Map<String, dynamic> details,
      String ipAddress,
      String userAgent,
      bool success,
      String? errorMessage,
      DateTime timestamp});
}

/// @nodoc
class _$AccessAuditLogCopyWithImpl<$Res, $Val extends AccessAuditLog>
    implements $AccessAuditLogCopyWith<$Res> {
  _$AccessAuditLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? action = null,
    Object? resource = null,
    Object? platform = null,
    Object? details = null,
    Object? ipAddress = null,
    Object? userAgent = null,
    Object? success = null,
    Object? errorMessage = freezed,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      resource: null == resource
          ? _value.resource
          : resource // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as AppPlatform,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      ipAddress: null == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String,
      userAgent: null == userAgent
          ? _value.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccessAuditLogImplCopyWith<$Res>
    implements $AccessAuditLogCopyWith<$Res> {
  factory _$$AccessAuditLogImplCopyWith(_$AccessAuditLogImpl value,
          $Res Function(_$AccessAuditLogImpl) then) =
      __$$AccessAuditLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String userName,
      String action,
      String resource,
      AppPlatform platform,
      Map<String, dynamic> details,
      String ipAddress,
      String userAgent,
      bool success,
      String? errorMessage,
      DateTime timestamp});
}

/// @nodoc
class __$$AccessAuditLogImplCopyWithImpl<$Res>
    extends _$AccessAuditLogCopyWithImpl<$Res, _$AccessAuditLogImpl>
    implements _$$AccessAuditLogImplCopyWith<$Res> {
  __$$AccessAuditLogImplCopyWithImpl(
      _$AccessAuditLogImpl _value, $Res Function(_$AccessAuditLogImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = null,
    Object? action = null,
    Object? resource = null,
    Object? platform = null,
    Object? details = null,
    Object? ipAddress = null,
    Object? userAgent = null,
    Object? success = null,
    Object? errorMessage = freezed,
    Object? timestamp = null,
  }) {
    return _then(_$AccessAuditLogImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      resource: null == resource
          ? _value.resource
          : resource // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as AppPlatform,
      details: null == details
          ? _value._details
          : details // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      ipAddress: null == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String,
      userAgent: null == userAgent
          ? _value.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccessAuditLogImpl implements _AccessAuditLog {
  const _$AccessAuditLogImpl(
      {required this.id,
      required this.userId,
      required this.userName,
      required this.action,
      required this.resource,
      required this.platform,
      required final Map<String, dynamic> details,
      required this.ipAddress,
      required this.userAgent,
      this.success = true,
      this.errorMessage,
      required this.timestamp})
      : _details = details;

  factory _$AccessAuditLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccessAuditLogImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String userName;
  @override
  final String action;
  @override
  final String resource;
  @override
  final AppPlatform platform;
  final Map<String, dynamic> _details;
  @override
  Map<String, dynamic> get details {
    if (_details is EqualUnmodifiableMapView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_details);
  }

  @override
  final String ipAddress;
  @override
  final String userAgent;
  @override
  @JsonKey()
  final bool success;
  @override
  final String? errorMessage;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'AccessAuditLog(id: $id, userId: $userId, userName: $userName, action: $action, resource: $resource, platform: $platform, details: $details, ipAddress: $ipAddress, userAgent: $userAgent, success: $success, errorMessage: $errorMessage, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccessAuditLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.resource, resource) ||
                other.resource == resource) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            const DeepCollectionEquality().equals(other._details, _details) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.userAgent, userAgent) ||
                other.userAgent == userAgent) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      userName,
      action,
      resource,
      platform,
      const DeepCollectionEquality().hash(_details),
      ipAddress,
      userAgent,
      success,
      errorMessage,
      timestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AccessAuditLogImplCopyWith<_$AccessAuditLogImpl> get copyWith =>
      __$$AccessAuditLogImplCopyWithImpl<_$AccessAuditLogImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccessAuditLogImplToJson(
      this,
    );
  }
}

abstract class _AccessAuditLog implements AccessAuditLog {
  const factory _AccessAuditLog(
      {required final String id,
      required final String userId,
      required final String userName,
      required final String action,
      required final String resource,
      required final AppPlatform platform,
      required final Map<String, dynamic> details,
      required final String ipAddress,
      required final String userAgent,
      final bool success,
      final String? errorMessage,
      required final DateTime timestamp}) = _$AccessAuditLogImpl;

  factory _AccessAuditLog.fromJson(Map<String, dynamic> json) =
      _$AccessAuditLogImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get userName;
  @override
  String get action;
  @override
  String get resource;
  @override
  AppPlatform get platform;
  @override
  Map<String, dynamic> get details;
  @override
  String get ipAddress;
  @override
  String get userAgent;
  @override
  bool get success;
  @override
  String? get errorMessage;
  @override
  DateTime get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$AccessAuditLogImplCopyWith<_$AccessAuditLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AccessControlConfig _$AccessControlConfigFromJson(Map<String, dynamic> json) {
  return _AccessControlConfig.fromJson(json);
}

/// @nodoc
mixin _$AccessControlConfig {
  int get maxFailedLoginAttempts => throw _privateConstructorUsedError;
  int get lockoutDurationMinutes => throw _privateConstructorUsedError;
  int get passwordExpiryDays => throw _privateConstructorUsedError;
  bool get requireMfaForAdmins => throw _privateConstructorUsedError;
  bool get requireApprovalForRoleChanges => throw _privateConstructorUsedError;
  bool get allowSelfServicePasswordReset => throw _privateConstructorUsedError;
  int get sessionTimeoutHours => throw _privateConstructorUsedError;
  bool get logAllAccessAttempts => throw _privateConstructorUsedError;
  bool get notifyOnSuspiciousActivity => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String get updatedBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AccessControlConfigCopyWith<AccessControlConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccessControlConfigCopyWith<$Res> {
  factory $AccessControlConfigCopyWith(
          AccessControlConfig value, $Res Function(AccessControlConfig) then) =
      _$AccessControlConfigCopyWithImpl<$Res, AccessControlConfig>;
  @useResult
  $Res call(
      {int maxFailedLoginAttempts,
      int lockoutDurationMinutes,
      int passwordExpiryDays,
      bool requireMfaForAdmins,
      bool requireApprovalForRoleChanges,
      bool allowSelfServicePasswordReset,
      int sessionTimeoutHours,
      bool logAllAccessAttempts,
      bool notifyOnSuspiciousActivity,
      DateTime updatedAt,
      String updatedBy});
}

/// @nodoc
class _$AccessControlConfigCopyWithImpl<$Res, $Val extends AccessControlConfig>
    implements $AccessControlConfigCopyWith<$Res> {
  _$AccessControlConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxFailedLoginAttempts = null,
    Object? lockoutDurationMinutes = null,
    Object? passwordExpiryDays = null,
    Object? requireMfaForAdmins = null,
    Object? requireApprovalForRoleChanges = null,
    Object? allowSelfServicePasswordReset = null,
    Object? sessionTimeoutHours = null,
    Object? logAllAccessAttempts = null,
    Object? notifyOnSuspiciousActivity = null,
    Object? updatedAt = null,
    Object? updatedBy = null,
  }) {
    return _then(_value.copyWith(
      maxFailedLoginAttempts: null == maxFailedLoginAttempts
          ? _value.maxFailedLoginAttempts
          : maxFailedLoginAttempts // ignore: cast_nullable_to_non_nullable
              as int,
      lockoutDurationMinutes: null == lockoutDurationMinutes
          ? _value.lockoutDurationMinutes
          : lockoutDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      passwordExpiryDays: null == passwordExpiryDays
          ? _value.passwordExpiryDays
          : passwordExpiryDays // ignore: cast_nullable_to_non_nullable
              as int,
      requireMfaForAdmins: null == requireMfaForAdmins
          ? _value.requireMfaForAdmins
          : requireMfaForAdmins // ignore: cast_nullable_to_non_nullable
              as bool,
      requireApprovalForRoleChanges: null == requireApprovalForRoleChanges
          ? _value.requireApprovalForRoleChanges
          : requireApprovalForRoleChanges // ignore: cast_nullable_to_non_nullable
              as bool,
      allowSelfServicePasswordReset: null == allowSelfServicePasswordReset
          ? _value.allowSelfServicePasswordReset
          : allowSelfServicePasswordReset // ignore: cast_nullable_to_non_nullable
              as bool,
      sessionTimeoutHours: null == sessionTimeoutHours
          ? _value.sessionTimeoutHours
          : sessionTimeoutHours // ignore: cast_nullable_to_non_nullable
              as int,
      logAllAccessAttempts: null == logAllAccessAttempts
          ? _value.logAllAccessAttempts
          : logAllAccessAttempts // ignore: cast_nullable_to_non_nullable
              as bool,
      notifyOnSuspiciousActivity: null == notifyOnSuspiciousActivity
          ? _value.notifyOnSuspiciousActivity
          : notifyOnSuspiciousActivity // ignore: cast_nullable_to_non_nullable
              as bool,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedBy: null == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccessControlConfigImplCopyWith<$Res>
    implements $AccessControlConfigCopyWith<$Res> {
  factory _$$AccessControlConfigImplCopyWith(_$AccessControlConfigImpl value,
          $Res Function(_$AccessControlConfigImpl) then) =
      __$$AccessControlConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int maxFailedLoginAttempts,
      int lockoutDurationMinutes,
      int passwordExpiryDays,
      bool requireMfaForAdmins,
      bool requireApprovalForRoleChanges,
      bool allowSelfServicePasswordReset,
      int sessionTimeoutHours,
      bool logAllAccessAttempts,
      bool notifyOnSuspiciousActivity,
      DateTime updatedAt,
      String updatedBy});
}

/// @nodoc
class __$$AccessControlConfigImplCopyWithImpl<$Res>
    extends _$AccessControlConfigCopyWithImpl<$Res, _$AccessControlConfigImpl>
    implements _$$AccessControlConfigImplCopyWith<$Res> {
  __$$AccessControlConfigImplCopyWithImpl(_$AccessControlConfigImpl _value,
      $Res Function(_$AccessControlConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxFailedLoginAttempts = null,
    Object? lockoutDurationMinutes = null,
    Object? passwordExpiryDays = null,
    Object? requireMfaForAdmins = null,
    Object? requireApprovalForRoleChanges = null,
    Object? allowSelfServicePasswordReset = null,
    Object? sessionTimeoutHours = null,
    Object? logAllAccessAttempts = null,
    Object? notifyOnSuspiciousActivity = null,
    Object? updatedAt = null,
    Object? updatedBy = null,
  }) {
    return _then(_$AccessControlConfigImpl(
      maxFailedLoginAttempts: null == maxFailedLoginAttempts
          ? _value.maxFailedLoginAttempts
          : maxFailedLoginAttempts // ignore: cast_nullable_to_non_nullable
              as int,
      lockoutDurationMinutes: null == lockoutDurationMinutes
          ? _value.lockoutDurationMinutes
          : lockoutDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      passwordExpiryDays: null == passwordExpiryDays
          ? _value.passwordExpiryDays
          : passwordExpiryDays // ignore: cast_nullable_to_non_nullable
              as int,
      requireMfaForAdmins: null == requireMfaForAdmins
          ? _value.requireMfaForAdmins
          : requireMfaForAdmins // ignore: cast_nullable_to_non_nullable
              as bool,
      requireApprovalForRoleChanges: null == requireApprovalForRoleChanges
          ? _value.requireApprovalForRoleChanges
          : requireApprovalForRoleChanges // ignore: cast_nullable_to_non_nullable
              as bool,
      allowSelfServicePasswordReset: null == allowSelfServicePasswordReset
          ? _value.allowSelfServicePasswordReset
          : allowSelfServicePasswordReset // ignore: cast_nullable_to_non_nullable
              as bool,
      sessionTimeoutHours: null == sessionTimeoutHours
          ? _value.sessionTimeoutHours
          : sessionTimeoutHours // ignore: cast_nullable_to_non_nullable
              as int,
      logAllAccessAttempts: null == logAllAccessAttempts
          ? _value.logAllAccessAttempts
          : logAllAccessAttempts // ignore: cast_nullable_to_non_nullable
              as bool,
      notifyOnSuspiciousActivity: null == notifyOnSuspiciousActivity
          ? _value.notifyOnSuspiciousActivity
          : notifyOnSuspiciousActivity // ignore: cast_nullable_to_non_nullable
              as bool,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedBy: null == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccessControlConfigImpl implements _AccessControlConfig {
  const _$AccessControlConfigImpl(
      {this.maxFailedLoginAttempts = 3,
      this.lockoutDurationMinutes = 30,
      this.passwordExpiryDays = 90,
      this.requireMfaForAdmins = true,
      this.requireApprovalForRoleChanges = true,
      this.allowSelfServicePasswordReset = false,
      this.sessionTimeoutHours = 24,
      this.logAllAccessAttempts = true,
      this.notifyOnSuspiciousActivity = true,
      required this.updatedAt,
      required this.updatedBy});

  factory _$AccessControlConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccessControlConfigImplFromJson(json);

  @override
  @JsonKey()
  final int maxFailedLoginAttempts;
  @override
  @JsonKey()
  final int lockoutDurationMinutes;
  @override
  @JsonKey()
  final int passwordExpiryDays;
  @override
  @JsonKey()
  final bool requireMfaForAdmins;
  @override
  @JsonKey()
  final bool requireApprovalForRoleChanges;
  @override
  @JsonKey()
  final bool allowSelfServicePasswordReset;
  @override
  @JsonKey()
  final int sessionTimeoutHours;
  @override
  @JsonKey()
  final bool logAllAccessAttempts;
  @override
  @JsonKey()
  final bool notifyOnSuspiciousActivity;
  @override
  final DateTime updatedAt;
  @override
  final String updatedBy;

  @override
  String toString() {
    return 'AccessControlConfig(maxFailedLoginAttempts: $maxFailedLoginAttempts, lockoutDurationMinutes: $lockoutDurationMinutes, passwordExpiryDays: $passwordExpiryDays, requireMfaForAdmins: $requireMfaForAdmins, requireApprovalForRoleChanges: $requireApprovalForRoleChanges, allowSelfServicePasswordReset: $allowSelfServicePasswordReset, sessionTimeoutHours: $sessionTimeoutHours, logAllAccessAttempts: $logAllAccessAttempts, notifyOnSuspiciousActivity: $notifyOnSuspiciousActivity, updatedAt: $updatedAt, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccessControlConfigImpl &&
            (identical(other.maxFailedLoginAttempts, maxFailedLoginAttempts) ||
                other.maxFailedLoginAttempts == maxFailedLoginAttempts) &&
            (identical(other.lockoutDurationMinutes, lockoutDurationMinutes) ||
                other.lockoutDurationMinutes == lockoutDurationMinutes) &&
            (identical(other.passwordExpiryDays, passwordExpiryDays) ||
                other.passwordExpiryDays == passwordExpiryDays) &&
            (identical(other.requireMfaForAdmins, requireMfaForAdmins) ||
                other.requireMfaForAdmins == requireMfaForAdmins) &&
            (identical(other.requireApprovalForRoleChanges,
                    requireApprovalForRoleChanges) ||
                other.requireApprovalForRoleChanges ==
                    requireApprovalForRoleChanges) &&
            (identical(other.allowSelfServicePasswordReset,
                    allowSelfServicePasswordReset) ||
                other.allowSelfServicePasswordReset ==
                    allowSelfServicePasswordReset) &&
            (identical(other.sessionTimeoutHours, sessionTimeoutHours) ||
                other.sessionTimeoutHours == sessionTimeoutHours) &&
            (identical(other.logAllAccessAttempts, logAllAccessAttempts) ||
                other.logAllAccessAttempts == logAllAccessAttempts) &&
            (identical(other.notifyOnSuspiciousActivity,
                    notifyOnSuspiciousActivity) ||
                other.notifyOnSuspiciousActivity ==
                    notifyOnSuspiciousActivity) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      maxFailedLoginAttempts,
      lockoutDurationMinutes,
      passwordExpiryDays,
      requireMfaForAdmins,
      requireApprovalForRoleChanges,
      allowSelfServicePasswordReset,
      sessionTimeoutHours,
      logAllAccessAttempts,
      notifyOnSuspiciousActivity,
      updatedAt,
      updatedBy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AccessControlConfigImplCopyWith<_$AccessControlConfigImpl> get copyWith =>
      __$$AccessControlConfigImplCopyWithImpl<_$AccessControlConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccessControlConfigImplToJson(
      this,
    );
  }
}

abstract class _AccessControlConfig implements AccessControlConfig {
  const factory _AccessControlConfig(
      {final int maxFailedLoginAttempts,
      final int lockoutDurationMinutes,
      final int passwordExpiryDays,
      final bool requireMfaForAdmins,
      final bool requireApprovalForRoleChanges,
      final bool allowSelfServicePasswordReset,
      final int sessionTimeoutHours,
      final bool logAllAccessAttempts,
      final bool notifyOnSuspiciousActivity,
      required final DateTime updatedAt,
      required final String updatedBy}) = _$AccessControlConfigImpl;

  factory _AccessControlConfig.fromJson(Map<String, dynamic> json) =
      _$AccessControlConfigImpl.fromJson;

  @override
  int get maxFailedLoginAttempts;
  @override
  int get lockoutDurationMinutes;
  @override
  int get passwordExpiryDays;
  @override
  bool get requireMfaForAdmins;
  @override
  bool get requireApprovalForRoleChanges;
  @override
  bool get allowSelfServicePasswordReset;
  @override
  int get sessionTimeoutHours;
  @override
  bool get logAllAccessAttempts;
  @override
  bool get notifyOnSuspiciousActivity;
  @override
  DateTime get updatedAt;
  @override
  String get updatedBy;
  @override
  @JsonKey(ignore: true)
  _$$AccessControlConfigImplCopyWith<_$AccessControlConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
