import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'advanced_security_service.dart';
import 'encryption_service.dart';

/// Zero-Trust Authentication Service with continuous verification
class ZeroTrustAuthService {
  static final ZeroTrustAuthService _instance = ZeroTrustAuthService._internal();
  factory ZeroTrustAuthService() => _instance;
  ZeroTrustAuthService._internal();

  final Dio _dio = Dio();
  final AdvancedSecurityService _securityService = AdvancedSecurityService();
  final EncryptionService _encryptionService = EncryptionService();

  // Zero-trust configuration
  static const String _baseUrl = 'http://localhost:3000/api';
  static const int _sessionValidityMinutes = 15;
  static const int _maxConcurrentSessions = 3;
  static const int _riskScoreThreshold = 70;
  
  // Session management
  String? _currentSessionToken;
  DateTime? _lastVerification;
  int _currentRiskScore = 0;
  Map<String, dynamic>? _userContext;
  final List<SecurityEvent> _securityEvents = [];

  /// Initialize Zero-Trust Authentication
  Future<void> initialize() async {
    try {
      await _securityService.initialize();
      await _encryptionService.initialize();
      _setupInterceptors();
      
      debugPrint('🛡️ Zero-Trust Authentication Service initialized');
    } catch (e) {
      debugPrint('❌ Failed to initialize Zero-Trust Auth: $e');
      throw Exception('Failed to initialize Zero-Trust authentication: $e');
    }
  }

  /// Setup HTTP interceptors for continuous verification
  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add security headers
        await _addSecurityHeaders(options);
        
        // Verify session before each request
        final isValid = await _verifyCurrentSession();
        if (!isValid) {
          handler.reject(DioException(
            requestOptions: options,
            type: DioExceptionType.cancel,
            message: 'Session verification failed',
          ));
          return;
        }
        
        handler.next(options);
      },
      onResponse: (response, handler) async {
        // Update risk score based on response
        await _updateRiskScore(response);
        handler.next(response);
      },
      onError: (error, handler) async {
        // Handle security-related errors
        await _handleSecurityError(error);
        handler.next(error);
      },
    ));
  }

  /// Authenticate with Zero-Trust principles
  Future<ZeroTrustAuthResult> authenticate({
    required String username,
    required String password,
    Map<String, dynamic>? additionalContext,
  }) async {
    try {
      // Step 1: Initialize security context
      final securityContext = await _buildSecurityContext(additionalContext);
      
      // Step 2: Perform multi-factor authentication
      final mfaResult = await _securityService.authenticateWithMFA(
        username: username,
        password: password,
        requireBiometric: true,
        requireDeviceVerification: true,
      );

      if (!mfaResult.success) {
        await _recordSecurityEvent(SecurityEventType.authenticationFailed, {
          'username': username,
          'reason': mfaResult.failureReason?.toString(),
          'error': mfaResult.errorMessage,
        });
        
        return ZeroTrustAuthResult.failure(
          mfaResult.errorMessage ?? 'Authentication failed',
          AuthFailureReason.mfaFailed,
        );
      }

      // Step 3: Calculate initial risk score
      final riskScore = await _calculateRiskScore(securityContext);
      
      if (riskScore > _riskScoreThreshold) {
        await _recordSecurityEvent(SecurityEventType.highRiskDetected, {
          'username': username,
          'riskScore': riskScore,
          'context': securityContext,
        });
        
        return ZeroTrustAuthResult.failure(
          'Authentication blocked due to high risk score: $riskScore',
          AuthFailureReason.highRisk,
        );
      }

      // Step 4: Create secure session
      final sessionResult = await _createSecureSession(username, securityContext, riskScore);
      
      if (!sessionResult.success) {
        return ZeroTrustAuthResult.failure(
          'Failed to create secure session',
          AuthFailureReason.sessionCreationFailed,
        );
      }

      // Step 5: Store session and context
      _currentSessionToken = sessionResult.sessionToken;
      _currentRiskScore = riskScore;
      _userContext = securityContext;
      _lastVerification = DateTime.now();

      await _recordSecurityEvent(SecurityEventType.authenticationSucceeded, {
        'username': username,
        'riskScore': riskScore,
        'sessionId': sessionResult.sessionId,
      });

      return ZeroTrustAuthResult.success(
        sessionToken: sessionResult.sessionToken!,
        sessionId: sessionResult.sessionId!,
        riskScore: riskScore,
        expiresAt: DateTime.now().add(const Duration(minutes: _sessionValidityMinutes)),
      );

    } catch (e) {
      debugPrint('❌ Zero-Trust authentication failed: $e');
      return ZeroTrustAuthResult.failure(
        'Authentication system error: $e',
        AuthFailureReason.systemError,
      );
    }
  }

  /// Continuous session verification
  Future<bool> _verifyCurrentSession() async {
    try {
      if (_currentSessionToken == null) return false;
      
      // Check session expiry
      if (_lastVerification != null) {
        final timeSinceLastVerification = DateTime.now().difference(_lastVerification!);
        if (timeSinceLastVerification.inMinutes > _sessionValidityMinutes) {
          await _invalidateSession('Session expired');
          return false;
        }
      }

      // Continuous risk assessment
      final currentRiskScore = await _calculateCurrentRiskScore();
      
      if (currentRiskScore > _riskScoreThreshold) {
        await _recordSecurityEvent(SecurityEventType.riskScoreExceeded, {
          'currentRiskScore': currentRiskScore,
          'threshold': _riskScoreThreshold,
        });
        
        await _invalidateSession('Risk score exceeded threshold');
        return false;
      }

      // Verify session with backend
      final isValidOnServer = await _verifySessionWithServer();
      if (!isValidOnServer) {
        await _invalidateSession('Server session verification failed');
        return false;
      }

      _lastVerification = DateTime.now();
      return true;

    } catch (e) {
      debugPrint('❌ Session verification failed: $e');
      await _invalidateSession('Session verification error');
      return false;
    }
  }

  /// Build comprehensive security context
  Future<Map<String, dynamic>> _buildSecurityContext(Map<String, dynamic>? additionalContext) async {
    final context = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'deviceFingerprint': await _getDeviceFingerprint(),
      'networkInfo': await _getNetworkInfo(),
      'locationInfo': await _getLocationInfo(),
      'behavioralMetrics': await _getBehavioralMetrics(),
      'appIntegrity': await _checkAppIntegrity(),
      'systemSecurity': await _checkSystemSecurity(),
    };

    if (additionalContext != null) {
      context.addAll(additionalContext);
    }

    return context;
  }

  /// Calculate risk score based on multiple factors
  Future<int> _calculateRiskScore(Map<String, dynamic> context) async {
    int riskScore = 0;

    // Device trust score (0-30 points)
    final deviceTrust = await _calculateDeviceTrustScore(context);
    riskScore += (30 - deviceTrust).clamp(0, 30);

    // Network risk score (0-20 points)
    final networkRisk = await _calculateNetworkRiskScore(context);
    riskScore += networkRisk;

    // Behavioral risk score (0-25 points)
    final behavioralRisk = await _calculateBehavioralRiskScore(context);
    riskScore += behavioralRisk;

    // Time-based risk score (0-15 points)
    final timeRisk = _calculateTimeBasedRiskScore();
    riskScore += timeRisk;

    // Location risk score (0-10 points)
    final locationRisk = await _calculateLocationRiskScore(context);
    riskScore += locationRisk;

    return riskScore.clamp(0, 100);
  }

  /// Calculate current risk score for continuous monitoring
  Future<int> _calculateCurrentRiskScore() async {
    final currentContext = await _buildSecurityContext(null);
    return await _calculateRiskScore(currentContext);
  }

  /// Create secure session with backend
  Future<SessionCreationResult> _createSecureSession(
    String username,
    Map<String, dynamic> context,
    int riskScore,
  ) async {
    try {
      final sessionData = {
        'username': username,
        'securityContext': context,
        'riskScore': riskScore,
        'deviceFingerprint': context['deviceFingerprint'],
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Encrypt session data
      final encryptedData = _encryptionService.encryptMessage(jsonEncode(sessionData));

      final response = await _dio.post(
        '$_baseUrl/auth/create-session',
        data: {
          'encryptedSessionData': encryptedData,
          'securityLevel': 'zero-trust',
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        return SessionCreationResult.success(
          sessionToken: data['sessionToken'],
          sessionId: data['sessionId'],
        );
      } else {
        return SessionCreationResult.failure('Server rejected session creation');
      }

    } catch (e) {
      debugPrint('❌ Session creation failed: $e');
      return SessionCreationResult.failure('Session creation error: $e');
    }
  }

  /// Verify session with server
  Future<bool> _verifySessionWithServer() async {
    try {
      if (_currentSessionToken == null) return false;

      final response = await _dio.post(
        '$_baseUrl/auth/verify-session',
        data: {
          'sessionToken': _currentSessionToken,
          'currentContext': await _buildSecurityContext(null),
        },
      );

      return response.statusCode == 200 && response.data['valid'] == true;
    } catch (e) {
      debugPrint('❌ Server session verification failed: $e');
      return false;
    }
  }

  /// Add security headers to requests
  Future<void> _addSecurityHeaders(RequestOptions options) async {
    options.headers.addAll({
      'X-Device-Fingerprint': await _getDeviceFingerprint(),
      'X-Session-Token': _currentSessionToken,
      'X-Risk-Score': _currentRiskScore.toString(),
      'X-Timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'X-App-Integrity': await _getAppIntegrityHash(),
    });
  }

  /// Update risk score based on API response
  Future<void> _updateRiskScore(Response response) async {
    // Analyze response for risk indicators
    final serverRiskScore = response.headers.value('X-Server-Risk-Score');
    if (serverRiskScore != null) {
      final newRiskScore = int.tryParse(serverRiskScore) ?? _currentRiskScore;
      if (newRiskScore != _currentRiskScore) {
        _currentRiskScore = newRiskScore;
        
        if (newRiskScore > _riskScoreThreshold) {
          await _recordSecurityEvent(SecurityEventType.riskScoreUpdated, {
            'newRiskScore': newRiskScore,
            'source': 'server',
          });
        }
      }
    }
  }

  /// Handle security-related errors
  Future<void> _handleSecurityError(DioException error) async {
    if (error.response?.statusCode == 401) {
      await _recordSecurityEvent(SecurityEventType.unauthorizedAccess, {
        'endpoint': error.requestOptions.path,
        'method': error.requestOptions.method,
      });
      
      await _invalidateSession('Unauthorized access detected');
    } else if (error.response?.statusCode == 403) {
      await _recordSecurityEvent(SecurityEventType.forbiddenAccess, {
        'endpoint': error.requestOptions.path,
        'method': error.requestOptions.method,
      });
    }
  }

  /// Invalidate current session
  Future<void> _invalidateSession(String reason) async {
    await _recordSecurityEvent(SecurityEventType.sessionInvalidated, {
      'reason': reason,
      'sessionToken': _currentSessionToken,
    });

    _currentSessionToken = null;
    _lastVerification = null;
    _currentRiskScore = 0;
    _userContext = null;

    // Clear stored session data
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('zero_trust_session');
  }

  /// Record security event
  Future<void> _recordSecurityEvent(SecurityEventType type, Map<String, dynamic> data) async {
    final event = SecurityEvent(
      type: type,
      timestamp: DateTime.now(),
      data: data,
    );

    _securityEvents.add(event);

    // Keep only last 100 events
    if (_securityEvents.length > 100) {
      _securityEvents.removeAt(0);
    }

    debugPrint('🔒 Security Event: ${type.toString()} - ${data.toString()}');
  }

  /// Helper methods for risk calculation
  Future<int> _calculateDeviceTrustScore(Map<String, dynamic> context) async {
    // Implementation would analyze device characteristics
    return 25; // Placeholder
  }

  Future<int> _calculateNetworkRiskScore(Map<String, dynamic> context) async {
    // Implementation would analyze network characteristics
    return 5; // Placeholder
  }

  Future<int> _calculateBehavioralRiskScore(Map<String, dynamic> context) async {
    // Implementation would analyze user behavior patterns
    return 10; // Placeholder
  }

  int _calculateTimeBasedRiskScore() {
    final hour = DateTime.now().hour;
    // Higher risk during unusual hours (11 PM - 5 AM)
    if (hour >= 23 || hour <= 5) {
      return 10;
    }
    return 0;
  }

  Future<int> _calculateLocationRiskScore(Map<String, dynamic> context) async {
    // Implementation would analyze location patterns
    return 0; // Placeholder
  }

  /// Helper methods for context building
  Future<String> _getDeviceFingerprint() async {
    // Implementation would generate device fingerprint
    return 'device_fingerprint_placeholder';
  }

  Future<Map<String, dynamic>> _getNetworkInfo() async {
    // Implementation would gather network information
    return {'type': 'wifi', 'ssid': 'unknown'};
  }

  Future<Map<String, dynamic>> _getLocationInfo() async {
    // Implementation would gather location information
    return {'latitude': 0.0, 'longitude': 0.0, 'accuracy': 0.0};
  }

  Future<Map<String, dynamic>> _getBehavioralMetrics() async {
    // Implementation would gather behavioral metrics
    return {'typing_speed': 0, 'touch_pressure': 0, 'usage_patterns': {}};
  }

  Future<Map<String, dynamic>> _checkAppIntegrity() async {
    // Implementation would check app integrity
    return {'signature_valid': true, 'checksum_valid': true};
  }

  Future<Map<String, dynamic>> _checkSystemSecurity() async {
    // Implementation would check system security
    return {'root_detected': false, 'debugger_detected': false};
  }

  Future<String> _getAppIntegrityHash() async {
    // Implementation would generate app integrity hash
    return 'app_integrity_hash_placeholder';
  }

  /// Generate secure session for registration process
  Future<String> generateSecureSession(
    Map<String, dynamic> registrationData,
    int securityLevel,
    Map<String, dynamic> additionalContext,
  ) async {
    try {
      final sessionData = {
        'registrationData': registrationData,
        'securityLevel': securityLevel,
        'additionalContext': additionalContext,
        'timestamp': DateTime.now().toIso8601String(),
        'deviceFingerprint': await _getDeviceFingerprint(),
        'sessionId': _generateSecureSessionId(),
        'riskScore': _currentRiskScore,
      };

      // Encrypt session data
      final sessionJson = jsonEncode(sessionData);
      final encryptedSession = _encryptionService.encryptMessage(sessionJson);

      return base64.encode(utf8.encode(encryptedSession));
    } catch (e) {
      throw Exception('Session generation failed: $e');
    }
  }

  String _generateSecureSessionId() {
    final random = Random.secure();
    final bytes = List.generate(32, (index) => random.nextInt(256));
    return base64.encode(bytes);
  }

  /// Public getters
  bool get isAuthenticated => _currentSessionToken != null;
  int get currentRiskScore => _currentRiskScore;
  List<SecurityEvent> get securityEvents => List.unmodifiable(_securityEvents);
}

// Supporting classes
class ZeroTrustAuthResult {
  final bool success;
  final String? sessionToken;
  final String? sessionId;
  final int? riskScore;
  final DateTime? expiresAt;
  final String? errorMessage;
  final AuthFailureReason? failureReason;

  ZeroTrustAuthResult._({
    required this.success,
    this.sessionToken,
    this.sessionId,
    this.riskScore,
    this.expiresAt,
    this.errorMessage,
    this.failureReason,
  });

  factory ZeroTrustAuthResult.success({
    required String sessionToken,
    required String sessionId,
    required int riskScore,
    required DateTime expiresAt,
  }) {
    return ZeroTrustAuthResult._(
      success: true,
      sessionToken: sessionToken,
      sessionId: sessionId,
      riskScore: riskScore,
      expiresAt: expiresAt,
    );
  }

  factory ZeroTrustAuthResult.failure(String message, AuthFailureReason reason) {
    return ZeroTrustAuthResult._(
      success: false,
      errorMessage: message,
      failureReason: reason,
    );
  }
}

class SessionCreationResult {
  final bool success;
  final String? sessionToken;
  final String? sessionId;
  final String? errorMessage;

  SessionCreationResult._({
    required this.success,
    this.sessionToken,
    this.sessionId,
    this.errorMessage,
  });

  factory SessionCreationResult.success({
    required String sessionToken,
    required String sessionId,
  }) {
    return SessionCreationResult._(
      success: true,
      sessionToken: sessionToken,
      sessionId: sessionId,
    );
  }

  factory SessionCreationResult.failure(String message) {
    return SessionCreationResult._(
      success: false,
      errorMessage: message,
    );
  }
}

class SecurityEvent {
  final SecurityEventType type;
  final DateTime timestamp;
  final Map<String, dynamic> data;

  SecurityEvent({
    required this.type,
    required this.timestamp,
    required this.data,
  });
}

enum SecurityEventType {
  authenticationSucceeded,
  authenticationFailed,
  sessionInvalidated,
  riskScoreExceeded,
  riskScoreUpdated,
  highRiskDetected,
  unauthorizedAccess,
  forbiddenAccess,
  suspiciousActivity,
}

enum AuthFailureReason {
  mfaFailed,
  highRisk,
  sessionCreationFailed,
  systemError,
}
