import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

/// User management service for admin operations
class UserManagementService {
  final Dio _dio;

  UserManagementService(this._dio);

  /// Get all users with filtering and pagination
  Future<Map<String, dynamic>> getAllUsers({
    int page = 1,
    int limit = 50,
    Map<String, dynamic>? filters,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        ...?filters,
      };

      final response = await _dio.get(
        '/admin/users',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  /// Get user by ID
  Future<Map<String, dynamic>> getUserById(String userId) async {
    try {
      final response = await _dio.get('/admin/users/$userId');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }

  /// Create a new user
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post('/admin/users', data: userData);
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  /// Update user
  Future<Map<String, dynamic>> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      final response = await _dio.patch('/admin/users/$userId', data: updates);
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  /// Delete user
  Future<void> deleteUser(String userId) async {
    try {
      await _dio.delete('/admin/users/$userId');
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  /// Activate user
  Future<void> activateUser(String userId) async {
    try {
      await _dio.patch('/admin/users/$userId/activate');
    } catch (e) {
      throw Exception('Failed to activate user: $e');
    }
  }

  /// Deactivate user
  Future<void> deactivateUser(String userId) async {
    try {
      await _dio.patch('/admin/users/$userId/deactivate');
    } catch (e) {
      throw Exception('Failed to deactivate user: $e');
    }
  }

  /// Reset user password
  Future<void> resetUserPassword(String userId) async {
    try {
      await _dio.post('/admin/users/$userId/reset-password');
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }

  /// Get admin users
  Future<Map<String, dynamic>> getAdminUsers() async {
    try {
      final response = await _dio.get('/admin/admin-users');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch admin users: $e');
    }
  }

  /// Create admin user
  Future<Map<String, dynamic>> createAdminUser(Map<String, dynamic> adminUserData) async {
    try {
      final response = await _dio.post('/admin/admin-users', data: adminUserData);
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to create admin user: $e');
    }
  }

  /// Update admin user
  Future<Map<String, dynamic>> updateAdminUser(String userId, Map<String, dynamic> updates) async {
    try {
      final response = await _dio.patch('/admin/admin-users/$userId', data: updates);
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to update admin user: $e');
    }
  }

  /// Delete admin user
  Future<void> deleteAdminUser(String userId) async {
    try {
      await _dio.delete('/admin/admin-users/$userId');
    } catch (e) {
      throw Exception('Failed to delete admin user: $e');
    }
  }

  /// Get user statistics
  Future<Map<String, dynamic>> getUserStatistics() async {
    try {
      final response = await _dio.get('/admin/users/statistics');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch user statistics: $e');
    }
  }

  /// Get user permissions
  Future<Map<String, dynamic>> getUserPermissions(String userId) async {
    try {
      final response = await _dio.get('/admin/users/$userId/permissions');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch user permissions: $e');
    }
  }

  /// Update user permissions
  Future<void> updateUserPermissions(String userId, List<String> permissions) async {
    try {
      await _dio.put('/admin/users/$userId/permissions', data: {
        'permissions': permissions,
      });
    } catch (e) {
      throw Exception('Failed to update user permissions: $e');
    }
  }

  /// Get user roles
  Future<Map<String, dynamic>> getUserRoles(String userId) async {
    try {
      final response = await _dio.get('/admin/users/$userId/roles');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch user roles: $e');
    }
  }

  /// Update user role
  Future<void> updateUserRole(String userId, String roleId) async {
    try {
      await _dio.patch('/admin/users/$userId/role', data: {
        'role_id': roleId,
      });
    } catch (e) {
      throw Exception('Failed to update user role: $e');
    }
  }

  /// Get available roles
  Future<Map<String, dynamic>> getAvailableRoles() async {
    try {
      final response = await _dio.get('/admin/roles');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch available roles: $e');
    }
  }

  /// Create role
  Future<Map<String, dynamic>> createRole({
    required String name,
    required String description,
    required List<String> permissions,
  }) async {
    try {
      final response = await _dio.post('/admin/roles', data: {
        'name': name,
        'description': description,
        'permissions': permissions,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to create role: $e');
    }
  }

  /// Update role
  Future<Map<String, dynamic>> updateRole(String roleId, Map<String, dynamic> updates) async {
    try {
      final response = await _dio.patch('/admin/roles/$roleId', data: updates);
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to update role: $e');
    }
  }

  /// Delete role
  Future<void> deleteRole(String roleId) async {
    try {
      await _dio.delete('/admin/roles/$roleId');
    } catch (e) {
      throw Exception('Failed to delete role: $e');
    }
  }

  /// Get access requests
  Future<Map<String, dynamic>> getAccessRequests({String? status}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;

      final response = await _dio.get(
        '/admin/access-requests',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch access requests: $e');
    }
  }

  /// Create access request
  Future<Map<String, dynamic>> createAccessRequest({
    required String userId,
    required String requestType,
    required String requestedRole,
    required List<String> requestedPermissions,
    required String justification,
  }) async {
    try {
      final response = await _dio.post('/admin/access-requests', data: {
        'user_id': userId,
        'request_type': requestType,
        'requested_role': requestedRole,
        'requested_permissions': requestedPermissions,
        'justification': justification,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to create access request: $e');
    }
  }

  /// Approve access request
  Future<void> approveAccessRequest(String requestId, {String? notes}) async {
    try {
      await _dio.patch('/admin/access-requests/$requestId/approve', data: {
        if (notes != null) 'notes': notes,
      });
    } catch (e) {
      throw Exception('Failed to approve access request: $e');
    }
  }

  /// Reject access request
  Future<void> rejectAccessRequest(String requestId, String reason) async {
    try {
      await _dio.patch('/admin/access-requests/$requestId/reject', data: {
        'reason': reason,
      });
    } catch (e) {
      throw Exception('Failed to reject access request: $e');
    }
  }

  /// Get audit trail
  Future<Map<String, dynamic>> getAuditTrail({
    String? userId,
    String? action,
    String? resource,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (userId != null) queryParams['user_id'] = userId;
      if (action != null) queryParams['action'] = action;
      if (resource != null) queryParams['resource'] = resource;
      if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
      if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();
      if (limit != null) queryParams['limit'] = limit;

      final response = await _dio.get(
        '/admin/audit-trail',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch audit trail: $e');
    }
  }

  /// Bulk user operations
  Future<Map<String, dynamic>> bulkUserOperation({
    required List<String> userIds,
    required String operation,
    Map<String, dynamic>? operationData,
  }) async {
    try {
      final response = await _dio.post('/admin/users/bulk-operation', data: {
        'user_ids': userIds,
        'operation': operation,
        if (operationData != null) 'operation_data': operationData,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to perform bulk operation: $e');
    }
  }

  /// Export users
  Future<String> exportUsers({
    Map<String, dynamic>? filters,
    String? format,
  }) async {
    try {
      final response = await _dio.post('/admin/users/export', data: {
        if (filters != null) 'filters': filters,
        if (format != null) 'format': format,
      });
      return response.data['data']['download_url'] as String;
    } catch (e) {
      throw Exception('Failed to export users: $e');
    }
  }

  /// Get user activity logs
  Future<Map<String, dynamic>> getUserActivityLogs(String userId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
      if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();
      if (limit != null) queryParams['limit'] = limit;

      final response = await _dio.get(
        '/admin/users/$userId/activity-logs',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch user activity logs: $e');
    }
  }

  /// Get user sessions
  Future<Map<String, dynamic>> getUserSessions(String userId) async {
    try {
      final response = await _dio.get('/admin/users/$userId/sessions');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch user sessions: $e');
    }
  }

  /// Terminate user session
  Future<void> terminateUserSession(String userId, String sessionId) async {
    try {
      await _dio.delete('/admin/users/$userId/sessions/$sessionId');
    } catch (e) {
      throw Exception('Failed to terminate user session: $e');
    }
  }

  /// Send notification to users
  Future<void> sendNotificationToUsers({
    required List<String> userIds,
    required String title,
    required String message,
    String? type,
  }) async {
    try {
      await _dio.post('/admin/users/send-notification', data: {
        'user_ids': userIds,
        'title': title,
        'message': message,
        if (type != null) 'type': type,
      });
    } catch (e) {
      throw Exception('Failed to send notification: $e');
    }
  }

  /// Generate compliance report
  Future<String> generateComplianceReport({
    required String reportType,
    DateTime? startDate,
    DateTime? endDate,
    String? format,
  }) async {
    try {
      final response = await _dio.post('/admin/compliance/generate-report', data: {
        'report_type': reportType,
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
        if (format != null) 'format': format,
      });
      return response.data['data']['download_url'] as String;
    } catch (e) {
      throw Exception('Failed to generate compliance report: $e');
    }
  }
}

/// User management service provider
final userManagementServiceProvider = Provider<UserManagementService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return UserManagementService(apiService.dio);
});
