import 'package:flutter/material.dart';
import 'registration_steps/service_type_step.dart';
import 'registration_steps/business_info_step.dart';
import 'registration_steps/business_verification_step.dart';
import 'registration_steps/account_setup_step.dart';
import 'registration_steps/terms_completion_step.dart';

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

  Future<void> _completeRegistration() async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.of(context).pop(); // Remove loading dialog
      
      // Navigate to profile setup or dashboard
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/profile-setup',
        (route) => false,
      );
    }
  }
}
