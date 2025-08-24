import 'package:flutter/material.dart';
import 'ai_diagnosis/ai_diagnosis_screen.dart';
import 'weather/weather_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.agriculture, color: Colors.white),
            const SizedBox(width: 8),
            const Text('KaziApp'),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              _showNotifications(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              _showLanguageSelector(context);
            },
          ),
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
                    const Text(
                      'Karibu, Farmer!',
                      style: TextStyle(
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
                        color: Colors.white.withOpacity(0.9),
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
}
