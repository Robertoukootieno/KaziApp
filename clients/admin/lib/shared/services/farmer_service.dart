import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/farmer.dart';
import 'api_service.dart';

/// Farmer search filters
class FarmerSearchFilters {
  final String? search;
  final FarmerVerificationStatus? verificationStatus;
  final FarmType? farmType;
  final ExperienceLevel? experienceLevel;
  final String? county;
  final bool? isActive;
  final bool? isVerified;
  final double? minFarmSize;
  final double? maxFarmSize;
  final DateTime? joinedAfter;
  final DateTime? joinedBefore;
  final String? sortBy;
  final String? sortOrder;

  const FarmerSearchFilters({
    this.search,
    this.verificationStatus,
    this.farmType,
    this.experienceLevel,
    this.county,
    this.isActive,
    this.isVerified,
    this.minFarmSize,
    this.maxFarmSize,
    this.joinedAfter,
    this.joinedBefore,
    this.sortBy,
    this.sortOrder,
  });

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};
    
    if (search != null && search!.isNotEmpty) params['search'] = search;
    if (verificationStatus != null) params['verification_status'] = verificationStatus!.name;
    if (farmType != null) params['farm_type'] = farmType!.name;
    if (experienceLevel != null) params['experience_level'] = experienceLevel!.name;
    if (county != null) params['county'] = county;
    if (isActive != null) params['is_active'] = isActive;
    if (isVerified != null) params['is_verified'] = isVerified;
    if (minFarmSize != null) params['min_farm_size'] = minFarmSize;
    if (maxFarmSize != null) params['max_farm_size'] = maxFarmSize;
    if (joinedAfter != null) params['joined_after'] = joinedAfter!.toIso8601String();
    if (joinedBefore != null) params['joined_before'] = joinedBefore!.toIso8601String();
    if (sortBy != null) params['sort_by'] = sortBy;
    if (sortOrder != null) params['sort_order'] = sortOrder;
    
    return params;
  }
}

/// Farmer bulk operation
class FarmerBulkOperation {
  final String operation;
  final List<String> farmerIds;
  final Map<String, dynamic>? data;

  const FarmerBulkOperation({
    required this.operation,
    required this.farmerIds,
    this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'operation': operation,
      'farmer_ids': farmerIds,
      if (data != null) 'data': data,
    };
  }
}

/// Farmer statistics
class FarmerStatistics {
  final int totalFarmers;
  final int verifiedFarmers;
  final int pendingVerification;
  final int activeFarmers;
  final int suspendedFarmers;
  final double averageFarmSize;
  final Map<String, int> farmersByCounty;
  final Map<String, int> farmersByFarmType;
  final Map<String, int> farmersByExperience;
  final Map<String, double> performanceMetrics;

  const FarmerStatistics({
    required this.totalFarmers,
    required this.verifiedFarmers,
    required this.pendingVerification,
    required this.activeFarmers,
    required this.suspendedFarmers,
    required this.averageFarmSize,
    required this.farmersByCounty,
    required this.farmersByFarmType,
    required this.farmersByExperience,
    required this.performanceMetrics,
  });

  factory FarmerStatistics.fromJson(Map<String, dynamic> json) {
    return FarmerStatistics(
      totalFarmers: json['total_farmers'] as int,
      verifiedFarmers: json['verified_farmers'] as int,
      pendingVerification: json['pending_verification'] as int,
      activeFarmers: json['active_farmers'] as int,
      suspendedFarmers: json['suspended_farmers'] as int,
      averageFarmSize: (json['average_farm_size'] as num).toDouble(),
      farmersByCounty: Map<String, int>.from(json['farmers_by_county'] as Map),
      farmersByFarmType: Map<String, int>.from(json['farmers_by_farm_type'] as Map),
      farmersByExperience: Map<String, int>.from(json['farmers_by_experience'] as Map),
      performanceMetrics: Map<String, double>.from(
        (json['performance_metrics'] as Map).map(
          (key, value) => MapEntry(key as String, (value as num).toDouble()),
        ),
      ),
    );
  }
}

/// Farmer service for admin operations
class FarmerService {
  final Dio _dio;

  FarmerService(this._dio);

  /// Get all farmers with pagination and filters
  Future<Map<String, dynamic>> getAllFarmers({
    int page = 1,
    int limit = 50,
    FarmerSearchFilters? filters,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
        ...?filters?.toQueryParameters(),
      };

      final response = await _dio.get('/admin/farmers', queryParameters: queryParams);
      
      return {
        'farmers': (response.data['data']['farmers'] as List)
            .map((json) => Farmer.fromJson(json))
            .toList(),
        'total': response.data['data']['total'] as int,
        'page': response.data['data']['page'] as int,
        'totalPages': response.data['data']['total_pages'] as int,
      };
    } catch (e) {
      throw Exception('Failed to fetch farmers: $e');
    }
  }

  /// Get farmer by ID
  Future<Farmer> getFarmerById(String farmerId) async {
    try {
      final response = await _dio.get('/admin/farmers/$farmerId');
      return Farmer.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to fetch farmer: $e');
    }
  }

  /// Update farmer profile
  Future<Farmer> updateFarmer(String farmerId, Map<String, dynamic> updates) async {
    try {
      final response = await _dio.patch('/admin/farmers/$farmerId', data: updates);
      return Farmer.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to update farmer: $e');
    }
  }

  /// Verify farmer
  Future<Farmer> verifyFarmer(String farmerId, {String? notes}) async {
    try {
      final response = await _dio.post('/admin/farmers/$farmerId/verify', data: {
        if (notes != null) 'notes': notes,
      });
      return Farmer.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to verify farmer: $e');
    }
  }

  /// Reject farmer verification
  Future<Farmer> rejectFarmerVerification(String farmerId, String reason) async {
    try {
      final response = await _dio.post('/admin/farmers/$farmerId/reject', data: {
        'reason': reason,
      });
      return Farmer.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to reject farmer verification: $e');
    }
  }

  /// Suspend farmer
  Future<Farmer> suspendFarmer(String farmerId, String reason) async {
    try {
      final response = await _dio.post('/admin/farmers/$farmerId/suspend', data: {
        'reason': reason,
      });
      return Farmer.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to suspend farmer: $e');
    }
  }

  /// Reactivate farmer
  Future<Farmer> reactivateFarmer(String farmerId) async {
    try {
      final response = await _dio.post('/admin/farmers/$farmerId/reactivate');
      return Farmer.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to reactivate farmer: $e');
    }
  }

  /// Delete farmer (soft delete)
  Future<void> deleteFarmer(String farmerId, String reason) async {
    try {
      await _dio.delete('/admin/farmers/$farmerId', data: {
        'reason': reason,
      });
    } catch (e) {
      throw Exception('Failed to delete farmer: $e');
    }
  }

  /// Bulk operations on farmers
  Future<Map<String, dynamic>> bulkOperation(FarmerBulkOperation operation) async {
    try {
      final response = await _dio.post('/admin/farmers/bulk', data: operation.toJson());
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to perform bulk operation: $e');
    }
  }

  /// Get farmer statistics
  Future<FarmerStatistics> getFarmerStatistics() async {
    try {
      final response = await _dio.get('/admin/farmers/statistics');
      return FarmerStatistics.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to fetch farmer statistics: $e');
    }
  }

  /// Get farmer performance analytics
  Future<Map<String, dynamic>> getFarmerPerformanceAnalytics({
    String? farmerId,
    DateTime? startDate,
    DateTime? endDate,
    String? groupBy,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (farmerId != null) queryParams['farmer_id'] = farmerId;
      if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
      if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();
      if (groupBy != null) queryParams['group_by'] = groupBy;

      final response = await _dio.get('/admin/farmers/analytics', queryParameters: queryParams);
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch farmer analytics: $e');
    }
  }

  /// Export farmers data
  Future<String> exportFarmers({
    String format = 'csv',
    FarmerSearchFilters? filters,
  }) async {
    try {
      final queryParams = {
        'format': format,
        ...?filters?.toQueryParameters(),
      };

      final response = await _dio.get('/admin/farmers/export', queryParameters: queryParams);
      return response.data['data']['download_url'] as String;
    } catch (e) {
      throw Exception('Failed to export farmers: $e');
    }
  }

  /// Get farmer verification queue
  Future<List<Farmer>> getVerificationQueue({
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _dio.get('/admin/farmers/verification-queue', queryParameters: {
        'page': page,
        'limit': limit,
      });
      
      return (response.data['data']['farmers'] as List)
          .map((json) => Farmer.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch verification queue: $e');
    }
  }

  /// Get farmer activity logs
  Future<List<Map<String, dynamic>>> getFarmerActivityLogs(String farmerId, {
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _dio.get('/admin/farmers/$farmerId/activity-logs', queryParameters: {
        'page': page,
        'limit': limit,
      });
      
      return List<Map<String, dynamic>>.from(response.data['data']['logs']);
    } catch (e) {
      throw Exception('Failed to fetch farmer activity logs: $e');
    }
  }

  /// Send notification to farmer
  Future<void> sendNotificationToFarmer(String farmerId, {
    required String title,
    required String message,
    String? type,
    Map<String, dynamic>? data,
  }) async {
    try {
      await _dio.post('/admin/farmers/$farmerId/notify', data: {
        'title': title,
        'message': message,
        if (type != null) 'type': type,
        if (data != null) 'data': data,
      });
    } catch (e) {
      throw Exception('Failed to send notification: $e');
    }
  }

  /// Send bulk notification to farmers
  Future<void> sendBulkNotification({
    required List<String> farmerIds,
    required String title,
    required String message,
    String? type,
    Map<String, dynamic>? data,
  }) async {
    try {
      await _dio.post('/admin/farmers/bulk-notify', data: {
        'farmer_ids': farmerIds,
        'title': title,
        'message': message,
        if (type != null) 'type': type,
        if (data != null) 'data': data,
      });
    } catch (e) {
      throw Exception('Failed to send bulk notification: $e');
    }
  }
}

/// Farmer service provider
final farmerServiceProvider = Provider<FarmerService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return FarmerService(apiService.dio);
});
