import 'package:flutter/material.dart';

class TermsCompletionStep extends StatefulWidget {
  final VoidCallback onComplete;
  final Map<String, dynamic> registrationData;

  const TermsCompletionStep({
    super.key,
    required this.onComplete,
    required this.registrationData,
  });

  @override
  State<TermsCompletionStep> createState() => _TermsCompletionStepState();
}

class _TermsCompletionStepState extends State<TermsCompletionStep> {
  bool _acceptTerms = false;
  bool _acceptPrivacy = false;
  bool _acceptMarketing = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Almost done!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Review your information and accept our terms to complete your registration.',
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
                  // Registration Summary
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.business,
                                color: Colors.green.shade700,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.registrationData['businessName'] ?? 'Your Business',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.registrationData['serviceTypeName'] ?? 'Service Provider',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildSummaryItem(
                          'Location',
                          '${widget.registrationData['county'] ?? 'Not specified'}, Kenya',
                          Icons.location_on,
                        ),
                        _buildSummaryItem(
                          'Contact',
                          widget.registrationData['email'] ?? 'Not specified',
                          Icons.email,
                        ),
                        _buildSummaryItem(
                          'Phone',
                          '+254 ${widget.registrationData['phone'] ?? 'Not specified'}',
                          Icons.phone,
                        ),
                        _buildSummaryItem(
                          'Experience',
                          '${widget.registrationData['yearsInBusiness'] ?? 1} years in business',
                          Icons.timeline,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Terms and Conditions
                  const Text(
                    'Terms & Agreements',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Terms of Service
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          title: const Text(
                            'Terms of Service',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: const Text(
                            'I agree to KaziApp\'s Terms of Service and understand my responsibilities as a service provider.',
                          ),
                          value: _acceptTerms,
                          onChanged: (value) {
                            setState(() {
                              _acceptTerms = value!;
                            });
                          },
                          activeColor: const Color(0xFF2E7D32),
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        
                        const Divider(),
                        
                        CheckboxListTile(
                          title: const Text(
                            'Privacy Policy',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: const Text(
                            'I acknowledge that I have read and accept the Privacy Policy regarding data handling.',
                          ),
                          value: _acceptPrivacy,
                          onChanged: (value) {
                            setState(() {
                              _acceptPrivacy = value!;
                            });
                          },
                          activeColor: const Color(0xFF2E7D32),
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        
                        const Divider(),
                        
                        CheckboxListTile(
                          title: const Text(
                            'Marketing Communications',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: const Text(
                            'I agree to receive marketing communications and business tips (optional).',
                          ),
                          value: _acceptMarketing,
                          onChanged: (value) {
                            setState(() {
                              _acceptMarketing = value!;
                            });
                          },
                          activeColor: const Color(0xFF2E7D32),
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // What happens next
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
                            Icon(Icons.info_outline, color: Colors.blue.shade700),
                            const SizedBox(width: 8),
                            const Text(
                              'What happens next?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildNextStepItem('1. Account verification (24-48 hours)'),
                        _buildNextStepItem('2. Complete your business profile'),
                        _buildNextStepItem('3. Add your services and pricing'),
                        _buildNextStepItem('4. Start receiving bookings from farmers'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Complete Registration button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_acceptTerms && _acceptPrivacy) ? widget.onComplete : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Complete Registration',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Help text
          Center(
            child: Text(
              'Need help? Contact our support team',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: Colors.blue.shade700,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
