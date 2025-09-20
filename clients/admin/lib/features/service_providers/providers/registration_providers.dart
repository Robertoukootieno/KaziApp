import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/service_provider_registration.dart';
import '../services/registration_service.dart';
import '../../../shared/services/websocket_service.dart';

/// Provider for pending registrations
final pendingRegistrationsProvider = FutureProvider<List<ServiceProviderRegistration>>((ref) async {
  final registrationService = ref.watch(registrationServiceProvider);
  return registrationService.getPendingRegistrations();
});

/// Provider for all registrations with filtering
final registrationsProvider = FutureProvider.family<List<ServiceProviderRegistration>, RegistrationFilters>((ref, filters) async {
  final registrationService = ref.watch(registrationServiceProvider);
  return registrationService.getRegistrations(
    status: filters.status,
    serviceType: filters.serviceType,
    searchQuery: filters.searchQuery,
    page: filters.page,
    limit: filters.limit,
  );
});

/// Provider for a specific registration
final registrationProvider = FutureProvider.family<ServiceProviderRegistration, String>((ref, id) async {
  final registrationService = ref.watch(registrationServiceProvider);
  return registrationService.getRegistrationById(id);
});

/// Provider for registration documents
final registrationDocumentsProvider = FutureProvider.family<List<RegistrationDocument>, String>((ref, registrationId) async {
  final registrationService = ref.watch(registrationServiceProvider);
  return registrationService.getRegistrationDocuments(registrationId);
});

/// Provider for registration statistics
final registrationStatisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final registrationService = ref.watch(registrationServiceProvider);
  return registrationService.getRegistrationStatistics();
});

/// Provider for real-time registration updates
final realTimeRegistrationUpdatesProvider = StreamProvider<ServiceProviderRegistration>((ref) async* {
  final webSocketService = ref.watch(webSocketServiceProvider);
  
  await for (final message in webSocketService.subscribeToRegistrationEvents()) {
    if (message['type'] == 'registration_updated' && message['data'] != null) {
      yield ServiceProviderRegistration.fromJson(message['data']);
    }
  }
});

/// Provider for new registration notifications
final newRegistrationNotificationsProvider = StreamProvider<ServiceProviderRegistration>((ref) async* {
  final webSocketService = ref.watch(webSocketServiceProvider);
  
  await for (final message in webSocketService.subscribeToEvent('registration_submitted')) {
    if (message['data'] != null) {
      yield ServiceProviderRegistration.fromJson(message['data']);
    }
  }
});

/// State notifier for managing registration filters
class RegistrationFiltersNotifier extends StateNotifier<RegistrationFilters> {
  RegistrationFiltersNotifier() : super(const RegistrationFilters());

  void updateStatus(RegistrationStatus? status) {
    state = state.copyWith(status: status, page: 1);
  }

  void updateServiceType(String? serviceType) {
    state = state.copyWith(serviceType: serviceType, page: 1);
  }

  void updateSearchQuery(String? searchQuery) {
    state = state.copyWith(searchQuery: searchQuery, page: 1);
  }

  void updatePage(int page) {
    state = state.copyWith(page: page);
  }

  void updateLimit(int limit) {
    state = state.copyWith(limit: limit, page: 1);
  }

  void reset() {
    state = const RegistrationFilters();
  }
}

/// Provider for registration filters
final registrationFiltersProvider = StateNotifierProvider<RegistrationFiltersNotifier, RegistrationFilters>((ref) {
  return RegistrationFiltersNotifier();
});

/// State notifier for managing selected registrations
class SelectedRegistrationsNotifier extends StateNotifier<Set<String>> {
  SelectedRegistrationsNotifier() : super({});

  void toggleSelection(String registrationId) {
    if (state.contains(registrationId)) {
      state = Set.from(state)..remove(registrationId);
    } else {
      state = Set.from(state)..add(registrationId);
    }
  }

  void selectAll(List<String> registrationIds) {
    state = Set.from(registrationIds);
  }

  void clearSelection() {
    state = {};
  }

  void selectMultiple(List<String> registrationIds) {
    state = Set.from(state)..addAll(registrationIds);
  }

  void deselectMultiple(List<String> registrationIds) {
    state = Set.from(state)..removeAll(registrationIds);
  }
}

/// Provider for selected registrations
final selectedRegistrationsProvider = StateNotifierProvider<SelectedRegistrationsNotifier, Set<String>>((ref) {
  return SelectedRegistrationsNotifier();
});

/// Provider for registration actions
final registrationActionsProvider = Provider<RegistrationActions>((ref) {
  final registrationService = ref.watch(registrationServiceProvider);
  return RegistrationActions(registrationService, ref);
});

/// Class for handling registration actions
class RegistrationActions {
  final RegistrationService _registrationService;
  final Ref _ref;

  RegistrationActions(this._registrationService, this._ref);

  /// Approve a registration
  Future<void> approveRegistration(String registrationId, {String? notes}) async {
    try {
      await _registrationService.approveRegistration(registrationId, notes: notes);
      
      // Refresh relevant providers
      _ref.invalidate(pendingRegistrationsProvider);
      _ref.invalidate(registrationsProvider);
      _ref.invalidate(registrationProvider(registrationId));
      _ref.invalidate(registrationStatisticsProvider);
    } catch (e) {
      rethrow;
    }
  }

  /// Reject a registration
  Future<void> rejectRegistration(String registrationId, {required String reason, String? notes}) async {
    try {
      await _registrationService.rejectRegistration(registrationId, reason: reason, notes: notes);
      
      // Refresh relevant providers
      _ref.invalidate(pendingRegistrationsProvider);
      _ref.invalidate(registrationsProvider);
      _ref.invalidate(registrationProvider(registrationId));
      _ref.invalidate(registrationStatisticsProvider);
    } catch (e) {
      rethrow;
    }
  }

  /// Request additional information
  Future<void> requestAdditionalInfo(String registrationId, {required String message, List<String>? requiredDocuments}) async {
    try {
      await _registrationService.requestAdditionalInfo(
        registrationId,
        message: message,
        requiredDocuments: requiredDocuments,
      );
      
      // Refresh relevant providers
      _ref.invalidate(pendingRegistrationsProvider);
      _ref.invalidate(registrationsProvider);
      _ref.invalidate(registrationProvider(registrationId));
      _ref.invalidate(registrationStatisticsProvider);
    } catch (e) {
      rethrow;
    }
  }

  /// Bulk approve registrations
  Future<void> bulkApproveRegistrations(List<String> registrationIds, {String? notes}) async {
    try {
      await _registrationService.bulkApproveRegistrations(registrationIds, notes: notes);
      
      // Clear selection and refresh providers
      _ref.read(selectedRegistrationsProvider.notifier).clearSelection();
      _ref.invalidate(pendingRegistrationsProvider);
      _ref.invalidate(registrationsProvider);
      _ref.invalidate(registrationStatisticsProvider);
    } catch (e) {
      rethrow;
    }
  }

  /// Bulk reject registrations
  Future<void> bulkRejectRegistrations(List<String> registrationIds, {required String reason, String? notes}) async {
    try {
      await _registrationService.bulkRejectRegistrations(registrationIds, reason: reason, notes: notes);
      
      // Clear selection and refresh providers
      _ref.read(selectedRegistrationsProvider.notifier).clearSelection();
      _ref.invalidate(pendingRegistrationsProvider);
      _ref.invalidate(registrationsProvider);
      _ref.invalidate(registrationStatisticsProvider);
    } catch (e) {
      rethrow;
    }
  }

  /// Verify document
  Future<void> verifyDocument(String documentId, {bool isVerified = true, String? notes}) async {
    try {
      await _registrationService.verifyDocument(documentId, isVerified: isVerified, notes: notes);
      
      // Refresh document providers
      _ref.invalidate(registrationDocumentsProvider);
    } catch (e) {
      rethrow;
    }
  }
}

/// Data class for registration filters
class RegistrationFilters {
  final RegistrationStatus? status;
  final String? serviceType;
  final String? searchQuery;
  final int page;
  final int limit;

  const RegistrationFilters({
    this.status,
    this.serviceType,
    this.searchQuery,
    this.page = 1,
    this.limit = 20,
  });

  RegistrationFilters copyWith({
    RegistrationStatus? status,
    String? serviceType,
    String? searchQuery,
    int? page,
    int? limit,
  }) {
    return RegistrationFilters(
      status: status ?? this.status,
      serviceType: serviceType ?? this.serviceType,
      searchQuery: searchQuery ?? this.searchQuery,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }
}
