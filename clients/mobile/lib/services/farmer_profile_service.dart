import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/farmer_profile.dart';

class FarmerProfileService {
  static final FarmerProfileService _instance = FarmerProfileService._internal();
  factory FarmerProfileService() => _instance;
  FarmerProfileService._internal();

  static const String _profileKey = 'farmer_profile';
  static const String _preferencesKey = 'farmer_preferences';
  
  FarmerProfile? _currentProfile;
  FarmerPreferences? _currentPreferences;

  // Initialize service and load existing profile
  Future<void> initialize() async {
    try {
      await _loadProfile();
      await _loadPreferences();
      debugPrint('Farmer profile service initialized');
    } catch (e) {
      debugPrint('Error initializing farmer profile service: $e');
    }
  }

  // Create new farmer profile
  Future<void> createProfile({
    required String name,
    required String phone,
    required String farmName,
    required String location,
    required String county,
    required String farmingType,
    required String experienceLevel,
    required double farmSize,
    required List<String> crops,
    required List<String> livestock,
    required String language,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final profile = FarmerProfile(
        id: _generateFarmerId(),
        name: name,
        phone: phone,
        farmName: farmName,
        location: location,
        county: county,
        farmingType: farmingType,
        experienceLevel: experienceLevel,
        farmSize: farmSize,
        crops: crops,
        livestock: livestock,
        language: language,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        additionalData: additionalData ?? {},
      );

      await _saveProfile(profile);
      _currentProfile = profile;
      
      debugPrint('Farmer profile created successfully: ${profile.id}');
    } catch (e) {
      debugPrint('Error creating farmer profile: $e');
      throw Exception('Failed to create farmer profile: $e');
    }
  }

  // Update existing profile
  Future<void> updateProfile(Map<String, dynamic> updates) async {
    try {
      if (_currentProfile == null) {
        throw Exception('No profile to update');
      }

      final updatedProfile = _currentProfile!.copyWith(
        name: updates['name'] ?? _currentProfile!.name,
        phone: updates['phone'] ?? _currentProfile!.phone,
        farmName: updates['farmName'] ?? _currentProfile!.farmName,
        location: updates['location'] ?? _currentProfile!.location,
        county: updates['county'] ?? _currentProfile!.county,
        farmingType: updates['farmingType'] ?? _currentProfile!.farmingType,
        experienceLevel: updates['experienceLevel'] ?? _currentProfile!.experienceLevel,
        farmSize: updates['farmSize'] ?? _currentProfile!.farmSize,
        crops: updates['crops'] ?? _currentProfile!.crops,
        livestock: updates['livestock'] ?? _currentProfile!.livestock,
        language: updates['language'] ?? _currentProfile!.language,
        updatedAt: DateTime.now(),
        additionalData: {
          ..._currentProfile!.additionalData,
          if (updates['additionalData'] != null) ...updates['additionalData'],
        },
      );

      await _saveProfile(updatedProfile);
      _currentProfile = updatedProfile;
      
      debugPrint('Farmer profile updated successfully');
    } catch (e) {
      debugPrint('Error updating farmer profile: $e');
      throw Exception('Failed to update farmer profile: $e');
    }
  }

  // Save farmer preferences
  Future<void> savePreferences({
    required List<String> selectedServices,
    required Map<String, bool> notificationSettings,
    required String preferredLanguage,
    required String theme,
    Map<String, dynamic>? customSettings,
  }) async {
    try {
      final preferences = FarmerPreferences(
        selectedServices: selectedServices,
        notificationSettings: notificationSettings,
        preferredLanguage: preferredLanguage,
        theme: theme,
        customSettings: customSettings ?? {},
        updatedAt: DateTime.now(),
      );

      await _savePreferences(preferences);
      _currentPreferences = preferences;
      
      debugPrint('Farmer preferences saved successfully');
    } catch (e) {
      debugPrint('Error saving farmer preferences: $e');
      throw Exception('Failed to save farmer preferences: $e');
    }
  }

  // Get personalized recommendations based on profile
  List<String> getPersonalizedRecommendations() {
    if (_currentProfile == null) return [];

    final recommendations = <String>[];
    
    // Farming type specific recommendations
    switch (_currentProfile!.farmingType) {
      case 'Livestock Farming':
        recommendations.addAll([
          'Check out our AI-powered livestock disease diagnosis',
          'Connect with veterinarians in your area',
          'Track your animal health records digitally',
        ]);
        break;
      case 'Crop Farming':
        recommendations.addAll([
          'Get weather alerts for your crops',
          'Monitor market prices for your produce',
          'Access crop disease identification tools',
        ]);
        break;
      case 'Mixed Farming':
        recommendations.addAll([
          'Optimize your farm with our comprehensive dashboard',
          'Balance crop and livestock management',
          'Access both plant and animal health services',
        ]);
        break;
    }

    // Experience level recommendations
    if (_currentProfile!.experienceLevel.contains('Beginner')) {
      recommendations.addAll([
        'Start with our farming basics tutorial',
        'Join the beginner farmers community',
        'Get personalized farming tips',
      ]);
    }

    // Location-based recommendations
    if (_currentProfile!.county.isNotEmpty) {
      recommendations.add('Connect with farmers in ${_currentProfile!.county}');
      recommendations.add('Get local weather updates for ${_currentProfile!.county}');
    }

    return recommendations;
  }

  // Get customized app features based on profile
  Map<String, bool> getCustomizedFeatures() {
    if (_currentProfile == null) return {};

    final features = <String, bool>{};
    
    // Enable features based on farming type
    features['aiDiagnosis'] = _currentProfile!.livestock.isNotEmpty;
    features['cropMonitoring'] = _currentProfile!.crops.isNotEmpty;
    features['weatherAlerts'] = true;
    features['marketPrices'] = _currentProfile!.crops.isNotEmpty;
    features['vetServices'] = _currentProfile!.livestock.isNotEmpty;
    features['communityForum'] = true;
    features['farmRecords'] = true;
    features['financialServices'] = _currentProfile!.farmSize > 1.0;

    return features;
  }

  // Generate farmer statistics
  Map<String, dynamic> getFarmerStats() {
    if (_currentProfile == null) return {};

    return {
      'profileCompleteness': _calculateProfileCompleteness(),
      'farmingExperience': _currentProfile!.experienceLevel,
      'farmSize': _currentProfile!.farmSize,
      'diversityScore': _calculateDiversityScore(),
      'memberSince': _currentProfile!.createdAt.toIso8601String(),
      'lastUpdated': _currentProfile!.updatedAt.toIso8601String(),
    };
  }

  // Private helper methods
  Future<void> _loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(_profileKey);
      
      if (profileJson != null) {
        final profileMap = jsonDecode(profileJson);
        _currentProfile = FarmerProfile.fromJson(profileMap);
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }
  }

  Future<void> _saveProfile(FarmerProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = jsonEncode(profile.toJson());
      await prefs.setString(_profileKey, profileJson);
    } catch (e) {
      debugPrint('Error saving profile: $e');
      throw Exception('Failed to save profile');
    }
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final preferencesJson = prefs.getString(_preferencesKey);
      
      if (preferencesJson != null) {
        final preferencesMap = jsonDecode(preferencesJson);
        _currentPreferences = FarmerPreferences.fromJson(preferencesMap);
      }
    } catch (e) {
      debugPrint('Error loading preferences: $e');
    }
  }

  Future<void> _savePreferences(FarmerPreferences preferences) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final preferencesJson = jsonEncode(preferences.toJson());
      await prefs.setString(_preferencesKey, preferencesJson);
    } catch (e) {
      debugPrint('Error saving preferences: $e');
      throw Exception('Failed to save preferences');
    }
  }

  String _generateFarmerId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'FARMER_$random';
  }

  double _calculateProfileCompleteness() {
    if (_currentProfile == null) return 0.0;
    
    int completedFields = 0;
    int totalFields = 11;
    
    if (_currentProfile!.name.isNotEmpty) completedFields++;
    if (_currentProfile!.phone.isNotEmpty) completedFields++;
    if (_currentProfile!.farmName.isNotEmpty) completedFields++;
    if (_currentProfile!.location.isNotEmpty) completedFields++;
    if (_currentProfile!.county.isNotEmpty) completedFields++;
    if (_currentProfile!.farmingType.isNotEmpty) completedFields++;
    if (_currentProfile!.experienceLevel.isNotEmpty) completedFields++;
    if (_currentProfile!.farmSize > 0) completedFields++;
    if (_currentProfile!.crops.isNotEmpty) completedFields++;
    if (_currentProfile!.livestock.isNotEmpty) completedFields++;
    if (_currentProfile!.language.isNotEmpty) completedFields++;
    
    return (completedFields / totalFields) * 100;
  }

  int _calculateDiversityScore() {
    if (_currentProfile == null) return 0;
    
    int score = 0;
    score += _currentProfile!.crops.length * 2;
    score += _currentProfile!.livestock.length * 3;
    
    if (_currentProfile!.farmingType == 'Mixed Farming') score += 10;
    if (_currentProfile!.farmSize > 5.0) score += 5;
    
    return score;
  }

  // Getters
  FarmerProfile? get currentProfile => _currentProfile;
  FarmerPreferences? get currentPreferences => _currentPreferences;
  bool get hasProfile => _currentProfile != null;
  bool get hasPreferences => _currentPreferences != null;
}
