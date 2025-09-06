import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/models.dart';
import '../../services/services.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final PageController _pageController = PageController();
  final AuthService _authService = AuthService();

  int _currentPage = 0;
  bool _isLoading = false;

  // Form keys
  final _businessDetailsFormKey = GlobalKey<FormState>();
  final _operatingHoursFormKey = GlobalKey<FormState>();
  final _certificationsFormKey = GlobalKey<FormState>();

  // Controllers
  final _descriptionController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _taxNumberController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _websiteController = TextEditingController();
  final _deliveryRadiusController = TextEditingController();
  final _deliveryFeeController = TextEditingController();

  // Profile data
  File? _profileImage;
  String? _profileImageUrl;
  final List<String> _selectedServiceAreas = [];
  final List<String> _selectedPaymentMethods = [];
  final Map<String, String> _operatingHours = {};
  bool _hasDelivery = false;
  final List<Certification> _certifications = [];

  // Available options
  final List<String> _kenyanCities = [
    'Nairobi', 'Mombasa', 'Kisumu', 'Nakuru', 'Eldoret', 'Thika', 'Malindi',
    'Kitale', 'Garissa', 'Kakamega', 'Machakos', 'Meru', 'Nyeri', 'Kericho',
    'Embu', 'Migori', 'Homa Bay', 'Naivasha', 'Voi', 'Wajir', 'Marsabit',
    'Isiolo', 'Lamu', 'Mandera', 'Moyale', 'Lodwar', 'Kapenguria', 'Bungoma',
    'Webuye', 'Busia', 'Siaya', 'Kisii', 'Keroka', 'Nyamira', 'Bomet',
    'Sotik', 'Narok', 'Kilgoris', 'Kajiado', 'Namanga', 'Loitokitok',
  ];

  final List<String> _paymentMethods = [
    'M-Pesa', 'Cash', 'Bank Transfer', 'Airtel Money', 'T-Kash', 'Credit Card',
    'Cheque', 'Mobile Banking', 'PayPal', 'Equity Bank', 'KCB Bank', 'Co-op Bank',
  ];

  final List<String> _daysOfWeek = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    _initializeOperatingHours();
  }

  void _initializeOperatingHours() {
    for (final day in _daysOfWeek) {
      _operatingHours[day] = '8:00 AM - 5:00 PM';
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _descriptionController.dispose();
    _registrationNumberController.dispose();
    _taxNumberController.dispose();
    _licenseNumberController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    _deliveryRadiusController.dispose();
    _deliveryFeeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress Indicator
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF2E7D32),
            child: Column(
              children: [
                Row(
                  children: List.generate(4, (index) {
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
                        height: 4,
                        decoration: BoxDecoration(
                          color: index <= _currentPage
                              ? Colors.white
                              : Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                Text(
                  _getPageTitle(_currentPage),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
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
                _buildBusinessDetailsPage(),
                _buildServiceAreasPage(),
                _buildOperatingHoursPage(),
                _buildCertificationsPage(),
              ],
            ),
          ),

          // Navigation Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentPage > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousPage,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFF2E7D32)),
                      ),
                      child: const Text('Previous'),
                    ),
                  ),
                if (_currentPage > 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _nextPage,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF2E7D32),
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
                        : Text(_currentPage == 3 ? 'Complete Setup' : 'Next'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPageTitle(int page) {
    switch (page) {
      case 0:
        return 'Business Details';
      case 1:
        return 'Service Areas';
      case 2:
        return 'Operating Hours';
      case 3:
        return 'Certifications';
      default:
        return '';
    }
  }

  Widget _buildBusinessDetailsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _businessDetailsFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tell us about your business',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This information helps farmers find and trust your services.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 32),

            // Profile Image
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickProfileImage,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(
                          color: const Color(0xFF2E7D32),
                          width: 3,
                        ),
                      ),
                      child: _profileImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(57),
                              child: Image.file(
                                _profileImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.add_a_photo,
                              size: 40,
                              color: Color(0xFF2E7D32),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add Business Logo',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Business Description
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Business Description',
                hintText: 'Describe your business, services, and what makes you unique...',
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please provide a business description';
                }
                if (value.trim().length < 50) {
                  return 'Description should be at least 50 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Registration Details
            const Text(
              'Registration Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _registrationNumberController,
              decoration: const InputDecoration(
                labelText: 'Business Registration Number',
                hintText: 'Enter your business registration number',
                prefixIcon: Icon(Icons.business),
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _taxNumberController,
              decoration: const InputDecoration(
                labelText: 'Tax/PIN Number',
                hintText: 'Enter your KRA PIN number',
                prefixIcon: Icon(Icons.receipt_long),
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _licenseNumberController,
              decoration: const InputDecoration(
                labelText: 'Professional License Number (Optional)',
                hintText: 'Enter your professional license number',
                prefixIcon: Icon(Icons.verified),
              ),
            ),

            const SizedBox(height: 24),

            // Contact Information
            const Text(
              'Business Address',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Physical Address',
                hintText: 'Enter your complete business address',
                prefixIcon: Icon(Icons.location_on),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please provide your business address';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _websiteController,
              decoration: const InputDecoration(
                labelText: 'Website (Optional)',
                hintText: 'https://www.yourbusiness.com',
                prefixIcon: Icon(Icons.language),
              ),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (!value.startsWith('http://') && !value.startsWith('https://')) {
                    return 'Please enter a valid URL starting with http:// or https://';
                  }
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceAreasPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Service Areas & Payment',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select the areas you serve and payment methods you accept.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 32),

          // Service Areas
          const Text(
            'Service Areas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select all areas where you provide services:',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _kenyanCities.map((city) {
              final isSelected = _selectedServiceAreas.contains(city);
              return FilterChip(
                label: Text(city),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedServiceAreas.add(city);
                    } else {
                      _selectedServiceAreas.remove(city);
                    }
                  });
                },
                selectedColor: const Color(0xFF2E7D32).withValues(alpha: 0.2),
                checkmarkColor: const Color(0xFF2E7D32),
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // Payment Methods
          const Text(
            'Payment Methods',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select payment methods you accept:',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _paymentMethods.map((method) {
              final isSelected = _selectedPaymentMethods.contains(method);
              return FilterChip(
                label: Text(method),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedPaymentMethods.add(method);
                    } else {
                      _selectedPaymentMethods.remove(method);
                    }
                  });
                },
                selectedColor: const Color(0xFF2E7D32).withValues(alpha: 0.2),
                checkmarkColor: const Color(0xFF2E7D32),
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          // Delivery Options
          const Text(
            'Delivery Options',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          SwitchListTile(
            title: const Text('Offer Delivery Services'),
            subtitle: const Text('Do you deliver products to customers?'),
            value: _hasDelivery,
            onChanged: (value) {
              setState(() {
                _hasDelivery = value;
              });
            },
            activeThumbColor: const Color(0xFF2E7D32),
          ),

          if (_hasDelivery) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _deliveryRadiusController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Delivery Radius (km)',
                hintText: 'Maximum distance you deliver',
                prefixIcon: Icon(Icons.location_on),
                suffixText: 'km',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _deliveryFeeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Delivery Fee (KSh)',
                hintText: 'Standard delivery charge',
                prefixIcon: Icon(Icons.money),
                prefixText: 'KSh ',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOperatingHoursPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _operatingHoursFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Operating Hours',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Set your business hours so customers know when you\'re available.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 32),

            ..._daysOfWeek.map((day) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          day,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () => _selectOperatingHours(day),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _operatingHours[day] ?? 'Closed',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _setAllDaysToSameHours,
                    icon: const Icon(Icons.copy_all),
                    label: const Text('Copy to All Days'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF2E7D32)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _setWeekdayHours,
                    icon: const Icon(Icons.business_center),
                    label: const Text('Weekdays Only'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF2E7D32)),
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

  Widget _buildCertificationsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _certificationsFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Certifications & Licenses',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add your professional certifications to build trust with customers.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 32),

            if (_certifications.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.verified,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No certifications added yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add your professional certifications and licenses to build credibility',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              )
            else
              ..._certifications.map((cert) => _buildCertificationCard(cert)),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _addCertification,
                icon: const Icon(Icons.add),
                label: const Text('Add Certification'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF2E7D32)),
                ),
              ),
            ),

            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Verification Process',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your certifications will be verified by our team. This may take 1-3 business days. Verified providers get a trust badge and higher visibility.',
                    style: TextStyle(
                      color: Colors.blue.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  Future<void> _pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _selectOperatingHours(String day) {
    showDialog(
      context: context,
      builder: (context) => _OperatingHoursDialog(
        day: day,
        currentHours: _operatingHours[day] ?? 'Closed',
        onSave: (hours) {
          setState(() {
            _operatingHours[day] = hours;
          });
        },
      ),
    );
  }

  void _setAllDaysToSameHours() {
    if (_operatingHours.values.any((hours) => hours != 'Closed')) {
      final firstNonClosedHours = _operatingHours.values
          .firstWhere((hours) => hours != 'Closed', orElse: () => '8:00 AM - 5:00 PM');

      setState(() {
        for (final day in _daysOfWeek) {
          _operatingHours[day] = firstNonClosedHours;
        }
      });
    }
  }

  void _setWeekdayHours() {
    const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    const weekends = ['Saturday', 'Sunday'];

    setState(() {
      for (final day in weekdays) {
        _operatingHours[day] = '8:00 AM - 5:00 PM';
      }
      for (final day in weekends) {
        _operatingHours[day] = 'Closed';
      }
    });
  }

  void _addCertification() {
    showDialog(
      context: context,
      builder: (context) => _CertificationDialog(
        onSave: (certification) {
          setState(() {
            _certifications.add(certification);
          });
        },
      ),
    );
  }

  Widget _buildCertificationCard(Certification cert) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    cert.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _certifications.remove(cert);
                    });
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Issued by: ${cert.issuingAuthority}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              'Issue Date: ${cert.issueDate.day}/${cert.issueDate.month}/${cert.issueDate.year}',
              style: const TextStyle(color: Colors.grey),
            ),
            if (cert.expiryDate != null) ...[
              const SizedBox(height: 4),
              Text(
                'Expires: ${cert.expiryDate!.day}/${cert.expiryDate!.month}/${cert.expiryDate!.year}',
                style: TextStyle(
                  color: cert.isExpired ? Colors.red : Colors.grey,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextPage() {
    if (_currentPage < 3) {
      if (_validateCurrentPage()) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      _completeSetup();
    }
  }

  bool _validateCurrentPage() {
    switch (_currentPage) {
      case 0:
        return _businessDetailsFormKey.currentState?.validate() ?? false;
      case 1:
        if (_selectedServiceAreas.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select at least one service area'),
              backgroundColor: Colors.red,
            ),
          );
          return false;
        }
        if (_selectedPaymentMethods.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select at least one payment method'),
              backgroundColor: Colors.red,
            ),
          );
          return false;
        }
        return true;
      case 2:
        final hasOpenHours = _operatingHours.values.any((hours) => hours != 'Closed');
        if (!hasOpenHours) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please set operating hours for at least one day'),
              backgroundColor: Colors.red,
            ),
          );
          return false;
        }
        return true;
      case 3:
        return true; // Certifications are optional
      default:
        return true;
    }
  }

  Future<void> _completeSetup() async {
    if (!_validateCurrentPage()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Upload profile image if selected
      String? profileImageUrl;
      if (_profileImage != null) {
        profileImageUrl = await _authService.uploadProfileImage(_profileImage!.path);
      }

      // Create business details
      final businessDetails = BusinessDetails(
        registrationNumber: _registrationNumberController.text.trim().isEmpty
            ? null
            : _registrationNumberController.text.trim(),
        taxNumber: _taxNumberController.text.trim().isEmpty
            ? null
            : _taxNumberController.text.trim(),
        licenseNumber: _licenseNumberController.text.trim().isEmpty
            ? null
            : _licenseNumberController.text.trim(),
        address: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        website: _websiteController.text.trim().isEmpty
            ? null
            : _websiteController.text.trim(),
        operatingHours: _operatingHours,
        paymentMethods: _selectedPaymentMethods,
        hasDelivery: _hasDelivery,
        deliveryRadius: _hasDelivery && _deliveryRadiusController.text.isNotEmpty
            ? double.tryParse(_deliveryRadiusController.text)
            : null,
        deliveryFee: _hasDelivery && _deliveryFeeController.text.isNotEmpty
            ? double.tryParse(_deliveryFeeController.text)
            : null,
      );

      // Update user profile
      final currentUser = _authService.currentUser!;
      final updatedUser = currentUser.copyWith(
        description: _descriptionController.text.trim(),
        profileImageUrl: profileImageUrl ?? currentUser.profileImageUrl,
        businessDetails: businessDetails,
        serviceAreas: _selectedServiceAreas,
        certifications: _certifications,
        updatedAt: DateTime.now(),
      );

      final result = await _authService.updateProfile(updatedUser);

      if (result.isSuccess) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/dashboard');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile setup completed successfully!'),
              backgroundColor: Color(0xFF2E7D32),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.error ?? 'Failed to complete setup'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
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
}

// Dialog for selecting operating hours
class _OperatingHoursDialog extends StatefulWidget {
  final String day;
  final String currentHours;
  final Function(String) onSave;

  const _OperatingHoursDialog({
    required this.day,
    required this.currentHours,
    required this.onSave,
  });

  @override
  State<_OperatingHoursDialog> createState() => _OperatingHoursDialogState();
}

class _OperatingHoursDialogState extends State<_OperatingHoursDialog> {
  late String _selectedHours;
  bool _isClosed = false;

  final List<String> _timeOptions = [
    '6:00 AM - 2:00 PM',
    '7:00 AM - 3:00 PM',
    '8:00 AM - 4:00 PM',
    '8:00 AM - 5:00 PM',
    '9:00 AM - 5:00 PM',
    '9:00 AM - 6:00 PM',
    '10:00 AM - 6:00 PM',
    '8:00 AM - 8:00 PM',
    '24 Hours',
  ];

  @override
  void initState() {
    super.initState();
    _selectedHours = widget.currentHours;
    _isClosed = widget.currentHours == 'Closed';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.day} Hours'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            title: const Text('Closed'),
            value: _isClosed,
            onChanged: (value) {
              setState(() {
                _isClosed = value;
                if (value) {
                  _selectedHours = 'Closed';
                } else {
                  _selectedHours = '8:00 AM - 5:00 PM';
                }
              });
            },
            activeThumbColor: const Color(0xFF2E7D32),
          ),
          if (!_isClosed) ...[
            const SizedBox(height: 16),
            const Text('Select operating hours:'),
            const SizedBox(height: 8),
            ...(_timeOptions.map((time) {
              final isSelected = _selectedHours == time;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedHours = time;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2E7D32).withValues(alpha: 0.1)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF2E7D32)
                          : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                        color: isSelected ? const Color(0xFF2E7D32) : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        time,
                        style: TextStyle(
                          color: isSelected ? const Color(0xFF2E7D32) : Colors.black,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList()),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(_selectedHours);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

// Dialog for adding certifications
class _CertificationDialog extends StatefulWidget {
  final Function(Certification) onSave;

  const _CertificationDialog({required this.onSave});

  @override
  State<_CertificationDialog> createState() => _CertificationDialogState();
}

class _CertificationDialogState extends State<_CertificationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _authorityController = TextEditingController();

  DateTime _issueDate = DateTime.now();
  DateTime? _expiryDate;
  bool _hasExpiry = false;

  @override
  void dispose() {
    _nameController.dispose();
    _authorityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Certification'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Certification Name',
                hintText: 'e.g., Veterinary License',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter certification name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _authorityController,
              decoration: const InputDecoration(
                labelText: 'Issuing Authority',
                hintText: 'e.g., Kenya Veterinary Board',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter issuing authority';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Issue Date'),
              subtitle: Text('${_issueDate.day}/${_issueDate.month}/${_issueDate.year}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _issueDate,
                  firstDate: DateTime(1990),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _issueDate = date;
                  });
                }
              },
            ),
            SwitchListTile(
              title: const Text('Has Expiry Date'),
              value: _hasExpiry,
              onChanged: (value) {
                setState(() {
                  _hasExpiry = value;
                  if (!value) {
                    _expiryDate = null;
                  }
                });
              },
              activeThumbColor: const Color(0xFF2E7D32),
            ),
            if (_hasExpiry)
              ListTile(
                title: const Text('Expiry Date'),
                subtitle: Text(_expiryDate != null
                    ? '${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}'
                    : 'Select expiry date'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _expiryDate ?? DateTime.now().add(const Duration(days: 365)),
                    firstDate: _issueDate,
                    lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
                  );
                  if (date != null) {
                    setState(() {
                      _expiryDate = date;
                    });
                  }
                },
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (_hasExpiry && _expiryDate == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select an expiry date'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final certification = Certification(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: _nameController.text.trim(),
                issuingAuthority: _authorityController.text.trim(),
                issueDate: _issueDate,
                expiryDate: _expiryDate,
                isVerified: false,
              );

              widget.onSave(certification);
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
