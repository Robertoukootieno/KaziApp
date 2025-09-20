import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/advanced_security_service.dart';
import '../services/zero_trust_auth_service.dart';
import '../services/behavioral_biometrics_service.dart';
import '../services/keycloak_auth_service.dart';
import '../services/registration_security_service.dart';
import '../screens/auth/enhanced_registration_screen.dart';

/// Advanced Registration Widget with Enterprise-Grade Security
/// Now supports hiding security widgets while maintaining all functionality
class AdvancedRegistrationWidget extends StatefulWidget {
  final Function(Map<String, dynamic> registrationData, String sessionToken, int securityLevel) onRegistrationSuccess;
  final Function(String error) onRegistrationFailure;
  final bool enableBiometrics;
  final bool enableBehavioralBiometrics;
  final String registrationStep; // 'basic_info', 'identity_verification', 'password_setup'
  final Map<String, dynamic>? initialData; // Data from previous registration steps
  final bool hideSecurityWidgets; // Hide security UI elements while keeping functionality

  const AdvancedRegistrationWidget({
    super.key,
    required this.onRegistrationSuccess,
    required this.onRegistrationFailure,
    this.enableBiometrics = true,
    this.enableBehavioralBiometrics = true,
    required this.registrationStep,
    this.initialData,
    this.hideSecurityWidgets = false, // Default to showing security widgets
  });

  @override
  State<AdvancedRegistrationWidget> createState() => _AdvancedRegistrationWidgetState();
}

class _AdvancedRegistrationWidgetState extends State<AdvancedRegistrationWidget>
    with TickerProviderStateMixin {
  
  // Services
  final AdvancedSecurityService _securityService = AdvancedSecurityService();
  final ZeroTrustAuthService _authService = ZeroTrustAuthService();
  final BehavioralBiometricsService _behavioralService = BehavioralBiometricsService();
  final KeycloakAuthService _keycloakService = KeycloakAuthService();
  final RegistrationSecurityService _registrationService = RegistrationSecurityService();
  
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _verificationCodeController = TextEditingController();

  // Farm Details Controllers
  final TextEditingController _farmNameController = TextEditingController();
  final TextEditingController _farmLocationController = TextEditingController();
  final TextEditingController _farmSizeController = TextEditingController();
  
  late AnimationController _securityAnimationController;
  late AnimationController _loadingAnimationController;
  late AnimationController _progressAnimationController;
  
  // State
  bool _isLoading = false;
  bool _isInitializing = true; // Track initialization state
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _passwordConfirmed = false; // Track if password has been confirmed
  int _securityLevel = 0;
  double _behavioralProgress = 0.0;
  double _registrationProgress = 0.0;
  List<SecurityIndicator> _securityIndicators = [];
  String? _errorMessage;
  String? _successMessage;

  // Farm Details State
  String _selectedFarmingType = '';
  String _selectedCounty = '';
  final List<String> _selectedCrops = [];
  final List<String> _selectedLivestock = [];
  final Map<String, bool> _selectedServices = {};

  // Registration data
  Map<String, dynamic> _registrationData = {};
  
  // Security tracking
  DateTime? _lastKeyPress;
  int _keystrokeCount = 0;
  final List<double> _keystrokeTimings = [];

  // Farm Details Options
  final List<String> _farmingTypes = [
    'Crop Farming',
    'Livestock Farming',
    'Mixed Farming',
    'Poultry Farming',
    'Dairy Farming',
    'Fish Farming',
    'Horticulture',
    'Agro-forestry',
  ];

  final List<String> _counties = [
    'Nairobi', 'Mombasa', 'Kisumu', 'Nakuru', 'Eldoret', 'Thika', 'Malindi',
    'Kitale', 'Garissa', 'Kakamega', 'Machakos', 'Meru', 'Nyeri', 'Kericho',
    'Embu', 'Migori', 'Bungoma', 'Homa Bay', 'Naivasha', 'Voi'
  ];

  final List<String> _cropOptions = [
    'Maize', 'Beans', 'Rice', 'Wheat', 'Sorghum', 'Millet', 'Cassava',
    'Sweet Potatoes', 'Irish Potatoes', 'Bananas', 'Sugarcane', 'Cotton',
    'Coffee', 'Tea', 'Tomatoes', 'Onions', 'Cabbages', 'Kales', 'Spinach',
    'Carrots', 'Peas', 'French Beans', 'Avocados', 'Mangoes', 'Oranges'
  ];

  final List<String> _livestockOptions = [
    'Cattle', 'Goats', 'Sheep', 'Pigs', 'Chickens', 'Ducks', 'Turkeys',
    'Rabbits', 'Donkeys', 'Camels', 'Fish', 'Bees'
  ];

  final List<String> _experienceLevels = [
    'Beginner (0-2 years)',
    'Intermediate (3-5 years)',
    'Experienced (6-10 years)',
    'Expert (10+ years)',
  ];

  final List<String> _languages = [
    'English', 'Kiswahili', 'Kikuyu', 'Luo', 'Kalenjin', 'Kamba',
  ];

  final Map<String, String> _appServices = {
    'AI Diagnosis': 'Get AI-powered disease diagnosis for your animals',
    'Weather Updates': 'Receive localized weather forecasts and alerts',
    'Market Prices': 'Track commodity prices and find buyers',
    'Vet Services': 'Connect with veterinarians for consultations',
    'Farm Records': 'Digital record keeping for your farm activities',
    'SMS Alerts': 'Receive important notifications via SMS',
  };

  // Additional state variables
  String _selectedExperienceLevel = '';
  String _selectedLanguage = 'English';
  
  @override
  void initState() {
    super.initState();

    // Initialize registration data with any passed initial data
    if (widget.initialData != null) {
      _registrationData = Map<String, dynamic>.from(widget.initialData!);
      debugPrint('🔄 Initialized with registration data: $_registrationData');
    }

    // Initialize selected services
    for (String service in _appServices.keys) {
      _selectedServices[service] = true; // Default all services to selected
    }

    // Initialize animations immediately (lightweight)
    _initializeAnimations();

    // Defer heavy initialization to after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performAsyncInitialization();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _verificationCodeController.dispose();
    _farmNameController.dispose();
    _farmLocationController.dispose();
    _farmSizeController.dispose();
    _securityAnimationController.dispose();
    _loadingAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _securityAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Start with stable initial values instead of repeating animations
    _securityAnimationController.value = 0.0;
    _progressAnimationController.value = 0.0;
  }

  Future<void> _performAsyncInitialization() async {
    try {
      // Show that we're initializing
      if (mounted) {
        setState(() {
          _isInitializing = true;
        });
      }

      // Initialize services in parallel for better performance
      await Future.wait([
        _initializeServices(),
        Future.delayed(const Duration(milliseconds: 50)), // Minimal loading time for smooth UX
      ]);

      // Update UI components after services are ready
      if (mounted) {
        // Defer heavy UI updates to improve perceived performance
        _startBehavioralTracking();

        setState(() {
          _isInitializing = false;
        });

        // Update security indicators after UI is shown (lazy loading)
        Future.microtask(() {
          if (mounted) {
            _updateSecurityIndicators();
          }
        });
      }
    } catch (e) {
      debugPrint('❌ Failed to initialize: $e');
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _errorMessage = 'Failed to initialize security services. Please try again.';
        });
      }
    }
  }

  Future<void> _initializeServices() async {
    try {
      // Initialize services in parallel with timeout for better performance
      await Future.wait([
        _securityService.initialize().timeout(const Duration(seconds: 3)),
        _behavioralService.initialize().timeout(const Duration(seconds: 2)),
        _keycloakService.initialize().timeout(const Duration(seconds: 4)),
        _registrationService.initialize().timeout(const Duration(seconds: 2)),
      ]).timeout(const Duration(seconds: 8)); // Overall timeout

      if (mounted) {
        setState(() {
          _securityLevel = 75; // Base security level for registration
        });

        _securityAnimationController.animateTo(_securityLevel / 100);
      }
    } catch (e) {
      debugPrint('⚠️ Service initialization completed with some issues: $e');
      // Continue with reduced functionality rather than failing completely
      if (mounted) {
        setState(() {
          _securityLevel = 50; // Reduced security level if services fail
        });
      }
    }
  }

  void _startBehavioralTracking() {
    if (widget.enableBehavioralBiometrics) {
      // Start collecting behavioral data during registration
      _behavioralService.startLearning();
    }
  }

  void _updateSecurityIndicators() {
    _securityIndicators = [
      SecurityIndicator(
        icon: Icons.verified_user,
        label: 'Identity Verification',
        status: widget.registrationStep == 'identity_verification' 
            ? SecurityStatus.enabled 
            : SecurityStatus.learning,
        description: 'Multi-step identity verification process',
      ),
      SecurityIndicator(
        icon: Icons.psychology,
        label: 'Behavioral Learning',
        status: widget.enableBehavioralBiometrics ? SecurityStatus.learning : SecurityStatus.disabled,
        description: 'Learning user behavior patterns',
        progress: _behavioralProgress,
      ),
      SecurityIndicator(
        icon: Icons.security,
        label: 'Zero-Trust Security',
        status: SecurityStatus.enabled,
        description: 'Continuous security monitoring',
      ),
      SecurityIndicator(
        icon: Icons.lock,
        label: 'Data Encryption',
        status: SecurityStatus.enabled,
        description: 'AES-256-GCM encryption active',
      ),
      SecurityIndicator(
        icon: Icons.fingerprint,
        label: 'Biometric Setup',
        status: widget.enableBiometrics ? SecurityStatus.learning : SecurityStatus.disabled,
        description: 'Preparing biometric authentication',
      ),
      SecurityIndicator(
        icon: Icons.shield,
        label: 'Threat Detection',
        status: SecurityStatus.enabled,
        description: 'Real-time security threat monitoring',
      ),
    ];
    
    if (mounted) {
      setState(() {});
    }
  }

  void _recordKeystroke() {
    final now = DateTime.now();
    if (_lastKeyPress != null) {
      final timing = now.difference(_lastKeyPress!).inMilliseconds.toDouble();
      _keystrokeTimings.add(timing);
      
      if (widget.enableBehavioralBiometrics) {
        _behavioralService.recordKeystroke(
          key: 'registration_input',
          timestamp: now,
          duration: timing,
        );
      }
    }
    
    _lastKeyPress = now;
    _keystrokeCount++;
    
    // Update behavioral progress
    setState(() {
      _behavioralProgress = (_keystrokeCount / 50).clamp(0.0, 1.0);
    });
  }

  Future<void> _processRegistration() async {
    debugPrint('🔄 _processRegistration called for step: ${widget.registrationStep}');
    debugPrint('📊 Registration data: $_registrationData');
    debugPrint('✅ Validation result: ${_validateCurrentStep()}');

    if (!_validateCurrentStep()) {
      debugPrint('❌ Validation failed, not proceeding');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _loadingAnimationController.forward();
    
    try {
      // Record behavioral data
      if (widget.enableBehavioralBiometrics) {
        _behavioralService.recordTouchEvent(
          x: 200, // Simplified - in production, get actual coordinates
          y: 400,
          type: TouchType.down,
          pressure: 1.0,
          size: 10.0,
        );
      }

      switch (widget.registrationStep) {
        case 'basic_info':
          await _processBasicInfo();
          break;
        case 'identity_verification':
          await _processIdentityVerification();
          break;
        case 'password_setup':
          if (!_passwordConfirmed) {
            await _confirmPassword();
          } else {
            await _continueToFarmDetails();
          }
          break;
        case 'farm_info':
          await _processFarmInfo();
          break;
        case 'farming_details':
          await _processFarmingDetails();
          break;
        case 'preferences':
          await _processPreferences();
          break;
        default:
          throw Exception('Unknown registration step: ${widget.registrationStep}');
      }

    } catch (e) {
      setState(() {
        _errorMessage = 'Registration error: $e';
      });
      widget.onRegistrationFailure('Registration error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
      _loadingAnimationController.stop();
    }
  }

  bool _validateCurrentStep() {
    debugPrint('🔍 Validating step: ${widget.registrationStep}');

    switch (widget.registrationStep) {
      case 'basic_info':
        final nameValid = _nameController.text.trim().isNotEmpty;
        final phoneValid = _phoneController.text.trim().isNotEmpty;
        final emailValid = _emailController.text.trim().isNotEmpty &&
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text.trim());
        final isValid = nameValid && phoneValid && emailValid;
        debugPrint('📝 Basic info validation: $isValid (name: $nameValid, phone: $phoneValid, email: $emailValid)');

        if (!isValid) {
          setState(() {
            if (!nameValid) {
              _errorMessage = 'Full name is required';
            } else if (!phoneValid) {
              _errorMessage = 'Phone number is required';
            } else if (!emailValid) {
              _errorMessage = 'Valid email address is required';
            }
          });
        }
        return isValid;
      case 'identity_verification':
        final bool codeSent = _registrationData.containsKey('verificationCodeSent');
        debugPrint('📱 Code sent status: $codeSent');

        if (!codeSent) {
          // Allow sending codes if basic info is complete
          final hasFullName = _registrationData.containsKey('fullName');
          final hasPhoneNumber = _registrationData.containsKey('phoneNumber');
          debugPrint('📊 Registration data check - fullName: $hasFullName, phoneNumber: $hasPhoneNumber');
          debugPrint('📊 Full registration data: $_registrationData');
          return hasFullName && hasPhoneNumber;
        } else {
          // Require 6-digit code if codes have been sent
          final codeLength = _verificationCodeController.text.trim().length;
          debugPrint('🔢 Code length: $codeLength');
          return codeLength == 6;
        }
      case 'password_setup':
        if (!_passwordConfirmed) {
          // For password confirmation step, validate password requirements
          final isValid = _validatePasswordRequirements();
          debugPrint('🔐 Password validation: $isValid');
          return isValid;
        } else {
          // For continue to farm details step, password is already confirmed
          debugPrint('🔐 Password already confirmed, ready to proceed');
          return true;
        }
      case 'farm_info':
        // Check if user has selected county or entered farm details
        final hasCounty = _selectedCounty.isNotEmpty;
        final hasFarmName = _farmNameController.text.trim().isNotEmpty;
        final hasLocation = _farmLocationController.text.trim().isNotEmpty;
        final hasFarmingType = _selectedFarmingType.isNotEmpty;
        final hasFarmSize = _farmSizeController.text.trim().isNotEmpty;

        // At least county or farming type should be selected
        final hasBasicFarmInfo = hasCounty || hasFarmingType || hasFarmName || hasLocation || hasFarmSize;
        debugPrint('🚜 Farm info validation: $hasBasicFarmInfo (county: $hasCounty, type: $hasFarmingType, name: $hasFarmName, location: $hasLocation, size: $hasFarmSize)');
        return hasBasicFarmInfo;
      case 'farming_details':
        // Check if user has selected at least one crop or livestock
        final hasCrops = _selectedCrops.isNotEmpty;
        final hasLivestock = _selectedLivestock.isNotEmpty;
        final hasFarmingDetails = hasCrops || hasLivestock;
        debugPrint('🌾 Farming details validation: $hasFarmingDetails (crops: ${_selectedCrops.length}, livestock: ${_selectedLivestock.length})');
        return hasFarmingDetails;
      case 'preferences':
        // Preferences are optional, so always valid
        debugPrint('⚙️ Preferences validation: true (optional)');
        return true;
      default:
        debugPrint('❓ Unknown step: ${widget.registrationStep}');
        return false;
    }
  }

  Future<void> _processBasicInfo() async {
    // Format phone number
    String phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isNotEmpty && !phoneNumber.startsWith('+254')) {
      if (phoneNumber.startsWith('0')) {
        phoneNumber = '+254${phoneNumber.substring(1)}';
      } else {
        phoneNumber = '+254$phoneNumber';
      }
    }

    // Validate phone number format and check for duplicates
    final phoneValidation = await _securityService.validatePhoneNumber(phoneNumber);
    if (!phoneValidation.isValid) {
      throw Exception(phoneValidation.errorMessage);
    }

    // Store basic info with encryption
    _registrationData = {
      'fullName': _nameController.text.trim(),
      'phoneNumber': phoneNumber,
      'email': _emailController.text.trim(),
      'registrationStep': 'basic_info_completed',
      'securityLevel': _securityLevel,
      'behavioralProgress': _behavioralProgress,
      'deviceFingerprint': await _securityService.getDeviceFingerprint(),
      'timestamp': DateTime.now().toIso8601String(),
    };

    // Simulate processing delay
    await Future.delayed(const Duration(milliseconds: 1500));
    
    setState(() {
      _successMessage = 'Basic information validated successfully';
      _registrationProgress = 0.33;
    });
    
    _progressAnimationController.animateTo(_registrationProgress);
    
    // Generate temporary session for next step
    final sessionToken = await _generateSecureSession();
    widget.onRegistrationSuccess(_registrationData, sessionToken, _securityLevel);
  }

  Future<void> _processIdentityVerification() async {
    // Check if we need to send verification code first
    if (!_registrationData.containsKey('verificationCodeSent')) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _successMessage = '📱 Sending real-time verification code...';
      });

      debugPrint('🔐 Starting real-time verification process...');
      debugPrint('📱 Phone: ${_registrationData['phoneNumber']}');
      debugPrint('📧 Email: ${_registrationData['email'] ?? 'Not provided'}');

      // Send real-time SMS and email verification
      final verificationResult = await _registrationService.sendVerificationCode(
        _registrationData['phoneNumber'],
        email: _registrationData['email']?.isNotEmpty == true ? _registrationData['email'] : null,
        userName: _registrationData['fullName'],
      );

      if (!verificationResult.success) {
        setState(() {
          _errorMessage = 'Failed to send verification: ${verificationResult.message}';
          _successMessage = null;
          _isLoading = false;
        });
        throw Exception(verificationResult.message);
      }

      _registrationData['verificationCodeSent'] = true;
      _registrationData['verificationSentAt'] = DateTime.now().toIso8601String();

      setState(() {
        _successMessage = '✅ ${verificationResult.message}\n📱 Check your phone and email for the verification code!';
        _isLoading = false;
      });

      debugPrint('✅ Verification codes sent successfully!');

      // Don't proceed to verification yet, wait for user to enter code
      return;
    }

    // Verify the entered code
    debugPrint('🔍 Verifying entered code: ${_verificationCodeController.text.trim()}');

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = 'Verifying code...';
    });

    final codeVerificationResult = await _registrationService.verifyIdentityCode(
      _verificationCodeController.text.trim(),
      _registrationData['phoneNumber'],
    );

    if (!codeVerificationResult.isValid) {
      setState(() {
        _errorMessage = 'Verification failed: ${codeVerificationResult.errorMessage}';
        _successMessage = null;
        _isLoading = false;
      });
      throw Exception(codeVerificationResult.errorMessage);
    }

    _registrationData['identityVerified'] = true;
    _registrationData['verificationTimestamp'] = DateTime.now().toIso8601String();
    _registrationData['registrationStep'] = 'identity_verified';

    setState(() {
      _successMessage = '🎉 Identity verified successfully!\n✅ Real-time verification completed!';
      _registrationProgress = 0.66;
      _securityLevel = 85; // Increase security level after verification
      _isLoading = false;
    });

    debugPrint('🎉 Identity verification completed successfully!');

    _progressAnimationController.animateTo(_registrationProgress);

    final sessionToken = await _generateSecureSession();
    widget.onRegistrationSuccess(_registrationData, sessionToken, _securityLevel);
  }

  Future<void> _confirmPassword() async {
    // This method handles the password confirmation step
    debugPrint('🔐 Confirming password...');

    // Validate password requirements using our comprehensive validation
    if (!_validatePasswordRequirements()) {
      debugPrint('❌ Password validation failed');
      return;
    }

    // If validation passes, mark password as confirmed
    setState(() {
      _passwordConfirmed = true;
      _successMessage = '✅ Password confirmed! You can now continue to farm details.';
      _errorMessage = null;
    });

    debugPrint('✅ Password confirmed successfully');

    // Brief delay to show success message
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _continueToFarmDetails() async {
    // This method handles continuing to farm details after password confirmation
    debugPrint('🚜 Continuing to farm details...');

    // Store password data for later use (when completing full registration)
    _registrationData['password'] = _passwordController.text;
    _registrationData['registrationStep'] = 'password_confirmed';

    setState(() {
      _successMessage = '🚜 Navigating to farm details...';
      _errorMessage = null;
    });

    debugPrint('✅ Password data stored, ready for farm details');

    // Brief delay to show success message
    await Future.delayed(const Duration(milliseconds: 1000));

    // Navigate to farm details using direct widget navigation
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EnhancedRegistrationScreen(
            registrationStep: 'farm_info',
            initialData: _registrationData,
          ),
        ),
      );
    }
  }

  Future<void> _processPasswordSetup() async {
    // Validate password strength
    final passwordValidation = await _securityService.validatePasswordStrength(
      _passwordController.text,
    );
    
    if (!passwordValidation.isValid) {
      throw Exception(passwordValidation.errorMessage);
    }

    // Hash password with advanced security
    final hashedPassword = await _securityService.hashPassword(
      _passwordController.text,
      _registrationData['phoneNumber'],
    );

    // Complete registration with Keycloak
    final registrationResult = await _keycloakService.registerUser(
      _registrationData['fullName'],
      _registrationData['phoneNumber'],
      _registrationData['email'],
      hashedPassword,
    );

    if (!registrationResult.success) {
      throw Exception(registrationResult.errorMessage);
    }

    _registrationData['passwordHash'] = hashedPassword;
    _registrationData['keycloakUserId'] = registrationResult.userId;
    _registrationData['registrationStep'] = 'password_setup_completed';

    setState(() {
      _successMessage = 'Password setup completed successfully! 🔐';
      _registrationProgress = 0.5; // 50% complete after password setup
      _securityLevel = 85; // High security level after password setup
    });

    _progressAnimationController.animateTo(_registrationProgress);
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<String> _generateSecureSession() async {
    return await _authService.generateSecureSession(
      _registrationData,
      _securityLevel,
      {
        'behavioralProgress': _behavioralProgress,
        'keystrokeCount': _keystrokeCount,
        'registrationStep': widget.registrationStep,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen during initialization
    if (_isInitializing) {
      return _buildInitializationLoader();
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue[50]!,
            Colors.indigo[50]!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Security Level Indicator (hidden if hideSecurityWidgets is true)
          if (!widget.hideSecurityWidgets) ...[
            _buildSecurityLevelIndicator(),
            const SizedBox(height: 24),
          ],

          // Registration Progress (always show but with farmer-friendly styling when hidden)
          widget.hideSecurityWidgets
              ? _buildFarmerFriendlyProgress()
              : _buildRegistrationProgress(),

          const SizedBox(height: 24),

          // Security Indicators Grid (hidden if hideSecurityWidgets is true)
          if (!widget.hideSecurityWidgets) ...[
            _buildSecurityIndicators(),
            const SizedBox(height: 32),
          ],

          // Farmer Graphics (show when security widgets are hidden)
          if (widget.hideSecurityWidgets) ...[
            _buildFarmerMotivationalGraphics(),
            const SizedBox(height: 24),
          ],

          // Dynamic Form Fields based on registration step
          _buildStepFields(),

          const SizedBox(height: 24),

          // Success/Error Messages
          if (_successMessage != null) _buildSuccessMessage(),
          if (_errorMessage != null) _buildErrorMessage(),

          // Registration Button
          _buildRegistrationButton(),

          const SizedBox(height: 16),

          // Behavioral Learning Progress (hidden if hideSecurityWidgets is true)
          if (widget.enableBehavioralBiometrics && !widget.hideSecurityWidgets)
            _buildBehavioralProgress(),

          // Farmer-friendly encouragement (show when security widgets are hidden)
          if (widget.hideSecurityWidgets)
            _buildFarmerEncouragement(),
        ],
      ),
    );
  }

  Widget _buildSecurityLevelIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getSecurityLevelColor().withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _getSecurityLevelColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              _getSecurityLevelIcon(),
              color: _getSecurityLevelColor(),
              size: 28,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Security Level: $_securityLevel%',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                LinearProgressIndicator(
                  value: _securityLevel / 100.0,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation(_getSecurityLevelColor()),
                  minHeight: 6,
                ),

                const SizedBox(height: 4),

                Text(
                  _getSecurityLevelDescription(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationProgress() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.how_to_reg, color: Colors.indigo[600], size: 20),
              const SizedBox(width: 8),
              Text(
                'Registration Progress',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo[600],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          LinearProgressIndicator(
            value: _registrationProgress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation(Colors.green[600]),
            minHeight: 8,
          ),

          const SizedBox(height: 8),

          Text(
            '${(_registrationProgress * 100).toInt()}% Complete',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityIndicators() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security, color: Colors.indigo[600], size: 20),
              const SizedBox(width: 8),
              Text(
                'Security Features',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo[600],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _securityIndicators.length,
            itemBuilder: (context, index) {
              final indicator = _securityIndicators[index];
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getStatusColor(indicator.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getStatusColor(indicator.status).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      indicator.icon,
                      color: _getStatusColor(indicator.status),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        indicator.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: _getStatusColor(indicator.status),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStepFields() {
    switch (widget.registrationStep) {
      case 'basic_info':
        return _buildBasicInfoFields();
      case 'identity_verification':
        return _buildVerificationFields();
      case 'password_setup':
        return _buildPasswordFields();
      case 'farm_info':
        return _buildFarmInfoFields();
      case 'farming_details':
        return _buildFarmingDetailsFields();
      case 'preferences':
        return _buildPreferencesFields();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBasicInfoFields() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Full Name',
            prefixIcon: const Icon(Icons.person),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (_) => _recordKeystroke(),
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          decoration: InputDecoration(
            labelText: 'Phone Number',
            hintText: '0712345678',
            prefixIcon: const Icon(Icons.phone),
            prefixText: '+254 ',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (_) => _recordKeystroke(),
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email Address *',
            hintText: 'Enter your email address',
            prefixIcon: const Icon(Icons.email),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Email address is required';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
              return 'Please enter a valid email address';
            }
            return null;
          },
          onChanged: (_) => _recordKeystroke(),
        ),
      ],
    );
  }

  Widget _buildVerificationFields() {
    final bool codeSent = _registrationData.containsKey('verificationCodeSent');

    return Column(
      children: [
        // Real-time verification status
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: codeSent ? Colors.green[50] : Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: codeSent ? Colors.green[200]! : Colors.blue[200]!,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    codeSent ? Icons.check_circle : Icons.sms,
                    color: codeSent ? Colors.green[600] : Colors.blue[600],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      codeSent
                        ? '✅ Verification codes sent!\nEnter the 6-digit code below to continue.'
                        : '📱 We will send verification codes to your phone and email.\nClick the button below to get started.',
                      style: TextStyle(
                        color: codeSent ? Colors.green[700] : Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              if (codeSent) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.phone_android, size: 16, color: Colors.green[600]),
                    const SizedBox(width: 8),
                    Text(
                      'SMS sent to ${_registrationData['phoneNumber']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (_registrationData['email']?.isNotEmpty == true) ...[
                  Row(
                    children: [
                      Icon(Icons.email, size: 16, color: Colors.green[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Email sent to ${_registrationData['email']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[600],
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Colors.orange[600]),
                      const SizedBox(width: 8),
                      Text(
                        'SMS verification only (no email provided)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Verification code input - always show but with different states
        TextFormField(
          controller: _verificationCodeController,
          keyboardType: TextInputType.number,
          enabled: codeSent, // Only enable after codes are sent
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          decoration: InputDecoration(
            labelText: 'Verification Code',
            hintText: codeSent ? '123456' : 'Codes will be sent first',
            prefixIcon: Icon(
              Icons.verified_user,
              color: codeSent ? null : Colors.grey[400],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: codeSent ? Colors.white : Colors.grey[100],
            helperText: codeSent
              ? 'Enter the 6-digit code from your SMS or email'
              : 'This field will be enabled after sending verification codes',
            helperStyle: TextStyle(
              color: codeSent ? Colors.grey[600] : Colors.grey[500],
            ),
          ),
          onChanged: (_) => _recordKeystroke(),
          autofocus: codeSent,
        ),

        if (codeSent) ...[
          const SizedBox(height: 12),

          // Resend codes option
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Didn't receive the code? ",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Clear the sent flag to allow resending
                  setState(() {
                    _registrationData.remove('verificationCodeSent');
                    _verificationCodeController.clear();
                  });
                },
                child: const Text(
                  'Resend',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildPasswordFields() {
    if (_passwordConfirmed) {
      // Show confirmation state with farm details preview
      return _buildPasswordConfirmedState();
    }

    // Show password input state
    return Column(
      children: [
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password (min 14 characters)',
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (_) {
            _recordKeystroke();
            setState(() {}); // Trigger rebuild for validation indicators
          },
        ),

        const SizedBox(height: 12),

        // Password requirements indicators
        _buildPasswordRequirementsIndicators(),

        const SizedBox(height: 16),

        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (_) {
            _recordKeystroke();
            setState(() {}); // Trigger rebuild for validation indicators
          },
        ),

        const SizedBox(height: 12),

        // Password match indicator
        _buildPasswordMatchIndicator(),
      ],
    );
  }

  Widget _buildPasswordConfirmedState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[300]!),
      ),
      child: Column(
        children: [
          // Success icon and message
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Password Confirmed Successfully!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Next step preview
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.agriculture, color: Colors.green[600], size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Next: Farm Details',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'We\'ll collect information about your farm location, size, and farming activities to provide personalized services.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[300]!),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green[600], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _successMessage!,
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[300]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: Colors.red[600], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _processRegistration,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo[600],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Processing...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              )
            : Text(_getButtonText()),
      ),
    );
  }

  Widget _buildBehavioralProgress() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: Colors.blue[600], size: 20),
              const SizedBox(width: 8),
              Text(
                'Behavioral Learning',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[600],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          LinearProgressIndicator(
            value: _behavioralProgress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation(Colors.blue[600]),
            minHeight: 4,
          ),

          const SizedBox(height: 4),

          Text(
            'Learning your typing patterns: ${(_behavioralProgress * 100).toInt()}%',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  Color _getSecurityLevelColor() {
    if (_securityLevel >= 80) return Colors.green;
    if (_securityLevel >= 60) return Colors.orange;
    return Colors.red;
  }

  IconData _getSecurityLevelIcon() {
    if (_securityLevel >= 80) return Icons.verified_user;
    if (_securityLevel >= 60) return Icons.warning;
    return Icons.error;
  }

  String _getSecurityLevelDescription() {
    if (_securityLevel >= 80) return 'Excellent security';
    if (_securityLevel >= 60) return 'Good security';
    return 'Security needs improvement';
  }

  Color _getStatusColor(SecurityStatus status) {
    switch (status) {
      case SecurityStatus.enabled:
        return Colors.green;
      case SecurityStatus.learning:
        return Colors.blue;
      case SecurityStatus.warning:
        return Colors.orange;
      case SecurityStatus.disabled:
        return Colors.red;
    }
  }

  String _getButtonText() {
    switch (widget.registrationStep) {
      case 'basic_info':
        return 'Continue to Verification';
      case 'identity_verification':
        final bool codeSent = _registrationData.containsKey('verificationCodeSent');
        final bool hasCode = _verificationCodeController.text.trim().length == 6;

        if (!codeSent) {
          return 'Send Verification Codes';
        } else if (hasCode) {
          return 'Verify Code & Continue';
        } else {
          return 'Enter Verification Code';
        }
      case 'password_setup':
        return _passwordConfirmed ? 'Continue to Farm Details' : 'Confirm Password';
      case 'farm_info':
        return 'Continue to Farming Details';
      case 'farming_details':
        return 'Continue to Preferences';
      case 'preferences':
        return 'Complete Registration';
      default:
        return 'Continue';
    }
  }
  // Farm Details Processing Methods
  Future<void> _processFarmInfo() async {
    // Validate farm information
    final bool countyValid = _selectedCounty.isNotEmpty;
    final bool typeValid = _selectedFarmingType.isNotEmpty;
    final bool nameValid = _farmNameController.text.trim().isNotEmpty || _registrationData['fullName'] != null;
    final bool locationValid = _farmLocationController.text.trim().isNotEmpty || _selectedCounty.isNotEmpty;
    final bool sizeValid = _farmSizeController.text.trim().isNotEmpty && double.tryParse(_farmSizeController.text) != null;

    debugPrint('🚜 Farm info validation: ${countyValid && typeValid && nameValid && locationValid && sizeValid} (county: $countyValid, type: $typeValid, name: $nameValid, location: $locationValid, size: $sizeValid)');

    if (!countyValid || !typeValid || !nameValid || !locationValid || !sizeValid) {
      setState(() {
        _errorMessage = 'Please fill in all required farm information fields';
        _successMessage = null;
      });
      return;
    }

    // Store farm information
    _registrationData.addAll({
      'farmName': _farmNameController.text.trim().isEmpty
          ? '${_registrationData['fullName']}\'s Farm'
          : _farmNameController.text.trim(),
      'farmLocation': _farmLocationController.text.trim().isEmpty
          ? _selectedCounty
          : _farmLocationController.text.trim(),
      'county': _selectedCounty.isEmpty ? 'Nairobi' : _selectedCounty,
      'farmSize': double.tryParse(_farmSizeController.text) ?? 1.0,
      'farmingType': _selectedFarmingType.isEmpty ? 'Mixed Farming' : _selectedFarmingType,
      'experienceLevel': _selectedExperienceLevel.isEmpty ? 'Beginner (0-2 years)' : _selectedExperienceLevel,
      'registrationStep': 'farm_info_completed',
    });

    setState(() {
      _successMessage = '✅ Farm information validated successfully! Proceeding to farming details...';
      _registrationProgress = 0.6;
      _errorMessage = null;
    });

    _progressAnimationController.animateTo(_registrationProgress);
    await Future.delayed(const Duration(milliseconds: 1500));

    // Automatically proceed to farming details
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EnhancedRegistrationScreen(
            registrationStep: 'farming_details',
            initialData: _registrationData,
          ),
        ),
      );
    }
  }

  Future<void> _processFarmingDetails() async {
    // Validate farming details
    final bool cropsValid = _selectedCrops.isNotEmpty;
    final bool livestockValid = _selectedLivestock.isNotEmpty;
    final bool hasSelection = cropsValid || livestockValid;

    debugPrint('🌾 Farming details validation: $hasSelection (crops: $cropsValid [${_selectedCrops.length}], livestock: $livestockValid [${_selectedLivestock.length}])');

    if (!hasSelection) {
      setState(() {
        _errorMessage = 'Please select at least one crop or livestock type';
        _successMessage = null;
      });
      return;
    }

    // Store farming details
    _registrationData.addAll({
      'crops': _selectedCrops,
      'livestock': _selectedLivestock,
      'registrationStep': 'farming_details_completed',
    });

    setState(() {
      _successMessage = '✅ Farming details validated successfully! Proceeding to preferences...';
      _registrationProgress = 0.8;
      _errorMessage = null;
    });

    _progressAnimationController.animateTo(_registrationProgress);
    await Future.delayed(const Duration(milliseconds: 1500));

    // Automatically proceed to preferences
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EnhancedRegistrationScreen(
            registrationStep: 'preferences',
            initialData: _registrationData,
          ),
        ),
      );
    }
  }

  Future<void> _processPreferences() async {
    // Validate preferences
    final bool languageValid = _selectedLanguage.isNotEmpty;
    final bool hasSelectedServices = _selectedServices.values.any((selected) => selected);

    debugPrint('⚙️ Preferences validation: ${languageValid && hasSelectedServices} (language: $languageValid, services: $hasSelectedServices)');

    if (!languageValid) {
      setState(() {
        _errorMessage = 'Please select a preferred language';
        _successMessage = null;
      });
      return;
    }

    if (!hasSelectedServices) {
      setState(() {
        _errorMessage = 'Please select at least one service';
        _successMessage = null;
      });
      return;
    }

    // Store preferences and complete registration
    _registrationData.addAll({
      'preferredLanguage': _selectedLanguage,
      'selectedServices': _selectedServices.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList(),
      'registrationStep': 'completed',
      'registrationCompleted': true,
    });

    setState(() {
      _successMessage = '✅ Preferences validated successfully! Completing registration...';
      _registrationProgress = 1.0;
      _securityLevel = 95; // Maximum security level
      _errorMessage = null;
    });

    _progressAnimationController.animateTo(_registrationProgress);

    // Send welcome messages via SMS and email
    try {
      await _registrationService.sendWelcomeMessages(
        phoneNumber: _registrationData['phoneNumber'],
        userName: _registrationData['fullName'],
        email: _registrationData['email'],
      );

      setState(() {
        _successMessage = 'Registration completed! Welcome messages sent 📱📧';
      });
    } catch (e) {
      debugPrint('⚠️ Welcome messages failed: $e');
      // Don't fail registration if welcome messages fail
    }

    // Generate secure session token
    final sessionToken = await _generateSecureSession();
    widget.onRegistrationSuccess(_registrationData, sessionToken, _securityLevel);
  }

  // Farm Details UI Methods
  Widget _buildFarmInfoFields() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          const Icon(
            Icons.agriculture,
            size: 64,
            color: Color(0xFF2E7D32),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tell us about your farm',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Help us understand your farming operation',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Farm Name Field
          TextFormField(
            controller: _farmNameController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: 'Farm Name',
              hintText: 'e.g., Green Valley Farm',
              prefixIcon: const Icon(Icons.home_work),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2E7D32)),
              ),
            ),
            onChanged: (_) => _recordKeystroke(),
          ),

          const SizedBox(height: 16),

          // County Dropdown
          DropdownButtonFormField<String>(
            initialValue: _selectedCounty.isEmpty ? null : _selectedCounty,
            decoration: InputDecoration(
              labelText: 'County',
              hintText: 'Select your county',
              prefixIcon: const Icon(Icons.map),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2E7D32)),
              ),
            ),
            items: _counties.map((String county) {
              return DropdownMenuItem<String>(
                value: county,
                child: Text(county),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCounty = newValue ?? '';
              });
            },
          ),

          const SizedBox(height: 16),

          // Farm Location Field
          TextFormField(
            controller: _farmLocationController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: 'Specific Location',
              hintText: 'e.g., Kiambu Town, near ABC School',
              prefixIcon: const Icon(Icons.location_on),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2E7D32)),
              ),
            ),
            onChanged: (_) => _recordKeystroke(),
          ),

          const SizedBox(height: 16),

          // Farm Size Field
          TextFormField(
            controller: _farmSizeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Farm Size (acres)',
              hintText: 'e.g., 2.5',
              prefixIcon: const Icon(Icons.landscape),
              suffixText: 'acres',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2E7D32)),
              ),
            ),
            onChanged: (_) => _recordKeystroke(),
          ),

          const SizedBox(height: 16),

          // Farming Type Selection
          const Text(
            'Primary Farming Type',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          ...List.generate(_farmingTypes.length, (index) {
            final type = _farmingTypes[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _selectedFarmingType == type
                      ? const Color(0xFF2E7D32)
                      : Colors.grey[300]!,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: Text(type),
                subtitle: Text(_getFarmingTypeDescription(type)),
                leading: Icon(
                  _selectedFarmingType == type
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: _selectedFarmingType == type
                      ? const Color(0xFF2E7D32)
                      : Colors.grey,
                ),
                onTap: () {
                  setState(() {
                    _selectedFarmingType = type;
                  });
                },
              ),
            );
          }),

          const SizedBox(height: 16),

          // Experience Level Selection
          const Text(
            'Farming Experience',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            initialValue: _selectedExperienceLevel.isEmpty ? null : _selectedExperienceLevel,
            decoration: InputDecoration(
              labelText: 'Experience Level',
              hintText: 'Select your experience level',
              prefixIcon: const Icon(Icons.star),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2E7D32)),
              ),
            ),
            items: _experienceLevels.map((String level) {
              return DropdownMenuItem<String>(
                value: level,
                child: Text(level),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedExperienceLevel = newValue ?? '';
              });
            },
          ),
        ],
      ),
    );
  }

  String _getFarmingTypeDescription(String type) {
    switch (type) {
      case 'Crop Farming':
        return 'Growing crops like maize, beans, vegetables';
      case 'Livestock Farming':
        return 'Raising cattle, goats, sheep for meat/milk';
      case 'Mixed Farming':
        return 'Combination of crops and livestock';
      case 'Poultry Farming':
        return 'Raising chickens, ducks, turkeys';
      case 'Dairy Farming':
        return 'Specialized in milk production';
      case 'Fish Farming':
        return 'Aquaculture and fish production';
      case 'Horticulture':
        return 'Fruits, vegetables, flowers cultivation';
      case 'Agro-forestry':
        return 'Trees integrated with crops/livestock';
      default:
        return 'Agricultural production';
    }
  }

  Widget _buildFarmingDetailsFields() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          const Icon(
            Icons.eco,
            size: 64,
            color: Color(0xFF2E7D32),
          ),
          const SizedBox(height: 16),
          const Text(
            'What do you grow & raise?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Select your crops and livestock',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Crops Section
          const Row(
            children: [
              Icon(Icons.grass, color: Color(0xFF2E7D32)),
              SizedBox(width: 8),
              Text(
                'Crops You Grow',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _cropOptions.map((crop) {
                final isSelected = _selectedCrops.contains(crop);
                return FilterChip(
                  label: Text(crop),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedCrops.add(crop);
                      } else {
                        _selectedCrops.remove(crop);
                      }
                    });
                  },
                  selectedColor: const Color(0xFF2E7D32).withValues(alpha: 0.2),
                  checkmarkColor: const Color(0xFF2E7D32),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Livestock Section
          const Row(
            children: [
              Icon(Icons.pets, color: Color(0xFF2E7D32)),
              SizedBox(width: 8),
              Text(
                'Livestock You Keep',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _livestockOptions.map((livestock) {
                final isSelected = _selectedLivestock.contains(livestock);
                return FilterChip(
                  label: Text(livestock),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedLivestock.add(livestock);
                      } else {
                        _selectedLivestock.remove(livestock);
                      }
                    });
                  },
                  selectedColor: const Color(0xFF2E7D32).withValues(alpha: 0.2),
                  checkmarkColor: const Color(0xFF2E7D32),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Quick Selection Buttons
          const Text(
            'Quick Selection',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedCrops.clear();
                      _selectedCrops.addAll(['Maize', 'Beans', 'Kales', 'Tomatoes']);
                    });
                  },
                  icon: const Icon(Icons.grass),
                  label: const Text('Common Crops'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2E7D32),
                    side: const BorderSide(color: Color(0xFF2E7D32)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedLivestock.clear();
                      _selectedLivestock.addAll(['Cattle', 'Goats', 'Chickens']);
                    });
                  },
                  icon: const Icon(Icons.pets),
                  label: const Text('Common Livestock'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2E7D32),
                    side: const BorderSide(color: Color(0xFF2E7D32)),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Clear All Button
          TextButton(
            onPressed: () {
              setState(() {
                _selectedCrops.clear();
                _selectedLivestock.clear();
              });
            },
            child: const Text(
              'Clear All Selections',
              style: TextStyle(color: Colors.red),
            ),
          ),

          const SizedBox(height: 16),

          // Selection Summary
          if (_selectedCrops.isNotEmpty || _selectedLivestock.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Selection Summary:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_selectedCrops.isNotEmpty)
                    Text('Crops: ${_selectedCrops.join(', ')}'),
                  if (_selectedLivestock.isNotEmpty)
                    Text('Livestock: ${_selectedLivestock.join(', ')}'),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPreferencesFields() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          const Icon(
            Icons.settings,
            size: 64,
            color: Color(0xFF2E7D32),
          ),
          const SizedBox(height: 16),
          const Text(
            'Customize your experience',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Choose services and preferences',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Language Selection
          const Row(
            children: [
              Icon(Icons.language, color: Color(0xFF2E7D32)),
              SizedBox(width: 8),
              Text(
                'Preferred Language',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            initialValue: _selectedLanguage,
            decoration: InputDecoration(
              labelText: 'Language',
              prefixIcon: const Icon(Icons.translate),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2E7D32)),
              ),
            ),
            items: _languages.map((String language) {
              return DropdownMenuItem<String>(
                value: language,
                child: Text(language),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedLanguage = newValue ?? 'English';
              });
            },
          ),

          const SizedBox(height: 24),

          // App Services Selection
          const Row(
            children: [
              Icon(Icons.apps, color: Color(0xFF2E7D32)),
              SizedBox(width: 8),
              Text(
                'App Services',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Select services you want to use (you can change these later)',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),

          ..._appServices.entries.map((service) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CheckboxListTile(
                title: Text(
                  service.key,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  service.value,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                value: _selectedServices[service.key] ?? false,
                onChanged: (bool? value) {
                  setState(() {
                    _selectedServices[service.key] = value ?? false;
                  });
                },
                activeColor: const Color(0xFF2E7D32),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          // Quick Selection Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      for (String service in _appServices.keys) {
                        _selectedServices[service] = true;
                      }
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2E7D32),
                    side: const BorderSide(color: Color(0xFF2E7D32)),
                  ),
                  child: const Text('Select All'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      for (String service in _appServices.keys) {
                        _selectedServices[service] = false;
                      }
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text('Clear All'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build password requirements indicators
  Widget _buildPasswordRequirementsIndicators() {
    final password = _passwordController.text;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Password Requirements:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          _buildRequirementItem('At least 14 characters', password.length >= 14),
          _buildRequirementItem('Uppercase letter (A-Z)', password.contains(RegExp(r'[A-Z]'))),
          _buildRequirementItem('Lowercase letter (a-z)', password.contains(RegExp(r'[a-z]'))),
          _buildRequirementItem('Number (0-9)', password.contains(RegExp(r'[0-9]'))),
          _buildRequirementItem('Special character (!@#\$%^&*)', password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))),
        ],
      ),
    );
  }

  /// Build individual requirement item
  Widget _buildRequirementItem(String requirement, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isMet ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            requirement,
            style: TextStyle(
              fontSize: 12,
              color: isMet ? Colors.green : Colors.grey[600],
              fontWeight: isMet ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  /// Build password match indicator
  Widget _buildPasswordMatchIndicator() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (confirmPassword.isEmpty) {
      return const SizedBox.shrink();
    }

    final isMatch = password == confirmPassword;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isMatch ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isMatch ? Colors.green : Colors.red,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isMatch ? Icons.check_circle : Icons.error,
            size: 16,
            color: isMatch ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Text(
            isMatch ? 'Passwords match' : 'Passwords do not match',
            style: TextStyle(
              fontSize: 12,
              color: isMatch ? Colors.green : Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Comprehensive password validation
  bool _validatePasswordRequirements() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Check if passwords match
    if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return false;
    }

    // Check minimum length
    if (password.length < 14) {
      setState(() {
        _errorMessage = 'Password must be at least 14 characters long';
      });
      return false;
    }

    // Check for uppercase letters
    if (!password.contains(RegExp(r'[A-Z]'))) {
      setState(() {
        _errorMessage = 'Password must contain at least one uppercase letter';
      });
      return false;
    }

    // Check for lowercase letters
    if (!password.contains(RegExp(r'[a-z]'))) {
      setState(() {
        _errorMessage = 'Password must contain at least one lowercase letter';
      });
      return false;
    }

    // Check for numbers
    if (!password.contains(RegExp(r'[0-9]'))) {
      setState(() {
        _errorMessage = 'Password must contain at least one number';
      });
      return false;
    }

    // Check for special characters
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      setState(() {
        _errorMessage = 'Password must contain at least one special character (!@#\$%^&*(),.?":{}|<>)';
      });
      return false;
    }

    // Clear error message if all validations pass
    setState(() {
      _errorMessage = null;
    });

    return true;
  }

  // Farmer-friendly UI methods (shown when security widgets are hidden)
  Widget _buildFarmerFriendlyProgress() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4CAF50).withValues(alpha: 0.1),
            const Color(0xFF2E7D32).withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.agriculture,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getStepTitle(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getStepDescription(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: _registrationProgress,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildFarmerMotivationalGraphics() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Farmer icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Join the KaziApp Community!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Connect with experts, access resources, and grow your farming success.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmerEncouragement() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: Colors.amber[700],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _getEncouragementMessage(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.amber[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle() {
    switch (widget.registrationStep) {
      case 'basic_info':
        return 'Personal Information';
      case 'identity_verification':
        return 'Farm Details';
      case 'password_setup':
        return 'Account Setup';
      default:
        return 'Registration';
    }
  }

  String _getStepDescription() {
    switch (widget.registrationStep) {
      case 'basic_info':
        return 'Tell us about yourself to get started';
      case 'identity_verification':
        return 'Share your farming information with us';
      case 'password_setup':
        return 'Secure your account and complete setup';
      default:
        return 'Complete your registration';
    }
  }

  String _getEncouragementMessage() {
    final messages = [
      'Your farming journey starts here! 🌱',
      'Connect with agricultural experts and grow your knowledge! 📚',
      'Access veterinary services and keep your livestock healthy! 🐄',
      'Join thousands of successful farmers in Kenya! 🇰🇪',
      'Get real-time market prices and maximize your profits! 💰',
    ];
    return messages[DateTime.now().millisecond % messages.length];
  }

  Widget _buildInitializationLoader() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green[50]!,
            Colors.green[100]!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Farmer avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withValues(alpha: 0.3),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: const Icon(
              Icons.agriculture,
              color: Colors.white,
              size: 40,
            ),
          ),

          const SizedBox(height: 24),

          // Loading indicator
          const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation(Color(0xFF4CAF50)),
            ),
          ),

          const SizedBox(height: 24),

          // Loading text
          const Text(
            'Initializing Mkulima Connect',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D32),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Setting up your secure farming experience...',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Progress steps
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLoadingStep('Security', true),
              const SizedBox(width: 8),
              _buildLoadingStep('Services', true),
              const SizedBox(width: 8),
              _buildLoadingStep('Ready', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingStep(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF4CAF50) : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isActive ? Colors.white : Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// Security Indicator class
class SecurityIndicator {
  final IconData icon;
  final String label;
  final SecurityStatus status;
  final String description;
  final double progress;

  SecurityIndicator({
    required this.icon,
    required this.label,
    required this.status,
    required this.description,
    this.progress = 0.0,
  });
}

enum SecurityStatus { enabled, learning, warning, disabled }
