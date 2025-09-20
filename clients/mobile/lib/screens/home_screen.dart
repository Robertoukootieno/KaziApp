import 'package:flutter/material.dart';
import 'ai_diagnosis/ai_diagnosis_screen.dart';
import 'weather/weather_screen.dart';
import 'vets/vets_screen.dart';
import 'marketplace/marketplace_screen.dart';
import 'farm_health/farm_dashboard_screen.dart';
import 'profile/farmer_profile_screen.dart';
import 'settings/settings_screen.dart';
import 'machinery/machinery_services_screen.dart';
import '../services/farmer_profile_service.dart';
import '../services/user_profile_service.dart';
import '../models/farmer_profile.dart';
import '../widgets/profile_icon_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FarmerProfileService _profileService = FarmerProfileService();
  final UserProfileService _userProfileService = UserProfileService();
  FarmerProfile? _currentProfile;
  UserProfile? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    // Set loading to false immediately to show UI
    setState(() {
      _isLoading = false;
    });

    // Load profiles in background
    try {
      await Future.wait([
        _profileService.initialize(),
        _userProfileService.initialize(),
      ]);

      if (mounted) {
        setState(() {
          _currentProfile = _profileService.currentProfile;
          _currentUser = _userProfileService.currentUser;
        });
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load profiles: $e');
      // Continue without profile data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.agriculture, color: Colors.white),
            SizedBox(width: 8),
            Text('KaziApp'),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: const [
          // Profile Icon Widget
          ProfileIconButton(
            size: 36,
            showNotificationBadge: true,
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with gradient
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getWelcomeMessage(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your Africa-First Agricultural Platform',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Actions Section
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick Action Cards Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    children: [
                      _buildQuickActionCard(
                        context,
                        icon: Icons.psychology,
                        title: 'AI Diagnosis',
                        subtitle: 'Get instant crop & livestock diagnosis',
                        color: Colors.blue,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AIDiagnosisScreen(),
                          ),
                        ),
                      ),
                      _buildQuickActionCard(
                        context,
                        icon: Icons.wb_sunny,
                        title: 'Weather',
                        subtitle: 'Check weather forecast & alerts',
                        color: Colors.orange,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WeatherScreen(),
                          ),
                        ),
                      ),
                      _buildQuickActionCard(
                        context,
                        icon: Icons.medical_services,
                        title: 'Find Vets',
                        subtitle: 'Connect with veterinarians',
                        color: Colors.red,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VetsScreen(),
                          ),
                        ),
                      ),
                      _buildQuickActionCard(
                        context,
                        icon: Icons.store,
                        title: 'Marketplace',
                        subtitle: 'Buy & sell agricultural products',
                        color: Colors.green,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MarketplaceScreen(),
                          ),
                        ),
                      ),
                      _buildQuickActionCard(
                        context,
                        icon: Icons.agriculture,
                        title: 'Machinery',
                        subtitle: 'Rent, lease & book farm equipment',
                        color: Colors.brown,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MachineryServicesScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Farm Health Dashboard Card
                  _buildQuickActionCard(
                    context,
                    icon: Icons.dashboard,
                    title: 'Farm Health Dashboard',
                    subtitle: 'Track your farm\'s health score & productivity',
                    color: Colors.purple,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FarmDashboardScreen(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Recent Activity Section
                  const Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Activity Cards
                  _buildActivityCard(
                    'Weather Alert',
                    'Heavy rains expected tomorrow. Protect your crops.',
                    Icons.warning,
                    Colors.orange,
                    '2 hours ago',
                  ),
                  const SizedBox(height: 12),
                  _buildActivityCard(
                    'Vet Consultation',
                    'Dr. Mwangi responded to your livestock query.',
                    Icons.medical_services,
                    Colors.blue,
                    '1 day ago',
                  ),
                  const SizedBox(height: 12),
                  _buildActivityCard(
                    'Market Update',
                    'Maize prices increased by 15% this week.',
                    Icons.trending_up,
                    Colors.green,
                    '2 days ago',
                  ),
                  // Quick Actions Grid
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      _buildQuickActionCard(
                        context,
                        icon: Icons.camera_alt,
                        title: 'AI Diagnosis',
                        subtitle: 'Scan crop diseases',
                        color: Colors.green,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AIDiagnosisScreen()),
                        ),
                      ),
                      _buildQuickActionCard(
                        context,
                        icon: Icons.cloud,
                        title: 'Weather',
                        subtitle: 'Climate insights',
                        color: Colors.blue,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const WeatherScreen()),
                        ),
                      ),
                      _buildQuickActionCard(
                        context,
                        icon: Icons.phone,
                        title: 'USSD Access',
                        subtitle: 'Dial *123#',
                        color: Colors.orange,
                        onTap: () => _showUSSDInfo(context),
                      ),
                      _buildQuickActionCard(
                        context,
                        icon: Icons.payment,
                        title: 'M-Pesa',
                        subtitle: 'Mobile payments',
                        color: Colors.purple,
                        onTap: () => _showMPesaInfo(context),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Features Section
                  const Text(
                    'Platform Features',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildFeatureCard(
                    '🌾 Connect with Veterinarians',
                    'Find qualified vets in your area for livestock and crop health',
                    () {},
                  ),
                  _buildFeatureCard(
                    '📱 USSD Access (*123#)',
                    'Works on any phone, even without internet connection',
                    () => _showUSSDInfo(context),
                  ),
                  _buildFeatureCard(
                    '💰 M-Pesa Integration',
                    'Secure mobile money payments for all transactions',
                    () => _showMPesaInfo(context),
                  ),
                  _buildFeatureCard(
                    '🌍 Multi-language Support',
                    'Available in Kiswahili, Kikuyu, Luo, Kalenjin & more',
                    () => _showLanguageSelector(context),
                  ),
                  _buildFeatureCard(
                    '🤖 AI-powered Diagnostics',
                    'Smart crop disease detection and treatment recommendations',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AIDiagnosisScreen()),
                    ),
                  ),
                  _buildFeatureCard(
                    '🏘️ Community Groups',
                    'Learn from fellow farmers and share experiences',
                    () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String title, String description, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Text(
          title.split(' ')[0], // Get emoji
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(
          title.substring(title.indexOf(' ') + 1), // Get title without emoji
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildActivityCard(String title, String description, IconData icon, Color color, String time) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: const Text('No new notifications'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Language',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Text('🇬🇧'),
              title: const Text('English'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Text('🇰🇪'),
              title: const Text('Kiswahili'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Text('🇰🇪'),
              title: const Text('Kikuyu'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Text('🇰🇪'),
              title: const Text('Luo'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showUSSDInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('USSD Access'),
        content: const Text(
          'Dial *123# from any phone to access KaziApp services even without internet connection.\n\nAvailable services:\n• Find nearby vets\n• Check weather\n• Market prices\n• Community messages',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showMPesaInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('M-Pesa Integration'),
        content: const Text(
          'Pay securely using M-Pesa for:\n\n• Veterinary consultations\n• Marketplace purchases\n• Premium features\n• Community group fees\n\nAll transactions are secure and instant.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Understood'),
          ),
        ],
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text(
                      _currentProfile!.name.split(' ')
                          .map((n) => n[0])
                          .take(2)
                          .join()
                          .toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentProfile!.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _currentProfile!.farmName,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _currentProfile!.farmingType,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Menu Options
            _buildMenuOption(
              icon: Icons.person,
              title: 'View Profile',
              subtitle: 'See your complete farmer profile',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FarmerProfileScreen(),
                  ),
                );
              },
            ),

            _buildMenuOption(
              icon: Icons.settings,
              title: 'Settings',
              subtitle: 'App preferences and account settings',
              onTap: () {
                Navigator.pop(context);
                _showSettingsScreen(context);
              },
            ),

            _buildMenuOption(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help and contact support',
              onTap: () {
                Navigator.pop(context);
                _showHelpAndSupport(context);
              },
            ),

            _buildMenuOption(
              icon: Icons.logout,
              title: 'Sign Out',
              subtitle: 'Sign out of your account',
              onTap: () {
                Navigator.pop(context);
                _showSignOutConfirmation(context);
              },
              isDestructive: true,
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive
              ? Colors.red.withOpacity(0.1)
              : const Color(0xFF2E7D32).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : const Color(0xFF2E7D32),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDestructive ? Colors.red : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showSettingsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  void _showHelpAndSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Need help? Contact us:'),
            SizedBox(height: 12),
            Text('📞 Phone: +254 700 123 456'),
            Text('📧 Email: support@kaziapp.com'),
            Text('💬 WhatsApp: +254 700 123 456'),
            SizedBox(height: 12),
            Text('🕒 Support Hours: 8AM - 6PM (Mon-Fri)'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSignOutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement sign out logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out successfully')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  /// Get personalized welcome message based on user profile
  String _getWelcomeMessage() {
    // Try to get first name from UserProfile first (from enhanced registration)
    if (_currentUser != null && _currentUser!.fullName.isNotEmpty) {
      final firstName = _currentUser!.fullName.split(' ').first;
      return 'Karibu, $firstName!';
    }

    // Fallback to FarmerProfile (from basic registration)
    if (_currentProfile != null && _currentProfile!.name.isNotEmpty) {
      final firstName = _currentProfile!.name.split(' ').first;
      return 'Karibu, $firstName!';
    }

    // Default fallback
    return 'Karibu, Farmer!';
  }
}
