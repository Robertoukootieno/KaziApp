import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/access_control.dart';

class AccessControlService {
  final Dio _dio;
  
  AccessControlService(this._dio);

  /// Get all user access records
  Future<List<UserAccess>> getAllUserAccess({
    int page = 1,
    int limit = 50,
    String? search,
    UserRole? role,
    AppPlatform? platform,
    bool? isActive,
  }) async {
    try {
      final response = await _dio.get('/admin/access/users', queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null) 'search': search,
        if (role != null) 'role': role.name,
        if (platform != null) 'platform': platform.name,
        if (isActive != null) 'is_active': isActive,
      });

      final List<dynamic> data = response.data['data'];
      return data.map((json) => UserAccess.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch user access records: $e');
    }
  }

  /// Get user access by ID
  Future<UserAccess> getUserAccess(String userId) async {
    try {
      final response = await _dio.get('/admin/access/users/$userId');
      return UserAccess.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch user access: $e');
    }
  }

  /// Create new user access
  Future<UserAccess> createUserAccess(UserAccess userAccess) async {
    try {
      final response = await _dio.post(
        '/admin/access/users',
        data: userAccess.toJson(),
      );
      return UserAccess.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create user access: $e');
    }
  }

  /// Update user access
  Future<UserAccess> updateUserAccess(String userId, UserAccess userAccess) async {
    try {
      final response = await _dio.put(
        '/admin/access/users/$userId',
        data: userAccess.toJson(),
      );
      return UserAccess.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update user access: $e');
    }
  }

  /// Lock/unlock user
  Future<void> toggleUserLock(String userId, bool isLocked, String? reason) async {
    try {
      await _dio.patch('/admin/access/users/$userId/lock', data: {
        'is_locked': isLocked,
        'reason': reason,
      });
    } catch (e) {
      throw Exception('Failed to toggle user lock: $e');
    }
  }

  /// Reset user password
  Future<void> resetUserPassword(String userId, bool requireReset) async {
    try {
      await _dio.patch('/admin/access/users/$userId/password-reset', data: {
        'require_reset': requireReset,
      });
    } catch (e) {
      throw Exception('Failed to reset user password: $e');
    }
  }

  /// Get all access requests
  Future<List<AccessRequest>> getAccessRequests({
    int page = 1,
    int limit = 50,
    AccessRequestStatus? status,
    AccessRequestType? type,
  }) async {
    try {
      final response = await _dio.get('/admin/access/requests', queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status.name,
        if (type != null) 'type': type.name,
      });

      final List<dynamic> data = response.data['data'];
      return data.map((json) => AccessRequest.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch access requests: $e');
    }
  }

  /// Create access request
  Future<AccessRequest> createAccessRequest(AccessRequest request) async {
    try {
      final response = await _dio.post(
        '/admin/access/requests',
        data: request.toJson(),
      );
      return AccessRequest.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create access request: $e');
    }
  }

  /// Approve access request
  Future<AccessRequest> approveAccessRequest(
    String requestId,
    String approverComments,
  ) async {
    try {
      final response = await _dio.patch(
        '/admin/access/requests/$requestId/approve',
        data: {'comments': approverComments},
      );
      return AccessRequest.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to approve access request: $e');
    }
  }

  /// Reject access request
  Future<AccessRequest> rejectAccessRequest(
    String requestId,
    String rejectionReason,
  ) async {
    try {
      final response = await _dio.patch(
        '/admin/access/requests/$requestId/reject',
        data: {'reason': rejectionReason},
      );
      return AccessRequest.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to reject access request: $e');
    }
  }

  /// Get audit logs
  Future<List<AccessAuditLog>> getAuditLogs({
    int page = 1,
    int limit = 50,
    String? userId,
    String? action,
    AppPlatform? platform,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final response = await _dio.get('/admin/access/audit-logs', queryParameters: {
        'page': page,
        'limit': limit,
        if (userId != null) 'user_id': userId,
        if (action != null) 'action': action,
        if (platform != null) 'platform': platform.name,
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
      });

      final List<dynamic> data = response.data['data'];
      return data.map((json) => AccessAuditLog.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch audit logs: $e');
    }
  }

  /// Get access control configuration
  Future<AccessControlConfig> getAccessControlConfig() async {
    try {
      final response = await _dio.get('/admin/access/config');
      return AccessControlConfig.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch access control config: $e');
    }
  }

  /// Update access control configuration
  Future<AccessControlConfig> updateAccessControlConfig(
    AccessControlConfig config,
  ) async {
    try {
      final response = await _dio.put(
        '/admin/access/config',
        data: config.toJson(),
      );
      return AccessControlConfig.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update access control config: $e');
    }
  }

  /// Get role permissions
  Future<List<RolePermission>> getRolePermissions() async {
    try {
      final response = await _dio.get('/admin/access/role-permissions');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => RolePermission.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch role permissions: $e');
    }
  }

  /// Update role permissions
  Future<RolePermission> updateRolePermissions(RolePermission rolePermission) async {
    try {
      final response = await _dio.put(
        '/admin/access/role-permissions/${rolePermission.role.name}',
        data: rolePermission.toJson(),
      );
      return RolePermission.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update role permissions: $e');
    }
  }

  /// Get available permissions
  Future<List<Permission>> getAvailablePermissions() async {
    try {
      final response = await _dio.get('/admin/access/permissions');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Permission.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch available permissions: $e');
    }
  }

  /// Bulk update user access
  Future<void> bulkUpdateUserAccess(
    List<String> userIds,
    Map<String, dynamic> updates,
  ) async {
    try {
      await _dio.patch('/admin/access/users/bulk', data: {
        'user_ids': userIds,
        'updates': updates,
      });
    } catch (e) {
      throw Exception('Failed to bulk update user access: $e');
    }
  }

  /// Export user access data
  Future<String> exportUserAccessData({
    String format = 'csv',
    List<String>? userIds,
    UserRole? role,
    AppPlatform? platform,
  }) async {
    try {
      final response = await _dio.get('/admin/access/export', queryParameters: {
        'format': format,
        if (userIds != null) 'user_ids': userIds.join(','),
        if (role != null) 'role': role.name,
        if (platform != null) 'platform': platform.name,
      });
      return response.data['download_url'];
    } catch (e) {
      throw Exception('Failed to export user access data: $e');
    }
  }
}

// Providers
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.kaziapp.com', // Replace with actual API URL
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  // Add interceptors for authentication, logging, etc.
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      // Add authentication token
      // options.headers['Authorization'] = 'Bearer $token';
      handler.next(options);
    },
    onError: (error, handler) {
      // Handle errors globally
      handler.next(error);
    },
  ));

  return dio;
});

final accessControlServiceProvider = Provider<AccessControlService>((ref) {
  final dio = ref.watch(dioProvider);
  return AccessControlService(dio);
});
