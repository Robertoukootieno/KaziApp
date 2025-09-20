// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AnalyticsData _$AnalyticsDataFromJson(Map<String, dynamic> json) {
  return _AnalyticsData.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsData {
  int get totalUsers => throw _privateConstructorUsedError;
  int get activeUsers => throw _privateConstructorUsedError;
  double get totalRevenue => throw _privateConstructorUsedError;
  double get monthlyRevenue => throw _privateConstructorUsedError;
  double get engagementRate => throw _privateConstructorUsedError;
  double get conversionRate => throw _privateConstructorUsedError;
  List<TimeSeriesData> get userGrowthHistory =>
      throw _privateConstructorUsedError;
  List<TimeSeriesData> get revenueHistory => throw _privateConstructorUsedError;
  Map<String, dynamic> get engagementMetrics =>
      throw _privateConstructorUsedError;
  Map<String, int> get conversionFunnel => throw _privateConstructorUsedError;
  Map<String, dynamic> get topMetrics => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AnalyticsDataCopyWith<AnalyticsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsDataCopyWith<$Res> {
  factory $AnalyticsDataCopyWith(
          AnalyticsData value, $Res Function(AnalyticsData) then) =
      _$AnalyticsDataCopyWithImpl<$Res, AnalyticsData>;
  @useResult
  $Res call(
      {int totalUsers,
      int activeUsers,
      double totalRevenue,
      double monthlyRevenue,
      double engagementRate,
      double conversionRate,
      List<TimeSeriesData> userGrowthHistory,
      List<TimeSeriesData> revenueHistory,
      Map<String, dynamic> engagementMetrics,
      Map<String, int> conversionFunnel,
      Map<String, dynamic> topMetrics});
}

/// @nodoc
class _$AnalyticsDataCopyWithImpl<$Res, $Val extends AnalyticsData>
    implements $AnalyticsDataCopyWith<$Res> {
  _$AnalyticsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUsers = null,
    Object? activeUsers = null,
    Object? totalRevenue = null,
    Object? monthlyRevenue = null,
    Object? engagementRate = null,
    Object? conversionRate = null,
    Object? userGrowthHistory = null,
    Object? revenueHistory = null,
    Object? engagementMetrics = null,
    Object? conversionFunnel = null,
    Object? topMetrics = null,
  }) {
    return _then(_value.copyWith(
      totalUsers: null == totalUsers
          ? _value.totalUsers
          : totalUsers // ignore: cast_nullable_to_non_nullable
              as int,
      activeUsers: null == activeUsers
          ? _value.activeUsers
          : activeUsers // ignore: cast_nullable_to_non_nullable
              as int,
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyRevenue: null == monthlyRevenue
          ? _value.monthlyRevenue
          : monthlyRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      engagementRate: null == engagementRate
          ? _value.engagementRate
          : engagementRate // ignore: cast_nullable_to_non_nullable
              as double,
      conversionRate: null == conversionRate
          ? _value.conversionRate
          : conversionRate // ignore: cast_nullable_to_non_nullable
              as double,
      userGrowthHistory: null == userGrowthHistory
          ? _value.userGrowthHistory
          : userGrowthHistory // ignore: cast_nullable_to_non_nullable
              as List<TimeSeriesData>,
      revenueHistory: null == revenueHistory
          ? _value.revenueHistory
          : revenueHistory // ignore: cast_nullable_to_non_nullable
              as List<TimeSeriesData>,
      engagementMetrics: null == engagementMetrics
          ? _value.engagementMetrics
          : engagementMetrics // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      conversionFunnel: null == conversionFunnel
          ? _value.conversionFunnel
          : conversionFunnel // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      topMetrics: null == topMetrics
          ? _value.topMetrics
          : topMetrics // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnalyticsDataImplCopyWith<$Res>
    implements $AnalyticsDataCopyWith<$Res> {
  factory _$$AnalyticsDataImplCopyWith(
          _$AnalyticsDataImpl value, $Res Function(_$AnalyticsDataImpl) then) =
      __$$AnalyticsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalUsers,
      int activeUsers,
      double totalRevenue,
      double monthlyRevenue,
      double engagementRate,
      double conversionRate,
      List<TimeSeriesData> userGrowthHistory,
      List<TimeSeriesData> revenueHistory,
      Map<String, dynamic> engagementMetrics,
      Map<String, int> conversionFunnel,
      Map<String, dynamic> topMetrics});
}

/// @nodoc
class __$$AnalyticsDataImplCopyWithImpl<$Res>
    extends _$AnalyticsDataCopyWithImpl<$Res, _$AnalyticsDataImpl>
    implements _$$AnalyticsDataImplCopyWith<$Res> {
  __$$AnalyticsDataImplCopyWithImpl(
      _$AnalyticsDataImpl _value, $Res Function(_$AnalyticsDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUsers = null,
    Object? activeUsers = null,
    Object? totalRevenue = null,
    Object? monthlyRevenue = null,
    Object? engagementRate = null,
    Object? conversionRate = null,
    Object? userGrowthHistory = null,
    Object? revenueHistory = null,
    Object? engagementMetrics = null,
    Object? conversionFunnel = null,
    Object? topMetrics = null,
  }) {
    return _then(_$AnalyticsDataImpl(
      totalUsers: null == totalUsers
          ? _value.totalUsers
          : totalUsers // ignore: cast_nullable_to_non_nullable
              as int,
      activeUsers: null == activeUsers
          ? _value.activeUsers
          : activeUsers // ignore: cast_nullable_to_non_nullable
              as int,
      totalRevenue: null == totalRevenue
          ? _value.totalRevenue
          : totalRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyRevenue: null == monthlyRevenue
          ? _value.monthlyRevenue
          : monthlyRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      engagementRate: null == engagementRate
          ? _value.engagementRate
          : engagementRate // ignore: cast_nullable_to_non_nullable
              as double,
      conversionRate: null == conversionRate
          ? _value.conversionRate
          : conversionRate // ignore: cast_nullable_to_non_nullable
              as double,
      userGrowthHistory: null == userGrowthHistory
          ? _value._userGrowthHistory
          : userGrowthHistory // ignore: cast_nullable_to_non_nullable
              as List<TimeSeriesData>,
      revenueHistory: null == revenueHistory
          ? _value._revenueHistory
          : revenueHistory // ignore: cast_nullable_to_non_nullable
              as List<TimeSeriesData>,
      engagementMetrics: null == engagementMetrics
          ? _value._engagementMetrics
          : engagementMetrics // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      conversionFunnel: null == conversionFunnel
          ? _value._conversionFunnel
          : conversionFunnel // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      topMetrics: null == topMetrics
          ? _value._topMetrics
          : topMetrics // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsDataImpl implements _AnalyticsData {
  const _$AnalyticsDataImpl(
      {required this.totalUsers,
      required this.activeUsers,
      required this.totalRevenue,
      required this.monthlyRevenue,
      required this.engagementRate,
      required this.conversionRate,
      required final List<TimeSeriesData> userGrowthHistory,
      required final List<TimeSeriesData> revenueHistory,
      required final Map<String, dynamic> engagementMetrics,
      required final Map<String, int> conversionFunnel,
      required final Map<String, dynamic> topMetrics})
      : _userGrowthHistory = userGrowthHistory,
        _revenueHistory = revenueHistory,
        _engagementMetrics = engagementMetrics,
        _conversionFunnel = conversionFunnel,
        _topMetrics = topMetrics;

  factory _$AnalyticsDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsDataImplFromJson(json);

  @override
  final int totalUsers;
  @override
  final int activeUsers;
  @override
  final double totalRevenue;
  @override
  final double monthlyRevenue;
  @override
  final double engagementRate;
  @override
  final double conversionRate;
  final List<TimeSeriesData> _userGrowthHistory;
  @override
  List<TimeSeriesData> get userGrowthHistory {
    if (_userGrowthHistory is EqualUnmodifiableListView)
      return _userGrowthHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userGrowthHistory);
  }

  final List<TimeSeriesData> _revenueHistory;
  @override
  List<TimeSeriesData> get revenueHistory {
    if (_revenueHistory is EqualUnmodifiableListView) return _revenueHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_revenueHistory);
  }

  final Map<String, dynamic> _engagementMetrics;
  @override
  Map<String, dynamic> get engagementMetrics {
    if (_engagementMetrics is EqualUnmodifiableMapView)
      return _engagementMetrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_engagementMetrics);
  }

  final Map<String, int> _conversionFunnel;
  @override
  Map<String, int> get conversionFunnel {
    if (_conversionFunnel is EqualUnmodifiableMapView) return _conversionFunnel;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_conversionFunnel);
  }

  final Map<String, dynamic> _topMetrics;
  @override
  Map<String, dynamic> get topMetrics {
    if (_topMetrics is EqualUnmodifiableMapView) return _topMetrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_topMetrics);
  }

  @override
  String toString() {
    return 'AnalyticsData(totalUsers: $totalUsers, activeUsers: $activeUsers, totalRevenue: $totalRevenue, monthlyRevenue: $monthlyRevenue, engagementRate: $engagementRate, conversionRate: $conversionRate, userGrowthHistory: $userGrowthHistory, revenueHistory: $revenueHistory, engagementMetrics: $engagementMetrics, conversionFunnel: $conversionFunnel, topMetrics: $topMetrics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsDataImpl &&
            (identical(other.totalUsers, totalUsers) ||
                other.totalUsers == totalUsers) &&
            (identical(other.activeUsers, activeUsers) ||
                other.activeUsers == activeUsers) &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.monthlyRevenue, monthlyRevenue) ||
                other.monthlyRevenue == monthlyRevenue) &&
            (identical(other.engagementRate, engagementRate) ||
                other.engagementRate == engagementRate) &&
            (identical(other.conversionRate, conversionRate) ||
                other.conversionRate == conversionRate) &&
            const DeepCollectionEquality()
                .equals(other._userGrowthHistory, _userGrowthHistory) &&
            const DeepCollectionEquality()
                .equals(other._revenueHistory, _revenueHistory) &&
            const DeepCollectionEquality()
                .equals(other._engagementMetrics, _engagementMetrics) &&
            const DeepCollectionEquality()
                .equals(other._conversionFunnel, _conversionFunnel) &&
            const DeepCollectionEquality()
                .equals(other._topMetrics, _topMetrics));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalUsers,
      activeUsers,
      totalRevenue,
      monthlyRevenue,
      engagementRate,
      conversionRate,
      const DeepCollectionEquality().hash(_userGrowthHistory),
      const DeepCollectionEquality().hash(_revenueHistory),
      const DeepCollectionEquality().hash(_engagementMetrics),
      const DeepCollectionEquality().hash(_conversionFunnel),
      const DeepCollectionEquality().hash(_topMetrics));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsDataImplCopyWith<_$AnalyticsDataImpl> get copyWith =>
      __$$AnalyticsDataImplCopyWithImpl<_$AnalyticsDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsDataImplToJson(
      this,
    );
  }
}

abstract class _AnalyticsData implements AnalyticsData {
  const factory _AnalyticsData(
      {required final int totalUsers,
      required final int activeUsers,
      required final double totalRevenue,
      required final double monthlyRevenue,
      required final double engagementRate,
      required final double conversionRate,
      required final List<TimeSeriesData> userGrowthHistory,
      required final List<TimeSeriesData> revenueHistory,
      required final Map<String, dynamic> engagementMetrics,
      required final Map<String, int> conversionFunnel,
      required final Map<String, dynamic> topMetrics}) = _$AnalyticsDataImpl;

  factory _AnalyticsData.fromJson(Map<String, dynamic> json) =
      _$AnalyticsDataImpl.fromJson;

  @override
  int get totalUsers;
  @override
  int get activeUsers;
  @override
  double get totalRevenue;
  @override
  double get monthlyRevenue;
  @override
  double get engagementRate;
  @override
  double get conversionRate;
  @override
  List<TimeSeriesData> get userGrowthHistory;
  @override
  List<TimeSeriesData> get revenueHistory;
  @override
  Map<String, dynamic> get engagementMetrics;
  @override
  Map<String, int> get conversionFunnel;
  @override
  Map<String, dynamic> get topMetrics;
  @override
  @JsonKey(ignore: true)
  _$$AnalyticsDataImplCopyWith<_$AnalyticsDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimeSeriesData _$TimeSeriesDataFromJson(Map<String, dynamic> json) {
  return _TimeSeriesData.fromJson(json);
}

/// @nodoc
mixin _$TimeSeriesData {
  DateTime get date => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  String? get label => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TimeSeriesDataCopyWith<TimeSeriesData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeSeriesDataCopyWith<$Res> {
  factory $TimeSeriesDataCopyWith(
          TimeSeriesData value, $Res Function(TimeSeriesData) then) =
      _$TimeSeriesDataCopyWithImpl<$Res, TimeSeriesData>;
  @useResult
  $Res call(
      {DateTime date,
      double value,
      String? label,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$TimeSeriesDataCopyWithImpl<$Res, $Val extends TimeSeriesData>
    implements $TimeSeriesDataCopyWith<$Res> {
  _$TimeSeriesDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? value = null,
    Object? label = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimeSeriesDataImplCopyWith<$Res>
    implements $TimeSeriesDataCopyWith<$Res> {
  factory _$$TimeSeriesDataImplCopyWith(_$TimeSeriesDataImpl value,
          $Res Function(_$TimeSeriesDataImpl) then) =
      __$$TimeSeriesDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      double value,
      String? label,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$TimeSeriesDataImplCopyWithImpl<$Res>
    extends _$TimeSeriesDataCopyWithImpl<$Res, _$TimeSeriesDataImpl>
    implements _$$TimeSeriesDataImplCopyWith<$Res> {
  __$$TimeSeriesDataImplCopyWithImpl(
      _$TimeSeriesDataImpl _value, $Res Function(_$TimeSeriesDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? value = null,
    Object? label = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$TimeSeriesDataImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TimeSeriesDataImpl implements _TimeSeriesData {
  const _$TimeSeriesDataImpl(
      {required this.date,
      required this.value,
      this.label,
      final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$TimeSeriesDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeSeriesDataImplFromJson(json);

  @override
  final DateTime date;
  @override
  final double value;
  @override
  final String? label;
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
    return 'TimeSeriesData(date: $date, value: $value, label: $label, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeSeriesDataImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.label, label) || other.label == label) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, date, value, label,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeSeriesDataImplCopyWith<_$TimeSeriesDataImpl> get copyWith =>
      __$$TimeSeriesDataImplCopyWithImpl<_$TimeSeriesDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeSeriesDataImplToJson(
      this,
    );
  }
}

abstract class _TimeSeriesData implements TimeSeriesData {
  const factory _TimeSeriesData(
      {required final DateTime date,
      required final double value,
      final String? label,
      final Map<String, dynamic>? metadata}) = _$TimeSeriesDataImpl;

  factory _TimeSeriesData.fromJson(Map<String, dynamic> json) =
      _$TimeSeriesDataImpl.fromJson;

  @override
  DateTime get date;
  @override
  double get value;
  @override
  String? get label;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$TimeSeriesDataImplCopyWith<_$TimeSeriesDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserBehaviorData _$UserBehaviorDataFromJson(Map<String, dynamic> json) {
  return _UserBehaviorData.fromJson(json);
}

/// @nodoc
mixin _$UserBehaviorData {
  Map<String, UserSegment> get userSegments =>
      throw _privateConstructorUsedError;
  List<UserJourneyStep> get userJourney => throw _privateConstructorUsedError;
  Map<String, double> get featureUsage => throw _privateConstructorUsedError;
  ChurnAnalysis get churnAnalysis => throw _privateConstructorUsedError;
  List<BehaviorPattern> get behaviorPatterns =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserBehaviorDataCopyWith<UserBehaviorData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserBehaviorDataCopyWith<$Res> {
  factory $UserBehaviorDataCopyWith(
          UserBehaviorData value, $Res Function(UserBehaviorData) then) =
      _$UserBehaviorDataCopyWithImpl<$Res, UserBehaviorData>;
  @useResult
  $Res call(
      {Map<String, UserSegment> userSegments,
      List<UserJourneyStep> userJourney,
      Map<String, double> featureUsage,
      ChurnAnalysis churnAnalysis,
      List<BehaviorPattern> behaviorPatterns});

  $ChurnAnalysisCopyWith<$Res> get churnAnalysis;
}

/// @nodoc
class _$UserBehaviorDataCopyWithImpl<$Res, $Val extends UserBehaviorData>
    implements $UserBehaviorDataCopyWith<$Res> {
  _$UserBehaviorDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userSegments = null,
    Object? userJourney = null,
    Object? featureUsage = null,
    Object? churnAnalysis = null,
    Object? behaviorPatterns = null,
  }) {
    return _then(_value.copyWith(
      userSegments: null == userSegments
          ? _value.userSegments
          : userSegments // ignore: cast_nullable_to_non_nullable
              as Map<String, UserSegment>,
      userJourney: null == userJourney
          ? _value.userJourney
          : userJourney // ignore: cast_nullable_to_non_nullable
              as List<UserJourneyStep>,
      featureUsage: null == featureUsage
          ? _value.featureUsage
          : featureUsage // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      churnAnalysis: null == churnAnalysis
          ? _value.churnAnalysis
          : churnAnalysis // ignore: cast_nullable_to_non_nullable
              as ChurnAnalysis,
      behaviorPatterns: null == behaviorPatterns
          ? _value.behaviorPatterns
          : behaviorPatterns // ignore: cast_nullable_to_non_nullable
              as List<BehaviorPattern>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ChurnAnalysisCopyWith<$Res> get churnAnalysis {
    return $ChurnAnalysisCopyWith<$Res>(_value.churnAnalysis, (value) {
      return _then(_value.copyWith(churnAnalysis: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserBehaviorDataImplCopyWith<$Res>
    implements $UserBehaviorDataCopyWith<$Res> {
  factory _$$UserBehaviorDataImplCopyWith(_$UserBehaviorDataImpl value,
          $Res Function(_$UserBehaviorDataImpl) then) =
      __$$UserBehaviorDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, UserSegment> userSegments,
      List<UserJourneyStep> userJourney,
      Map<String, double> featureUsage,
      ChurnAnalysis churnAnalysis,
      List<BehaviorPattern> behaviorPatterns});

  @override
  $ChurnAnalysisCopyWith<$Res> get churnAnalysis;
}

/// @nodoc
class __$$UserBehaviorDataImplCopyWithImpl<$Res>
    extends _$UserBehaviorDataCopyWithImpl<$Res, _$UserBehaviorDataImpl>
    implements _$$UserBehaviorDataImplCopyWith<$Res> {
  __$$UserBehaviorDataImplCopyWithImpl(_$UserBehaviorDataImpl _value,
      $Res Function(_$UserBehaviorDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userSegments = null,
    Object? userJourney = null,
    Object? featureUsage = null,
    Object? churnAnalysis = null,
    Object? behaviorPatterns = null,
  }) {
    return _then(_$UserBehaviorDataImpl(
      userSegments: null == userSegments
          ? _value._userSegments
          : userSegments // ignore: cast_nullable_to_non_nullable
              as Map<String, UserSegment>,
      userJourney: null == userJourney
          ? _value._userJourney
          : userJourney // ignore: cast_nullable_to_non_nullable
              as List<UserJourneyStep>,
      featureUsage: null == featureUsage
          ? _value._featureUsage
          : featureUsage // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      churnAnalysis: null == churnAnalysis
          ? _value.churnAnalysis
          : churnAnalysis // ignore: cast_nullable_to_non_nullable
              as ChurnAnalysis,
      behaviorPatterns: null == behaviorPatterns
          ? _value._behaviorPatterns
          : behaviorPatterns // ignore: cast_nullable_to_non_nullable
              as List<BehaviorPattern>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserBehaviorDataImpl implements _UserBehaviorData {
  const _$UserBehaviorDataImpl(
      {required final Map<String, UserSegment> userSegments,
      required final List<UserJourneyStep> userJourney,
      required final Map<String, double> featureUsage,
      required this.churnAnalysis,
      required final List<BehaviorPattern> behaviorPatterns})
      : _userSegments = userSegments,
        _userJourney = userJourney,
        _featureUsage = featureUsage,
        _behaviorPatterns = behaviorPatterns;

  factory _$UserBehaviorDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserBehaviorDataImplFromJson(json);

  final Map<String, UserSegment> _userSegments;
  @override
  Map<String, UserSegment> get userSegments {
    if (_userSegments is EqualUnmodifiableMapView) return _userSegments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_userSegments);
  }

  final List<UserJourneyStep> _userJourney;
  @override
  List<UserJourneyStep> get userJourney {
    if (_userJourney is EqualUnmodifiableListView) return _userJourney;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userJourney);
  }

  final Map<String, double> _featureUsage;
  @override
  Map<String, double> get featureUsage {
    if (_featureUsage is EqualUnmodifiableMapView) return _featureUsage;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_featureUsage);
  }

  @override
  final ChurnAnalysis churnAnalysis;
  final List<BehaviorPattern> _behaviorPatterns;
  @override
  List<BehaviorPattern> get behaviorPatterns {
    if (_behaviorPatterns is EqualUnmodifiableListView)
      return _behaviorPatterns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_behaviorPatterns);
  }

  @override
  String toString() {
    return 'UserBehaviorData(userSegments: $userSegments, userJourney: $userJourney, featureUsage: $featureUsage, churnAnalysis: $churnAnalysis, behaviorPatterns: $behaviorPatterns)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserBehaviorDataImpl &&
            const DeepCollectionEquality()
                .equals(other._userSegments, _userSegments) &&
            const DeepCollectionEquality()
                .equals(other._userJourney, _userJourney) &&
            const DeepCollectionEquality()
                .equals(other._featureUsage, _featureUsage) &&
            (identical(other.churnAnalysis, churnAnalysis) ||
                other.churnAnalysis == churnAnalysis) &&
            const DeepCollectionEquality()
                .equals(other._behaviorPatterns, _behaviorPatterns));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_userSegments),
      const DeepCollectionEquality().hash(_userJourney),
      const DeepCollectionEquality().hash(_featureUsage),
      churnAnalysis,
      const DeepCollectionEquality().hash(_behaviorPatterns));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserBehaviorDataImplCopyWith<_$UserBehaviorDataImpl> get copyWith =>
      __$$UserBehaviorDataImplCopyWithImpl<_$UserBehaviorDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserBehaviorDataImplToJson(
      this,
    );
  }
}

abstract class _UserBehaviorData implements UserBehaviorData {
  const factory _UserBehaviorData(
          {required final Map<String, UserSegment> userSegments,
          required final List<UserJourneyStep> userJourney,
          required final Map<String, double> featureUsage,
          required final ChurnAnalysis churnAnalysis,
          required final List<BehaviorPattern> behaviorPatterns}) =
      _$UserBehaviorDataImpl;

  factory _UserBehaviorData.fromJson(Map<String, dynamic> json) =
      _$UserBehaviorDataImpl.fromJson;

  @override
  Map<String, UserSegment> get userSegments;
  @override
  List<UserJourneyStep> get userJourney;
  @override
  Map<String, double> get featureUsage;
  @override
  ChurnAnalysis get churnAnalysis;
  @override
  List<BehaviorPattern> get behaviorPatterns;
  @override
  @JsonKey(ignore: true)
  _$$UserBehaviorDataImplCopyWith<_$UserBehaviorDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserSegment _$UserSegmentFromJson(Map<String, dynamic> json) {
  return _UserSegment.fromJson(json);
}

/// @nodoc
mixin _$UserSegment {
  int get count => throw _privateConstructorUsedError;
  double get engagement => throw _privateConstructorUsedError;
  double get retention => throw _privateConstructorUsedError;
  double get averageRevenue => throw _privateConstructorUsedError;
  Map<String, dynamic>? get characteristics =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserSegmentCopyWith<UserSegment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSegmentCopyWith<$Res> {
  factory $UserSegmentCopyWith(
          UserSegment value, $Res Function(UserSegment) then) =
      _$UserSegmentCopyWithImpl<$Res, UserSegment>;
  @useResult
  $Res call(
      {int count,
      double engagement,
      double retention,
      double averageRevenue,
      Map<String, dynamic>? characteristics});
}

/// @nodoc
class _$UserSegmentCopyWithImpl<$Res, $Val extends UserSegment>
    implements $UserSegmentCopyWith<$Res> {
  _$UserSegmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
    Object? engagement = null,
    Object? retention = null,
    Object? averageRevenue = null,
    Object? characteristics = freezed,
  }) {
    return _then(_value.copyWith(
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      engagement: null == engagement
          ? _value.engagement
          : engagement // ignore: cast_nullable_to_non_nullable
              as double,
      retention: null == retention
          ? _value.retention
          : retention // ignore: cast_nullable_to_non_nullable
              as double,
      averageRevenue: null == averageRevenue
          ? _value.averageRevenue
          : averageRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      characteristics: freezed == characteristics
          ? _value.characteristics
          : characteristics // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserSegmentImplCopyWith<$Res>
    implements $UserSegmentCopyWith<$Res> {
  factory _$$UserSegmentImplCopyWith(
          _$UserSegmentImpl value, $Res Function(_$UserSegmentImpl) then) =
      __$$UserSegmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int count,
      double engagement,
      double retention,
      double averageRevenue,
      Map<String, dynamic>? characteristics});
}

/// @nodoc
class __$$UserSegmentImplCopyWithImpl<$Res>
    extends _$UserSegmentCopyWithImpl<$Res, _$UserSegmentImpl>
    implements _$$UserSegmentImplCopyWith<$Res> {
  __$$UserSegmentImplCopyWithImpl(
      _$UserSegmentImpl _value, $Res Function(_$UserSegmentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
    Object? engagement = null,
    Object? retention = null,
    Object? averageRevenue = null,
    Object? characteristics = freezed,
  }) {
    return _then(_$UserSegmentImpl(
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      engagement: null == engagement
          ? _value.engagement
          : engagement // ignore: cast_nullable_to_non_nullable
              as double,
      retention: null == retention
          ? _value.retention
          : retention // ignore: cast_nullable_to_non_nullable
              as double,
      averageRevenue: null == averageRevenue
          ? _value.averageRevenue
          : averageRevenue // ignore: cast_nullable_to_non_nullable
              as double,
      characteristics: freezed == characteristics
          ? _value._characteristics
          : characteristics // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSegmentImpl implements _UserSegment {
  const _$UserSegmentImpl(
      {required this.count,
      required this.engagement,
      required this.retention,
      required this.averageRevenue,
      final Map<String, dynamic>? characteristics})
      : _characteristics = characteristics;

  factory _$UserSegmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSegmentImplFromJson(json);

  @override
  final int count;
  @override
  final double engagement;
  @override
  final double retention;
  @override
  final double averageRevenue;
  final Map<String, dynamic>? _characteristics;
  @override
  Map<String, dynamic>? get characteristics {
    final value = _characteristics;
    if (value == null) return null;
    if (_characteristics is EqualUnmodifiableMapView) return _characteristics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'UserSegment(count: $count, engagement: $engagement, retention: $retention, averageRevenue: $averageRevenue, characteristics: $characteristics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSegmentImpl &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.engagement, engagement) ||
                other.engagement == engagement) &&
            (identical(other.retention, retention) ||
                other.retention == retention) &&
            (identical(other.averageRevenue, averageRevenue) ||
                other.averageRevenue == averageRevenue) &&
            const DeepCollectionEquality()
                .equals(other._characteristics, _characteristics));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, count, engagement, retention,
      averageRevenue, const DeepCollectionEquality().hash(_characteristics));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSegmentImplCopyWith<_$UserSegmentImpl> get copyWith =>
      __$$UserSegmentImplCopyWithImpl<_$UserSegmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSegmentImplToJson(
      this,
    );
  }
}

abstract class _UserSegment implements UserSegment {
  const factory _UserSegment(
      {required final int count,
      required final double engagement,
      required final double retention,
      required final double averageRevenue,
      final Map<String, dynamic>? characteristics}) = _$UserSegmentImpl;

  factory _UserSegment.fromJson(Map<String, dynamic> json) =
      _$UserSegmentImpl.fromJson;

  @override
  int get count;
  @override
  double get engagement;
  @override
  double get retention;
  @override
  double get averageRevenue;
  @override
  Map<String, dynamic>? get characteristics;
  @override
  @JsonKey(ignore: true)
  _$$UserSegmentImplCopyWith<_$UserSegmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserJourneyStep _$UserJourneyStepFromJson(Map<String, dynamic> json) {
  return _UserJourneyStep.fromJson(json);
}

/// @nodoc
mixin _$UserJourneyStep {
  String get step => throw _privateConstructorUsedError;
  double get completionRate => throw _privateConstructorUsedError;
  double get averageTime => throw _privateConstructorUsedError;
  List<String>? get dropOffReasons => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserJourneyStepCopyWith<UserJourneyStep> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserJourneyStepCopyWith<$Res> {
  factory $UserJourneyStepCopyWith(
          UserJourneyStep value, $Res Function(UserJourneyStep) then) =
      _$UserJourneyStepCopyWithImpl<$Res, UserJourneyStep>;
  @useResult
  $Res call(
      {String step,
      double completionRate,
      double averageTime,
      List<String>? dropOffReasons});
}

/// @nodoc
class _$UserJourneyStepCopyWithImpl<$Res, $Val extends UserJourneyStep>
    implements $UserJourneyStepCopyWith<$Res> {
  _$UserJourneyStepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? completionRate = null,
    Object? averageTime = null,
    Object? dropOffReasons = freezed,
  }) {
    return _then(_value.copyWith(
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as String,
      completionRate: null == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double,
      averageTime: null == averageTime
          ? _value.averageTime
          : averageTime // ignore: cast_nullable_to_non_nullable
              as double,
      dropOffReasons: freezed == dropOffReasons
          ? _value.dropOffReasons
          : dropOffReasons // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserJourneyStepImplCopyWith<$Res>
    implements $UserJourneyStepCopyWith<$Res> {
  factory _$$UserJourneyStepImplCopyWith(_$UserJourneyStepImpl value,
          $Res Function(_$UserJourneyStepImpl) then) =
      __$$UserJourneyStepImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String step,
      double completionRate,
      double averageTime,
      List<String>? dropOffReasons});
}

/// @nodoc
class __$$UserJourneyStepImplCopyWithImpl<$Res>
    extends _$UserJourneyStepCopyWithImpl<$Res, _$UserJourneyStepImpl>
    implements _$$UserJourneyStepImplCopyWith<$Res> {
  __$$UserJourneyStepImplCopyWithImpl(
      _$UserJourneyStepImpl _value, $Res Function(_$UserJourneyStepImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? completionRate = null,
    Object? averageTime = null,
    Object? dropOffReasons = freezed,
  }) {
    return _then(_$UserJourneyStepImpl(
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as String,
      completionRate: null == completionRate
          ? _value.completionRate
          : completionRate // ignore: cast_nullable_to_non_nullable
              as double,
      averageTime: null == averageTime
          ? _value.averageTime
          : averageTime // ignore: cast_nullable_to_non_nullable
              as double,
      dropOffReasons: freezed == dropOffReasons
          ? _value._dropOffReasons
          : dropOffReasons // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserJourneyStepImpl implements _UserJourneyStep {
  const _$UserJourneyStepImpl(
      {required this.step,
      required this.completionRate,
      required this.averageTime,
      final List<String>? dropOffReasons})
      : _dropOffReasons = dropOffReasons;

  factory _$UserJourneyStepImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserJourneyStepImplFromJson(json);

  @override
  final String step;
  @override
  final double completionRate;
  @override
  final double averageTime;
  final List<String>? _dropOffReasons;
  @override
  List<String>? get dropOffReasons {
    final value = _dropOffReasons;
    if (value == null) return null;
    if (_dropOffReasons is EqualUnmodifiableListView) return _dropOffReasons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'UserJourneyStep(step: $step, completionRate: $completionRate, averageTime: $averageTime, dropOffReasons: $dropOffReasons)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserJourneyStepImpl &&
            (identical(other.step, step) || other.step == step) &&
            (identical(other.completionRate, completionRate) ||
                other.completionRate == completionRate) &&
            (identical(other.averageTime, averageTime) ||
                other.averageTime == averageTime) &&
            const DeepCollectionEquality()
                .equals(other._dropOffReasons, _dropOffReasons));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, step, completionRate,
      averageTime, const DeepCollectionEquality().hash(_dropOffReasons));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserJourneyStepImplCopyWith<_$UserJourneyStepImpl> get copyWith =>
      __$$UserJourneyStepImplCopyWithImpl<_$UserJourneyStepImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserJourneyStepImplToJson(
      this,
    );
  }
}

abstract class _UserJourneyStep implements UserJourneyStep {
  const factory _UserJourneyStep(
      {required final String step,
      required final double completionRate,
      required final double averageTime,
      final List<String>? dropOffReasons}) = _$UserJourneyStepImpl;

  factory _UserJourneyStep.fromJson(Map<String, dynamic> json) =
      _$UserJourneyStepImpl.fromJson;

  @override
  String get step;
  @override
  double get completionRate;
  @override
  double get averageTime;
  @override
  List<String>? get dropOffReasons;
  @override
  @JsonKey(ignore: true)
  _$$UserJourneyStepImplCopyWith<_$UserJourneyStepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChurnAnalysis _$ChurnAnalysisFromJson(Map<String, dynamic> json) {
  return _ChurnAnalysis.fromJson(json);
}

/// @nodoc
mixin _$ChurnAnalysis {
  double get churnRate => throw _privateConstructorUsedError;
  int get atRiskUsers => throw _privateConstructorUsedError;
  Map<String, double> get churnReasons => throw _privateConstructorUsedError;
  List<ChurnPrediction> get predictions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChurnAnalysisCopyWith<ChurnAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChurnAnalysisCopyWith<$Res> {
  factory $ChurnAnalysisCopyWith(
          ChurnAnalysis value, $Res Function(ChurnAnalysis) then) =
      _$ChurnAnalysisCopyWithImpl<$Res, ChurnAnalysis>;
  @useResult
  $Res call(
      {double churnRate,
      int atRiskUsers,
      Map<String, double> churnReasons,
      List<ChurnPrediction> predictions});
}

/// @nodoc
class _$ChurnAnalysisCopyWithImpl<$Res, $Val extends ChurnAnalysis>
    implements $ChurnAnalysisCopyWith<$Res> {
  _$ChurnAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? churnRate = null,
    Object? atRiskUsers = null,
    Object? churnReasons = null,
    Object? predictions = null,
  }) {
    return _then(_value.copyWith(
      churnRate: null == churnRate
          ? _value.churnRate
          : churnRate // ignore: cast_nullable_to_non_nullable
              as double,
      atRiskUsers: null == atRiskUsers
          ? _value.atRiskUsers
          : atRiskUsers // ignore: cast_nullable_to_non_nullable
              as int,
      churnReasons: null == churnReasons
          ? _value.churnReasons
          : churnReasons // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      predictions: null == predictions
          ? _value.predictions
          : predictions // ignore: cast_nullable_to_non_nullable
              as List<ChurnPrediction>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChurnAnalysisImplCopyWith<$Res>
    implements $ChurnAnalysisCopyWith<$Res> {
  factory _$$ChurnAnalysisImplCopyWith(
          _$ChurnAnalysisImpl value, $Res Function(_$ChurnAnalysisImpl) then) =
      __$$ChurnAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double churnRate,
      int atRiskUsers,
      Map<String, double> churnReasons,
      List<ChurnPrediction> predictions});
}

/// @nodoc
class __$$ChurnAnalysisImplCopyWithImpl<$Res>
    extends _$ChurnAnalysisCopyWithImpl<$Res, _$ChurnAnalysisImpl>
    implements _$$ChurnAnalysisImplCopyWith<$Res> {
  __$$ChurnAnalysisImplCopyWithImpl(
      _$ChurnAnalysisImpl _value, $Res Function(_$ChurnAnalysisImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? churnRate = null,
    Object? atRiskUsers = null,
    Object? churnReasons = null,
    Object? predictions = null,
  }) {
    return _then(_$ChurnAnalysisImpl(
      churnRate: null == churnRate
          ? _value.churnRate
          : churnRate // ignore: cast_nullable_to_non_nullable
              as double,
      atRiskUsers: null == atRiskUsers
          ? _value.atRiskUsers
          : atRiskUsers // ignore: cast_nullable_to_non_nullable
              as int,
      churnReasons: null == churnReasons
          ? _value._churnReasons
          : churnReasons // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      predictions: null == predictions
          ? _value._predictions
          : predictions // ignore: cast_nullable_to_non_nullable
              as List<ChurnPrediction>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChurnAnalysisImpl implements _ChurnAnalysis {
  const _$ChurnAnalysisImpl(
      {required this.churnRate,
      required this.atRiskUsers,
      required final Map<String, double> churnReasons,
      required final List<ChurnPrediction> predictions})
      : _churnReasons = churnReasons,
        _predictions = predictions;

  factory _$ChurnAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChurnAnalysisImplFromJson(json);

  @override
  final double churnRate;
  @override
  final int atRiskUsers;
  final Map<String, double> _churnReasons;
  @override
  Map<String, double> get churnReasons {
    if (_churnReasons is EqualUnmodifiableMapView) return _churnReasons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_churnReasons);
  }

  final List<ChurnPrediction> _predictions;
  @override
  List<ChurnPrediction> get predictions {
    if (_predictions is EqualUnmodifiableListView) return _predictions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_predictions);
  }

  @override
  String toString() {
    return 'ChurnAnalysis(churnRate: $churnRate, atRiskUsers: $atRiskUsers, churnReasons: $churnReasons, predictions: $predictions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChurnAnalysisImpl &&
            (identical(other.churnRate, churnRate) ||
                other.churnRate == churnRate) &&
            (identical(other.atRiskUsers, atRiskUsers) ||
                other.atRiskUsers == atRiskUsers) &&
            const DeepCollectionEquality()
                .equals(other._churnReasons, _churnReasons) &&
            const DeepCollectionEquality()
                .equals(other._predictions, _predictions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      churnRate,
      atRiskUsers,
      const DeepCollectionEquality().hash(_churnReasons),
      const DeepCollectionEquality().hash(_predictions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChurnAnalysisImplCopyWith<_$ChurnAnalysisImpl> get copyWith =>
      __$$ChurnAnalysisImplCopyWithImpl<_$ChurnAnalysisImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChurnAnalysisImplToJson(
      this,
    );
  }
}

abstract class _ChurnAnalysis implements ChurnAnalysis {
  const factory _ChurnAnalysis(
      {required final double churnRate,
      required final int atRiskUsers,
      required final Map<String, double> churnReasons,
      required final List<ChurnPrediction> predictions}) = _$ChurnAnalysisImpl;

  factory _ChurnAnalysis.fromJson(Map<String, dynamic> json) =
      _$ChurnAnalysisImpl.fromJson;

  @override
  double get churnRate;
  @override
  int get atRiskUsers;
  @override
  Map<String, double> get churnReasons;
  @override
  List<ChurnPrediction> get predictions;
  @override
  @JsonKey(ignore: true)
  _$$ChurnAnalysisImplCopyWith<_$ChurnAnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChurnPrediction _$ChurnPredictionFromJson(Map<String, dynamic> json) {
  return _ChurnPrediction.fromJson(json);
}

/// @nodoc
mixin _$ChurnPrediction {
  String get userId => throw _privateConstructorUsedError;
  double get churnProbability => throw _privateConstructorUsedError;
  List<String> get riskFactors => throw _privateConstructorUsedError;
  DateTime get predictedChurnDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChurnPredictionCopyWith<ChurnPrediction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChurnPredictionCopyWith<$Res> {
  factory $ChurnPredictionCopyWith(
          ChurnPrediction value, $Res Function(ChurnPrediction) then) =
      _$ChurnPredictionCopyWithImpl<$Res, ChurnPrediction>;
  @useResult
  $Res call(
      {String userId,
      double churnProbability,
      List<String> riskFactors,
      DateTime predictedChurnDate});
}

/// @nodoc
class _$ChurnPredictionCopyWithImpl<$Res, $Val extends ChurnPrediction>
    implements $ChurnPredictionCopyWith<$Res> {
  _$ChurnPredictionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? churnProbability = null,
    Object? riskFactors = null,
    Object? predictedChurnDate = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      churnProbability: null == churnProbability
          ? _value.churnProbability
          : churnProbability // ignore: cast_nullable_to_non_nullable
              as double,
      riskFactors: null == riskFactors
          ? _value.riskFactors
          : riskFactors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      predictedChurnDate: null == predictedChurnDate
          ? _value.predictedChurnDate
          : predictedChurnDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChurnPredictionImplCopyWith<$Res>
    implements $ChurnPredictionCopyWith<$Res> {
  factory _$$ChurnPredictionImplCopyWith(_$ChurnPredictionImpl value,
          $Res Function(_$ChurnPredictionImpl) then) =
      __$$ChurnPredictionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      double churnProbability,
      List<String> riskFactors,
      DateTime predictedChurnDate});
}

/// @nodoc
class __$$ChurnPredictionImplCopyWithImpl<$Res>
    extends _$ChurnPredictionCopyWithImpl<$Res, _$ChurnPredictionImpl>
    implements _$$ChurnPredictionImplCopyWith<$Res> {
  __$$ChurnPredictionImplCopyWithImpl(
      _$ChurnPredictionImpl _value, $Res Function(_$ChurnPredictionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? churnProbability = null,
    Object? riskFactors = null,
    Object? predictedChurnDate = null,
  }) {
    return _then(_$ChurnPredictionImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      churnProbability: null == churnProbability
          ? _value.churnProbability
          : churnProbability // ignore: cast_nullable_to_non_nullable
              as double,
      riskFactors: null == riskFactors
          ? _value._riskFactors
          : riskFactors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      predictedChurnDate: null == predictedChurnDate
          ? _value.predictedChurnDate
          : predictedChurnDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChurnPredictionImpl implements _ChurnPrediction {
  const _$ChurnPredictionImpl(
      {required this.userId,
      required this.churnProbability,
      required final List<String> riskFactors,
      required this.predictedChurnDate})
      : _riskFactors = riskFactors;

  factory _$ChurnPredictionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChurnPredictionImplFromJson(json);

  @override
  final String userId;
  @override
  final double churnProbability;
  final List<String> _riskFactors;
  @override
  List<String> get riskFactors {
    if (_riskFactors is EqualUnmodifiableListView) return _riskFactors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_riskFactors);
  }

  @override
  final DateTime predictedChurnDate;

  @override
  String toString() {
    return 'ChurnPrediction(userId: $userId, churnProbability: $churnProbability, riskFactors: $riskFactors, predictedChurnDate: $predictedChurnDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChurnPredictionImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.churnProbability, churnProbability) ||
                other.churnProbability == churnProbability) &&
            const DeepCollectionEquality()
                .equals(other._riskFactors, _riskFactors) &&
            (identical(other.predictedChurnDate, predictedChurnDate) ||
                other.predictedChurnDate == predictedChurnDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userId, churnProbability,
      const DeepCollectionEquality().hash(_riskFactors), predictedChurnDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChurnPredictionImplCopyWith<_$ChurnPredictionImpl> get copyWith =>
      __$$ChurnPredictionImplCopyWithImpl<_$ChurnPredictionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChurnPredictionImplToJson(
      this,
    );
  }
}

abstract class _ChurnPrediction implements ChurnPrediction {
  const factory _ChurnPrediction(
      {required final String userId,
      required final double churnProbability,
      required final List<String> riskFactors,
      required final DateTime predictedChurnDate}) = _$ChurnPredictionImpl;

  factory _ChurnPrediction.fromJson(Map<String, dynamic> json) =
      _$ChurnPredictionImpl.fromJson;

  @override
  String get userId;
  @override
  double get churnProbability;
  @override
  List<String> get riskFactors;
  @override
  DateTime get predictedChurnDate;
  @override
  @JsonKey(ignore: true)
  _$$ChurnPredictionImplCopyWith<_$ChurnPredictionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BehaviorPattern _$BehaviorPatternFromJson(Map<String, dynamic> json) {
  return _BehaviorPattern.fromJson(json);
}

/// @nodoc
mixin _$BehaviorPattern {
  String get patternId => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get frequency => throw _privateConstructorUsedError;
  List<String> get userSegments => throw _privateConstructorUsedError;
  Map<String, dynamic> get characteristics =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BehaviorPatternCopyWith<BehaviorPattern> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BehaviorPatternCopyWith<$Res> {
  factory $BehaviorPatternCopyWith(
          BehaviorPattern value, $Res Function(BehaviorPattern) then) =
      _$BehaviorPatternCopyWithImpl<$Res, BehaviorPattern>;
  @useResult
  $Res call(
      {String patternId,
      String description,
      double frequency,
      List<String> userSegments,
      Map<String, dynamic> characteristics});
}

/// @nodoc
class _$BehaviorPatternCopyWithImpl<$Res, $Val extends BehaviorPattern>
    implements $BehaviorPatternCopyWith<$Res> {
  _$BehaviorPatternCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? patternId = null,
    Object? description = null,
    Object? frequency = null,
    Object? userSegments = null,
    Object? characteristics = null,
  }) {
    return _then(_value.copyWith(
      patternId: null == patternId
          ? _value.patternId
          : patternId // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as double,
      userSegments: null == userSegments
          ? _value.userSegments
          : userSegments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      characteristics: null == characteristics
          ? _value.characteristics
          : characteristics // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BehaviorPatternImplCopyWith<$Res>
    implements $BehaviorPatternCopyWith<$Res> {
  factory _$$BehaviorPatternImplCopyWith(_$BehaviorPatternImpl value,
          $Res Function(_$BehaviorPatternImpl) then) =
      __$$BehaviorPatternImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String patternId,
      String description,
      double frequency,
      List<String> userSegments,
      Map<String, dynamic> characteristics});
}

/// @nodoc
class __$$BehaviorPatternImplCopyWithImpl<$Res>
    extends _$BehaviorPatternCopyWithImpl<$Res, _$BehaviorPatternImpl>
    implements _$$BehaviorPatternImplCopyWith<$Res> {
  __$$BehaviorPatternImplCopyWithImpl(
      _$BehaviorPatternImpl _value, $Res Function(_$BehaviorPatternImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? patternId = null,
    Object? description = null,
    Object? frequency = null,
    Object? userSegments = null,
    Object? characteristics = null,
  }) {
    return _then(_$BehaviorPatternImpl(
      patternId: null == patternId
          ? _value.patternId
          : patternId // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as double,
      userSegments: null == userSegments
          ? _value._userSegments
          : userSegments // ignore: cast_nullable_to_non_nullable
              as List<String>,
      characteristics: null == characteristics
          ? _value._characteristics
          : characteristics // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BehaviorPatternImpl implements _BehaviorPattern {
  const _$BehaviorPatternImpl(
      {required this.patternId,
      required this.description,
      required this.frequency,
      required final List<String> userSegments,
      required final Map<String, dynamic> characteristics})
      : _userSegments = userSegments,
        _characteristics = characteristics;

  factory _$BehaviorPatternImpl.fromJson(Map<String, dynamic> json) =>
      _$$BehaviorPatternImplFromJson(json);

  @override
  final String patternId;
  @override
  final String description;
  @override
  final double frequency;
  final List<String> _userSegments;
  @override
  List<String> get userSegments {
    if (_userSegments is EqualUnmodifiableListView) return _userSegments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userSegments);
  }

  final Map<String, dynamic> _characteristics;
  @override
  Map<String, dynamic> get characteristics {
    if (_characteristics is EqualUnmodifiableMapView) return _characteristics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_characteristics);
  }

  @override
  String toString() {
    return 'BehaviorPattern(patternId: $patternId, description: $description, frequency: $frequency, userSegments: $userSegments, characteristics: $characteristics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BehaviorPatternImpl &&
            (identical(other.patternId, patternId) ||
                other.patternId == patternId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            const DeepCollectionEquality()
                .equals(other._userSegments, _userSegments) &&
            const DeepCollectionEquality()
                .equals(other._characteristics, _characteristics));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      patternId,
      description,
      frequency,
      const DeepCollectionEquality().hash(_userSegments),
      const DeepCollectionEquality().hash(_characteristics));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BehaviorPatternImplCopyWith<_$BehaviorPatternImpl> get copyWith =>
      __$$BehaviorPatternImplCopyWithImpl<_$BehaviorPatternImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BehaviorPatternImplToJson(
      this,
    );
  }
}

abstract class _BehaviorPattern implements BehaviorPattern {
  const factory _BehaviorPattern(
          {required final String patternId,
          required final String description,
          required final double frequency,
          required final List<String> userSegments,
          required final Map<String, dynamic> characteristics}) =
      _$BehaviorPatternImpl;

  factory _BehaviorPattern.fromJson(Map<String, dynamic> json) =
      _$BehaviorPatternImpl.fromJson;

  @override
  String get patternId;
  @override
  String get description;
  @override
  double get frequency;
  @override
  List<String> get userSegments;
  @override
  Map<String, dynamic> get characteristics;
  @override
  @JsonKey(ignore: true)
  _$$BehaviorPatternImplCopyWith<_$BehaviorPatternImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BusinessIntelligenceData _$BusinessIntelligenceDataFromJson(
    Map<String, dynamic> json) {
  return _BusinessIntelligenceData.fromJson(json);
}

/// @nodoc
mixin _$BusinessIntelligenceData {
  Map<String, MetricValue> get keyMetrics => throw _privateConstructorUsedError;
  List<TrendData> get trends => throw _privateConstructorUsedError;
  List<PredictiveInsight> get predictions => throw _privateConstructorUsedError;
  List<BusinessRecommendation> get recommendations =>
      throw _privateConstructorUsedError;
  CompetitiveAnalysis get competitiveAnalysis =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BusinessIntelligenceDataCopyWith<BusinessIntelligenceData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessIntelligenceDataCopyWith<$Res> {
  factory $BusinessIntelligenceDataCopyWith(BusinessIntelligenceData value,
          $Res Function(BusinessIntelligenceData) then) =
      _$BusinessIntelligenceDataCopyWithImpl<$Res, BusinessIntelligenceData>;
  @useResult
  $Res call(
      {Map<String, MetricValue> keyMetrics,
      List<TrendData> trends,
      List<PredictiveInsight> predictions,
      List<BusinessRecommendation> recommendations,
      CompetitiveAnalysis competitiveAnalysis});

  $CompetitiveAnalysisCopyWith<$Res> get competitiveAnalysis;
}

/// @nodoc
class _$BusinessIntelligenceDataCopyWithImpl<$Res,
        $Val extends BusinessIntelligenceData>
    implements $BusinessIntelligenceDataCopyWith<$Res> {
  _$BusinessIntelligenceDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? keyMetrics = null,
    Object? trends = null,
    Object? predictions = null,
    Object? recommendations = null,
    Object? competitiveAnalysis = null,
  }) {
    return _then(_value.copyWith(
      keyMetrics: null == keyMetrics
          ? _value.keyMetrics
          : keyMetrics // ignore: cast_nullable_to_non_nullable
              as Map<String, MetricValue>,
      trends: null == trends
          ? _value.trends
          : trends // ignore: cast_nullable_to_non_nullable
              as List<TrendData>,
      predictions: null == predictions
          ? _value.predictions
          : predictions // ignore: cast_nullable_to_non_nullable
              as List<PredictiveInsight>,
      recommendations: null == recommendations
          ? _value.recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<BusinessRecommendation>,
      competitiveAnalysis: null == competitiveAnalysis
          ? _value.competitiveAnalysis
          : competitiveAnalysis // ignore: cast_nullable_to_non_nullable
              as CompetitiveAnalysis,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CompetitiveAnalysisCopyWith<$Res> get competitiveAnalysis {
    return $CompetitiveAnalysisCopyWith<$Res>(_value.competitiveAnalysis,
        (value) {
      return _then(_value.copyWith(competitiveAnalysis: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BusinessIntelligenceDataImplCopyWith<$Res>
    implements $BusinessIntelligenceDataCopyWith<$Res> {
  factory _$$BusinessIntelligenceDataImplCopyWith(
          _$BusinessIntelligenceDataImpl value,
          $Res Function(_$BusinessIntelligenceDataImpl) then) =
      __$$BusinessIntelligenceDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, MetricValue> keyMetrics,
      List<TrendData> trends,
      List<PredictiveInsight> predictions,
      List<BusinessRecommendation> recommendations,
      CompetitiveAnalysis competitiveAnalysis});

  @override
  $CompetitiveAnalysisCopyWith<$Res> get competitiveAnalysis;
}

/// @nodoc
class __$$BusinessIntelligenceDataImplCopyWithImpl<$Res>
    extends _$BusinessIntelligenceDataCopyWithImpl<$Res,
        _$BusinessIntelligenceDataImpl>
    implements _$$BusinessIntelligenceDataImplCopyWith<$Res> {
  __$$BusinessIntelligenceDataImplCopyWithImpl(
      _$BusinessIntelligenceDataImpl _value,
      $Res Function(_$BusinessIntelligenceDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? keyMetrics = null,
    Object? trends = null,
    Object? predictions = null,
    Object? recommendations = null,
    Object? competitiveAnalysis = null,
  }) {
    return _then(_$BusinessIntelligenceDataImpl(
      keyMetrics: null == keyMetrics
          ? _value._keyMetrics
          : keyMetrics // ignore: cast_nullable_to_non_nullable
              as Map<String, MetricValue>,
      trends: null == trends
          ? _value._trends
          : trends // ignore: cast_nullable_to_non_nullable
              as List<TrendData>,
      predictions: null == predictions
          ? _value._predictions
          : predictions // ignore: cast_nullable_to_non_nullable
              as List<PredictiveInsight>,
      recommendations: null == recommendations
          ? _value._recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<BusinessRecommendation>,
      competitiveAnalysis: null == competitiveAnalysis
          ? _value.competitiveAnalysis
          : competitiveAnalysis // ignore: cast_nullable_to_non_nullable
              as CompetitiveAnalysis,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BusinessIntelligenceDataImpl implements _BusinessIntelligenceData {
  const _$BusinessIntelligenceDataImpl(
      {required final Map<String, MetricValue> keyMetrics,
      required final List<TrendData> trends,
      required final List<PredictiveInsight> predictions,
      required final List<BusinessRecommendation> recommendations,
      required this.competitiveAnalysis})
      : _keyMetrics = keyMetrics,
        _trends = trends,
        _predictions = predictions,
        _recommendations = recommendations;

  factory _$BusinessIntelligenceDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusinessIntelligenceDataImplFromJson(json);

  final Map<String, MetricValue> _keyMetrics;
  @override
  Map<String, MetricValue> get keyMetrics {
    if (_keyMetrics is EqualUnmodifiableMapView) return _keyMetrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_keyMetrics);
  }

  final List<TrendData> _trends;
  @override
  List<TrendData> get trends {
    if (_trends is EqualUnmodifiableListView) return _trends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trends);
  }

  final List<PredictiveInsight> _predictions;
  @override
  List<PredictiveInsight> get predictions {
    if (_predictions is EqualUnmodifiableListView) return _predictions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_predictions);
  }

  final List<BusinessRecommendation> _recommendations;
  @override
  List<BusinessRecommendation> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  @override
  final CompetitiveAnalysis competitiveAnalysis;

  @override
  String toString() {
    return 'BusinessIntelligenceData(keyMetrics: $keyMetrics, trends: $trends, predictions: $predictions, recommendations: $recommendations, competitiveAnalysis: $competitiveAnalysis)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessIntelligenceDataImpl &&
            const DeepCollectionEquality()
                .equals(other._keyMetrics, _keyMetrics) &&
            const DeepCollectionEquality().equals(other._trends, _trends) &&
            const DeepCollectionEquality()
                .equals(other._predictions, _predictions) &&
            const DeepCollectionEquality()
                .equals(other._recommendations, _recommendations) &&
            (identical(other.competitiveAnalysis, competitiveAnalysis) ||
                other.competitiveAnalysis == competitiveAnalysis));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_keyMetrics),
      const DeepCollectionEquality().hash(_trends),
      const DeepCollectionEquality().hash(_predictions),
      const DeepCollectionEquality().hash(_recommendations),
      competitiveAnalysis);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessIntelligenceDataImplCopyWith<_$BusinessIntelligenceDataImpl>
      get copyWith => __$$BusinessIntelligenceDataImplCopyWithImpl<
          _$BusinessIntelligenceDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BusinessIntelligenceDataImplToJson(
      this,
    );
  }
}

abstract class _BusinessIntelligenceData implements BusinessIntelligenceData {
  const factory _BusinessIntelligenceData(
          {required final Map<String, MetricValue> keyMetrics,
          required final List<TrendData> trends,
          required final List<PredictiveInsight> predictions,
          required final List<BusinessRecommendation> recommendations,
          required final CompetitiveAnalysis competitiveAnalysis}) =
      _$BusinessIntelligenceDataImpl;

  factory _BusinessIntelligenceData.fromJson(Map<String, dynamic> json) =
      _$BusinessIntelligenceDataImpl.fromJson;

  @override
  Map<String, MetricValue> get keyMetrics;
  @override
  List<TrendData> get trends;
  @override
  List<PredictiveInsight> get predictions;
  @override
  List<BusinessRecommendation> get recommendations;
  @override
  CompetitiveAnalysis get competitiveAnalysis;
  @override
  @JsonKey(ignore: true)
  _$$BusinessIntelligenceDataImplCopyWith<_$BusinessIntelligenceDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

MetricValue _$MetricValueFromJson(Map<String, dynamic> json) {
  return _MetricValue.fromJson(json);
}

/// @nodoc
mixin _$MetricValue {
  double get current => throw _privateConstructorUsedError;
  double get previous => throw _privateConstructorUsedError;
  double get change => throw _privateConstructorUsedError;
  String get changeType =>
      throw _privateConstructorUsedError; // 'increase', 'decrease', 'stable'
  String? get unit => throw _privateConstructorUsedError;
  String? get format => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MetricValueCopyWith<MetricValue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetricValueCopyWith<$Res> {
  factory $MetricValueCopyWith(
          MetricValue value, $Res Function(MetricValue) then) =
      _$MetricValueCopyWithImpl<$Res, MetricValue>;
  @useResult
  $Res call(
      {double current,
      double previous,
      double change,
      String changeType,
      String? unit,
      String? format});
}

/// @nodoc
class _$MetricValueCopyWithImpl<$Res, $Val extends MetricValue>
    implements $MetricValueCopyWith<$Res> {
  _$MetricValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? previous = null,
    Object? change = null,
    Object? changeType = null,
    Object? unit = freezed,
    Object? format = freezed,
  }) {
    return _then(_value.copyWith(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as double,
      previous: null == previous
          ? _value.previous
          : previous // ignore: cast_nullable_to_non_nullable
              as double,
      change: null == change
          ? _value.change
          : change // ignore: cast_nullable_to_non_nullable
              as double,
      changeType: null == changeType
          ? _value.changeType
          : changeType // ignore: cast_nullable_to_non_nullable
              as String,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      format: freezed == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MetricValueImplCopyWith<$Res>
    implements $MetricValueCopyWith<$Res> {
  factory _$$MetricValueImplCopyWith(
          _$MetricValueImpl value, $Res Function(_$MetricValueImpl) then) =
      __$$MetricValueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double current,
      double previous,
      double change,
      String changeType,
      String? unit,
      String? format});
}

/// @nodoc
class __$$MetricValueImplCopyWithImpl<$Res>
    extends _$MetricValueCopyWithImpl<$Res, _$MetricValueImpl>
    implements _$$MetricValueImplCopyWith<$Res> {
  __$$MetricValueImplCopyWithImpl(
      _$MetricValueImpl _value, $Res Function(_$MetricValueImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? previous = null,
    Object? change = null,
    Object? changeType = null,
    Object? unit = freezed,
    Object? format = freezed,
  }) {
    return _then(_$MetricValueImpl(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as double,
      previous: null == previous
          ? _value.previous
          : previous // ignore: cast_nullable_to_non_nullable
              as double,
      change: null == change
          ? _value.change
          : change // ignore: cast_nullable_to_non_nullable
              as double,
      changeType: null == changeType
          ? _value.changeType
          : changeType // ignore: cast_nullable_to_non_nullable
              as String,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      format: freezed == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MetricValueImpl implements _MetricValue {
  const _$MetricValueImpl(
      {required this.current,
      required this.previous,
      required this.change,
      required this.changeType,
      this.unit,
      this.format});

  factory _$MetricValueImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetricValueImplFromJson(json);

  @override
  final double current;
  @override
  final double previous;
  @override
  final double change;
  @override
  final String changeType;
// 'increase', 'decrease', 'stable'
  @override
  final String? unit;
  @override
  final String? format;

  @override
  String toString() {
    return 'MetricValue(current: $current, previous: $previous, change: $change, changeType: $changeType, unit: $unit, format: $format)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetricValueImpl &&
            (identical(other.current, current) || other.current == current) &&
            (identical(other.previous, previous) ||
                other.previous == previous) &&
            (identical(other.change, change) || other.change == change) &&
            (identical(other.changeType, changeType) ||
                other.changeType == changeType) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.format, format) || other.format == format));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, current, previous, change, changeType, unit, format);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MetricValueImplCopyWith<_$MetricValueImpl> get copyWith =>
      __$$MetricValueImplCopyWithImpl<_$MetricValueImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MetricValueImplToJson(
      this,
    );
  }
}

abstract class _MetricValue implements MetricValue {
  const factory _MetricValue(
      {required final double current,
      required final double previous,
      required final double change,
      required final String changeType,
      final String? unit,
      final String? format}) = _$MetricValueImpl;

  factory _MetricValue.fromJson(Map<String, dynamic> json) =
      _$MetricValueImpl.fromJson;

  @override
  double get current;
  @override
  double get previous;
  @override
  double get change;
  @override
  String get changeType;
  @override // 'increase', 'decrease', 'stable'
  String? get unit;
  @override
  String? get format;
  @override
  @JsonKey(ignore: true)
  _$$MetricValueImplCopyWith<_$MetricValueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TrendData _$TrendDataFromJson(Map<String, dynamic> json) {
  return _TrendData.fromJson(json);
}

/// @nodoc
mixin _$TrendData {
  String get metric => throw _privateConstructorUsedError;
  List<TimeSeriesData> get data => throw _privateConstructorUsedError;
  String get trendDirection =>
      throw _privateConstructorUsedError; // 'up', 'down', 'stable'
  double get trendStrength => throw _privateConstructorUsedError;
  List<String>? get influencingFactors => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TrendDataCopyWith<TrendData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrendDataCopyWith<$Res> {
  factory $TrendDataCopyWith(TrendData value, $Res Function(TrendData) then) =
      _$TrendDataCopyWithImpl<$Res, TrendData>;
  @useResult
  $Res call(
      {String metric,
      List<TimeSeriesData> data,
      String trendDirection,
      double trendStrength,
      List<String>? influencingFactors});
}

/// @nodoc
class _$TrendDataCopyWithImpl<$Res, $Val extends TrendData>
    implements $TrendDataCopyWith<$Res> {
  _$TrendDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? metric = null,
    Object? data = null,
    Object? trendDirection = null,
    Object? trendStrength = null,
    Object? influencingFactors = freezed,
  }) {
    return _then(_value.copyWith(
      metric: null == metric
          ? _value.metric
          : metric // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<TimeSeriesData>,
      trendDirection: null == trendDirection
          ? _value.trendDirection
          : trendDirection // ignore: cast_nullable_to_non_nullable
              as String,
      trendStrength: null == trendStrength
          ? _value.trendStrength
          : trendStrength // ignore: cast_nullable_to_non_nullable
              as double,
      influencingFactors: freezed == influencingFactors
          ? _value.influencingFactors
          : influencingFactors // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrendDataImplCopyWith<$Res>
    implements $TrendDataCopyWith<$Res> {
  factory _$$TrendDataImplCopyWith(
          _$TrendDataImpl value, $Res Function(_$TrendDataImpl) then) =
      __$$TrendDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String metric,
      List<TimeSeriesData> data,
      String trendDirection,
      double trendStrength,
      List<String>? influencingFactors});
}

/// @nodoc
class __$$TrendDataImplCopyWithImpl<$Res>
    extends _$TrendDataCopyWithImpl<$Res, _$TrendDataImpl>
    implements _$$TrendDataImplCopyWith<$Res> {
  __$$TrendDataImplCopyWithImpl(
      _$TrendDataImpl _value, $Res Function(_$TrendDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? metric = null,
    Object? data = null,
    Object? trendDirection = null,
    Object? trendStrength = null,
    Object? influencingFactors = freezed,
  }) {
    return _then(_$TrendDataImpl(
      metric: null == metric
          ? _value.metric
          : metric // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<TimeSeriesData>,
      trendDirection: null == trendDirection
          ? _value.trendDirection
          : trendDirection // ignore: cast_nullable_to_non_nullable
              as String,
      trendStrength: null == trendStrength
          ? _value.trendStrength
          : trendStrength // ignore: cast_nullable_to_non_nullable
              as double,
      influencingFactors: freezed == influencingFactors
          ? _value._influencingFactors
          : influencingFactors // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrendDataImpl implements _TrendData {
  const _$TrendDataImpl(
      {required this.metric,
      required final List<TimeSeriesData> data,
      required this.trendDirection,
      required this.trendStrength,
      final List<String>? influencingFactors})
      : _data = data,
        _influencingFactors = influencingFactors;

  factory _$TrendDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrendDataImplFromJson(json);

  @override
  final String metric;
  final List<TimeSeriesData> _data;
  @override
  List<TimeSeriesData> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final String trendDirection;
// 'up', 'down', 'stable'
  @override
  final double trendStrength;
  final List<String>? _influencingFactors;
  @override
  List<String>? get influencingFactors {
    final value = _influencingFactors;
    if (value == null) return null;
    if (_influencingFactors is EqualUnmodifiableListView)
      return _influencingFactors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'TrendData(metric: $metric, data: $data, trendDirection: $trendDirection, trendStrength: $trendStrength, influencingFactors: $influencingFactors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrendDataImpl &&
            (identical(other.metric, metric) || other.metric == metric) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.trendDirection, trendDirection) ||
                other.trendDirection == trendDirection) &&
            (identical(other.trendStrength, trendStrength) ||
                other.trendStrength == trendStrength) &&
            const DeepCollectionEquality()
                .equals(other._influencingFactors, _influencingFactors));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      metric,
      const DeepCollectionEquality().hash(_data),
      trendDirection,
      trendStrength,
      const DeepCollectionEquality().hash(_influencingFactors));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TrendDataImplCopyWith<_$TrendDataImpl> get copyWith =>
      __$$TrendDataImplCopyWithImpl<_$TrendDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrendDataImplToJson(
      this,
    );
  }
}

abstract class _TrendData implements TrendData {
  const factory _TrendData(
      {required final String metric,
      required final List<TimeSeriesData> data,
      required final String trendDirection,
      required final double trendStrength,
      final List<String>? influencingFactors}) = _$TrendDataImpl;

  factory _TrendData.fromJson(Map<String, dynamic> json) =
      _$TrendDataImpl.fromJson;

  @override
  String get metric;
  @override
  List<TimeSeriesData> get data;
  @override
  String get trendDirection;
  @override // 'up', 'down', 'stable'
  double get trendStrength;
  @override
  List<String>? get influencingFactors;
  @override
  @JsonKey(ignore: true)
  _$$TrendDataImplCopyWith<_$TrendDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PredictiveInsight _$PredictiveInsightFromJson(Map<String, dynamic> json) {
  return _PredictiveInsight.fromJson(json);
}

/// @nodoc
mixin _$PredictiveInsight {
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'positive', 'negative', 'warning', 'neutral'
  DateTime get predictedDate => throw _privateConstructorUsedError;
  Map<String, dynamic>? get supportingData =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PredictiveInsightCopyWith<PredictiveInsight> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PredictiveInsightCopyWith<$Res> {
  factory $PredictiveInsightCopyWith(
          PredictiveInsight value, $Res Function(PredictiveInsight) then) =
      _$PredictiveInsightCopyWithImpl<$Res, PredictiveInsight>;
  @useResult
  $Res call(
      {String title,
      String description,
      double confidence,
      String type,
      DateTime predictedDate,
      Map<String, dynamic>? supportingData});
}

/// @nodoc
class _$PredictiveInsightCopyWithImpl<$Res, $Val extends PredictiveInsight>
    implements $PredictiveInsightCopyWith<$Res> {
  _$PredictiveInsightCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? confidence = null,
    Object? type = null,
    Object? predictedDate = null,
    Object? supportingData = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      predictedDate: null == predictedDate
          ? _value.predictedDate
          : predictedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      supportingData: freezed == supportingData
          ? _value.supportingData
          : supportingData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PredictiveInsightImplCopyWith<$Res>
    implements $PredictiveInsightCopyWith<$Res> {
  factory _$$PredictiveInsightImplCopyWith(_$PredictiveInsightImpl value,
          $Res Function(_$PredictiveInsightImpl) then) =
      __$$PredictiveInsightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String description,
      double confidence,
      String type,
      DateTime predictedDate,
      Map<String, dynamic>? supportingData});
}

/// @nodoc
class __$$PredictiveInsightImplCopyWithImpl<$Res>
    extends _$PredictiveInsightCopyWithImpl<$Res, _$PredictiveInsightImpl>
    implements _$$PredictiveInsightImplCopyWith<$Res> {
  __$$PredictiveInsightImplCopyWithImpl(_$PredictiveInsightImpl _value,
      $Res Function(_$PredictiveInsightImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? confidence = null,
    Object? type = null,
    Object? predictedDate = null,
    Object? supportingData = freezed,
  }) {
    return _then(_$PredictiveInsightImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      predictedDate: null == predictedDate
          ? _value.predictedDate
          : predictedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      supportingData: freezed == supportingData
          ? _value._supportingData
          : supportingData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PredictiveInsightImpl implements _PredictiveInsight {
  const _$PredictiveInsightImpl(
      {required this.title,
      required this.description,
      required this.confidence,
      required this.type,
      required this.predictedDate,
      final Map<String, dynamic>? supportingData})
      : _supportingData = supportingData;

  factory _$PredictiveInsightImpl.fromJson(Map<String, dynamic> json) =>
      _$$PredictiveInsightImplFromJson(json);

  @override
  final String title;
  @override
  final String description;
  @override
  final double confidence;
  @override
  final String type;
// 'positive', 'negative', 'warning', 'neutral'
  @override
  final DateTime predictedDate;
  final Map<String, dynamic>? _supportingData;
  @override
  Map<String, dynamic>? get supportingData {
    final value = _supportingData;
    if (value == null) return null;
    if (_supportingData is EqualUnmodifiableMapView) return _supportingData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'PredictiveInsight(title: $title, description: $description, confidence: $confidence, type: $type, predictedDate: $predictedDate, supportingData: $supportingData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PredictiveInsightImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.predictedDate, predictedDate) ||
                other.predictedDate == predictedDate) &&
            const DeepCollectionEquality()
                .equals(other._supportingData, _supportingData));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      description,
      confidence,
      type,
      predictedDate,
      const DeepCollectionEquality().hash(_supportingData));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PredictiveInsightImplCopyWith<_$PredictiveInsightImpl> get copyWith =>
      __$$PredictiveInsightImplCopyWithImpl<_$PredictiveInsightImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PredictiveInsightImplToJson(
      this,
    );
  }
}

abstract class _PredictiveInsight implements PredictiveInsight {
  const factory _PredictiveInsight(
      {required final String title,
      required final String description,
      required final double confidence,
      required final String type,
      required final DateTime predictedDate,
      final Map<String, dynamic>? supportingData}) = _$PredictiveInsightImpl;

  factory _PredictiveInsight.fromJson(Map<String, dynamic> json) =
      _$PredictiveInsightImpl.fromJson;

  @override
  String get title;
  @override
  String get description;
  @override
  double get confidence;
  @override
  String get type;
  @override // 'positive', 'negative', 'warning', 'neutral'
  DateTime get predictedDate;
  @override
  Map<String, dynamic>? get supportingData;
  @override
  @JsonKey(ignore: true)
  _$$PredictiveInsightImplCopyWith<_$PredictiveInsightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BusinessRecommendation _$BusinessRecommendationFromJson(
    Map<String, dynamic> json) {
  return _BusinessRecommendation.fromJson(json);
}

/// @nodoc
mixin _$BusinessRecommendation {
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get priority =>
      throw _privateConstructorUsedError; // 'high', 'medium', 'low'
  String get impact => throw _privateConstructorUsedError;
  List<String> get actionItems => throw _privateConstructorUsedError;
  double get estimatedROI => throw _privateConstructorUsedError;
  Map<String, dynamic>? get implementation =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BusinessRecommendationCopyWith<BusinessRecommendation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessRecommendationCopyWith<$Res> {
  factory $BusinessRecommendationCopyWith(BusinessRecommendation value,
          $Res Function(BusinessRecommendation) then) =
      _$BusinessRecommendationCopyWithImpl<$Res, BusinessRecommendation>;
  @useResult
  $Res call(
      {String title,
      String description,
      String priority,
      String impact,
      List<String> actionItems,
      double estimatedROI,
      Map<String, dynamic>? implementation});
}

/// @nodoc
class _$BusinessRecommendationCopyWithImpl<$Res,
        $Val extends BusinessRecommendation>
    implements $BusinessRecommendationCopyWith<$Res> {
  _$BusinessRecommendationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? priority = null,
    Object? impact = null,
    Object? actionItems = null,
    Object? estimatedROI = null,
    Object? implementation = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      impact: null == impact
          ? _value.impact
          : impact // ignore: cast_nullable_to_non_nullable
              as String,
      actionItems: null == actionItems
          ? _value.actionItems
          : actionItems // ignore: cast_nullable_to_non_nullable
              as List<String>,
      estimatedROI: null == estimatedROI
          ? _value.estimatedROI
          : estimatedROI // ignore: cast_nullable_to_non_nullable
              as double,
      implementation: freezed == implementation
          ? _value.implementation
          : implementation // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BusinessRecommendationImplCopyWith<$Res>
    implements $BusinessRecommendationCopyWith<$Res> {
  factory _$$BusinessRecommendationImplCopyWith(
          _$BusinessRecommendationImpl value,
          $Res Function(_$BusinessRecommendationImpl) then) =
      __$$BusinessRecommendationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String description,
      String priority,
      String impact,
      List<String> actionItems,
      double estimatedROI,
      Map<String, dynamic>? implementation});
}

/// @nodoc
class __$$BusinessRecommendationImplCopyWithImpl<$Res>
    extends _$BusinessRecommendationCopyWithImpl<$Res,
        _$BusinessRecommendationImpl>
    implements _$$BusinessRecommendationImplCopyWith<$Res> {
  __$$BusinessRecommendationImplCopyWithImpl(
      _$BusinessRecommendationImpl _value,
      $Res Function(_$BusinessRecommendationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? priority = null,
    Object? impact = null,
    Object? actionItems = null,
    Object? estimatedROI = null,
    Object? implementation = freezed,
  }) {
    return _then(_$BusinessRecommendationImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      impact: null == impact
          ? _value.impact
          : impact // ignore: cast_nullable_to_non_nullable
              as String,
      actionItems: null == actionItems
          ? _value._actionItems
          : actionItems // ignore: cast_nullable_to_non_nullable
              as List<String>,
      estimatedROI: null == estimatedROI
          ? _value.estimatedROI
          : estimatedROI // ignore: cast_nullable_to_non_nullable
              as double,
      implementation: freezed == implementation
          ? _value._implementation
          : implementation // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BusinessRecommendationImpl implements _BusinessRecommendation {
  const _$BusinessRecommendationImpl(
      {required this.title,
      required this.description,
      required this.priority,
      required this.impact,
      required final List<String> actionItems,
      required this.estimatedROI,
      final Map<String, dynamic>? implementation})
      : _actionItems = actionItems,
        _implementation = implementation;

  factory _$BusinessRecommendationImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusinessRecommendationImplFromJson(json);

  @override
  final String title;
  @override
  final String description;
  @override
  final String priority;
// 'high', 'medium', 'low'
  @override
  final String impact;
  final List<String> _actionItems;
  @override
  List<String> get actionItems {
    if (_actionItems is EqualUnmodifiableListView) return _actionItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actionItems);
  }

  @override
  final double estimatedROI;
  final Map<String, dynamic>? _implementation;
  @override
  Map<String, dynamic>? get implementation {
    final value = _implementation;
    if (value == null) return null;
    if (_implementation is EqualUnmodifiableMapView) return _implementation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'BusinessRecommendation(title: $title, description: $description, priority: $priority, impact: $impact, actionItems: $actionItems, estimatedROI: $estimatedROI, implementation: $implementation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessRecommendationImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.impact, impact) || other.impact == impact) &&
            const DeepCollectionEquality()
                .equals(other._actionItems, _actionItems) &&
            (identical(other.estimatedROI, estimatedROI) ||
                other.estimatedROI == estimatedROI) &&
            const DeepCollectionEquality()
                .equals(other._implementation, _implementation));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      description,
      priority,
      impact,
      const DeepCollectionEquality().hash(_actionItems),
      estimatedROI,
      const DeepCollectionEquality().hash(_implementation));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessRecommendationImplCopyWith<_$BusinessRecommendationImpl>
      get copyWith => __$$BusinessRecommendationImplCopyWithImpl<
          _$BusinessRecommendationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BusinessRecommendationImplToJson(
      this,
    );
  }
}

abstract class _BusinessRecommendation implements BusinessRecommendation {
  const factory _BusinessRecommendation(
          {required final String title,
          required final String description,
          required final String priority,
          required final String impact,
          required final List<String> actionItems,
          required final double estimatedROI,
          final Map<String, dynamic>? implementation}) =
      _$BusinessRecommendationImpl;

  factory _BusinessRecommendation.fromJson(Map<String, dynamic> json) =
      _$BusinessRecommendationImpl.fromJson;

  @override
  String get title;
  @override
  String get description;
  @override
  String get priority;
  @override // 'high', 'medium', 'low'
  String get impact;
  @override
  List<String> get actionItems;
  @override
  double get estimatedROI;
  @override
  Map<String, dynamic>? get implementation;
  @override
  @JsonKey(ignore: true)
  _$$BusinessRecommendationImplCopyWith<_$BusinessRecommendationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CompetitiveAnalysis _$CompetitiveAnalysisFromJson(Map<String, dynamic> json) {
  return _CompetitiveAnalysis.fromJson(json);
}

/// @nodoc
mixin _$CompetitiveAnalysis {
  Map<String, CompetitorData> get competitors =>
      throw _privateConstructorUsedError;
  List<String> get competitiveAdvantages => throw _privateConstructorUsedError;
  List<String> get improvementAreas => throw _privateConstructorUsedError;
  double get marketPosition => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompetitiveAnalysisCopyWith<CompetitiveAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompetitiveAnalysisCopyWith<$Res> {
  factory $CompetitiveAnalysisCopyWith(
          CompetitiveAnalysis value, $Res Function(CompetitiveAnalysis) then) =
      _$CompetitiveAnalysisCopyWithImpl<$Res, CompetitiveAnalysis>;
  @useResult
  $Res call(
      {Map<String, CompetitorData> competitors,
      List<String> competitiveAdvantages,
      List<String> improvementAreas,
      double marketPosition});
}

/// @nodoc
class _$CompetitiveAnalysisCopyWithImpl<$Res, $Val extends CompetitiveAnalysis>
    implements $CompetitiveAnalysisCopyWith<$Res> {
  _$CompetitiveAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? competitors = null,
    Object? competitiveAdvantages = null,
    Object? improvementAreas = null,
    Object? marketPosition = null,
  }) {
    return _then(_value.copyWith(
      competitors: null == competitors
          ? _value.competitors
          : competitors // ignore: cast_nullable_to_non_nullable
              as Map<String, CompetitorData>,
      competitiveAdvantages: null == competitiveAdvantages
          ? _value.competitiveAdvantages
          : competitiveAdvantages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      improvementAreas: null == improvementAreas
          ? _value.improvementAreas
          : improvementAreas // ignore: cast_nullable_to_non_nullable
              as List<String>,
      marketPosition: null == marketPosition
          ? _value.marketPosition
          : marketPosition // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompetitiveAnalysisImplCopyWith<$Res>
    implements $CompetitiveAnalysisCopyWith<$Res> {
  factory _$$CompetitiveAnalysisImplCopyWith(_$CompetitiveAnalysisImpl value,
          $Res Function(_$CompetitiveAnalysisImpl) then) =
      __$$CompetitiveAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, CompetitorData> competitors,
      List<String> competitiveAdvantages,
      List<String> improvementAreas,
      double marketPosition});
}

/// @nodoc
class __$$CompetitiveAnalysisImplCopyWithImpl<$Res>
    extends _$CompetitiveAnalysisCopyWithImpl<$Res, _$CompetitiveAnalysisImpl>
    implements _$$CompetitiveAnalysisImplCopyWith<$Res> {
  __$$CompetitiveAnalysisImplCopyWithImpl(_$CompetitiveAnalysisImpl _value,
      $Res Function(_$CompetitiveAnalysisImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? competitors = null,
    Object? competitiveAdvantages = null,
    Object? improvementAreas = null,
    Object? marketPosition = null,
  }) {
    return _then(_$CompetitiveAnalysisImpl(
      competitors: null == competitors
          ? _value._competitors
          : competitors // ignore: cast_nullable_to_non_nullable
              as Map<String, CompetitorData>,
      competitiveAdvantages: null == competitiveAdvantages
          ? _value._competitiveAdvantages
          : competitiveAdvantages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      improvementAreas: null == improvementAreas
          ? _value._improvementAreas
          : improvementAreas // ignore: cast_nullable_to_non_nullable
              as List<String>,
      marketPosition: null == marketPosition
          ? _value.marketPosition
          : marketPosition // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompetitiveAnalysisImpl implements _CompetitiveAnalysis {
  const _$CompetitiveAnalysisImpl(
      {required final Map<String, CompetitorData> competitors,
      required final List<String> competitiveAdvantages,
      required final List<String> improvementAreas,
      required this.marketPosition})
      : _competitors = competitors,
        _competitiveAdvantages = competitiveAdvantages,
        _improvementAreas = improvementAreas;

  factory _$CompetitiveAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompetitiveAnalysisImplFromJson(json);

  final Map<String, CompetitorData> _competitors;
  @override
  Map<String, CompetitorData> get competitors {
    if (_competitors is EqualUnmodifiableMapView) return _competitors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_competitors);
  }

  final List<String> _competitiveAdvantages;
  @override
  List<String> get competitiveAdvantages {
    if (_competitiveAdvantages is EqualUnmodifiableListView)
      return _competitiveAdvantages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_competitiveAdvantages);
  }

  final List<String> _improvementAreas;
  @override
  List<String> get improvementAreas {
    if (_improvementAreas is EqualUnmodifiableListView)
      return _improvementAreas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_improvementAreas);
  }

  @override
  final double marketPosition;

  @override
  String toString() {
    return 'CompetitiveAnalysis(competitors: $competitors, competitiveAdvantages: $competitiveAdvantages, improvementAreas: $improvementAreas, marketPosition: $marketPosition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompetitiveAnalysisImpl &&
            const DeepCollectionEquality()
                .equals(other._competitors, _competitors) &&
            const DeepCollectionEquality()
                .equals(other._competitiveAdvantages, _competitiveAdvantages) &&
            const DeepCollectionEquality()
                .equals(other._improvementAreas, _improvementAreas) &&
            (identical(other.marketPosition, marketPosition) ||
                other.marketPosition == marketPosition));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_competitors),
      const DeepCollectionEquality().hash(_competitiveAdvantages),
      const DeepCollectionEquality().hash(_improvementAreas),
      marketPosition);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompetitiveAnalysisImplCopyWith<_$CompetitiveAnalysisImpl> get copyWith =>
      __$$CompetitiveAnalysisImplCopyWithImpl<_$CompetitiveAnalysisImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompetitiveAnalysisImplToJson(
      this,
    );
  }
}

abstract class _CompetitiveAnalysis implements CompetitiveAnalysis {
  const factory _CompetitiveAnalysis(
      {required final Map<String, CompetitorData> competitors,
      required final List<String> competitiveAdvantages,
      required final List<String> improvementAreas,
      required final double marketPosition}) = _$CompetitiveAnalysisImpl;

  factory _CompetitiveAnalysis.fromJson(Map<String, dynamic> json) =
      _$CompetitiveAnalysisImpl.fromJson;

  @override
  Map<String, CompetitorData> get competitors;
  @override
  List<String> get competitiveAdvantages;
  @override
  List<String> get improvementAreas;
  @override
  double get marketPosition;
  @override
  @JsonKey(ignore: true)
  _$$CompetitiveAnalysisImplCopyWith<_$CompetitiveAnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CompetitorData _$CompetitorDataFromJson(Map<String, dynamic> json) {
  return _CompetitorData.fromJson(json);
}

/// @nodoc
mixin _$CompetitorData {
  String get name => throw _privateConstructorUsedError;
  double get marketShare => throw _privateConstructorUsedError;
  List<String> get strengths => throw _privateConstructorUsedError;
  List<String> get weaknesses => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metrics => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompetitorDataCopyWith<CompetitorData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompetitorDataCopyWith<$Res> {
  factory $CompetitorDataCopyWith(
          CompetitorData value, $Res Function(CompetitorData) then) =
      _$CompetitorDataCopyWithImpl<$Res, CompetitorData>;
  @useResult
  $Res call(
      {String name,
      double marketShare,
      List<String> strengths,
      List<String> weaknesses,
      Map<String, dynamic>? metrics});
}

/// @nodoc
class _$CompetitorDataCopyWithImpl<$Res, $Val extends CompetitorData>
    implements $CompetitorDataCopyWith<$Res> {
  _$CompetitorDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? marketShare = null,
    Object? strengths = null,
    Object? weaknesses = null,
    Object? metrics = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      marketShare: null == marketShare
          ? _value.marketShare
          : marketShare // ignore: cast_nullable_to_non_nullable
              as double,
      strengths: null == strengths
          ? _value.strengths
          : strengths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      weaknesses: null == weaknesses
          ? _value.weaknesses
          : weaknesses // ignore: cast_nullable_to_non_nullable
              as List<String>,
      metrics: freezed == metrics
          ? _value.metrics
          : metrics // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompetitorDataImplCopyWith<$Res>
    implements $CompetitorDataCopyWith<$Res> {
  factory _$$CompetitorDataImplCopyWith(_$CompetitorDataImpl value,
          $Res Function(_$CompetitorDataImpl) then) =
      __$$CompetitorDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      double marketShare,
      List<String> strengths,
      List<String> weaknesses,
      Map<String, dynamic>? metrics});
}

/// @nodoc
class __$$CompetitorDataImplCopyWithImpl<$Res>
    extends _$CompetitorDataCopyWithImpl<$Res, _$CompetitorDataImpl>
    implements _$$CompetitorDataImplCopyWith<$Res> {
  __$$CompetitorDataImplCopyWithImpl(
      _$CompetitorDataImpl _value, $Res Function(_$CompetitorDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? marketShare = null,
    Object? strengths = null,
    Object? weaknesses = null,
    Object? metrics = freezed,
  }) {
    return _then(_$CompetitorDataImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      marketShare: null == marketShare
          ? _value.marketShare
          : marketShare // ignore: cast_nullable_to_non_nullable
              as double,
      strengths: null == strengths
          ? _value._strengths
          : strengths // ignore: cast_nullable_to_non_nullable
              as List<String>,
      weaknesses: null == weaknesses
          ? _value._weaknesses
          : weaknesses // ignore: cast_nullable_to_non_nullable
              as List<String>,
      metrics: freezed == metrics
          ? _value._metrics
          : metrics // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompetitorDataImpl implements _CompetitorData {
  const _$CompetitorDataImpl(
      {required this.name,
      required this.marketShare,
      required final List<String> strengths,
      required final List<String> weaknesses,
      final Map<String, dynamic>? metrics})
      : _strengths = strengths,
        _weaknesses = weaknesses,
        _metrics = metrics;

  factory _$CompetitorDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompetitorDataImplFromJson(json);

  @override
  final String name;
  @override
  final double marketShare;
  final List<String> _strengths;
  @override
  List<String> get strengths {
    if (_strengths is EqualUnmodifiableListView) return _strengths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_strengths);
  }

  final List<String> _weaknesses;
  @override
  List<String> get weaknesses {
    if (_weaknesses is EqualUnmodifiableListView) return _weaknesses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weaknesses);
  }

  final Map<String, dynamic>? _metrics;
  @override
  Map<String, dynamic>? get metrics {
    final value = _metrics;
    if (value == null) return null;
    if (_metrics is EqualUnmodifiableMapView) return _metrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'CompetitorData(name: $name, marketShare: $marketShare, strengths: $strengths, weaknesses: $weaknesses, metrics: $metrics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompetitorDataImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.marketShare, marketShare) ||
                other.marketShare == marketShare) &&
            const DeepCollectionEquality()
                .equals(other._strengths, _strengths) &&
            const DeepCollectionEquality()
                .equals(other._weaknesses, _weaknesses) &&
            const DeepCollectionEquality().equals(other._metrics, _metrics));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      marketShare,
      const DeepCollectionEquality().hash(_strengths),
      const DeepCollectionEquality().hash(_weaknesses),
      const DeepCollectionEquality().hash(_metrics));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompetitorDataImplCopyWith<_$CompetitorDataImpl> get copyWith =>
      __$$CompetitorDataImplCopyWithImpl<_$CompetitorDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompetitorDataImplToJson(
      this,
    );
  }
}

abstract class _CompetitorData implements CompetitorData {
  const factory _CompetitorData(
      {required final String name,
      required final double marketShare,
      required final List<String> strengths,
      required final List<String> weaknesses,
      final Map<String, dynamic>? metrics}) = _$CompetitorDataImpl;

  factory _CompetitorData.fromJson(Map<String, dynamic> json) =
      _$CompetitorDataImpl.fromJson;

  @override
  String get name;
  @override
  double get marketShare;
  @override
  List<String> get strengths;
  @override
  List<String> get weaknesses;
  @override
  Map<String, dynamic>? get metrics;
  @override
  @JsonKey(ignore: true)
  _$$CompetitorDataImplCopyWith<_$CompetitorDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RealTimeMetrics _$RealTimeMetricsFromJson(Map<String, dynamic> json) {
  return _RealTimeMetrics.fromJson(json);
}

/// @nodoc
mixin _$RealTimeMetrics {
  int get activeUsersNow => throw _privateConstructorUsedError;
  int get transactionsToday => throw _privateConstructorUsedError;
  double get revenueToday => throw _privateConstructorUsedError;
  double get systemHealth => throw _privateConstructorUsedError;
  int get responseTime => throw _privateConstructorUsedError;
  double get errorRate => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  Map<String, dynamic>? get additionalMetrics =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RealTimeMetricsCopyWith<RealTimeMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RealTimeMetricsCopyWith<$Res> {
  factory $RealTimeMetricsCopyWith(
          RealTimeMetrics value, $Res Function(RealTimeMetrics) then) =
      _$RealTimeMetricsCopyWithImpl<$Res, RealTimeMetrics>;
  @useResult
  $Res call(
      {int activeUsersNow,
      int transactionsToday,
      double revenueToday,
      double systemHealth,
      int responseTime,
      double errorRate,
      DateTime lastUpdated,
      Map<String, dynamic>? additionalMetrics});
}

/// @nodoc
class _$RealTimeMetricsCopyWithImpl<$Res, $Val extends RealTimeMetrics>
    implements $RealTimeMetricsCopyWith<$Res> {
  _$RealTimeMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeUsersNow = null,
    Object? transactionsToday = null,
    Object? revenueToday = null,
    Object? systemHealth = null,
    Object? responseTime = null,
    Object? errorRate = null,
    Object? lastUpdated = null,
    Object? additionalMetrics = freezed,
  }) {
    return _then(_value.copyWith(
      activeUsersNow: null == activeUsersNow
          ? _value.activeUsersNow
          : activeUsersNow // ignore: cast_nullable_to_non_nullable
              as int,
      transactionsToday: null == transactionsToday
          ? _value.transactionsToday
          : transactionsToday // ignore: cast_nullable_to_non_nullable
              as int,
      revenueToday: null == revenueToday
          ? _value.revenueToday
          : revenueToday // ignore: cast_nullable_to_non_nullable
              as double,
      systemHealth: null == systemHealth
          ? _value.systemHealth
          : systemHealth // ignore: cast_nullable_to_non_nullable
              as double,
      responseTime: null == responseTime
          ? _value.responseTime
          : responseTime // ignore: cast_nullable_to_non_nullable
              as int,
      errorRate: null == errorRate
          ? _value.errorRate
          : errorRate // ignore: cast_nullable_to_non_nullable
              as double,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      additionalMetrics: freezed == additionalMetrics
          ? _value.additionalMetrics
          : additionalMetrics // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RealTimeMetricsImplCopyWith<$Res>
    implements $RealTimeMetricsCopyWith<$Res> {
  factory _$$RealTimeMetricsImplCopyWith(_$RealTimeMetricsImpl value,
          $Res Function(_$RealTimeMetricsImpl) then) =
      __$$RealTimeMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int activeUsersNow,
      int transactionsToday,
      double revenueToday,
      double systemHealth,
      int responseTime,
      double errorRate,
      DateTime lastUpdated,
      Map<String, dynamic>? additionalMetrics});
}

/// @nodoc
class __$$RealTimeMetricsImplCopyWithImpl<$Res>
    extends _$RealTimeMetricsCopyWithImpl<$Res, _$RealTimeMetricsImpl>
    implements _$$RealTimeMetricsImplCopyWith<$Res> {
  __$$RealTimeMetricsImplCopyWithImpl(
      _$RealTimeMetricsImpl _value, $Res Function(_$RealTimeMetricsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeUsersNow = null,
    Object? transactionsToday = null,
    Object? revenueToday = null,
    Object? systemHealth = null,
    Object? responseTime = null,
    Object? errorRate = null,
    Object? lastUpdated = null,
    Object? additionalMetrics = freezed,
  }) {
    return _then(_$RealTimeMetricsImpl(
      activeUsersNow: null == activeUsersNow
          ? _value.activeUsersNow
          : activeUsersNow // ignore: cast_nullable_to_non_nullable
              as int,
      transactionsToday: null == transactionsToday
          ? _value.transactionsToday
          : transactionsToday // ignore: cast_nullable_to_non_nullable
              as int,
      revenueToday: null == revenueToday
          ? _value.revenueToday
          : revenueToday // ignore: cast_nullable_to_non_nullable
              as double,
      systemHealth: null == systemHealth
          ? _value.systemHealth
          : systemHealth // ignore: cast_nullable_to_non_nullable
              as double,
      responseTime: null == responseTime
          ? _value.responseTime
          : responseTime // ignore: cast_nullable_to_non_nullable
              as int,
      errorRate: null == errorRate
          ? _value.errorRate
          : errorRate // ignore: cast_nullable_to_non_nullable
              as double,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      additionalMetrics: freezed == additionalMetrics
          ? _value._additionalMetrics
          : additionalMetrics // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RealTimeMetricsImpl implements _RealTimeMetrics {
  const _$RealTimeMetricsImpl(
      {required this.activeUsersNow,
      required this.transactionsToday,
      required this.revenueToday,
      required this.systemHealth,
      required this.responseTime,
      required this.errorRate,
      required this.lastUpdated,
      final Map<String, dynamic>? additionalMetrics})
      : _additionalMetrics = additionalMetrics;

  factory _$RealTimeMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$RealTimeMetricsImplFromJson(json);

  @override
  final int activeUsersNow;
  @override
  final int transactionsToday;
  @override
  final double revenueToday;
  @override
  final double systemHealth;
  @override
  final int responseTime;
  @override
  final double errorRate;
  @override
  final DateTime lastUpdated;
  final Map<String, dynamic>? _additionalMetrics;
  @override
  Map<String, dynamic>? get additionalMetrics {
    final value = _additionalMetrics;
    if (value == null) return null;
    if (_additionalMetrics is EqualUnmodifiableMapView)
      return _additionalMetrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'RealTimeMetrics(activeUsersNow: $activeUsersNow, transactionsToday: $transactionsToday, revenueToday: $revenueToday, systemHealth: $systemHealth, responseTime: $responseTime, errorRate: $errorRate, lastUpdated: $lastUpdated, additionalMetrics: $additionalMetrics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RealTimeMetricsImpl &&
            (identical(other.activeUsersNow, activeUsersNow) ||
                other.activeUsersNow == activeUsersNow) &&
            (identical(other.transactionsToday, transactionsToday) ||
                other.transactionsToday == transactionsToday) &&
            (identical(other.revenueToday, revenueToday) ||
                other.revenueToday == revenueToday) &&
            (identical(other.systemHealth, systemHealth) ||
                other.systemHealth == systemHealth) &&
            (identical(other.responseTime, responseTime) ||
                other.responseTime == responseTime) &&
            (identical(other.errorRate, errorRate) ||
                other.errorRate == errorRate) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            const DeepCollectionEquality()
                .equals(other._additionalMetrics, _additionalMetrics));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      activeUsersNow,
      transactionsToday,
      revenueToday,
      systemHealth,
      responseTime,
      errorRate,
      lastUpdated,
      const DeepCollectionEquality().hash(_additionalMetrics));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RealTimeMetricsImplCopyWith<_$RealTimeMetricsImpl> get copyWith =>
      __$$RealTimeMetricsImplCopyWithImpl<_$RealTimeMetricsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RealTimeMetricsImplToJson(
      this,
    );
  }
}

abstract class _RealTimeMetrics implements RealTimeMetrics {
  const factory _RealTimeMetrics(
      {required final int activeUsersNow,
      required final int transactionsToday,
      required final double revenueToday,
      required final double systemHealth,
      required final int responseTime,
      required final double errorRate,
      required final DateTime lastUpdated,
      final Map<String, dynamic>? additionalMetrics}) = _$RealTimeMetricsImpl;

  factory _RealTimeMetrics.fromJson(Map<String, dynamic> json) =
      _$RealTimeMetricsImpl.fromJson;

  @override
  int get activeUsersNow;
  @override
  int get transactionsToday;
  @override
  double get revenueToday;
  @override
  double get systemHealth;
  @override
  int get responseTime;
  @override
  double get errorRate;
  @override
  DateTime get lastUpdated;
  @override
  Map<String, dynamic>? get additionalMetrics;
  @override
  @JsonKey(ignore: true)
  _$$RealTimeMetricsImplCopyWith<_$RealTimeMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CustomDashboardData _$CustomDashboardDataFromJson(Map<String, dynamic> json) {
  return _CustomDashboardData.fromJson(json);
}

/// @nodoc
mixin _$CustomDashboardData {
  String get dashboardId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  List<DashboardWidget> get widgets => throw _privateConstructorUsedError;
  Map<String, dynamic> get filters => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  Map<String, dynamic>? get configuration => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CustomDashboardDataCopyWith<CustomDashboardData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomDashboardDataCopyWith<$Res> {
  factory $CustomDashboardDataCopyWith(
          CustomDashboardData value, $Res Function(CustomDashboardData) then) =
      _$CustomDashboardDataCopyWithImpl<$Res, CustomDashboardData>;
  @useResult
  $Res call(
      {String dashboardId,
      String title,
      List<DashboardWidget> widgets,
      Map<String, dynamic> filters,
      DateTime lastUpdated,
      Map<String, dynamic>? configuration});
}

/// @nodoc
class _$CustomDashboardDataCopyWithImpl<$Res, $Val extends CustomDashboardData>
    implements $CustomDashboardDataCopyWith<$Res> {
  _$CustomDashboardDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dashboardId = null,
    Object? title = null,
    Object? widgets = null,
    Object? filters = null,
    Object? lastUpdated = null,
    Object? configuration = freezed,
  }) {
    return _then(_value.copyWith(
      dashboardId: null == dashboardId
          ? _value.dashboardId
          : dashboardId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      widgets: null == widgets
          ? _value.widgets
          : widgets // ignore: cast_nullable_to_non_nullable
              as List<DashboardWidget>,
      filters: null == filters
          ? _value.filters
          : filters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      configuration: freezed == configuration
          ? _value.configuration
          : configuration // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CustomDashboardDataImplCopyWith<$Res>
    implements $CustomDashboardDataCopyWith<$Res> {
  factory _$$CustomDashboardDataImplCopyWith(_$CustomDashboardDataImpl value,
          $Res Function(_$CustomDashboardDataImpl) then) =
      __$$CustomDashboardDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String dashboardId,
      String title,
      List<DashboardWidget> widgets,
      Map<String, dynamic> filters,
      DateTime lastUpdated,
      Map<String, dynamic>? configuration});
}

/// @nodoc
class __$$CustomDashboardDataImplCopyWithImpl<$Res>
    extends _$CustomDashboardDataCopyWithImpl<$Res, _$CustomDashboardDataImpl>
    implements _$$CustomDashboardDataImplCopyWith<$Res> {
  __$$CustomDashboardDataImplCopyWithImpl(_$CustomDashboardDataImpl _value,
      $Res Function(_$CustomDashboardDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dashboardId = null,
    Object? title = null,
    Object? widgets = null,
    Object? filters = null,
    Object? lastUpdated = null,
    Object? configuration = freezed,
  }) {
    return _then(_$CustomDashboardDataImpl(
      dashboardId: null == dashboardId
          ? _value.dashboardId
          : dashboardId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      widgets: null == widgets
          ? _value._widgets
          : widgets // ignore: cast_nullable_to_non_nullable
              as List<DashboardWidget>,
      filters: null == filters
          ? _value._filters
          : filters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      configuration: freezed == configuration
          ? _value._configuration
          : configuration // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomDashboardDataImpl implements _CustomDashboardData {
  const _$CustomDashboardDataImpl(
      {required this.dashboardId,
      required this.title,
      required final List<DashboardWidget> widgets,
      required final Map<String, dynamic> filters,
      required this.lastUpdated,
      final Map<String, dynamic>? configuration})
      : _widgets = widgets,
        _filters = filters,
        _configuration = configuration;

  factory _$CustomDashboardDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomDashboardDataImplFromJson(json);

  @override
  final String dashboardId;
  @override
  final String title;
  final List<DashboardWidget> _widgets;
  @override
  List<DashboardWidget> get widgets {
    if (_widgets is EqualUnmodifiableListView) return _widgets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_widgets);
  }

  final Map<String, dynamic> _filters;
  @override
  Map<String, dynamic> get filters {
    if (_filters is EqualUnmodifiableMapView) return _filters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_filters);
  }

  @override
  final DateTime lastUpdated;
  final Map<String, dynamic>? _configuration;
  @override
  Map<String, dynamic>? get configuration {
    final value = _configuration;
    if (value == null) return null;
    if (_configuration is EqualUnmodifiableMapView) return _configuration;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'CustomDashboardData(dashboardId: $dashboardId, title: $title, widgets: $widgets, filters: $filters, lastUpdated: $lastUpdated, configuration: $configuration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomDashboardDataImpl &&
            (identical(other.dashboardId, dashboardId) ||
                other.dashboardId == dashboardId) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._widgets, _widgets) &&
            const DeepCollectionEquality().equals(other._filters, _filters) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            const DeepCollectionEquality()
                .equals(other._configuration, _configuration));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      dashboardId,
      title,
      const DeepCollectionEquality().hash(_widgets),
      const DeepCollectionEquality().hash(_filters),
      lastUpdated,
      const DeepCollectionEquality().hash(_configuration));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomDashboardDataImplCopyWith<_$CustomDashboardDataImpl> get copyWith =>
      __$$CustomDashboardDataImplCopyWithImpl<_$CustomDashboardDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomDashboardDataImplToJson(
      this,
    );
  }
}

abstract class _CustomDashboardData implements CustomDashboardData {
  const factory _CustomDashboardData(
      {required final String dashboardId,
      required final String title,
      required final List<DashboardWidget> widgets,
      required final Map<String, dynamic> filters,
      required final DateTime lastUpdated,
      final Map<String, dynamic>? configuration}) = _$CustomDashboardDataImpl;

  factory _CustomDashboardData.fromJson(Map<String, dynamic> json) =
      _$CustomDashboardDataImpl.fromJson;

  @override
  String get dashboardId;
  @override
  String get title;
  @override
  List<DashboardWidget> get widgets;
  @override
  Map<String, dynamic> get filters;
  @override
  DateTime get lastUpdated;
  @override
  Map<String, dynamic>? get configuration;
  @override
  @JsonKey(ignore: true)
  _$$CustomDashboardDataImplCopyWith<_$CustomDashboardDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DashboardWidget _$DashboardWidgetFromJson(Map<String, dynamic> json) {
  return _DashboardWidget.fromJson(json);
}

/// @nodoc
mixin _$DashboardWidget {
  String get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  Map<String, dynamic> get data => throw _privateConstructorUsedError;
  Map<String, dynamic> get configuration => throw _privateConstructorUsedError;
  int? get position => throw _privateConstructorUsedError;
  Map<String, dynamic>? get styling => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DashboardWidgetCopyWith<DashboardWidget> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardWidgetCopyWith<$Res> {
  factory $DashboardWidgetCopyWith(
          DashboardWidget value, $Res Function(DashboardWidget) then) =
      _$DashboardWidgetCopyWithImpl<$Res, DashboardWidget>;
  @useResult
  $Res call(
      {String id,
      String type,
      String title,
      Map<String, dynamic> data,
      Map<String, dynamic> configuration,
      int? position,
      Map<String, dynamic>? styling});
}

/// @nodoc
class _$DashboardWidgetCopyWithImpl<$Res, $Val extends DashboardWidget>
    implements $DashboardWidgetCopyWith<$Res> {
  _$DashboardWidgetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? data = null,
    Object? configuration = null,
    Object? position = freezed,
    Object? styling = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      configuration: null == configuration
          ? _value.configuration
          : configuration // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int?,
      styling: freezed == styling
          ? _value.styling
          : styling // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DashboardWidgetImplCopyWith<$Res>
    implements $DashboardWidgetCopyWith<$Res> {
  factory _$$DashboardWidgetImplCopyWith(_$DashboardWidgetImpl value,
          $Res Function(_$DashboardWidgetImpl) then) =
      __$$DashboardWidgetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      String title,
      Map<String, dynamic> data,
      Map<String, dynamic> configuration,
      int? position,
      Map<String, dynamic>? styling});
}

/// @nodoc
class __$$DashboardWidgetImplCopyWithImpl<$Res>
    extends _$DashboardWidgetCopyWithImpl<$Res, _$DashboardWidgetImpl>
    implements _$$DashboardWidgetImplCopyWith<$Res> {
  __$$DashboardWidgetImplCopyWithImpl(
      _$DashboardWidgetImpl _value, $Res Function(_$DashboardWidgetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? data = null,
    Object? configuration = null,
    Object? position = freezed,
    Object? styling = freezed,
  }) {
    return _then(_$DashboardWidgetImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      configuration: null == configuration
          ? _value._configuration
          : configuration // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int?,
      styling: freezed == styling
          ? _value._styling
          : styling // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardWidgetImpl implements _DashboardWidget {
  const _$DashboardWidgetImpl(
      {required this.id,
      required this.type,
      required this.title,
      required final Map<String, dynamic> data,
      required final Map<String, dynamic> configuration,
      this.position,
      final Map<String, dynamic>? styling})
      : _data = data,
        _configuration = configuration,
        _styling = styling;

  factory _$DashboardWidgetImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardWidgetImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
  @override
  final String title;
  final Map<String, dynamic> _data;
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  final Map<String, dynamic> _configuration;
  @override
  Map<String, dynamic> get configuration {
    if (_configuration is EqualUnmodifiableMapView) return _configuration;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_configuration);
  }

  @override
  final int? position;
  final Map<String, dynamic>? _styling;
  @override
  Map<String, dynamic>? get styling {
    final value = _styling;
    if (value == null) return null;
    if (_styling is EqualUnmodifiableMapView) return _styling;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'DashboardWidget(id: $id, type: $type, title: $title, data: $data, configuration: $configuration, position: $position, styling: $styling)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardWidgetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            const DeepCollectionEquality()
                .equals(other._configuration, _configuration) &&
            (identical(other.position, position) ||
                other.position == position) &&
            const DeepCollectionEquality().equals(other._styling, _styling));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      title,
      const DeepCollectionEquality().hash(_data),
      const DeepCollectionEquality().hash(_configuration),
      position,
      const DeepCollectionEquality().hash(_styling));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardWidgetImplCopyWith<_$DashboardWidgetImpl> get copyWith =>
      __$$DashboardWidgetImplCopyWithImpl<_$DashboardWidgetImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardWidgetImplToJson(
      this,
    );
  }
}

abstract class _DashboardWidget implements DashboardWidget {
  const factory _DashboardWidget(
      {required final String id,
      required final String type,
      required final String title,
      required final Map<String, dynamic> data,
      required final Map<String, dynamic> configuration,
      final int? position,
      final Map<String, dynamic>? styling}) = _$DashboardWidgetImpl;

  factory _DashboardWidget.fromJson(Map<String, dynamic> json) =
      _$DashboardWidgetImpl.fromJson;

  @override
  String get id;
  @override
  String get type;
  @override
  String get title;
  @override
  Map<String, dynamic> get data;
  @override
  Map<String, dynamic> get configuration;
  @override
  int? get position;
  @override
  Map<String, dynamic>? get styling;
  @override
  @JsonKey(ignore: true)
  _$$DashboardWidgetImplCopyWith<_$DashboardWidgetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
