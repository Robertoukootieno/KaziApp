import 'package:flutter/material.dart';
import '../../../services/behavioral_biometrics_service.dart';

class AccountSecurityStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Function(Map<String, dynamic>) onDataChanged;
  final Map<String, dynamic> initialData;
  final BehavioralBiometricsService behavioralService;

  const AccountSecurityStep({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.onDataChanged,
    required this.initialData,
    required this.behavioralService,
  });

  @override
  State<AccountSecurityStep> createState() => _AccountSecurityStepState();
}

class _AccountSecurityStepState extends State<AccountSecurityStep> 
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  bool _acceptPrivacy = false;
  
  // Password strength indicators (hidden from user but used for security)
  double _passwordStrength = 0.0;
  List<String> _passwordRequirements = [];

  late AnimationController _slideController;
  late AnimationController _securityController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _securityAnimation;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeAnimations();
  }

  void _initializeControllers() {
    _passwordController.text = widget.initialData['password'] ?? '';
    _confirmPasswordController.text = widget.initialData['confirmPassword'] ?? '';
    _acceptTerms = widget.initialData['acceptTerms'] ?? false;
    _acceptPrivacy = widget.initialData['acceptPrivacy'] ?? false;
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _securityController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    
    _securityAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _securityController, curve: Curves.easeInOut),
    );

    _slideController.forward();
    _securityController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _slideController.dispose();
    _securityController.dispose();
    super.dispose();
  }

  void _analyzePasswordStrength(String password) {
    // Background password analysis (hidden from user)
    setState(() {
      _passwordStrength = 0.0;
      _passwordRequirements.clear();
      
      if (password.length >= 8) _passwordStrength += 0.2;
      if (password.contains(RegExp(r'[A-Z]'))) _passwordStrength += 0.2;
      if (password.contains(RegExp(r'[a-z]'))) _passwordStrength += 0.2;
      if (password.contains(RegExp(r'[0-9]'))) _passwordStrength += 0.2;
      if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) _passwordStrength += 0.2;
      
      // Store requirements for background security analysis
      if (password.length < 8) _passwordRequirements.add('At least 8 characters');
      if (!password.contains(RegExp(r'[A-Z]'))) _passwordRequirements.add('Uppercase letter');
      if (!password.contains(RegExp(r'[a-z]'))) _passwordRequirements.add('Lowercase letter');
      if (!password.contains(RegExp(r'[0-9]'))) _passwordRequirements.add('Number');
      if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) _passwordRequirements.add('Special character');
    });
  }

  void _continue() {
    if (_formKey.currentState!.validate() && _acceptTerms && _acceptPrivacy) {
      // Update registration data
      widget.onDataChanged({
        'password': _passwordController.text,
        'confirmPassword': _confirmPasswordController.text,
        'acceptTerms': _acceptTerms,
        'acceptPrivacy': _acceptPrivacy,
        'passwordStrength': _passwordStrength, // Hidden security metric
      });
      
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Security shield illustration
            Container(
              width: 120,
              height: 120,
              margin: const EdgeInsets.only(bottom: 32),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circle with pulse animation
                  AnimatedBuilder(
                    animation: _securityAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _securityAnimation.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.blue[400]!.withValues(alpha: 0.2),
                                Colors.blue[400]!.withValues(alpha: 0.05),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  // Security shield icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.blue[400],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue[400]!.withValues(alpha: 0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.security,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
            
            // Form card
            _buildFormCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Card(
      elevation: 20,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey[50]!,
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              const Text(
                'Secure your account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E7D32),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Create a strong password to protect your account',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              // Password field
              _buildPasswordField(),
              
              const SizedBox(height: 20),
              
              // Confirm Password field
              _buildConfirmPasswordField(),
              
              const SizedBox(height: 24),
              
              // Terms and Privacy checkboxes
              _buildTermsCheckboxes(),
              
              const SizedBox(height: 32),
              
              // Navigation buttons
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Create a strong password',
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF2E7D32)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters long';
        }
        return null;
      },
      onChanged: (value) {
        _analyzePasswordStrength(value);
        // Background behavioral analysis (hidden from user)
        try {
          widget.behavioralService.recordKeystroke(
            key: value.isNotEmpty ? value[value.length - 1] : '',
            timestamp: DateTime.now(),
            duration: 100.0,
          );
        } catch (e) {
          debugPrint('Behavioral analysis: $e');
        }
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        hintText: 'Re-enter your password',
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF2E7D32)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _buildTermsCheckboxes() {
    return Column(
      children: [
        CheckboxListTile(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() {
              _acceptTerms = value ?? false;
            });
          },
          title: const Text(
            'I accept the Terms and Conditions',
            style: TextStyle(fontSize: 14),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: const Color(0xFF2E7D32),
          contentPadding: EdgeInsets.zero,
        ),

        CheckboxListTile(
          value: _acceptPrivacy,
          onChanged: (value) {
            setState(() {
              _acceptPrivacy = value ?? false;
            });
          },
          title: const Text(
            'I accept the Privacy Policy',
            style: TextStyle(fontSize: 14),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: const Color(0xFF2E7D32),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: OutlinedButton(
              onPressed: widget.onPrevious,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF2E7D32)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Back',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          flex: 2,
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: (_acceptTerms && _acceptPrivacy) ? _continue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                shadowColor: const Color(0xFF2E7D32).withValues(alpha: 0.3),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
