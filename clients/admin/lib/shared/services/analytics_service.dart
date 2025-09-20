import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

/// Analytics service for comprehensive analytics and business intelligence
class AnalyticsService {
  final Dio _dio;

  AnalyticsService(this._dio);

  /// Get analytics overview
  Future<Map<String, dynamic>> getAnalyticsOverview({
    String? timeRange,
    List<String>? metrics,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (timeRange != null) queryParams['time_range'] = timeRange;
      if (metrics != null) queryParams['metrics'] = metrics.join(',');

      final response = await _dio.get(
        '/admin/analytics/overview',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch analytics overview: $e');
    }
  }

  /// Get custom dashboards
  Future<Map<String, dynamic>> getCustomDashboards() async {
    try {
      final response = await _dio.get('/admin/analytics/dashboards');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch custom dashboards: $e');
    }
  }

  /// Create custom dashboard
  Future<Map<String, dynamic>> createCustomDashboard({
    required String name,
    required String description,
    required List<Map<String, dynamic>> widgets,
    required Map<String, dynamic> layout,
    bool isPublic = false,
  }) async {
    try {
      final response = await _dio.post('/admin/analytics/dashboards', data: {
        'name': name,
        'description': description,
        'widgets': widgets,
        'layout': layout,
        'is_public': isPublic,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to create custom dashboard: $e');
    }
  }

  /// Update custom dashboard
  Future<void> updateCustomDashboard(String dashboardId, Map<String, dynamic> updates) async {
    try {
      await _dio.patch('/admin/analytics/dashboards/$dashboardId', data: updates);
    } catch (e) {
      throw Exception('Failed to update custom dashboard: $e');
    }
  }

  /// Delete custom dashboard
  Future<void> deleteCustomDashboard(String dashboardId) async {
    try {
      await _dio.delete('/admin/analytics/dashboards/$dashboardId');
    } catch (e) {
      throw Exception('Failed to delete custom dashboard: $e');
    }
  }

  /// Get predictive analytics
  Future<Map<String, dynamic>> getPredictiveAnalytics({
    String? timeRange,
    List<String>? models,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (timeRange != null) queryParams['time_range'] = timeRange;
      if (models != null) queryParams['models'] = models.join(',');

      final response = await _dio.get(
        '/admin/analytics/predictive',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch predictive analytics: $e');
    }
  }

  /// Get user behavior analytics
  Future<Map<String, dynamic>> getUserBehaviorAnalytics({
    String? timeRange,
    String? segment,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (timeRange != null) queryParams['time_range'] = timeRange;
      if (segment != null) queryParams['segment'] = segment;

      final response = await _dio.get(
        '/admin/analytics/user-behavior',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch user behavior analytics: $e');
    }
  }

  /// Get business intelligence
  Future<Map<String, dynamic>> getBusinessIntelligence({
    String? timeRange,
    List<String>? reports,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (timeRange != null) queryParams['time_range'] = timeRange;
      if (reports != null) queryParams['reports'] = reports.join(',');

      final response = await _dio.get(
        '/admin/analytics/business-intelligence',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch business intelligence: $e');
    }
  }

  /// Get real-time metrics
  Future<Map<String, dynamic>> getRealTimeMetrics({
    List<String>? metrics,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (metrics != null) queryParams['metrics'] = metrics.join(',');

      final response = await _dio.get(
        '/admin/analytics/real-time',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch real-time metrics: $e');
    }
  }

  /// Get cohort analysis
  Future<Map<String, dynamic>> getCohortAnalysis({
    String? timeRange,
    String? cohortType,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (timeRange != null) queryParams['time_range'] = timeRange;
      if (cohortType != null) queryParams['cohort_type'] = cohortType;

      final response = await _dio.get(
        '/admin/analytics/cohort',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch cohort analysis: $e');
    }
  }

  /// Get funnel analysis
  Future<Map<String, dynamic>> getFunnelAnalysis({
    String? funnelId,
    String? timeRange,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (funnelId != null) queryParams['funnel_id'] = funnelId;
      if (timeRange != null) queryParams['time_range'] = timeRange;

      final response = await _dio.get(
        '/admin/analytics/funnel',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch funnel analysis: $e');
    }
  }

  /// Get retention analysis
  Future<Map<String, dynamic>> getRetentionAnalysis({
    String? timeRange,
    String? segment,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (timeRange != null) queryParams['time_range'] = timeRange;
      if (segment != null) queryParams['segment'] = segment;

      final response = await _dio.get(
        '/admin/analytics/retention',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch retention analysis: $e');
    }
  }

  /// Get A/B test results
  Future<Map<String, dynamic>> getABTestResults({
    String? testId,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (testId != null) queryParams['test_id'] = testId;
      if (status != null) queryParams['status'] = status;

      final response = await _dio.get(
        '/admin/analytics/ab-tests',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch A/B test results: $e');
    }
  }

  /// Create A/B test
  Future<Map<String, dynamic>> createABTest({
    required String name,
    required String description,
    required Map<String, dynamic> configuration,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _dio.post('/admin/analytics/ab-tests', data: {
        'name': name,
        'description': description,
        'configuration': configuration,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to create A/B test: $e');
    }
  }

  /// Get custom reports
  Future<Map<String, dynamic>> getCustomReports({
    String? category,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (category != null) queryParams['category'] = category;
      if (status != null) queryParams['status'] = status;

      final response = await _dio.get(
        '/admin/analytics/reports',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch custom reports: $e');
    }
  }

  /// Generate custom report
  Future<Map<String, dynamic>> generateCustomReport({
    required String name,
    required String type,
    required Map<String, dynamic> parameters,
    String? format,
  }) async {
    try {
      final response = await _dio.post('/admin/analytics/reports/generate', data: {
        'name': name,
        'type': type,
        'parameters': parameters,
        if (format != null) 'format': format,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to generate custom report: $e');
    }
  }

  /// Export analytics data
  Future<String> exportAnalyticsData({
    required String dataType,
    DateTime? startDate,
    DateTime? endDate,
    Map<String, dynamic>? filters,
    String? format,
  }) async {
    try {
      final response = await _dio.post('/admin/analytics/export', data: {
        'data_type': dataType,
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
        if (filters != null) 'filters': filters,
        if (format != null) 'format': format,
      });
      return response.data['data']['download_url'] as String;
    } catch (e) {
      throw Exception('Failed to export analytics data: $e');
    }
  }

  /// Get data sources
  Future<Map<String, dynamic>> getDataSources() async {
    try {
      final response = await _dio.get('/admin/analytics/data-sources');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch data sources: $e');
    }
  }

  /// Create data source
  Future<Map<String, dynamic>> createDataSource({
    required String name,
    required String type,
    required Map<String, dynamic> configuration,
  }) async {
    try {
      final response = await _dio.post('/admin/analytics/data-sources', data: {
        'name': name,
        'type': type,
        'configuration': configuration,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to create data source: $e');
    }
  }

  /// Test data source connection
  Future<Map<String, dynamic>> testDataSource(String dataSourceId) async {
    try {
      final response = await _dio.post('/admin/analytics/data-sources/$dataSourceId/test');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to test data source: $e');
    }
  }

  /// Get analytics alerts
  Future<Map<String, dynamic>> getAnalyticsAlerts({
    String? severity,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (severity != null) queryParams['severity'] = severity;
      if (status != null) queryParams['status'] = status;

      final response = await _dio.get(
        '/admin/analytics/alerts',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch analytics alerts: $e');
    }
  }

  /// Create analytics alert
  Future<Map<String, dynamic>> createAnalyticsAlert({
    required String name,
    required String metric,
    required String condition,
    required double threshold,
    required List<String> recipients,
  }) async {
    try {
      final response = await _dio.post('/admin/analytics/alerts', data: {
        'name': name,
        'metric': metric,
        'condition': condition,
        'threshold': threshold,
        'recipients': recipients,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to create analytics alert: $e');
    }
  }

  /// Get analytics configuration
  Future<Map<String, dynamic>> getAnalyticsConfiguration() async {
    try {
      final response = await _dio.get('/admin/analytics/configuration');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch analytics configuration: $e');
    }
  }

  /// Update analytics configuration
  Future<void> updateAnalyticsConfiguration(Map<String, dynamic> config) async {
    try {
      await _dio.put('/admin/analytics/configuration', data: config);
    } catch (e) {
      throw Exception('Failed to update analytics configuration: $e');
    }
  }
}

/// Analytics service provider
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AnalyticsService(apiService.dio);
});
