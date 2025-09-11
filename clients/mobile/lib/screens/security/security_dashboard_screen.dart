import 'package:flutter/material.dart';
import '../../services/zero_trust_auth_service.dart';
import '../../services/behavioral_biometrics_service.dart';

/// Security Dashboard for monitoring authentication and security status
class SecurityDashboardScreen extends StatefulWidget {
  const SecurityDashboardScreen({super.key});

  @override
  State<SecurityDashboardScreen> createState() => _SecurityDashboardScreenState();
}

class _SecurityDashboardScreenState extends State<SecurityDashboardScreen>
    with TickerProviderStateMixin {
  
  final ZeroTrustAuthService _authService = ZeroTrustAuthService();
  final BehavioralBiometricsService _behavioralService = BehavioralBiometricsService();
  
  late AnimationController _riskMeterController;
  late Animation<double> _riskMeterAnimation;
  
  int _currentRiskScore = 0;
  bool _isLoading = true;
  List<SecurityEvent> _recentEvents = [];
  BehavioralProfile? _behavioralProfile;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadSecurityData();
  }

  @override
  void dispose() {
    _riskMeterController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _riskMeterController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _riskMeterAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _riskMeterController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _loadSecurityData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Load current risk score
      _currentRiskScore = _authService.currentRiskScore;
      
      // Load recent security events
      _recentEvents = _authService.securityEvents.take(10).toList();
      
      // Load behavioral profile
      _behavioralProfile = _behavioralService.userProfile;
      
      // Animate risk meter
      _riskMeterController.animateTo(_currentRiskScore / 100.0);
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Failed to load security data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Security Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.indigo[600],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSecurityData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadSecurityData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Risk Score Meter
                    _buildRiskScoreMeter(),
                    
                    const SizedBox(height: 24),
                    
                    // Security Status Cards
                    _buildSecurityStatusCards(),
                    
                    const SizedBox(height: 24),
                    
                    // Behavioral Profile Section
                    if (_behavioralProfile != null) _buildBehavioralProfileSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Recent Security Events
                    _buildRecentEventsSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Security Recommendations
                    _buildSecurityRecommendations(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildRiskScoreMeter() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo[600]!, Colors.purple[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo[600]!.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(
                Icons.security,
                color: Colors.white,
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                'Current Risk Score',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Risk Meter
          SizedBox(
            width: 200,
            height: 200,
            child: AnimatedBuilder(
              animation: _riskMeterAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: RiskMeterPainter(
                    progress: _riskMeterAnimation.value * (_currentRiskScore / 100.0),
                    riskScore: _currentRiskScore,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$_currentRiskScore',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          _getRiskLevelText(),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            _getRiskDescription(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityStatusCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildStatusCard(
          'Session Status',
          _authService.isAuthenticated ? 'Active' : 'Inactive',
          _authService.isAuthenticated ? Icons.check_circle : Icons.error,
          _authService.isAuthenticated ? Colors.green : Colors.red,
        ),
        _buildStatusCard(
          'Behavioral Learning',
          '${(_behavioralService.profileCompleteness * 100).toInt()}%',
          Icons.psychology,
          Colors.blue,
        ),
        _buildStatusCard(
          'Security Events',
          '${_recentEvents.length}',
          Icons.event_note,
          Colors.orange,
        ),
        _buildStatusCard(
          'Threat Level',
          _getThreatLevel(),
          Icons.warning,
          _getThreatLevelColor(),
        ),
      ],
    );
  }

  Widget _buildStatusCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          
          const SizedBox(height: 4),
          
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBehavioralProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology,
                color: Colors.blue[600],
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Behavioral Profile',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Profile created with ${_behavioralProfile!.samplesUsed} behavioral samples',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildProfileMetric(
                  'Touch Patterns',
                  _behavioralProfile!.touchProfile.averagePressure.toStringAsFixed(2),
                  'Avg Pressure',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildProfileMetric(
                  'Typing Speed',
                  '${_behavioralProfile!.typingProfile.keyProfiles.length}',
                  'Keys Learned',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMetric(String title, String value, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.blue[600],
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentEventsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.event_note,
                color: Colors.orange[600],
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Recent Security Events',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          if (_recentEvents.isEmpty)
            Text(
              'No recent security events',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            )
          else
            ...(_recentEvents.take(5).map((event) => _buildEventItem(event)).toList()),
        ],
      ),
    );
  }

  Widget _buildEventItem(SecurityEvent event) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getEventColor(event.type),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          
          const SizedBox(width: 12),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getEventDescription(event.type),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatEventTime(event.timestamp),
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

  Widget _buildSecurityRecommendations() {
    final recommendations = _getSecurityRecommendations();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: Colors.amber[600],
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Security Recommendations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          ...recommendations.map((rec) => _buildRecommendationItem(rec)),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(String recommendation) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.amber[600],
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              recommendation,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _getRiskLevelText() {
    if (_currentRiskScore <= 30) return 'LOW RISK';
    if (_currentRiskScore <= 60) return 'MEDIUM RISK';
    return 'HIGH RISK';
  }

  String _getRiskDescription() {
    if (_currentRiskScore <= 30) return 'Your account security is excellent';
    if (_currentRiskScore <= 60) return 'Some security concerns detected';
    return 'Immediate security attention required';
  }

  String _getThreatLevel() {
    if (_currentRiskScore <= 30) return 'Low';
    if (_currentRiskScore <= 60) return 'Medium';
    return 'High';
  }

  Color _getThreatLevelColor() {
    if (_currentRiskScore <= 30) return Colors.green;
    if (_currentRiskScore <= 60) return Colors.orange;
    return Colors.red;
  }

  Color _getEventColor(SecurityEventType type) {
    switch (type) {
      case SecurityEventType.authenticationSucceeded:
        return Colors.green;
      case SecurityEventType.authenticationFailed:
        return Colors.red;
      case SecurityEventType.riskScoreExceeded:
        return Colors.red;
      case SecurityEventType.highRiskDetected:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _getEventDescription(SecurityEventType type) {
    switch (type) {
      case SecurityEventType.authenticationSucceeded:
        return 'Successful authentication';
      case SecurityEventType.authenticationFailed:
        return 'Failed authentication attempt';
      case SecurityEventType.riskScoreExceeded:
        return 'Risk score threshold exceeded';
      case SecurityEventType.highRiskDetected:
        return 'High risk activity detected';
      case SecurityEventType.sessionInvalidated:
        return 'Session invalidated';
      case SecurityEventType.unauthorizedAccess:
        return 'Unauthorized access attempt';
      case SecurityEventType.forbiddenAccess:
        return 'Forbidden access attempt';
      case SecurityEventType.suspiciousActivity:
        return 'Suspicious activity detected';
      default:
        return 'Security event';
    }
  }

  String _formatEventTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }

  List<String> _getSecurityRecommendations() {
    final recommendations = <String>[];
    
    if (_currentRiskScore > 60) {
      recommendations.add('Consider changing your password immediately');
      recommendations.add('Review recent login activity for suspicious behavior');
    }
    
    if (_behavioralService.profileCompleteness < 0.8) {
      recommendations.add('Continue using the app to improve behavioral learning');
    }
    
    if (_recentEvents.any((e) => e.type == SecurityEventType.authenticationFailed)) {
      recommendations.add('Enable additional security measures like 2FA');
    }
    
    if (recommendations.isEmpty) {
      recommendations.add('Your security posture is excellent');
      recommendations.add('Continue following security best practices');
    }
    
    return recommendations;
  }
}

// Custom painter for risk meter
class RiskMeterPainter extends CustomPainter {
  final double progress;
  final int riskScore;

  RiskMeterPainter({required this.progress, required this.riskScore});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // Background circle
    final backgroundPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = _getProgressColor()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708, // Start from top
      progress * 6.2832, // Full circle
      false,
      progressPaint,
    );
  }

  Color _getProgressColor() {
    if (riskScore <= 30) return Colors.green;
    if (riskScore <= 60) return Colors.orange;
    return Colors.red;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
