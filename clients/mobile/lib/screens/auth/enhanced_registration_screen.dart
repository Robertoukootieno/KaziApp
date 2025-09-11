import 'package:flutter/material.dart';
import '../../widgets/advanced_registration_widget.dart';
import '../farm_health/farm_dashboard_screen.dart';
import '../home_screen.dart';
import '../../services/user_profile_service.dart';
import '../security/security_dashboard_screen.dart';

/// Enhanced Registration Screen with Advanced Security Features
class EnhancedRegistrationScreen extends StatefulWidget {
  final String registrationStep;
  final Map<String, dynamic>? initialData;

  const EnhancedRegistrationScreen({
    super.key,
    this.registrationStep = 'basic_info',
    this.initialData,
  });

  @override
  State<EnhancedRegistrationScreen> createState() => _EnhancedRegistrationScreenState();
}

class _EnhancedRegistrationScreenState extends State<EnhancedRegistrationScreen>
    with TickerProviderStateMixin {
  
  late AnimationController _backgroundAnimation;
  late AnimationController _securityBadgeAnimation;
  
  bool _showSecurityDetails = false;
  String? _sessionToken;
  int _securityLevel = 0;
  Map<String, dynamic> _registrationData = {};

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _registrationData = widget.initialData ?? {};
  }

  @override
  void dispose() {
    _backgroundAnimation.dispose();
    _securityBadgeAnimation.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _backgroundAnimation = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    
    _securityBadgeAnimation = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _backgroundAnimation.repeat();
    _securityBadgeAnimation.forward();
  }

  void _onRegistrationSuccess(Map<String, dynamic> data, String sessionToken, int securityLevel) async {
    setState(() {
      _registrationData = data;
      _sessionToken = sessionToken;
      _securityLevel = securityLevel;
    });

    // Save user profile data
    try {
      final profileService = UserProfileService();
      await profileService.createUserProfileFromRegistration(data);
    } catch (e) {
      debugPrint('⚠️ Failed to save user profile: $e');
    }

    _showSuccessDialog(data, securityLevel);
  }

  void _onRegistrationFailure(String error) {
    _showErrorDialog(error);
  }

  void _showSuccessDialog(Map<String, dynamic> data, int securityLevel) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[600], size: 28),
              const SizedBox(width: 12),
              const Text('Registration Successful!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Welcome to KaziApp Mkulima!'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Security Level: $securityLevel%',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your account is protected with enterprise-grade security',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleGetStartedAction();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
              ),
              child: Text(_getActionButtonText()),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red[600]),
              const SizedBox(width: 12),
              const Text('Registration Failed'),
            ],
          ),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Try Again'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToNextStep() {
    String nextStep;
    switch (widget.registrationStep) {
      case 'basic_info':
        nextStep = 'identity_verification';
        break;
      case 'identity_verification':
        nextStep = 'password_setup';
        break;
      case 'password_setup':
        // After password setup, continue to farm details
        nextStep = 'farm_info';
        break;
      case 'farm_info':
        nextStep = 'farming_details';
        break;
      case 'farming_details':
        nextStep = 'preferences';
        break;
      case 'preferences':
        // Only navigate to dashboard if registration is fully completed
        if (_registrationData['registrationCompleted'] == true) {
          _navigateToDashboard();
        } else {
          // Stay on preferences until completion
          return;
        }
        return;
      default:
        nextStep = 'basic_info';
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EnhancedRegistrationScreen(
          registrationStep: nextStep,
          initialData: _registrationData,
        ),
      ),
    );
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

  void _handleGetStartedAction() {
    // Only navigate to dashboard if registration is fully completed
    if (widget.registrationStep == 'preferences' &&
        _registrationData['registrationCompleted'] == true) {
      _navigateToDashboard();
    } else {
      // Otherwise, continue to next step
      _navigateToNextStep();
    }
  }

  String _getActionButtonText() {
    switch (widget.registrationStep) {
      case 'basic_info':
        return 'Continue to Verification';
      case 'identity_verification':
        return 'Continue to Password';
      case 'password_setup':
        return 'Continue to Farm Details';
      case 'farm_info':
        return 'Continue to Farming Details';
      case 'farming_details':
        return 'Continue to Preferences';
      case 'preferences':
        return _registrationData['registrationCompleted'] == true
            ? 'Get Started'
            : 'Complete Registration';
      default:
        return 'Continue';
    }
  }

  void _toggleSecurityDetails() {
    setState(() {
      _showSecurityDetails = !_showSecurityDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    Colors.indigo[900],
                    Colors.purple[900],
                    _backgroundAnimation.value,
                  )!,
                  Color.lerp(
                    Colors.blue[800],
                    Colors.indigo[800],
                    _backgroundAnimation.value,
                  )!,
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    
                    // App Logo and Title
                    _buildHeader(),
                    
                    const SizedBox(height: 32),
                    
                    // Security Badge
                    _buildSecurityBadge(),
                    
                    const SizedBox(height: 24),
                    
                    // Advanced Registration Widget
                    AdvancedRegistrationWidget(
                      registrationStep: widget.registrationStep,
                      initialData: widget.initialData,
                      onRegistrationSuccess: _onRegistrationSuccess,
                      onRegistrationFailure: _onRegistrationFailure,
                      enableBiometrics: true,
                      enableBehavioralBiometrics: true,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Security Information
                    _buildSecurityInfo(),
                    
                    const SizedBox(height: 32),
                    
                    // Footer
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[400]!, Colors.green[600]!],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.green[400]!.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.agriculture,
            size: 60,
            color: Colors.white,
          ),
        ),
        
        const SizedBox(height: 24),
        
        Text(
          _getStepTitle(),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          _getStepDescription(),
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.8),
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSecurityBadge() {
    return AnimatedBuilder(
      animation: _securityBadgeAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _securityBadgeAnimation.value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber[400]!, Colors.orange[500]!],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber[400]!.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.security,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Enterprise Security',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSecurityInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.white.withValues(alpha: 0.8),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Advanced Security Features',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _toggleSecurityDetails,
                child: Icon(
                  _showSecurityDetails ? Icons.expand_less : Icons.expand_more,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),

          if (_showSecurityDetails) ...[
            const SizedBox(height: 16),
            _buildSecurityFeaturesList(),
          ],
        ],
      ),
    );
  }

  Widget _buildSecurityFeaturesList() {
    final features = [
      '🔐 AES-256-GCM Encryption',
      '🛡️ Zero-Trust Architecture',
      '🧠 Behavioral Biometrics',
      '📱 Device Fingerprinting',
      '⚠️ Real-time Threat Detection',
      '🔑 Multi-Factor Authentication',
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Text(
                feature,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          'Secured by KaziApp Enterprise Security',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SecurityDashboardScreen(),
                  ),
                );
              },
              child: Text(
                'Security Dashboard',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getStepTitle() {
    switch (widget.registrationStep) {
      case 'basic_info':
        return 'Join KaziApp Mkulima';
      case 'identity_verification':
        return 'Verify Your Identity';
      case 'password_setup':
        return 'Secure Your Account';
      case 'farm_info':
        return 'Farm Information';
      case 'farming_details':
        return 'Farming Details';
      case 'preferences':
        return 'Preferences & Services';
      default:
        return 'Registration';
    }
  }

  String _getStepDescription() {
    switch (widget.registrationStep) {
      case 'basic_info':
        return 'Enter your basic information to get started with enterprise-grade security';
      case 'identity_verification':
        return 'Verify your phone number with our secure verification system';
      case 'password_setup':
        return 'Create a strong password to complete your secure registration';
      case 'farm_info':
        return 'Tell us about your farm location and basic information';
      case 'farming_details':
        return 'Select your crops and livestock for personalized services';
      case 'preferences':
        return 'Choose your preferred services and complete your registration';
      default:
        return 'Complete your registration with advanced security';
    }
  }
}
