import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_data.freezed.dart';
part 'analytics_data.g.dart';

@freezed
class AnalyticsData with _$AnalyticsData {
  const factory AnalyticsData({
    required int totalUsers,
    required int activeUsers,
    required double totalRevenue,
    required double monthlyRevenue,
    required double engagementRate,
    required double conversionRate,
    required List<TimeSeriesData> userGrowthHistory,
    required List<TimeSeriesData> revenueHistory,
    required Map<String, dynamic> engagementMetrics,
    required Map<String, int> conversionFunnel,
    required Map<String, dynamic> topMetrics,
  }) = _AnalyticsData;

  factory AnalyticsData.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsDataFromJson(json);
}

@freezed
class TimeSeriesData with _$TimeSeriesData {
  const factory TimeSeriesData({
    required DateTime date,
    required double value,
    String? label,
    Map<String, dynamic>? metadata,
  }) = _TimeSeriesData;

  factory TimeSeriesData.fromJson(Map<String, dynamic> json) =>
      _$TimeSeriesDataFromJson(json);
}

@freezed
class UserBehaviorData with _$UserBehaviorData {
  const factory UserBehaviorData({
    required Map<String, UserSegment> userSegments,
    required List<UserJourneyStep> userJourney,
    required Map<String, double> featureUsage,
    required ChurnAnalysis churnAnalysis,
    required List<BehaviorPattern> behaviorPatterns,
  }) = _UserBehaviorData;

  factory UserBehaviorData.fromJson(Map<String, dynamic> json) =>
      _$UserBehaviorDataFromJson(json);
}

@freezed
class UserSegment with _$UserSegment {
  const factory UserSegment({
    required int count,
    required double engagement,
    required double retention,
    required double averageRevenue,
    Map<String, dynamic>? characteristics,
  }) = _UserSegment;

  factory UserSegment.fromJson(Map<String, dynamic> json) =>
      _$UserSegmentFromJson(json);
}

@freezed
class UserJourneyStep with _$UserJourneyStep {
  const factory UserJourneyStep({
    required String step,
    required double completionRate,
    required double averageTime,
    List<String>? dropOffReasons,
  }) = _UserJourneyStep;

  factory UserJourneyStep.fromJson(Map<String, dynamic> json) =>
      _$UserJourneyStepFromJson(json);
}

@freezed
class ChurnAnalysis with _$ChurnAnalysis {
  const factory ChurnAnalysis({
    required double churnRate,
    required int atRiskUsers,
    required Map<String, double> churnReasons,
    required List<ChurnPrediction> predictions,
  }) = _ChurnAnalysis;

  factory ChurnAnalysis.fromJson(Map<String, dynamic> json) =>
      _$ChurnAnalysisFromJson(json);
}

@freezed
class ChurnPrediction with _$ChurnPrediction {
  const factory ChurnPrediction({
    required String userId,
    required double churnProbability,
    required List<String> riskFactors,
    required DateTime predictedChurnDate,
  }) = _ChurnPrediction;

  factory ChurnPrediction.fromJson(Map<String, dynamic> json) =>
      _$ChurnPredictionFromJson(json);
}

@freezed
class BehaviorPattern with _$BehaviorPattern {
  const factory BehaviorPattern({
    required String patternId,
    required String description,
    required double frequency,
    required List<String> userSegments,
    required Map<String, dynamic> characteristics,
  }) = _BehaviorPattern;

  factory BehaviorPattern.fromJson(Map<String, dynamic> json) =>
      _$BehaviorPatternFromJson(json);
}

@freezed
class BusinessIntelligenceData with _$BusinessIntelligenceData {
  const factory BusinessIntelligenceData({
    required Map<String, MetricValue> keyMetrics,
    required List<TrendData> trends,
    required List<PredictiveInsight> predictions,
    required List<BusinessRecommendation> recommendations,
    required CompetitiveAnalysis competitiveAnalysis,
  }) = _BusinessIntelligenceData;

  factory BusinessIntelligenceData.fromJson(Map<String, dynamic> json) =>
      _$BusinessIntelligenceDataFromJson(json);
}

@freezed
class MetricValue with _$MetricValue {
  const factory MetricValue({
    required double current,
    required double previous,
    required double change,
    required String changeType, // 'increase', 'decrease', 'stable'
    String? unit,
    String? format,
  }) = _MetricValue;

  factory MetricValue.fromJson(Map<String, dynamic> json) =>
      _$MetricValueFromJson(json);
}

@freezed
class TrendData with _$TrendData {
  const factory TrendData({
    required String metric,
    required List<TimeSeriesData> data,
    required String trendDirection, // 'up', 'down', 'stable'
    required double trendStrength,
    List<String>? influencingFactors,
  }) = _TrendData;

  factory TrendData.fromJson(Map<String, dynamic> json) =>
      _$TrendDataFromJson(json);
}

@freezed
class PredictiveInsight with _$PredictiveInsight {
  const factory PredictiveInsight({
    required String title,
    required String description,
    required double confidence,
    required String type, // 'positive', 'negative', 'warning', 'neutral'
    required DateTime predictedDate,
    Map<String, dynamic>? supportingData,
  }) = _PredictiveInsight;

  factory PredictiveInsight.fromJson(Map<String, dynamic> json) =>
      _$PredictiveInsightFromJson(json);
}

@freezed
class BusinessRecommendation with _$BusinessRecommendation {
  const factory BusinessRecommendation({
    required String title,
    required String description,
    required String priority, // 'high', 'medium', 'low'
    required String impact,
    required List<String> actionItems,
    required double estimatedROI,
    Map<String, dynamic>? implementation,
  }) = _BusinessRecommendation;

  factory BusinessRecommendation.fromJson(Map<String, dynamic> json) =>
      _$BusinessRecommendationFromJson(json);
}

@freezed
class CompetitiveAnalysis with _$CompetitiveAnalysis {
  const factory CompetitiveAnalysis({
    required Map<String, CompetitorData> competitors,
    required List<String> competitiveAdvantages,
    required List<String> improvementAreas,
    required double marketPosition,
  }) = _CompetitiveAnalysis;

  factory CompetitiveAnalysis.fromJson(Map<String, dynamic> json) =>
      _$CompetitiveAnalysisFromJson(json);
}

@freezed
class CompetitorData with _$CompetitorData {
  const factory CompetitorData({
    required String name,
    required double marketShare,
    required List<String> strengths,
    required List<String> weaknesses,
    Map<String, dynamic>? metrics,
  }) = _CompetitorData;

  factory CompetitorData.fromJson(Map<String, dynamic> json) =>
      _$CompetitorDataFromJson(json);
}

@freezed
class RealTimeMetrics with _$RealTimeMetrics {
  const factory RealTimeMetrics({
    required int activeUsersNow,
    required int transactionsToday,
    required double revenueToday,
    required double systemHealth,
    required int responseTime,
    required double errorRate,
    required DateTime lastUpdated,
    Map<String, dynamic>? additionalMetrics,
  }) = _RealTimeMetrics;

  factory RealTimeMetrics.fromJson(Map<String, dynamic> json) =>
      _$RealTimeMetricsFromJson(json);
}

@freezed
class CustomDashboardData with _$CustomDashboardData {
  const factory CustomDashboardData({
    required String dashboardId,
    required String title,
    required List<DashboardWidget> widgets,
    required Map<String, dynamic> filters,
    required DateTime lastUpdated,
    Map<String, dynamic>? configuration,
  }) = _CustomDashboardData;

  factory CustomDashboardData.fromJson(Map<String, dynamic> json) =>
      _$CustomDashboardDataFromJson(json);
}

@freezed
class DashboardWidget with _$DashboardWidget {
  const factory DashboardWidget({
    required String id,
    required String type,
    required String title,
    required Map<String, dynamic> data,
    required Map<String, dynamic> configuration,
    int? position,
    Map<String, dynamic>? styling,
  }) = _DashboardWidget;

  factory DashboardWidget.fromJson(Map<String, dynamic> json) =>
      _$DashboardWidgetFromJson(json);
}

// Enums for better type safety
enum AnalyticsTimeRange {
  @JsonValue('1d')
  oneDay,
  @JsonValue('7d')
  sevenDays,
  @JsonValue('30d')
  thirtyDays,
  @JsonValue('90d')
  ninetyDays,
  @JsonValue('1y')
  oneYear,
  @JsonValue('custom')
  custom,
}

enum MetricType {
  @JsonValue('revenue')
  revenue,
  @JsonValue('users')
  users,
  @JsonValue('engagement')
  engagement,
  @JsonValue('conversion')
  conversion,
  @JsonValue('retention')
  retention,
  @JsonValue('churn')
  churn,
}

enum ChartType {
  @JsonValue('line')
  line,
  @JsonValue('bar')
  bar,
  @JsonValue('pie')
  pie,
  @JsonValue('area')
  area,
  @JsonValue('scatter')
  scatter,
  @JsonValue('heatmap')
  heatmap,
}

enum ExportFormat {
  @JsonValue('csv')
  csv,
  @JsonValue('excel')
  excel,
  @JsonValue('pdf')
  pdf,
  @JsonValue('json')
  json,
}
