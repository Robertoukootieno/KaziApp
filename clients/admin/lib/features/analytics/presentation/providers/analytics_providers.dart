import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/services/analytics_service.dart';

/// Analytics overview model
class AnalyticsOverview {
  final int totalUsers;
  final int activeUsers;
  final double totalRevenue;
  final double monthlyRevenue;
  final double engagementRate;
  final double conversionRate;
  final List<Map<String, dynamic>> userGrowthHistory;
  final List<Map<String, dynamic>> revenueHistory;
  final Map<String, dynamic> engagementMetrics;
  final Map<String, int> conversionFunnel;
  final Map<String, dynamic> topMetrics;

  const AnalyticsOverview({
    required this.totalUsers,
    required this.activeUsers,
    required this.totalRevenue,
    required this.monthlyRevenue,
    required this.engagementRate,
    required this.conversionRate,
    required this.userGrowthHistory,
    required this.revenueHistory,
    required this.engagementMetrics,
    required this.conversionFunnel,
    required this.topMetrics,
  });

  factory AnalyticsOverview.fromJson(Map<String, dynamic> json) {
    return AnalyticsOverview(
      totalUsers: json['total_users'] as int,
      activeUsers: json['active_users'] as int,
      totalRevenue: (json['total_revenue'] as num).toDouble(),
      monthlyRevenue: (json['monthly_revenue'] as num).toDouble(),
      engagementRate: (json['engagement_rate'] as num).toDouble(),
      conversionRate: (json['conversion_rate'] as num).toDouble(),
      userGrowthHistory: List<Map<String, dynamic>>.from(json['user_growth_history'] as List),
      revenueHistory: List<Map<String, dynamic>>.from(json['revenue_history'] as List),
      engagementMetrics: json['engagement_metrics'] as Map<String, dynamic>,
      conversionFunnel: Map<String, int>.from(json['conversion_funnel'] as Map),
      topMetrics: json['top_metrics'] as Map<String, dynamic>,
    );
  }
}

/// Custom dashboard model
class CustomDashboard {
  final String id;
  final String name;
  final String description;
  final List<DashboardWidget> widgets;
  final Map<String, dynamic> layout;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final bool isPublic;

  const CustomDashboard({
    required this.id,
    required this.name,
    required this.description,
    required this.widgets,
    required this.layout,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.isPublic,
  });

  factory CustomDashboard.fromJson(Map<String, dynamic> json) {
    return CustomDashboard(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      widgets: (json['widgets'] as List)
          .map((w) => DashboardWidget.fromJson(w))
          .toList(),
      layout: json['layout'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdBy: json['created_by'] as String,
      isPublic: json['is_public'] as bool,
    );
  }
}

class DashboardWidget {
  final String id;
  final String type;
  final String title;
  final Map<String, dynamic> configuration;
  final Map<String, dynamic> position;

  const DashboardWidget({
    required this.id,
    required this.type,
    required this.title,
    required this.configuration,
    required this.position,
  });

  factory DashboardWidget.fromJson(Map<String, dynamic> json) {
    return DashboardWidget(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      configuration: json['configuration'] as Map<String, dynamic>,
      position: json['position'] as Map<String, dynamic>,
    );
  }
}

/// Predictive analytics model
class PredictiveAnalytics {
  final Map<String, dynamic> userGrowthPrediction;
  final Map<String, dynamic> revenueForecast;
  final Map<String, dynamic> churnPrediction;
  final Map<String, dynamic> seasonalTrends;
  final List<Map<String, dynamic>> recommendations;
  final Map<String, double> confidenceScores;

  const PredictiveAnalytics({
    required this.userGrowthPrediction,
    required this.revenueForecast,
    required this.churnPrediction,
    required this.seasonalTrends,
    required this.recommendations,
    required this.confidenceScores,
  });

  factory PredictiveAnalytics.fromJson(Map<String, dynamic> json) {
    return PredictiveAnalytics(
      userGrowthPrediction: json['user_growth_prediction'] as Map<String, dynamic>,
      revenueForecast: json['revenue_forecast'] as Map<String, dynamic>,
      churnPrediction: json['churn_prediction'] as Map<String, dynamic>,
      seasonalTrends: json['seasonal_trends'] as Map<String, dynamic>,
      recommendations: List<Map<String, dynamic>>.from(json['recommendations'] as List),
      confidenceScores: Map<String, double>.from(
        (json['confidence_scores'] as Map).map(
          (key, value) => MapEntry(key as String, (value as num).toDouble()),
        ),
      ),
    );
  }
}

/// User behavior analytics model
class UserBehaviorAnalytics {
  final Map<String, dynamic> userJourney;
  final Map<String, dynamic> featureUsage;
  final Map<String, dynamic> sessionAnalytics;
  final Map<String, dynamic> deviceAnalytics;
  final Map<String, dynamic> geographicData;
  final List<Map<String, dynamic>> cohortAnalysis;

  const UserBehaviorAnalytics({
    required this.userJourney,
    required this.featureUsage,
    required this.sessionAnalytics,
    required this.deviceAnalytics,
    required this.geographicData,
    required this.cohortAnalysis,
  });

  factory UserBehaviorAnalytics.fromJson(Map<String, dynamic> json) {
    return UserBehaviorAnalytics(
      userJourney: json['user_journey'] as Map<String, dynamic>,
      featureUsage: json['feature_usage'] as Map<String, dynamic>,
      sessionAnalytics: json['session_analytics'] as Map<String, dynamic>,
      deviceAnalytics: json['device_analytics'] as Map<String, dynamic>,
      geographicData: json['geographic_data'] as Map<String, dynamic>,
      cohortAnalysis: List<Map<String, dynamic>>.from(json['cohort_analysis'] as List),
    );
  }
}

/// Business intelligence model
class BusinessIntelligence {
  final Map<String, dynamic> kpiMetrics;
  final Map<String, dynamic> performanceIndicators;
  final List<Map<String, dynamic>> businessReports;
  final Map<String, dynamic> competitiveAnalysis;
  final Map<String, dynamic> marketInsights;
  final List<Map<String, dynamic>> actionableInsights;

  const BusinessIntelligence({
    required this.kpiMetrics,
    required this.performanceIndicators,
    required this.businessReports,
    required this.competitiveAnalysis,
    required this.marketInsights,
    required this.actionableInsights,
  });

  factory BusinessIntelligence.fromJson(Map<String, dynamic> json) {
    return BusinessIntelligence(
      kpiMetrics: json['kpi_metrics'] as Map<String, dynamic>,
      performanceIndicators: json['performance_indicators'] as Map<String, dynamic>,
      businessReports: List<Map<String, dynamic>>.from(json['business_reports'] as List),
      competitiveAnalysis: json['competitive_analysis'] as Map<String, dynamic>,
      marketInsights: json['market_insights'] as Map<String, dynamic>,
      actionableInsights: List<Map<String, dynamic>>.from(json['actionable_insights'] as List),
    );
  }
}

/// Analytics overview state notifier
class AnalyticsOverviewNotifier extends StateNotifier<AsyncValue<AnalyticsOverview>> {
  final AnalyticsService _service;

  AnalyticsOverviewNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadOverview({
    String? timeRange,
    List<String>? metrics,
  }) async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getAnalyticsOverview(
        timeRange: timeRange,
        metrics: metrics,
      );
      state = AsyncValue.data(AnalyticsOverview.fromJson(result));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Custom dashboards state notifier
class CustomDashboardsNotifier extends StateNotifier<AsyncValue<List<CustomDashboard>>> {
  final AnalyticsService _service;

  CustomDashboardsNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadDashboards() async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getCustomDashboards();
      final dashboards = (result['dashboards'] as List)
          .map((json) => CustomDashboard.fromJson(json))
          .toList();
      state = AsyncValue.data(dashboards);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Predictive analytics state notifier
class PredictiveAnalyticsNotifier extends StateNotifier<AsyncValue<PredictiveAnalytics>> {
  final AnalyticsService _service;

  PredictiveAnalyticsNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadPredictions() async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getPredictiveAnalytics();
      state = AsyncValue.data(PredictiveAnalytics.fromJson(result));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// User behavior analytics state notifier
class UserBehaviorAnalyticsNotifier extends StateNotifier<AsyncValue<UserBehaviorAnalytics>> {
  final AnalyticsService _service;

  UserBehaviorAnalyticsNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadBehaviorData() async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getUserBehaviorAnalytics();
      state = AsyncValue.data(UserBehaviorAnalytics.fromJson(result));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Business intelligence state notifier
class BusinessIntelligenceNotifier extends StateNotifier<AsyncValue<BusinessIntelligence>> {
  final AnalyticsService _service;

  BusinessIntelligenceNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadBIData() async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getBusinessIntelligence();
      state = AsyncValue.data(BusinessIntelligence.fromJson(result));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Providers
final analyticsOverviewProvider = StateNotifierProvider<AnalyticsOverviewNotifier, AsyncValue<AnalyticsOverview>>((ref) {
  final service = ref.watch(analyticsServiceProvider);
  return AnalyticsOverviewNotifier(service);
});

final customDashboardsProvider = StateNotifierProvider<CustomDashboardsNotifier, AsyncValue<List<CustomDashboard>>>((ref) {
  final service = ref.watch(analyticsServiceProvider);
  return CustomDashboardsNotifier(service);
});

final predictiveAnalyticsProvider = StateNotifierProvider<PredictiveAnalyticsNotifier, AsyncValue<PredictiveAnalytics>>((ref) {
  final service = ref.watch(analyticsServiceProvider);
  return PredictiveAnalyticsNotifier(service);
});

final userBehaviorAnalyticsProvider = StateNotifierProvider<UserBehaviorAnalyticsNotifier, AsyncValue<UserBehaviorAnalytics>>((ref) {
  final service = ref.watch(analyticsServiceProvider);
  return UserBehaviorAnalyticsNotifier(service);
});

final businessIntelligenceProvider = StateNotifierProvider<BusinessIntelligenceNotifier, AsyncValue<BusinessIntelligence>>((ref) {
  final service = ref.watch(analyticsServiceProvider);
  return BusinessIntelligenceNotifier(service);
});
