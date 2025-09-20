import 'package:flutter/material.dart';
import '../../widgets/advanced_registration_widget.dart';
import '../../widgets/farmer_graphics.dart';
import '../../widgets/mkulima_connect_logo.dart';

import '../home_screen.dart';
import '../../services/user_profile_service.dart';

/// Enhanced Registration Screen with Advanced Security Features (Hidden UI)
/// All security features run in background while providing engaging farmer-focused UI
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
  // Professional animation controllers for enhanced UI
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _logoController;
  late AnimationController _backgroundController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _backgroundAnimation;

  Map<String, dynamic> _registrationData = {};
  bool _isScreenReady = false;

  @override
  void initState() {
    super.initState();
    _registrationData = widget.initialData ?? {};
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Fade animation for overall screen
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Slide animation for content
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Logo animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    // Background gradient animation
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimationSequence() {
    // Start background animation once (no repeat to prevent flickering)
    _backgroundController.forward();

    // Delay before showing content
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isScreenReady = true;
        });

        // Start logo animation
        _logoController.forward();

        // Start fade animation
        _fadeController.forward();

        // Start slide animation with delay
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            _slideController.forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _logoController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  void _onRegistrationSuccess(Map<String, dynamic> data, String sessionToken, int securityLevel) async {
    setState(() {
      _registrationData = data;
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



  @override
  Widget build(BuildContext context) {
    if (!_isScreenReady) {
      return _buildLoadingScreen();
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.lerp(
                const Color(0xFF1B5E20),
                const Color(0xFF2E7D32),
                _backgroundAnimation.value,
              )!,
              Color.lerp(
                const Color(0xFF2E7D32),
                const Color(0xFF4CAF50),
                _backgroundAnimation.value,
              )!,
              Color.lerp(
                const Color(0xFF4CAF50),
                const Color(0xFF66BB6A),
                _backgroundAnimation.value,
              )!,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Static background particles (no animation to prevent flickering)
            _buildStaticParticles(),

            // Main content
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // Animated Engaging Header
                        _buildAnimatedHeader(),

                        const SizedBox(height: 32),

                        // Advanced Registration Widget (Security features hidden)
                        AdvancedRegistrationWidget(
                          registrationStep: widget.registrationStep,
                          initialData: widget.initialData,
                          onRegistrationSuccess: _onRegistrationSuccess,
                          onRegistrationFailure: _onRegistrationFailure,
                          enableBiometrics: true,
                          enableBehavioralBiometrics: true,
                          hideSecurityWidgets: true, // Hide all security UI elements
                        ),

                        const SizedBox(height: 32),

                        // Engaging Footer with Farmer Graphics
                        _buildEngagingFooter(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF2E7D32),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Static logo (no animation during loading to prevent flickering)
            const MkulimaConnectLogo(
              width: 80,
              height: 80,
              showText: true,
              textColor: Colors.white,
              fontSize: 24,
              isHorizontal: false,
            ),

            const SizedBox(height: 32),

            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),

            const SizedBox(height: 24),

            // Loading text
            Text(
              'Preparing your registration...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaticParticles() {
    return CustomPaint(
      painter: StaticParticlesPainter(),
      size: Size.infinite,
    );
  }

  Widget _buildAnimatedHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Animated logo with controlled animation
          AnimatedBuilder(
            animation: _logoController,
            builder: (context, child) {
              return Transform.scale(
                scale: _logoScaleAnimation.value,
                child: const MkulimaConnectLogo(
                  width: 100,
                  height: 100,
                  showText: false,
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Animated title
          FadeTransition(
            opacity: _fadeAnimation,
            child: const Text(
              'Join Mkulima Connect',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
                shadows: [
                  Shadow(
                    offset: Offset(0, 2),
                    blurRadius: 4,
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Animated subtitle
          SlideTransition(
            position: _slideAnimation,
            child: Text(
              'Connect with agricultural experts and grow your farming business',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }







  Widget _buildEngagingFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Farm scene illustration
          SizedBox(
            height: 80,
            width: double.infinity,
            child: FarmerGraphics.farmScene(
              width: double.infinity,
              height: 80,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Empowering Kenyan Farmers',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Join thousands of farmers already using KaziApp to improve their farming practices and connect with agricultural experts.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Custom painter for static background particles (no animation to prevent flickering)
class StaticParticlesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    // Draw static floating particles
    for (int i = 0; i < 15; i++) {
      final x = size.width * (i * 0.1 + 0.15);
      final y = size.height * (i * 0.08 + 0.2);
      final radius = 2.0 + (i % 3);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
