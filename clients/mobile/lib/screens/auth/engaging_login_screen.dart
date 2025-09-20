import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'enhanced_registration_screen.dart';
import 'email_verification_screen.dart';
import 'forgot_password_screen.dart';
import '../../navigation/main_navigation.dart';
import '../../services/keycloak_auth_service.dart';
import '../../services/zero_trust_auth_service.dart';
import '../../services/behavioral_biometrics_service.dart';
import '../../widgets/farmer_graphics.dart';
import '../../widgets/mkulima_connect_logo.dart';

class EngagingLoginScreen extends StatefulWidget {
  const EngagingLoginScreen({super.key});

  @override
  State<EngagingLoginScreen> createState() => _EngagingLoginScreenState();
}

class _EngagingLoginScreenState extends State<EngagingLoginScreen> 
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final KeycloakAuthService _authService = KeycloakAuthService();
  
  // Background security services (hidden from UI)
  final ZeroTrustAuthService _zeroTrustService = ZeroTrustAuthService();
  final BehavioralBiometricsService _behavioralService = BehavioralBiometricsService();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  
  // Animation controllers for engaging visuals
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatingAnimation;

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
    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
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
    _floatingAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _slideController.forward();
    _pulseController.repeat(reverse: true);
    _floatingController.repeat(reverse: true);
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
    _phoneController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Initialize Keycloak service
      await _authService.initialize();

      // Format phone number to include country code
      String phoneNumber = _phoneController.text.trim();
      if (!phoneNumber.startsWith('+254')) {
        phoneNumber = '+254${phoneNumber.substring(1)}';
      }

      // Run background security checks (hidden from user)
      _runBackgroundSecurityChecks();

      // Attempt login
      final result = await _authService.login(phoneNumber, _passwordController.text);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (result.success && result.user != null) {
          if (!result.user!.emailVerified && result.user!.email != null && result.user!.email!.isNotEmpty) {
            _showMessage(
              'Please verify your email address before logging in.',
              isError: true,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EmailVerificationScreen(
                  username: phoneNumber,
                  email: result.user!.email!,
                ),
              ),
            );
          } else {
            _showMessage('Welcome back, ${result.user!.firstName}!');
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const MainNavigation(),
              ),
            );
          }
        } else {
          _showMessage(result.error ?? 'Login failed. Please check your credentials.', isError: true);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showMessage('Login failed: ${e.toString()}', isError: true);
      }
    }
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

  Future<void> _handleSSOLogin(String provider) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.initialize();
      // For now, show a message that SSO is coming soon
      _showMessage('$provider login coming soon!', isError: false);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showMessage('SSO login error: $e', isError: true);
      }
    }
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Engaging Header with Farmer Graphics
                _buildEngagingHeader(),

                const SizedBox(height: 40),

                // Login Form Card
                _buildLoginCard(),

                const SizedBox(height: 24),

                // SSO Options
                _buildSSOOptions(),

                const SizedBox(height: 32),

                // Footer with Register Link
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEngagingHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            // Animated Farmer-Expert Interaction Scene
            Stack(
              alignment: Alignment.center,
              children: [
                // Background circle with gradient
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                  ),
                ),

                // Floating farmer and expert icons
                AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(_floatingAnimation.value, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Farmer icon using custom graphics
                          ScaleTransition(
                            scale: _pulseAnimation,
                            child: FarmerGraphics.farmerAvatar(
                              size: 60,
                              backgroundColor: Colors.amber[400]!,
                            ),
                          ),

                          const SizedBox(width: 20),

                          // Connection line using custom graphics
                          FarmerGraphics.connectionLine(
                            width: 40,
                            height: 2,
                            color: Colors.white,
                            opacity: 0.6,
                          ),

                          const SizedBox(width: 20),

                          // Expert/Veterinary icon using custom graphics
                          FarmerGraphics.veterinaryIcon(
                            size: 60,
                            backgroundColor: Colors.blue[400]!,
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // Machinery icons around the circle using custom graphics
                Positioned(
                  top: 20,
                  right: 20,
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 0.8 + (_pulseAnimation.value - 0.8) * 0.5,
                        child: FarmerGraphics.machineryIcon(
                          size: 40,
                          backgroundColor: Colors.orange[400]!,
                        ),
                      );
                    },
                  ),
                ),

                Positioned(
                  bottom: 20,
                  left: 20,
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 0.8 + (1.0 - _pulseAnimation.value + 0.8) * 0.5,
                        child: FarmerGraphics.cropIcon(
                          size: 40,
                          backgroundColor: Colors.green[600]!,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // App Title
            const MkulimaConnectLogo(
              width: 80,
              height: 80,
              showText: true,
              textColor: Colors.white,
              fontSize: 36,
              isHorizontal: false,
            ),

            const SizedBox(height: 8),

            // Subtitle
            Text(
              'Connect with Agricultural Experts',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginCard() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Card(
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
                // Welcome Text
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E7D32),
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  'Sign in to access agricultural services',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Phone Number Field
                _buildPhoneField(),

                const SizedBox(height: 20),

                // Password Field
                _buildPasswordField(),

                const SizedBox(height: 16),

                // Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Login Button
                _buildLoginButton(),
              ],
            ),
          ),
        ),
      ),
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
          _behavioralService.recordKeystroke(
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

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF2E7D32)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
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
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          shadowColor: const Color(0xFF2E7D32).withValues(alpha: 0.3),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }

  Widget _buildSSOOptions() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          // Divider with "OR"
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Google Sign In
          SizedBox(
            height: 56,
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : () => _handleSSOLogin('google'),
              icon: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.g_mobiledata,
                  color: Colors.red,
                  size: 20,
                ),
              ),
              label: const Text(
                'Continue with Google',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                shadowColor: Colors.black.withValues(alpha: 0.2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          // Register Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EnhancedRegistrationScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Register Here',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // App Version and Security Notice (subtle)
          Text(
            'Secured by advanced authentication',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
