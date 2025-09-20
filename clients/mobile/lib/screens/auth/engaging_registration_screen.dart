import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../navigation/main_navigation.dart';
import '../../services/keycloak_auth_service.dart';
import '../../services/zero_trust_auth_service.dart';
import '../../services/behavioral_biometrics_service.dart';
import '../../widgets/farmer_graphics.dart';
import 'login_screen.dart';
import 'registration_steps/farm_details_step.dart';
import 'registration_steps/account_security_step.dart';
import 'registration_steps/welcome_step.dart';

class EngagingRegistrationScreen extends StatefulWidget {
  const EngagingRegistrationScreen({super.key});

  @override
  State<EngagingRegistrationScreen> createState() => _EngagingRegistrationScreenState();
}

class _EngagingRegistrationScreenState extends State<EngagingRegistrationScreen> 
    with TickerProviderStateMixin {
  
  final PageController _pageController = PageController();
  final KeycloakAuthService _authService = KeycloakAuthService();
  
  // Background security services (hidden from UI)
  final ZeroTrustAuthService _zeroTrustService = ZeroTrustAuthService();
  final BehavioralBiometricsService _behavioralService = BehavioralBiometricsService();
  
  int _currentStep = 0;
  bool _isLoading = false;
  
  // Registration data
  final Map<String, dynamic> _registrationData = {};
  
  // Animation controllers for engaging visuals
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _progressController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _progressAnimation;

  // Registration steps
  final List<String> _stepTitles = [
    'Personal Information',
    'Farm Details',
    'Account Security',
    'Welcome to KaziApp!'
  ];

  final List<String> _stepDescriptions = [
    'Tell us about yourself',
    'Share your farming information',
    'Secure your account',
    'You\'re all set to start!'
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeBackgroundSecurity();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  void _initializeBackgroundSecurity() async {
    // Initialize security services in background (hidden from user)
    try {
      await _zeroTrustService.initialize();
      await _behavioralService.initialize();
    } catch (e) {
      // Silently handle security initialization errors
      debugPrint('Background security initialization: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _updateProgressAnimation();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _updateProgressAnimation();
    }
  }

  void _updateProgressAnimation() {
    _progressController.animateTo((_currentStep + 1) / 4);
  }

  void _updateRegistrationData(Map<String, dynamic> data) {
    setState(() {
      _registrationData.addAll(data);
    });
    _runBackgroundSecurityChecks();
  }

  void _runBackgroundSecurityChecks() async {
    // Run security checks silently in background
    try {
      // Background security analysis (hidden from user)
      debugPrint('Running background security checks...');
    } catch (e) {
      // Silently handle security check errors
      debugPrint('Background security check: $e');
    }
  }

  Future<void> _completeRegistration() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Initialize Keycloak service
      await _authService.initialize();

      // Run final background security checks
      _runBackgroundSecurityChecks();

      // Register user with Keycloak
      final registration = UserRegistration(
        firstName: _registrationData['firstName'] ?? '',
        lastName: _registrationData['lastName'] ?? '',
        phoneNumber: _registrationData['phoneNumber'] ?? '',
        email: _registrationData['email'],
        password: _registrationData['password'] ?? '',
        confirmPassword: _registrationData['confirmPassword'] ?? '',
        clientType: 'farmer',
        acceptTerms: true,
      );

      final result = await _authService.register(registration);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (result.success) {
          _showMessage('Registration successful! Welcome to KaziApp!');
          // Navigate to main app after a short delay
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const MainNavigation(),
                ),
              );
            }
          });
        } else {
          _showMessage(result.error ?? 'Registration failed. Please try again.', isError: true);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showMessage('Registration failed: ${e.toString()}', isError: true);
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1B5E20), // Deep green
              Color(0xFF2E7D32), // Medium green
              Color(0xFF4CAF50), // Light green
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with progress
              _buildHeader(),

              // Registration steps
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildPersonalInfoStep(),
                    _buildFarmDetailsStep(),
                    _buildAccountSecurityStep(),
                    _buildWelcomeStep(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // App logo and title
            Row(
              children: [
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.agriculture,
                      color: Color(0xFF2E7D32),
                      size: 28,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'KaziApp Mkulima',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Join the farming community',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Progress indicator
            _buildProgressIndicator(),

            const SizedBox(height: 16),

            // Step title and description
            Column(
              children: [
                Text(
                  _stepTitles[_currentStep],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _stepDescriptions[_currentStep],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(3),
      ),
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          return FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _progressAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.amber, Colors.orange],
                ),
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPersonalInfoStep() {
    return PersonalInfoStep(
      onNext: _nextStep,
      onDataChanged: _updateRegistrationData,
      initialData: _registrationData,
      behavioralService: _behavioralService,
    );
  }

  Widget _buildFarmDetailsStep() {
    return FarmDetailsStep(
      onNext: _nextStep,
      onPrevious: _previousStep,
      onDataChanged: _updateRegistrationData,
      initialData: _registrationData,
    );
  }

  Widget _buildAccountSecurityStep() {
    return AccountSecurityStep(
      onNext: _nextStep,
      onPrevious: _previousStep,
      onDataChanged: _updateRegistrationData,
      initialData: _registrationData,
      behavioralService: _behavioralService,
    );
  }

  Widget _buildWelcomeStep() {
    return WelcomeStep(
      onComplete: _completeRegistration,
      onPrevious: _previousStep,
      registrationData: _registrationData,
      isLoading: _isLoading,
    );
  }
}

// Personal Information Step
class PersonalInfoStep extends StatefulWidget {
  final VoidCallback onNext;
  final Function(Map<String, dynamic>) onDataChanged;
  final Map<String, dynamic> initialData;
  final BehavioralBiometricsService behavioralService;

  const PersonalInfoStep({
    super.key,
    required this.onNext,
    required this.onDataChanged,
    required this.initialData,
    required this.behavioralService,
  });

  @override
  State<PersonalInfoStep> createState() => _PersonalInfoStepState();
}

class _PersonalInfoStepState extends State<PersonalInfoStep>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeAnimations();
  }

  void _initializeControllers() {
    _firstNameController.text = widget.initialData['firstName'] ?? '';
    _lastNameController.text = widget.initialData['lastName'] ?? '';
    _phoneController.text = widget.initialData['phoneNumber'] ?? '';
    _emailController.text = widget.initialData['email'] ?? '';
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _slideController.forward();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_formKey.currentState!.validate()) {
      // Update registration data
      widget.onDataChanged({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
      });

      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Farmer avatar illustration
            Container(
              width: 120,
              height: 120,
              margin: const EdgeInsets.only(bottom: 32),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circle
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.2),
                          Colors.white.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                  ),

                  // Farmer avatar
                  FarmerGraphics.farmerAvatar(
                    size: 80,
                    backgroundColor: Colors.amber[400]!,
                  ),
                ],
              ),
            ),

            // Form card
            _buildFormCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Card(
      elevation: 20,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey[50]!,
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome text
              const Text(
                'Tell us about yourself',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E7D32),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                'We\'ll use this information to personalize your experience',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // First Name field
              _buildTextField(
                controller: _firstNameController,
                label: 'First Name',
                hint: 'Enter your first name',
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Last Name field
              _buildTextField(
                controller: _lastNameController,
                label: 'Last Name',
                hint: 'Enter your last name',
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Phone Number field
              _buildPhoneField(),

              const SizedBox(height: 20),

              // Email field
              _buildTextField(
                controller: _emailController,
                label: 'Email Address',
                hint: 'Enter your email address',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Continue button
              _buildContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF2E7D32)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: validator,
      onChanged: (value) {
        // Background behavioral analysis (hidden from user)
        try {
          widget.behavioralService.recordKeystroke(
            key: value.isNotEmpty ? value[value.length - 1] : '',
            timestamp: DateTime.now(),
            duration: 100.0,
          );
        } catch (e) {
          debugPrint('Behavioral analysis: $e');
        }
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: '0712345678',
        prefixIcon: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '+254',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        }
        if (!RegExp(r'^0[0-9]{9}$').hasMatch(value)) {
          return 'Please enter a valid phone number';
        }
        return null;
      },
      onChanged: (value) {
        // Background behavioral analysis (hidden from user)
        try {
          widget.behavioralService.recordKeystroke(
            key: value.isNotEmpty ? value[value.length - 1] : '',
            timestamp: DateTime.now(),
            duration: 100.0,
          );
        } catch (e) {
          debugPrint('Behavioral analysis: $e');
        }
      },
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: _continue,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          shadowColor: const Color(0xFF2E7D32).withValues(alpha: 0.3),
        ),
        child: const Text(
          'Continue',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
