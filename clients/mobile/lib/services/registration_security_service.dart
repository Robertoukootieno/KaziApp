import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'advanced_security_service.dart';
import 'communication_service.dart';

/// Registration Security Service with Advanced Validation
class RegistrationSecurityService {
  static final RegistrationSecurityService _instance = RegistrationSecurityService._internal();
  factory RegistrationSecurityService() => _instance;
  RegistrationSecurityService._internal();

  final AdvancedSecurityService _securityService = AdvancedSecurityService();
  final CommunicationService _communicationService = CommunicationService();
  
  // Security constants
  static const int _minPasswordLength = 14;
  static const int _maxFailedAttempts = 3;
  static const int _verificationCodeLength = 6;
  static const int _codeValidityMinutes = 10;
  
  // Temporary storage for verification codes (in production, use secure backend)
  final Map<String, VerificationCode> _verificationCodes = {};
  final Map<String, int> _failedAttempts = {};

  /// Initialize the registration security service
  Future<void> initialize() async {
    try {
      await _securityService.initialize();
      await _communicationService.initialize();
      debugPrint('🔐 Registration Security Service initialized');
    } catch (e) {
      debugPrint('❌ Failed to initialize Registration Security Service: $e');
      throw SecurityException('Failed to initialize registration security: $e');
    }
  }

  /// Validate phone number format and check for duplicates
  Future<ValidationResult> validatePhoneNumber(String phoneNumber) async {
    try {
      // Format validation
      if (!_isValidPhoneFormat(phoneNumber)) {
        return ValidationResult.invalid('Invalid phone number format');
      }

      // Check for existing registration (simulate database check)
      final exists = await _checkPhoneNumberExists(phoneNumber);
      if (exists) {
        return ValidationResult.invalid('Phone number already registered');
      }

      // Additional security checks
      if (await _isPhoneNumberBlacklisted(phoneNumber)) {
        return ValidationResult.invalid('Phone number not allowed');
      }

      return ValidationResult.valid();
    } catch (e) {
      return ValidationResult.invalid('Phone validation error: $e');
    }
  }

  /// Generate and send verification code with real-time SMS and Email
  Future<VerificationResult> sendVerificationCode(
    String phoneNumber, {
    String? email,
    String? userName,
  }) async {
    try {
      // Check failed attempts
      final attempts = _failedAttempts[phoneNumber] ?? 0;
      if (attempts >= _maxFailedAttempts) {
        return VerificationResult.failed('Too many attempts. Please try again later.');
      }

      // Generate secure verification code
      final code = _generateSecureCode();
      final expiryTime = DateTime.now().add(const Duration(minutes: _codeValidityMinutes));

      _verificationCodes[phoneNumber] = VerificationCode(
        code: code,
        phoneNumber: phoneNumber,
        expiryTime: expiryTime,
        attempts: 0,
      );

      // Send real-time SMS verification
      final smsResult = await _communicationService.sendSmsVerification(
        phoneNumber: phoneNumber,
        verificationCode: code,
        userName: userName,
      );

      // Send real-time email verification if email provided
      EmailResult? emailResult;
      if (email != null && email.isNotEmpty) {
        emailResult = await _communicationService.sendEmailVerification(
          email: email,
          verificationCode: code,
          userName: userName,
        );
      }

      // Check results
      if (smsResult.success) {
        String message = 'Verification code sent via SMS';
        if (emailResult?.success == true) {
          message += ' and email';
        }

        debugPrint('✅ Verification sent successfully to $phoneNumber');
        if (email != null) debugPrint('✅ Email verification sent to $email');

        return VerificationResult.success(message);
      } else {
        debugPrint('❌ SMS verification failed: ${smsResult.error}');
        return VerificationResult.failed(
          smsResult.error ?? 'Failed to send verification code'
        );
      }
    } catch (e) {
      debugPrint('❌ Verification sending error: $e');
      return VerificationResult.failed('Failed to send verification code: $e');
    }
  }

  /// Verify identity code with enhanced security
  Future<ValidationResult> verifyIdentityCode(String code, String phoneNumber) async {
    try {
      final storedCode = _verificationCodes[phoneNumber];
      
      if (storedCode == null) {
        return ValidationResult.invalid('No verification code found');
      }

      // Check expiry
      if (DateTime.now().isAfter(storedCode.expiryTime)) {
        _verificationCodes.remove(phoneNumber);
        return ValidationResult.invalid('Verification code expired');
      }

      // Check attempts
      if (storedCode.attempts >= 3) {
        _verificationCodes.remove(phoneNumber);
        _failedAttempts[phoneNumber] = (_failedAttempts[phoneNumber] ?? 0) + 1;
        return ValidationResult.invalid('Too many verification attempts');
      }

      // Verify code
      if (storedCode.code != code) {
        storedCode.attempts++;
        return ValidationResult.invalid('Invalid verification code');
      }

      // Success - remove code and reset attempts
      _verificationCodes.remove(phoneNumber);
      _failedAttempts.remove(phoneNumber);
      
      return ValidationResult.valid();
    } catch (e) {
      return ValidationResult.invalid('Verification error: $e');
    }
  }

  /// Validate password strength with advanced criteria
  Future<ValidationResult> validatePasswordStrength(String password) async {
    try {
      final issues = <String>[];

      // Length check
      if (password.length < _minPasswordLength) {
        issues.add('Password must be at least $_minPasswordLength characters');
      }

      // Character variety checks
      if (!password.contains(RegExp(r'[A-Z]'))) {
        issues.add('Password must contain uppercase letters');
      }

      if (!password.contains(RegExp(r'[a-z]'))) {
        issues.add('Password must contain lowercase letters');
      }

      if (!password.contains(RegExp(r'[0-9]'))) {
        issues.add('Password must contain numbers');
      }

      if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        issues.add('Password must contain special characters');
      }

      // Common password checks
      if (await _isCommonPassword(password)) {
        issues.add('Password is too common');
      }

      // Sequential character checks
      if (_hasSequentialCharacters(password)) {
        issues.add('Password contains sequential characters');
      }

      // Repeated character checks
      if (_hasRepeatedCharacters(password)) {
        issues.add('Password has too many repeated characters');
      }

      if (issues.isNotEmpty) {
        return ValidationResult.invalid(issues.join('. '));
      }

      return ValidationResult.valid();
    } catch (e) {
      return ValidationResult.invalid('Password validation error: $e');
    }
  }

  /// Hash password with advanced security
  Future<String> hashPassword(String password, String phoneNumber) async {
    try {
      // Generate unique salt using phone number and timestamp
      final saltInput = '$phoneNumber${DateTime.now().millisecondsSinceEpoch}';
      final salt = sha256.convert(utf8.encode(saltInput)).toString();
      
      // Use PBKDF2 with high iteration count
      const iterations = 100000;
      final passwordBytes = utf8.encode(password);
      final saltBytes = utf8.encode(salt);

      // Simulate PBKDF2 (in production, use proper PBKDF2 implementation)
      var hash = Uint8List.fromList(passwordBytes);
      for (int i = 0; i < iterations; i++) {
        hash = Uint8List.fromList(sha256.convert([...hash, ...saltBytes]).bytes);
      }
      
      final hashedPassword = base64.encode(hash);
      
      // Store salt with hash (in production, store securely)
      return '$salt:$hashedPassword';
    } catch (e) {
      throw SecurityException('Password hashing failed: $e');
    }
  }

  /// Generate secure session for registration process
  Future<String> generateRegistrationSession(
    Map<String, dynamic> registrationData,
    int securityLevel,
  ) async {
    try {
      final sessionData = {
        'registrationData': registrationData,
        'securityLevel': securityLevel,
        'timestamp': DateTime.now().toIso8601String(),
        'deviceFingerprint': await _securityService.getDeviceFingerprint(),
        'sessionId': _generateSecureSessionId(),
      };

      // Encrypt session data
      final sessionJson = jsonEncode(sessionData);
      final encryptedSession = await _securityService.encryptData(sessionJson);
      
      return base64.encode(utf8.encode(encryptedSession));
    } catch (e) {
      throw SecurityException('Session generation failed: $e');
    }
  }

  /// Send welcome messages after successful registration
  Future<void> sendWelcomeMessages({
    required String phoneNumber,
    required String userName,
    String? email,
  }) async {
    try {
      // Send welcome SMS
      final smsResult = await _communicationService.sendWelcomeSms(
        phoneNumber: phoneNumber,
        userName: userName,
      );

      if (smsResult.success) {
        debugPrint('✅ Welcome SMS sent to $phoneNumber');
      } else {
        debugPrint('⚠️ Welcome SMS failed: ${smsResult.error}');
      }

      // Send welcome email if provided
      if (email != null && email.isNotEmpty) {
        final emailResult = await _communicationService.sendWelcomeEmail(
          email: email,
          userName: userName,
        );

        if (emailResult.success) {
          debugPrint('✅ Welcome email sent to $email');
        } else {
          debugPrint('⚠️ Welcome email failed: ${emailResult.error}');
        }
      }
    } catch (e) {
      debugPrint('⚠️ Welcome messages error: $e');
      // Don't throw error for welcome messages - they're not critical
    }
  }

  // Private helper methods
  bool _isValidPhoneFormat(String phoneNumber) {
    // Kenyan phone number format: +254XXXXXXXXX
    final regex = RegExp(r'^\+254[17]\d{8}$');
    return regex.hasMatch(phoneNumber);
  }

  Future<bool> _checkPhoneNumberExists(String phoneNumber) async {
    // Simulate database check
    await Future.delayed(const Duration(milliseconds: 500));
    
    // In production, check against user database
    final existingNumbers = ['+254712345678', '+254787654321'];
    return existingNumbers.contains(phoneNumber);
  }

  Future<bool> _isPhoneNumberBlacklisted(String phoneNumber) async {
    // Simulate blacklist check
    await Future.delayed(const Duration(milliseconds: 200));
    
    // In production, check against blacklist database
    final blacklistedNumbers = ['+254700000000'];
    return blacklistedNumbers.contains(phoneNumber);
  }

  String _generateSecureCode() {
    final random = Random.secure();
    final code = List.generate(_verificationCodeLength, 
        (index) => random.nextInt(10)).join();
    return code;
  }

  String _generateSecureSessionId() {
    final random = Random.secure();
    final bytes = List.generate(32, (index) => random.nextInt(256));
    return base64.encode(bytes);
  }

  Future<bool> _isCommonPassword(String password) async {
    // Check against common passwords list
    final commonPasswords = [
      'password123456789',
      'admin123456789',
      'qwerty123456789',
      '123456789012345',
    ];
    
    return commonPasswords.contains(password.toLowerCase());
  }

  bool _hasSequentialCharacters(String password) {
    for (int i = 0; i < password.length - 2; i++) {
      final char1 = password.codeUnitAt(i);
      final char2 = password.codeUnitAt(i + 1);
      final char3 = password.codeUnitAt(i + 2);
      
      if (char2 == char1 + 1 && char3 == char2 + 1) {
        return true;
      }
    }
    return false;
  }

  bool _hasRepeatedCharacters(String password) {
    final charCount = <String, int>{};
    for (final char in password.split('')) {
      charCount[char] = (charCount[char] ?? 0) + 1;
    }
    
    // Check if any character appears more than 3 times
    return charCount.values.any((count) => count > 3);
  }
}

// Result classes
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  ValidationResult._(this.isValid, this.errorMessage);

  factory ValidationResult.valid() => ValidationResult._(true, null);
  factory ValidationResult.invalid(String message) => ValidationResult._(false, message);
}

class VerificationResult {
  final bool success;
  final String message;

  VerificationResult._(this.success, this.message);

  factory VerificationResult.success(String message) => VerificationResult._(true, message);
  factory VerificationResult.failed(String message) => VerificationResult._(false, message);
}

class VerificationCode {
  final String code;
  final String phoneNumber;
  final DateTime expiryTime;
  int attempts;

  VerificationCode({
    required this.code,
    required this.phoneNumber,
    required this.expiryTime,
    this.attempts = 0,
  });
}

class SecurityException implements Exception {
  final String message;
  SecurityException(this.message);
  
  @override
  String toString() => 'SecurityException: $message';
}
