import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/user_profile_service.dart';
import '../screens/profile/profile_management_screen.dart';

class ProfileAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final List<Widget>? actions;
  final bool showProfileIcon;

  const ProfileAppBar({
    super.key,
    required this.title,
    this.backgroundColor,
    this.foregroundColor,
    this.actions,
    this.showProfileIcon = true,
  });

  @override
  State<ProfileAppBar> createState() => _ProfileAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ProfileAppBarState extends State<ProfileAppBar> {
  final UserProfileService _profileService = UserProfileService.instance;
  UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    setState(() {
      _profile = _profileService.currentProfile;
    });
  }

  Future<void> _signOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _profileService.logout();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/welcome',
          (route) => false,
        );
      }
    }
  }

  void _showProfileMenu() {
    if (_profile == null) return;

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
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF1976D2).withValues(alpha: 0.1),
                  backgroundImage: _profile!.profileImageUrl != null
                      ? NetworkImage(_profile!.profileImageUrl!)
                      : null,
                  child: _profile!.profileImageUrl == null
                      ? Text(
                          _profile!.initials,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1976D2),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _profile!.displayName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _profile!.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _profile!.profileType == UserProfileType.businessRegistered
                              ? Colors.blue.withValues(alpha: 0.1)
                              : Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _profile!.profileType.displayName,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _profile!.profileType == UserProfileType.businessRegistered
                                ? Colors.blue
                                : Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            
            // Menu Items
            ListTile(
              leading: const Icon(Icons.person, color: Color(0xFF1976D2)),
              title: const Text('Manage Profile'),
              subtitle: const Text('Edit your profile and settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileManagementScreen(),
                  ),
                );
              },
            ),
            
            if (!_profileService.isProfileComplete()) ...[
              ListTile(
                leading: Icon(Icons.warning, color: Colors.orange.shade600),
                title: const Text('Complete Profile'),
                subtitle: Text(
                  '${_profile!.profileCompletionPercentage.toInt()}% complete',
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileManagementScreen(),
                    ),
                  );
                },
              ),
            ],
            
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sign Out'),
              subtitle: const Text('Sign out of your account'),
              onTap: () {
                Navigator.pop(context);
                _signOut();
              },
            ),
            
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final actions = <Widget>[];
    
    // Add custom actions if provided
    if (widget.actions != null) {
      actions.addAll(widget.actions!);
    }
    
    // Add profile icon if enabled and profile exists
    if (widget.showProfileIcon && _profile != null) {
      actions.add(
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: _showProfileMenu,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  backgroundImage: _profile!.profileImageUrl != null
                      ? NetworkImage(_profile!.profileImageUrl!)
                      : null,
                  child: _profile!.profileImageUrl == null
                      ? Text(
                          _profile!.initials,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                if (!_profileService.isProfileComplete())
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: const Icon(
                        Icons.warning,
                        size: 8,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return AppBar(
      title: Text(widget.title),
      backgroundColor: widget.backgroundColor ?? const Color(0xFF1976D2),
      foregroundColor: widget.foregroundColor ?? Colors.white,
      elevation: 0,
      actions: actions.isNotEmpty ? actions : null,
    );
  }
}
