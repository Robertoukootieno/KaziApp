import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/services/audit_service.dart';

/// Audit log model
class AuditLog {
  final String id;
  final String action;
  final String resource;
  final String userId;
  final String userName;
  final String severity;
  final Map<String, dynamic> details;
  final String ipAddress;
  final String userAgent;
  final DateTime timestamp;
  final String? outcome;

  const AuditLog({
    required this.id,
    required this.action,
    required this.resource,
    required this.userId,
    required this.userName,
    required this.severity,
    required this.details,
    required this.ipAddress,
    required this.userAgent,
    required this.timestamp,
    this.outcome,
  });

  factory AuditLog.fromJson(Map<String, dynamic> json) {
    return AuditLog(
      id: json['id'] as String,
      action: json['action'] as String,
      resource: json['resource'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      severity: json['severity'] as String,
      details: json['details'] as Map<String, dynamic>,
      ipAddress: json['ip_address'] as String,
      userAgent: json['user_agent'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      outcome: json['outcome'] as String?,
    );
  }
}

/// Compliance status model
class ComplianceStatus {
  final double overallScore;
  final int activeViolations;
  final int pendingReviews;
  final DateTime lastAuditDate;
  final Map<String, ComplianceCategory> categories;
  final List<ComplianceViolation> recentViolations;

  const ComplianceStatus({
    required this.overallScore,
    required this.activeViolations,
    required this.pendingReviews,
    required this.lastAuditDate,
    required this.categories,
    required this.recentViolations,
  });

  factory ComplianceStatus.fromJson(Map<String, dynamic> json) {
    return ComplianceStatus(
      overallScore: (json['overall_score'] as num).toDouble(),
      activeViolations: json['active_violations'] as int,
      pendingReviews: json['pending_reviews'] as int,
      lastAuditDate: DateTime.parse(json['last_audit_date'] as String),
      categories: Map<String, ComplianceCategory>.from(
        (json['categories'] as Map).map(
          (key, value) => MapEntry(
            key as String,
            ComplianceCategory.fromJson(value as Map<String, dynamic>),
          ),
        ),
      ),
      recentViolations: (json['recent_violations'] as List)
          .map((v) => ComplianceViolation.fromJson(v))
          .toList(),
    );
  }
}

class ComplianceCategory {
  final String name;
  final double score;
  final String status;
  final int violations;
  final DateTime lastChecked;

  const ComplianceCategory({
    required this.name,
    required this.score,
    required this.status,
    required this.violations,
    required this.lastChecked,
  });

  factory ComplianceCategory.fromJson(Map<String, dynamic> json) {
    return ComplianceCategory(
      name: json['name'] as String,
      score: (json['score'] as num).toDouble(),
      status: json['status'] as String,
      violations: json['violations'] as int,
      lastChecked: DateTime.parse(json['last_checked'] as String),
    );
  }
}

class ComplianceViolation {
  final String id;
  final String type;
  final String severity;
  final String description;
  final String status;
  final DateTime detectedAt;
  final String? assignedTo;

  const ComplianceViolation({
    required this.id,
    required this.type,
    required this.severity,
    required this.description,
    required this.status,
    required this.detectedAt,
    this.assignedTo,
  });

  factory ComplianceViolation.fromJson(Map<String, dynamic> json) {
    return ComplianceViolation(
      id: json['id'] as String,
      type: json['type'] as String,
      severity: json['severity'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      detectedAt: DateTime.parse(json['detected_at'] as String),
      assignedTo: json['assigned_to'] as String?,
    );
  }
}

/// Regulatory report model
class RegulatoryReport {
  final String id;
  final String name;
  final String type;
  final String status;
  final DateTime generatedAt;
  final DateTime? submittedAt;
  final String generatedBy;
  final Map<String, dynamic> metadata;
  final String? downloadUrl;

  const RegulatoryReport({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.generatedAt,
    this.submittedAt,
    required this.generatedBy,
    required this.metadata,
    this.downloadUrl,
  });

  factory RegulatoryReport.fromJson(Map<String, dynamic> json) {
    return RegulatoryReport(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      generatedAt: DateTime.parse(json['generated_at'] as String),
      submittedAt: json['submitted_at'] != null 
          ? DateTime.parse(json['submitted_at'] as String)
          : null,
      generatedBy: json['generated_by'] as String,
      metadata: json['metadata'] as Map<String, dynamic>,
      downloadUrl: json['download_url'] as String?,
    );
  }
}

/// Data privacy status model
class DataPrivacyStatus {
  final int totalDataRequests;
  final int pendingRequests;
  final int completedRequests;
  final Map<String, int> requestsByType;
  final List<DataRequest> recentRequests;
  final Map<String, dynamic> privacyMetrics;

  const DataPrivacyStatus({
    required this.totalDataRequests,
    required this.pendingRequests,
    required this.completedRequests,
    required this.requestsByType,
    required this.recentRequests,
    required this.privacyMetrics,
  });

  factory DataPrivacyStatus.fromJson(Map<String, dynamic> json) {
    return DataPrivacyStatus(
      totalDataRequests: json['total_data_requests'] as int,
      pendingRequests: json['pending_requests'] as int,
      completedRequests: json['completed_requests'] as int,
      requestsByType: Map<String, int>.from(json['requests_by_type'] as Map),
      recentRequests: (json['recent_requests'] as List)
          .map((r) => DataRequest.fromJson(r))
          .toList(),
      privacyMetrics: json['privacy_metrics'] as Map<String, dynamic>,
    );
  }
}

class DataRequest {
  final String id;
  final String type;
  final String status;
  final String requesterEmail;
  final DateTime requestedAt;
  final DateTime? completedAt;
  final String? assignedTo;

  const DataRequest({
    required this.id,
    required this.type,
    required this.status,
    required this.requesterEmail,
    required this.requestedAt,
    this.completedAt,
    this.assignedTo,
  });

  factory DataRequest.fromJson(Map<String, dynamic> json) {
    return DataRequest(
      id: json['id'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      requesterEmail: json['requester_email'] as String,
      requestedAt: DateTime.parse(json['requested_at'] as String),
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      assignedTo: json['assigned_to'] as String?,
    );
  }
}

/// Security incident model
class SecurityIncident {
  final String id;
  final String title;
  final String type;
  final String severity;
  final String status;
  final String description;
  final DateTime detectedAt;
  final DateTime? resolvedAt;
  final String reportedBy;
  final String? assignedTo;
  final List<String> affectedSystems;
  final Map<String, dynamic> metadata;

  const SecurityIncident({
    required this.id,
    required this.title,
    required this.type,
    required this.severity,
    required this.status,
    required this.description,
    required this.detectedAt,
    this.resolvedAt,
    required this.reportedBy,
    this.assignedTo,
    required this.affectedSystems,
    required this.metadata,
  });

  factory SecurityIncident.fromJson(Map<String, dynamic> json) {
    return SecurityIncident(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      severity: json['severity'] as String,
      status: json['status'] as String,
      description: json['description'] as String,
      detectedAt: DateTime.parse(json['detected_at'] as String),
      resolvedAt: json['resolved_at'] != null 
          ? DateTime.parse(json['resolved_at'] as String)
          : null,
      reportedBy: json['reported_by'] as String,
      assignedTo: json['assigned_to'] as String?,
      affectedSystems: List<String>.from(json['affected_systems'] as List),
      metadata: json['metadata'] as Map<String, dynamic>,
    );
  }
}

/// Audit trail model
class AuditTrail {
  final String id;
  final String entityType;
  final String entityId;
  final String action;
  final Map<String, dynamic> changes;
  final String userId;
  final String userName;
  final DateTime timestamp;
  final String? reason;

  const AuditTrail({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.action,
    required this.changes,
    required this.userId,
    required this.userName,
    required this.timestamp,
    this.reason,
  });

  factory AuditTrail.fromJson(Map<String, dynamic> json) {
    return AuditTrail(
      id: json['id'] as String,
      entityType: json['entity_type'] as String,
      entityId: json['entity_id'] as String,
      action: json['action'] as String,
      changes: json['changes'] as Map<String, dynamic>,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      reason: json['reason'] as String?,
    );
  }
}

/// Audit logs state notifier
class AuditLogsNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final AuditService _service;

  AuditLogsNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadAuditLogs({
    String? timeRange,
    String? severity,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getAuditLogs(
        timeRange: timeRange,
        severity: severity,
        page: page,
        limit: limit,
      );
      
      final logs = (result['logs'] as List)
          .map((json) => AuditLog.fromJson(json))
          .toList();
      
      state = AsyncValue.data({
        'logs': logs,
        'total': result['total'],
        'page': result['page'],
        'limit': result['limit'],
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Compliance status state notifier
class ComplianceStatusNotifier extends StateNotifier<AsyncValue<ComplianceStatus>> {
  final AuditService _service;

  ComplianceStatusNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadComplianceStatus() async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getComplianceStatus();
      state = AsyncValue.data(ComplianceStatus.fromJson(result));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Regulatory reports state notifier
class RegulatoryReportsNotifier extends StateNotifier<AsyncValue<List<RegulatoryReport>>> {
  final AuditService _service;

  RegulatoryReportsNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadReports() async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getRegulatoryReports();
      final reports = (result['reports'] as List)
          .map((json) => RegulatoryReport.fromJson(json))
          .toList();
      state = AsyncValue.data(reports);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Data privacy status state notifier
class DataPrivacyStatusNotifier extends StateNotifier<AsyncValue<DataPrivacyStatus>> {
  final AuditService _service;

  DataPrivacyStatusNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadPrivacyStatus() async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getDataPrivacyStatus();
      state = AsyncValue.data(DataPrivacyStatus.fromJson(result));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Security incidents state notifier
class SecurityIncidentsNotifier extends StateNotifier<AsyncValue<List<SecurityIncident>>> {
  final AuditService _service;

  SecurityIncidentsNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadIncidents() async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getSecurityIncidents();
      final incidents = (result['incidents'] as List)
          .map((json) => SecurityIncident.fromJson(json))
          .toList();
      state = AsyncValue.data(incidents);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Audit trail state notifier
class AuditTrailNotifier extends StateNotifier<AsyncValue<List<AuditTrail>>> {
  final AuditService _service;

  AuditTrailNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadAuditTrail({
    String? entityType,
    String? entityId,
  }) async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getAuditTrail(
        entityType: entityType,
        entityId: entityId,
      );
      final trail = (result['trail'] as List)
          .map((json) => AuditTrail.fromJson(json))
          .toList();
      state = AsyncValue.data(trail);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Providers
final auditLogsProvider = StateNotifierProvider<AuditLogsNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  final service = ref.watch(auditServiceProvider);
  return AuditLogsNotifier(service);
});

final complianceStatusProvider = StateNotifierProvider<ComplianceStatusNotifier, AsyncValue<ComplianceStatus>>((ref) {
  final service = ref.watch(auditServiceProvider);
  return ComplianceStatusNotifier(service);
});

final regulatoryReportsProvider = StateNotifierProvider<RegulatoryReportsNotifier, AsyncValue<List<RegulatoryReport>>>((ref) {
  final service = ref.watch(auditServiceProvider);
  return RegulatoryReportsNotifier(service);
});

final dataPrivacyStatusProvider = StateNotifierProvider<DataPrivacyStatusNotifier, AsyncValue<DataPrivacyStatus>>((ref) {
  final service = ref.watch(auditServiceProvider);
  return DataPrivacyStatusNotifier(service);
});

final securityIncidentsProvider = StateNotifierProvider<SecurityIncidentsNotifier, AsyncValue<List<SecurityIncident>>>((ref) {
  final service = ref.watch(auditServiceProvider);
  return SecurityIncidentsNotifier(service);
});

final auditTrailProvider = StateNotifierProvider<AuditTrailNotifier, AsyncValue<List<AuditTrail>>>((ref) {
  final service = ref.watch(auditServiceProvider);
  return AuditTrailNotifier(service);
});

/// Audit statistics provider
final auditStatisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.watch(auditServiceProvider);
  return await service.getAuditStatistics();
});

/// Compliance trends provider
final complianceTrendsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.watch(auditServiceProvider);
  return await service.getComplianceTrends();
});
