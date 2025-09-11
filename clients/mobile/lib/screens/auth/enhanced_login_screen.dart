import 'package:flutter/material.dart';
import '../../widgets/advanced_auth_widget.dart';
import '../farm_health/farm_dashboard_screen.dart';

/// Enhanced Login Screen with Advanced Security Features
class EnhancedLoginScreen extends StatefulWidget {
  const EnhancedLoginScreen({super.key});

  @override
  State<EnhancedLoginScreen> createState() => _EnhancedLoginScreenState();
}

class _EnhancedLoginScreenState extends State<EnhancedLoginScreen>
    with TickerProviderStateMixin {
  
  late AnimationController _backgroundAnimationController;
  late AnimationController _securityBadgeController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _securityBadgeAnimation;
  
  bool _showSecurityDetails = false;
  String? _sessionToken;
  int _securityLevel = 0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startBackgroundAnimation();
  }

  @override
  void dispose() {
    _backgroundAnimationController.dispose();
    _securityBadgeController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    _securityBadgeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.linear,
    ));
    
    _securityBadgeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _securityBadgeController,
      curve: Curves.elasticOut,
    ));
  }

  void _startBackgroundAnimation() {
    _backgroundAnimationController.repeat();
    _securityBadgeController.forward();
  }

  void _onAuthSuccess(String sessionToken, int securityLevel) {
    setState(() {
      _sessionToken = sessionToken;
      _securityLevel = securityLevel;
    });

    // Show success animation
    _showSuccessDialog();
  }

  void _onAuthFailure(String error) {
    _showErrorDialog(error);
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(
                  Icons.verified_user,
                  color: Colors.green[600],
                  size: 40,
                ),
              ),
              
              const SizedBox(height: 24),
              
              const Text(
                'Authentication Successful!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              Text(
                'Security Level: $_securityLevel%',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _navigateToDashboard();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Continue to Dashboard'),
                ),
              ),
            ],
          ),
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
              const Text('Authentication Failed'),
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

  void _navigateToDashboard() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const FarmDashboardScreen(),
      ),
    );
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
                    const SizedBox(height: 40),
                    
                    // App Logo and Title
                    _buildHeader(),
                    
                    const SizedBox(height: 40),
                    
                    // Security Badge
                    _buildSecurityBadge(),
                    
                    const SizedBox(height: 32),
                    
                    // Advanced Authentication Widget
                    AdvancedAuthWidget(
                      onAuthSuccess: _onAuthSuccess,
                      onAuthFailure: _onAuthFailure,
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
        
        const Text(
          'KaziApp Mkulima',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          'Secure Agricultural Services Platform',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.8),
            fontWeight: FontWeight.w400,
          ),
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
                  Icons.verified_user,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Enterprise Security',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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
    return GestureDetector(
      onTap: _toggleSecurityDetails,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Security Features',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  _showSecurityDetails ? Icons.expand_less : Icons.expand_more,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ],
            ),
            
            if (_showSecurityDetails) ...[
              const SizedBox(height: 16),
              _buildSecurityFeaturesList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityFeaturesList() {
    final features = [
      '🔐 Multi-Factor Authentication',
      '🧠 Behavioral Biometrics',
      '🛡️ Zero-Trust Architecture',
      '🔍 Real-time Threat Detection',
      '📱 Device Fingerprinting',
      '🔒 End-to-End Encryption',
      '⚡ Continuous Verification',
      '🎯 Risk-Based Authentication',
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Text(
                feature.split(' ')[0],
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  feature.substring(feature.indexOf(' ') + 1),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
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
          'Protected by Advanced Security',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shield,
              color: Colors.white.withValues(alpha: 0.6),
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              'Bank-Grade Encryption',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
