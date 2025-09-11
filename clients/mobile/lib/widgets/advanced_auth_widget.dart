import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/zero_trust_auth_service.dart';
import '../services/behavioral_biometrics_service.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/registration/welcome_basic_info_screen.dart';

/// Advanced Authentication Widget with Security Indicators
class AdvancedAuthWidget extends StatefulWidget {
  final Function(String sessionToken, int securityLevel) onAuthSuccess;
  final Function(String error) onAuthFailure;
  final bool enableBiometrics;
  final bool enableBehavioralBiometrics;

  const AdvancedAuthWidget({
    super.key,
    required this.onAuthSuccess,
    required this.onAuthFailure,
    this.enableBiometrics = true,
    this.enableBehavioralBiometrics = true,
  });

  @override
  State<AdvancedAuthWidget> createState() => _AdvancedAuthWidgetState();
}

class _AdvancedAuthWidgetState extends State<AdvancedAuthWidget>
    with TickerProviderStateMixin {
  
  // Services
  final ZeroTrustAuthService _authService = ZeroTrustAuthService();
  final BehavioralBiometricsService _behavioralService = BehavioralBiometricsService();
  
  // Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _securityAnimationController;
  late AnimationController _loadingAnimationController;
  
  // State
  bool _isLoading = false;
  bool _obscurePassword = true;
  int _securityLevel = 0;
  double _behavioralProgress = 0.0;
  List<SecurityIndicator> _securityIndicators = [];
  String? _errorMessage;
  
  // Behavioral tracking
  DateTime? _lastKeyPress;
  final Map<String, DateTime> _keyDownTimes = {};

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _setupAnimations();
    _setupBehavioralTracking();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _securityAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  Future<void> _initializeServices() async {
    try {
      await _authService.initialize();
      if (widget.enableBehavioralBiometrics) {
        await _behavioralService.initialize();
        _updateBehavioralProgress();
      }
      _updateSecurityIndicators();
    } catch (e) {
      debugPrint('❌ Failed to initialize auth services: $e');
    }
  }

  void _setupAnimations() {
    _securityAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  void _setupBehavioralTracking() {
    if (!widget.enableBehavioralBiometrics) return;
    
    // Track typing patterns
    _usernameController.addListener(_trackTyping);
    _passwordController.addListener(_trackTyping);
  }

  void _trackTyping() {
    final now = DateTime.now();
    
    if (_lastKeyPress != null) {
      final flightTime = now.difference(_lastKeyPress!);
      
      // Record typing event (simplified)
      _behavioralService.recordTypingEvent(
        key: 'generic', // In production, you'd track specific keys
        type: TypingEventType.keyDown,
        dwellTime: const Duration(milliseconds: 100), // Simplified
        flightTime: flightTime,
      );
    }
    
    _lastKeyPress = now;
    _updateBehavioralProgress();
  }

  void _updateBehavioralProgress() {
    if (!widget.enableBehavioralBiometrics) return;
    
    setState(() {
      _behavioralProgress = _behavioralService.profileCompleteness;
    });
  }

  void _updateSecurityIndicators() {
    _securityIndicators = [
      SecurityIndicator(
        icon: Icons.fingerprint,
        label: 'Biometric Auth',
        status: widget.enableBiometrics ? SecurityStatus.enabled : SecurityStatus.disabled,
        description: 'Fingerprint/Face ID authentication',
      ),
      SecurityIndicator(
        icon: Icons.psychology,
        label: 'Behavioral Analysis',
        status: widget.enableBehavioralBiometrics ? SecurityStatus.learning : SecurityStatus.disabled,
        description: 'Continuous user behavior verification',
        progress: _behavioralProgress,
      ),
      SecurityIndicator(
        icon: Icons.security,
        label: 'Zero-Trust',
        status: SecurityStatus.enabled,
        description: 'Continuous session verification',
      ),
      SecurityIndicator(
        icon: Icons.shield,
        label: 'Threat Detection',
        status: SecurityStatus.enabled,
        description: 'Real-time security monitoring',
      ),
    ];
    
    _securityLevel = _calculateSecurityLevel();
    _securityAnimationController.animateTo(_securityLevel / 100.0);
  }

  int _calculateSecurityLevel() {
    int level = 30; // Base level
    
    for (final indicator in _securityIndicators) {
      switch (indicator.status) {
        case SecurityStatus.enabled:
          level += 20;
          break;
        case SecurityStatus.learning:
          level += (10 + (indicator.progress * 10)).round();
          break;
        case SecurityStatus.warning:
          level += 5;
          break;
        case SecurityStatus.disabled:
          break;
      }
    }
    
    return level.clamp(0, 100);
  }

  Future<void> _authenticate() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter both username and password';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _loadingAnimationController.repeat();

    try {
      // Record touch event for behavioral analysis
      if (widget.enableBehavioralBiometrics) {
        _behavioralService.recordTouchEvent(
          x: 200, // Simplified - in production, get actual touch coordinates
          y: 400,
          type: TouchType.down,
          pressure: 1.0,
          size: 10.0,
        );
      }

      // Format phone number to include country code
      String phoneNumber = _usernameController.text.trim();
      if (phoneNumber.isNotEmpty && !phoneNumber.startsWith('+254')) {
        // Remove leading 0 if present and add +254
        if (phoneNumber.startsWith('0')) {
          phoneNumber = '+254${phoneNumber.substring(1)}';
        } else {
          phoneNumber = '+254$phoneNumber';
        }
      }

      final result = await _authService.authenticate(
        username: phoneNumber,
        password: _passwordController.text,
        additionalContext: {
          'behavioralProgress': _behavioralProgress,
          'securityLevel': _securityLevel,
        },
      );

      if (result.success) {
        widget.onAuthSuccess(result.sessionToken!, result.riskScore!);
      } else {
        setState(() {
          _errorMessage = result.errorMessage;
        });
        widget.onAuthFailure(result.errorMessage ?? 'Authentication failed');
      }

    } catch (e) {
      setState(() {
        _errorMessage = 'Authentication error: $e';
      });
      widget.onAuthFailure('Authentication error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
      _loadingAnimationController.stop();
    }
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
          
          // Security Indicators Grid
          _buildSecurityIndicators(),
          
          const SizedBox(height: 32),
          
          // Username Field
          _buildUsernameField(),
          
          const SizedBox(height: 16),
          
          // Password Field
          _buildPasswordField(),
          
          const SizedBox(height: 24),
          
          // Error Message
          if (_errorMessage != null) _buildErrorMessage(),
          
          // Forgot Password Link
          _buildForgotPasswordLink(),

          const SizedBox(height: 16),

          // Authentication Button
          _buildAuthButton(),

          const SizedBox(height: 16),

          // Register Link
          _buildRegisterLink(),

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

  Widget _buildSecurityIndicators() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: _securityIndicators.length,
      itemBuilder: (context, index) {
        final indicator = _securityIndicators[index];
        return _buildSecurityIndicatorCard(indicator);
      },
    );
  }

  Widget _buildSecurityIndicatorCard(SecurityIndicator indicator) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(indicator.status).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            indicator.icon,
            color: _getStatusColor(indicator.status),
            size: 24,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            indicator.label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 4),
          
          if (indicator.progress > 0) ...[
            LinearProgressIndicator(
              value: indicator.progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(_getStatusColor(indicator.status)),
              minHeight: 3,
            ),
            const SizedBox(height: 4),
          ],
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _getStatusColor(indicator.status).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              indicator.status.name.toUpperCase(),
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: _getStatusColor(indicator.status),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10), // Limit to 10 digits after +254
      ],
      decoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: '0712345678',
        prefixIcon: const Icon(Icons.phone),
        prefixText: '+254 ',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (_) => _updateSecurityIndicators(),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
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
      onChanged: (_) => _updateSecurityIndicators(),
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

  Widget _buildAuthButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _authenticate,
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
                      const Text('Authenticating...'),
                    ],
                  );
                },
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.security, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Secure Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildBehavioralProgress() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: Colors.blue[600], size: 20),
              const SizedBox(width: 8),
              const Text(
                'Behavioral Learning',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
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
            '${(_behavioralProgress * 100).toInt()}% complete - Learning your unique patterns',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

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
        return Colors.grey;
    }
  }

  Widget _buildForgotPasswordLink() {
    return Align(
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
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.w600,
            fontSize: 14,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account? ",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WelcomeBasicInfoScreen(),
                ),
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Register Here',
              style: TextStyle(
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.bold,
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Supporting classes
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
