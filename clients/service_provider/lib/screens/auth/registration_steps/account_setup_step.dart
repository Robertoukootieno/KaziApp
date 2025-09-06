import 'package:flutter/material.dart';

class AccountSetupStep extends StatefulWidget {
  final VoidCallback onNext;
  final Function(Map<String, dynamic>) onDataChanged;
  final Map<String, dynamic> initialData;

  const AccountSetupStep({
    super.key,
    required this.onNext,
    required this.onDataChanged,
    required this.initialData,
  });

  @override
  State<AccountSetupStep> createState() => _AccountSetupStepState();
}

class _AccountSetupStepState extends State<AccountSetupStep> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _enableNotifications = true;
  bool _enableSmsAlerts = true;
  bool _enableEmailUpdates = true;

  // Password strength indicators
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    _firstNameController.text = widget.initialData['firstName'] ?? '';
    _lastNameController.text = widget.initialData['lastName'] ?? '';
    _passwordController.text = widget.initialData['password'] ?? '';
    _confirmPasswordController.text = widget.initialData['confirmPassword'] ?? '';
    _enableNotifications = widget.initialData['enableNotifications'] ?? true;
    _enableSmsAlerts = widget.initialData['enableSmsAlerts'] ?? true;
    _enableEmailUpdates = widget.initialData['enableEmailUpdates'] ?? true;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Create your account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Set up your personal account details and security preferences.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 32),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Personal Information
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // First Name
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        labelText: 'First Name *',
                        hintText: 'Enter your first name',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                      onChanged: (value) => _updateData(),
                    ),

                    const SizedBox(height: 16),

                    // Last Name
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        labelText: 'Last Name *',
                        hintText: 'Enter your last name',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                      onChanged: (value) => _updateData(),
                    ),

                    const SizedBox(height: 32),

                    // Account Security
                    const Text(
                      'Account Security',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password *',
                        hintText: 'Create a strong password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                      onChanged: _checkPasswordStrength,
                    ),

                    const SizedBox(height: 12),

                    // Password strength indicators
                    if (_passwordController.text.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Password Requirements:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildPasswordRequirement('At least 8 characters', _hasMinLength),
                            _buildPasswordRequirement('One uppercase letter', _hasUppercase),
                            _buildPasswordRequirement('One lowercase letter', _hasLowercase),
                            _buildPasswordRequirement('One number', _hasNumber),
                            _buildPasswordRequirement('One special character', _hasSpecialChar),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Confirm Password
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password *',
                        hintText: 'Re-enter your password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
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
                      onChanged: (value) => _updateData(),
                    ),

                    const SizedBox(height: 32),

                    // Notification Preferences
                    const Text(
                      'Notification Preferences',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          SwitchListTile(
                            title: const Text('Push Notifications'),
                            subtitle: const Text('Get notified about new bookings and messages'),
                            value: _enableNotifications,
                            onChanged: (value) {
                              setState(() {
                                _enableNotifications = value;
                              });
                              _updateData();
                            },
                            activeThumbColor: const Color(0xFF2E7D32),
                            contentPadding: EdgeInsets.zero,
                          ),
                          SwitchListTile(
                            title: const Text('SMS Alerts'),
                            subtitle: const Text('Receive important updates via SMS'),
                            value: _enableSmsAlerts,
                            onChanged: (value) {
                              setState(() {
                                _enableSmsAlerts = value;
                              });
                              _updateData();
                            },
                            activeThumbColor: const Color(0xFF2E7D32),
                            contentPadding: EdgeInsets.zero,
                          ),
                          SwitchListTile(
                            title: const Text('Email Updates'),
                            subtitle: const Text('Get weekly reports and updates'),
                            value: _enableEmailUpdates,
                            onChanged: (value) {
                              setState(() {
                                _enableEmailUpdates = value;
                              });
                              _updateData();
                            },
                            activeThumbColor: const Color(0xFF2E7D32),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Continue button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordRequirement(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isMet ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isMet ? Colors.green : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  void _checkPasswordStrength(String password) {
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
    _updateData();
  }

  void _updateData() {
    widget.onDataChanged({
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'password': _passwordController.text,
      'confirmPassword': _confirmPasswordController.text,
      'enableNotifications': _enableNotifications,
      'enableSmsAlerts': _enableSmsAlerts,
      'enableEmailUpdates': _enableEmailUpdates,
    });
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      _updateData();
      widget.onNext();
    }
  }
}
