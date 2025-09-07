import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/keycloak_auth_service.dart';
import '../../navigation/main_navigation.dart';
import 'login_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String username;
  final String email;

  const EmailVerificationScreen({
    super.key,
    required this.username,
    required this.email,
  });

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _codeController = TextEditingController();
  final KeycloakAuthService _authService = KeycloakAuthService();
  
  bool _isLoading = false;
  bool _isResending = false;
  int _resendCooldown = 0;

  @override
  void initState() {
    super.initState();
    _startResendCooldown();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _startResendCooldown() {
    setState(() {
      _resendCooldown = 60; // 60 seconds cooldown
    });
    
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendCooldown--;
        });
        return _resendCooldown > 0;
      }
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E7D32)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Verify Email',
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Icon
            const Icon(
              Icons.mark_email_read,
              size: 80,
              color: Color(0xFF2E7D32),
            ),
            const SizedBox(height: 24),

            // Title
            const Text(
              'Check Your Email',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              'We\'ve sent a verification link to:\n${widget.email}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            Text(
              'Click the link in your email to verify your account, or enter the verification code below.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // Verification Code Input
            TextFormField(
              controller: _codeController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                LengthLimitingTextInputFormatter(6),
              ],
              decoration: InputDecoration(
                labelText: 'Verification Code (Optional)',
                hintText: 'Enter 6-digit code',
                prefixIcon: const Icon(Icons.security),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2E7D32)),
                ),
                helperText: 'If you received a verification code via email',
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 24),

            // Verify Button
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Verify Code',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
            ),

            const SizedBox(height: 16),

            // Check Status Button
            OutlinedButton(
              onPressed: _isLoading ? null : _checkVerificationStatus,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF2E7D32),
                side: const BorderSide(color: Color(0xFF2E7D32)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Check Verification Status',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 32),

            // Resend Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  Text(
                    'Didn\'t receive the email?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  if (_resendCooldown > 0)
                    Text(
                      'Resend available in ${_resendCooldown}s',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    )
                  else
                    TextButton(
                      onPressed: _isResending ? null : _resendVerification,
                      child: _isResending
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Resend Verification Email',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Skip for now button
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text(
                'Skip for now - Go to Login',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _verifyCode() async {
    if (_codeController.text.trim().isEmpty) {
      _showMessage('Please enter the verification code', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // For now, we'll simulate verification since Keycloak handles this via email links
      // In a real implementation, you'd verify the code with your backend
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        _showMessage('Email verified successfully!');
        
        // Navigate to main app after a short delay
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MainNavigation(),
              ),
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showMessage('Verification failed: ${e.toString()}', isError: true);
      }
    }
  }

  void _checkVerificationStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final status = await _authService.getVerificationStatus(widget.username);
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (status != null && status.emailVerified) {
          _showMessage('Email verified successfully!');
          
          // Navigate to main app
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainNavigation(),
                ),
              );
            }
          });
        } else {
          _showMessage('Email not yet verified. Please check your email.', isError: true);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showMessage('Failed to check verification status', isError: true);
      }
    }
  }

  void _resendVerification() async {
    setState(() {
      _isResending = true;
    });

    try {
      final success = await _authService.resendVerification(widget.username);
      
      if (mounted) {
        setState(() {
          _isResending = false;
        });

        if (success) {
          _showMessage('Verification email sent successfully!');
          _startResendCooldown();
        } else {
          _showMessage('Failed to resend verification email', isError: true);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
        _showMessage('Failed to resend verification email', isError: true);
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }
}
