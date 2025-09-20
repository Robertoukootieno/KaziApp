import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

/// Monitoring service for system health and performance
class MonitoringService {
  final Dio _dio;

  MonitoringService(this._dio);

  /// Get system health information
  Future<Map<String, dynamic>> getSystemHealth() async {
    try {
      final response = await _dio.get('/admin/monitoring/system-health');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch system health: $e');
    }
  }

  /// Get performance metrics
  Future<Map<String, dynamic>> getPerformanceMetrics({
    DateTime? startTime,
    DateTime? endTime,
    String? granularity,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startTime != null) queryParams['start_time'] = startTime.toIso8601String();
      if (endTime != null) queryParams['end_time'] = endTime.toIso8601String();
      if (granularity != null) queryParams['granularity'] = granularity;

      final response = await _dio.get(
        '/admin/monitoring/performance-metrics',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch performance metrics: $e');
    }
  }

  /// Get system alerts
  Future<Map<String, dynamic>> getAlerts({
    String? severity,
    String? status,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (severity != null) queryParams['severity'] = severity;
      if (status != null) queryParams['status'] = status;
      if (limit != null) queryParams['limit'] = limit;

      final response = await _dio.get(
        '/admin/monitoring/alerts',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch alerts: $e');
    }
  }

  /// Create a new alert
  Future<Map<String, dynamic>> createAlert({
    required String title,
    required String description,
    required String severity,
    required String source,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _dio.post('/admin/monitoring/alerts', data: {
        'title': title,
        'description': description,
        'severity': severity,
        'source': source,
        if (metadata != null) 'metadata': metadata,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to create alert: $e');
    }
  }

  /// Resolve an alert
  Future<void> resolveAlert(String alertId) async {
    try {
      await _dio.patch('/admin/monitoring/alerts/$alertId/resolve');
    } catch (e) {
      throw Exception('Failed to resolve alert: $e');
    }
  }

  /// Assign an alert to a user
  Future<void> assignAlert(String alertId, String assigneeId) async {
    try {
      await _dio.patch('/admin/monitoring/alerts/$alertId/assign', data: {
        'assignee_id': assigneeId,
      });
    } catch (e) {
      throw Exception('Failed to assign alert: $e');
    }
  }

  /// Get service status
  Future<Map<String, dynamic>> getServiceStatus() async {
    try {
      final response = await _dio.get('/admin/monitoring/service-status');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch service status: $e');
    }
  }

  /// Get real-time analytics
  Future<Map<String, dynamic>> getRealTimeAnalytics({
    String? timeRange,
    List<String>? metrics,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (timeRange != null) queryParams['time_range'] = timeRange;
      if (metrics != null) queryParams['metrics'] = metrics.join(',');

      final response = await _dio.get(
        '/admin/monitoring/real-time-analytics',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch real-time analytics: $e');
    }
  }

  /// Get resource usage metrics
  Future<Map<String, dynamic>> getResourceUsage({
    String? timeRange,
    List<String>? resources,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (timeRange != null) queryParams['time_range'] = timeRange;
      if (resources != null) queryParams['resources'] = resources.join(',');

      final response = await _dio.get(
        '/admin/monitoring/resource-usage',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch resource usage: $e');
    }
  }

  /// Get database performance metrics
  Future<Map<String, dynamic>> getDatabaseMetrics() async {
    try {
      final response = await _dio.get('/admin/monitoring/database-metrics');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch database metrics: $e');
    }
  }

  /// Get API endpoint performance
  Future<Map<String, dynamic>> getApiPerformance({
    String? timeRange,
    String? endpoint,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (timeRange != null) queryParams['time_range'] = timeRange;
      if (endpoint != null) queryParams['endpoint'] = endpoint;

      final response = await _dio.get(
        '/admin/monitoring/api-performance',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch API performance: $e');
    }
  }

  /// Get error logs
  Future<Map<String, dynamic>> getErrorLogs({
    String? severity,
    String? service,
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (severity != null) queryParams['severity'] = severity;
      if (service != null) queryParams['service'] = service;
      if (startTime != null) queryParams['start_time'] = startTime.toIso8601String();
      if (endTime != null) queryParams['end_time'] = endTime.toIso8601String();
      if (limit != null) queryParams['limit'] = limit;

      final response = await _dio.get(
        '/admin/monitoring/error-logs',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch error logs: $e');
    }
  }

  /// Get user activity metrics
  Future<Map<String, dynamic>> getUserActivityMetrics({
    String? timeRange,
    String? userType,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (timeRange != null) queryParams['time_range'] = timeRange;
      if (userType != null) queryParams['user_type'] = userType;

      final response = await _dio.get(
        '/admin/monitoring/user-activity',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch user activity metrics: $e');
    }
  }

  /// Get transaction metrics
  Future<Map<String, dynamic>> getTransactionMetrics({
    String? timeRange,
    String? transactionType,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (timeRange != null) queryParams['time_range'] = timeRange;
      if (transactionType != null) queryParams['transaction_type'] = transactionType;

      final response = await _dio.get(
        '/admin/monitoring/transaction-metrics',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch transaction metrics: $e');
    }
  }

  /// Generate monitoring report
  Future<String> generateReport({
    required String reportType,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? metrics,
    String? format,
  }) async {
    try {
      final response = await _dio.post('/admin/monitoring/generate-report', data: {
        'report_type': reportType,
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
        if (metrics != null) 'metrics': metrics,
        if (format != null) 'format': format,
      });
      return response.data['data']['download_url'] as String;
    } catch (e) {
      throw Exception('Failed to generate report: $e');
    }
  }

  /// Set up monitoring alert rules
  Future<void> createAlertRule({
    required String name,
    required String metric,
    required String condition,
    required double threshold,
    required String severity,
    List<String>? notificationChannels,
  }) async {
    try {
      await _dio.post('/admin/monitoring/alert-rules', data: {
        'name': name,
        'metric': metric,
        'condition': condition,
        'threshold': threshold,
        'severity': severity,
        if (notificationChannels != null) 'notification_channels': notificationChannels,
      });
    } catch (e) {
      throw Exception('Failed to create alert rule: $e');
    }
  }

  /// Get alert rules
  Future<List<Map<String, dynamic>>> getAlertRules() async {
    try {
      final response = await _dio.get('/admin/monitoring/alert-rules');
      return List<Map<String, dynamic>>.from(response.data['data']['rules']);
    } catch (e) {
      throw Exception('Failed to fetch alert rules: $e');
    }
  }

  /// Update alert rule
  Future<void> updateAlertRule(String ruleId, Map<String, dynamic> updates) async {
    try {
      await _dio.patch('/admin/monitoring/alert-rules/$ruleId', data: updates);
    } catch (e) {
      throw Exception('Failed to update alert rule: $e');
    }
  }

  /// Delete alert rule
  Future<void> deleteAlertRule(String ruleId) async {
    try {
      await _dio.delete('/admin/monitoring/alert-rules/$ruleId');
    } catch (e) {
      throw Exception('Failed to delete alert rule: $e');
    }
  }

  /// Get monitoring dashboard configuration
  Future<Map<String, dynamic>> getDashboardConfig() async {
    try {
      final response = await _dio.get('/admin/monitoring/dashboard-config');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch dashboard config: $e');
    }
  }

  /// Update monitoring dashboard configuration
  Future<void> updateDashboardConfig(Map<String, dynamic> config) async {
    try {
      await _dio.put('/admin/monitoring/dashboard-config', data: config);
    } catch (e) {
      throw Exception('Failed to update dashboard config: $e');
    }
  }

  /// Test service connectivity
  Future<Map<String, dynamic>> testServiceConnectivity(String serviceName) async {
    try {
      final response = await _dio.post('/admin/monitoring/test-connectivity', data: {
        'service_name': serviceName,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to test service connectivity: $e');
    }
  }

  /// Get system logs
  Future<Map<String, dynamic>> getSystemLogs({
    String? level,
    String? service,
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (level != null) queryParams['level'] = level;
      if (service != null) queryParams['service'] = service;
      if (startTime != null) queryParams['start_time'] = startTime.toIso8601String();
      if (endTime != null) queryParams['end_time'] = endTime.toIso8601String();
      if (limit != null) queryParams['limit'] = limit;
      if (search != null) queryParams['search'] = search;

      final response = await _dio.get(
        '/admin/monitoring/system-logs',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch system logs: $e');
    }
  }
}

/// Monitoring service provider
final monitoringServiceProvider = Provider<MonitoringService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return MonitoringService(apiService.dio);
});
