import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import 'api_service.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user_data';
  
  final ApiService _apiService = ApiService();
  ServiceProvider? _currentUser;
  
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  ServiceProvider? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final token = data['token'] as String;
        final refreshToken = data['refreshToken'] as String;
        final userData = data['user'] as Map<String, dynamic>;

        // Save tokens and user data
        await _saveAuthData(token, refreshToken, userData);
        
        // Set API token
        _apiService.setAuthToken(token);
        
        // Set current user
        _currentUser = ServiceProvider.fromJson(userData);

        return AuthResult.success(_currentUser!);
      } else {
        return AuthResult.error(response.error ?? 'Login failed');
      }
    } catch (e) {
      return AuthResult.error('Login failed: $e');
    }
  }

  Future<AuthResult> register({
    required String businessName,
    required String email,
    required String phoneNumber,
    required String password,
    required String location,
    required ServiceType serviceType,
  }) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        ApiEndpoints.register,
        body: {
          'businessName': businessName,
          'email': email,
          'phoneNumber': phoneNumber,
          'password': password,
          'location': location,
          'serviceType': serviceType.toString().split('.').last,
        },
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final token = data['token'] as String;
        final refreshToken = data['refreshToken'] as String;
        final userData = data['user'] as Map<String, dynamic>;

        // Save tokens and user data
        await _saveAuthData(token, refreshToken, userData);
        
        // Set API token
        _apiService.setAuthToken(token);
        
        // Set current user
        _currentUser = ServiceProvider.fromJson(userData);

        return AuthResult.success(_currentUser!);
      } else {
        return AuthResult.error(response.error ?? 'Registration failed');
      }
    } catch (e) {
      return AuthResult.error('Registration failed: $e');
    }
  }

  Future<bool> logout() async {
    try {
      // Call logout endpoint
      await _apiService.post(ApiEndpoints.logout);
      
      // Clear local data
      await _clearAuthData();
      
      return true;
    } catch (e) {
      // Clear local data even if API call fails
      await _clearAuthData();
      return false;
    }
  }

  Future<bool> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(_refreshTokenKey);
      
      if (refreshToken == null) return false;

      final response = await _apiService.post<Map<String, dynamic>>(
        ApiEndpoints.refreshToken,
        body: {'refreshToken': refreshToken},
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data!;
        final newToken = data['token'] as String;
        final newRefreshToken = data['refreshToken'] as String;

        // Update stored tokens
        await prefs.setString(_tokenKey, newToken);
        await prefs.setString(_refreshTokenKey, newRefreshToken);
        
        // Set new API token
        _apiService.setAuthToken(newToken);

        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.forgotPassword,
        body: {'email': email},
      );

      return response.isSuccess;
    } catch (e) {
      return false;
    }
  }

  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.resetPassword,
        body: {
          'token': token,
          'password': newPassword,
        },
      );

      return response.isSuccess;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.put(
        '/auth/change-password',
        body: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );

      return response.isSuccess;
    } catch (e) {
      return false;
    }
  }

  Future<bool> initializeAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      final userDataString = prefs.getString(_userKey);

      if (token != null && userDataString != null) {
        // Set API token
        _apiService.setAuthToken(token);
        
        // Restore user data
        final userData = jsonDecode(userDataString) as Map<String, dynamic>;
        _currentUser = ServiceProvider.fromJson(userData);

        // Try to refresh token to ensure it's still valid
        final refreshSuccess = await refreshToken();
        if (!refreshSuccess) {
          // Token refresh failed, clear auth data
          await _clearAuthData();
          return false;
        }

        return true;
      }
      
      return false;
    } catch (e) {
      await _clearAuthData();
      return false;
    }
  }

  Future<void> _saveAuthData(
    String token,
    String refreshToken,
    Map<String, dynamic> userData,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_refreshTokenKey, refreshToken);
    await prefs.setString(_userKey, jsonEncode(userData));
  }

  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userKey);
    
    _apiService.clearAuthToken();
    _currentUser = null;
  }

  Future<AuthResult> updateProfile(ServiceProvider updatedProvider) async {
    try {
      final response = await _apiService.put<Map<String, dynamic>>(
        ApiEndpoints.updateProfile,
        body: updatedProvider.toJson(),
      );

      if (response.isSuccess && response.data != null) {
        final userData = response.data!;
        _currentUser = ServiceProvider.fromJson(userData);
        
        // Update stored user data
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userKey, jsonEncode(userData));

        return AuthResult.success(_currentUser!);
      } else {
        return AuthResult.error(response.error ?? 'Profile update failed');
      }
    } catch (e) {
      return AuthResult.error('Profile update failed: $e');
    }
  }

  Future<String?> uploadProfileImage(String imagePath) async {
    try {
      final response = await _apiService.uploadFile(
        ApiEndpoints.uploadProfileImage,
        File(imagePath),
      );

      if (response.isSuccess) {
        return response.data;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
}

class AuthResult {
  final ServiceProvider? user;
  final String? error;
  final bool isSuccess;

  AuthResult.success(this.user) : error = null, isSuccess = true;
  AuthResult.error(this.error) : user = null, isSuccess = false;

  bool get isError => !isSuccess;
}
