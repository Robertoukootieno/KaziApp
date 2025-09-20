import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/service_provider_registration.dart';
import '../../../shared/services/api_service.dart';

/// Service for handling service provider registration operations
class RegistrationService {
  final ApiService _apiService;

  RegistrationService(this._apiService);

  /// Get all pending registrations
  Future<List<ServiceProviderRegistration>> getPendingRegistrations({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get(
        '/admin/registrations',
        queryParameters: {
          'status': 'pending',
          'page': page,
          'limit': limit,
        },
      );

      final List<dynamic> data = response.data['data'] ?? [];
      return data
          .map((json) => ServiceProviderRegistration.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch pending registrations: $e');
    }
  }

  /// Get all registrations with filtering
  Future<List<ServiceProviderRegistration>> getRegistrations({
    RegistrationStatus? status,
    String? serviceType,
    String? searchQuery,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (status != null) {
        queryParams['status'] = status.name;
      }
      if (serviceType != null) {
        queryParams['serviceType'] = serviceType;
      }
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['search'] = searchQuery;
      }

      final response = await _apiService.get(
        '/admin/registrations',
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data['data'] ?? [];
      return data
          .map((json) => ServiceProviderRegistration.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch registrations: $e');
    }
  }

  /// Get registration by ID
  Future<ServiceProviderRegistration> getRegistrationById(String id) async {
    try {
      final response = await _apiService.get('/admin/registrations/$id');
      return ServiceProviderRegistration.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to fetch registration: $e');
    }
  }

  /// Get registration documents
  Future<List<RegistrationDocument>> getRegistrationDocuments(String registrationId) async {
    try {
      final response = await _apiService.get('/admin/registrations/$registrationId/documents');
      final List<dynamic> data = response.data['data'] ?? [];
      return data
          .map((json) => RegistrationDocument.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch registration documents: $e');
    }
  }

  /// Approve registration
  Future<ServiceProviderRegistration> approveRegistration(
    String registrationId, {
    String? notes,
  }) async {
    try {
      final response = await _apiService.post(
        '/admin/registrations/$registrationId/approve',
        data: {
          'action': 'approve',
          'notes': notes,
          'approvedAt': DateTime.now().toIso8601String(),
        },
      );

      return ServiceProviderRegistration.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to approve registration: $e');
    }
  }

  /// Reject registration
  Future<ServiceProviderRegistration> rejectRegistration(
    String registrationId, {
    required String reason,
    String? notes,
  }) async {
    try {
      final response = await _apiService.post(
        '/admin/registrations/$registrationId/reject',
        data: {
          'action': 'reject',
          'reason': reason,
          'notes': notes,
          'rejectedAt': DateTime.now().toIso8601String(),
        },
      );

      return ServiceProviderRegistration.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to reject registration: $e');
    }
  }

  /// Request additional information
  Future<ServiceProviderRegistration> requestAdditionalInfo(
    String registrationId, {
    required String message,
    List<String>? requiredDocuments,
  }) async {
    try {
      final response = await _apiService.post(
        '/admin/registrations/$registrationId/request-info',
        data: {
          'action': 'request_more_info',
          'message': message,
          'requiredDocuments': requiredDocuments ?? [],
          'requestedAt': DateTime.now().toIso8601String(),
        },
      );

      return ServiceProviderRegistration.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to request additional information: $e');
    }
  }

  /// Update registration status
  Future<ServiceProviderRegistration> updateRegistrationStatus(
    String registrationId,
    RegistrationStatus status, {
    String? notes,
  }) async {
    try {
      final response = await _apiService.patch(
        '/admin/registrations/$registrationId',
        data: {
          'status': status.name,
          'notes': notes,
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );

      return ServiceProviderRegistration.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to update registration status: $e');
    }
  }

  /// Verify document
  Future<RegistrationDocument> verifyDocument(
    String documentId, {
    bool isVerified = true,
    String? notes,
  }) async {
    try {
      final response = await _apiService.post(
        '/admin/documents/$documentId/verify',
        data: {
          'status': isVerified ? 'verified' : 'rejected',
          'verificationNotes': notes,
          'verifiedAt': DateTime.now().toIso8601String(),
        },
      );

      return RegistrationDocument.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to verify document: $e');
    }
  }

  /// Get registration statistics
  Future<Map<String, dynamic>> getRegistrationStatistics() async {
    try {
      final response = await _apiService.get('/admin/registrations/statistics');
      return response.data['data'] ?? {};
    } catch (e) {
      throw Exception('Failed to fetch registration statistics: $e');
    }
  }

  /// Send notification to service provider
  Future<void> sendNotification(
    String registrationId, {
    required NotificationType type,
    required String title,
    required String message,
    Map<String, dynamic>? data,
  }) async {
    try {
      await _apiService.post(
        '/admin/registrations/$registrationId/notify',
        data: {
          'type': type.name,
          'title': title,
          'message': message,
          'data': data ?? {},
          'sentAt': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      throw Exception('Failed to send notification: $e');
    }
  }

  /// Bulk approve registrations
  Future<List<ServiceProviderRegistration>> bulkApproveRegistrations(
    List<String> registrationIds, {
    String? notes,
  }) async {
    try {
      final response = await _apiService.post(
        '/admin/registrations/bulk-approve',
        data: {
          'registrationIds': registrationIds,
          'notes': notes,
          'approvedAt': DateTime.now().toIso8601String(),
        },
      );

      final List<dynamic> data = response.data['data'] ?? [];
      return data
          .map((json) => ServiceProviderRegistration.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to bulk approve registrations: $e');
    }
  }

  /// Bulk reject registrations
  Future<List<ServiceProviderRegistration>> bulkRejectRegistrations(
    List<String> registrationIds, {
    required String reason,
    String? notes,
  }) async {
    try {
      final response = await _apiService.post(
        '/admin/registrations/bulk-reject',
        data: {
          'registrationIds': registrationIds,
          'reason': reason,
          'notes': notes,
          'rejectedAt': DateTime.now().toIso8601String(),
        },
      );

      final List<dynamic> data = response.data['data'] ?? [];
      return data
          .map((json) => ServiceProviderRegistration.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to bulk reject registrations: $e');
    }
  }
}

/// Registration service provider
final registrationServiceProvider = Provider<RegistrationService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return RegistrationService(apiService);
});
