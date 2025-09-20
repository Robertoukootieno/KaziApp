import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class UserProfileService {
  static const String _profileKey = 'user_profile';
  static const String _authTokenKey = 'auth_token';
  static const String _isLoggedInKey = 'is_logged_in';

  static UserProfileService? _instance;
  static UserProfileService get instance => _instance ??= UserProfileService._();
  UserProfileService._();

  UserProfile? _currentProfile;
  UserProfile? get currentProfile => _currentProfile;

  // Initialize service and load saved profile
  Future<void> initialize() async {
    await _loadSavedProfile();
  }

  // Create profile from registration data
  Future<UserProfile> createProfile({
    required String email,
    required UserProfileType profileType,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? location,
    String? county,
    String? subCounty,
    String? serviceType,
    String? serviceTypeName,
    List<String>? serviceCategories,
    String? experience,
    String? servicesOffered,
    BusinessInformation? businessInfo,
    Map<String, dynamic>? additionalData,
  }) async {
    final now = DateTime.now();
    final profile = UserProfile(
      id: _generateUserId(),
      profileType: profileType,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      location: location,
      county: county,
      subCounty: subCounty,
      serviceType: serviceType,
      serviceTypeName: serviceTypeName,
      serviceCategories: serviceCategories ?? [],
      experience: experience,
      servicesOffered: servicesOffered,
      businessInfo: businessInfo,
      createdAt: now,
      updatedAt: now,
      lastLoginAt: now,
      profileCompletionPercentage: _calculateCompletionPercentage(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        location: location,
        county: county,
        serviceType: serviceType,
        experience: experience,
        servicesOffered: servicesOffered,
        businessInfo: businessInfo,
      ),
    );

    await _saveProfile(profile);
    _currentProfile = profile;
    await _setLoggedIn(true);
    
    return profile;
  }

  // Update existing profile
  Future<UserProfile> updateProfile(UserProfile updatedProfile) async {
    final profile = updatedProfile.copyWith(
      updatedAt: DateTime.now(),
      profileCompletionPercentage: _calculateCompletionPercentage(
        firstName: updatedProfile.firstName,
        lastName: updatedProfile.lastName,
        phoneNumber: updatedProfile.phoneNumber,
        location: updatedProfile.location,
        county: updatedProfile.county,
        serviceType: updatedProfile.serviceType,
        experience: updatedProfile.experience,
        servicesOffered: updatedProfile.servicesOffered,
        businessInfo: updatedProfile.businessInfo,
      ),
    );

    await _saveProfile(profile);
    _currentProfile = profile;
    
    return profile;
  }

  // Update profile image
  Future<UserProfile> updateProfileImage(String imageUrl) async {
    if (_currentProfile == null) throw Exception('No profile found');
    
    final updatedProfile = _currentProfile!.copyWith(
      profileImageUrl: imageUrl,
      updatedAt: DateTime.now(),
    );
    
    return await updateProfile(updatedProfile);
  }

  // Update notification preferences
  Future<UserProfile> updateNotificationPreferences(NotificationPreferences preferences) async {
    if (_currentProfile == null) throw Exception('No profile found');
    
    final updatedProfile = _currentProfile!.copyWith(
      notificationPreferences: preferences,
      updatedAt: DateTime.now(),
    );
    
    return await updateProfile(updatedProfile);
  }

  // Update privacy settings
  Future<UserProfile> updatePrivacySettings(PrivacySettings settings) async {
    if (_currentProfile == null) throw Exception('No profile found');
    
    final updatedProfile = _currentProfile!.copyWith(
      privacySettings: settings,
      updatedAt: DateTime.now(),
    );
    
    return await updateProfile(updatedProfile);
  }

  // Update business information
  Future<UserProfile> updateBusinessInformation(BusinessInformation businessInfo) async {
    if (_currentProfile == null) throw Exception('No profile found');
    
    final updatedProfile = _currentProfile!.copyWith(
      businessInfo: businessInfo,
      updatedAt: DateTime.now(),
    );
    
    return await updateProfile(updatedProfile);
  }

  // Login with existing profile
  Future<UserProfile?> login(String email, String password) async {
    // In a real app, this would authenticate with a backend
    // For now, we'll simulate login by loading saved profile
    await _loadSavedProfile();
    
    if (_currentProfile?.email == email) {
      final updatedProfile = _currentProfile!.copyWith(
        lastLoginAt: DateTime.now(),
      );
      await updateProfile(updatedProfile);
      await _setLoggedIn(true);
      return _currentProfile;
    }
    
    return null;
  }

  // Logout
  Future<void> logout() async {
    await _setLoggedIn(false);
    await _clearAuthToken();
    _currentProfile = null;
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Get profile completion percentage
  double getProfileCompletionPercentage() {
    if (_currentProfile == null) return 0.0;
    return _currentProfile!.profileCompletionPercentage;
  }

  // Check if profile is complete
  bool isProfileComplete() {
    if (_currentProfile == null) return false;
    return _currentProfile!.profileCompletionPercentage >= 80.0;
  }

  // Get missing profile fields
  List<String> getMissingProfileFields() {
    if (_currentProfile == null) return [];
    
    final missing = <String>[];
    
    if (_currentProfile!.firstName == null || _currentProfile!.firstName!.isEmpty) {
      missing.add('First Name');
    }
    if (_currentProfile!.lastName == null || _currentProfile!.lastName!.isEmpty) {
      missing.add('Last Name');
    }
    if (_currentProfile!.phoneNumber == null || _currentProfile!.phoneNumber!.isEmpty) {
      missing.add('Phone Number');
    }
    if (_currentProfile!.location == null || _currentProfile!.location!.isEmpty) {
      missing.add('Location');
    }
    if (_currentProfile!.bio == null || _currentProfile!.bio!.isEmpty) {
      missing.add('Bio');
    }
    if (_currentProfile!.profileImageUrl == null) {
      missing.add('Profile Picture');
    }
    
    if (_currentProfile!.isBusinessProfile && _currentProfile!.businessInfo != null) {
      final businessInfo = _currentProfile!.businessInfo!;
      if (businessInfo.businessName == null || businessInfo.businessName!.isEmpty) {
        missing.add('Business Name');
      }
      if (businessInfo.businessAddress == null || businessInfo.businessAddress!.isEmpty) {
        missing.add('Business Address');
      }
    }
    
    return missing;
  }

  // Private methods
  Future<void> _saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  Future<void> _loadSavedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_profileKey);
    
    if (profileJson != null) {
      try {
        final profileData = jsonDecode(profileJson);
        _currentProfile = UserProfile.fromJson(profileData);
      } catch (e) {
        // Handle parsing error
        print('Error loading profile: $e');
      }
    }
  }

  Future<void> _setLoggedIn(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  Future<void> _clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
  }

  String _generateUserId() {
    // In a real app, this would come from the backend
    return 'user_${DateTime.now().millisecondsSinceEpoch}';
  }

  double _calculateCompletionPercentage({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? location,
    String? county,
    String? serviceType,
    String? experience,
    String? servicesOffered,
    BusinessInformation? businessInfo,
  }) {
    int completedFields = 0;
    int totalFields = 8; // Base fields: firstName, lastName, phone, location, county, serviceType, experience, servicesOffered

    if (firstName != null && firstName.isNotEmpty) completedFields++;
    if (lastName != null && lastName.isNotEmpty) completedFields++;
    if (phoneNumber != null && phoneNumber.isNotEmpty) completedFields++;
    if (location != null && location.isNotEmpty) completedFields++;
    if (county != null && county.isNotEmpty) completedFields++;
    if (serviceType != null && serviceType.isNotEmpty) completedFields++;
    if (experience != null && experience.isNotEmpty) completedFields++;
    if (servicesOffered != null && servicesOffered.isNotEmpty) completedFields++;

    // Add business-specific fields if it's a business profile
    if (businessInfo != null) {
      totalFields += 6; // businessName, businessAddress, businessPhone, description, businessLicense, taxPin
      if (businessInfo.businessName != null && businessInfo.businessName!.isNotEmpty) {
        completedFields++;
      }
      if (businessInfo.businessAddress != null && businessInfo.businessAddress!.isNotEmpty) {
        completedFields++;
      }
      if (businessInfo.businessPhone != null && businessInfo.businessPhone!.isNotEmpty) {
        completedFields++;
      }
      if (businessInfo.description != null && businessInfo.description!.isNotEmpty) {
        completedFields++;
      }
      if (businessInfo.businessLicense != null && businessInfo.businessLicense!.isNotEmpty) {
        completedFields++;
      }
      if (businessInfo.taxPin != null && businessInfo.taxPin!.isNotEmpty) {
        completedFields++;
      }
    }

    return (completedFields / totalFields * 100).clamp(0.0, 100.0);
  }

  // Clear all profile data (for testing or account deletion)
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
    await prefs.remove(_authTokenKey);
    await prefs.remove(_isLoggedInKey);
    _currentProfile = null;
  }
}
