import 'package:flutter/foundation.dart';

class AppConfig extends ChangeNotifier {
  static AppConfig? _instance;
  static AppConfig get instance => _instance ??= AppConfig._();
  
  AppConfig._();
  
  // Environment configuration
  static const String _baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:3000/api',
  );
  
  static const bool _isProduction = bool.fromEnvironment(
    'PRODUCTION',
    defaultValue: false,
  );
  
  static const String _apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: '',
  );
  
  // Getters
  String get baseUrl => _baseUrl;
  bool get isProduction => _isProduction;
  bool get isDevelopment => !_isProduction;
  String get apiKey => _apiKey;
  
  // App settings
  bool _isDarkMode = false;
  String _selectedLanguage = 'sw';
  bool _isOfflineMode = false;
  
  // Getters for app settings
  bool get isDarkMode => _isDarkMode;
  String get selectedLanguage => _selectedLanguage;
  bool get isOfflineMode => _isOfflineMode;
  
  // Setters for app settings
  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
  
  void setLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }
  
  void setOfflineMode(bool value) {
    _isOfflineMode = value;
    notifyListeners();
  }
  
  // API endpoints
  String get authEndpoint => '$baseUrl/auth';
  String get usersEndpoint => '$baseUrl/users';
  String get vetsEndpoint => '$baseUrl/matching';
  String get communicationEndpoint => '$baseUrl/communication';
  String get aiDiagnosticsEndpoint => '$baseUrl/ai-diagnostics';
  String get marketplaceEndpoint => '$baseUrl/marketplace';
  String get farmManagementEndpoint => '$baseUrl/farm-management';
  String get paymentsEndpoint => '$baseUrl/payments';
  String get notificationsEndpoint => '$baseUrl/notifications';
  String get communityEndpoint => '$baseUrl/community';
  
  // Feature flags
  bool get isUSSDEnabled => true;
  bool get isMPesaEnabled => true;
  bool get isWhatsAppEnabled => true;
  bool get isVoiceAssistantEnabled => true;
  bool get isOfflineSyncEnabled => true;
  bool get isAIEnabled => true;
  
  // App metadata
  String get appName => 'KaziApp';
  String get appVersion => '1.0.0';
  String get appBuildNumber => '1';
  
  // Logging
  bool get enableLogging => isDevelopment;
  bool get enableCrashReporting => isProduction;
  
  @override
  String toString() {
    return 'AppConfig{baseUrl: $baseUrl, isProduction: $isProduction, selectedLanguage: $selectedLanguage}';
  }
}
