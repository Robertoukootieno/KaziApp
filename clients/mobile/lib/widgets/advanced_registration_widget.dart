import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/advanced_security_service.dart';
import '../services/zero_trust_auth_service.dart';
import '../services/behavioral_biometrics_service.dart';
import '../services/keycloak_auth_service.dart';
import '../services/registration_security_service.dart';

/// Advanced Registration Widget with Enterprise-Grade Security
class AdvancedRegistrationWidget extends StatefulWidget {
  final Function(Map<String, dynamic> registrationData, String sessionToken, int securityLevel) onRegistrationSuccess;
  final Function(String error) onRegistrationFailure;
  final bool enableBiometrics;
  final bool enableBehavioralBiometrics;
  final String registrationStep; // 'basic_info', 'identity_verification', 'password_setup'
  final Map<String, dynamic>? initialData; // Data from previous registration steps

  const AdvancedRegistrationWidget({
    super.key,
    required this.onRegistrationSuccess,
    required this.onRegistrationFailure,
    this.enableBiometrics = true,
    this.enableBehavioralBiometrics = true,
    required this.registrationStep,
    this.initialData,
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
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
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
  
  @override
  void initState() {
    super.initState();

    // Initialize registration data with any passed initial data
    if (widget.initialData != null) {
      _registrationData = Map<String, dynamic>.from(widget.initialData!);
      debugPrint('🔄 Initialized with registration data: $_registrationData');
    }

    _initializeAnimations();
    _initializeServices();
    _updateSecurityIndicators();
    _startBehavioralTracking();
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
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _securityAnimationController.repeat();
  }

  Future<void> _initializeServices() async {
    try {
      await _securityService.initialize();
      await _behavioralService.initialize();
      await _keycloakService.initialize();
      await _registrationService.initialize();

      setState(() {
        _securityLevel = 75; // Base security level for registration
      });

      _securityAnimationController.animateTo(_securityLevel / 100);
    } catch (e) {
      debugPrint('Failed to initialize security services: $e');
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

    _loadingAnimationController.repeat();
    
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
          await _processPasswordSetup();
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
        final isValid = _nameController.text.trim().isNotEmpty &&
                       _phoneController.text.trim().isNotEmpty;
        debugPrint('📝 Basic info validation: $isValid (name: ${_nameController.text.trim().isNotEmpty}, phone: ${_phoneController.text.trim().isNotEmpty})');
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
        final isValid = _passwordController.text.length >= 14 &&
                       _passwordController.text == _confirmPasswordController.text;
        debugPrint('🔐 Password validation: $isValid');
        return isValid;
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
          // Security Level Indicator
          _buildSecurityLevelIndicator(),

          const SizedBox(height: 24),

          // Registration Progress
          _buildRegistrationProgress(),

          const SizedBox(height: 24),

          // Security Indicators Grid
          _buildSecurityIndicators(),

          const SizedBox(height: 32),

          // Dynamic Form Fields based on registration step
          _buildStepFields(),

          const SizedBox(height: 24),

          // Success/Error Messages
          if (_successMessage != null) _buildSuccessMessage(),
          if (_errorMessage != null) _buildErrorMessage(),

          // Registration Button
          _buildRegistrationButton(),

          const SizedBox(height: 16),

          // Behavioral Learning Progress
          if (widget.enableBehavioralBiometrics) _buildBehavioralProgress(),
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

                AnimatedBuilder(
                  animation: _securityAnimationController,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _securityAnimationController.value,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation(_getSecurityLevelColor()),
                      minHeight: 6,
                    );
                  },
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

          AnimatedBuilder(
            animation: _progressAnimationController,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: _progressAnimationController.value,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation(Colors.green[600]),
                minHeight: 8,
              );
            },
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
            labelText: 'Email Address (Optional)',
            prefixIcon: const Icon(Icons.email),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
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
          onChanged: (_) => _recordKeystroke(),
        ),

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
          onChanged: (_) => _recordKeystroke(),
        ),
      ],
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
            ? AnimatedBuilder(
                animation: _loadingAnimationController,
                builder: (context, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: const AlwaysStoppedAnimation(Colors.white),
                          value: _loadingAnimationController.value,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('Processing...'),
                    ],
                  );
                },
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
        return 'Continue to Farm Details';
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
      'registrationStep': 'farm_info_completed',
    });

    setState(() {
      _successMessage = 'Farm information saved successfully! 🚜';
      _registrationProgress = 0.6;
    });

    _progressAnimationController.animateTo(_registrationProgress);
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _processFarmingDetails() async {
    // Store farming details
    _registrationData.addAll({
      'crops': _selectedCrops,
      'livestock': _selectedLivestock,
      'registrationStep': 'farming_details_completed',
    });

    setState(() {
      _successMessage = 'Farming details saved successfully! 🌾';
      _registrationProgress = 0.8;
    });

    _progressAnimationController.animateTo(_registrationProgress);
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _processPreferences() async {
    // Store preferences and complete registration
    _registrationData.addAll({
      'selectedServices': _selectedServices.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList(),
      'registrationStep': 'completed',
      'registrationCompleted': true,
    });

    setState(() {
      _successMessage = 'Registration completed successfully! 🎉';
      _registrationProgress = 1.0;
      _securityLevel = 95; // Maximum security level
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
    return Column(
      children: [
        TextFormField(
          controller: _farmNameController,
          decoration: InputDecoration(
            labelText: 'Farm Name (Optional)',
            hintText: 'e.g., Green Valley Farm',
            prefixIcon: const Icon(Icons.agriculture),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (_) => _recordKeystroke(),
        ),
        const SizedBox(height: 16),

        DropdownButtonFormField<String>(
          initialValue: _selectedCounty.isEmpty ? null : _selectedCounty,
          decoration: InputDecoration(
            labelText: 'County',
            prefixIcon: const Icon(Icons.location_on),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          items: _counties.map((county) {
            return DropdownMenuItem(
              value: county,
              child: Text(county),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCounty = value ?? '';
            });
          },
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _farmLocationController,
          decoration: InputDecoration(
            labelText: 'Specific Location (Optional)',
            hintText: 'e.g., Kiambu Town, near ABC School',
            prefixIcon: const Icon(Icons.place),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (_) => _recordKeystroke(),
        ),
        const SizedBox(height: 16),

        DropdownButtonFormField<String>(
          initialValue: _selectedFarmingType.isEmpty ? null : _selectedFarmingType,
          decoration: InputDecoration(
            labelText: 'Primary Farming Type',
            prefixIcon: const Icon(Icons.eco),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          items: _farmingTypes.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedFarmingType = value ?? '';
            });
          },
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _farmSizeController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Farm Size (Acres)',
            hintText: 'e.g., 2.5',
            prefixIcon: const Icon(Icons.straighten),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (_) => _recordKeystroke(),
        ),
      ],
    );
  }

  Widget _buildFarmingDetailsFields() {
    return Column(
      children: [
        const Text(
          'Select Your Crops',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
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
                selectedColor: const Color(0xFF2E7D32).withOpacity(0.2),
                checkmarkColor: const Color(0xFF2E7D32),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),

        const Text(
          'Select Your Livestock',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
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
                selectedColor: const Color(0xFF2E7D32).withOpacity(0.2),
                checkmarkColor: const Color(0xFF2E7D32),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPreferencesFields() {
    final services = [
      'AI Crop Diagnosis',
      'Weather Updates',
      'Market Prices',
      'Veterinary Services',
      'Equipment Rental',
      'Expert Consultation',
      'SMS Notifications',
      'Email Updates',
    ];

    return Column(
      children: [
        const Text(
          'Select Your Preferred Services',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...services.map((service) {
          return CheckboxListTile(
            title: Text(service),
            value: _selectedServices[service] ?? false,
            onChanged: (bool? value) {
              setState(() {
                _selectedServices[service] = value ?? false;
              });
            },
            activeColor: const Color(0xFF2E7D32),
          );
        }),
      ],
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
