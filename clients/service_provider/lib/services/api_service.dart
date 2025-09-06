import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api.kaziapp.com/v1';
  static const Duration timeout = Duration(seconds: 30);
  
  String? _authToken;
  
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  void setAuthToken(String token) {
    _authToken = token;
  }

  void clearAuthToken() {
    _authToken = null;
  }

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    
    return headers;
  }

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final finalUri = queryParams != null 
          ? uri.replace(queryParameters: queryParams)
          : uri;

      final response = await http.get(
        finalUri,
        headers: _headers,
      ).timeout(timeout);

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(timeout);

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(timeout);

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      ).timeout(timeout);

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  Future<ApiResponse<String>> uploadFile(
    String endpoint,
    File file, {
    Map<String, String>? fields,
  }) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse('$baseUrl$endpoint'));
      
      // Add headers
      request.headers.addAll(_headers);
      
      // Add file
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      
      // Add fields
      if (fields != null) {
        request.fields.addAll(fields);
      }

      final streamedResponse = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        return ApiResponse.success(data['url'] ?? data['data'] ?? '');
      } else {
        return ApiResponse.error(_getErrorMessage(response));
      }
    } catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }

  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final data = jsonDecode(response.body);
        
        if (fromJson != null && data is Map<String, dynamic>) {
          return ApiResponse.success(fromJson(data));
        } else if (data is List && fromJson != null) {
          final items = data.map((item) => fromJson(item as Map<String, dynamic>)).toList();
          return ApiResponse.success(items as T);
        } else {
          return ApiResponse.success(data as T);
        }
      } catch (e) {
        return ApiResponse.error('Failed to parse response: $e');
      }
    } else {
      return ApiResponse.error(_getErrorMessage(response));
    }
  }

  String _getErrorMessage(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      return data['message'] ?? data['error'] ?? 'Request failed';
    } catch (e) {
      return 'Request failed with status ${response.statusCode}';
    }
  }

  String _handleError(dynamic error) {
    if (error is SocketException) {
      return 'No internet connection';
    } else if (error is HttpException) {
      return 'HTTP error: ${error.message}';
    } else if (error is FormatException) {
      return 'Invalid response format';
    } else {
      return 'An unexpected error occurred: $error';
    }
  }
}

class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  ApiResponse.success(this.data) : error = null, isSuccess = true;
  ApiResponse.error(this.error) : data = null, isSuccess = false;

  bool get isError => !isSuccess;
}

class PaginatedResponse<T> {
  final List<T> data;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginatedResponse({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return PaginatedResponse(
      data: (json['data'] as List)
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList(),
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalItems: json['totalItems'] ?? 0,
      itemsPerPage: json['itemsPerPage'] ?? 10,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
    );
  }
}

// API Endpoints
class ApiEndpoints {
  // Authentication
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // Service Provider
  static const String profile = '/provider/profile';
  static const String updateProfile = '/provider/profile';
  static const String uploadProfileImage = '/provider/profile/image';

  // Services
  static const String services = '/provider/services';
  static String service(String id) => '/provider/services/$id';
  static const String serviceCategories = '/services/categories';

  // Bookings
  static const String bookings = '/provider/bookings';
  static String booking(String id) => '/provider/bookings/$id';
  static String updateBookingStatus(String id) => '/provider/bookings/$id/status';

  // Customers
  static const String customers = '/provider/customers';
  static String customer(String id) => '/provider/customers/$id';
  static String customerInteractions(String id) => '/provider/customers/$id/interactions';

  // Inventory
  static const String inventory = '/provider/inventory';
  static String inventoryItem(String id) => '/provider/inventory/$id';
  static const String stockMovements = '/provider/inventory/movements';

  // Analytics
  static const String analytics = '/provider/analytics';
  static const String revenueAnalytics = '/provider/analytics/revenue';
  static const String bookingAnalytics = '/provider/analytics/bookings';
  static const String customerAnalytics = '/provider/analytics/customers';

  // Notifications
  static const String notifications = '/provider/notifications';
  static String markNotificationRead(String id) => '/provider/notifications/$id/read';
  static const String notificationSettings = '/provider/notifications/settings';

  // File uploads
  static const String uploadFile = '/files/upload';
  static const String uploadImage = '/images/upload';
}
