import 'package:flutter/material.dart';
import 'general_terms_screen.dart';

class TermsConditionsScreen extends StatefulWidget {
  final String fullName;
  final String phoneNumber;
  final String countryCode;
  final String countryFlag;

  const TermsConditionsScreen({
    super.key,
    required this.fullName,
    required this.phoneNumber,
    required this.countryCode,
    required this.countryFlag,
  });

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  bool _acceptGeneralTerms = false;
  bool _acceptLoyaltyTerms = false;
  bool _acceptMarketingTerms = false;
  bool _isLoading = false;

  bool get _canContinue => _acceptGeneralTerms && _acceptLoyaltyTerms;

  void _continue() {
    setState(() {
      _isLoading = true;
    });

    // Navigate to General Terms screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GeneralTermsScreen(
          fullName: widget.fullName,
          phoneNumber: widget.phoneNumber,
          countryCode: widget.countryCode,
          countryFlag: widget.countryFlag,
        ),
      ),
    ).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _showTermsDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required VoidCallback onViewTerms,
    bool isRequired = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? const Color(0xFF2E7D32).withValues(alpha: 0.3) : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: const Color(0xFF2E7D32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        if (isRequired) ...[
                          const SizedBox(width: 4),
                          const Text(
                            '*',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: onViewTerms,
                      child: const Text(
                        'View Terms',
                        style: TextStyle(
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              
              // Header
              Column(
                children: [
                  // Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.description_outlined,
                      size: 40,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Title
                  const Text(
                    'Terms & Conditions',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Text(
                    'Please review and accept our terms to continue',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Terms List
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // General Terms & Conditions
                      _buildTermsCheckbox(
                        title: 'General Terms & Conditions',
                        description: 'Accept our general terms of service and privacy policy',
                        value: _acceptGeneralTerms,
                        onChanged: (value) => setState(() => _acceptGeneralTerms = value ?? false),
                        onViewTerms: () => _showTermsDialog(
                          'General Terms & Conditions',
                          'By using KaziApp, you agree to our terms of service. This includes:\n\n'
                          '• Responsible use of the platform\n'
                          '• Accuracy of information provided\n'
                          '• Compliance with local laws\n'
                          '• Respect for other users\n'
                          '• Protection of your account credentials\n\n'
                          'We are committed to protecting your privacy and data security.',
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Loyalty Terms
                      _buildTermsCheckbox(
                        title: 'Loyalty Program Terms',
                        description: 'Join our loyalty program to earn rewards and benefits',
                        value: _acceptLoyaltyTerms,
                        onChanged: (value) => setState(() => _acceptLoyaltyTerms = value ?? false),
                        onViewTerms: () => _showTermsDialog(
                          'Loyalty Program Terms',
                          'Our loyalty program offers:\n\n'
                          '• Points for app usage and engagement\n'
                          '• Exclusive discounts on services\n'
                          '• Priority customer support\n'
                          '• Early access to new features\n'
                          '• Special farming resources and content\n\n'
                          'Points expire after 12 months of inactivity.',
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Marketing Terms (Optional)
                      _buildTermsCheckbox(
                        title: 'Marketing Communications',
                        description: 'Receive updates, tips, and promotional offers (optional)',
                        value: _acceptMarketingTerms,
                        onChanged: (value) => setState(() => _acceptMarketingTerms = value ?? false),
                        onViewTerms: () => _showTermsDialog(
                          'Marketing Communications',
                          'By accepting marketing communications, you will receive:\n\n'
                          '• Farming tips and best practices\n'
                          '• Product updates and new features\n'
                          '• Special offers and promotions\n'
                          '• Seasonal farming advice\n'
                          '• Community events and webinars\n\n'
                          'You can unsubscribe at any time from your account settings.',
                        ),
                        isRequired: false,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Required fields note
                      Row(
                        children: [
                          const Text(
                            '* ',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Required to continue',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Continue Button
              Container(
                margin: const EdgeInsets.only(bottom: 32, top: 16),
                child: ElevatedButton(
                  onPressed: _canContinue && !_isLoading ? _continue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canContinue ? const Color(0xFF2E7D32) : Colors.grey[300],
                    foregroundColor: _canContinue ? Colors.white : Colors.grey[600],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Accept & Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
