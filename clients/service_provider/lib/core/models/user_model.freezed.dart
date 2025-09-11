// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  ServiceProviderType get providerType => throw _privateConstructorUsedError;
  UserStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;
  String? get businessName => throw _privateConstructorUsedError;
  String? get businessRegistrationNumber => throw _privateConstructorUsedError;
  String? get taxNumber => throw _privateConstructorUsedError;
  String? get county => throw _privateConstructorUsedError;
  String? get subCounty => throw _privateConstructorUsedError;
  String? get ward => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  List<String>? get specializations => throw _privateConstructorUsedError;
  List<String>? get certifications => throw _privateConstructorUsedError;
  int? get yearsOfExperience => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  int? get totalReviews => throw _privateConstructorUsedError;
  bool? get isVerified => throw _privateConstructorUsedError;
  bool? get isOnline => throw _privateConstructorUsedError;
  DateTime? get lastActiveAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String id,
      String email,
      String firstName,
      String lastName,
      String phoneNumber,
      ServiceProviderType providerType,
      UserStatus status,
      DateTime createdAt,
      DateTime updatedAt,
      String? profileImageUrl,
      String? businessName,
      String? businessRegistrationNumber,
      String? taxNumber,
      String? county,
      String? subCounty,
      String? ward,
      String? address,
      double? latitude,
      double? longitude,
      String? bio,
      List<String>? specializations,
      List<String>? certifications,
      int? yearsOfExperience,
      double? rating,
      int? totalReviews,
      bool? isVerified,
      bool? isOnline,
      DateTime? lastActiveAt,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

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
    Object? phoneNumber = null,
    Object? providerType = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? profileImageUrl = freezed,
    Object? businessName = freezed,
    Object? businessRegistrationNumber = freezed,
    Object? taxNumber = freezed,
    Object? county = freezed,
    Object? subCounty = freezed,
    Object? ward = freezed,
    Object? address = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? bio = freezed,
    Object? specializations = freezed,
    Object? certifications = freezed,
    Object? yearsOfExperience = freezed,
    Object? rating = freezed,
    Object? totalReviews = freezed,
    Object? isVerified = freezed,
    Object? isOnline = freezed,
    Object? lastActiveAt = freezed,
    Object? metadata = freezed,
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
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      providerType: null == providerType
          ? _value.providerType
          : providerType // ignore: cast_nullable_to_non_nullable
              as ServiceProviderType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UserStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      businessName: freezed == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String?,
      businessRegistrationNumber: freezed == businessRegistrationNumber
          ? _value.businessRegistrationNumber
          : businessRegistrationNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      taxNumber: freezed == taxNumber
          ? _value.taxNumber
          : taxNumber // ignore: cast_nullable_to_non_nullable
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
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      specializations: freezed == specializations
          ? _value.specializations
          : specializations // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      certifications: freezed == certifications
          ? _value.certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      yearsOfExperience: freezed == yearsOfExperience
          ? _value.yearsOfExperience
          : yearsOfExperience // ignore: cast_nullable_to_non_nullable
              as int?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      totalReviews: freezed == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int?,
      isVerified: freezed == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      isOnline: freezed == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool?,
      lastActiveAt: freezed == lastActiveAt
          ? _value.lastActiveAt
          : lastActiveAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String firstName,
      String lastName,
      String phoneNumber,
      ServiceProviderType providerType,
      UserStatus status,
      DateTime createdAt,
      DateTime updatedAt,
      String? profileImageUrl,
      String? businessName,
      String? businessRegistrationNumber,
      String? taxNumber,
      String? county,
      String? subCounty,
      String? ward,
      String? address,
      double? latitude,
      double? longitude,
      String? bio,
      List<String>? specializations,
      List<String>? certifications,
      int? yearsOfExperience,
      double? rating,
      int? totalReviews,
      bool? isVerified,
      bool? isOnline,
      DateTime? lastActiveAt,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? phoneNumber = null,
    Object? providerType = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? profileImageUrl = freezed,
    Object? businessName = freezed,
    Object? businessRegistrationNumber = freezed,
    Object? taxNumber = freezed,
    Object? county = freezed,
    Object? subCounty = freezed,
    Object? ward = freezed,
    Object? address = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? bio = freezed,
    Object? specializations = freezed,
    Object? certifications = freezed,
    Object? yearsOfExperience = freezed,
    Object? rating = freezed,
    Object? totalReviews = freezed,
    Object? isVerified = freezed,
    Object? isOnline = freezed,
    Object? lastActiveAt = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$UserImpl(
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
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      providerType: null == providerType
          ? _value.providerType
          : providerType // ignore: cast_nullable_to_non_nullable
              as ServiceProviderType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UserStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      businessName: freezed == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String?,
      businessRegistrationNumber: freezed == businessRegistrationNumber
          ? _value.businessRegistrationNumber
          : businessRegistrationNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      taxNumber: freezed == taxNumber
          ? _value.taxNumber
          : taxNumber // ignore: cast_nullable_to_non_nullable
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
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      specializations: freezed == specializations
          ? _value._specializations
          : specializations // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      certifications: freezed == certifications
          ? _value._certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      yearsOfExperience: freezed == yearsOfExperience
          ? _value.yearsOfExperience
          : yearsOfExperience // ignore: cast_nullable_to_non_nullable
              as int?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      totalReviews: freezed == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int?,
      isVerified: freezed == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      isOnline: freezed == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool?,
      lastActiveAt: freezed == lastActiveAt
          ? _value.lastActiveAt
          : lastActiveAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl(
      {required this.id,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.providerType,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      this.profileImageUrl,
      this.businessName,
      this.businessRegistrationNumber,
      this.taxNumber,
      this.county,
      this.subCounty,
      this.ward,
      this.address,
      this.latitude,
      this.longitude,
      this.bio,
      final List<String>? specializations,
      final List<String>? certifications,
      this.yearsOfExperience,
      this.rating,
      this.totalReviews,
      this.isVerified,
      this.isOnline,
      this.lastActiveAt,
      final Map<String, dynamic>? metadata})
      : _specializations = specializations,
        _certifications = certifications,
        _metadata = metadata;

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String phoneNumber;
  @override
  final ServiceProviderType providerType;
  @override
  final UserStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? profileImageUrl;
  @override
  final String? businessName;
  @override
  final String? businessRegistrationNumber;
  @override
  final String? taxNumber;
  @override
  final String? county;
  @override
  final String? subCounty;
  @override
  final String? ward;
  @override
  final String? address;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String? bio;
  final List<String>? _specializations;
  @override
  List<String>? get specializations {
    final value = _specializations;
    if (value == null) return null;
    if (_specializations is EqualUnmodifiableListView) return _specializations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _certifications;
  @override
  List<String>? get certifications {
    final value = _certifications;
    if (value == null) return null;
    if (_certifications is EqualUnmodifiableListView) return _certifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? yearsOfExperience;
  @override
  final double? rating;
  @override
  final int? totalReviews;
  @override
  final bool? isVerified;
  @override
  final bool? isOnline;
  @override
  final DateTime? lastActiveAt;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, providerType: $providerType, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, profileImageUrl: $profileImageUrl, businessName: $businessName, businessRegistrationNumber: $businessRegistrationNumber, taxNumber: $taxNumber, county: $county, subCounty: $subCounty, ward: $ward, address: $address, latitude: $latitude, longitude: $longitude, bio: $bio, specializations: $specializations, certifications: $certifications, yearsOfExperience: $yearsOfExperience, rating: $rating, totalReviews: $totalReviews, isVerified: $isVerified, isOnline: $isOnline, lastActiveAt: $lastActiveAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.providerType, providerType) ||
                other.providerType == providerType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.businessRegistrationNumber,
                    businessRegistrationNumber) ||
                other.businessRegistrationNumber ==
                    businessRegistrationNumber) &&
            (identical(other.taxNumber, taxNumber) ||
                other.taxNumber == taxNumber) &&
            (identical(other.county, county) || other.county == county) &&
            (identical(other.subCounty, subCounty) ||
                other.subCounty == subCounty) &&
            (identical(other.ward, ward) || other.ward == ward) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            const DeepCollectionEquality()
                .equals(other._specializations, _specializations) &&
            const DeepCollectionEquality()
                .equals(other._certifications, _certifications) &&
            (identical(other.yearsOfExperience, yearsOfExperience) ||
                other.yearsOfExperience == yearsOfExperience) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.lastActiveAt, lastActiveAt) ||
                other.lastActiveAt == lastActiveAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        email,
        firstName,
        lastName,
        phoneNumber,
        providerType,
        status,
        createdAt,
        updatedAt,
        profileImageUrl,
        businessName,
        businessRegistrationNumber,
        taxNumber,
        county,
        subCounty,
        ward,
        address,
        latitude,
        longitude,
        bio,
        const DeepCollectionEquality().hash(_specializations),
        const DeepCollectionEquality().hash(_certifications),
        yearsOfExperience,
        rating,
        totalReviews,
        isVerified,
        isOnline,
        lastActiveAt,
        const DeepCollectionEquality().hash(_metadata)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User implements User {
  const factory _User(
      {required final String id,
      required final String email,
      required final String firstName,
      required final String lastName,
      required final String phoneNumber,
      required final ServiceProviderType providerType,
      required final UserStatus status,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String? profileImageUrl,
      final String? businessName,
      final String? businessRegistrationNumber,
      final String? taxNumber,
      final String? county,
      final String? subCounty,
      final String? ward,
      final String? address,
      final double? latitude,
      final double? longitude,
      final String? bio,
      final List<String>? specializations,
      final List<String>? certifications,
      final int? yearsOfExperience,
      final double? rating,
      final int? totalReviews,
      final bool? isVerified,
      final bool? isOnline,
      final DateTime? lastActiveAt,
      final Map<String, dynamic>? metadata}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String get phoneNumber;
  @override
  ServiceProviderType get providerType;
  @override
  UserStatus get status;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get profileImageUrl;
  @override
  String? get businessName;
  @override
  String? get businessRegistrationNumber;
  @override
  String? get taxNumber;
  @override
  String? get county;
  @override
  String? get subCounty;
  @override
  String? get ward;
  @override
  String? get address;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  String? get bio;
  @override
  List<String>? get specializations;
  @override
  List<String>? get certifications;
  @override
  int? get yearsOfExperience;
  @override
  double? get rating;
  @override
  int? get totalReviews;
  @override
  bool? get isVerified;
  @override
  bool? get isOnline;
  @override
  DateTime? get lastActiveAt;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  String get userId => throw _privateConstructorUsedError;
  String get businessName => throw _privateConstructorUsedError;
  String get businessDescription => throw _privateConstructorUsedError;
  List<String> get serviceCategories => throw _privateConstructorUsedError;
  BusinessHours get businessHours => throw _privateConstructorUsedError;
  ContactInfo get contactInfo => throw _privateConstructorUsedError;
  LocationInfo get locationInfo => throw _privateConstructorUsedError;
  String? get businessLogo => throw _privateConstructorUsedError;
  List<String>? get businessImages => throw _privateConstructorUsedError;
  List<Certification>? get certifications => throw _privateConstructorUsedError;
  List<String>? get languages => throw _privateConstructorUsedError;
  PaymentMethods? get paymentMethods => throw _privateConstructorUsedError;
  SocialMediaLinks? get socialMediaLinks => throw _privateConstructorUsedError;
  BusinessSettings? get settings => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {String userId,
      String businessName,
      String businessDescription,
      List<String> serviceCategories,
      BusinessHours businessHours,
      ContactInfo contactInfo,
      LocationInfo locationInfo,
      String? businessLogo,
      List<String>? businessImages,
      List<Certification>? certifications,
      List<String>? languages,
      PaymentMethods? paymentMethods,
      SocialMediaLinks? socialMediaLinks,
      BusinessSettings? settings,
      DateTime? createdAt,
      DateTime? updatedAt});

  $BusinessHoursCopyWith<$Res> get businessHours;
  $ContactInfoCopyWith<$Res> get contactInfo;
  $LocationInfoCopyWith<$Res> get locationInfo;
  $PaymentMethodsCopyWith<$Res>? get paymentMethods;
  $SocialMediaLinksCopyWith<$Res>? get socialMediaLinks;
  $BusinessSettingsCopyWith<$Res>? get settings;
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? businessName = null,
    Object? businessDescription = null,
    Object? serviceCategories = null,
    Object? businessHours = null,
    Object? contactInfo = null,
    Object? locationInfo = null,
    Object? businessLogo = freezed,
    Object? businessImages = freezed,
    Object? certifications = freezed,
    Object? languages = freezed,
    Object? paymentMethods = freezed,
    Object? socialMediaLinks = freezed,
    Object? settings = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      businessName: null == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String,
      businessDescription: null == businessDescription
          ? _value.businessDescription
          : businessDescription // ignore: cast_nullable_to_non_nullable
              as String,
      serviceCategories: null == serviceCategories
          ? _value.serviceCategories
          : serviceCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      businessHours: null == businessHours
          ? _value.businessHours
          : businessHours // ignore: cast_nullable_to_non_nullable
              as BusinessHours,
      contactInfo: null == contactInfo
          ? _value.contactInfo
          : contactInfo // ignore: cast_nullable_to_non_nullable
              as ContactInfo,
      locationInfo: null == locationInfo
          ? _value.locationInfo
          : locationInfo // ignore: cast_nullable_to_non_nullable
              as LocationInfo,
      businessLogo: freezed == businessLogo
          ? _value.businessLogo
          : businessLogo // ignore: cast_nullable_to_non_nullable
              as String?,
      businessImages: freezed == businessImages
          ? _value.businessImages
          : businessImages // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      certifications: freezed == certifications
          ? _value.certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<Certification>?,
      languages: freezed == languages
          ? _value.languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      paymentMethods: freezed == paymentMethods
          ? _value.paymentMethods
          : paymentMethods // ignore: cast_nullable_to_non_nullable
              as PaymentMethods?,
      socialMediaLinks: freezed == socialMediaLinks
          ? _value.socialMediaLinks
          : socialMediaLinks // ignore: cast_nullable_to_non_nullable
              as SocialMediaLinks?,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as BusinessSettings?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BusinessHoursCopyWith<$Res> get businessHours {
    return $BusinessHoursCopyWith<$Res>(_value.businessHours, (value) {
      return _then(_value.copyWith(businessHours: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ContactInfoCopyWith<$Res> get contactInfo {
    return $ContactInfoCopyWith<$Res>(_value.contactInfo, (value) {
      return _then(_value.copyWith(contactInfo: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $LocationInfoCopyWith<$Res> get locationInfo {
    return $LocationInfoCopyWith<$Res>(_value.locationInfo, (value) {
      return _then(_value.copyWith(locationInfo: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PaymentMethodsCopyWith<$Res>? get paymentMethods {
    if (_value.paymentMethods == null) {
      return null;
    }

    return $PaymentMethodsCopyWith<$Res>(_value.paymentMethods!, (value) {
      return _then(_value.copyWith(paymentMethods: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SocialMediaLinksCopyWith<$Res>? get socialMediaLinks {
    if (_value.socialMediaLinks == null) {
      return null;
    }

    return $SocialMediaLinksCopyWith<$Res>(_value.socialMediaLinks!, (value) {
      return _then(_value.copyWith(socialMediaLinks: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BusinessSettingsCopyWith<$Res>? get settings {
    if (_value.settings == null) {
      return null;
    }

    return $BusinessSettingsCopyWith<$Res>(_value.settings!, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String businessName,
      String businessDescription,
      List<String> serviceCategories,
      BusinessHours businessHours,
      ContactInfo contactInfo,
      LocationInfo locationInfo,
      String? businessLogo,
      List<String>? businessImages,
      List<Certification>? certifications,
      List<String>? languages,
      PaymentMethods? paymentMethods,
      SocialMediaLinks? socialMediaLinks,
      BusinessSettings? settings,
      DateTime? createdAt,
      DateTime? updatedAt});

  @override
  $BusinessHoursCopyWith<$Res> get businessHours;
  @override
  $ContactInfoCopyWith<$Res> get contactInfo;
  @override
  $LocationInfoCopyWith<$Res> get locationInfo;
  @override
  $PaymentMethodsCopyWith<$Res>? get paymentMethods;
  @override
  $SocialMediaLinksCopyWith<$Res>? get socialMediaLinks;
  @override
  $BusinessSettingsCopyWith<$Res>? get settings;
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? businessName = null,
    Object? businessDescription = null,
    Object? serviceCategories = null,
    Object? businessHours = null,
    Object? contactInfo = null,
    Object? locationInfo = null,
    Object? businessLogo = freezed,
    Object? businessImages = freezed,
    Object? certifications = freezed,
    Object? languages = freezed,
    Object? paymentMethods = freezed,
    Object? socialMediaLinks = freezed,
    Object? settings = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UserProfileImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      businessName: null == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String,
      businessDescription: null == businessDescription
          ? _value.businessDescription
          : businessDescription // ignore: cast_nullable_to_non_nullable
              as String,
      serviceCategories: null == serviceCategories
          ? _value._serviceCategories
          : serviceCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      businessHours: null == businessHours
          ? _value.businessHours
          : businessHours // ignore: cast_nullable_to_non_nullable
              as BusinessHours,
      contactInfo: null == contactInfo
          ? _value.contactInfo
          : contactInfo // ignore: cast_nullable_to_non_nullable
              as ContactInfo,
      locationInfo: null == locationInfo
          ? _value.locationInfo
          : locationInfo // ignore: cast_nullable_to_non_nullable
              as LocationInfo,
      businessLogo: freezed == businessLogo
          ? _value.businessLogo
          : businessLogo // ignore: cast_nullable_to_non_nullable
              as String?,
      businessImages: freezed == businessImages
          ? _value._businessImages
          : businessImages // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      certifications: freezed == certifications
          ? _value._certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<Certification>?,
      languages: freezed == languages
          ? _value._languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      paymentMethods: freezed == paymentMethods
          ? _value.paymentMethods
          : paymentMethods // ignore: cast_nullable_to_non_nullable
              as PaymentMethods?,
      socialMediaLinks: freezed == socialMediaLinks
          ? _value.socialMediaLinks
          : socialMediaLinks // ignore: cast_nullable_to_non_nullable
              as SocialMediaLinks?,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as BusinessSettings?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl(
      {required this.userId,
      required this.businessName,
      required this.businessDescription,
      required final List<String> serviceCategories,
      required this.businessHours,
      required this.contactInfo,
      required this.locationInfo,
      this.businessLogo,
      final List<String>? businessImages,
      final List<Certification>? certifications,
      final List<String>? languages,
      this.paymentMethods,
      this.socialMediaLinks,
      this.settings,
      this.createdAt,
      this.updatedAt})
      : _serviceCategories = serviceCategories,
        _businessImages = businessImages,
        _certifications = certifications,
        _languages = languages;

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  final String userId;
  @override
  final String businessName;
  @override
  final String businessDescription;
  final List<String> _serviceCategories;
  @override
  List<String> get serviceCategories {
    if (_serviceCategories is EqualUnmodifiableListView)
      return _serviceCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_serviceCategories);
  }

  @override
  final BusinessHours businessHours;
  @override
  final ContactInfo contactInfo;
  @override
  final LocationInfo locationInfo;
  @override
  final String? businessLogo;
  final List<String>? _businessImages;
  @override
  List<String>? get businessImages {
    final value = _businessImages;
    if (value == null) return null;
    if (_businessImages is EqualUnmodifiableListView) return _businessImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Certification>? _certifications;
  @override
  List<Certification>? get certifications {
    final value = _certifications;
    if (value == null) return null;
    if (_certifications is EqualUnmodifiableListView) return _certifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _languages;
  @override
  List<String>? get languages {
    final value = _languages;
    if (value == null) return null;
    if (_languages is EqualUnmodifiableListView) return _languages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final PaymentMethods? paymentMethods;
  @override
  final SocialMediaLinks? socialMediaLinks;
  @override
  final BusinessSettings? settings;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UserProfile(userId: $userId, businessName: $businessName, businessDescription: $businessDescription, serviceCategories: $serviceCategories, businessHours: $businessHours, contactInfo: $contactInfo, locationInfo: $locationInfo, businessLogo: $businessLogo, businessImages: $businessImages, certifications: $certifications, languages: $languages, paymentMethods: $paymentMethods, socialMediaLinks: $socialMediaLinks, settings: $settings, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.businessDescription, businessDescription) ||
                other.businessDescription == businessDescription) &&
            const DeepCollectionEquality()
                .equals(other._serviceCategories, _serviceCategories) &&
            (identical(other.businessHours, businessHours) ||
                other.businessHours == businessHours) &&
            (identical(other.contactInfo, contactInfo) ||
                other.contactInfo == contactInfo) &&
            (identical(other.locationInfo, locationInfo) ||
                other.locationInfo == locationInfo) &&
            (identical(other.businessLogo, businessLogo) ||
                other.businessLogo == businessLogo) &&
            const DeepCollectionEquality()
                .equals(other._businessImages, _businessImages) &&
            const DeepCollectionEquality()
                .equals(other._certifications, _certifications) &&
            const DeepCollectionEquality()
                .equals(other._languages, _languages) &&
            (identical(other.paymentMethods, paymentMethods) ||
                other.paymentMethods == paymentMethods) &&
            (identical(other.socialMediaLinks, socialMediaLinks) ||
                other.socialMediaLinks == socialMediaLinks) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      businessName,
      businessDescription,
      const DeepCollectionEquality().hash(_serviceCategories),
      businessHours,
      contactInfo,
      locationInfo,
      businessLogo,
      const DeepCollectionEquality().hash(_businessImages),
      const DeepCollectionEquality().hash(_certifications),
      const DeepCollectionEquality().hash(_languages),
      paymentMethods,
      socialMediaLinks,
      settings,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile(
      {required final String userId,
      required final String businessName,
      required final String businessDescription,
      required final List<String> serviceCategories,
      required final BusinessHours businessHours,
      required final ContactInfo contactInfo,
      required final LocationInfo locationInfo,
      final String? businessLogo,
      final List<String>? businessImages,
      final List<Certification>? certifications,
      final List<String>? languages,
      final PaymentMethods? paymentMethods,
      final SocialMediaLinks? socialMediaLinks,
      final BusinessSettings? settings,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  String get userId;
  @override
  String get businessName;
  @override
  String get businessDescription;
  @override
  List<String> get serviceCategories;
  @override
  BusinessHours get businessHours;
  @override
  ContactInfo get contactInfo;
  @override
  LocationInfo get locationInfo;
  @override
  String? get businessLogo;
  @override
  List<String>? get businessImages;
  @override
  List<Certification>? get certifications;
  @override
  List<String>? get languages;
  @override
  PaymentMethods? get paymentMethods;
  @override
  SocialMediaLinks? get socialMediaLinks;
  @override
  BusinessSettings? get settings;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BusinessHours _$BusinessHoursFromJson(Map<String, dynamic> json) {
  return _BusinessHours.fromJson(json);
}

/// @nodoc
mixin _$BusinessHours {
  DaySchedule get monday => throw _privateConstructorUsedError;
  DaySchedule get tuesday => throw _privateConstructorUsedError;
  DaySchedule get wednesday => throw _privateConstructorUsedError;
  DaySchedule get thursday => throw _privateConstructorUsedError;
  DaySchedule get friday => throw _privateConstructorUsedError;
  DaySchedule get saturday => throw _privateConstructorUsedError;
  DaySchedule get sunday => throw _privateConstructorUsedError;
  List<Holiday>? get holidays => throw _privateConstructorUsedError;
  String? get timezone => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BusinessHoursCopyWith<BusinessHours> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessHoursCopyWith<$Res> {
  factory $BusinessHoursCopyWith(
          BusinessHours value, $Res Function(BusinessHours) then) =
      _$BusinessHoursCopyWithImpl<$Res, BusinessHours>;
  @useResult
  $Res call(
      {DaySchedule monday,
      DaySchedule tuesday,
      DaySchedule wednesday,
      DaySchedule thursday,
      DaySchedule friday,
      DaySchedule saturday,
      DaySchedule sunday,
      List<Holiday>? holidays,
      String? timezone});

  $DayScheduleCopyWith<$Res> get monday;
  $DayScheduleCopyWith<$Res> get tuesday;
  $DayScheduleCopyWith<$Res> get wednesday;
  $DayScheduleCopyWith<$Res> get thursday;
  $DayScheduleCopyWith<$Res> get friday;
  $DayScheduleCopyWith<$Res> get saturday;
  $DayScheduleCopyWith<$Res> get sunday;
}

/// @nodoc
class _$BusinessHoursCopyWithImpl<$Res, $Val extends BusinessHours>
    implements $BusinessHoursCopyWith<$Res> {
  _$BusinessHoursCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? monday = null,
    Object? tuesday = null,
    Object? wednesday = null,
    Object? thursday = null,
    Object? friday = null,
    Object? saturday = null,
    Object? sunday = null,
    Object? holidays = freezed,
    Object? timezone = freezed,
  }) {
    return _then(_value.copyWith(
      monday: null == monday
          ? _value.monday
          : monday // ignore: cast_nullable_to_non_nullable
              as DaySchedule,
      tuesday: null == tuesday
          ? _value.tuesday
          : tuesday // ignore: cast_nullable_to_non_nullable
              as DaySchedule,
      wednesday: null == wednesday
          ? _value.wednesday
          : wednesday // ignore: cast_nullable_to_non_nullable
              as DaySchedule,
      thursday: null == thursday
          ? _value.thursday
          : thursday // ignore: cast_nullable_to_non_nullable
              as DaySchedule,
      friday: null == friday
          ? _value.friday
          : friday // ignore: cast_nullable_to_non_nullable
              as DaySchedule,
      saturday: null == saturday
          ? _value.saturday
          : saturday // ignore: cast_nullable_to_non_nullable
              as DaySchedule,
      sunday: null == sunday
          ? _value.sunday
          : sunday // ignore: cast_nullable_to_non_nullable
              as DaySchedule,
      holidays: freezed == holidays
          ? _value.holidays
          : holidays // ignore: cast_nullable_to_non_nullable
              as List<Holiday>?,
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DayScheduleCopyWith<$Res> get monday {
    return $DayScheduleCopyWith<$Res>(_value.monday, (value) {
      return _then(_value.copyWith(monday: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $DayScheduleCopyWith<$Res> get tuesday {
    return $DayScheduleCopyWith<$Res>(_value.tuesday, (value) {
      return _then(_value.copyWith(tuesday: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $DayScheduleCopyWith<$Res> get wednesday {
    return $DayScheduleCopyWith<$Res>(_value.wednesday, (value) {
      return _then(_value.copyWith(wednesday: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $DayScheduleCopyWith<$Res> get thursday {
    return $DayScheduleCopyWith<$Res>(_value.thursday, (value) {
      return _then(_value.copyWith(thursday: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $DayScheduleCopyWith<$Res> get friday {
    return $DayScheduleCopyWith<$Res>(_value.friday, (value) {
      return _then(_value.copyWith(friday: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $DayScheduleCopyWith<$Res> get saturday {
    return $DayScheduleCopyWith<$Res>(_value.saturday, (value) {
      return _then(_value.copyWith(saturday: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $DayScheduleCopyWith<$Res> get sunday {
    return $DayScheduleCopyWith<$Res>(_value.sunday, (value) {
      return _then(_value.copyWith(sunday: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BusinessHoursImplCopyWith<$Res>
    implements $BusinessHoursCopyWith<$Res> {
  factory _$$BusinessHoursImplCopyWith(
          _$BusinessHoursImpl value, $Res Function(_$BusinessHoursImpl) then) =
      __$$BusinessHoursImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DaySchedule monday,
      DaySchedule tuesday,
      DaySchedule wednesday,
      DaySchedule thursday,
      DaySchedule friday,
      DaySchedule saturday,
      DaySchedule sunday,
      List<Holiday>? holidays,
      String? timezone});

  @override
  $DayScheduleCopyWith<$Res> get monday;
  @override
  $DayScheduleCopyWith<$Res> get tuesday;
  @override
  $DayScheduleCopyWith<$Res> get wednesday;
  @override
  $DayScheduleCopyWith<$Res> get thursday;
  @override
  $DayScheduleCopyWith<$Res> get friday;
  @override
  $DayScheduleCopyWith<$Res> get saturday;
  @override
  $DayScheduleCopyWith<$Res> get sunday;
}

/// @nodoc
class __$$BusinessHoursImplCopyWithImpl<$Res>
    extends _$BusinessHoursCopyWithImpl<$Res, _$BusinessHoursImpl>
    implements _$$BusinessHoursImplCopyWith<$Res> {
  __$$BusinessHoursImplCopyWithImpl(
      _$BusinessHoursImpl _value, $Res Function(_$BusinessHoursImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? monday = null,
    Object? tuesday = null,
    Object? wednesday = null,
    Object? thursday = null,
    Object? friday = null,
    Object? saturday = null,
    Object? sunday = null,
    Object? holidays = freezed,
    Object? timezone = freezed,
  }) {
    return _then(_$BusinessHoursImpl(
      monday: null == monday
          ? _value.monday
          : monday // ignore: cast_nullable_to_non_nullable
              as DaySchedule,
      tuesday: null == tuesday
          ? _value.tuesday
          : tuesday // ignore: cast_nullable_to_non_nullable
              as DaySchedule,
      wednesday: null == wednesday
          ? _value.wednesday
          : wednesday // ignore: cast_nullable_to_non_nullable
              as DaySchedule,
      thursday: null == thursday
          ? _value.thursday
          : thursday // ignore: cast_nullable_to_non_nullable
              as DaySchedule,
      friday: null == friday
          ? _value.friday
          : friday // ignore: cast_nullable_to_non_nullable
              as DaySchedule,
      saturday: null == saturday
          ? _value.saturday
          : saturday // ignore: cast_nullable_to_non_nullable
              as DaySchedule,
      sunday: null == sunday
          ? _value.sunday
          : sunday // ignore: cast_nullable_to_non_nullable
              as DaySchedule,
      holidays: freezed == holidays
          ? _value._holidays
          : holidays // ignore: cast_nullable_to_non_nullable
              as List<Holiday>?,
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BusinessHoursImpl implements _BusinessHours {
  const _$BusinessHoursImpl(
      {required this.monday,
      required this.tuesday,
      required this.wednesday,
      required this.thursday,
      required this.friday,
      required this.saturday,
      required this.sunday,
      final List<Holiday>? holidays,
      this.timezone})
      : _holidays = holidays;

  factory _$BusinessHoursImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusinessHoursImplFromJson(json);

  @override
  final DaySchedule monday;
  @override
  final DaySchedule tuesday;
  @override
  final DaySchedule wednesday;
  @override
  final DaySchedule thursday;
  @override
  final DaySchedule friday;
  @override
  final DaySchedule saturday;
  @override
  final DaySchedule sunday;
  final List<Holiday>? _holidays;
  @override
  List<Holiday>? get holidays {
    final value = _holidays;
    if (value == null) return null;
    if (_holidays is EqualUnmodifiableListView) return _holidays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? timezone;

  @override
  String toString() {
    return 'BusinessHours(monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday, saturday: $saturday, sunday: $sunday, holidays: $holidays, timezone: $timezone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessHoursImpl &&
            (identical(other.monday, monday) || other.monday == monday) &&
            (identical(other.tuesday, tuesday) || other.tuesday == tuesday) &&
            (identical(other.wednesday, wednesday) ||
                other.wednesday == wednesday) &&
            (identical(other.thursday, thursday) ||
                other.thursday == thursday) &&
            (identical(other.friday, friday) || other.friday == friday) &&
            (identical(other.saturday, saturday) ||
                other.saturday == saturday) &&
            (identical(other.sunday, sunday) || other.sunday == sunday) &&
            const DeepCollectionEquality().equals(other._holidays, _holidays) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      monday,
      tuesday,
      wednesday,
      thursday,
      friday,
      saturday,
      sunday,
      const DeepCollectionEquality().hash(_holidays),
      timezone);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessHoursImplCopyWith<_$BusinessHoursImpl> get copyWith =>
      __$$BusinessHoursImplCopyWithImpl<_$BusinessHoursImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BusinessHoursImplToJson(
      this,
    );
  }
}

abstract class _BusinessHours implements BusinessHours {
  const factory _BusinessHours(
      {required final DaySchedule monday,
      required final DaySchedule tuesday,
      required final DaySchedule wednesday,
      required final DaySchedule thursday,
      required final DaySchedule friday,
      required final DaySchedule saturday,
      required final DaySchedule sunday,
      final List<Holiday>? holidays,
      final String? timezone}) = _$BusinessHoursImpl;

  factory _BusinessHours.fromJson(Map<String, dynamic> json) =
      _$BusinessHoursImpl.fromJson;

  @override
  DaySchedule get monday;
  @override
  DaySchedule get tuesday;
  @override
  DaySchedule get wednesday;
  @override
  DaySchedule get thursday;
  @override
  DaySchedule get friday;
  @override
  DaySchedule get saturday;
  @override
  DaySchedule get sunday;
  @override
  List<Holiday>? get holidays;
  @override
  String? get timezone;
  @override
  @JsonKey(ignore: true)
  _$$BusinessHoursImplCopyWith<_$BusinessHoursImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DaySchedule _$DayScheduleFromJson(Map<String, dynamic> json) {
  return _DaySchedule.fromJson(json);
}

/// @nodoc
mixin _$DaySchedule {
  bool get isOpen => throw _privateConstructorUsedError;
  String? get openTime => throw _privateConstructorUsedError;
  String? get closeTime => throw _privateConstructorUsedError;
  List<BreakTime>? get breaks => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DayScheduleCopyWith<DaySchedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DayScheduleCopyWith<$Res> {
  factory $DayScheduleCopyWith(
          DaySchedule value, $Res Function(DaySchedule) then) =
      _$DayScheduleCopyWithImpl<$Res, DaySchedule>;
  @useResult
  $Res call(
      {bool isOpen,
      String? openTime,
      String? closeTime,
      List<BreakTime>? breaks});
}

/// @nodoc
class _$DayScheduleCopyWithImpl<$Res, $Val extends DaySchedule>
    implements $DayScheduleCopyWith<$Res> {
  _$DayScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOpen = null,
    Object? openTime = freezed,
    Object? closeTime = freezed,
    Object? breaks = freezed,
  }) {
    return _then(_value.copyWith(
      isOpen: null == isOpen
          ? _value.isOpen
          : isOpen // ignore: cast_nullable_to_non_nullable
              as bool,
      openTime: freezed == openTime
          ? _value.openTime
          : openTime // ignore: cast_nullable_to_non_nullable
              as String?,
      closeTime: freezed == closeTime
          ? _value.closeTime
          : closeTime // ignore: cast_nullable_to_non_nullable
              as String?,
      breaks: freezed == breaks
          ? _value.breaks
          : breaks // ignore: cast_nullable_to_non_nullable
              as List<BreakTime>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DayScheduleImplCopyWith<$Res>
    implements $DayScheduleCopyWith<$Res> {
  factory _$$DayScheduleImplCopyWith(
          _$DayScheduleImpl value, $Res Function(_$DayScheduleImpl) then) =
      __$$DayScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isOpen,
      String? openTime,
      String? closeTime,
      List<BreakTime>? breaks});
}

/// @nodoc
class __$$DayScheduleImplCopyWithImpl<$Res>
    extends _$DayScheduleCopyWithImpl<$Res, _$DayScheduleImpl>
    implements _$$DayScheduleImplCopyWith<$Res> {
  __$$DayScheduleImplCopyWithImpl(
      _$DayScheduleImpl _value, $Res Function(_$DayScheduleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOpen = null,
    Object? openTime = freezed,
    Object? closeTime = freezed,
    Object? breaks = freezed,
  }) {
    return _then(_$DayScheduleImpl(
      isOpen: null == isOpen
          ? _value.isOpen
          : isOpen // ignore: cast_nullable_to_non_nullable
              as bool,
      openTime: freezed == openTime
          ? _value.openTime
          : openTime // ignore: cast_nullable_to_non_nullable
              as String?,
      closeTime: freezed == closeTime
          ? _value.closeTime
          : closeTime // ignore: cast_nullable_to_non_nullable
              as String?,
      breaks: freezed == breaks
          ? _value._breaks
          : breaks // ignore: cast_nullable_to_non_nullable
              as List<BreakTime>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DayScheduleImpl implements _DaySchedule {
  const _$DayScheduleImpl(
      {required this.isOpen,
      this.openTime,
      this.closeTime,
      final List<BreakTime>? breaks})
      : _breaks = breaks;

  factory _$DayScheduleImpl.fromJson(Map<String, dynamic> json) =>
      _$$DayScheduleImplFromJson(json);

  @override
  final bool isOpen;
  @override
  final String? openTime;
  @override
  final String? closeTime;
  final List<BreakTime>? _breaks;
  @override
  List<BreakTime>? get breaks {
    final value = _breaks;
    if (value == null) return null;
    if (_breaks is EqualUnmodifiableListView) return _breaks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'DaySchedule(isOpen: $isOpen, openTime: $openTime, closeTime: $closeTime, breaks: $breaks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DayScheduleImpl &&
            (identical(other.isOpen, isOpen) || other.isOpen == isOpen) &&
            (identical(other.openTime, openTime) ||
                other.openTime == openTime) &&
            (identical(other.closeTime, closeTime) ||
                other.closeTime == closeTime) &&
            const DeepCollectionEquality().equals(other._breaks, _breaks));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, isOpen, openTime, closeTime,
      const DeepCollectionEquality().hash(_breaks));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DayScheduleImplCopyWith<_$DayScheduleImpl> get copyWith =>
      __$$DayScheduleImplCopyWithImpl<_$DayScheduleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DayScheduleImplToJson(
      this,
    );
  }
}

abstract class _DaySchedule implements DaySchedule {
  const factory _DaySchedule(
      {required final bool isOpen,
      final String? openTime,
      final String? closeTime,
      final List<BreakTime>? breaks}) = _$DayScheduleImpl;

  factory _DaySchedule.fromJson(Map<String, dynamic> json) =
      _$DayScheduleImpl.fromJson;

  @override
  bool get isOpen;
  @override
  String? get openTime;
  @override
  String? get closeTime;
  @override
  List<BreakTime>? get breaks;
  @override
  @JsonKey(ignore: true)
  _$$DayScheduleImplCopyWith<_$DayScheduleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BreakTime _$BreakTimeFromJson(Map<String, dynamic> json) {
  return _BreakTime.fromJson(json);
}

/// @nodoc
mixin _$BreakTime {
  String get startTime => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BreakTimeCopyWith<BreakTime> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BreakTimeCopyWith<$Res> {
  factory $BreakTimeCopyWith(BreakTime value, $Res Function(BreakTime) then) =
      _$BreakTimeCopyWithImpl<$Res, BreakTime>;
  @useResult
  $Res call({String startTime, String endTime, String? description});
}

/// @nodoc
class _$BreakTimeCopyWithImpl<$Res, $Val extends BreakTime>
    implements $BreakTimeCopyWith<$Res> {
  _$BreakTimeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? endTime = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BreakTimeImplCopyWith<$Res>
    implements $BreakTimeCopyWith<$Res> {
  factory _$$BreakTimeImplCopyWith(
          _$BreakTimeImpl value, $Res Function(_$BreakTimeImpl) then) =
      __$$BreakTimeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String startTime, String endTime, String? description});
}

/// @nodoc
class __$$BreakTimeImplCopyWithImpl<$Res>
    extends _$BreakTimeCopyWithImpl<$Res, _$BreakTimeImpl>
    implements _$$BreakTimeImplCopyWith<$Res> {
  __$$BreakTimeImplCopyWithImpl(
      _$BreakTimeImpl _value, $Res Function(_$BreakTimeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? endTime = null,
    Object? description = freezed,
  }) {
    return _then(_$BreakTimeImpl(
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BreakTimeImpl implements _BreakTime {
  const _$BreakTimeImpl(
      {required this.startTime, required this.endTime, this.description});

  factory _$BreakTimeImpl.fromJson(Map<String, dynamic> json) =>
      _$$BreakTimeImplFromJson(json);

  @override
  final String startTime;
  @override
  final String endTime;
  @override
  final String? description;

  @override
  String toString() {
    return 'BreakTime(startTime: $startTime, endTime: $endTime, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreakTimeImpl &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, startTime, endTime, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BreakTimeImplCopyWith<_$BreakTimeImpl> get copyWith =>
      __$$BreakTimeImplCopyWithImpl<_$BreakTimeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BreakTimeImplToJson(
      this,
    );
  }
}

abstract class _BreakTime implements BreakTime {
  const factory _BreakTime(
      {required final String startTime,
      required final String endTime,
      final String? description}) = _$BreakTimeImpl;

  factory _BreakTime.fromJson(Map<String, dynamic> json) =
      _$BreakTimeImpl.fromJson;

  @override
  String get startTime;
  @override
  String get endTime;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$$BreakTimeImplCopyWith<_$BreakTimeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Holiday _$HolidayFromJson(Map<String, dynamic> json) {
  return _Holiday.fromJson(json);
}

/// @nodoc
mixin _$Holiday {
  String get name => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool? get isRecurring => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HolidayCopyWith<Holiday> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HolidayCopyWith<$Res> {
  factory $HolidayCopyWith(Holiday value, $Res Function(Holiday) then) =
      _$HolidayCopyWithImpl<$Res, Holiday>;
  @useResult
  $Res call(
      {String name, DateTime date, String? description, bool? isRecurring});
}

/// @nodoc
class _$HolidayCopyWithImpl<$Res, $Val extends Holiday>
    implements $HolidayCopyWith<$Res> {
  _$HolidayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? date = null,
    Object? description = freezed,
    Object? isRecurring = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isRecurring: freezed == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HolidayImplCopyWith<$Res> implements $HolidayCopyWith<$Res> {
  factory _$$HolidayImplCopyWith(
          _$HolidayImpl value, $Res Function(_$HolidayImpl) then) =
      __$$HolidayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name, DateTime date, String? description, bool? isRecurring});
}

/// @nodoc
class __$$HolidayImplCopyWithImpl<$Res>
    extends _$HolidayCopyWithImpl<$Res, _$HolidayImpl>
    implements _$$HolidayImplCopyWith<$Res> {
  __$$HolidayImplCopyWithImpl(
      _$HolidayImpl _value, $Res Function(_$HolidayImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? date = null,
    Object? description = freezed,
    Object? isRecurring = freezed,
  }) {
    return _then(_$HolidayImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      isRecurring: freezed == isRecurring
          ? _value.isRecurring
          : isRecurring // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HolidayImpl implements _Holiday {
  const _$HolidayImpl(
      {required this.name,
      required this.date,
      this.description,
      this.isRecurring});

  factory _$HolidayImpl.fromJson(Map<String, dynamic> json) =>
      _$$HolidayImplFromJson(json);

  @override
  final String name;
  @override
  final DateTime date;
  @override
  final String? description;
  @override
  final bool? isRecurring;

  @override
  String toString() {
    return 'Holiday(name: $name, date: $date, description: $description, isRecurring: $isRecurring)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HolidayImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isRecurring, isRecurring) ||
                other.isRecurring == isRecurring));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, date, description, isRecurring);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HolidayImplCopyWith<_$HolidayImpl> get copyWith =>
      __$$HolidayImplCopyWithImpl<_$HolidayImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HolidayImplToJson(
      this,
    );
  }
}

abstract class _Holiday implements Holiday {
  const factory _Holiday(
      {required final String name,
      required final DateTime date,
      final String? description,
      final bool? isRecurring}) = _$HolidayImpl;

  factory _Holiday.fromJson(Map<String, dynamic> json) = _$HolidayImpl.fromJson;

  @override
  String get name;
  @override
  DateTime get date;
  @override
  String? get description;
  @override
  bool? get isRecurring;
  @override
  @JsonKey(ignore: true)
  _$$HolidayImplCopyWith<_$HolidayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ContactInfo _$ContactInfoFromJson(Map<String, dynamic> json) {
  return _ContactInfo.fromJson(json);
}

/// @nodoc
mixin _$ContactInfo {
  String get primaryPhone => throw _privateConstructorUsedError;
  String? get secondaryPhone => throw _privateConstructorUsedError;
  String? get whatsappNumber => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  String? get facebookPage => throw _privateConstructorUsedError;
  String? get instagramHandle => throw _privateConstructorUsedError;
  String? get twitterHandle => throw _privateConstructorUsedError;
  String? get linkedinProfile => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContactInfoCopyWith<ContactInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactInfoCopyWith<$Res> {
  factory $ContactInfoCopyWith(
          ContactInfo value, $Res Function(ContactInfo) then) =
      _$ContactInfoCopyWithImpl<$Res, ContactInfo>;
  @useResult
  $Res call(
      {String primaryPhone,
      String? secondaryPhone,
      String? whatsappNumber,
      String email,
      String? website,
      String? facebookPage,
      String? instagramHandle,
      String? twitterHandle,
      String? linkedinProfile});
}

/// @nodoc
class _$ContactInfoCopyWithImpl<$Res, $Val extends ContactInfo>
    implements $ContactInfoCopyWith<$Res> {
  _$ContactInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primaryPhone = null,
    Object? secondaryPhone = freezed,
    Object? whatsappNumber = freezed,
    Object? email = null,
    Object? website = freezed,
    Object? facebookPage = freezed,
    Object? instagramHandle = freezed,
    Object? twitterHandle = freezed,
    Object? linkedinProfile = freezed,
  }) {
    return _then(_value.copyWith(
      primaryPhone: null == primaryPhone
          ? _value.primaryPhone
          : primaryPhone // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryPhone: freezed == secondaryPhone
          ? _value.secondaryPhone
          : secondaryPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      whatsappNumber: freezed == whatsappNumber
          ? _value.whatsappNumber
          : whatsappNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      facebookPage: freezed == facebookPage
          ? _value.facebookPage
          : facebookPage // ignore: cast_nullable_to_non_nullable
              as String?,
      instagramHandle: freezed == instagramHandle
          ? _value.instagramHandle
          : instagramHandle // ignore: cast_nullable_to_non_nullable
              as String?,
      twitterHandle: freezed == twitterHandle
          ? _value.twitterHandle
          : twitterHandle // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedinProfile: freezed == linkedinProfile
          ? _value.linkedinProfile
          : linkedinProfile // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactInfoImplCopyWith<$Res>
    implements $ContactInfoCopyWith<$Res> {
  factory _$$ContactInfoImplCopyWith(
          _$ContactInfoImpl value, $Res Function(_$ContactInfoImpl) then) =
      __$$ContactInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String primaryPhone,
      String? secondaryPhone,
      String? whatsappNumber,
      String email,
      String? website,
      String? facebookPage,
      String? instagramHandle,
      String? twitterHandle,
      String? linkedinProfile});
}

/// @nodoc
class __$$ContactInfoImplCopyWithImpl<$Res>
    extends _$ContactInfoCopyWithImpl<$Res, _$ContactInfoImpl>
    implements _$$ContactInfoImplCopyWith<$Res> {
  __$$ContactInfoImplCopyWithImpl(
      _$ContactInfoImpl _value, $Res Function(_$ContactInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? primaryPhone = null,
    Object? secondaryPhone = freezed,
    Object? whatsappNumber = freezed,
    Object? email = null,
    Object? website = freezed,
    Object? facebookPage = freezed,
    Object? instagramHandle = freezed,
    Object? twitterHandle = freezed,
    Object? linkedinProfile = freezed,
  }) {
    return _then(_$ContactInfoImpl(
      primaryPhone: null == primaryPhone
          ? _value.primaryPhone
          : primaryPhone // ignore: cast_nullable_to_non_nullable
              as String,
      secondaryPhone: freezed == secondaryPhone
          ? _value.secondaryPhone
          : secondaryPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      whatsappNumber: freezed == whatsappNumber
          ? _value.whatsappNumber
          : whatsappNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      facebookPage: freezed == facebookPage
          ? _value.facebookPage
          : facebookPage // ignore: cast_nullable_to_non_nullable
              as String?,
      instagramHandle: freezed == instagramHandle
          ? _value.instagramHandle
          : instagramHandle // ignore: cast_nullable_to_non_nullable
              as String?,
      twitterHandle: freezed == twitterHandle
          ? _value.twitterHandle
          : twitterHandle // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedinProfile: freezed == linkedinProfile
          ? _value.linkedinProfile
          : linkedinProfile // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactInfoImpl implements _ContactInfo {
  const _$ContactInfoImpl(
      {required this.primaryPhone,
      this.secondaryPhone,
      this.whatsappNumber,
      required this.email,
      this.website,
      this.facebookPage,
      this.instagramHandle,
      this.twitterHandle,
      this.linkedinProfile});

  factory _$ContactInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactInfoImplFromJson(json);

  @override
  final String primaryPhone;
  @override
  final String? secondaryPhone;
  @override
  final String? whatsappNumber;
  @override
  final String email;
  @override
  final String? website;
  @override
  final String? facebookPage;
  @override
  final String? instagramHandle;
  @override
  final String? twitterHandle;
  @override
  final String? linkedinProfile;

  @override
  String toString() {
    return 'ContactInfo(primaryPhone: $primaryPhone, secondaryPhone: $secondaryPhone, whatsappNumber: $whatsappNumber, email: $email, website: $website, facebookPage: $facebookPage, instagramHandle: $instagramHandle, twitterHandle: $twitterHandle, linkedinProfile: $linkedinProfile)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactInfoImpl &&
            (identical(other.primaryPhone, primaryPhone) ||
                other.primaryPhone == primaryPhone) &&
            (identical(other.secondaryPhone, secondaryPhone) ||
                other.secondaryPhone == secondaryPhone) &&
            (identical(other.whatsappNumber, whatsappNumber) ||
                other.whatsappNumber == whatsappNumber) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.facebookPage, facebookPage) ||
                other.facebookPage == facebookPage) &&
            (identical(other.instagramHandle, instagramHandle) ||
                other.instagramHandle == instagramHandle) &&
            (identical(other.twitterHandle, twitterHandle) ||
                other.twitterHandle == twitterHandle) &&
            (identical(other.linkedinProfile, linkedinProfile) ||
                other.linkedinProfile == linkedinProfile));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      primaryPhone,
      secondaryPhone,
      whatsappNumber,
      email,
      website,
      facebookPage,
      instagramHandle,
      twitterHandle,
      linkedinProfile);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactInfoImplCopyWith<_$ContactInfoImpl> get copyWith =>
      __$$ContactInfoImplCopyWithImpl<_$ContactInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactInfoImplToJson(
      this,
    );
  }
}

abstract class _ContactInfo implements ContactInfo {
  const factory _ContactInfo(
      {required final String primaryPhone,
      final String? secondaryPhone,
      final String? whatsappNumber,
      required final String email,
      final String? website,
      final String? facebookPage,
      final String? instagramHandle,
      final String? twitterHandle,
      final String? linkedinProfile}) = _$ContactInfoImpl;

  factory _ContactInfo.fromJson(Map<String, dynamic> json) =
      _$ContactInfoImpl.fromJson;

  @override
  String get primaryPhone;
  @override
  String? get secondaryPhone;
  @override
  String? get whatsappNumber;
  @override
  String get email;
  @override
  String? get website;
  @override
  String? get facebookPage;
  @override
  String? get instagramHandle;
  @override
  String? get twitterHandle;
  @override
  String? get linkedinProfile;
  @override
  @JsonKey(ignore: true)
  _$$ContactInfoImplCopyWith<_$ContactInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LocationInfo _$LocationInfoFromJson(Map<String, dynamic> json) {
  return _LocationInfo.fromJson(json);
}

/// @nodoc
mixin _$LocationInfo {
  String get county => throw _privateConstructorUsedError;
  String get subCounty => throw _privateConstructorUsedError;
  String get ward => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double? get serviceRadius => throw _privateConstructorUsedError;
  List<String>? get serviceAreas => throw _privateConstructorUsedError;
  String? get landmark => throw _privateConstructorUsedError;
  String? get directions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LocationInfoCopyWith<LocationInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationInfoCopyWith<$Res> {
  factory $LocationInfoCopyWith(
          LocationInfo value, $Res Function(LocationInfo) then) =
      _$LocationInfoCopyWithImpl<$Res, LocationInfo>;
  @useResult
  $Res call(
      {String county,
      String subCounty,
      String ward,
      String address,
      double latitude,
      double longitude,
      double? serviceRadius,
      List<String>? serviceAreas,
      String? landmark,
      String? directions});
}

/// @nodoc
class _$LocationInfoCopyWithImpl<$Res, $Val extends LocationInfo>
    implements $LocationInfoCopyWith<$Res> {
  _$LocationInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? county = null,
    Object? subCounty = null,
    Object? ward = null,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? serviceRadius = freezed,
    Object? serviceAreas = freezed,
    Object? landmark = freezed,
    Object? directions = freezed,
  }) {
    return _then(_value.copyWith(
      county: null == county
          ? _value.county
          : county // ignore: cast_nullable_to_non_nullable
              as String,
      subCounty: null == subCounty
          ? _value.subCounty
          : subCounty // ignore: cast_nullable_to_non_nullable
              as String,
      ward: null == ward
          ? _value.ward
          : ward // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      serviceRadius: freezed == serviceRadius
          ? _value.serviceRadius
          : serviceRadius // ignore: cast_nullable_to_non_nullable
              as double?,
      serviceAreas: freezed == serviceAreas
          ? _value.serviceAreas
          : serviceAreas // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      landmark: freezed == landmark
          ? _value.landmark
          : landmark // ignore: cast_nullable_to_non_nullable
              as String?,
      directions: freezed == directions
          ? _value.directions
          : directions // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocationInfoImplCopyWith<$Res>
    implements $LocationInfoCopyWith<$Res> {
  factory _$$LocationInfoImplCopyWith(
          _$LocationInfoImpl value, $Res Function(_$LocationInfoImpl) then) =
      __$$LocationInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String county,
      String subCounty,
      String ward,
      String address,
      double latitude,
      double longitude,
      double? serviceRadius,
      List<String>? serviceAreas,
      String? landmark,
      String? directions});
}

/// @nodoc
class __$$LocationInfoImplCopyWithImpl<$Res>
    extends _$LocationInfoCopyWithImpl<$Res, _$LocationInfoImpl>
    implements _$$LocationInfoImplCopyWith<$Res> {
  __$$LocationInfoImplCopyWithImpl(
      _$LocationInfoImpl _value, $Res Function(_$LocationInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? county = null,
    Object? subCounty = null,
    Object? ward = null,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? serviceRadius = freezed,
    Object? serviceAreas = freezed,
    Object? landmark = freezed,
    Object? directions = freezed,
  }) {
    return _then(_$LocationInfoImpl(
      county: null == county
          ? _value.county
          : county // ignore: cast_nullable_to_non_nullable
              as String,
      subCounty: null == subCounty
          ? _value.subCounty
          : subCounty // ignore: cast_nullable_to_non_nullable
              as String,
      ward: null == ward
          ? _value.ward
          : ward // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      serviceRadius: freezed == serviceRadius
          ? _value.serviceRadius
          : serviceRadius // ignore: cast_nullable_to_non_nullable
              as double?,
      serviceAreas: freezed == serviceAreas
          ? _value._serviceAreas
          : serviceAreas // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      landmark: freezed == landmark
          ? _value.landmark
          : landmark // ignore: cast_nullable_to_non_nullable
              as String?,
      directions: freezed == directions
          ? _value.directions
          : directions // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationInfoImpl implements _LocationInfo {
  const _$LocationInfoImpl(
      {required this.county,
      required this.subCounty,
      required this.ward,
      required this.address,
      required this.latitude,
      required this.longitude,
      this.serviceRadius,
      final List<String>? serviceAreas,
      this.landmark,
      this.directions})
      : _serviceAreas = serviceAreas;

  factory _$LocationInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationInfoImplFromJson(json);

  @override
  final String county;
  @override
  final String subCounty;
  @override
  final String ward;
  @override
  final String address;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double? serviceRadius;
  final List<String>? _serviceAreas;
  @override
  List<String>? get serviceAreas {
    final value = _serviceAreas;
    if (value == null) return null;
    if (_serviceAreas is EqualUnmodifiableListView) return _serviceAreas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? landmark;
  @override
  final String? directions;

  @override
  String toString() {
    return 'LocationInfo(county: $county, subCounty: $subCounty, ward: $ward, address: $address, latitude: $latitude, longitude: $longitude, serviceRadius: $serviceRadius, serviceAreas: $serviceAreas, landmark: $landmark, directions: $directions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationInfoImpl &&
            (identical(other.county, county) || other.county == county) &&
            (identical(other.subCounty, subCounty) ||
                other.subCounty == subCounty) &&
            (identical(other.ward, ward) || other.ward == ward) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.serviceRadius, serviceRadius) ||
                other.serviceRadius == serviceRadius) &&
            const DeepCollectionEquality()
                .equals(other._serviceAreas, _serviceAreas) &&
            (identical(other.landmark, landmark) ||
                other.landmark == landmark) &&
            (identical(other.directions, directions) ||
                other.directions == directions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      county,
      subCounty,
      ward,
      address,
      latitude,
      longitude,
      serviceRadius,
      const DeepCollectionEquality().hash(_serviceAreas),
      landmark,
      directions);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationInfoImplCopyWith<_$LocationInfoImpl> get copyWith =>
      __$$LocationInfoImplCopyWithImpl<_$LocationInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationInfoImplToJson(
      this,
    );
  }
}

abstract class _LocationInfo implements LocationInfo {
  const factory _LocationInfo(
      {required final String county,
      required final String subCounty,
      required final String ward,
      required final String address,
      required final double latitude,
      required final double longitude,
      final double? serviceRadius,
      final List<String>? serviceAreas,
      final String? landmark,
      final String? directions}) = _$LocationInfoImpl;

  factory _LocationInfo.fromJson(Map<String, dynamic> json) =
      _$LocationInfoImpl.fromJson;

  @override
  String get county;
  @override
  String get subCounty;
  @override
  String get ward;
  @override
  String get address;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double? get serviceRadius;
  @override
  List<String>? get serviceAreas;
  @override
  String? get landmark;
  @override
  String? get directions;
  @override
  @JsonKey(ignore: true)
  _$$LocationInfoImplCopyWith<_$LocationInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Certification _$CertificationFromJson(Map<String, dynamic> json) {
  return _Certification.fromJson(json);
}

/// @nodoc
mixin _$Certification {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get issuingOrganization => throw _privateConstructorUsedError;
  DateTime get issueDate => throw _privateConstructorUsedError;
  DateTime? get expiryDate => throw _privateConstructorUsedError;
  String? get certificateNumber => throw _privateConstructorUsedError;
  String? get certificateUrl => throw _privateConstructorUsedError;
  bool? get isVerified => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CertificationCopyWith<Certification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CertificationCopyWith<$Res> {
  factory $CertificationCopyWith(
          Certification value, $Res Function(Certification) then) =
      _$CertificationCopyWithImpl<$Res, Certification>;
  @useResult
  $Res call(
      {String id,
      String name,
      String issuingOrganization,
      DateTime issueDate,
      DateTime? expiryDate,
      String? certificateNumber,
      String? certificateUrl,
      bool? isVerified});
}

/// @nodoc
class _$CertificationCopyWithImpl<$Res, $Val extends Certification>
    implements $CertificationCopyWith<$Res> {
  _$CertificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? issuingOrganization = null,
    Object? issueDate = null,
    Object? expiryDate = freezed,
    Object? certificateNumber = freezed,
    Object? certificateUrl = freezed,
    Object? isVerified = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      issuingOrganization: null == issuingOrganization
          ? _value.issuingOrganization
          : issuingOrganization // ignore: cast_nullable_to_non_nullable
              as String,
      issueDate: null == issueDate
          ? _value.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      certificateNumber: freezed == certificateNumber
          ? _value.certificateNumber
          : certificateNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      certificateUrl: freezed == certificateUrl
          ? _value.certificateUrl
          : certificateUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: freezed == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CertificationImplCopyWith<$Res>
    implements $CertificationCopyWith<$Res> {
  factory _$$CertificationImplCopyWith(
          _$CertificationImpl value, $Res Function(_$CertificationImpl) then) =
      __$$CertificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String issuingOrganization,
      DateTime issueDate,
      DateTime? expiryDate,
      String? certificateNumber,
      String? certificateUrl,
      bool? isVerified});
}

/// @nodoc
class __$$CertificationImplCopyWithImpl<$Res>
    extends _$CertificationCopyWithImpl<$Res, _$CertificationImpl>
    implements _$$CertificationImplCopyWith<$Res> {
  __$$CertificationImplCopyWithImpl(
      _$CertificationImpl _value, $Res Function(_$CertificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? issuingOrganization = null,
    Object? issueDate = null,
    Object? expiryDate = freezed,
    Object? certificateNumber = freezed,
    Object? certificateUrl = freezed,
    Object? isVerified = freezed,
  }) {
    return _then(_$CertificationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      issuingOrganization: null == issuingOrganization
          ? _value.issuingOrganization
          : issuingOrganization // ignore: cast_nullable_to_non_nullable
              as String,
      issueDate: null == issueDate
          ? _value.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      certificateNumber: freezed == certificateNumber
          ? _value.certificateNumber
          : certificateNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      certificateUrl: freezed == certificateUrl
          ? _value.certificateUrl
          : certificateUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: freezed == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CertificationImpl implements _Certification {
  const _$CertificationImpl(
      {required this.id,
      required this.name,
      required this.issuingOrganization,
      required this.issueDate,
      this.expiryDate,
      this.certificateNumber,
      this.certificateUrl,
      this.isVerified});

  factory _$CertificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$CertificationImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String issuingOrganization;
  @override
  final DateTime issueDate;
  @override
  final DateTime? expiryDate;
  @override
  final String? certificateNumber;
  @override
  final String? certificateUrl;
  @override
  final bool? isVerified;

  @override
  String toString() {
    return 'Certification(id: $id, name: $name, issuingOrganization: $issuingOrganization, issueDate: $issueDate, expiryDate: $expiryDate, certificateNumber: $certificateNumber, certificateUrl: $certificateUrl, isVerified: $isVerified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CertificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.issuingOrganization, issuingOrganization) ||
                other.issuingOrganization == issuingOrganization) &&
            (identical(other.issueDate, issueDate) ||
                other.issueDate == issueDate) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.certificateNumber, certificateNumber) ||
                other.certificateNumber == certificateNumber) &&
            (identical(other.certificateUrl, certificateUrl) ||
                other.certificateUrl == certificateUrl) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, issuingOrganization,
      issueDate, expiryDate, certificateNumber, certificateUrl, isVerified);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CertificationImplCopyWith<_$CertificationImpl> get copyWith =>
      __$$CertificationImplCopyWithImpl<_$CertificationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CertificationImplToJson(
      this,
    );
  }
}

abstract class _Certification implements Certification {
  const factory _Certification(
      {required final String id,
      required final String name,
      required final String issuingOrganization,
      required final DateTime issueDate,
      final DateTime? expiryDate,
      final String? certificateNumber,
      final String? certificateUrl,
      final bool? isVerified}) = _$CertificationImpl;

  factory _Certification.fromJson(Map<String, dynamic> json) =
      _$CertificationImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get issuingOrganization;
  @override
  DateTime get issueDate;
  @override
  DateTime? get expiryDate;
  @override
  String? get certificateNumber;
  @override
  String? get certificateUrl;
  @override
  bool? get isVerified;
  @override
  @JsonKey(ignore: true)
  _$$CertificationImplCopyWith<_$CertificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaymentMethods _$PaymentMethodsFromJson(Map<String, dynamic> json) {
  return _PaymentMethods.fromJson(json);
}

/// @nodoc
mixin _$PaymentMethods {
  bool? get acceptsCash => throw _privateConstructorUsedError;
  bool? get acceptsMpesa => throw _privateConstructorUsedError;
  bool? get acceptsBankTransfer => throw _privateConstructorUsedError;
  bool? get acceptsCard => throw _privateConstructorUsedError;
  String? get mpesaNumber => throw _privateConstructorUsedError;
  String? get bankName => throw _privateConstructorUsedError;
  String? get accountNumber => throw _privateConstructorUsedError;
  String? get accountName => throw _privateConstructorUsedError;
  List<String>? get supportedCards => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaymentMethodsCopyWith<PaymentMethods> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentMethodsCopyWith<$Res> {
  factory $PaymentMethodsCopyWith(
          PaymentMethods value, $Res Function(PaymentMethods) then) =
      _$PaymentMethodsCopyWithImpl<$Res, PaymentMethods>;
  @useResult
  $Res call(
      {bool? acceptsCash,
      bool? acceptsMpesa,
      bool? acceptsBankTransfer,
      bool? acceptsCard,
      String? mpesaNumber,
      String? bankName,
      String? accountNumber,
      String? accountName,
      List<String>? supportedCards});
}

/// @nodoc
class _$PaymentMethodsCopyWithImpl<$Res, $Val extends PaymentMethods>
    implements $PaymentMethodsCopyWith<$Res> {
  _$PaymentMethodsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? acceptsCash = freezed,
    Object? acceptsMpesa = freezed,
    Object? acceptsBankTransfer = freezed,
    Object? acceptsCard = freezed,
    Object? mpesaNumber = freezed,
    Object? bankName = freezed,
    Object? accountNumber = freezed,
    Object? accountName = freezed,
    Object? supportedCards = freezed,
  }) {
    return _then(_value.copyWith(
      acceptsCash: freezed == acceptsCash
          ? _value.acceptsCash
          : acceptsCash // ignore: cast_nullable_to_non_nullable
              as bool?,
      acceptsMpesa: freezed == acceptsMpesa
          ? _value.acceptsMpesa
          : acceptsMpesa // ignore: cast_nullable_to_non_nullable
              as bool?,
      acceptsBankTransfer: freezed == acceptsBankTransfer
          ? _value.acceptsBankTransfer
          : acceptsBankTransfer // ignore: cast_nullable_to_non_nullable
              as bool?,
      acceptsCard: freezed == acceptsCard
          ? _value.acceptsCard
          : acceptsCard // ignore: cast_nullable_to_non_nullable
              as bool?,
      mpesaNumber: freezed == mpesaNumber
          ? _value.mpesaNumber
          : mpesaNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      accountNumber: freezed == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      accountName: freezed == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String?,
      supportedCards: freezed == supportedCards
          ? _value.supportedCards
          : supportedCards // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentMethodsImplCopyWith<$Res>
    implements $PaymentMethodsCopyWith<$Res> {
  factory _$$PaymentMethodsImplCopyWith(_$PaymentMethodsImpl value,
          $Res Function(_$PaymentMethodsImpl) then) =
      __$$PaymentMethodsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool? acceptsCash,
      bool? acceptsMpesa,
      bool? acceptsBankTransfer,
      bool? acceptsCard,
      String? mpesaNumber,
      String? bankName,
      String? accountNumber,
      String? accountName,
      List<String>? supportedCards});
}

/// @nodoc
class __$$PaymentMethodsImplCopyWithImpl<$Res>
    extends _$PaymentMethodsCopyWithImpl<$Res, _$PaymentMethodsImpl>
    implements _$$PaymentMethodsImplCopyWith<$Res> {
  __$$PaymentMethodsImplCopyWithImpl(
      _$PaymentMethodsImpl _value, $Res Function(_$PaymentMethodsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? acceptsCash = freezed,
    Object? acceptsMpesa = freezed,
    Object? acceptsBankTransfer = freezed,
    Object? acceptsCard = freezed,
    Object? mpesaNumber = freezed,
    Object? bankName = freezed,
    Object? accountNumber = freezed,
    Object? accountName = freezed,
    Object? supportedCards = freezed,
  }) {
    return _then(_$PaymentMethodsImpl(
      acceptsCash: freezed == acceptsCash
          ? _value.acceptsCash
          : acceptsCash // ignore: cast_nullable_to_non_nullable
              as bool?,
      acceptsMpesa: freezed == acceptsMpesa
          ? _value.acceptsMpesa
          : acceptsMpesa // ignore: cast_nullable_to_non_nullable
              as bool?,
      acceptsBankTransfer: freezed == acceptsBankTransfer
          ? _value.acceptsBankTransfer
          : acceptsBankTransfer // ignore: cast_nullable_to_non_nullable
              as bool?,
      acceptsCard: freezed == acceptsCard
          ? _value.acceptsCard
          : acceptsCard // ignore: cast_nullable_to_non_nullable
              as bool?,
      mpesaNumber: freezed == mpesaNumber
          ? _value.mpesaNumber
          : mpesaNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      accountNumber: freezed == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      accountName: freezed == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String?,
      supportedCards: freezed == supportedCards
          ? _value._supportedCards
          : supportedCards // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentMethodsImpl implements _PaymentMethods {
  const _$PaymentMethodsImpl(
      {this.acceptsCash,
      this.acceptsMpesa,
      this.acceptsBankTransfer,
      this.acceptsCard,
      this.mpesaNumber,
      this.bankName,
      this.accountNumber,
      this.accountName,
      final List<String>? supportedCards})
      : _supportedCards = supportedCards;

  factory _$PaymentMethodsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentMethodsImplFromJson(json);

  @override
  final bool? acceptsCash;
  @override
  final bool? acceptsMpesa;
  @override
  final bool? acceptsBankTransfer;
  @override
  final bool? acceptsCard;
  @override
  final String? mpesaNumber;
  @override
  final String? bankName;
  @override
  final String? accountNumber;
  @override
  final String? accountName;
  final List<String>? _supportedCards;
  @override
  List<String>? get supportedCards {
    final value = _supportedCards;
    if (value == null) return null;
    if (_supportedCards is EqualUnmodifiableListView) return _supportedCards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PaymentMethods(acceptsCash: $acceptsCash, acceptsMpesa: $acceptsMpesa, acceptsBankTransfer: $acceptsBankTransfer, acceptsCard: $acceptsCard, mpesaNumber: $mpesaNumber, bankName: $bankName, accountNumber: $accountNumber, accountName: $accountName, supportedCards: $supportedCards)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentMethodsImpl &&
            (identical(other.acceptsCash, acceptsCash) ||
                other.acceptsCash == acceptsCash) &&
            (identical(other.acceptsMpesa, acceptsMpesa) ||
                other.acceptsMpesa == acceptsMpesa) &&
            (identical(other.acceptsBankTransfer, acceptsBankTransfer) ||
                other.acceptsBankTransfer == acceptsBankTransfer) &&
            (identical(other.acceptsCard, acceptsCard) ||
                other.acceptsCard == acceptsCard) &&
            (identical(other.mpesaNumber, mpesaNumber) ||
                other.mpesaNumber == mpesaNumber) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            const DeepCollectionEquality()
                .equals(other._supportedCards, _supportedCards));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      acceptsCash,
      acceptsMpesa,
      acceptsBankTransfer,
      acceptsCard,
      mpesaNumber,
      bankName,
      accountNumber,
      accountName,
      const DeepCollectionEquality().hash(_supportedCards));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentMethodsImplCopyWith<_$PaymentMethodsImpl> get copyWith =>
      __$$PaymentMethodsImplCopyWithImpl<_$PaymentMethodsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentMethodsImplToJson(
      this,
    );
  }
}

abstract class _PaymentMethods implements PaymentMethods {
  const factory _PaymentMethods(
      {final bool? acceptsCash,
      final bool? acceptsMpesa,
      final bool? acceptsBankTransfer,
      final bool? acceptsCard,
      final String? mpesaNumber,
      final String? bankName,
      final String? accountNumber,
      final String? accountName,
      final List<String>? supportedCards}) = _$PaymentMethodsImpl;

  factory _PaymentMethods.fromJson(Map<String, dynamic> json) =
      _$PaymentMethodsImpl.fromJson;

  @override
  bool? get acceptsCash;
  @override
  bool? get acceptsMpesa;
  @override
  bool? get acceptsBankTransfer;
  @override
  bool? get acceptsCard;
  @override
  String? get mpesaNumber;
  @override
  String? get bankName;
  @override
  String? get accountNumber;
  @override
  String? get accountName;
  @override
  List<String>? get supportedCards;
  @override
  @JsonKey(ignore: true)
  _$$PaymentMethodsImplCopyWith<_$PaymentMethodsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SocialMediaLinks _$SocialMediaLinksFromJson(Map<String, dynamic> json) {
  return _SocialMediaLinks.fromJson(json);
}

/// @nodoc
mixin _$SocialMediaLinks {
  String? get facebook => throw _privateConstructorUsedError;
  String? get instagram => throw _privateConstructorUsedError;
  String? get twitter => throw _privateConstructorUsedError;
  String? get linkedin => throw _privateConstructorUsedError;
  String? get youtube => throw _privateConstructorUsedError;
  String? get tiktok => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SocialMediaLinksCopyWith<SocialMediaLinks> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialMediaLinksCopyWith<$Res> {
  factory $SocialMediaLinksCopyWith(
          SocialMediaLinks value, $Res Function(SocialMediaLinks) then) =
      _$SocialMediaLinksCopyWithImpl<$Res, SocialMediaLinks>;
  @useResult
  $Res call(
      {String? facebook,
      String? instagram,
      String? twitter,
      String? linkedin,
      String? youtube,
      String? tiktok,
      String? website});
}

/// @nodoc
class _$SocialMediaLinksCopyWithImpl<$Res, $Val extends SocialMediaLinks>
    implements $SocialMediaLinksCopyWith<$Res> {
  _$SocialMediaLinksCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? facebook = freezed,
    Object? instagram = freezed,
    Object? twitter = freezed,
    Object? linkedin = freezed,
    Object? youtube = freezed,
    Object? tiktok = freezed,
    Object? website = freezed,
  }) {
    return _then(_value.copyWith(
      facebook: freezed == facebook
          ? _value.facebook
          : facebook // ignore: cast_nullable_to_non_nullable
              as String?,
      instagram: freezed == instagram
          ? _value.instagram
          : instagram // ignore: cast_nullable_to_non_nullable
              as String?,
      twitter: freezed == twitter
          ? _value.twitter
          : twitter // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedin: freezed == linkedin
          ? _value.linkedin
          : linkedin // ignore: cast_nullable_to_non_nullable
              as String?,
      youtube: freezed == youtube
          ? _value.youtube
          : youtube // ignore: cast_nullable_to_non_nullable
              as String?,
      tiktok: freezed == tiktok
          ? _value.tiktok
          : tiktok // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SocialMediaLinksImplCopyWith<$Res>
    implements $SocialMediaLinksCopyWith<$Res> {
  factory _$$SocialMediaLinksImplCopyWith(_$SocialMediaLinksImpl value,
          $Res Function(_$SocialMediaLinksImpl) then) =
      __$$SocialMediaLinksImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? facebook,
      String? instagram,
      String? twitter,
      String? linkedin,
      String? youtube,
      String? tiktok,
      String? website});
}

/// @nodoc
class __$$SocialMediaLinksImplCopyWithImpl<$Res>
    extends _$SocialMediaLinksCopyWithImpl<$Res, _$SocialMediaLinksImpl>
    implements _$$SocialMediaLinksImplCopyWith<$Res> {
  __$$SocialMediaLinksImplCopyWithImpl(_$SocialMediaLinksImpl _value,
      $Res Function(_$SocialMediaLinksImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? facebook = freezed,
    Object? instagram = freezed,
    Object? twitter = freezed,
    Object? linkedin = freezed,
    Object? youtube = freezed,
    Object? tiktok = freezed,
    Object? website = freezed,
  }) {
    return _then(_$SocialMediaLinksImpl(
      facebook: freezed == facebook
          ? _value.facebook
          : facebook // ignore: cast_nullable_to_non_nullable
              as String?,
      instagram: freezed == instagram
          ? _value.instagram
          : instagram // ignore: cast_nullable_to_non_nullable
              as String?,
      twitter: freezed == twitter
          ? _value.twitter
          : twitter // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedin: freezed == linkedin
          ? _value.linkedin
          : linkedin // ignore: cast_nullable_to_non_nullable
              as String?,
      youtube: freezed == youtube
          ? _value.youtube
          : youtube // ignore: cast_nullable_to_non_nullable
              as String?,
      tiktok: freezed == tiktok
          ? _value.tiktok
          : tiktok // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SocialMediaLinksImpl implements _SocialMediaLinks {
  const _$SocialMediaLinksImpl(
      {this.facebook,
      this.instagram,
      this.twitter,
      this.linkedin,
      this.youtube,
      this.tiktok,
      this.website});

  factory _$SocialMediaLinksImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialMediaLinksImplFromJson(json);

  @override
  final String? facebook;
  @override
  final String? instagram;
  @override
  final String? twitter;
  @override
  final String? linkedin;
  @override
  final String? youtube;
  @override
  final String? tiktok;
  @override
  final String? website;

  @override
  String toString() {
    return 'SocialMediaLinks(facebook: $facebook, instagram: $instagram, twitter: $twitter, linkedin: $linkedin, youtube: $youtube, tiktok: $tiktok, website: $website)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialMediaLinksImpl &&
            (identical(other.facebook, facebook) ||
                other.facebook == facebook) &&
            (identical(other.instagram, instagram) ||
                other.instagram == instagram) &&
            (identical(other.twitter, twitter) || other.twitter == twitter) &&
            (identical(other.linkedin, linkedin) ||
                other.linkedin == linkedin) &&
            (identical(other.youtube, youtube) || other.youtube == youtube) &&
            (identical(other.tiktok, tiktok) || other.tiktok == tiktok) &&
            (identical(other.website, website) || other.website == website));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, facebook, instagram, twitter,
      linkedin, youtube, tiktok, website);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialMediaLinksImplCopyWith<_$SocialMediaLinksImpl> get copyWith =>
      __$$SocialMediaLinksImplCopyWithImpl<_$SocialMediaLinksImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialMediaLinksImplToJson(
      this,
    );
  }
}

abstract class _SocialMediaLinks implements SocialMediaLinks {
  const factory _SocialMediaLinks(
      {final String? facebook,
      final String? instagram,
      final String? twitter,
      final String? linkedin,
      final String? youtube,
      final String? tiktok,
      final String? website}) = _$SocialMediaLinksImpl;

  factory _SocialMediaLinks.fromJson(Map<String, dynamic> json) =
      _$SocialMediaLinksImpl.fromJson;

  @override
  String? get facebook;
  @override
  String? get instagram;
  @override
  String? get twitter;
  @override
  String? get linkedin;
  @override
  String? get youtube;
  @override
  String? get tiktok;
  @override
  String? get website;
  @override
  @JsonKey(ignore: true)
  _$$SocialMediaLinksImplCopyWith<_$SocialMediaLinksImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BusinessSettings _$BusinessSettingsFromJson(Map<String, dynamic> json) {
  return _BusinessSettings.fromJson(json);
}

/// @nodoc
mixin _$BusinessSettings {
  bool? get autoAcceptBookings => throw _privateConstructorUsedError;
  int? get maxBookingsPerDay => throw _privateConstructorUsedError;
  int? get advanceBookingDays => throw _privateConstructorUsedError;
  int? get cancellationHours => throw _privateConstructorUsedError;
  bool? get requireDeposit => throw _privateConstructorUsedError;
  double? get depositPercentage => throw _privateConstructorUsedError;
  bool? get sendReminders => throw _privateConstructorUsedError;
  int? get reminderHours => throw _privateConstructorUsedError;
  bool? get allowOnlinePayment => throw _privateConstructorUsedError;
  bool? get allowInstantBooking => throw _privateConstructorUsedError;
  String? get cancellationPolicy => throw _privateConstructorUsedError;
  String? get refundPolicy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BusinessSettingsCopyWith<BusinessSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessSettingsCopyWith<$Res> {
  factory $BusinessSettingsCopyWith(
          BusinessSettings value, $Res Function(BusinessSettings) then) =
      _$BusinessSettingsCopyWithImpl<$Res, BusinessSettings>;
  @useResult
  $Res call(
      {bool? autoAcceptBookings,
      int? maxBookingsPerDay,
      int? advanceBookingDays,
      int? cancellationHours,
      bool? requireDeposit,
      double? depositPercentage,
      bool? sendReminders,
      int? reminderHours,
      bool? allowOnlinePayment,
      bool? allowInstantBooking,
      String? cancellationPolicy,
      String? refundPolicy});
}

/// @nodoc
class _$BusinessSettingsCopyWithImpl<$Res, $Val extends BusinessSettings>
    implements $BusinessSettingsCopyWith<$Res> {
  _$BusinessSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? autoAcceptBookings = freezed,
    Object? maxBookingsPerDay = freezed,
    Object? advanceBookingDays = freezed,
    Object? cancellationHours = freezed,
    Object? requireDeposit = freezed,
    Object? depositPercentage = freezed,
    Object? sendReminders = freezed,
    Object? reminderHours = freezed,
    Object? allowOnlinePayment = freezed,
    Object? allowInstantBooking = freezed,
    Object? cancellationPolicy = freezed,
    Object? refundPolicy = freezed,
  }) {
    return _then(_value.copyWith(
      autoAcceptBookings: freezed == autoAcceptBookings
          ? _value.autoAcceptBookings
          : autoAcceptBookings // ignore: cast_nullable_to_non_nullable
              as bool?,
      maxBookingsPerDay: freezed == maxBookingsPerDay
          ? _value.maxBookingsPerDay
          : maxBookingsPerDay // ignore: cast_nullable_to_non_nullable
              as int?,
      advanceBookingDays: freezed == advanceBookingDays
          ? _value.advanceBookingDays
          : advanceBookingDays // ignore: cast_nullable_to_non_nullable
              as int?,
      cancellationHours: freezed == cancellationHours
          ? _value.cancellationHours
          : cancellationHours // ignore: cast_nullable_to_non_nullable
              as int?,
      requireDeposit: freezed == requireDeposit
          ? _value.requireDeposit
          : requireDeposit // ignore: cast_nullable_to_non_nullable
              as bool?,
      depositPercentage: freezed == depositPercentage
          ? _value.depositPercentage
          : depositPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      sendReminders: freezed == sendReminders
          ? _value.sendReminders
          : sendReminders // ignore: cast_nullable_to_non_nullable
              as bool?,
      reminderHours: freezed == reminderHours
          ? _value.reminderHours
          : reminderHours // ignore: cast_nullable_to_non_nullable
              as int?,
      allowOnlinePayment: freezed == allowOnlinePayment
          ? _value.allowOnlinePayment
          : allowOnlinePayment // ignore: cast_nullable_to_non_nullable
              as bool?,
      allowInstantBooking: freezed == allowInstantBooking
          ? _value.allowInstantBooking
          : allowInstantBooking // ignore: cast_nullable_to_non_nullable
              as bool?,
      cancellationPolicy: freezed == cancellationPolicy
          ? _value.cancellationPolicy
          : cancellationPolicy // ignore: cast_nullable_to_non_nullable
              as String?,
      refundPolicy: freezed == refundPolicy
          ? _value.refundPolicy
          : refundPolicy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BusinessSettingsImplCopyWith<$Res>
    implements $BusinessSettingsCopyWith<$Res> {
  factory _$$BusinessSettingsImplCopyWith(_$BusinessSettingsImpl value,
          $Res Function(_$BusinessSettingsImpl) then) =
      __$$BusinessSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool? autoAcceptBookings,
      int? maxBookingsPerDay,
      int? advanceBookingDays,
      int? cancellationHours,
      bool? requireDeposit,
      double? depositPercentage,
      bool? sendReminders,
      int? reminderHours,
      bool? allowOnlinePayment,
      bool? allowInstantBooking,
      String? cancellationPolicy,
      String? refundPolicy});
}

/// @nodoc
class __$$BusinessSettingsImplCopyWithImpl<$Res>
    extends _$BusinessSettingsCopyWithImpl<$Res, _$BusinessSettingsImpl>
    implements _$$BusinessSettingsImplCopyWith<$Res> {
  __$$BusinessSettingsImplCopyWithImpl(_$BusinessSettingsImpl _value,
      $Res Function(_$BusinessSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? autoAcceptBookings = freezed,
    Object? maxBookingsPerDay = freezed,
    Object? advanceBookingDays = freezed,
    Object? cancellationHours = freezed,
    Object? requireDeposit = freezed,
    Object? depositPercentage = freezed,
    Object? sendReminders = freezed,
    Object? reminderHours = freezed,
    Object? allowOnlinePayment = freezed,
    Object? allowInstantBooking = freezed,
    Object? cancellationPolicy = freezed,
    Object? refundPolicy = freezed,
  }) {
    return _then(_$BusinessSettingsImpl(
      autoAcceptBookings: freezed == autoAcceptBookings
          ? _value.autoAcceptBookings
          : autoAcceptBookings // ignore: cast_nullable_to_non_nullable
              as bool?,
      maxBookingsPerDay: freezed == maxBookingsPerDay
          ? _value.maxBookingsPerDay
          : maxBookingsPerDay // ignore: cast_nullable_to_non_nullable
              as int?,
      advanceBookingDays: freezed == advanceBookingDays
          ? _value.advanceBookingDays
          : advanceBookingDays // ignore: cast_nullable_to_non_nullable
              as int?,
      cancellationHours: freezed == cancellationHours
          ? _value.cancellationHours
          : cancellationHours // ignore: cast_nullable_to_non_nullable
              as int?,
      requireDeposit: freezed == requireDeposit
          ? _value.requireDeposit
          : requireDeposit // ignore: cast_nullable_to_non_nullable
              as bool?,
      depositPercentage: freezed == depositPercentage
          ? _value.depositPercentage
          : depositPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      sendReminders: freezed == sendReminders
          ? _value.sendReminders
          : sendReminders // ignore: cast_nullable_to_non_nullable
              as bool?,
      reminderHours: freezed == reminderHours
          ? _value.reminderHours
          : reminderHours // ignore: cast_nullable_to_non_nullable
              as int?,
      allowOnlinePayment: freezed == allowOnlinePayment
          ? _value.allowOnlinePayment
          : allowOnlinePayment // ignore: cast_nullable_to_non_nullable
              as bool?,
      allowInstantBooking: freezed == allowInstantBooking
          ? _value.allowInstantBooking
          : allowInstantBooking // ignore: cast_nullable_to_non_nullable
              as bool?,
      cancellationPolicy: freezed == cancellationPolicy
          ? _value.cancellationPolicy
          : cancellationPolicy // ignore: cast_nullable_to_non_nullable
              as String?,
      refundPolicy: freezed == refundPolicy
          ? _value.refundPolicy
          : refundPolicy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BusinessSettingsImpl implements _BusinessSettings {
  const _$BusinessSettingsImpl(
      {this.autoAcceptBookings,
      this.maxBookingsPerDay,
      this.advanceBookingDays,
      this.cancellationHours,
      this.requireDeposit,
      this.depositPercentage,
      this.sendReminders,
      this.reminderHours,
      this.allowOnlinePayment,
      this.allowInstantBooking,
      this.cancellationPolicy,
      this.refundPolicy});

  factory _$BusinessSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusinessSettingsImplFromJson(json);

  @override
  final bool? autoAcceptBookings;
  @override
  final int? maxBookingsPerDay;
  @override
  final int? advanceBookingDays;
  @override
  final int? cancellationHours;
  @override
  final bool? requireDeposit;
  @override
  final double? depositPercentage;
  @override
  final bool? sendReminders;
  @override
  final int? reminderHours;
  @override
  final bool? allowOnlinePayment;
  @override
  final bool? allowInstantBooking;
  @override
  final String? cancellationPolicy;
  @override
  final String? refundPolicy;

  @override
  String toString() {
    return 'BusinessSettings(autoAcceptBookings: $autoAcceptBookings, maxBookingsPerDay: $maxBookingsPerDay, advanceBookingDays: $advanceBookingDays, cancellationHours: $cancellationHours, requireDeposit: $requireDeposit, depositPercentage: $depositPercentage, sendReminders: $sendReminders, reminderHours: $reminderHours, allowOnlinePayment: $allowOnlinePayment, allowInstantBooking: $allowInstantBooking, cancellationPolicy: $cancellationPolicy, refundPolicy: $refundPolicy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessSettingsImpl &&
            (identical(other.autoAcceptBookings, autoAcceptBookings) ||
                other.autoAcceptBookings == autoAcceptBookings) &&
            (identical(other.maxBookingsPerDay, maxBookingsPerDay) ||
                other.maxBookingsPerDay == maxBookingsPerDay) &&
            (identical(other.advanceBookingDays, advanceBookingDays) ||
                other.advanceBookingDays == advanceBookingDays) &&
            (identical(other.cancellationHours, cancellationHours) ||
                other.cancellationHours == cancellationHours) &&
            (identical(other.requireDeposit, requireDeposit) ||
                other.requireDeposit == requireDeposit) &&
            (identical(other.depositPercentage, depositPercentage) ||
                other.depositPercentage == depositPercentage) &&
            (identical(other.sendReminders, sendReminders) ||
                other.sendReminders == sendReminders) &&
            (identical(other.reminderHours, reminderHours) ||
                other.reminderHours == reminderHours) &&
            (identical(other.allowOnlinePayment, allowOnlinePayment) ||
                other.allowOnlinePayment == allowOnlinePayment) &&
            (identical(other.allowInstantBooking, allowInstantBooking) ||
                other.allowInstantBooking == allowInstantBooking) &&
            (identical(other.cancellationPolicy, cancellationPolicy) ||
                other.cancellationPolicy == cancellationPolicy) &&
            (identical(other.refundPolicy, refundPolicy) ||
                other.refundPolicy == refundPolicy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      autoAcceptBookings,
      maxBookingsPerDay,
      advanceBookingDays,
      cancellationHours,
      requireDeposit,
      depositPercentage,
      sendReminders,
      reminderHours,
      allowOnlinePayment,
      allowInstantBooking,
      cancellationPolicy,
      refundPolicy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessSettingsImplCopyWith<_$BusinessSettingsImpl> get copyWith =>
      __$$BusinessSettingsImplCopyWithImpl<_$BusinessSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BusinessSettingsImplToJson(
      this,
    );
  }
}

abstract class _BusinessSettings implements BusinessSettings {
  const factory _BusinessSettings(
      {final bool? autoAcceptBookings,
      final int? maxBookingsPerDay,
      final int? advanceBookingDays,
      final int? cancellationHours,
      final bool? requireDeposit,
      final double? depositPercentage,
      final bool? sendReminders,
      final int? reminderHours,
      final bool? allowOnlinePayment,
      final bool? allowInstantBooking,
      final String? cancellationPolicy,
      final String? refundPolicy}) = _$BusinessSettingsImpl;

  factory _BusinessSettings.fromJson(Map<String, dynamic> json) =
      _$BusinessSettingsImpl.fromJson;

  @override
  bool? get autoAcceptBookings;
  @override
  int? get maxBookingsPerDay;
  @override
  int? get advanceBookingDays;
  @override
  int? get cancellationHours;
  @override
  bool? get requireDeposit;
  @override
  double? get depositPercentage;
  @override
  bool? get sendReminders;
  @override
  int? get reminderHours;
  @override
  bool? get allowOnlinePayment;
  @override
  bool? get allowInstantBooking;
  @override
  String? get cancellationPolicy;
  @override
  String? get refundPolicy;
  @override
  @JsonKey(ignore: true)
  _$$BusinessSettingsImplCopyWith<_$BusinessSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
