import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../constants/app_constants.dart';
import '../../shared/models/admin_user.dart';
import '../../shared/services/api_service.dart';

/// Authentication state
enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  mfaRequired,
  locked,
  expired,
  error,
}

/// Authentication result
class AuthResult {
  final bool success;
  final String? message;
  final String? errorCode;
  final Map<String, dynamic>? data;

  const AuthResult({
    required this.success,
    this.message,
    this.errorCode,
    this.data,
  });

  factory AuthResult.success({String? message, Map<String, dynamic>? data}) {
    return AuthResult(success: true, message: message, data: data);
  }

  factory AuthResult.failure({String? message, String? errorCode}) {
    return AuthResult(success: false, message: message, errorCode: errorCode);
  }
}

/// Session information
class SessionInfo {
  final String sessionId;
  final DateTime createdAt;
  final DateTime lastActivity;
  final String ipAddress;
  final String userAgent;
  final bool isActive;

  const SessionInfo({
    required this.sessionId,
    required this.createdAt,
    required this.lastActivity,
    required this.ipAddress,
    required this.userAgent,
    required this.isActive,
  });

  factory SessionInfo.fromJson(Map<String, dynamic> json) {
    return SessionInfo(
      sessionId: json['sessionId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastActivity: DateTime.parse(json['lastActivity'] as String),
      ipAddress: json['ipAddress'] as String,
      userAgent: json['userAgent'] as String,
      isActive: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'createdAt': createdAt.toIso8601String(),
      'lastActivity': lastActivity.toIso8601String(),
      'ipAddress': ipAddress,
      'userAgent': userAgent,
      'isActive': isActive,
    };
  }
}

/// Advanced Authentication Manager
class AuthManager extends StateNotifier<AuthState> {
  final ApiService _apiService;
  final Box _secureBox;
  
  AdminUser? _currentUser;
  String? _accessToken;
  String? _refreshToken;
  SessionInfo? _currentSession;
  Timer? _sessionTimer;
  Timer? _tokenRefreshTimer;
  int _loginAttempts = 0;
  DateTime? _lockoutUntil;

  AuthManager(this._apiService, this._secureBox) : super(AuthState.initial) {
    _initializeAuth();
  }

  // Getters
  AdminUser? get currentUser => _currentUser;
  String? get accessToken => _accessToken;
  bool get isAuthenticated => state == AuthState.authenticated && _currentUser != null;
  bool get isMfaRequired => state == AuthState.mfaRequired;
  bool get isLocked => state == AuthState.locked || (_lockoutUntil?.isAfter(DateTime.now()) ?? false);
  SessionInfo? get currentSession => _currentSession;

  /// Initialize authentication state
  Future<void> _initializeAuth() async {
    try {
      state = AuthState.loading;
      
      // Check for existing session
      final storedToken = _secureBox.get(AppConstants.authTokenKey);
      final storedRefreshToken = _secureBox.get(AppConstants.refreshTokenKey);
      final storedUserData = _secureBox.get(AppConstants.userDataKey);
      final storedSession = _secureBox.get(AppConstants.sessionKey);

      if (storedToken != null && storedUserData != null) {
        _accessToken = storedToken;
        _refreshToken = storedRefreshToken;
        _currentUser = AdminUser.fromJson(jsonDecode(storedUserData));
        
        if (storedSession != null) {
          _currentSession = SessionInfo.fromJson(jsonDecode(storedSession));
        }

        // Validate token
        if (_isTokenValid(_accessToken!)) {
          await _validateSession();
          if (state == AuthState.authenticated) {
            _startSessionTimer();
            _startTokenRefreshTimer();
          }
        } else if (_refreshToken != null) {
          await _refreshAccessToken();
        } else {
          await logout();
        }
      } else {
        state = AuthState.unauthenticated;
      }
    } catch (e) {
      debugPrint('Auth initialization error: $e');
      state = AuthState.unauthenticated;
    }
  }

  /// Login with email and password
  Future<AuthResult> login(String email, String password, {String? mfaCode}) async {
    if (isLocked) {
      final remainingTime = _lockoutUntil!.difference(DateTime.now()).inMinutes;
      return AuthResult.failure(
        message: 'Account locked. Try again in $remainingTime minutes.',
        errorCode: 'ACCOUNT_LOCKED',
      );
    }

    try {
      state = AuthState.loading;

      final response = await _apiService.post('/auth/admin/login', data: {
        'email': email,
        'password': _hashPassword(password),
        'mfaCode': mfaCode,
        'deviceInfo': await _getDeviceInfo(),
      });

      if (response.data['success'] == true) {
        final data = response.data['data'];

        // Check if MFA is required
        if (data['mfaRequired'] == true) {
          state = AuthState.mfaRequired;
          return AuthResult.success(
            message: 'MFA code required',
            data: {'mfaRequired': true},
          );
        }

        // Store authentication data
        _accessToken = data['accessToken'];
        _refreshToken = data['refreshToken'];
        _currentUser = AdminUser.fromJson(data['user']);
        _currentSession = SessionInfo.fromJson(data['session']);

        await _storeAuthData();
        
        // Reset login attempts
        _loginAttempts = 0;
        _lockoutUntil = null;
        
        state = AuthState.authenticated;
        _startSessionTimer();
        _startTokenRefreshTimer();

        return AuthResult.success(message: 'Login successful');
      } else {
        _handleLoginFailure();
        return AuthResult.failure(
          message: response.data['message'] ?? 'Login failed',
          errorCode: response.data['errorCode'],
        );
      }
    } catch (e) {
      _handleLoginFailure();
      state = AuthState.error;
      return AuthResult.failure(message: 'Login error: $e');
    }
  }

  /// Handle login failure and implement lockout
  void _handleLoginFailure() {
    _loginAttempts++;
    if (_loginAttempts >= AppConstants.maxLoginAttempts) {
      _lockoutUntil = DateTime.now().add(
        Duration(minutes: AppConstants.lockoutDurationMinutes),
      );
      state = AuthState.locked;
    } else {
      state = AuthState.unauthenticated;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      // Notify server about logout
      if (_accessToken != null) {
        await _apiService.post('/auth/admin/logout', data: {
          'sessionId': _currentSession?.sessionId,
        });
      }
    } catch (e) {
      debugPrint('Logout API error: $e');
    }

    // Clear local data
    await _clearAuthData();
    _stopTimers();
    
    _currentUser = null;
    _accessToken = null;
    _refreshToken = null;
    _currentSession = null;
    
    state = AuthState.unauthenticated;
  }

  /// Refresh access token
  Future<bool> _refreshAccessToken() async {
    if (_refreshToken == null) return false;

    try {
      final response = await _apiService.post('/auth/admin/refresh', data: {
        'refreshToken': _refreshToken,
      });

      if (response.data['success'] == true) {
        final data = response.data['data'];
        _accessToken = data['accessToken'];
        _refreshToken = data['refreshToken'];
        
        await _storeAuthData();
        _startTokenRefreshTimer();
        
        return true;
      }
    } catch (e) {
      debugPrint('Token refresh error: $e');
    }

    await logout();
    return false;
  }

  /// Validate current session
  Future<void> _validateSession() async {
    try {
      final response = await _apiService.get('/auth/admin/validate-session');
      
      if (response.data['success'] == true) {
        state = AuthState.authenticated;
        _currentSession = SessionInfo.fromJson(response.data['data']['session']);
        await _storeSessionData();
      } else {
        await logout();
      }
    } catch (e) {
      debugPrint('Session validation error: $e');
      await logout();
    }
  }

  /// Check if token is valid
  bool _isTokenValid(String token) {
    try {
      return !JwtDecoder.isExpired(token);
    } catch (e) {
      return false;
    }
  }

  /// Hash password using SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Get device information
  Future<Map<String, dynamic>> _getDeviceInfo() async {
    return {
      'platform': kIsWeb ? 'web' : 'desktop',
      'userAgent': kIsWeb ? 'Web Browser' : 'Desktop App',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Store authentication data securely
  Future<void> _storeAuthData() async {
    await _secureBox.put(AppConstants.authTokenKey, _accessToken);
    await _secureBox.put(AppConstants.refreshTokenKey, _refreshToken);
    await _secureBox.put(AppConstants.userDataKey, jsonEncode(_currentUser!.toJson()));
    await _storeSessionData();
  }

  /// Store session data
  Future<void> _storeSessionData() async {
    if (_currentSession != null) {
      await _secureBox.put(AppConstants.sessionKey, jsonEncode(_currentSession!.toJson()));
    }
  }

  /// Clear authentication data
  Future<void> _clearAuthData() async {
    await _secureBox.delete(AppConstants.authTokenKey);
    await _secureBox.delete(AppConstants.refreshTokenKey);
    await _secureBox.delete(AppConstants.userDataKey);
    await _secureBox.delete(AppConstants.sessionKey);
  }

  /// Start session timeout timer
  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer(
      Duration(minutes: AppConstants.sessionTimeoutMinutes),
      () async {
        await logout();
      },
    );
  }

  /// Start token refresh timer
  void _startTokenRefreshTimer() {
    _tokenRefreshTimer?.cancel();
    
    if (_accessToken != null) {
      try {
        final decodedToken = JwtDecoder.decode(_accessToken!);
        final exp = decodedToken['exp'] as int;
        final expiryTime = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
        final refreshTime = expiryTime.subtract(const Duration(minutes: 5));
        final timeUntilRefresh = refreshTime.difference(DateTime.now());
        
        if (timeUntilRefresh.isNegative) {
          _refreshAccessToken();
        } else {
          _tokenRefreshTimer = Timer(timeUntilRefresh, () {
            _refreshAccessToken();
          });
        }
      } catch (e) {
        debugPrint('Token refresh timer error: $e');
      }
    }
  }

  /// Stop all timers
  void _stopTimers() {
    _sessionTimer?.cancel();
    _tokenRefreshTimer?.cancel();
  }

  @override
  void dispose() {
    _stopTimers();
    super.dispose();
  }
}

/// Auth manager provider
final authManagerProvider = StateNotifierProvider<AuthManager, AuthState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final secureBox = Hive.box('secure_storage');
  return AuthManager(apiService, secureBox);
});

/// Current user provider
final currentUserProvider = Provider<AdminUser?>((ref) {
  final authManager = ref.watch(authManagerProvider.notifier);
  return authManager.currentUser;
});

/// Authentication state provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authManager = ref.watch(authManagerProvider.notifier);
  return authManager.isAuthenticated;
});
