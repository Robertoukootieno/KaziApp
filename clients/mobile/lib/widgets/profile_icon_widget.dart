import 'package:flutter/material.dart';
import '../services/user_profile_service.dart';
import '../screens/profile/user_profile_screen.dart';

/// Profile Icon Widget for displaying user profile icon in navigation
class ProfileIconWidget extends StatefulWidget {
  final double size;
  final bool showNotificationBadge;
  final VoidCallback? onTap;

  const ProfileIconWidget({
    super.key,
    this.size = 40,
    this.showNotificationBadge = true,
    this.onTap,
  });

  @override
  State<ProfileIconWidget> createState() => _ProfileIconWidgetState();
}

class _ProfileIconWidgetState extends State<ProfileIconWidget> with TickerProviderStateMixin {
  final UserProfileService _profileService = UserProfileService();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _initializeProfile();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _initializeProfile() async {
    try {
      // Initialize profile service in background without blocking UI
      _profileService.initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });

          // Start pulse animation if profile is incomplete
          final completionPercentage = _profileService.getProfileCompletionPercentage();
          if (completionPercentage < 80) {
            _pulseController.repeat(reverse: true);
          }
        }
      }).catchError((e) {
        debugPrint('⚠️ Failed to initialize profile for icon: $e');
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      });

      // Set initialized immediately to show basic icon
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('⚠️ Failed to initialize profile for icon: $e');
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return _buildLoadingIcon();
    }

    final user = _profileService.currentUser;
    final completionPercentage = _profileService.getProfileCompletionPercentage();
    final showBadge = widget.showNotificationBadge && completionPercentage < 80;

    return GestureDetector(
      onTap: widget.onTap ?? () => _navigateToProfile(context),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: showBadge ? _pulseAnimation.value : 1.0,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Profile Avatar
                  Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: user != null ? const Color(0xFF2E7D32) : Colors.grey[400]!,
                        width: 2,
                      ),
                    ),
                    child: user != null
                        ? _buildUserAvatar(user)
                        : _buildGuestAvatar(),
                  ),
                  
                  // Notification Badge
                  if (showBadge)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.red[600],
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Center(
                          child: Text(
                            '!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  
                  // Security Level Indicator (small ring)
                  if (user != null && _profileService.securityData != null)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: _getSecurityColor(_profileService.getSecurityLevel()),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingIcon() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
      ),
      child: Center(
        child: SizedBox(
          width: widget.size * 0.5,
          height: widget.size * 0.5,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar(UserProfile user) {
    if (user.profileImageUrl != null) {
      return ClipOval(
        child: Image.network(
          user.profileImageUrl!,
          fit: BoxFit.cover,
          width: widget.size,
          height: widget.size,
          errorBuilder: (context, error, stackTrace) => _buildInitialsAvatar(user),
        ),
      );
    } else {
      return _buildInitialsAvatar(user);
    }
  }

  Widget _buildInitialsAvatar(UserProfile user) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
        ),
      ),
      child: Center(
        child: Text(
          _profileService.getUserInitials(),
          style: TextStyle(
            color: Colors.white,
            fontSize: widget.size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildGuestAvatar() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
      ),
      child: Icon(
        Icons.person,
        color: Colors.grey[600],
        size: widget.size * 0.6,
      ),
    );
  }

  Color _getSecurityColor(int securityLevel) {
    if (securityLevel >= 90) return Colors.green;
    if (securityLevel >= 75) return Colors.orange;
    if (securityLevel >= 50) return Colors.yellow[700]!;
    return Colors.red;
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UserProfileScreen(),
      ),
    );
  }
}

/// Profile Icon Button for use in app bars
class ProfileIconButton extends StatelessWidget {
  final double size;
  final bool showNotificationBadge;
  final VoidCallback? onPressed;

  const ProfileIconButton({
    super.key,
    this.size = 32,
    this.showNotificationBadge = true,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: ProfileIconWidget(
        size: size,
        showNotificationBadge: showNotificationBadge,
        onTap: onPressed,
      ),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
        minWidth: size + 8,
        minHeight: size + 8,
      ),
    );
  }
}
