import 'dart:async';

/// Password validation result model
class PasswordValidationResult {
  final bool isValid;
  final double strength; // 0.0 to 1.0
  final List<String> errors;
  final List<String> suggestions;
  final Map<String, bool> criteria;

  const PasswordValidationResult({
    required this.isValid,
    required this.strength,
    required this.errors,
    required this.suggestions,
    required this.criteria,
  });

  factory PasswordValidationResult.invalid(List<String> errors, {
    double strength = 0.0,
    List<String> suggestions = const [],
    Map<String, bool> criteria = const {},
  }) {
    return PasswordValidationResult(
      isValid: false,
      strength: strength,
      errors: errors,
      suggestions: suggestions,
      criteria: criteria,
    );
  }

  factory PasswordValidationResult.valid({
    double strength = 1.0,
    Map<String, bool> criteria = const {},
  }) {
    return PasswordValidationResult(
      isValid: true,
      strength: strength,
      errors: const [],
      suggestions: const [],
      criteria: criteria,
    );
  }
}

/// Comprehensive password validation service for KaziApp Mkulima
class PasswordValidationService {
  static const int _minLength = 8;
  static const int _recommendedLength = 12;
  static const int _maxLength = 128;

  // Common weak passwords (subset for demo)
  static const List<String> _commonPasswords = [
    'password', '123456', '123456789', 'qwerty', 'abc123',
    'password123', 'admin', 'letmein', 'welcome', 'monkey',
    'dragon', 'master', 'shadow', 'football', 'baseball',
    'superman', 'michael', 'jordan', 'harley', 'ranger',
  ];

  /// Validate password with comprehensive criteria
  Future<PasswordValidationResult> validatePassword(String password) async {
    final errors = <String>[];
    final suggestions = <String>[];
    final criteria = <String, bool>{};
    
    // Length validation
    criteria['minLength'] = password.length >= _minLength;
    if (!criteria['minLength']!) {
      errors.add('Password must be at least $_minLength characters long');
      suggestions.add('Add more characters to reach minimum length');
    }

    criteria['maxLength'] = password.length <= _maxLength;
    if (!criteria['maxLength']!) {
      errors.add('Password must not exceed $_maxLength characters');
    }

    // Character variety validation
    criteria['hasUppercase'] = password.contains(RegExp(r'[A-Z]'));
    if (!criteria['hasUppercase']!) {
      errors.add('Password must contain at least one uppercase letter');
      suggestions.add('Add uppercase letters (A-Z)');
    }

    criteria['hasLowercase'] = password.contains(RegExp(r'[a-z]'));
    if (!criteria['hasLowercase']!) {
      errors.add('Password must contain at least one lowercase letter');
      suggestions.add('Add lowercase letters (a-z)');
    }

    criteria['hasNumbers'] = password.contains(RegExp(r'[0-9]'));
    if (!criteria['hasNumbers']!) {
      errors.add('Password must contain at least one number');
      suggestions.add('Add numbers (0-9)');
    }

    criteria['hasSpecialChars'] = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_+=\-\[\]\\\/~`]'));
    if (!criteria['hasSpecialChars']!) {
      errors.add('Password must contain at least one special character');
      suggestions.add('Add special characters (!@#\$%^&*...)');
    }

    // Advanced security checks
    criteria['notCommon'] = !_isCommonPassword(password.toLowerCase());
    if (!criteria['notCommon']!) {
      errors.add('Password is too common and easily guessable');
      suggestions.add('Choose a more unique password');
    }

    criteria['noSequential'] = !_hasSequentialCharacters(password);
    if (!criteria['noSequential']!) {
      errors.add('Password contains sequential characters');
      suggestions.add('Avoid sequences like "123" or "abc"');
    }

    criteria['noRepeated'] = !_hasExcessiveRepeatedCharacters(password);
    if (!criteria['noRepeated']!) {
      errors.add('Password has too many repeated characters');
      suggestions.add('Reduce repeated characters');
    }

    criteria['noPersonalInfo'] = !_containsPersonalInfo(password);
    if (!criteria['noPersonalInfo']!) {
      errors.add('Password should not contain personal information');
      suggestions.add('Avoid using names, birthdays, or phone numbers');
    }

    // Calculate strength score
    final strength = _calculatePasswordStrength(password, criteria);
    
    // Add strength-based suggestions
    if (strength < 0.6) {
      suggestions.add('Consider making your password longer');
      suggestions.add('Mix different types of characters');
    }

    final isValid = errors.isEmpty && strength >= 0.6;

    return PasswordValidationResult(
      isValid: isValid,
      strength: strength,
      errors: errors,
      suggestions: suggestions,
      criteria: criteria,
    );
  }

  /// Validate password confirmation
  PasswordValidationResult validatePasswordConfirmation(String password, String confirmation) {
    if (password != confirmation) {
      return PasswordValidationResult.invalid(
        ['Passwords do not match'],
        suggestions: ['Make sure both password fields are identical'],
      );
    }
    return PasswordValidationResult.valid();
  }

  /// Check if password is in common passwords list
  bool _isCommonPassword(String password) {
    return _commonPasswords.contains(password.toLowerCase());
  }

  /// Check for sequential characters (123, abc, etc.)
  bool _hasSequentialCharacters(String password) {
    final lower = password.toLowerCase();
    for (int i = 0; i < lower.length - 2; i++) {
      final char1 = lower.codeUnitAt(i);
      final char2 = lower.codeUnitAt(i + 1);
      final char3 = lower.codeUnitAt(i + 2);
      
      if (char2 == char1 + 1 && char3 == char2 + 1) {
        return true;
      }
    }
    return false;
  }

  /// Check for excessive repeated characters
  bool _hasExcessiveRepeatedCharacters(String password) {
    final charCount = <String, int>{};
    for (final char in password.split('')) {
      charCount[char] = (charCount[char] ?? 0) + 1;
    }
    
    // Check if any character appears more than 3 times
    return charCount.values.any((count) => count > 3);
  }

  /// Check for personal information patterns
  bool _containsPersonalInfo(String password) {
    final lower = password.toLowerCase();
    
    // Check for common personal info patterns
    final personalPatterns = [
      RegExp(r'(19|20)\d{2}'), // Years
      RegExp(r'\d{4,}'), // Long numbers (could be phone, ID, etc.)
      RegExp(r'(admin|user|name|phone|email)'), // Common field names
    ];
    
    return personalPatterns.any((pattern) => pattern.hasMatch(lower));
  }

  /// Calculate password strength score (0.0 to 1.0)
  double _calculatePasswordStrength(String password, Map<String, bool> criteria) {
    double score = 0.0;
    
    // Base score from criteria (60% of total)
    final criteriaScore = criteria.values.where((met) => met).length / criteria.length;
    score += criteriaScore * 0.6;
    
    // Length bonus (20% of total)
    final lengthScore = (password.length / _recommendedLength).clamp(0.0, 1.0);
    score += lengthScore * 0.2;
    
    // Character variety bonus (20% of total)
    final uniqueChars = password.split('').toSet().length;
    final varietyScore = (uniqueChars / password.length).clamp(0.0, 1.0);
    score += varietyScore * 0.2;
    
    return score.clamp(0.0, 1.0);
  }

  /// Get password strength description
  String getStrengthDescription(double strength) {
    if (strength >= 0.8) return 'Very Strong';
    if (strength >= 0.6) return 'Strong';
    if (strength >= 0.4) return 'Moderate';
    if (strength >= 0.2) return 'Weak';
    return 'Very Weak';
  }

  /// Get strength color for UI
  static const strengthColors = {
    'Very Weak': 0xFFD32F2F,
    'Weak': 0xFFFF5722,
    'Moderate': 0xFFFF9800,
    'Strong': 0xFF4CAF50,
    'Very Strong': 0xFF2E7D32,
  };

  int getStrengthColor(double strength) {
    final description = getStrengthDescription(strength);
    return strengthColors[description] ?? 0xFFD32F2F;
  }
}
