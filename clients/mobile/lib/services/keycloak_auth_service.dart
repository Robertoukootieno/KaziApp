import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:openid_client/openid_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class KeycloakAuthService {
  static const String _accessTokenKey = 'keycloak_access_token';
  static const String _refreshTokenKey = 'keycloak_refresh_token';
  static const String _idTokenKey = 'keycloak_id_token';
  static const String _userDataKey = 'keycloak_user_data';
  static const String _configKey = 'keycloak_config';

  // Keycloak configuration
  static const String keycloakBaseUrl = 'http://localhost:8080';
  static const String realm = 'kaziapp';
  static const String clientId = 'kaziapp-farmer-mobile';
  static const String redirectUri = 'kaziapp://auth/callback';
  
  // Integration service
  static const String integrationServiceUrl = 'http://localhost:3150';

  final Dio _dio = Dio();
  Client? _client;
  Issuer? _issuer;
  
  // Singleton pattern
  static final KeycloakAuthService _instance = KeycloakAuthService._internal();
  factory KeycloakAuthService() => _instance;
  KeycloakAuthService._internal() {
    _setupDio();
  }

  void _setupDio() {
    _dio.options.baseUrl = integrationServiceUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    
    // Add interceptor for token refresh
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Try to refresh token
          final refreshed = await _refreshTokenSilently();
          if (refreshed) {
            // Retry the request
            final token = await getAccessToken();
            if (token != null) {
              error.requestOptions.headers['Authorization'] = 'Bearer $token';
              final response = await _dio.fetch(error.requestOptions);
              handler.resolve(response);
              return;
            }
          }
        }
        handler.next(error);
      },
    ));
  }

  /// Initialize Keycloak client
  Future<void> initialize() async {
    try {
      final issuerUri = Uri.parse('$keycloakBaseUrl/realms/$realm');
      _issuer = await Issuer.discover(issuerUri);
      _client = Client(_issuer!, clientId);
      
      debugPrint('Keycloak client initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize Keycloak client: $e');
      throw Exception('Failed to initialize authentication service');
    }
  }

  /// Login with username and password
  Future<AuthResult> login(String username, String password, {String clientType = 'farmer'}) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'username': username,
        'password': password,
        'clientType': clientType,
        'rememberMe': true,
      });

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        final tokens = data['tokens'];
        final user = data['user'];

        // Store tokens and user data
        await _storeAuthData(tokens, user);

        return AuthResult.success(UserProfile.fromJson(user));
      } else {
        return AuthResult.error(response.data['error'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return AuthResult.error('Invalid credentials');
      }
      return AuthResult.error('Network error: ${e.message}');
    } catch (e) {
      return AuthResult.error('Login failed: $e');
    }
  }

  /// Register new user
  Future<AuthResult> register(UserRegistration registration) async {
    try {
      final response = await _dio.post('/auth/register', data: registration.toJson());

      if (response.statusCode == 201 && response.data['success'] == true) {
        final data = response.data['data'];
        final user = data['user'];

        return AuthResult.success(
          UserProfile.fromJson(user),
          requiresVerification: data['requiresVerification'] ?? false,
        );
      } else {
        return AuthResult.error(response.data['error'] ?? 'Registration failed');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final error = e.response?.data['error'] ?? 'Registration failed';
        return AuthResult.error(error);
      }
      return AuthResult.error('Network error: ${e.message}');
    } catch (e) {
      return AuthResult.error('Registration failed: $e');
    }
  }

  /// Refresh access token
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _dio.post('/auth/refresh', data: {
        'refreshToken': refreshToken,
        'clientType': 'farmer', // TODO: Get from stored user data
      });

      if (response.statusCode == 200 && response.data['success'] == true) {
        final tokens = response.data['data']['tokens'];
        await _updateTokens(tokens);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Token refresh failed: $e');
      return false;
    }
  }

  /// Silent token refresh (internal use)
  Future<bool> _refreshTokenSilently() async {
    try {
      return await refreshToken();
    } catch (e) {
      debugPrint('Silent token refresh failed: $e');
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      final token = await getAccessToken();
      if (token != null) {
        await _dio.post('/auth/logout', options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ));
      }
    } catch (e) {
      debugPrint('Logout API call failed: $e');
    } finally {
      await _clearAuthData();
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    if (token == null) return false;

    // Check if token is expired
    if (JwtDecoder.isExpired(token)) {
      // Try to refresh token
      final refreshed = await refreshToken();
      return refreshed;
    }

    return true;
  }

  /// Get current user profile
  Future<UserProfile?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(_userDataKey);
      
      if (userDataString != null) {
        final userData = jsonDecode(userDataString);
        return UserProfile.fromJson(userData);
      }
      return null;
    } catch (e) {
      debugPrint('Failed to get current user: $e');
      return null;
    }
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  /// Get ID token
  Future<String?> getIdToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_idTokenKey);
  }

  /// Verify token with server
  Future<bool> verifyToken() async {
    try {
      final token = await getAccessToken();
      if (token == null) return false;

      final response = await _dio.post('/auth/verify-token', data: {
        'token': token,
      });

      return response.statusCode == 200 && response.data['valid'] == true;
    } catch (e) {
      debugPrint('Token verification failed: $e');
      return false;
    }
  }

  /// Forgot password
  Future<bool> forgotPassword(String username) async {
    try {
      final response = await _dio.post('/auth/forgot-password', data: {
        'username': username,
      });

      return response.statusCode == 200 && response.data['success'] == true;
    } catch (e) {
      debugPrint('Forgot password failed: $e');
      return false;
    }
  }

  /// Verify email with token
  Future<AuthResult> verifyEmail(String userId, String token) async {
    try {
      final response = await _dio.post('/auth/verify-email', data: {
        'userId': userId,
        'token': token,
      });

      if (response.statusCode == 200 && response.data['success'] == true) {
        return AuthResult.success(
          UserProfile(
            id: userId,
            username: '',
            firstName: '',
            lastName: '',
            userType: 'farmer',
            preferredLanguage: 'en',
            emailVerified: true,
            enabled: true,
            roles: [],
            groups: [],
          ),
        );
      } else {
        return AuthResult.error(response.data['error'] ?? 'Email verification failed');
      }
    } catch (e) {
      debugPrint('Email verification failed: $e');
      return AuthResult.error('Email verification failed: $e');
    }
  }

  /// Resend verification email
  Future<bool> resendVerification(String username) async {
    try {
      final response = await _dio.post('/auth/resend-verification', data: {
        'username': username,
      });

      return response.statusCode == 200 && response.data['success'] == true;
    } catch (e) {
      debugPrint('Resend verification failed: $e');
      return false;
    }
  }

  /// Check verification status
  Future<VerificationStatus?> getVerificationStatus(String username) async {
    try {
      final response = await _dio.get('/auth/verification-status/$username');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        return VerificationStatus(
          emailVerified: data['emailVerified'] ?? false,
          enabled: data['enabled'] ?? false,
        );
      }
      return null;
    } catch (e) {
      debugPrint('Get verification status failed: $e');
      return null;
    }
  }

  // Private methods
  Future<void> _storeAuthData(Map<String, dynamic> tokens, Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString(_accessTokenKey, tokens['accessToken']);
    await prefs.setString(_refreshTokenKey, tokens['refreshToken']);
    if (tokens['idToken'] != null) {
      await prefs.setString(_idTokenKey, tokens['idToken']);
    }
    await prefs.setString(_userDataKey, jsonEncode(user));
  }

  Future<void> _updateTokens(Map<String, dynamic> tokens) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString(_accessTokenKey, tokens['accessToken']);
    await prefs.setString(_refreshTokenKey, tokens['refreshToken']);
    if (tokens['idToken'] != null) {
      await prefs.setString(_idTokenKey, tokens['idToken']);
    }
  }

  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_idTokenKey);
    await prefs.remove(_userDataKey);
    await prefs.remove(_configKey);
  }
}

// Data models
class AuthResult {
  final bool success;
  final UserProfile? user;
  final String? error;
  final bool requiresVerification;

  AuthResult._({
    required this.success,
    this.user,
    this.error,
    this.requiresVerification = false,
  });

  factory AuthResult.success(UserProfile user, {bool requiresVerification = false}) {
    return AuthResult._(
      success: true,
      user: user,
      requiresVerification: requiresVerification,
    );
  }

  factory AuthResult.error(String error) {
    return AuthResult._(
      success: false,
      error: error,
    );
  }
}

class UserProfile {
  final String id;
  final String username;
  final String? email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? county;
  final String userType;
  final String preferredLanguage;
  final bool emailVerified;
  final bool enabled;
  final List<String> roles;
  final List<String> groups;

  UserProfile({
    required this.id,
    required this.username,
    this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.county,
    required this.userType,
    required this.preferredLanguage,
    required this.emailVerified,
    required this.enabled,
    required this.roles,
    required this.groups,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      county: json['county'],
      userType: json['userType'],
      preferredLanguage: json['preferredLanguage'] ?? 'en',
      emailVerified: json['emailVerified'] ?? false,
      enabled: json['enabled'] ?? true,
      roles: List<String>.from(json['roles'] ?? []),
      groups: List<String>.from(json['groups'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'county': county,
      'userType': userType,
      'preferredLanguage': preferredLanguage,
      'emailVerified': emailVerified,
      'enabled': enabled,
      'roles': roles,
      'groups': groups,
    };
  }

  String get fullName => '$firstName $lastName';
}

class UserRegistration {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? email;
  final String password;
  final String confirmPassword;
  final String? county;
  final String preferredLanguage;
  final String clientType;
  final bool acceptTerms;

  UserRegistration({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.email,
    required this.password,
    required this.confirmPassword,
    this.county,
    this.preferredLanguage = 'en',
    this.clientType = 'farmer',
    this.acceptTerms = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'county': county,
      'preferredLanguage': preferredLanguage,
      'clientType': clientType,
      'acceptTerms': acceptTerms,
    };
  }
}

class VerificationStatus {
  final bool emailVerified;
  final bool enabled;

  VerificationStatus({
    required this.emailVerified,
    required this.enabled,
  });

  factory VerificationStatus.fromJson(Map<String, dynamic> json) {
    return VerificationStatus(
      emailVerified: json['emailVerified'] ?? false,
      enabled: json['enabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emailVerified': emailVerified,
      'enabled': enabled,
    };
  }
}
