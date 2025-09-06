import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../navigation/main_navigation.dart';
import '../../services/farmer_profile_service.dart';

class FarmerRegisterScreen extends StatefulWidget {
  const FarmerRegisterScreen({super.key});

  @override
  State<FarmerRegisterScreen> createState() => _FarmerRegisterScreenState();
}

class _FarmerRegisterScreenState extends State<FarmerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  
  // Basic Information Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
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
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
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
                borderSide: const BorderSide(color: Color(0xFF2E7D32)),
              ),
            ),
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
                borderSide: const BorderSide(color: Color(0xFF2E7D32)),
              ),
            ),
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

  void _completeRegistration() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Initialize profile service
      final profileService = FarmerProfileService();
      await profileService.initialize();

      // Create farmer profile
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
        },
      );

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

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Show success message with personalized content
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome to KaziApp, ${_nameController.text.split(' ').first}! 🌾'),
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

  Widget _buildFarmInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          const Icon(
            Icons.agriculture,
            size: 64,
            color: Color(0xFF2E7D32),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tell us about your farm',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Help us understand your farming operation',
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
              labelText: 'Farm Name',
              hintText: 'e.g., Green Valley Farm',
              prefixIcon: const Icon(Icons.home_work),
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
            initialValue: _selectedCounty.isEmpty ? null : _selectedCounty,
            decoration: InputDecoration(
              labelText: 'County',
              hintText: 'Select your county',
              prefixIcon: const Icon(Icons.map),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2E7D32)),
              ),
            ),
            items: _kenyanCounties.map((String county) {
              return DropdownMenuItem<String>(
                value: county,
                child: Text(county),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCounty = newValue ?? '';
              });
            },
          ),

          const SizedBox(height: 16),

          // Farm Location Field
          TextFormField(
            controller: _farmLocationController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: 'Specific Location',
              hintText: 'e.g., Kiambu Town, near ABC School',
              prefixIcon: const Icon(Icons.location_on),
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
              labelText: 'Farm Size (acres)',
              hintText: 'e.g., 2.5',
              prefixIcon: const Icon(Icons.landscape),
              suffixText: 'acres',
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

          // Farming Type Selection
          const Text(
            'Primary Farming Type',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          ...List.generate(_farmingTypes.length, (index) {
            final type = _farmingTypes[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _selectedFarmingType == type
                      ? const Color(0xFF2E7D32)
                      : Colors.grey[300]!,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: Text(type),
                subtitle: Text(_getFarmingTypeDescription(type)),
                leading: Icon(
                  _selectedFarmingType == type
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: _selectedFarmingType == type
                      ? const Color(0xFF2E7D32)
                      : Colors.grey,
                ),
                onTap: () {
                  setState(() {
                    _selectedFarmingType = type;
                  });
                },
              ),
            );
          }),

          const SizedBox(height: 16),

          // Experience Level Selection
          const Text(
            'Farming Experience',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            initialValue: _selectedExperienceLevel.isEmpty ? null : _selectedExperienceLevel,
            decoration: InputDecoration(
              labelText: 'Experience Level',
              hintText: 'Select your experience level',
              prefixIcon: const Icon(Icons.star),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2E7D32)),
              ),
            ),
            items: _experienceLevels.map((String level) {
              return DropdownMenuItem<String>(
                value: level,
                child: Text(level),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedExperienceLevel = newValue ?? '';
              });
            },
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
          // Header
          const Icon(
            Icons.eco,
            size: 64,
            color: Color(0xFF2E7D32),
          ),
          const SizedBox(height: 16),
          const Text(
            'What do you grow & raise?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Select your crops and livestock',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Crops Section
          const Row(
            children: [
              Icon(Icons.grass, color: Color(0xFF2E7D32)),
              SizedBox(width: 8),
              Text(
                'Crops You Grow',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _cropOptions.map((crop) {
                final isSelected = _selectedCrops.contains(crop);
                return FilterChip(
                  label: Text(crop),
                  selected: isSelected,
                  onSelected: (bool selected) {
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
          ),

          const SizedBox(height: 24),

          // Livestock Section
          const Row(
            children: [
              Icon(Icons.pets, color: Color(0xFF2E7D32)),
              SizedBox(width: 8),
              Text(
                'Livestock You Keep',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _livestockOptions.map((livestock) {
                final isSelected = _selectedLivestock.contains(livestock);
                return FilterChip(
                  label: Text(livestock),
                  selected: isSelected,
                  onSelected: (bool selected) {
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
          ),

          const SizedBox(height: 24),

          // Quick Selection Buttons
          const Text(
            'Quick Selection',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedCrops.clear();
                      _selectedCrops.addAll(['Maize', 'Beans', 'Kales', 'Tomatoes']);
                    });
                  },
                  icon: const Icon(Icons.grass),
                  label: const Text('Common Crops'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2E7D32),
                    side: const BorderSide(color: Color(0xFF2E7D32)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedLivestock.clear();
                      _selectedLivestock.addAll(['Cattle', 'Goats', 'Chickens']);
                    });
                  },
                  icon: const Icon(Icons.pets),
                  label: const Text('Common Livestock'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2E7D32),
                    side: const BorderSide(color: Color(0xFF2E7D32)),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Clear All Button
          TextButton(
            onPressed: () {
              setState(() {
                _selectedCrops.clear();
                _selectedLivestock.clear();
              });
            },
            child: const Text(
              'Clear All Selections',
              style: TextStyle(color: Colors.red),
            ),
          ),

          const SizedBox(height: 16),

          // Selection Summary
          if (_selectedCrops.isNotEmpty || _selectedLivestock.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Selection Summary:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_selectedCrops.isNotEmpty)
                    Text('Crops: ${_selectedCrops.join(', ')}'),
                  if (_selectedLivestock.isNotEmpty)
                    Text('Livestock: ${_selectedLivestock.join(', ')}'),
                ],
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
          // Header
          const Icon(
            Icons.settings,
            size: 64,
            color: Color(0xFF2E7D32),
          ),
          const SizedBox(height: 16),
          const Text(
            'Customize your experience',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Choose services and preferences',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Language Selection
          const Row(
            children: [
              Icon(Icons.language, color: Color(0xFF2E7D32)),
              SizedBox(width: 8),
              Text(
                'Preferred Language',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            initialValue: _selectedLanguage,
            decoration: InputDecoration(
              labelText: 'Language',
              prefixIcon: const Icon(Icons.translate),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF2E7D32)),
              ),
            ),
            items: _languages.map((String language) {
              return DropdownMenuItem<String>(
                value: language,
                child: Text(language),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedLanguage = newValue ?? 'English';
              });
            },
          ),

          const SizedBox(height: 24),

          // App Services Selection
          const Row(
            children: [
              Icon(Icons.apps, color: Color(0xFF2E7D32)),
              SizedBox(width: 8),
              Text(
                'App Services',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Select services you want to use (you can change these later)',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),

          ..._appServices.entries.map((service) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CheckboxListTile(
                title: Text(
                  service.key,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  service.value,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                value: _selectedServices[service.key] ?? false,
                onChanged: (bool? value) {
                  setState(() {
                    _selectedServices[service.key] = value ?? false;
                  });
                },
                activeColor: const Color(0xFF2E7D32),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          // Quick Selection Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      for (String service in _appServices.keys) {
                        _selectedServices[service] = true;
                      }
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2E7D32),
                    side: const BorderSide(color: Color(0xFF2E7D32)),
                  ),
                  child: const Text('Select All'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      for (String service in _appServices.keys) {
                        _selectedServices[service] = false;
                      }
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text('Clear All'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Registration Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.check_circle, color: Color(0xFF2E7D32)),
                    SizedBox(width: 8),
                    Text(
                      'Registration Summary',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildSummaryRow('Name', _nameController.text),
                _buildSummaryRow('Phone', '+254 ${_phoneController.text}'),
                _buildSummaryRow('Farm', _farmNameController.text.isEmpty
                    ? '${_nameController.text}\'s Farm'
                    : _farmNameController.text),
                _buildSummaryRow('Location', _selectedCounty),
                _buildSummaryRow('Farming Type', _selectedFarmingType),
                _buildSummaryRow('Experience', _selectedExperienceLevel),
                _buildSummaryRow('Farm Size', '${_farmSizeController.text} acres'),
                if (_selectedCrops.isNotEmpty)
                  _buildSummaryRow('Crops', _selectedCrops.take(3).join(', ') +
                      (_selectedCrops.length > 3 ? '...' : '')),
                if (_selectedLivestock.isNotEmpty)
                  _buildSummaryRow('Livestock', _selectedLivestock.take(3).join(', ') +
                      (_selectedLivestock.length > 3 ? '...' : '')),
                _buildSummaryRow('Language', _selectedLanguage),
                _buildSummaryRow('Services', '${_selectedServices.values.where((v) => v).length} selected'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Terms and Conditions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.info,
                  color: Colors.blue,
                  size: 32,
                ),
                const SizedBox(height: 8),
                const Text(
                  'By completing registration, you agree to:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• KaziApp Terms of Service\n'
                  '• Privacy Policy\n'
                  '• Data collection for service improvement\n'
                  '• SMS notifications for important updates',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    _showTermsAndConditions();
                  },
                  child: const Text('Read Full Terms'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getFarmingTypeDescription(String type) {
    switch (type) {
      case 'Crop Farming':
        return 'Growing crops like maize, beans, vegetables';
      case 'Livestock Farming':
        return 'Raising cattle, goats, sheep for meat/milk';
      case 'Mixed Farming':
        return 'Combination of crops and livestock';
      case 'Poultry Farming':
        return 'Raising chickens, ducks, turkeys for eggs/meat';
      case 'Dairy Farming':
        return 'Specialized milk production from cows/goats';
      case 'Fish Farming':
        return 'Aquaculture - raising fish in ponds/tanks';
      case 'Horticulture':
        return 'Growing fruits, flowers, ornamental plants';
      case 'Agro-forestry':
        return 'Combining trees with crops/livestock';
      default:
        return 'Select your primary farming activity';
    }
  }

  Widget _buildSummaryRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms and Conditions'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'KaziApp Terms of Service',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '1. Service Usage: KaziApp provides agricultural services including AI diagnosis, weather updates, market prices, and veterinary connections.\n\n'
                '2. Data Collection: We collect farm and personal information to provide personalized services.\n\n'
                '3. Privacy: Your data is protected and used only for service improvement and delivery.\n\n'
                '4. Communication: You may receive SMS notifications for important updates and alerts.\n\n'
                '5. Service Availability: Services are provided as-is and availability may vary by location.\n\n'
                '6. User Responsibility: Provide accurate information for best service delivery.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('I Understand'),
          ),
        ],
      ),
    );
  }
}
