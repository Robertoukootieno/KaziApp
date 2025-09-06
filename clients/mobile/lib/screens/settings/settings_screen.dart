import 'package:flutter/material.dart';
import '../../services/farmer_profile_service.dart';
import '../../models/farmer_profile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FarmerProfileService _profileService = FarmerProfileService();
  FarmerProfile? _currentProfile;
  FarmerPreferences? _currentPreferences;
  bool _isLoading = true;

  // Settings state
  bool _weatherAlerts = true;
  bool _marketPrices = true;
  bool _vetReminders = true;
  bool _communityUpdates = true;
  bool _pushNotifications = true;
  bool _smsNotifications = true;
  String _selectedLanguage = 'English';
  String _selectedTheme = 'light';

  final List<String> _languages = [
    'English', 'Kiswahili', 'Kikuyu', 'Luo', 'Kalenjin', 'Kamba',
  ];

  final List<String> _themes = ['light', 'dark', 'system'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      await _profileService.initialize();
      setState(() {
        _currentProfile = _profileService.currentProfile;
        _currentPreferences = _profileService.currentPreferences;
        
        if (_currentPreferences != null) {
          _weatherAlerts = _currentPreferences!.notificationSettings['weatherAlerts'] ?? true;
          _marketPrices = _currentPreferences!.notificationSettings['marketPrices'] ?? true;
          _vetReminders = _currentPreferences!.notificationSettings['vetReminders'] ?? true;
          _communityUpdates = _currentPreferences!.notificationSettings['communityUpdates'] ?? true;
          _pushNotifications = _currentPreferences!.notificationSettings['pushNotifications'] ?? true;
          _smsNotifications = _currentPreferences!.notificationSettings['smsNotifications'] ?? true;
          _selectedLanguage = _currentPreferences!.preferredLanguage;
          _selectedTheme = _currentPreferences!.theme;
        }
        
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    try {
      await _profileService.savePreferences(
        selectedServices: _currentPreferences?.selectedServices ?? [],
        notificationSettings: {
          'weatherAlerts': _weatherAlerts,
          'marketPrices': _marketPrices,
          'vetReminders': _vetReminders,
          'communityUpdates': _communityUpdates,
          'pushNotifications': _pushNotifications,
          'smsNotifications': _smsNotifications,
        },
        preferredLanguage: _selectedLanguage,
        theme: _selectedTheme,
        customSettings: _currentPreferences?.customSettings ?? {},
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved successfully!'),
          backgroundColor: Color(0xFF2E7D32),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save settings: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile Section
                  if (_currentProfile != null) _buildProfileSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Notifications Section
                  _buildNotificationsSection(),
                  
                  const SizedBox(height: 24),
                  
                  // App Preferences Section
                  _buildAppPreferencesSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Account Section
                  _buildAccountSection(),
                  
                  const SizedBox(height: 24),
                  
                  // About Section
                  _buildAboutSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profile Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFF2E7D32),
                child: Text(
                  _currentProfile!.name.split(' ')
                      .map((n) => n[0])
                      .take(2)
                      .join()
                      .toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
                      ),
                    ),
                    Text(
                      _currentProfile!.farmName,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _currentProfile!.farmingType,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  // Navigate to profile edit
                },
                icon: const Icon(Icons.edit),
                color: const Color(0xFF2E7D32),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.notifications, color: Color(0xFF2E7D32)),
              SizedBox(width: 8),
              Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          _buildSwitchTile(
            'Push Notifications',
            'Receive notifications on your device',
            _pushNotifications,
            (value) => setState(() => _pushNotifications = value),
          ),
          
          _buildSwitchTile(
            'SMS Notifications',
            'Receive important updates via SMS',
            _smsNotifications,
            (value) => setState(() => _smsNotifications = value),
          ),
          
          const Divider(),
          
          const Text(
            'Notification Types',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          
          _buildSwitchTile(
            'Weather Alerts',
            'Get weather updates and warnings',
            _weatherAlerts,
            (value) => setState(() => _weatherAlerts = value),
          ),
          
          _buildSwitchTile(
            'Market Prices',
            'Receive commodity price updates',
            _marketPrices,
            (value) => setState(() => _marketPrices = value),
          ),
          
          _buildSwitchTile(
            'Vet Reminders',
            'Animal health and vaccination reminders',
            _vetReminders,
            (value) => setState(() => _vetReminders = value),
          ),
          
          _buildSwitchTile(
            'Community Updates',
            'News from your farming community',
            _communityUpdates,
            (value) => setState(() => _communityUpdates = value),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeThumbColor: const Color(0xFF2E7D32),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildAppPreferencesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.settings, color: Color(0xFF2E7D32)),
              SizedBox(width: 8),
              Text(
                'App Preferences',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Language Selection
          ListTile(
            title: const Text('Language'),
            subtitle: Text(_selectedLanguage),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            contentPadding: EdgeInsets.zero,
            onTap: () => _showLanguageSelector(),
          ),
          
          const Divider(),
          
          // Theme Selection
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(_selectedTheme.toUpperCase()),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            contentPadding: EdgeInsets.zero,
            onTap: () => _showThemeSelector(),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.account_circle, color: Color(0xFF2E7D32)),
              SizedBox(width: 8),
              Text(
                'Account',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          ListTile(
            title: const Text('Change Password'),
            subtitle: const Text('Update your account password'),
            leading: const Icon(Icons.lock, color: Color(0xFF2E7D32)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            contentPadding: EdgeInsets.zero,
            onTap: () => _showChangePassword(),
          ),
          
          ListTile(
            title: const Text('Privacy Settings'),
            subtitle: const Text('Manage your data and privacy'),
            leading: const Icon(Icons.privacy_tip, color: Color(0xFF2E7D32)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            contentPadding: EdgeInsets.zero,
            onTap: () => _showPrivacySettings(),
          ),
          
          ListTile(
            title: const Text('Delete Account'),
            subtitle: const Text('Permanently delete your account'),
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            contentPadding: EdgeInsets.zero,
            onTap: () => _showDeleteAccountConfirmation(),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info, color: Color(0xFF2E7D32)),
              SizedBox(width: 8),
              Text(
                'About',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          const ListTile(
            title: Text('App Version'),
            subtitle: Text('1.0.0'),
            leading: Icon(Icons.info_outline, color: Color(0xFF2E7D32)),
            contentPadding: EdgeInsets.zero,
          ),
          
          ListTile(
            title: const Text('Terms of Service'),
            leading: const Icon(Icons.description, color: Color(0xFF2E7D32)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            contentPadding: EdgeInsets.zero,
            onTap: () => _showTermsOfService(),
          ),
          
          ListTile(
            title: const Text('Privacy Policy'),
            leading: const Icon(Icons.policy, color: Color(0xFF2E7D32)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            contentPadding: EdgeInsets.zero,
            onTap: () => _showPrivacyPolicy(),
          ),
          
          ListTile(
            title: const Text('Contact Support'),
            leading: const Icon(Icons.support_agent, color: Color(0xFF2E7D32)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            contentPadding: EdgeInsets.zero,
            onTap: () => _showContactSupport(),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _languages.map((language) {
            return RadioListTile<String>(
              title: Text(language),
              value: language,
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.pop(context);
              },
              activeColor: const Color(0xFF2E7D32),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showThemeSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _themes.map((theme) {
            return RadioListTile<String>(
              title: Text(theme.toUpperCase()),
              value: theme,
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value!;
                });
                Navigator.pop(context);
              },
              activeColor: const Color(0xFF2E7D32),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showChangePassword() {
    // TODO: Implement change password
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Change password feature coming soon!')),
    );
  }

  void _showPrivacySettings() {
    // TODO: Implement privacy settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy settings coming soon!')),
    );
  }

  void _showDeleteAccountConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement account deletion
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion feature coming soon!')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    // TODO: Show terms of service
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Terms of service coming soon!')),
    );
  }

  void _showPrivacyPolicy() {
    // TODO: Show privacy policy
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy policy coming soon!')),
    );
  }

  void _showContactSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Get help from our support team:'),
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
}
