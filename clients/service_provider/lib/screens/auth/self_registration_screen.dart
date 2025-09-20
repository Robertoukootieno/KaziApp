import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../services/user_profile_service.dart';

class SelfRegistrationScreen extends StatefulWidget {
  const SelfRegistrationScreen({super.key});

  @override
  State<SelfRegistrationScreen> createState() => _SelfRegistrationScreenState();
}

class _SelfRegistrationScreenState extends State<SelfRegistrationScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  
  // Form controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _locationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _servicesController = TextEditingController();
  
  // Form keys
  final _personalInfoFormKey = GlobalKey<FormState>();
  final _serviceInfoFormKey = GlobalKey<FormState>();
  final _accountSetupFormKey = GlobalKey<FormState>();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  
  String _selectedServiceCategory = '';
  
  final List<Map<String, dynamic>> _serviceCategories = [
    {'id': 'farming', 'name': 'Farming Services', 'icon': '🌾', 'description': 'Crop farming, land preparation'},
    {'id': 'livestock', 'name': 'Livestock Services', 'icon': '🐄', 'description': 'Animal care, breeding assistance'},
    {'id': 'veterinary', 'name': 'Veterinary Services', 'icon': '🏥', 'description': 'Animal health, medical treatments'},
    {'id': 'machinery', 'name': 'Machinery Services', 'icon': '🚜', 'description': 'Equipment rental, machinery services'},
    {'id': 'agrovet', 'name': 'Agrovet Services', 'icon': '🏪', 'description': 'Agricultural supplies, medicines'},
    {'id': 'feed_supplier', 'name': 'Feed Supply', 'icon': '🌾', 'description': 'Animal feed, nutrition supplies'},
    {'id': 'seeds_supplier', 'name': 'Seeds Supply', 'icon': '🌱', 'description': 'Quality seeds, planting materials'},
    {'id': 'fertilizer_supplier', 'name': 'Fertilizer Supply', 'icon': '🧪', 'description': 'Fertilizers, soil amendments'},
    {'id': 'retailer', 'name': 'General Retail', 'icon': '🛒', 'description': 'General farm products, supplies'},
    {'id': 'consultation', 'name': 'Agricultural Consultation', 'icon': '👨‍🌾', 'description': 'Expert advice and guidance'},
    {'id': 'transport', 'name': 'Transportation', 'icon': '🚚', 'description': 'Produce transport, logistics'},
    {'id': 'equipment', 'name': 'Equipment Services', 'icon': '⚙️', 'description': 'Equipment maintenance, repair'},
    {'id': 'other', 'name': 'Other Services', 'icon': '⚡', 'description': 'Other agricultural services'},
  ];

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Personal Info',
      'subtitle': 'Tell us about yourself',
      'icon': Icons.person,
    },
    {
      'title': 'Service Info',
      'subtitle': 'What services do you offer?',
      'icon': Icons.work,
    },
    {
      'title': 'Account Setup',
      'subtitle': 'Create your account',
      'icon': Icons.account_circle,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _locationController.dispose();
    _experienceController.dispose();
    _servicesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Self Registration'),
        backgroundColor: const Color(0xFF388E3C),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousStep,
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            color: const Color(0xFF388E3C),
            child: Column(
              children: [
                // Step indicator
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: List.generate(_steps.length, (index) {
                      final isActive = index == _currentStep;
                      final isCompleted = index < _currentStep;
                      
                      return Expanded(
                        child: Row(
                          children: [
                            // Step circle
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? Colors.white
                                    : isActive
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: isCompleted
                                    ? const Icon(
                                        Icons.check,
                                        color: Color(0xFF388E3C),
                                        size: 18,
                                      )
                                    : Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          color: isActive
                                              ? const Color(0xFF388E3C)
                                              : Colors.white.withValues(alpha: 0.7),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                              ),
                            ),
                            
                            // Connector line
                            if (index < _steps.length - 1)
                              Expanded(
                                child: Container(
                                  height: 2,
                                  margin: const EdgeInsets.symmetric(horizontal: 8),
                                  color: isCompleted
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.3),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                
                // Step title
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      Text(
                        _steps[_currentStep]['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _steps[_currentStep]['subtitle'],
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Step content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildPersonalInfoStep(),
                _buildServiceInfoStep(),
                _buildAccountSetupStep(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _personalInfoFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF388E3C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please provide your personal details to create your profile.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            
            const SizedBox(height: 24),
            
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
                prefixText: '+254 ',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location/County',
                prefixIcon: Icon(Icons.location_on),
                hintText: 'e.g., Nakuru, Kiambu, Meru',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your location';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_personalInfoFormKey.currentState!.validate()) {
                    _nextStep();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF388E3C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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

  Widget _buildServiceInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _serviceInfoFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Service Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF388E3C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tell us about the services you provide to help farmers find you.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Service Category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemCount: _serviceCategories.length,
              itemBuilder: (context, index) {
                final service = _serviceCategories[index];
                final isSelected = _selectedServiceCategory == service['id'];

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedServiceCategory = service['id'];
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF388E3C).withValues(alpha: 0.1) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF388E3C) : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          service['icon'],
                          style: const TextStyle(fontSize: 28),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          service['name'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? const Color(0xFF388E3C) : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          service['description'],
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            TextFormField(
              controller: _experienceController,
              decoration: const InputDecoration(
                labelText: 'Years of Experience',
                prefixIcon: Icon(Icons.timeline),
                hintText: 'e.g., 5 years',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your experience';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _servicesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Describe Your Services',
                prefixIcon: Icon(Icons.description),
                hintText: 'Briefly describe the services you offer to farmers...',
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please describe your services';
                }
                return null;
              },
            ),

            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousStep,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF388E3C),
                      side: const BorderSide(color: Color(0xFF388E3C)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Previous',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_serviceInfoFormKey.currentState!.validate() && _selectedServiceCategory.isNotEmpty) {
                        _nextStep();
                      } else if (_selectedServiceCategory.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a service category'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF388E3C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSetupStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _accountSetupFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Account Setup',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF388E3C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create a secure password to protect your account.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 24),

            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outlined),
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
                hintText: 'Create a strong password',
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
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: const Icon(Icons.lock_outlined),
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
                hintText: 'Confirm your password',
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
            ),

            const SizedBox(height: 24),

            // Terms and Conditions
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _acceptTerms,
                  onChanged: (value) {
                    setState(() {
                      _acceptTerms = value!;
                    });
                  },
                  activeColor: const Color(0xFF388E3C),
                ),
                const Expanded(
                  child: Text(
                    'I agree to the Terms of Service and Privacy Policy. I understand that KaziApp will connect me with farmers seeking agricultural services.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousStep,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF388E3C),
                      side: const BorderSide(color: Color(0xFF388E3C)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Previous',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _acceptTerms ? _completeRegistration : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF388E3C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _isMarketplaceServiceCategory(String serviceCategory) {
    const marketplaceServiceCategories = [
      'agrovet',
      'feed_supplier',
      'seeds_supplier',
      'fertilizer_supplier',
      'retailer',
    ];
    return marketplaceServiceCategories.contains(serviceCategory);
  }

  Future<void> _completeRegistration() async {
    if (!_accountSetupFormKey.currentState!.validate()) {
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Create user profile from registration data
      final profileService = UserProfileService.instance;

      // Get the selected service category details
      final selectedService = _serviceCategories.firstWhere(
        (service) => service['id'] == _selectedServiceCategory,
        orElse: () => {'name': _selectedServiceCategory},
      );

      // Create user profile
      await profileService.createProfile(
        email: _emailController.text.trim(),
        profileType: UserProfileType.selfRegistered,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        location: _locationController.text.trim(),
        serviceType: _selectedServiceCategory,
        serviceTypeName: selectedService['name'],
        serviceCategories: [_selectedServiceCategory],
        experience: _experienceController.text.trim(),
        servicesOffered: _servicesController.text.trim(),
      );

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.of(context).pop(); // Remove loading dialog

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: Color(0xFF388E3C),
          ),
        );

        // Check service category and redirect to appropriate portal
        if (_selectedServiceCategory == 'veterinary') {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/veterinary-dashboard',
            (route) => false,
          );
        } else if (_selectedServiceCategory == 'machinery') {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/machinery-dashboard',
            (route) => false,
          );
        } else if (_isMarketplaceServiceCategory(_selectedServiceCategory)) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/marketplace-dashboard',
            (route) => false,
          );
        } else {
          // Navigate to profile management for other service types
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/profile-management',
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Remove loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
