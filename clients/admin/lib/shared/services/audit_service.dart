import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

/// Audit service for comprehensive audit logging and compliance management
class AuditService {
  final Dio _dio;

  AuditService(this._dio);

  /// Get audit logs with filtering and pagination
  Future<Map<String, dynamic>> getAuditLogs({
    String? timeRange,
    String? severity,
    String? action,
    String? userId,
    String? resource,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      
      if (timeRange != null) queryParams['time_range'] = timeRange;
      if (severity != null && severity != 'all') queryParams['severity'] = severity;
      if (action != null) queryParams['action'] = action;
      if (userId != null) queryParams['user_id'] = userId;
      if (resource != null) queryParams['resource'] = resource;

      final response = await _dio.get(
        '/admin/audit/logs',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch audit logs: $e');
    }
  }

  /// Create audit log entry
  Future<void> createAuditLog({
    required String action,
    required String resource,
    required String userId,
    required String severity,
    required Map<String, dynamic> details,
    String? outcome,
  }) async {
    try {
      await _dio.post('/admin/audit/logs', data: {
        'action': action,
        'resource': resource,
        'user_id': userId,
        'severity': severity,
        'details': details,
        if (outcome != null) 'outcome': outcome,
      });
    } catch (e) {
      throw Exception('Failed to create audit log: $e');
    }
  }

  /// Get compliance status
  Future<Map<String, dynamic>> getComplianceStatus() async {
    try {
      final response = await _dio.get('/admin/audit/compliance/status');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch compliance status: $e');
    }
  }

  /// Run compliance check
  Future<Map<String, dynamic>> runComplianceCheck({
    String? category,
    List<String>? rules,
  }) async {
    try {
      final response = await _dio.post('/admin/audit/compliance/check', data: {
        if (category != null) 'category': category,
        if (rules != null) 'rules': rules,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to run compliance check: $e');
    }
  }

  /// Get compliance violations
  Future<Map<String, dynamic>> getComplianceViolations({
    String? status,
    String? severity,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;
      if (severity != null) queryParams['severity'] = severity;
      if (limit != null) queryParams['limit'] = limit;

      final response = await _dio.get(
        '/admin/audit/compliance/violations',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch compliance violations: $e');
    }
  }

  /// Update compliance violation
  Future<void> updateComplianceViolation(String violationId, Map<String, dynamic> updates) async {
    try {
      await _dio.patch('/admin/audit/compliance/violations/$violationId', data: updates);
    } catch (e) {
      throw Exception('Failed to update compliance violation: $e');
    }
  }

  /// Get regulatory reports
  Future<Map<String, dynamic>> getRegulatoryReports({
    String? type,
    String? status,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (type != null) queryParams['type'] = type;
      if (status != null) queryParams['status'] = status;
      if (limit != null) queryParams['limit'] = limit;

      final response = await _dio.get(
        '/admin/audit/regulatory/reports',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch regulatory reports: $e');
    }
  }

  /// Generate regulatory report
  Future<Map<String, dynamic>> generateRegulatoryReport({
    required String type,
    required String name,
    DateTime? startDate,
    DateTime? endDate,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      final response = await _dio.post('/admin/audit/regulatory/reports/generate', data: {
        'type': type,
        'name': name,
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
        if (parameters != null) 'parameters': parameters,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to generate regulatory report: $e');
    }
  }

  /// Submit regulatory report
  Future<void> submitRegulatoryReport(String reportId) async {
    try {
      await _dio.post('/admin/audit/regulatory/reports/$reportId/submit');
    } catch (e) {
      throw Exception('Failed to submit regulatory report: $e');
    }
  }

  /// Get data privacy status
  Future<Map<String, dynamic>> getDataPrivacyStatus() async {
    try {
      final response = await _dio.get('/admin/audit/privacy/status');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch data privacy status: $e');
    }
  }

  /// Get data requests
  Future<Map<String, dynamic>> getDataRequests({
    String? type,
    String? status,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (type != null) queryParams['type'] = type;
      if (status != null) queryParams['status'] = status;
      if (limit != null) queryParams['limit'] = limit;

      final response = await _dio.get(
        '/admin/audit/privacy/requests',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch data requests: $e');
    }
  }

  /// Process data request
  Future<void> processDataRequest(String requestId, String action, {String? notes}) async {
    try {
      await _dio.post('/admin/audit/privacy/requests/$requestId/process', data: {
        'action': action,
        if (notes != null) 'notes': notes,
      });
    } catch (e) {
      throw Exception('Failed to process data request: $e');
    }
  }

  /// Get security incidents
  Future<Map<String, dynamic>> getSecurityIncidents({
    String? status,
    String? severity,
    String? type,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;
      if (severity != null) queryParams['severity'] = severity;
      if (type != null) queryParams['type'] = type;
      if (limit != null) queryParams['limit'] = limit;

      final response = await _dio.get(
        '/admin/audit/security/incidents',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch security incidents: $e');
    }
  }

  /// Create security incident
  Future<Map<String, dynamic>> createSecurityIncident({
    required String title,
    required String type,
    required String severity,
    required String description,
    List<String>? affectedSystems,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _dio.post('/admin/audit/security/incidents', data: {
        'title': title,
        'type': type,
        'severity': severity,
        'description': description,
        if (affectedSystems != null) 'affected_systems': affectedSystems,
        if (metadata != null) 'metadata': metadata,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to create security incident: $e');
    }
  }

  /// Update security incident
  Future<void> updateSecurityIncident(String incidentId, Map<String, dynamic> updates) async {
    try {
      await _dio.patch('/admin/audit/security/incidents/$incidentId', data: updates);
    } catch (e) {
      throw Exception('Failed to update security incident: $e');
    }
  }

  /// Get audit trail
  Future<Map<String, dynamic>> getAuditTrail({
    String? entityType,
    String? entityId,
    String? action,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (entityType != null) queryParams['entity_type'] = entityType;
      if (entityId != null) queryParams['entity_id'] = entityId;
      if (action != null) queryParams['action'] = action;
      if (limit != null) queryParams['limit'] = limit;

      final response = await _dio.get(
        '/admin/audit/trail',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch audit trail: $e');
    }
  }

  /// Create audit trail entry
  Future<void> createAuditTrail({
    required String entityType,
    required String entityId,
    required String action,
    required Map<String, dynamic> changes,
    String? reason,
  }) async {
    try {
      await _dio.post('/admin/audit/trail', data: {
        'entity_type': entityType,
        'entity_id': entityId,
        'action': action,
        'changes': changes,
        if (reason != null) 'reason': reason,
      });
    } catch (e) {
      throw Exception('Failed to create audit trail entry: $e');
    }
  }

  /// Get audit statistics
  Future<Map<String, dynamic>> getAuditStatistics({
    String? timeRange,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (timeRange != null) queryParams['time_range'] = timeRange;

      final response = await _dio.get(
        '/admin/audit/statistics',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch audit statistics: $e');
    }
  }

  /// Get compliance trends
  Future<Map<String, dynamic>> getComplianceTrends({
    String? timeRange,
    String? category,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (timeRange != null) queryParams['time_range'] = timeRange;
      if (category != null) queryParams['category'] = category;

      final response = await _dio.get(
        '/admin/audit/compliance/trends',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch compliance trends: $e');
    }
  }

  /// Export audit data
  Future<String> exportAuditData({
    required String dataType,
    DateTime? startDate,
    DateTime? endDate,
    Map<String, dynamic>? filters,
    String? format,
  }) async {
    try {
      final response = await _dio.post('/admin/audit/export', data: {
        'data_type': dataType,
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
        if (filters != null) 'filters': filters,
        if (format != null) 'format': format,
      });
      return response.data['data']['download_url'] as String;
    } catch (e) {
      throw Exception('Failed to export audit data: $e');
    }
  }

  /// Get audit configuration
  Future<Map<String, dynamic>> getAuditConfiguration() async {
    try {
      final response = await _dio.get('/admin/audit/configuration');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch audit configuration: $e');
    }
  }

  /// Update audit configuration
  Future<void> updateAuditConfiguration(Map<String, dynamic> config) async {
    try {
      await _dio.put('/admin/audit/configuration', data: config);
    } catch (e) {
      throw Exception('Failed to update audit configuration: $e');
    }
  }

  /// Get retention policies
  Future<Map<String, dynamic>> getRetentionPolicies() async {
    try {
      final response = await _dio.get('/admin/audit/retention-policies');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch retention policies: $e');
    }
  }

  /// Update retention policy
  Future<void> updateRetentionPolicy(String policyId, Map<String, dynamic> policy) async {
    try {
      await _dio.put('/admin/audit/retention-policies/$policyId', data: policy);
    } catch (e) {
      throw Exception('Failed to update retention policy: $e');
    }
  }

  /// Archive old audit data
  Future<Map<String, dynamic>> archiveAuditData({
    required DateTime beforeDate,
    List<String>? dataTypes,
  }) async {
    try {
      final response = await _dio.post('/admin/audit/archive', data: {
        'before_date': beforeDate.toIso8601String(),
        if (dataTypes != null) 'data_types': dataTypes,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to archive audit data: $e');
    }
  }

  /// Get compliance frameworks
  Future<Map<String, dynamic>> getComplianceFrameworks() async {
    try {
      final response = await _dio.get('/admin/audit/compliance/frameworks');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch compliance frameworks: $e');
    }
  }

  /// Update compliance framework
  Future<void> updateComplianceFramework(String frameworkId, Map<String, dynamic> framework) async {
    try {
      await _dio.put('/admin/audit/compliance/frameworks/$frameworkId', data: framework);
    } catch (e) {
      throw Exception('Failed to update compliance framework: $e');
    }
  }

  /// Get audit alerts
  Future<Map<String, dynamic>> getAuditAlerts({
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
        '/admin/audit/alerts',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch audit alerts: $e');
    }
  }

  /// Create audit alert rule
  Future<Map<String, dynamic>> createAuditAlertRule({
    required String name,
    required String condition,
    required String severity,
    required List<String> actions,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _dio.post('/admin/audit/alert-rules', data: {
        'name': name,
        'condition': condition,
        'severity': severity,
        'actions': actions,
        if (metadata != null) 'metadata': metadata,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to create audit alert rule: $e');
    }
  }

  /// Test audit alert rule
  Future<Map<String, dynamic>> testAuditAlertRule(String ruleId) async {
    try {
      final response = await _dio.post('/admin/audit/alert-rules/$ruleId/test');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to test audit alert rule: $e');
    }
  }
}

/// Audit service provider
final auditServiceProvider = Provider<AuditService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuditService(apiService.dio);
});
