import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// User Profile Service for managing user data and profile information
class UserProfileService {
  static final UserProfileService _instance = UserProfileService._internal();
  factory UserProfileService() => _instance;
  UserProfileService._internal();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _userProfileKey = 'user_profile';
  static const String _farmDataKey = 'farm_data';
  static const String _securityDataKey = 'security_data';

  UserProfile? _currentUser;
  FarmData? _farmData;
  SecurityData? _securityData;
  bool _isInitialized = false;

  /// Initialize the user profile service (lazy loading)
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Load data in parallel for faster initialization
      await Future.wait([
        _loadUserProfile(),
        _loadFarmData(),
        _loadSecurityData(),
      ]);

      _isInitialized = true;
      debugPrint('👤 User Profile Service initialized');
    } catch (e) {
      debugPrint('❌ Failed to initialize User Profile Service: $e');
      // Don't throw error, allow app to continue
    }
  }

  /// Ensure service is initialized before use
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  /// Get current user profile
  UserProfile? get currentUser => _currentUser;

  /// Get farm data
  FarmData? get farmData => _farmData;

  /// Get security data
  SecurityData? get securityData => _securityData;

  /// Check if user is logged in
  bool get isLoggedIn => _currentUser != null;

  /// Save user profile after registration/login
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      _currentUser = profile;
      final profileJson = jsonEncode(profile.toJson());
      await _storage.write(key: _userProfileKey, value: profileJson);
      debugPrint('✅ User profile saved: ${profile.fullName}');
    } catch (e) {
      debugPrint('❌ Failed to save user profile: $e');
      throw Exception('Failed to save user profile: $e');
    }
  }

  /// Save farm data
  Future<void> saveFarmData(FarmData farmData) async {
    try {
      _farmData = farmData;
      final farmJson = jsonEncode(farmData.toJson());
      await _storage.write(key: _farmDataKey, value: farmJson);
      debugPrint('✅ Farm data saved: ${farmData.farmName}');
    } catch (e) {
      debugPrint('❌ Failed to save farm data: $e');
      throw Exception('Failed to save farm data: $e');
    }
  }

  /// Save security data
  Future<void> saveSecurityData(SecurityData securityData) async {
    try {
      _securityData = securityData;
      final securityJson = jsonEncode(securityData.toJson());
      await _storage.write(key: _securityDataKey, value: securityJson);
      debugPrint('✅ Security data saved');
    } catch (e) {
      debugPrint('❌ Failed to save security data: $e');
      throw Exception('Failed to save security data: $e');
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
    String? county,
    String? preferredLanguage,
  }) async {
    if (_currentUser == null) return;

    final updatedProfile = _currentUser!.copyWith(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      profileImageUrl: profileImageUrl,
      county: county,
      preferredLanguage: preferredLanguage,
      lastUpdated: DateTime.now(),
    );

    await saveUserProfile(updatedProfile);
  }

  /// Update farm data
  Future<void> updateFarmData({
    String? farmName,
    String? farmLocation,
    double? farmSize,
    String? farmingType,
    List<String>? crops,
    List<String>? livestock,
    Map<String, dynamic>? farmHealth,
  }) async {
    if (_farmData == null) return;

    final updatedFarmData = _farmData!.copyWith(
      farmName: farmName,
      farmLocation: farmLocation,
      farmSize: farmSize,
      farmingType: farmingType,
      crops: crops,
      livestock: livestock,
      farmHealth: farmHealth,
      lastUpdated: DateTime.now(),
    );

    await saveFarmData(updatedFarmData);
  }

  /// Get user initials for profile avatar
  String getUserInitials() {
    if (_currentUser?.fullName == null) return 'U';
    
    final names = _currentUser!.fullName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names[0][0].toUpperCase();
    }
    return 'U';
  }

  /// Get profile completion percentage
  int getProfileCompletionPercentage() {
    if (_currentUser == null) return 0;

    int completedFields = 0;
    int totalFields = 8;

    if (_currentUser!.fullName.isNotEmpty) completedFields++;
    if (_currentUser!.email?.isNotEmpty == true) completedFields++;
    if (_currentUser!.phoneNumber.isNotEmpty) completedFields++;
    if (_currentUser!.profileImageUrl?.isNotEmpty == true) completedFields++;
    if (_currentUser!.county?.isNotEmpty == true) completedFields++;
    if (_currentUser!.preferredLanguage?.isNotEmpty == true) completedFields++;
    if (_farmData?.farmName.isNotEmpty == true) completedFields++;
    if (_farmData?.farmLocation.isNotEmpty == true) completedFields++;

    return ((completedFields / totalFields) * 100).round();
  }

  /// Get farm health score
  int getFarmHealthScore() {
    return _farmData?.farmHealth['overallScore'] ?? 75;
  }

  /// Get security level
  int getSecurityLevel() {
    return _securityData?.securityLevel ?? 85;
  }

  /// Load user profile from storage
  Future<void> _loadUserProfile() async {
    try {
      final profileJson = await _storage.read(key: _userProfileKey);
      if (profileJson != null) {
        final profileData = jsonDecode(profileJson);
        _currentUser = UserProfile.fromJson(profileData);
        debugPrint('✅ User profile loaded: ${_currentUser!.fullName}');
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load user profile: $e');
    }
  }

  /// Load farm data from storage
  Future<void> _loadFarmData() async {
    try {
      final farmJson = await _storage.read(key: _farmDataKey);
      if (farmJson != null) {
        final farmData = jsonDecode(farmJson);
        _farmData = FarmData.fromJson(farmData);
        debugPrint('✅ Farm data loaded: ${_farmData!.farmName}');
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load farm data: $e');
    }
  }

  /// Load security data from storage
  Future<void> _loadSecurityData() async {
    try {
      final securityJson = await _storage.read(key: _securityDataKey);
      if (securityJson != null) {
        final securityData = jsonDecode(securityJson);
        _securityData = SecurityData.fromJson(securityData);
        debugPrint('✅ Security data loaded');
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load security data: $e');
    }
  }

  /// Clear all user data (logout)
  Future<void> clearUserData() async {
    try {
      await _storage.delete(key: _userProfileKey);
      await _storage.delete(key: _farmDataKey);
      await _storage.delete(key: _securityDataKey);
      
      _currentUser = null;
      _farmData = null;
      _securityData = null;
      
      debugPrint('✅ User data cleared');
    } catch (e) {
      debugPrint('❌ Failed to clear user data: $e');
    }
  }

  /// Create user profile from registration data
  Future<void> createUserProfileFromRegistration(Map<String, dynamic> registrationData) async {
    try {
      // Create user profile
      final userProfile = UserProfile(
        id: registrationData['userId'] ?? 'offline_${DateTime.now().millisecondsSinceEpoch}',
        fullName: registrationData['fullName'] ?? '',
        email: registrationData['email'],
        phoneNumber: registrationData['phoneNumber'] ?? '',
        county: registrationData['county'],
        preferredLanguage: registrationData['preferredLanguage'] ?? 'en',
        registrationDate: DateTime.now(),
        lastUpdated: DateTime.now(),
        isVerified: registrationData['identityVerified'] ?? false,
        registrationMode: registrationData['registrationStep'] == 'completed' ? 'advanced' : 'basic',
      );

      await saveUserProfile(userProfile);

      // Create farm data if available
      if (registrationData.containsKey('farmName')) {
        final farmData = FarmData(
          farmName: registrationData['farmName'] ?? '',
          farmLocation: registrationData['farmLocation'] ?? '',
          farmSize: registrationData['farmSize'] ?? 0.0,
          farmingType: registrationData['farmingType'] ?? '',
          crops: registrationData['crops'] ?? [],
          livestock: registrationData['livestock'] ?? [],
          farmHealth: {
            'overallScore': 75,
            'soilHealth': 80,
            'cropHealth': 75,
            'livestockHealth': 70,
            'lastAssessment': DateTime.now().toIso8601String(),
          },
          createdAt: DateTime.now(),
          lastUpdated: DateTime.now(),
        );

        await saveFarmData(farmData);
      }

      // Create security data
      final securityData = SecurityData(
        securityLevel: registrationData['securityLevel'] ?? 85,
        deviceFingerprint: registrationData['deviceFingerprint'] ?? '',
        behavioralProgress: (registrationData['behavioralProgress'] as num?)?.toDouble() ?? 0.0,
        threatLevel: 'low',
        lastSecurityCheck: DateTime.now(),
        encryptionEnabled: true,
        biometricsEnabled: registrationData['registrationStep'] == 'completed',
      );

      await saveSecurityData(securityData);

      debugPrint('✅ User profile created from registration data');
    } catch (e) {
      debugPrint('❌ Failed to create user profile from registration: $e');
      throw Exception('Failed to create user profile: $e');
    }
  }
}

// Data Models
class UserProfile {
  final String id;
  final String fullName;
  final String? email;
  final String phoneNumber;
  final String? profileImageUrl;
  final String? county;
  final String? preferredLanguage;
  final DateTime registrationDate;
  final DateTime lastUpdated;
  final bool isVerified;
  final String registrationMode; // 'basic' or 'advanced'

  UserProfile({
    required this.id,
    required this.fullName,
    this.email,
    required this.phoneNumber,
    this.profileImageUrl,
    this.county,
    this.preferredLanguage,
    required this.registrationDate,
    required this.lastUpdated,
    this.isVerified = false,
    this.registrationMode = 'basic',
  });

  UserProfile copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
    String? county,
    String? preferredLanguage,
    DateTime? lastUpdated,
    bool? isVerified,
  }) {
    return UserProfile(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      county: county ?? this.county,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      registrationDate: registrationDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isVerified: isVerified ?? this.isVerified,
      registrationMode: registrationMode,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'email': email,
    'phoneNumber': phoneNumber,
    'profileImageUrl': profileImageUrl,
    'county': county,
    'preferredLanguage': preferredLanguage,
    'registrationDate': registrationDate.toIso8601String(),
    'lastUpdated': lastUpdated.toIso8601String(),
    'isVerified': isVerified,
    'registrationMode': registrationMode,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'],
    fullName: json['fullName'],
    email: json['email'],
    phoneNumber: json['phoneNumber'],
    profileImageUrl: json['profileImageUrl'],
    county: json['county'],
    preferredLanguage: json['preferredLanguage'],
    registrationDate: DateTime.parse(json['registrationDate']),
    lastUpdated: DateTime.parse(json['lastUpdated']),
    isVerified: json['isVerified'] ?? false,
    registrationMode: json['registrationMode'] ?? 'basic',
  );
}

class FarmData {
  final String farmName;
  final String farmLocation;
  final double farmSize;
  final String farmingType;
  final List<String> crops;
  final List<String> livestock;
  final Map<String, dynamic> farmHealth;
  final DateTime createdAt;
  final DateTime lastUpdated;

  FarmData({
    required this.farmName,
    required this.farmLocation,
    required this.farmSize,
    required this.farmingType,
    required this.crops,
    required this.livestock,
    required this.farmHealth,
    required this.createdAt,
    required this.lastUpdated,
  });

  FarmData copyWith({
    String? farmName,
    String? farmLocation,
    double? farmSize,
    String? farmingType,
    List<String>? crops,
    List<String>? livestock,
    Map<String, dynamic>? farmHealth,
    DateTime? lastUpdated,
  }) {
    return FarmData(
      farmName: farmName ?? this.farmName,
      farmLocation: farmLocation ?? this.farmLocation,
      farmSize: farmSize ?? this.farmSize,
      farmingType: farmingType ?? this.farmingType,
      crops: crops ?? this.crops,
      livestock: livestock ?? this.livestock,
      farmHealth: farmHealth ?? this.farmHealth,
      createdAt: createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() => {
    'farmName': farmName,
    'farmLocation': farmLocation,
    'farmSize': farmSize,
    'farmingType': farmingType,
    'crops': crops,
    'livestock': livestock,
    'farmHealth': farmHealth,
    'createdAt': createdAt.toIso8601String(),
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory FarmData.fromJson(Map<String, dynamic> json) => FarmData(
    farmName: json['farmName'],
    farmLocation: json['farmLocation'],
    farmSize: json['farmSize']?.toDouble() ?? 0.0,
    farmingType: json['farmingType'],
    crops: List<String>.from(json['crops'] ?? []),
    livestock: List<String>.from(json['livestock'] ?? []),
    farmHealth: Map<String, dynamic>.from(json['farmHealth'] ?? {}),
    createdAt: DateTime.parse(json['createdAt']),
    lastUpdated: DateTime.parse(json['lastUpdated']),
  );
}

class SecurityData {
  final int securityLevel;
  final String deviceFingerprint;
  final double behavioralProgress; // Changed from int to double for percentage values (0.0 to 1.0)
  final String threatLevel;
  final DateTime lastSecurityCheck;
  final bool encryptionEnabled;
  final bool biometricsEnabled;

  SecurityData({
    required this.securityLevel,
    required this.deviceFingerprint,
    required this.behavioralProgress,
    required this.threatLevel,
    required this.lastSecurityCheck,
    required this.encryptionEnabled,
    required this.biometricsEnabled,
  });

  Map<String, dynamic> toJson() => {
    'securityLevel': securityLevel,
    'deviceFingerprint': deviceFingerprint,
    'behavioralProgress': behavioralProgress,
    'threatLevel': threatLevel,
    'lastSecurityCheck': lastSecurityCheck.toIso8601String(),
    'encryptionEnabled': encryptionEnabled,
    'biometricsEnabled': biometricsEnabled,
  };

  factory SecurityData.fromJson(Map<String, dynamic> json) => SecurityData(
    securityLevel: json['securityLevel'],
    deviceFingerprint: json['deviceFingerprint'],
    behavioralProgress: (json['behavioralProgress'] as num?)?.toDouble() ?? 0.0,
    threatLevel: json['threatLevel'],
    lastSecurityCheck: DateTime.parse(json['lastSecurityCheck']),
    encryptionEnabled: json['encryptionEnabled'],
    biometricsEnabled: json['biometricsEnabled'],
  );
}
