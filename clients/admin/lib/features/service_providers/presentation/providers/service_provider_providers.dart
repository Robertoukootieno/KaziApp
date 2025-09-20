import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/service_provider.dart';
import '../../../../shared/services/service_provider_service.dart';

/// Service provider search filters
class ServiceProviderSearchFilters {
  final String? search;
  final ServiceProviderType? providerType;
  final VerificationStatus? verificationStatus;
  final List<String>? serviceAreas;
  final bool? isActive;
  final bool? isAvailable;
  final double? minRating;
  final DateTime? joinedAfter;
  final DateTime? joinedBefore;
  final String? sortBy;
  final String? sortOrder;

  const ServiceProviderSearchFilters({
    this.search,
    this.providerType,
    this.verificationStatus,
    this.serviceAreas,
    this.isActive,
    this.isAvailable,
    this.minRating,
    this.joinedAfter,
    this.joinedBefore,
    this.sortBy,
    this.sortOrder,
  });

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};
    
    if (search != null && search!.isNotEmpty) params['search'] = search;
    if (providerType != null) params['provider_type'] = providerType!.name;
    if (verificationStatus != null) params['verification_status'] = verificationStatus!.name;
    if (serviceAreas != null && serviceAreas!.isNotEmpty) params['service_areas'] = serviceAreas!.join(',');
    if (isActive != null) params['is_active'] = isActive;
    if (isAvailable != null) params['is_available'] = isAvailable;
    if (minRating != null) params['min_rating'] = minRating;
    if (joinedAfter != null) params['joined_after'] = joinedAfter!.toIso8601String();
    if (joinedBefore != null) params['joined_before'] = joinedBefore!.toIso8601String();
    if (sortBy != null) params['sort_by'] = sortBy;
    if (sortOrder != null) params['sort_order'] = sortOrder;
    
    return params;
  }
}

/// Service provider statistics
class ServiceProviderStatistics {
  final int totalProviders;
  final int verifiedProviders;
  final int pendingVerification;
  final int activeProviders;
  final int suspendedProviders;
  final double averageRating;
  final Map<String, int> providersByType;
  final Map<String, int> providersByLocation;
  final Map<String, double> performanceMetrics;
  final Map<String, int> verificationQueue;

  const ServiceProviderStatistics({
    required this.totalProviders,
    required this.verifiedProviders,
    required this.pendingVerification,
    required this.activeProviders,
    required this.suspendedProviders,
    required this.averageRating,
    required this.providersByType,
    required this.providersByLocation,
    required this.performanceMetrics,
    required this.verificationQueue,
  });

  factory ServiceProviderStatistics.fromJson(Map<String, dynamic> json) {
    return ServiceProviderStatistics(
      totalProviders: json['total_providers'] as int,
      verifiedProviders: json['verified_providers'] as int,
      pendingVerification: json['pending_verification'] as int,
      activeProviders: json['active_providers'] as int,
      suspendedProviders: json['suspended_providers'] as int,
      averageRating: (json['average_rating'] as num).toDouble(),
      providersByType: Map<String, int>.from(json['providers_by_type'] as Map),
      providersByLocation: Map<String, int>.from(json['providers_by_location'] as Map),
      performanceMetrics: Map<String, double>.from(
        (json['performance_metrics'] as Map).map(
          (key, value) => MapEntry(key as String, (value as num).toDouble()),
        ),
      ),
      verificationQueue: Map<String, int>.from(json['verification_queue'] as Map),
    );
  }
}

/// Service provider list state notifier
class ServiceProviderListNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final ServiceProviderService _service;

  ServiceProviderListNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadProviders({
    int page = 1,
    int limit = 50,
    ServiceProviderSearchFilters? filters,
  }) async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getAllServiceProviders(
        page: page,
        limit: limit,
        search: filters?.search,
        type: filters?.providerType,
        status: filters?.verificationStatus,
        serviceAreas: filters?.serviceAreas,
        isActive: filters?.isActive,
      );
      state = AsyncValue.data(result);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshProviders() async {
    await loadProviders();
  }
}

/// Service provider statistics state notifier
class ServiceProviderStatisticsNotifier extends StateNotifier<AsyncValue<ServiceProviderStatistics>> {
  final ServiceProviderService _service;

  ServiceProviderStatisticsNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadStatistics() async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getServiceProviderStatistics();
      state = AsyncValue.data(ServiceProviderStatistics.fromJson(result));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Verification queue state notifier
class VerificationQueueNotifier extends StateNotifier<AsyncValue<List<ServiceProvider>>> {
  final ServiceProviderService _service;

  VerificationQueueNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadQueue() async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getAllServiceProviders(
        status: VerificationStatus.pending,
        limit: 100,
      );
      final providers = result['providers'] as List<ServiceProvider>;
      state = AsyncValue.data(providers);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> verifyProvider(String providerId, {String? notes}) async {
    try {
      await _service.verifyServiceProvider(providerId, notes: notes);
      await loadQueue(); // Refresh the queue
    } catch (error) {
      // Handle error
      rethrow;
    }
  }

  Future<void> rejectProvider(String providerId, String reason) async {
    try {
      await _service.rejectServiceProvider(providerId, reason);
      await loadQueue(); // Refresh the queue
    } catch (error) {
      // Handle error
      rethrow;
    }
  }
}

/// Compliance metrics state notifier
class ComplianceMetricsNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final ServiceProviderService _service;

  ComplianceMetricsNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadMetrics() async {
    try {
      state = const AsyncValue.loading();
      // This would be a specific endpoint for compliance metrics
      final result = await _service.getServiceProviderStatistics();
      state = AsyncValue.data(result);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Providers
final serviceProviderListProvider = StateNotifierProvider<ServiceProviderListNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  final service = ref.watch(serviceProviderServiceProvider);
  return ServiceProviderListNotifier(service);
});

final serviceProviderStatisticsProvider = StateNotifierProvider<ServiceProviderStatisticsNotifier, AsyncValue<ServiceProviderStatistics>>((ref) {
  final service = ref.watch(serviceProviderServiceProvider);
  return ServiceProviderStatisticsNotifier(service);
});

final verificationQueueProvider = StateNotifierProvider<VerificationQueueNotifier, AsyncValue<List<ServiceProvider>>>((ref) {
  final service = ref.watch(serviceProviderServiceProvider);
  return VerificationQueueNotifier(service);
});

final complianceMetricsProvider = StateNotifierProvider<ComplianceMetricsNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  final service = ref.watch(serviceProviderServiceProvider);
  return ComplianceMetricsNotifier(service);
});

/// Selected service provider provider
final selectedServiceProviderProvider = StateProvider<ServiceProvider?>((ref) => null);

/// Service provider details provider
final serviceProviderDetailsProvider = FutureProvider.family<ServiceProvider, String>((ref, providerId) async {
  final service = ref.watch(serviceProviderServiceProvider);
  return await service.getServiceProviderById(providerId);
});

/// Service provider performance analytics provider
final serviceProviderPerformanceProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, providerId) async {
  final service = ref.watch(serviceProviderServiceProvider);
  return await service.getServiceProviderPerformance(providerId);
});

/// Service provider activity logs provider
final serviceProviderActivityLogsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, providerId) async {
  final service = ref.watch(serviceProviderServiceProvider);
  return await service.getServiceProviderActivityLogs(providerId);
});
