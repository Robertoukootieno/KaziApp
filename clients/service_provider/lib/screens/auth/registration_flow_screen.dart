import 'dart:io';
import 'package:flutter/material.dart';
import 'registration_steps/service_type_step.dart';
import 'registration_steps/business_info_step.dart';
import 'registration_steps/business_verification_step.dart';
import 'registration_steps/account_setup_step.dart';
import 'registration_steps/terms_completion_step.dart';
import '../../models/user_profile.dart';
import '../../services/user_profile_service.dart';
import '../../services/registration_submission_service.dart';

class RegistrationFlowScreen extends StatefulWidget {
  const RegistrationFlowScreen({super.key});

  @override
  State<RegistrationFlowScreen> createState() => _RegistrationFlowScreenState();
}

class _RegistrationFlowScreenState extends State<RegistrationFlowScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Registration data
  final Map<String, dynamic> _registrationData = {};

  // Services
  final RegistrationSubmissionService _submissionService = RegistrationSubmissionService();

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Service Type',
      'subtitle': 'Choose your business type',
      'icon': Icons.business_center,
    },
    {
      'title': 'Business Info',
      'subtitle': 'Tell us about your business',
      'icon': Icons.info_outline,
    },
    {
      'title': 'Verification',
      'subtitle': 'Verify your business',
      'icon': Icons.verified_user,
    },
    {
      'title': 'Account Setup',
      'subtitle': 'Create your account',
      'icon': Icons.account_circle,
    },
    {
      'title': 'Complete',
      'subtitle': 'Review and finish',
      'icon': Icons.check_circle,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _submissionService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousStep,
              )
            : null,
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            color: const Color(0xFF2E7D32),
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
                                        color: Color(0xFF2E7D32),
                                        size: 18,
                                      )
                                    : Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          color: isActive
                                              ? const Color(0xFF2E7D32)
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
                ServiceTypeStep(
                  onNext: _nextStep,
                  onDataChanged: _updateRegistrationData,
                  initialData: _registrationData,
                ),
                BusinessInfoStep(
                  onNext: _nextStep,
                  onDataChanged: _updateRegistrationData,
                  initialData: _registrationData,
                ),
                BusinessVerificationStep(
                  onNext: _nextStep,
                  onDataChanged: _updateRegistrationData,
                  initialData: _registrationData,
                ),
                AccountSetupStep(
                  onNext: _nextStep,
                  onDataChanged: _updateRegistrationData,
                  initialData: _registrationData,
                ),
                TermsCompletionStep(
                  onComplete: _completeRegistration,
                  registrationData: _registrationData,
                ),
              ],
            ),
          ),
        ],
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

  void _updateRegistrationData(Map<String, dynamic> data) {
    setState(() {
      _registrationData.addAll(data);
    });
  }

  bool _isMarketplaceServiceType(String serviceType) {
    const marketplaceServiceTypes = [
      'agrovet',
      'feed_supplier',
      'seeds_supplier',
      'fertilizer_supplier',
      'retailer',
    ];
    return marketplaceServiceTypes.contains(serviceType);
  }

  Future<void> _completeRegistration() async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Submit registration to admin system for real-time approval
      final documents = <String, File>{};

      // Add document files if they exist
      if (_registrationData['businessLicenseImage'] != null) {
        final file = File(_registrationData['businessLicenseImage']);
        if (await file.exists()) {
          documents['businessLicenseImage'] = file;
        }
      }

      if (_registrationData['businessLogoImage'] != null) {
        final file = File(_registrationData['businessLogoImage']);
        if (await file.exists()) {
          documents['businessLogoImage'] = file;
        }
      }

      if (_registrationData['idCopyImage'] != null) {
        final file = File(_registrationData['idCopyImage']);
        if (await file.exists()) {
          documents['idCopyImage'] = file;
        }
      }

      // Submit to admin system for real-time approval
      final submissionResult = await _submissionService.submitRegistration(
        registrationData: _registrationData,
        documents: documents.isNotEmpty ? documents : null,
      );

      if (!submissionResult['success']) {
        throw Exception(submissionResult['error'] ?? 'Registration submission failed');
      }

      // Create user profile from registration data
      final profileService = UserProfileService.instance;

      // Create business information if available
      BusinessInformation? businessInfo;
      if (_registrationData['businessName'] != null) {
        businessInfo = BusinessInformation(
          businessName: _registrationData['businessName'],
          businessRegistrationNumber: _registrationData['businessRegistrationNumber'],
          businessType: _registrationData['businessType'],
          businessAddress: _registrationData['address'],
          businessPhone: _registrationData['phone'],
          businessEmail: _registrationData['email'],
          taxNumber: _registrationData['taxPin'],
          description: _registrationData['description'],
          businessLicense: _registrationData['businessLicense'],
          taxPin: _registrationData['taxPin'],
          yearsInBusiness: _registrationData['yearsInBusiness'],
          hasBusinessLicense: _registrationData['hasBusinessLicense'] ?? false,
          isRegisteredBusiness: _registrationData['isRegisteredBusiness'] ?? false,
          businessLicenseImagePath: _registrationData['businessLicenseImage'],
          businessLogoImagePath: _registrationData['businessLogoImage'],
          idCopyImagePath: _registrationData['idCopyImage'],
        );
      }

      // Create local user profile with registration tracking
      await profileService.createProfile(
        email: _registrationData['email'],
        profileType: UserProfileType.businessRegistered,
        firstName: _registrationData['firstName'],
        lastName: _registrationData['lastName'],
        phoneNumber: _registrationData['phone'],
        location: _registrationData['address'],
        county: _registrationData['county'],
        subCounty: _registrationData['subCounty'],
        serviceType: _registrationData['serviceType'],
        serviceTypeName: _registrationData['serviceTypeName'],
        businessInfo: businessInfo,
        additionalData: {
          ..._registrationData,
          'registrationId': submissionResult['data']?['registrationId'],
          'submissionStatus': 'submitted_for_approval',
          'submittedAt': DateTime.now().toIso8601String(),
        },
      );

      if (mounted) {
        Navigator.of(context).pop(); // Remove loading dialog

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Registration submitted successfully! Your documents will be reviewed within 24-48 hours. You can start using the platform immediately.',
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ),
        );

        // Check service type and redirect to appropriate portal
        final serviceType = _registrationData['serviceType'];
        if (serviceType == 'veterinarian') {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/veterinary-dashboard',
            (route) => false,
          );
        } else if (serviceType == 'machinery_provider') {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/machinery-dashboard',
            (route) => false,
          );
        } else if (_isMarketplaceServiceType(serviceType)) {
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
