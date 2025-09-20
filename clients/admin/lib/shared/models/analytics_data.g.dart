// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnalyticsDataImpl _$$AnalyticsDataImplFromJson(Map<String, dynamic> json) =>
    _$AnalyticsDataImpl(
      totalUsers: (json['totalUsers'] as num).toInt(),
      activeUsers: (json['activeUsers'] as num).toInt(),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      monthlyRevenue: (json['monthlyRevenue'] as num).toDouble(),
      engagementRate: (json['engagementRate'] as num).toDouble(),
      conversionRate: (json['conversionRate'] as num).toDouble(),
      userGrowthHistory: (json['userGrowthHistory'] as List<dynamic>)
          .map((e) => TimeSeriesData.fromJson(e as Map<String, dynamic>))
          .toList(),
      revenueHistory: (json['revenueHistory'] as List<dynamic>)
          .map((e) => TimeSeriesData.fromJson(e as Map<String, dynamic>))
          .toList(),
      engagementMetrics: json['engagementMetrics'] as Map<String, dynamic>,
      conversionFunnel: Map<String, int>.from(json['conversionFunnel'] as Map),
      topMetrics: json['topMetrics'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$AnalyticsDataImplToJson(_$AnalyticsDataImpl instance) =>
    <String, dynamic>{
      'totalUsers': instance.totalUsers,
      'activeUsers': instance.activeUsers,
      'totalRevenue': instance.totalRevenue,
      'monthlyRevenue': instance.monthlyRevenue,
      'engagementRate': instance.engagementRate,
      'conversionRate': instance.conversionRate,
      'userGrowthHistory': instance.userGrowthHistory,
      'revenueHistory': instance.revenueHistory,
      'engagementMetrics': instance.engagementMetrics,
      'conversionFunnel': instance.conversionFunnel,
      'topMetrics': instance.topMetrics,
    };

_$TimeSeriesDataImpl _$$TimeSeriesDataImplFromJson(Map<String, dynamic> json) =>
    _$TimeSeriesDataImpl(
      date: DateTime.parse(json['date'] as String),
      value: (json['value'] as num).toDouble(),
      label: json['label'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$TimeSeriesDataImplToJson(
        _$TimeSeriesDataImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'value': instance.value,
      'label': instance.label,
      'metadata': instance.metadata,
    };

_$UserBehaviorDataImpl _$$UserBehaviorDataImplFromJson(
        Map<String, dynamic> json) =>
    _$UserBehaviorDataImpl(
      userSegments: (json['userSegments'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, UserSegment.fromJson(e as Map<String, dynamic>)),
      ),
      userJourney: (json['userJourney'] as List<dynamic>)
          .map((e) => UserJourneyStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      featureUsage: (json['featureUsage'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      churnAnalysis:
          ChurnAnalysis.fromJson(json['churnAnalysis'] as Map<String, dynamic>),
      behaviorPatterns: (json['behaviorPatterns'] as List<dynamic>)
          .map((e) => BehaviorPattern.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$UserBehaviorDataImplToJson(
        _$UserBehaviorDataImpl instance) =>
    <String, dynamic>{
      'userSegments': instance.userSegments,
      'userJourney': instance.userJourney,
      'featureUsage': instance.featureUsage,
      'churnAnalysis': instance.churnAnalysis,
      'behaviorPatterns': instance.behaviorPatterns,
    };

_$UserSegmentImpl _$$UserSegmentImplFromJson(Map<String, dynamic> json) =>
    _$UserSegmentImpl(
      count: (json['count'] as num).toInt(),
      engagement: (json['engagement'] as num).toDouble(),
      retention: (json['retention'] as num).toDouble(),
      averageRevenue: (json['averageRevenue'] as num).toDouble(),
      characteristics: json['characteristics'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$UserSegmentImplToJson(_$UserSegmentImpl instance) =>
    <String, dynamic>{
      'count': instance.count,
      'engagement': instance.engagement,
      'retention': instance.retention,
      'averageRevenue': instance.averageRevenue,
      'characteristics': instance.characteristics,
    };

_$UserJourneyStepImpl _$$UserJourneyStepImplFromJson(
        Map<String, dynamic> json) =>
    _$UserJourneyStepImpl(
      step: json['step'] as String,
      completionRate: (json['completionRate'] as num).toDouble(),
      averageTime: (json['averageTime'] as num).toDouble(),
      dropOffReasons: (json['dropOffReasons'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$UserJourneyStepImplToJson(
        _$UserJourneyStepImpl instance) =>
    <String, dynamic>{
      'step': instance.step,
      'completionRate': instance.completionRate,
      'averageTime': instance.averageTime,
      'dropOffReasons': instance.dropOffReasons,
    };

_$ChurnAnalysisImpl _$$ChurnAnalysisImplFromJson(Map<String, dynamic> json) =>
    _$ChurnAnalysisImpl(
      churnRate: (json['churnRate'] as num).toDouble(),
      atRiskUsers: (json['atRiskUsers'] as num).toInt(),
      churnReasons: (json['churnReasons'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      predictions: (json['predictions'] as List<dynamic>)
          .map((e) => ChurnPrediction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ChurnAnalysisImplToJson(_$ChurnAnalysisImpl instance) =>
    <String, dynamic>{
      'churnRate': instance.churnRate,
      'atRiskUsers': instance.atRiskUsers,
      'churnReasons': instance.churnReasons,
      'predictions': instance.predictions,
    };

_$ChurnPredictionImpl _$$ChurnPredictionImplFromJson(
        Map<String, dynamic> json) =>
    _$ChurnPredictionImpl(
      userId: json['userId'] as String,
      churnProbability: (json['churnProbability'] as num).toDouble(),
      riskFactors: (json['riskFactors'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      predictedChurnDate: DateTime.parse(json['predictedChurnDate'] as String),
    );

Map<String, dynamic> _$$ChurnPredictionImplToJson(
        _$ChurnPredictionImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'churnProbability': instance.churnProbability,
      'riskFactors': instance.riskFactors,
      'predictedChurnDate': instance.predictedChurnDate.toIso8601String(),
    };

_$BehaviorPatternImpl _$$BehaviorPatternImplFromJson(
        Map<String, dynamic> json) =>
    _$BehaviorPatternImpl(
      patternId: json['patternId'] as String,
      description: json['description'] as String,
      frequency: (json['frequency'] as num).toDouble(),
      userSegments: (json['userSegments'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      characteristics: json['characteristics'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$BehaviorPatternImplToJson(
        _$BehaviorPatternImpl instance) =>
    <String, dynamic>{
      'patternId': instance.patternId,
      'description': instance.description,
      'frequency': instance.frequency,
      'userSegments': instance.userSegments,
      'characteristics': instance.characteristics,
    };

_$BusinessIntelligenceDataImpl _$$BusinessIntelligenceDataImplFromJson(
        Map<String, dynamic> json) =>
    _$BusinessIntelligenceDataImpl(
      keyMetrics: (json['keyMetrics'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, MetricValue.fromJson(e as Map<String, dynamic>)),
      ),
      trends: (json['trends'] as List<dynamic>)
          .map((e) => TrendData.fromJson(e as Map<String, dynamic>))
          .toList(),
      predictions: (json['predictions'] as List<dynamic>)
          .map((e) => PredictiveInsight.fromJson(e as Map<String, dynamic>))
          .toList(),
      recommendations: (json['recommendations'] as List<dynamic>)
          .map(
              (e) => BusinessRecommendation.fromJson(e as Map<String, dynamic>))
          .toList(),
      competitiveAnalysis: CompetitiveAnalysis.fromJson(
          json['competitiveAnalysis'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$BusinessIntelligenceDataImplToJson(
        _$BusinessIntelligenceDataImpl instance) =>
    <String, dynamic>{
      'keyMetrics': instance.keyMetrics,
      'trends': instance.trends,
      'predictions': instance.predictions,
      'recommendations': instance.recommendations,
      'competitiveAnalysis': instance.competitiveAnalysis,
    };

_$MetricValueImpl _$$MetricValueImplFromJson(Map<String, dynamic> json) =>
    _$MetricValueImpl(
      current: (json['current'] as num).toDouble(),
      previous: (json['previous'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
      changeType: json['changeType'] as String,
      unit: json['unit'] as String?,
      format: json['format'] as String?,
    );

Map<String, dynamic> _$$MetricValueImplToJson(_$MetricValueImpl instance) =>
    <String, dynamic>{
      'current': instance.current,
      'previous': instance.previous,
      'change': instance.change,
      'changeType': instance.changeType,
      'unit': instance.unit,
      'format': instance.format,
    };

_$TrendDataImpl _$$TrendDataImplFromJson(Map<String, dynamic> json) =>
    _$TrendDataImpl(
      metric: json['metric'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => TimeSeriesData.fromJson(e as Map<String, dynamic>))
          .toList(),
      trendDirection: json['trendDirection'] as String,
      trendStrength: (json['trendStrength'] as num).toDouble(),
      influencingFactors: (json['influencingFactors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$TrendDataImplToJson(_$TrendDataImpl instance) =>
    <String, dynamic>{
      'metric': instance.metric,
      'data': instance.data,
      'trendDirection': instance.trendDirection,
      'trendStrength': instance.trendStrength,
      'influencingFactors': instance.influencingFactors,
    };

_$PredictiveInsightImpl _$$PredictiveInsightImplFromJson(
        Map<String, dynamic> json) =>
    _$PredictiveInsightImpl(
      title: json['title'] as String,
      description: json['description'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      type: json['type'] as String,
      predictedDate: DateTime.parse(json['predictedDate'] as String),
      supportingData: json['supportingData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PredictiveInsightImplToJson(
        _$PredictiveInsightImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'confidence': instance.confidence,
      'type': instance.type,
      'predictedDate': instance.predictedDate.toIso8601String(),
      'supportingData': instance.supportingData,
    };

_$BusinessRecommendationImpl _$$BusinessRecommendationImplFromJson(
        Map<String, dynamic> json) =>
    _$BusinessRecommendationImpl(
      title: json['title'] as String,
      description: json['description'] as String,
      priority: json['priority'] as String,
      impact: json['impact'] as String,
      actionItems: (json['actionItems'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      estimatedROI: (json['estimatedROI'] as num).toDouble(),
      implementation: json['implementation'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$BusinessRecommendationImplToJson(
        _$BusinessRecommendationImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'priority': instance.priority,
      'impact': instance.impact,
      'actionItems': instance.actionItems,
      'estimatedROI': instance.estimatedROI,
      'implementation': instance.implementation,
    };

_$CompetitiveAnalysisImpl _$$CompetitiveAnalysisImplFromJson(
        Map<String, dynamic> json) =>
    _$CompetitiveAnalysisImpl(
      competitors: (json['competitors'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, CompetitorData.fromJson(e as Map<String, dynamic>)),
      ),
      competitiveAdvantages: (json['competitiveAdvantages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      improvementAreas: (json['improvementAreas'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      marketPosition: (json['marketPosition'] as num).toDouble(),
    );

Map<String, dynamic> _$$CompetitiveAnalysisImplToJson(
        _$CompetitiveAnalysisImpl instance) =>
    <String, dynamic>{
      'competitors': instance.competitors,
      'competitiveAdvantages': instance.competitiveAdvantages,
      'improvementAreas': instance.improvementAreas,
      'marketPosition': instance.marketPosition,
    };

_$CompetitorDataImpl _$$CompetitorDataImplFromJson(Map<String, dynamic> json) =>
    _$CompetitorDataImpl(
      name: json['name'] as String,
      marketShare: (json['marketShare'] as num).toDouble(),
      strengths:
          (json['strengths'] as List<dynamic>).map((e) => e as String).toList(),
      weaknesses: (json['weaknesses'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      metrics: json['metrics'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$CompetitorDataImplToJson(
        _$CompetitorDataImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'marketShare': instance.marketShare,
      'strengths': instance.strengths,
      'weaknesses': instance.weaknesses,
      'metrics': instance.metrics,
    };

_$RealTimeMetricsImpl _$$RealTimeMetricsImplFromJson(
        Map<String, dynamic> json) =>
    _$RealTimeMetricsImpl(
      activeUsersNow: (json['activeUsersNow'] as num).toInt(),
      transactionsToday: (json['transactionsToday'] as num).toInt(),
      revenueToday: (json['revenueToday'] as num).toDouble(),
      systemHealth: (json['systemHealth'] as num).toDouble(),
      responseTime: (json['responseTime'] as num).toInt(),
      errorRate: (json['errorRate'] as num).toDouble(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      additionalMetrics: json['additionalMetrics'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$RealTimeMetricsImplToJson(
        _$RealTimeMetricsImpl instance) =>
    <String, dynamic>{
      'activeUsersNow': instance.activeUsersNow,
      'transactionsToday': instance.transactionsToday,
      'revenueToday': instance.revenueToday,
      'systemHealth': instance.systemHealth,
      'responseTime': instance.responseTime,
      'errorRate': instance.errorRate,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'additionalMetrics': instance.additionalMetrics,
    };

_$CustomDashboardDataImpl _$$CustomDashboardDataImplFromJson(
        Map<String, dynamic> json) =>
    _$CustomDashboardDataImpl(
      dashboardId: json['dashboardId'] as String,
      title: json['title'] as String,
      widgets: (json['widgets'] as List<dynamic>)
          .map((e) => DashboardWidget.fromJson(e as Map<String, dynamic>))
          .toList(),
      filters: json['filters'] as Map<String, dynamic>,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      configuration: json['configuration'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$CustomDashboardDataImplToJson(
        _$CustomDashboardDataImpl instance) =>
    <String, dynamic>{
      'dashboardId': instance.dashboardId,
      'title': instance.title,
      'widgets': instance.widgets,
      'filters': instance.filters,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'configuration': instance.configuration,
    };

_$DashboardWidgetImpl _$$DashboardWidgetImplFromJson(
        Map<String, dynamic> json) =>
    _$DashboardWidgetImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      data: json['data'] as Map<String, dynamic>,
      configuration: json['configuration'] as Map<String, dynamic>,
      position: (json['position'] as num?)?.toInt(),
      styling: json['styling'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$DashboardWidgetImplToJson(
        _$DashboardWidgetImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'data': instance.data,
      'configuration': instance.configuration,
      'position': instance.position,
      'styling': instance.styling,
    };
