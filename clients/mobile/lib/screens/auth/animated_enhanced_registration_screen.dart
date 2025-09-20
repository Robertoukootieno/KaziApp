import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../widgets/advanced_registration_widget.dart';
import '../../widgets/farmer_graphics.dart';
import '../../widgets/mkulima_connect_logo.dart';
import '../home_screen.dart';
import '../../services/user_profile_service.dart';

/// Enhanced Registration Screen with Professional Animations and Mkulima Connect Branding
/// Features smooth transitions, elegant animations, and the original logo design
class AnimatedEnhancedRegistrationScreen extends StatefulWidget {
  final String registrationStep;
  final Map<String, dynamic>? initialData;

  const AnimatedEnhancedRegistrationScreen({
    super.key,
    this.registrationStep = 'basic_info',
    this.initialData,
  });

  @override
  State<AnimatedEnhancedRegistrationScreen> createState() => _AnimatedEnhancedRegistrationScreenState();
}

class _AnimatedEnhancedRegistrationScreenState extends State<AnimatedEnhancedRegistrationScreen>
    with TickerProviderStateMixin {
  
  // Animation Controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _logoController;
  late AnimationController _backgroundController;
  late AnimationController _particleController;
  
  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _particleAnimation;
  
  // State
  Map<String, dynamic> _registrationData = {};
  bool _isScreenReady = false;
  bool _showContent = false;

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
    _logoRotationAnimation = Tween<double>(
      begin: -0.1,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
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

    // Particle animation for floating elements
    _particleController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: Curves.linear,
    ));
  }

  void _startAnimationSequence() {
    // Start background animation immediately
    _backgroundController.repeat(reverse: true);
    _particleController.repeat();
    
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
            setState(() {
              _showContent = true;
            });
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
    _particleController.dispose();
    super.dispose();
  }

  void _onRegistrationSuccess(Map<String, dynamic> data, String sessionToken, int securityLevel) async {
    setState(() {
      _registrationData = data;
    });

    // Animate out before navigation
    await _fadeController.reverse();

    if (mounted) {
      // Save user profile using the service method
      try {
        final userProfileService = UserProfileService();
        await userProfileService.createUserProfileFromRegistration(data);
      } catch (e) {
        debugPrint('Failed to save user profile: $e');
      }

      // Navigate to home screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
      }
    }
  }

  void _onRegistrationFailure(String error) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isScreenReady) {
      return _buildLoadingScreen();
    }

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
                // Animated background particles
                _buildAnimatedParticles(),
                
                // Main content
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: SafeArea(
                      child: Column(
                        children: [
                          // Animated header with logo
                          _buildAnimatedHeader(),
                          
                          // Registration content
                          Expanded(
                            child: _showContent ? _buildRegistrationContent() : const SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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
            // Animated logo
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

  Widget _buildAnimatedParticles() {
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlesPainter(_particleAnimation.value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildAnimatedHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Animated logo
          AnimatedBuilder(
            animation: _logoController,
            builder: (context, child) {
              return Transform.scale(
                scale: _logoScaleAnimation.value,
                child: Transform.rotate(
                  angle: _logoRotationAnimation.value,
                  child: const MkulimaConnectLogo(
                    width: 100,
                    height: 100,
                    showText: false,
                  ),
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

  Widget _buildRegistrationContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: AdvancedRegistrationWidget(
          registrationStep: widget.registrationStep,
          initialData: _registrationData,
          onRegistrationSuccess: _onRegistrationSuccess,
          onRegistrationFailure: _onRegistrationFailure,
          hideSecurityWidgets: true, // Hide security UI for cleaner look
        ),
      ),
    );
  }
}

// Custom painter for animated background particles
class ParticlesPainter extends CustomPainter {
  final double animationValue;
  
  ParticlesPainter(this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    
    // Draw floating particles
    for (int i = 0; i < 20; i++) {
      final x = (size.width * (i * 0.1 + 0.1) + 
                 50 * math.sin(animationValue * 2 * math.pi + i)) % size.width;
      final y = (size.height * (i * 0.05 + 0.1) + 
                 30 * math.cos(animationValue * 2 * math.pi + i * 0.5)) % size.height;
      final radius = 2 + 3 * math.sin(animationValue * 4 * math.pi + i);
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
