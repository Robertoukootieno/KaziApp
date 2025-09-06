class AppConstants {
  // App Information
  static const String appName = 'KaziApp Admin';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Administrative dashboard for KaziApp agricultural platform';
  
  // API Configuration
  static const String baseUrl = 'http://localhost:3000/api';
  static const String adminApiUrl = '$baseUrl/admin';
  static const String userApiUrl = '$baseUrl/users';
  static const String analyticsApiUrl = '$baseUrl/analytics';
  
  // Storage Keys
  static const String authTokenKey = 'admin_auth_token';
  static const String refreshTokenKey = 'admin_refresh_token';
  static const String userDataKey = 'admin_user_data';
  static const String themeKey = 'admin_theme_mode';
  
  // Routes
  static const String loginRoute = '/login';
  static const String dashboardRoute = '/dashboard';
  static const String usersRoute = '/users';
  static const String analyticsRoute = '/analytics';
  static const String settingsRoute = '/settings';
  static const String profileRoute = '/profile';
  
  // User Types
  static const String farmerType = 'farmer';
  static const String veterinarianType = 'veterinarian';
  static const String buyerType = 'buyer';
  static const String vendorType = 'vendor';
  static const String adminType = 'admin';
  
  // Admin Roles
  static const String superAdminRole = 'super_admin';
  static const String systemAdminRole = 'system_admin';
  static const String contentManagerRole = 'content_manager';
  static const String supportAdminRole = 'support_admin';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 8.0;
  
  // Colors (Material Design 3)
  static const int primaryColorValue = 0xFF2E7D32; // Green for agriculture
  static const int secondaryColorValue = 0xFF1976D2; // Blue for technology
  static const int errorColorValue = 0xFFD32F2F;
  static const int warningColorValue = 0xFFF57C00;
  static const int successColorValue = 0xFF388E3C;
  
  // Breakpoints for responsive design
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;
  
  // Chart Colors
  static const List<int> chartColors = [
    0xFF2E7D32, // Primary Green
    0xFF1976D2, // Blue
    0xFFF57C00, // Orange
    0xFF7B1FA2, // Purple
    0xFFD32F2F, // Red
    0xFF388E3C, // Success Green
    0xFF0097A7, // Cyan
    0xFF5D4037, // Brown
  ];
  
  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx', 'xls', 'xlsx'];
  
  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayDateTimeFormat = 'MMM dd, yyyy HH:mm';
  
  // Languages
  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'sw': 'Kiswahili',
    'ki': 'Kikuyu',
    'luo': 'Luo',
    'kln': 'Kalenjin',
    'so': 'Somali',
  };
  
  // Counties in Kenya
  static const List<String> kenyanCounties = [
    'Baringo', 'Bomet', 'Bungoma', 'Busia', 'Elgeyo-Marakwet', 'Embu',
    'Garissa', 'Homa Bay', 'Isiolo', 'Kajiado', 'Kakamega', 'Kericho',
    'Kiambu', 'Kilifi', 'Kirinyaga', 'Kisii', 'Kisumu', 'Kitui',
    'Kwale', 'Laikipia', 'Lamu', 'Machakos', 'Makueni', 'Mandera',
    'Marsabit', 'Meru', 'Migori', 'Mombasa', 'Murang\'a', 'Nairobi',
    'Nakuru', 'Nandi', 'Narok', 'Nyamira', 'Nyandarua', 'Nyeri',
    'Samburu', 'Siaya', 'Taita-Taveta', 'Tana River', 'Tharaka-Nithi',
    'Trans Nzoia', 'Turkana', 'Uasin Gishu', 'Vihiga', 'Wajir', 'West Pokot'
  ];
}
