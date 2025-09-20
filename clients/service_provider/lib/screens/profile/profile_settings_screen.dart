import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../services/user_profile_service.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final UserProfile profile;

  const ProfileSettingsScreen({super.key, required this.profile});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final UserProfileService _profileService = UserProfileService.instance;

  late NotificationPreferences _notificationPreferences;
  late PrivacySettings _privacySettings;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _notificationPreferences = widget.profile.notificationPreferences;
    _privacySettings = widget.profile.privacySettings;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _saveNotificationPreferences() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _profileService.updateNotificationPreferences(_notificationPreferences);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification preferences updated!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating preferences: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _savePrivacySettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _profileService.updatePrivacySettings(_privacySettings);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Privacy settings updated!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating settings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Notifications'),
            Tab(text: 'Privacy'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : () async {
              if (_tabController.index == 0) {
                await _saveNotificationPreferences();
              } else {
                await _savePrivacySettings();
              }
              Navigator.pop(context, true);
            },
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationSettings(),
          _buildPrivacySettings(),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notification Preferences',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose how you want to be notified about important updates',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),

          _buildSettingsCard([
            _buildSwitchTile(
              title: 'Email Notifications',
              subtitle: 'Receive notifications via email',
              value: _notificationPreferences.emailNotifications,
              onChanged: (value) {
                setState(() {
                  _notificationPreferences = _notificationPreferences.copyWith(
                    emailNotifications: value,
                  );
                });
              },
            ),
            _buildSwitchTile(
              title: 'Push Notifications',
              subtitle: 'Receive push notifications on your device',
              value: _notificationPreferences.pushNotifications,
              onChanged: (value) {
                setState(() {
                  _notificationPreferences = _notificationPreferences.copyWith(
                    pushNotifications: value,
                  );
                });
              },
            ),
            _buildSwitchTile(
              title: 'SMS Notifications',
              subtitle: 'Receive notifications via SMS',
              value: _notificationPreferences.smsNotifications,
              onChanged: (value) {
                setState(() {
                  _notificationPreferences = _notificationPreferences.copyWith(
                    smsNotifications: value,
                  );
                });
              },
            ),
          ]),

          const SizedBox(height: 24),

          const Text(
            'Content Preferences',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          _buildSettingsCard([
            _buildSwitchTile(
              title: 'Order Updates',
              subtitle: 'Notifications about your orders and bookings',
              value: _notificationPreferences.orderUpdates,
              onChanged: (value) {
                setState(() {
                  _notificationPreferences = _notificationPreferences.copyWith(
                    orderUpdates: value,
                  );
                });
              },
            ),
            _buildSwitchTile(
              title: 'Appointment Reminders',
              subtitle: 'Reminders for upcoming appointments',
              value: _notificationPreferences.appointmentReminders,
              onChanged: (value) {
                setState(() {
                  _notificationPreferences = _notificationPreferences.copyWith(
                    appointmentReminders: value,
                  );
                });
              },
            ),
            _buildSwitchTile(
              title: 'System Alerts',
              subtitle: 'Important system updates and alerts',
              value: _notificationPreferences.systemAlerts,
              onChanged: (value) {
                setState(() {
                  _notificationPreferences = _notificationPreferences.copyWith(
                    systemAlerts: value,
                  );
                });
              },
            ),
            _buildSwitchTile(
              title: 'Marketing Emails',
              subtitle: 'Promotional offers and marketing content',
              value: _notificationPreferences.marketingEmails,
              onChanged: (value) {
                setState(() {
                  _notificationPreferences = _notificationPreferences.copyWith(
                    marketingEmails: value,
                  );
                });
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildPrivacySettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Privacy Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Control your privacy and data sharing preferences',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),

          _buildSettingsCard([
            _buildSwitchTile(
              title: 'Profile Visibility',
              subtitle: 'Make your profile visible to other users',
              value: _privacySettings.profileVisibility,
              onChanged: (value) {
                setState(() {
                  _privacySettings = _privacySettings.copyWith(
                    profileVisibility: value,
                  );
                });
              },
            ),
            _buildSwitchTile(
              title: 'Contact Info Visibility',
              subtitle: 'Show your contact information to other users',
              value: _privacySettings.contactInfoVisibility,
              onChanged: (value) {
                setState(() {
                  _privacySettings = _privacySettings.copyWith(
                    contactInfoVisibility: value,
                  );
                });
              },
            ),
            _buildSwitchTile(
              title: 'Service History Visibility',
              subtitle: 'Show your service history and reviews',
              value: _privacySettings.serviceHistoryVisibility,
              onChanged: (value) {
                setState(() {
                  _privacySettings = _privacySettings.copyWith(
                    serviceHistoryVisibility: value,
                  );
                });
              },
            ),
          ]),

          const SizedBox(height: 24),

          const Text(
            'Data & Analytics',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          _buildSettingsCard([
            _buildSwitchTile(
              title: 'Allow Data Collection',
              subtitle: 'Help us improve our services with usage analytics',
              value: _privacySettings.allowDataCollection,
              onChanged: (value) {
                setState(() {
                  _privacySettings = _privacySettings.copyWith(
                    allowDataCollection: value,
                  );
                });
              },
            ),
            _buildSwitchTile(
              title: 'Location Tracking',
              subtitle: 'Allow location tracking for better service matching',
              value: _privacySettings.allowLocationTracking,
              onChanged: (value) {
                setState(() {
                  _privacySettings = _privacySettings.copyWith(
                    allowLocationTracking: value,
                  );
                });
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeThumbColor: const Color(0xFF1976D2),
    );
  }
}
