import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/service_provider.dart';
import 'api_service.dart';

class ServiceProviderService {
  final Dio _dio;
  
  ServiceProviderService(this._dio);

  /// Get all service providers
  Future<List<ServiceProvider>> getAllServiceProviders({
    int page = 1,
    int limit = 50,
    String? search,
    ServiceProviderType? type,
    VerificationStatus? status,
    List<String>? serviceAreas,
    bool? isActive,
  }) async {
    try {
      final response = await _dio.get('/admin/service-providers', queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null) 'search': search,
        if (type != null) 'type': type.name,
        if (status != null) 'status': status.name,
        if (serviceAreas != null) 'service_areas': serviceAreas.join(','),
        if (isActive != null) 'is_active': isActive,
      });

      final List<dynamic> data = response.data['data'];
      return data.map((json) => ServiceProvider.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch service providers: $e');
    }
  }

  /// Get service provider by ID
  Future<ServiceProvider> getServiceProvider(String providerId) async {
    try {
      final response = await _dio.get('/admin/service-providers/$providerId');
      return ServiceProvider.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch service provider: $e');
    }
  }

  /// Get verification requests
  Future<List<VerificationRequest>> getVerificationRequests({
    int page = 1,
    int limit = 50,
    VerificationStatus? status,
    ServiceProviderType? providerType,
    String? assignedTo,
    int? priority,
  }) async {
    try {
      final response = await _dio.get('/admin/verification-requests', queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status.name,
        if (providerType != null) 'provider_type': providerType.name,
        if (assignedTo != null) 'assigned_to': assignedTo,
        if (priority != null) 'priority': priority,
      });

      final List<dynamic> data = response.data['data'];
      return data.map((json) => VerificationRequest.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch verification requests: $e');
    }
  }

  /// Approve service provider verification
  Future<ServiceProvider> approveVerification(
    String providerId,
    String reviewNotes,
  ) async {
    try {
      final response = await _dio.patch(
        '/admin/service-providers/$providerId/approve',
        data: {'review_notes': reviewNotes},
      );
      return ServiceProvider.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to approve verification: $e');
    }
  }

  /// Reject service provider verification
  Future<ServiceProvider> rejectVerification(
    String providerId,
    String rejectionReason,
    List<String> requiredActions,
  ) async {
    try {
      final response = await _dio.patch(
        '/admin/service-providers/$providerId/reject',
        data: {
          'rejection_reason': rejectionReason,
          'required_actions': requiredActions,
        },
      );
      return ServiceProvider.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to reject verification: $e');
    }
  }

  /// Suspend service provider
  Future<ServiceProvider> suspendServiceProvider(
    String providerId,
    String suspensionReason,
  ) async {
    try {
      final response = await _dio.patch(
        '/admin/service-providers/$providerId/suspend',
        data: {'suspension_reason': suspensionReason},
      );
      return ServiceProvider.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to suspend service provider: $e');
    }
  }

  /// Reactivate service provider
  Future<ServiceProvider> reactivateServiceProvider(String providerId) async {
    try {
      final response = await _dio.patch(
        '/admin/service-providers/$providerId/reactivate',
      );
      return ServiceProvider.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to reactivate service provider: $e');
    }
  }

  /// Update service provider profile
  Future<ServiceProvider> updateServiceProvider(
    String providerId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _dio.patch(
        '/admin/service-providers/$providerId',
        data: updates,
      );
      return ServiceProvider.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update service provider: $e');
    }
  }

  /// Get service provider analytics
  Future<ServiceProviderAnalytics> getServiceProviderAnalytics(
    String providerId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final response = await _dio.get(
        '/admin/service-providers/$providerId/analytics',
        queryParameters: {
          if (startDate != null) 'start_date': startDate.toIso8601String(),
          if (endDate != null) 'end_date': endDate.toIso8601String(),
        },
      );
      return ServiceProviderAnalytics.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch service provider analytics: $e');
    }
  }

  /// Get performance metrics
  Future<PerformanceMetrics> getPerformanceMetrics(String providerId) async {
    try {
      final response = await _dio.get(
        '/admin/service-providers/$providerId/performance',
      );
      return PerformanceMetrics.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch performance metrics: $e');
    }
  }

  /// Assign verification request
  Future<VerificationRequest> assignVerificationRequest(
    String requestId,
    String assignedTo,
  ) async {
    try {
      final response = await _dio.patch(
        '/admin/verification-requests/$requestId/assign',
        data: {'assigned_to': assignedTo},
      );
      return VerificationRequest.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to assign verification request: $e');
    }
  }

  /// Update verification request priority
  Future<VerificationRequest> updateVerificationPriority(
    String requestId,
    int priority,
  ) async {
    try {
      final response = await _dio.patch(
        '/admin/verification-requests/$requestId/priority',
        data: {'priority': priority},
      );
      return VerificationRequest.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update verification priority: $e');
    }
  }

  /// Get verification documents
  Future<List<VerificationDocument>> getVerificationDocuments(
    String providerId,
  ) async {
    try {
      final response = await _dio.get(
        '/admin/service-providers/$providerId/documents',
      );
      final List<dynamic> data = response.data['data'];
      return data.map((json) => VerificationDocument.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch verification documents: $e');
    }
  }

  /// Verify document
  Future<VerificationDocument> verifyDocument(
    String documentId,
    bool isApproved,
    String notes,
  ) async {
    try {
      final response = await _dio.patch(
        '/admin/documents/$documentId/verify',
        data: {
          'is_approved': isApproved,
          'notes': notes,
        },
      );
      return VerificationDocument.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to verify document: $e');
    }
  }

  /// Get service provider statistics
  Future<Map<String, dynamic>> getServiceProviderStatistics() async {
    try {
      final response = await _dio.get('/admin/service-providers/statistics');
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch service provider statistics: $e');
    }
  }

  /// Export service provider data
  Future<String> exportServiceProviderData({
    String format = 'csv',
    List<String>? providerIds,
    ServiceProviderType? type,
    VerificationStatus? status,
  }) async {
    try {
      final response = await _dio.get('/admin/service-providers/export', queryParameters: {
        'format': format,
        if (providerIds != null) 'provider_ids': providerIds.join(','),
        if (type != null) 'type': type.name,
        if (status != null) 'status': status.name,
      });
      return response.data['download_url'];
    } catch (e) {
      throw Exception('Failed to export service provider data: $e');
    }
  }

  /// Bulk update service providers
  Future<void> bulkUpdateServiceProviders(
    List<String> providerIds,
    Map<String, dynamic> updates,
  ) async {
    try {
      await _dio.patch('/admin/service-providers/bulk', data: {
        'provider_ids': providerIds,
        'updates': updates,
      });
    } catch (e) {
      throw Exception('Failed to bulk update service providers: $e');
    }
  }

  /// Send notification to service provider
  Future<void> sendNotification(
    String providerId,
    String title,
    String message,
    String type,
  ) async {
    try {
      await _dio.post('/admin/service-providers/$providerId/notify', data: {
        'title': title,
        'message': message,
        'type': type,
      });
    } catch (e) {
      throw Exception('Failed to send notification: $e');
    }
  }

  /// Get service provider reviews
  Future<List<Map<String, dynamic>>> getServiceProviderReviews(
    String providerId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/admin/service-providers/$providerId/reviews',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      return List<Map<String, dynamic>>.from(response.data['data']);
    } catch (e) {
      throw Exception('Failed to fetch service provider reviews: $e');
    }
  }

  /// Get service provider bookings
  Future<List<Map<String, dynamic>>> getServiceProviderBookings(
    String providerId, {
    int page = 1,
    int limit = 20,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final response = await _dio.get(
        '/admin/service-providers/$providerId/bookings',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (status != null) 'status': status,
          if (startDate != null) 'start_date': startDate.toIso8601String(),
          if (endDate != null) 'end_date': endDate.toIso8601String(),
        },
      );
      return List<Map<String, dynamic>>.from(response.data['data']);
    } catch (e) {
      throw Exception('Failed to fetch service provider bookings: $e');
    }
  }
}

// Provider
final serviceProviderServiceProvider = Provider<ServiceProviderService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ServiceProviderService(apiService.dio);
});
