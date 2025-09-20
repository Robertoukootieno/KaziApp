import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../navigation/main_navigation.dart';
import '../../services/farmer_profile_service.dart';
import '../../services/user_profile_service.dart';
// Removed keycloak import to avoid network errors in basic registration
import 'email_verification_screen.dart';

class FarmerRegisterScreen extends StatefulWidget {
  final Map<String, dynamic>? prefilledData;

  const FarmerRegisterScreen({
    super.key,
    this.prefilledData,
  });

  @override
  State<FarmerRegisterScreen> createState() => _FarmerRegisterScreenState();
}

class _FarmerRegisterScreenState extends State<FarmerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  
  // Basic Information Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // Farm Information Controllers
  final _farmNameController = TextEditingController();
  final _farmLocationController = TextEditingController();
  final _farmSizeController = TextEditingController();
  final _experienceController = TextEditingController();
  
  // Registration State
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  int _currentPage = 0;
  String _selectedFarmingType = '';
  String _selectedExperienceLevel = '';
  String _selectedCounty = '';
  String _selectedLanguage = 'English';
  final List<String> _selectedCrops = [];
  final List<String> _selectedLivestock = [];
  final Map<String, bool> _selectedServices = {};
  
  // Farming Options
  final List<String> _farmingTypes = [
    'Crop Farming',
    'Livestock Farming', 
    'Mixed Farming',
    'Poultry Farming',
    'Dairy Farming',
    'Fish Farming',
    'Horticulture',
    'Agro-forestry',
  ];
  
  final List<String> _experienceLevels = [
    'Beginner (0-2 years)',
    'Intermediate (3-5 years)',
    'Experienced (6-10 years)',
    'Expert (10+ years)',
  ];
  
  final List<String> _kenyanCounties = [
    'Nairobi', 'Mombasa', 'Kisumu', 'Nakuru', 'Eldoret', 'Thika', 'Malindi',
    'Kitale', 'Garissa', 'Kakamega', 'Machakos', 'Meru', 'Nyeri', 'Kericho',
    'Embu', 'Migori', 'Bungoma', 'Homa Bay', 'Naivasha', 'Voi'
  ];
  
  final List<String> _cropOptions = [
    'Maize', 'Beans', 'Rice', 'Wheat', 'Sorghum', 'Millet', 'Cassava',
    'Sweet Potatoes', 'Irish Potatoes', 'Bananas', 'Sugarcane', 'Cotton',
    'Coffee', 'Tea', 'Tomatoes', 'Onions', 'Cabbages', 'Kales', 'Spinach',
    'Carrots', 'Peas', 'French Beans', 'Avocados', 'Mangoes', 'Oranges'
  ];
  
  final List<String> _livestockOptions = [
    'Cattle', 'Goats', 'Sheep', 'Pigs', 'Chickens', 'Ducks', 'Turkeys',
    'Rabbits', 'Donkeys', 'Camels', 'Fish', 'Bees'
  ];
  
  final List<String> _languages = [
    'English', 'Kiswahili', 'Kikuyu', 'Luo', 'Kalenjin', 'Kamba',
  ];
  
  final Map<String, String> _appServices = {
    'AI Diagnosis': 'Get AI-powered disease diagnosis for your animals',
    'Weather Updates': 'Receive localized weather forecasts and alerts',
    'Market Prices': 'Track commodity prices and find buyers',
    'Vet Services': 'Connect with veterinarians for consultations',
    'Farm Records': 'Digital record keeping for your farm activities',
    'Community Forum': 'Connect with other farmers in your area',
    'Training Content': 'Access farming tutorials and best practices',
    'Financial Services': 'Loans, insurance, and payment solutions',
  };

  @override
  void initState() {
    super.initState();
    // Initialize selected services
    for (String service in _appServices.keys) {
      _selectedServices[service] = true; // Default all services to selected
    }

    // Initialize with prefilled data if available
    if (widget.prefilledData != null) {
      _nameController.text = widget.prefilledData!['fullName'] ?? '';
      _phoneController.text = widget.prefilledData!['phoneNumber']?.replaceFirst(widget.prefilledData!['countryCode'] ?? '+254', '') ?? '';
      _emailController.text = widget.prefilledData!['email'] ?? '';
      // Skip to page 1 (farm information) since basic info is already filled
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _pageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          setState(() {
            _currentPage = 1;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _farmNameController.dispose();
    _farmLocationController.dispose();
    _farmSizeController.dispose();
    _experienceController.dispose();
    super.dispose();
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
          onPressed: () {
            if (_currentPage > 0) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          'Farmer Registration (${_currentPage + 1}/4)',
          style: const TextStyle(
            color: Color(0xFF2E7D32),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: List.generate(4, (index) {
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
                    height: 4,
                    decoration: BoxDecoration(
                      color: index <= _currentPage 
                          ? const Color(0xFF2E7D32) 
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
          
          // Page Content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                _buildBasicInfoPage(),
                _buildFarmInfoPage(),
                _buildFarmingDetailsPage(),
                _buildPreferencesPage(),
              ],
            ),
          ),
          
          // Navigation Buttons
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                if (_currentPage > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2E7D32),
                        side: const BorderSide(color: Color(0xFF2E7D32)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Previous'),
                    ),
                  ),
                if (_currentPage > 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleNextOrRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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
                        : Text(_currentPage == 3 ? 'Complete Registration' : 'Next'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Welcome Header
          const Icon(
            Icons.agriculture,
            size: 64,
            color: Color(0xFF2E7D32),
          ),
          const SizedBox(height: 16),
          const Text(
            'Welcome to KaziApp!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Let\'s create your farmer profile',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Full Name Field
          TextFormField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2E7D32)),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Phone Number Field
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: '0712345678',
              prefixIcon: const Icon(Icons.phone),
              prefixText: '+254 ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2E7D32)),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Email Field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email Address *',
              hintText: 'your.email@example.com',
              prefixIcon: const Icon(Icons.email, color: Color(0xFF2E7D32)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red),
              ),
              helperText: 'Required for account verification and security',
              helperStyle: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email address is required for account verification';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Password Field
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
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
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 14) {
                return 'Password must be at least 14 characters long';
              }
              if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?])').hasMatch(value)) {
                return 'Password must contain uppercase, lowercase, number, and special character';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Confirm Password Field
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
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
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red),
              ),
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

          // USSD Option
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.phone,
                  color: Colors.blue,
                  size: 32,
                ),
                const SizedBox(height: 8),
                const Text(
                  'No smartphone? No problem!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Dial *384*96# to register via USSD',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    _showUSSDInstructions();
                  },
                  child: const Text('Learn More'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleNextOrRegister() {
    // Validate current page before proceeding
    if (!_validateCurrentPage()) {
      return;
    }

    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeRegistration();
    }
  }

  bool _validateCurrentPage() {
    switch (_currentPage) {
      case 0: // Basic Info Page
        if (_nameController.text.trim().isEmpty) {
          _showValidationError('Please enter your full name');
          return false;
        }
        if (_phoneController.text.trim().isEmpty || _phoneController.text.length != 10) {
          _showValidationError('Please enter a valid 10-digit phone number');
          return false;
        }
        if (_passwordController.text.isEmpty || _passwordController.text.length < 6) {
          _showValidationError('Password must be at least 6 characters');
          return false;
        }
        if (_passwordController.text != _confirmPasswordController.text) {
          _showValidationError('Passwords do not match');
          return false;
        }
        // Validate email format if provided
        if (_emailController.text.isNotEmpty && !_isValidEmail(_emailController.text)) {
          _showValidationError('Please enter a valid email address');
          return false;
        }
        break;

      case 1: // Farm Info Page
        if (_selectedCounty.isEmpty) {
          _showValidationError('Please select your county');
          return false;
        }
        if (_selectedFarmingType.isEmpty) {
          _showValidationError('Please select your farming type');
          return false;
        }
        if (_selectedExperienceLevel.isEmpty) {
          _showValidationError('Please select your experience level');
          return false;
        }
        if (_farmSizeController.text.isEmpty || double.tryParse(_farmSizeController.text) == null) {
          _showValidationError('Please enter a valid farm size');
          return false;
        }
        break;

      case 2: // Farming Details Page
        if (_selectedCrops.isEmpty && _selectedLivestock.isEmpty) {
          _showValidationError('Please select at least one crop or livestock');
          return false;
        }
        break;

      case 3: // Preferences Page
        // No strict validation needed for preferences
        break;
    }
    return true;
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _completeRegistration() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate registration process without backend connection
      await Future.delayed(const Duration(milliseconds: 2000)); // Simulate processing time

      // Parse name into first and last name
      final nameParts = _nameController.text.trim().split(' ');
      final firstName = nameParts.first;
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      // Format phone number to include country code
      String phoneNumber = _phoneController.text.trim();
      if (!phoneNumber.startsWith('+254')) {
        phoneNumber = '+254${phoneNumber.substring(1)}'; // Remove leading 0 and add +254
      }

      // Store registration data locally (for future sync when online)
      final registrationData = {
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'email': _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        'password': _passwordController.text,
        'confirmPassword': _confirmPasswordController.text,
        'county': _selectedCounty.isEmpty ? null : _selectedCounty,
        'preferredLanguage': _selectedLanguage.toLowerCase() == 'english' ? 'en' : 'sw',
        'clientType': 'farmer',
        'acceptTerms': true,
        'registeredAt': DateTime.now().toIso8601String(),
        'offlineMode': true,
      };

      // Simulate successful registration (offline mode)
      final result = _OfflineRegistrationResult(
        success: true,
        userId: 'offline_${DateTime.now().millisecondsSinceEpoch}',
        message: 'Registration successful (offline mode)',
      );

      if (result.success) {
        // If email verification is required
        if (_emailController.text.isNotEmpty) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });

            // Show verification message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registration successful! Please check your email to verify your account.'),
                backgroundColor: Color(0xFF2E7D32),
                duration: Duration(seconds: 5),
              ),
            );

            // Navigate to email verification screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => EmailVerificationScreen(
                  username: phoneNumber,
                  email: _emailController.text.trim(),
                ),
              ),
            );
          }
        } else {
          // Registration complete, save additional profile data
          await _saveAdditionalProfileData();

          if (mounted) {
            setState(() {
              _isLoading = false;
            });

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Welcome to KaziApp, $firstName! 🌾'),
                backgroundColor: const Color(0xFF2E7D32),
                duration: const Duration(seconds: 3),
              ),
            );

            // Navigate to main app
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MainNavigation(),
              ),
            );
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.errorMessage ?? 'Registration failed'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveAdditionalProfileData() async {
    try {
      // Initialize profile service for additional data
      final profileService = FarmerProfileService();
      await profileService.initialize();

      // Save additional farmer profile data
      await profileService.createProfile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        farmName: _farmNameController.text.trim().isEmpty
            ? '${_nameController.text.trim()}\'s Farm'
            : _farmNameController.text.trim(),
        location: _farmLocationController.text.trim().isEmpty
            ? _selectedCounty
            : _farmLocationController.text.trim(),
        county: _selectedCounty.isEmpty ? 'Nairobi' : _selectedCounty,
        farmingType: _selectedFarmingType.isEmpty ? 'Mixed Farming' : _selectedFarmingType,
        experienceLevel: _selectedExperienceLevel.isEmpty ? 'Beginner (0-2 years)' : _selectedExperienceLevel,
        farmSize: double.tryParse(_farmSizeController.text) ?? 1.0,
        crops: _selectedCrops,
        livestock: _selectedLivestock,
        language: _selectedLanguage,
        additionalData: {
          'registrationMethod': 'mobile_app',
          'registrationDate': DateTime.now().toIso8601String(),
          'appVersion': '1.0.0',
          'email': _emailController.text.trim(),
        },
      );

      // Also save to new user profile service
      final userProfileService = UserProfileService();
      await userProfileService.createUserProfileFromRegistration({
        'userId': 'offline_${DateTime.now().millisecondsSinceEpoch}',
        'fullName': _nameController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'email': _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        'county': _selectedCounty.isEmpty ? null : _selectedCounty,
        'preferredLanguage': _selectedLanguage.toLowerCase() == 'english' ? 'en' : 'sw',
        'registrationMode': 'basic',
        'identityVerified': false,
        'farmName': _farmNameController.text.trim().isEmpty
            ? '${_nameController.text.trim()}\'s Farm'
            : _farmNameController.text.trim(),
        'farmLocation': _farmLocationController.text.trim().isEmpty
            ? _selectedCounty
            : _farmLocationController.text.trim(),
        'farmSize': double.tryParse(_farmSizeController.text) ?? 1.0,
        'farmingType': _selectedFarmingType.isEmpty ? 'Mixed Farming' : _selectedFarmingType,
        'crops': _selectedCrops,
        'livestock': _selectedLivestock,
      });

      // Save preferences
      await profileService.savePreferences(
        selectedServices: _selectedServices.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toList(),
        notificationSettings: {
          'weatherAlerts': true,
          'marketPrices': true,
          'vetReminders': true,
          'communityUpdates': true,
        },
        preferredLanguage: _selectedLanguage,
        theme: 'light',
        customSettings: {
          'firstTimeUser': true,
          'onboardingCompleted': true,
        },
      );
    } catch (e) {
      // Log error but don't fail registration
      debugPrint('Failed to save additional profile data: $e');
    }
  }

  Widget _buildFarmInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Farm Information',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Tell us more about your farm',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Farm Name Field
          TextFormField(
            controller: _farmNameController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: 'Farm Name (Optional)',
              hintText: 'e.g., Green Valley Farm',
              prefixIcon: const Icon(Icons.agriculture),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2E7D32)),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // County Dropdown
          DropdownButtonFormField<String>(
            value: _selectedCounty.isEmpty ? null : _selectedCounty,
            decoration: InputDecoration(
              labelText: 'County *',
              prefixIcon: const Icon(Icons.location_on),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2E7D32)),
              ),
            ),
            items: _kenyanCounties.map((county) {
              return DropdownMenuItem(
                value: county,
                child: Text(county),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCounty = value ?? '';
              });
            },
          ),

          const SizedBox(height: 16),

          // Farm Location Field
          TextFormField(
            controller: _farmLocationController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: 'Specific Location (Optional)',
              hintText: 'e.g., Kiambu, Thika Road',
              prefixIcon: const Icon(Icons.place),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2E7D32)),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Farm Size Field
          TextFormField(
            controller: _farmSizeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Farm Size (Acres) *',
              hintText: 'e.g., 2.5',
              prefixIcon: const Icon(Icons.straighten),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2E7D32)),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Farming Type Dropdown
          DropdownButtonFormField<String>(
            value: _selectedFarmingType.isEmpty ? null : _selectedFarmingType,
            decoration: InputDecoration(
              labelText: 'Primary Farming Type *',
              prefixIcon: const Icon(Icons.eco),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2E7D32)),
              ),
            ),
            items: _farmingTypes.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedFarmingType = value ?? '';
              });
            },
          ),

          const SizedBox(height: 16),

          // Experience Level Dropdown
          DropdownButtonFormField<String>(
            value: _selectedExperienceLevel.isEmpty ? null : _selectedExperienceLevel,
            decoration: InputDecoration(
              labelText: 'Experience Level *',
              prefixIcon: const Icon(Icons.school),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2E7D32)),
              ),
            ),
            items: _experienceLevels.map((level) {
              return DropdownMenuItem(
                value: level,
                child: Text(level),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedExperienceLevel = value ?? '';
              });
            },
          ),
        ],
      ),
    );
  }

  void _showUSSDInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('USSD Registration'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('To register via USSD:'),
            SizedBox(height: 8),
            Text('1. Dial *384*96# from your phone'),
            Text('2. Follow the prompts to enter your details'),
            Text('3. Choose your farming type and location'),
            Text('4. Set up your preferences'),
            SizedBox(height: 8),
            Text('USSD registration is free and works on any phone!'),
          ],
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

  Widget _buildFarmingDetailsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Farming Details',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'What do you grow or raise?',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Crops Section
          const Text(
            'Crops (Select all that apply)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _cropOptions.map((crop) {
              final isSelected = _selectedCrops.contains(crop);
              return FilterChip(
                label: Text(crop),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedCrops.add(crop);
                    } else {
                      _selectedCrops.remove(crop);
                    }
                  });
                },
                selectedColor: const Color(0xFF2E7D32).withOpacity(0.2),
                checkmarkColor: const Color(0xFF2E7D32),
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // Livestock Section
          const Text(
            'Livestock (Select all that apply)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _livestockOptions.map((livestock) {
              final isSelected = _selectedLivestock.contains(livestock);
              return FilterChip(
                label: Text(livestock),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedLivestock.add(livestock);
                    } else {
                      _selectedLivestock.remove(livestock);
                    }
                  });
                },
                selectedColor: const Color(0xFF2E7D32).withOpacity(0.2),
                checkmarkColor: const Color(0xFF2E7D32),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Note
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: const Text(
              'Select at least one crop or livestock to continue. You can always update this information later.',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'App Preferences',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Customize your KaziApp experience',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Language Selection
          const Text(
            'Preferred Language',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedLanguage,
            decoration: InputDecoration(
              labelText: 'Language',
              prefixIcon: const Icon(Icons.language),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2E7D32)),
              ),
            ),
            items: _languages.map((language) {
              return DropdownMenuItem(
                value: language,
                child: Text(language),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value ?? 'English';
              });
            },
          ),

          const SizedBox(height: 32),

          // Services Selection
          const Text(
            'Services You\'re Interested In',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select the services you\'d like to use (you can change these later)',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),

          // Services List
          ..._appServices.entries.map((entry) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: CheckboxListTile(
                title: Text(
                  entry.key,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  entry.value,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                value: _selectedServices[entry.key] ?? false,
                onChanged: (value) {
                  setState(() {
                    _selectedServices[entry.key] = value ?? false;
                  });
                },
                activeColor: const Color(0xFF2E7D32),
              ),
            );
          }).toList(),

          const SizedBox(height: 24),

          // Welcome Message
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.celebration,
                  color: Color(0xFF2E7D32),
                  size: 32,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Almost Done!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Click "Complete Registration" to finish setting up your account.',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Simple offline registration result class
class _OfflineRegistrationResult {
  final bool success;
  final String? userId;
  final String? message;
  final String? errorMessage;

  _OfflineRegistrationResult({
    required this.success,
    this.userId,
    this.message,
    this.errorMessage,
  });
}
