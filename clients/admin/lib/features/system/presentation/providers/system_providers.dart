import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/services/system_service.dart';

/// Feature flag model
class FeatureFlag {
  final String id;
  final String name;
  final String description;
  final bool isEnabled;
  final String environment;
  final Map<String, dynamic> configuration;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String createdBy;

  const FeatureFlag({
    required this.id,
    required this.name,
    required this.description,
    required this.isEnabled,
    required this.environment,
    required this.configuration,
    required this.createdAt,
    this.updatedAt,
    required this.createdBy,
  });

  factory FeatureFlag.fromJson(Map<String, dynamic> json) {
    return FeatureFlag(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      isEnabled: json['is_enabled'] as bool,
      environment: json['environment'] as String,
      configuration: json['configuration'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      createdBy: json['created_by'] as String,
    );
  }

  FeatureFlag copyWith({
    String? id,
    String? name,
    String? description,
    bool? isEnabled,
    String? environment,
    Map<String, dynamic>? configuration,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) {
    return FeatureFlag(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isEnabled: isEnabled ?? this.isEnabled,
      environment: environment ?? this.environment,
      configuration: configuration ?? this.configuration,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}

/// Environment settings model
class EnvironmentSettings {
  final String currentEnvironment;
  final String appVersion;
  final Map<String, String> environmentVariables;
  final Map<String, dynamic> databaseConfig;
  final Map<String, dynamic> cacheConfig;
  final Map<String, dynamic> loggingConfig;
  final DateTime lastUpdated;

  const EnvironmentSettings({
    required this.currentEnvironment,
    required this.appVersion,
    required this.environmentVariables,
    required this.databaseConfig,
    required this.cacheConfig,
    required this.loggingConfig,
    required this.lastUpdated,
  });

  factory EnvironmentSettings.fromJson(Map<String, dynamic> json) {
    return EnvironmentSettings(
      currentEnvironment: json['current_environment'] as String,
      appVersion: json['app_version'] as String,
      environmentVariables: Map<String, String>.from(json['environment_variables'] as Map),
      databaseConfig: json['database_config'] as Map<String, dynamic>,
      cacheConfig: json['cache_config'] as Map<String, dynamic>,
      loggingConfig: json['logging_config'] as Map<String, dynamic>,
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }
}

/// API configuration model
class ApiConfiguration {
  final Map<String, ApiEndpoint> endpoints;
  final Map<String, String> globalHeaders;
  final int defaultTimeout;
  final int maxRetries;
  final Map<String, dynamic> rateLimiting;
  final Map<String, dynamic> authentication;
  final DateTime lastUpdated;

  const ApiConfiguration({
    required this.endpoints,
    required this.globalHeaders,
    required this.defaultTimeout,
    required this.maxRetries,
    required this.rateLimiting,
    required this.authentication,
    required this.lastUpdated,
  });

  factory ApiConfiguration.fromJson(Map<String, dynamic> json) {
    return ApiConfiguration(
      endpoints: Map<String, ApiEndpoint>.from(
        (json['endpoints'] as Map).map(
          (key, value) => MapEntry(
            key as String,
            ApiEndpoint.fromJson(value as Map<String, dynamic>),
          ),
        ),
      ),
      globalHeaders: Map<String, String>.from(json['global_headers'] as Map),
      defaultTimeout: json['default_timeout'] as int,
      maxRetries: json['max_retries'] as int,
      rateLimiting: json['rate_limiting'] as Map<String, dynamic>,
      authentication: json['authentication'] as Map<String, dynamic>,
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }
}

class ApiEndpoint {
  final String url;
  final String method;
  final Map<String, String> headers;
  final int timeout;
  final bool isEnabled;

  const ApiEndpoint({
    required this.url,
    required this.method,
    required this.headers,
    required this.timeout,
    required this.isEnabled,
  });

  factory ApiEndpoint.fromJson(Map<String, dynamic> json) {
    return ApiEndpoint(
      url: json['url'] as String,
      method: json['method'] as String,
      headers: Map<String, String>.from(json['headers'] as Map),
      timeout: json['timeout'] as int,
      isEnabled: json['is_enabled'] as bool,
    );
  }
}

/// Third-party integration model
class ThirdPartyIntegration {
  final String id;
  final String name;
  final String type;
  final bool isEnabled;
  final Map<String, dynamic> configuration;
  final String status;
  final DateTime lastSync;
  final Map<String, dynamic> healthCheck;

  const ThirdPartyIntegration({
    required this.id,
    required this.name,
    required this.type,
    required this.isEnabled,
    required this.configuration,
    required this.status,
    required this.lastSync,
    required this.healthCheck,
  });

  factory ThirdPartyIntegration.fromJson(Map<String, dynamic> json) {
    return ThirdPartyIntegration(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      isEnabled: json['is_enabled'] as bool,
      configuration: json['configuration'] as Map<String, dynamic>,
      status: json['status'] as String,
      lastSync: DateTime.parse(json['last_sync'] as String),
      healthCheck: json['health_check'] as Map<String, dynamic>,
    );
  }
}

/// Deployment status model
class DeploymentStatus {
  final String currentVersion;
  final String environment;
  final DateTime lastDeployment;
  final String deploymentStatus;
  final List<DeploymentHistory> history;
  final Map<String, dynamic> rollbackOptions;

  const DeploymentStatus({
    required this.currentVersion,
    required this.environment,
    required this.lastDeployment,
    required this.deploymentStatus,
    required this.history,
    required this.rollbackOptions,
  });

  factory DeploymentStatus.fromJson(Map<String, dynamic> json) {
    return DeploymentStatus(
      currentVersion: json['current_version'] as String,
      environment: json['environment'] as String,
      lastDeployment: DateTime.parse(json['last_deployment'] as String),
      deploymentStatus: json['deployment_status'] as String,
      history: (json['history'] as List)
          .map((h) => DeploymentHistory.fromJson(h))
          .toList(),
      rollbackOptions: json['rollback_options'] as Map<String, dynamic>,
    );
  }
}

class DeploymentHistory {
  final String version;
  final DateTime deployedAt;
  final String deployedBy;
  final String status;
  final String? notes;

  const DeploymentHistory({
    required this.version,
    required this.deployedAt,
    required this.deployedBy,
    required this.status,
    this.notes,
  });

  factory DeploymentHistory.fromJson(Map<String, dynamic> json) {
    return DeploymentHistory(
      version: json['version'] as String,
      deployedAt: DateTime.parse(json['deployed_at'] as String),
      deployedBy: json['deployed_by'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String?,
    );
  }
}

/// Backup status model
class BackupStatus {
  final DateTime lastBackup;
  final String backupStatus;
  final int backupSize;
  final List<BackupHistory> history;
  final Map<String, dynamic> configuration;
  final bool autoBackupEnabled;

  const BackupStatus({
    required this.lastBackup,
    required this.backupStatus,
    required this.backupSize,
    required this.history,
    required this.configuration,
    required this.autoBackupEnabled,
  });

  factory BackupStatus.fromJson(Map<String, dynamic> json) {
    return BackupStatus(
      lastBackup: DateTime.parse(json['last_backup'] as String),
      backupStatus: json['backup_status'] as String,
      backupSize: json['backup_size'] as int,
      history: (json['history'] as List)
          .map((h) => BackupHistory.fromJson(h))
          .toList(),
      configuration: json['configuration'] as Map<String, dynamic>,
      autoBackupEnabled: json['auto_backup_enabled'] as bool,
    );
  }
}

class BackupHistory {
  final String id;
  final DateTime createdAt;
  final int size;
  final String status;
  final String type;

  const BackupHistory({
    required this.id,
    required this.createdAt,
    required this.size,
    required this.status,
    required this.type,
  });

  factory BackupHistory.fromJson(Map<String, dynamic> json) {
    return BackupHistory(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      size: json['size'] as int,
      status: json['status'] as String,
      type: json['type'] as String,
    );
  }
}

/// Feature flags state notifier
class FeatureFlagsNotifier extends StateNotifier<AsyncValue<List<FeatureFlag>>> {
  final SystemService _service;

  FeatureFlagsNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadFeatureFlags() async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getFeatureFlags();
      final flags = (result['flags'] as List)
          .map((json) => FeatureFlag.fromJson(json))
          .toList();
      state = AsyncValue.data(flags);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateFeatureFlag(String flagId, bool isEnabled) async {
    try {
      await _service.updateFeatureFlag(flagId, {'is_enabled': isEnabled});
      await loadFeatureFlags(); // Refresh the list
    } catch (error) {
      rethrow;
    }
  }

  Future<void> createFeatureFlag(FeatureFlag flag) async {
    try {
      await _service.createFeatureFlag({
        'name': flag.name,
        'description': flag.description,
        'is_enabled': flag.isEnabled,
        'environment': flag.environment,
        'configuration': flag.configuration,
      });
      await loadFeatureFlags(); // Refresh the list
    } catch (error) {
      rethrow;
    }
  }
}

/// Environment settings state notifier
class EnvironmentSettingsNotifier extends StateNotifier<AsyncValue<EnvironmentSettings>> {
  final SystemService _service;

  EnvironmentSettingsNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadSettings() async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getEnvironmentSettings();
      state = AsyncValue.data(EnvironmentSettings.fromJson(result));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateSettings(Map<String, dynamic> updates) async {
    try {
      await _service.updateEnvironmentSettings(updates);
      await loadSettings(); // Refresh the settings
    } catch (error) {
      rethrow;
    }
  }
}

/// API configuration state notifier
class ApiConfigurationNotifier extends StateNotifier<AsyncValue<ApiConfiguration>> {
  final SystemService _service;

  ApiConfigurationNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadConfiguration() async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getApiConfiguration();
      state = AsyncValue.data(ApiConfiguration.fromJson(result));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateConfiguration(Map<String, dynamic> updates) async {
    try {
      await _service.updateApiConfiguration(updates);
      await loadConfiguration(); // Refresh the configuration
    } catch (error) {
      rethrow;
    }
  }
}

/// Third-party integrations state notifier
class ThirdPartyIntegrationsNotifier extends StateNotifier<AsyncValue<List<ThirdPartyIntegration>>> {
  final SystemService _service;

  ThirdPartyIntegrationsNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadIntegrations() async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getThirdPartyIntegrations();
      final integrations = (result['integrations'] as List)
          .map((json) => ThirdPartyIntegration.fromJson(json))
          .toList();
      state = AsyncValue.data(integrations);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateIntegration(String integrationId, Map<String, dynamic> updates) async {
    try {
      await _service.updateThirdPartyIntegration(integrationId, updates);
      await loadIntegrations(); // Refresh the list
    } catch (error) {
      rethrow;
    }
  }
}

/// Deployment status state notifier
class DeploymentStatusNotifier extends StateNotifier<AsyncValue<DeploymentStatus>> {
  final SystemService _service;

  DeploymentStatusNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadStatus() async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getDeploymentStatus();
      state = AsyncValue.data(DeploymentStatus.fromJson(result));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Backup status state notifier
class BackupStatusNotifier extends StateNotifier<AsyncValue<BackupStatus>> {
  final SystemService _service;

  BackupStatusNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadBackupStatus() async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getBackupStatus();
      state = AsyncValue.data(BackupStatus.fromJson(result));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createBackup(String type) async {
    try {
      await _service.createBackup(type);
      await loadBackupStatus(); // Refresh the status
    } catch (error) {
      rethrow;
    }
  }
}

/// Providers
final featureFlagsProvider = StateNotifierProvider<FeatureFlagsNotifier, AsyncValue<List<FeatureFlag>>>((ref) {
  final service = ref.watch(systemServiceProvider);
  return FeatureFlagsNotifier(service);
});

final environmentSettingsProvider = StateNotifierProvider<EnvironmentSettingsNotifier, AsyncValue<EnvironmentSettings>>((ref) {
  final service = ref.watch(systemServiceProvider);
  return EnvironmentSettingsNotifier(service);
});

final apiConfigurationProvider = StateNotifierProvider<ApiConfigurationNotifier, AsyncValue<ApiConfiguration>>((ref) {
  final service = ref.watch(systemServiceProvider);
  return ApiConfigurationNotifier(service);
});

final thirdPartyIntegrationsProvider = StateNotifierProvider<ThirdPartyIntegrationsNotifier, AsyncValue<List<ThirdPartyIntegration>>>((ref) {
  final service = ref.watch(systemServiceProvider);
  return ThirdPartyIntegrationsNotifier(service);
});

final deploymentStatusProvider = StateNotifierProvider<DeploymentStatusNotifier, AsyncValue<DeploymentStatus>>((ref) {
  final service = ref.watch(systemServiceProvider);
  return DeploymentStatusNotifier(service);
});

final backupStatusProvider = StateNotifierProvider<BackupStatusNotifier, AsyncValue<BackupStatus>>((ref) {
  final service = ref.watch(systemServiceProvider);
  return BackupStatusNotifier(service);
});

/// System health provider
final systemHealthProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.watch(systemServiceProvider);
  return await service.getSystemHealth();
});

/// Configuration history provider
final configurationHistoryProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.watch(systemServiceProvider);
  return await service.getConfigurationHistory();
});
