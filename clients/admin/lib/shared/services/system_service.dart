import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

/// System service for configuration and settings management
class SystemService {
  final Dio _dio;

  SystemService(this._dio);

  /// Get feature flags
  Future<Map<String, dynamic>> getFeatureFlags() async {
    try {
      final response = await _dio.get('/admin/system/feature-flags');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch feature flags: $e');
    }
  }

  /// Create feature flag
  Future<Map<String, dynamic>> createFeatureFlag(Map<String, dynamic> flagData) async {
    try {
      final response = await _dio.post('/admin/system/feature-flags', data: flagData);
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to create feature flag: $e');
    }
  }

  /// Update feature flag
  Future<void> updateFeatureFlag(String flagId, Map<String, dynamic> updates) async {
    try {
      await _dio.patch('/admin/system/feature-flags/$flagId', data: updates);
    } catch (e) {
      throw Exception('Failed to update feature flag: $e');
    }
  }

  /// Delete feature flag
  Future<void> deleteFeatureFlag(String flagId) async {
    try {
      await _dio.delete('/admin/system/feature-flags/$flagId');
    } catch (e) {
      throw Exception('Failed to delete feature flag: $e');
    }
  }

  /// Get environment settings
  Future<Map<String, dynamic>> getEnvironmentSettings() async {
    try {
      final response = await _dio.get('/admin/system/environment');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch environment settings: $e');
    }
  }

  /// Update environment settings
  Future<void> updateEnvironmentSettings(Map<String, dynamic> settings) async {
    try {
      await _dio.put('/admin/system/environment', data: settings);
    } catch (e) {
      throw Exception('Failed to update environment settings: $e');
    }
  }

  /// Get API configuration
  Future<Map<String, dynamic>> getApiConfiguration() async {
    try {
      final response = await _dio.get('/admin/system/api-config');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch API configuration: $e');
    }
  }

  /// Update API configuration
  Future<void> updateApiConfiguration(Map<String, dynamic> config) async {
    try {
      await _dio.put('/admin/system/api-config', data: config);
    } catch (e) {
      throw Exception('Failed to update API configuration: $e');
    }
  }

  /// Test API endpoint
  Future<Map<String, dynamic>> testApiEndpoint(String endpointId) async {
    try {
      final response = await _dio.post('/admin/system/api-config/test', data: {
        'endpoint_id': endpointId,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to test API endpoint: $e');
    }
  }

  /// Get third-party integrations
  Future<Map<String, dynamic>> getThirdPartyIntegrations() async {
    try {
      final response = await _dio.get('/admin/system/integrations');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch third-party integrations: $e');
    }
  }

  /// Create third-party integration
  Future<Map<String, dynamic>> createThirdPartyIntegration(Map<String, dynamic> integrationData) async {
    try {
      final response = await _dio.post('/admin/system/integrations', data: integrationData);
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to create third-party integration: $e');
    }
  }

  /// Update third-party integration
  Future<void> updateThirdPartyIntegration(String integrationId, Map<String, dynamic> updates) async {
    try {
      await _dio.patch('/admin/system/integrations/$integrationId', data: updates);
    } catch (e) {
      throw Exception('Failed to update third-party integration: $e');
    }
  }

  /// Test third-party integration
  Future<Map<String, dynamic>> testThirdPartyIntegration(String integrationId) async {
    try {
      final response = await _dio.post('/admin/system/integrations/$integrationId/test');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to test third-party integration: $e');
    }
  }

  /// Delete third-party integration
  Future<void> deleteThirdPartyIntegration(String integrationId) async {
    try {
      await _dio.delete('/admin/system/integrations/$integrationId');
    } catch (e) {
      throw Exception('Failed to delete third-party integration: $e');
    }
  }

  /// Get deployment status
  Future<Map<String, dynamic>> getDeploymentStatus() async {
    try {
      final response = await _dio.get('/admin/system/deployment');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch deployment status: $e');
    }
  }

  /// Deploy application
  Future<Map<String, dynamic>> deployApplication({
    required String version,
    required String environment,
    String? notes,
  }) async {
    try {
      final response = await _dio.post('/admin/system/deployment/deploy', data: {
        'version': version,
        'environment': environment,
        if (notes != null) 'notes': notes,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to deploy application: $e');
    }
  }

  /// Rollback deployment
  Future<Map<String, dynamic>> rollbackDeployment({
    required String version,
    String? reason,
  }) async {
    try {
      final response = await _dio.post('/admin/system/deployment/rollback', data: {
        'version': version,
        if (reason != null) 'reason': reason,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to rollback deployment: $e');
    }
  }

  /// Get backup status
  Future<Map<String, dynamic>> getBackupStatus() async {
    try {
      final response = await _dio.get('/admin/system/backup');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch backup status: $e');
    }
  }

  /// Create backup
  Future<Map<String, dynamic>> createBackup(String type) async {
    try {
      final response = await _dio.post('/admin/system/backup/create', data: {
        'type': type,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to create backup: $e');
    }
  }

  /// Restore from backup
  Future<Map<String, dynamic>> restoreFromBackup(String backupId) async {
    try {
      final response = await _dio.post('/admin/system/backup/restore', data: {
        'backup_id': backupId,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to restore from backup: $e');
    }
  }

  /// Delete backup
  Future<void> deleteBackup(String backupId) async {
    try {
      await _dio.delete('/admin/system/backup/$backupId');
    } catch (e) {
      throw Exception('Failed to delete backup: $e');
    }
  }

  /// Get system health
  Future<Map<String, dynamic>> getSystemHealth() async {
    try {
      final response = await _dio.get('/admin/system/health');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch system health: $e');
    }
  }

  /// Get system logs
  Future<Map<String, dynamic>> getSystemLogs({
    String? level,
    String? service,
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (level != null) queryParams['level'] = level;
      if (service != null) queryParams['service'] = service;
      if (startTime != null) queryParams['start_time'] = startTime.toIso8601String();
      if (endTime != null) queryParams['end_time'] = endTime.toIso8601String();
      if (limit != null) queryParams['limit'] = limit;

      final response = await _dio.get(
        '/admin/system/logs',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch system logs: $e');
    }
  }

  /// Get configuration history
  Future<List<Map<String, dynamic>>> getConfigurationHistory({
    String? configType,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (configType != null) queryParams['config_type'] = configType;
      if (limit != null) queryParams['limit'] = limit;

      final response = await _dio.get(
        '/admin/system/config-history',
        queryParameters: queryParams,
      );
      return List<Map<String, dynamic>>.from(response.data['data']['history']);
    } catch (e) {
      throw Exception('Failed to fetch configuration history: $e');
    }
  }

  /// Export system configuration
  Future<String> exportSystemConfiguration({
    List<String>? configTypes,
    String? format,
  }) async {
    try {
      final response = await _dio.post('/admin/system/export-config', data: {
        if (configTypes != null) 'config_types': configTypes,
        if (format != null) 'format': format,
      });
      return response.data['data']['download_url'] as String;
    } catch (e) {
      throw Exception('Failed to export system configuration: $e');
    }
  }

  /// Import system configuration
  Future<Map<String, dynamic>> importSystemConfiguration({
    required String configData,
    bool dryRun = false,
  }) async {
    try {
      final response = await _dio.post('/admin/system/import-config', data: {
        'config_data': configData,
        'dry_run': dryRun,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to import system configuration: $e');
    }
  }

  /// Get maintenance mode status
  Future<Map<String, dynamic>> getMaintenanceMode() async {
    try {
      final response = await _dio.get('/admin/system/maintenance');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch maintenance mode status: $e');
    }
  }

  /// Enable maintenance mode
  Future<void> enableMaintenanceMode({
    String? message,
    DateTime? scheduledEnd,
  }) async {
    try {
      await _dio.post('/admin/system/maintenance/enable', data: {
        if (message != null) 'message': message,
        if (scheduledEnd != null) 'scheduled_end': scheduledEnd.toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to enable maintenance mode: $e');
    }
  }

  /// Disable maintenance mode
  Future<void> disableMaintenanceMode() async {
    try {
      await _dio.post('/admin/system/maintenance/disable');
    } catch (e) {
      throw Exception('Failed to disable maintenance mode: $e');
    }
  }

  /// Get system metrics
  Future<Map<String, dynamic>> getSystemMetrics({
    String? timeRange,
    List<String>? metrics,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (timeRange != null) queryParams['time_range'] = timeRange;
      if (metrics != null) queryParams['metrics'] = metrics.join(',');

      final response = await _dio.get(
        '/admin/system/metrics',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch system metrics: $e');
    }
  }

  /// Clear system cache
  Future<Map<String, dynamic>> clearSystemCache({
    List<String>? cacheTypes,
  }) async {
    try {
      final response = await _dio.post('/admin/system/clear-cache', data: {
        if (cacheTypes != null) 'cache_types': cacheTypes,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to clear system cache: $e');
    }
  }

  /// Restart system services
  Future<Map<String, dynamic>> restartSystemServices({
    List<String>? services,
  }) async {
    try {
      final response = await _dio.post('/admin/system/restart-services', data: {
        if (services != null) 'services': services,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to restart system services: $e');
    }
  }

  /// Get database status
  Future<Map<String, dynamic>> getDatabaseStatus() async {
    try {
      final response = await _dio.get('/admin/system/database/status');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch database status: $e');
    }
  }

  /// Optimize database
  Future<Map<String, dynamic>> optimizeDatabase() async {
    try {
      final response = await _dio.post('/admin/system/database/optimize');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to optimize database: $e');
    }
  }

  /// Get security settings
  Future<Map<String, dynamic>> getSecuritySettings() async {
    try {
      final response = await _dio.get('/admin/system/security');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch security settings: $e');
    }
  }

  /// Update security settings
  Future<void> updateSecuritySettings(Map<String, dynamic> settings) async {
    try {
      await _dio.put('/admin/system/security', data: settings);
    } catch (e) {
      throw Exception('Failed to update security settings: $e');
    }
  }

  /// Generate system report
  Future<String> generateSystemReport({
    required String reportType,
    DateTime? startDate,
    DateTime? endDate,
    String? format,
  }) async {
    try {
      final response = await _dio.post('/admin/system/generate-report', data: {
        'report_type': reportType,
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
        if (format != null) 'format': format,
      });
      return response.data['data']['download_url'] as String;
    } catch (e) {
      throw Exception('Failed to generate system report: $e');
    }
  }
}

/// System service provider
final systemServiceProvider = Provider<SystemService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return SystemService(apiService.dio);
});
