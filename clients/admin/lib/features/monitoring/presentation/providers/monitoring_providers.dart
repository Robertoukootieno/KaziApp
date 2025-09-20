import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/services/monitoring_service.dart';

/// System health data model
class SystemHealth {
  final String overallStatus;
  final int activeUsers;
  final int averageResponseTime;
  final double uptime;
  final double cpuUsage;
  final double memoryUsage;
  final double diskUsage;
  final Map<String, dynamic> services;
  final DateTime lastUpdated;

  const SystemHealth({
    required this.overallStatus,
    required this.activeUsers,
    required this.averageResponseTime,
    required this.uptime,
    required this.cpuUsage,
    required this.memoryUsage,
    required this.diskUsage,
    required this.services,
    required this.lastUpdated,
  });

  factory SystemHealth.fromJson(Map<String, dynamic> json) {
    return SystemHealth(
      overallStatus: json['overall_status'] as String,
      activeUsers: json['active_users'] as int,
      averageResponseTime: json['average_response_time'] as int,
      uptime: (json['uptime'] as num).toDouble(),
      cpuUsage: (json['cpu_usage'] as num).toDouble(),
      memoryUsage: (json['memory_usage'] as num).toDouble(),
      diskUsage: (json['disk_usage'] as num).toDouble(),
      services: json['services'] as Map<String, dynamic>,
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }
}

/// Performance metrics data model
class PerformanceMetrics {
  final Map<String, List<double>> responseTimeHistory;
  final Map<String, List<double>> throughputHistory;
  final Map<String, List<double>> errorRateHistory;
  final Map<String, double> currentMetrics;
  final List<String> timestamps;

  const PerformanceMetrics({
    required this.responseTimeHistory,
    required this.throughputHistory,
    required this.errorRateHistory,
    required this.currentMetrics,
    required this.timestamps,
  });

  factory PerformanceMetrics.fromJson(Map<String, dynamic> json) {
    return PerformanceMetrics(
      responseTimeHistory: Map<String, List<double>>.from(
        (json['response_time_history'] as Map).map(
          (key, value) => MapEntry(
            key as String,
            List<double>.from(value as List),
          ),
        ),
      ),
      throughputHistory: Map<String, List<double>>.from(
        (json['throughput_history'] as Map).map(
          (key, value) => MapEntry(
            key as String,
            List<double>.from(value as List),
          ),
        ),
      ),
      errorRateHistory: Map<String, List<double>>.from(
        (json['error_rate_history'] as Map).map(
          (key, value) => MapEntry(
            key as String,
            List<double>.from(value as List),
          ),
        ),
      ),
      currentMetrics: Map<String, double>.from(
        (json['current_metrics'] as Map).map(
          (key, value) => MapEntry(key as String, (value as num).toDouble()),
        ),
      ),
      timestamps: List<String>.from(json['timestamps'] as List),
    );
  }
}

/// Alert data model
class SystemAlert {
  final String id;
  final String title;
  final String description;
  final String severity;
  final String status;
  final String source;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? assignedTo;
  final Map<String, dynamic>? metadata;

  const SystemAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.status,
    required this.source,
    required this.createdAt,
    this.resolvedAt,
    this.assignedTo,
    this.metadata,
  });

  factory SystemAlert.fromJson(Map<String, dynamic> json) {
    return SystemAlert(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      severity: json['severity'] as String,
      status: json['status'] as String,
      source: json['source'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      resolvedAt: json['resolved_at'] != null 
          ? DateTime.parse(json['resolved_at'] as String)
          : null,
      assignedTo: json['assigned_to'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}

/// Service status data model
class ServiceStatus {
  final Map<String, ServiceInfo> services;
  final DateTime lastUpdated;

  const ServiceStatus({
    required this.services,
    required this.lastUpdated,
  });

  factory ServiceStatus.fromJson(Map<String, dynamic> json) {
    return ServiceStatus(
      services: Map<String, ServiceInfo>.from(
        (json['services'] as Map).map(
          (key, value) => MapEntry(
            key as String,
            ServiceInfo.fromJson(value as Map<String, dynamic>),
          ),
        ),
      ),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }
}

class ServiceInfo {
  final String name;
  final String status;
  final double responseTime;
  final double uptime;
  final String version;
  final DateTime lastHealthCheck;

  const ServiceInfo({
    required this.name,
    required this.status,
    required this.responseTime,
    required this.uptime,
    required this.version,
    required this.lastHealthCheck,
  });

  factory ServiceInfo.fromJson(Map<String, dynamic> json) {
    return ServiceInfo(
      name: json['name'] as String,
      status: json['status'] as String,
      responseTime: (json['response_time'] as num).toDouble(),
      uptime: (json['uptime'] as num).toDouble(),
      version: json['version'] as String,
      lastHealthCheck: DateTime.parse(json['last_health_check'] as String),
    );
  }
}

/// Real-time analytics data model
class RealTimeAnalytics {
  final Map<String, List<double>> userActivity;
  final Map<String, List<double>> requestVolume;
  final Map<String, List<double>> errorRates;
  final List<String> timestamps;
  final Map<String, dynamic> currentStats;

  const RealTimeAnalytics({
    required this.userActivity,
    required this.requestVolume,
    required this.errorRates,
    required this.timestamps,
    required this.currentStats,
  });

  factory RealTimeAnalytics.fromJson(Map<String, dynamic> json) {
    return RealTimeAnalytics(
      userActivity: Map<String, List<double>>.from(
        (json['user_activity'] as Map).map(
          (key, value) => MapEntry(
            key as String,
            List<double>.from(value as List),
          ),
        ),
      ),
      requestVolume: Map<String, List<double>>.from(
        (json['request_volume'] as Map).map(
          (key, value) => MapEntry(
            key as String,
            List<double>.from(value as List),
          ),
        ),
      ),
      errorRates: Map<String, List<double>>.from(
        (json['error_rates'] as Map).map(
          (key, value) => MapEntry(
            key as String,
            List<double>.from(value as List),
          ),
        ),
      ),
      timestamps: List<String>.from(json['timestamps'] as List),
      currentStats: json['current_stats'] as Map<String, dynamic>,
    );
  }
}

/// System health state notifier
class SystemHealthNotifier extends StateNotifier<AsyncValue<SystemHealth>> {
  final MonitoringService _service;

  SystemHealthNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadSystemHealth() async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getSystemHealth();
      state = AsyncValue.data(SystemHealth.fromJson(result));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Performance metrics state notifier
class PerformanceMetricsNotifier extends StateNotifier<AsyncValue<PerformanceMetrics>> {
  final MonitoringService _service;

  PerformanceMetricsNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadMetrics({
    DateTime? startTime,
    DateTime? endTime,
    String? granularity,
  }) async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getPerformanceMetrics(
        startTime: startTime,
        endTime: endTime,
        granularity: granularity,
      );
      state = AsyncValue.data(PerformanceMetrics.fromJson(result));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Alerts state notifier
class AlertsNotifier extends StateNotifier<AsyncValue<List<SystemAlert>>> {
  final MonitoringService _service;

  AlertsNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadAlerts({
    String? severity,
    String? status,
    int? limit,
  }) async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getAlerts(
        severity: severity,
        status: status,
        limit: limit,
      );
      final alerts = (result['alerts'] as List)
          .map((json) => SystemAlert.fromJson(json))
          .toList();
      state = AsyncValue.data(alerts);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> resolveAlert(String alertId) async {
    try {
      await _service.resolveAlert(alertId);
      await loadAlerts(); // Refresh alerts
    } catch (error) {
      // Handle error
      rethrow;
    }
  }

  Future<void> assignAlert(String alertId, String assigneeId) async {
    try {
      await _service.assignAlert(alertId, assigneeId);
      await loadAlerts(); // Refresh alerts
    } catch (error) {
      // Handle error
      rethrow;
    }
  }
}

/// Service status state notifier
class ServiceStatusNotifier extends StateNotifier<AsyncValue<ServiceStatus>> {
  final MonitoringService _service;

  ServiceStatusNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadServiceStatus() async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getServiceStatus();
      state = AsyncValue.data(ServiceStatus.fromJson(result));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Real-time analytics state notifier
class RealTimeAnalyticsNotifier extends StateNotifier<AsyncValue<RealTimeAnalytics>> {
  final MonitoringService _service;

  RealTimeAnalyticsNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadAnalytics({
    String? timeRange,
    List<String>? metrics,
  }) async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getRealTimeAnalytics(
        timeRange: timeRange,
        metrics: metrics,
      );
      state = AsyncValue.data(RealTimeAnalytics.fromJson(result));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Providers
final systemHealthProvider = StateNotifierProvider<SystemHealthNotifier, AsyncValue<SystemHealth>>((ref) {
  final service = ref.watch(monitoringServiceProvider);
  return SystemHealthNotifier(service);
});

final performanceMetricsProvider = StateNotifierProvider<PerformanceMetricsNotifier, AsyncValue<PerformanceMetrics>>((ref) {
  final service = ref.watch(monitoringServiceProvider);
  return PerformanceMetricsNotifier(service);
});

final alertsProvider = StateNotifierProvider<AlertsNotifier, AsyncValue<List<SystemAlert>>>((ref) {
  final service = ref.watch(monitoringServiceProvider);
  return AlertsNotifier(service);
});

final serviceStatusProvider = StateNotifierProvider<ServiceStatusNotifier, AsyncValue<ServiceStatus>>((ref) {
  final service = ref.watch(monitoringServiceProvider);
  return ServiceStatusNotifier(service);
});

final realTimeAnalyticsProvider = StateNotifierProvider<RealTimeAnalyticsNotifier, AsyncValue<RealTimeAnalytics>>((ref) {
  final service = ref.watch(monitoringServiceProvider);
  return RealTimeAnalyticsNotifier(service);
});

/// Active alerts count provider
final activeAlertsCountProvider = Provider<int>((ref) {
  final alertsAsync = ref.watch(alertsProvider);
  return alertsAsync.when(
    data: (alerts) => alerts.where((alert) => alert.status != 'resolved').length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// Critical alerts provider
final criticalAlertsProvider = Provider<List<SystemAlert>>((ref) {
  final alertsAsync = ref.watch(alertsProvider);
  return alertsAsync.when(
    data: (alerts) => alerts.where((alert) => 
        alert.severity == 'critical' && alert.status != 'resolved').toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});
