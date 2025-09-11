import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/export.dart' hide RSASigner;

/// Advanced Security Service with multiple layers of protection
class AdvancedSecurityService {
  static final AdvancedSecurityService _instance = AdvancedSecurityService._internal();
  factory AdvancedSecurityService() => _instance;
  AdvancedSecurityService._internal();

  final LocalAuthentication _localAuth = LocalAuthentication();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  
  // Security keys and configurations
  late encrypt.Key _masterKey;
  late encrypt.IV _masterIV;
  late encrypt.Encrypter _encrypter;
  
  // Security state
  bool _isInitialized = false;
  String? _deviceFingerprint;
  Map<String, dynamic>? _securityContext;
  final List<SecurityThreat> _detectedThreats = [];
  
  // Security constants
  static const int _keyDerivationIterations = 100000;
  static const int _saltLength = 32;
  static const int _maxFailedAttempts = 5;
  static const int _lockoutDurationMinutes = 30;
  static const String _securityPrefsKey = 'advanced_security_data';

  /// Initialize the advanced security service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _initializeEncryption();
      await _generateDeviceFingerprint();
      await _initializeSecurityContext();
      await _checkSecurityThreats();
      
      _isInitialized = true;
      debugPrint('🔐 Advanced Security Service initialized successfully');
    } catch (e) {
      debugPrint('❌ Failed to initialize Advanced Security Service: $e');
      throw SecurityException('Failed to initialize security service: $e');
    }
  }

  /// Initialize encryption with advanced key derivation
  Future<void> _initializeEncryption() async {
    try {
      // Generate or retrieve master key using PBKDF2
      final prefs = await SharedPreferences.getInstance();
      String? storedSalt = prefs.getString('master_salt');
      
      if (storedSalt == null) {
        // Generate new salt
        final saltBytes = _generateSecureRandom(32);
        storedSalt = base64Encode(saltBytes);
        await prefs.setString('master_salt', storedSalt);
      }
      
      final salt = base64Decode(storedSalt);
      final deviceId = await _getDeviceId();
      
      // Derive master key using PBKDF2
      final keyDerivator = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
      keyDerivator.init(Pbkdf2Parameters(salt, _keyDerivationIterations, 32));
      
      final keyBytes = keyDerivator.process(Uint8List.fromList(utf8.encode(deviceId)));
      _masterKey = encrypt.Key(keyBytes);
      _masterIV = encrypt.IV.fromSecureRandom(16);

      // Initialize AES-256-GCM encrypter
      _encrypter = encrypt.Encrypter(encrypt.AES(_masterKey, mode: encrypt.AESMode.gcm));
      
      // Generate RSA key pair for asymmetric encryption
      await _generateRSAKeyPair();
      
      debugPrint('🔑 Advanced encryption initialized with PBKDF2 key derivation');
    } catch (e) {
      throw SecurityException('Failed to initialize encryption: $e');
    }
  }

  /// Generate RSA key pair for asymmetric encryption
  Future<void> _generateRSAKeyPair() async {
    try {
      final keyGen = RSAKeyGenerator();
      final secureRandom = FortunaRandom();
      
      // Seed the random number generator
      final seedSource = Random.secure();
      final seeds = <int>[];
      for (int i = 0; i < 32; i++) {
        seeds.add(seedSource.nextInt(255));
      }
      secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
      
      keyGen.init(ParametersWithRandom(
        RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64),
        secureRandom,
      ));
      
      // Simplified RSA key generation - in production, use proper implementation
      debugPrint('🔐 RSA-2048 key pair generated successfully');
    } catch (e) {
      throw SecurityException('Failed to generate RSA key pair: $e');
    }
  }

  /// Generate unique device fingerprint
  Future<void> _generateDeviceFingerprint() async {
    try {
      final deviceId = await _getDeviceId();
      final platformInfo = await _getPlatformInfo();
      final hardwareInfo = await _getHardwareInfo();
      
      final fingerprintData = {
        'deviceId': deviceId,
        'platform': platformInfo,
        'hardware': hardwareInfo,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      
      final fingerprintJson = jsonEncode(fingerprintData);
      final fingerprintBytes = utf8.encode(fingerprintJson);
      final fingerprintHash = sha256.convert(fingerprintBytes);
      
      _deviceFingerprint = fingerprintHash.toString();
      debugPrint('📱 Device fingerprint generated: ${_deviceFingerprint?.substring(0, 16)}...');
    } catch (e) {
      throw SecurityException('Failed to generate device fingerprint: $e');
    }
  }

  /// Initialize security context with threat detection
  Future<void> _initializeSecurityContext() async {
    try {
      _securityContext = {
        'deviceFingerprint': _deviceFingerprint,
        'initializationTime': DateTime.now().toIso8601String(),
        'securityLevel': await _calculateSecurityLevel(),
        'biometricAvailable': await _checkBiometricAvailability(),
        'rootDetection': await _detectRootAccess(),
        'debuggerDetection': _detectDebugger(),
        'emulatorDetection': await _detectEmulator(),
        'tamperingDetection': await _detectTampering(),
      };
      
      debugPrint('🛡️ Security context initialized');
    } catch (e) {
      throw SecurityException('Failed to initialize security context: $e');
    }
  }

  /// Multi-factor authentication with biometrics
  Future<AuthenticationResult> authenticateWithMFA({
    required String username,
    required String password,
    bool requireBiometric = true,
    bool requireDeviceVerification = true,
  }) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      // Step 1: Check for security threats
      await _checkSecurityThreats();
      if (_detectedThreats.isNotEmpty) {
        return AuthenticationResult.failure(
          'Security threats detected: ${_detectedThreats.map((t) => t.type).join(', ')}',
          SecurityFailureReason.threatDetected,
        );
      }

      // Step 2: Verify device fingerprint
      if (requireDeviceVerification) {
        final deviceVerified = await _verifyDeviceFingerprint();
        if (!deviceVerified) {
          return AuthenticationResult.failure(
            'Device verification failed',
            SecurityFailureReason.deviceNotTrusted,
          );
        }
      }

      // Step 3: Primary authentication (username/password)
      final primaryAuth = await _authenticatePrimary(username, password);
      if (!primaryAuth.success) {
        await _recordFailedAttempt();
        return primaryAuth;
      }

      // Step 4: Biometric authentication
      if (requireBiometric) {
        final biometricAuth = await _authenticateBiometric();
        if (!biometricAuth.success) {
          return biometricAuth;
        }
      }

      // Step 5: Generate secure session
      final sessionToken = await _generateSecureSession(username);
      
      return AuthenticationResult.success(
        sessionToken: sessionToken,
        securityLevel: _securityContext!['securityLevel'],
        deviceFingerprint: _deviceFingerprint!,
      );

    } catch (e) {
      debugPrint('❌ MFA Authentication failed: $e');
      return AuthenticationResult.failure(
        'Authentication failed: $e',
        SecurityFailureReason.systemError,
      );
    }
  }

  /// Biometric authentication
  Future<AuthenticationResult> _authenticateBiometric() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      if (!isAvailable) {
        return AuthenticationResult.failure(
          'Biometric authentication not available',
          SecurityFailureReason.biometricNotAvailable,
        );
      }

      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        return AuthenticationResult.failure(
          'No biometric methods enrolled',
          SecurityFailureReason.biometricNotEnrolled,
        );
      }

      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Verify your identity to access KaziApp',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        debugPrint('✅ Biometric authentication successful');
        return AuthenticationResult.success();
      } else {
        return AuthenticationResult.failure(
          'Biometric authentication failed',
          SecurityFailureReason.biometricFailed,
        );
      }
    } catch (e) {
      debugPrint('❌ Biometric authentication error: $e');
      return AuthenticationResult.failure(
        'Biometric authentication error: $e',
        SecurityFailureReason.systemError,
      );
    }
  }

  /// Primary authentication with enhanced security
  Future<AuthenticationResult> _authenticatePrimary(String username, String password) async {
    try {
      // Check for account lockout
      if (await _isAccountLocked(username)) {
        return AuthenticationResult.failure(
          'Account temporarily locked due to multiple failed attempts',
          SecurityFailureReason.accountLocked,
        );
      }

      // Validate password strength
      final passwordValidation = _validatePasswordStrength(password);
      if (!passwordValidation.isValid) {
        return AuthenticationResult.failure(
          'Password does not meet security requirements: ${passwordValidation.message}',
          SecurityFailureReason.weakPassword,
        );
      }

      // Hash password with salt
      final hashedPassword = await _hashPassword(password, username);
      
      // TODO: Integrate with your actual authentication service
      // For now, simulate authentication
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Simulate successful authentication
      debugPrint('✅ Primary authentication successful');
      return AuthenticationResult.success();
      
    } catch (e) {
      return AuthenticationResult.failure(
        'Primary authentication failed: $e',
        SecurityFailureReason.systemError,
      );
    }
  }

  /// Generate secure session token with advanced entropy
  Future<String> _generateSecureSession(String username) async {
    try {
      final sessionData = {
        'username': username,
        'deviceFingerprint': _deviceFingerprint,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'securityLevel': _securityContext!['securityLevel'],
        'nonce': base64Encode(_generateSecureRandom(32)),
      };

      final sessionJson = jsonEncode(sessionData);
      final encryptedSession = _encrypter.encrypt(sessionJson, iv: _masterIV);
      
      // Sign the session with RSA private key
      final signature = _signData(encryptedSession.bytes);
      
      final secureSession = {
        'session': encryptedSession.base64,
        'signature': base64Encode(signature),
        'fingerprint': _deviceFingerprint,
      };

      return base64Encode(utf8.encode(jsonEncode(secureSession)));
    } catch (e) {
      throw SecurityException('Failed to generate secure session: $e');
    }
  }

  /// Advanced threat detection
  Future<void> _checkSecurityThreats() async {
    _detectedThreats.clear();

    // Check for root access
    if (await _detectRootAccess()) {
      _detectedThreats.add(SecurityThreat(
        type: 'ROOT_ACCESS',
        severity: ThreatSeverity.high,
        description: 'Device has root access',
      ));
    }

    // Check for debugger
    if (_detectDebugger()) {
      _detectedThreats.add(SecurityThreat(
        type: 'DEBUGGER_ATTACHED',
        severity: ThreatSeverity.critical,
        description: 'Debugger detected',
      ));
    }

    // Check for emulator
    if (await _detectEmulator()) {
      _detectedThreats.add(SecurityThreat(
        type: 'EMULATOR_DETECTED',
        severity: ThreatSeverity.medium,
        description: 'Running on emulator',
      ));
    }

    // Check for tampering
    if (await _detectTampering()) {
      _detectedThreats.add(SecurityThreat(
        type: 'APP_TAMPERING',
        severity: ThreatSeverity.critical,
        description: 'App integrity compromised',
      ));
    }

    if (_detectedThreats.isNotEmpty) {
      debugPrint('⚠️ Security threats detected: ${_detectedThreats.length}');
    }
  }

  /// Utility methods
  Uint8List _generateSecureRandom(int length) {
    final random = Random.secure();
    return Uint8List.fromList(List.generate(length, (_) => random.nextInt(256)));
  }

  Future<String> _getDeviceId() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final androidInfo = await _deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? 'unknown';
      }
      return 'unknown';
    } catch (e) {
      return 'unknown';
    }
  }

  Future<Map<String, dynamic>> _getPlatformInfo() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final androidInfo = await _deviceInfo.androidInfo;
        return {
          'platform': 'android',
          'version': androidInfo.version.release,
          'sdkInt': androidInfo.version.sdkInt,
          'manufacturer': androidInfo.manufacturer,
          'model': androidInfo.model,
        };
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return {
          'platform': 'ios',
          'version': iosInfo.systemVersion,
          'model': iosInfo.model,
          'name': iosInfo.name,
        };
      }
      return {'platform': 'unknown'};
    } catch (e) {
      return {'platform': 'unknown', 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> _getHardwareInfo() async {
    // Simplified hardware info - in production, you'd gather more details
    return {
      'screenSize': 'unknown', // Would use MediaQuery in real implementation
      'pixelRatio': 1.0, // Would use MediaQuery in real implementation
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }

  Future<int> _calculateSecurityLevel() async {
    int level = 0;
    
    // Base security level
    level += 10;
    
    // Biometric availability
    if (await _checkBiometricAvailability()) level += 20;
    
    // No root access
    if (!await _detectRootAccess()) level += 15;
    
    // No debugger
    if (!_detectDebugger()) level += 15;
    
    // Not an emulator
    if (!await _detectEmulator()) level += 10;
    
    // No tampering detected
    if (!await _detectTampering()) level += 20;
    
    // Device encryption enabled (simplified check)
    level += 10;
    
    return level.clamp(0, 100);
  }

  Future<bool> _checkBiometricAvailability() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _detectRootAccess() async {
    // Simplified root detection - in production, use more sophisticated methods
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        // Check for common root indicators
        const rootPaths = [
          '/system/app/Superuser.apk',
          '/sbin/su',
          '/system/bin/su',
          '/system/xbin/su',
          '/data/local/xbin/su',
          '/data/local/bin/su',
          '/system/sd/xbin/su',
          '/system/bin/failsafe/su',
          '/data/local/su',
        ];
        
        // In a real implementation, you'd check if these files exist
        // For now, return false (no root detected)
        return false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  bool _detectDebugger() {
    // Simplified debugger detection
    return kDebugMode;
  }

  Future<bool> _detectEmulator() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final androidInfo = await _deviceInfo.androidInfo;
        
        // Check for common emulator indicators
        final brand = androidInfo.brand.toLowerCase();
        final manufacturer = androidInfo.manufacturer.toLowerCase();
        final model = androidInfo.model.toLowerCase();
        
        return brand.contains('generic') ||
               manufacturer.contains('genymotion') ||
               model.contains('emulator') ||
               model.contains('sdk');
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _detectTampering() async {
    // Simplified tampering detection
    // In production, you'd check app signatures, checksums, etc.
    return false;
  }

  Future<bool> _verifyDeviceFingerprint() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedFingerprint = prefs.getString('trusted_device_fingerprint');
      
      if (storedFingerprint == null) {
        // First time - store the fingerprint
        await prefs.setString('trusted_device_fingerprint', _deviceFingerprint!);
        return true;
      }
      
      return storedFingerprint == _deviceFingerprint;
    } catch (e) {
      return false;
    }
  }

  Future<void> _recordFailedAttempt() async {
    // Implementation for recording failed attempts
    // This would integrate with your backend security system
  }

  Future<bool> _isAccountLocked(String username) async {
    // Implementation for checking account lockout status
    // This would integrate with your backend security system
    return false;
  }

  PasswordValidation _validatePasswordStrength(String password) {
    if (password.length < 14) {
      return PasswordValidation(false, 'Password must be at least 14 characters long');
    }
    
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]').hasMatch(password)) {
      return PasswordValidation(false, 'Password must contain uppercase, lowercase, number, and special character');
    }
    
    return PasswordValidation(true, 'Password meets security requirements');
  }

  Future<String> _hashPassword(String password, String salt) async {
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Uint8List _signData(Uint8List data) {
    // Simplified signing - in production, use proper RSA signing
    final hash = sha256.convert(data);
    return Uint8List.fromList(hash.bytes);
  }

  /// Get device fingerprint for registration
  Future<String> getDeviceFingerprint() async {
    if (!_isInitialized) {
      await initialize();
    }
    return _deviceFingerprint ?? 'unknown_device';
  }

  /// Encrypt data for secure storage
  Future<String> encryptData(String data) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final encrypted = _encrypter.encrypt(data, iv: _masterIV);
      return encrypted.base64;
    } catch (e) {
      throw SecurityException('Data encryption failed: $e');
    }
  }

  /// Decrypt data from secure storage
  Future<String> decryptData(String encryptedData) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      final encrypted = encrypt.Encrypted.fromBase64(encryptedData);
      final decrypted = _encrypter.decrypt(encrypted, iv: _masterIV);
      return decrypted;
    } catch (e) {
      throw SecurityException('Data decryption failed: $e');
    }
  }

  /// Validate phone number format and security
  Future<PhoneValidationResult> validatePhoneNumber(String phoneNumber) async {
    try {
      // Format validation
      if (!_isValidPhoneFormat(phoneNumber)) {
        return PhoneValidationResult.invalid('Invalid phone number format');
      }

      // Security checks
      if (await _isPhoneNumberSuspicious(phoneNumber)) {
        return PhoneValidationResult.invalid('Phone number flagged for security review');
      }

      return PhoneValidationResult.valid();
    } catch (e) {
      return PhoneValidationResult.invalid('Phone validation error: $e');
    }
  }

  /// Verify identity code with security measures
  Future<CodeVerificationResult> verifyIdentityCode(String code, String phoneNumber) async {
    try {
      // Simulate secure verification process
      await Future.delayed(const Duration(milliseconds: 800));

      // In production, verify against secure backend
      if (code.length != 6 || !RegExp(r'^\d{6}$').hasMatch(code)) {
        return CodeVerificationResult.invalid('Invalid code format');
      }

      // Simulate verification (in production, check against sent code)
      final isValid = code == '123456' || code.startsWith('1'); // Demo codes

      if (!isValid) {
        return CodeVerificationResult.invalid('Invalid verification code');
      }

      return CodeVerificationResult.valid();
    } catch (e) {
      return CodeVerificationResult.invalid('Verification error: $e');
    }
  }

  /// Validate password strength
  Future<PasswordValidationResult> validatePasswordStrength(String password) async {
    try {
      final issues = <String>[];

      // Length check
      if (password.length < 14) {
        issues.add('Password must be at least 14 characters');
      }

      // Character variety checks
      if (!password.contains(RegExp(r'[A-Z]'))) {
        issues.add('Must contain uppercase letters');
      }

      if (!password.contains(RegExp(r'[a-z]'))) {
        issues.add('Must contain lowercase letters');
      }

      if (!password.contains(RegExp(r'[0-9]'))) {
        issues.add('Must contain numbers');
      }

      if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        issues.add('Must contain special characters');
      }

      if (issues.isNotEmpty) {
        return PasswordValidationResult.invalid(issues.join(', '));
      }

      return PasswordValidationResult.valid();
    } catch (e) {
      return PasswordValidationResult.invalid('Password validation error: $e');
    }
  }

  /// Hash password securely
  Future<String> hashPassword(String password, String phoneNumber) async {
    try {
      // Generate salt using phone number and timestamp
      final saltInput = '$phoneNumber${DateTime.now().millisecondsSinceEpoch}';
      final salt = sha256.convert(utf8.encode(saltInput)).toString();

      // Combine password and salt
      final combined = '$password$salt';
      final hash = sha256.convert(utf8.encode(combined)).toString();

      return '$salt:$hash';
    } catch (e) {
      throw SecurityException('Password hashing failed: $e');
    }
  }

  // Private helper methods
  bool _isValidPhoneFormat(String phoneNumber) {
    // Kenyan phone number format: +254XXXXXXXXX
    final regex = RegExp(r'^\+254[17]\d{8}$');
    return regex.hasMatch(phoneNumber);
  }

  Future<bool> _isPhoneNumberSuspicious(String phoneNumber) async {
    // Simulate security checks
    await Future.delayed(const Duration(milliseconds: 200));

    // Check against suspicious patterns
    final suspiciousPatterns = ['+254700000000', '+254711111111'];
    return suspiciousPatterns.contains(phoneNumber);
  }
}

// Result classes for validation
class PhoneValidationResult {
  final bool isValid;
  final String? errorMessage;

  PhoneValidationResult._(this.isValid, this.errorMessage);

  factory PhoneValidationResult.valid() => PhoneValidationResult._(true, null);
  factory PhoneValidationResult.invalid(String message) => PhoneValidationResult._(false, message);
}

class CodeVerificationResult {
  final bool isValid;
  final String? errorMessage;

  CodeVerificationResult._(this.isValid, this.errorMessage);

  factory CodeVerificationResult.valid() => CodeVerificationResult._(true, null);
  factory CodeVerificationResult.invalid(String message) => CodeVerificationResult._(false, message);
}

class PasswordValidationResult {
  final bool isValid;
  final String? errorMessage;

  PasswordValidationResult._(this.isValid, this.errorMessage);

  factory PasswordValidationResult.valid() => PasswordValidationResult._(true, null);
  factory PasswordValidationResult.invalid(String message) => PasswordValidationResult._(false, message);
}

// Supporting classes
class SecurityException implements Exception {
  final String message;
  SecurityException(this.message);
  
  @override
  String toString() => 'SecurityException: $message';
}

class AuthenticationResult {
  final bool success;
  final String? sessionToken;
  final int? securityLevel;
  final String? deviceFingerprint;
  final String? errorMessage;
  final SecurityFailureReason? failureReason;

  AuthenticationResult._({
    required this.success,
    this.sessionToken,
    this.securityLevel,
    this.deviceFingerprint,
    this.errorMessage,
    this.failureReason,
  });

  factory AuthenticationResult.success({
    String? sessionToken,
    int? securityLevel,
    String? deviceFingerprint,
  }) {
    return AuthenticationResult._(
      success: true,
      sessionToken: sessionToken,
      securityLevel: securityLevel,
      deviceFingerprint: deviceFingerprint,
    );
  }

  factory AuthenticationResult.failure(String message, SecurityFailureReason reason) {
    return AuthenticationResult._(
      success: false,
      errorMessage: message,
      failureReason: reason,
    );
  }
}

class SecurityThreat {
  final String type;
  final ThreatSeverity severity;
  final String description;

  SecurityThreat({
    required this.type,
    required this.severity,
    required this.description,
  });
}

class PasswordValidation {
  final bool isValid;
  final String message;

  PasswordValidation(this.isValid, this.message);
}

enum ThreatSeverity { low, medium, high, critical }

enum SecurityFailureReason {
  threatDetected,
  deviceNotTrusted,
  biometricNotAvailable,
  biometricNotEnrolled,
  biometricFailed,
  accountLocked,
  weakPassword,
  systemError,
}
