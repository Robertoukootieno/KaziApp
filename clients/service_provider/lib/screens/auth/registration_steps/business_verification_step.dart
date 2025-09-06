import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BusinessVerificationStep extends StatefulWidget {
  final VoidCallback onNext;
  final Function(Map<String, dynamic>) onDataChanged;
  final Map<String, dynamic> initialData;

  const BusinessVerificationStep({
    super.key,
    required this.onNext,
    required this.onDataChanged,
    required this.initialData,
  });

  @override
  State<BusinessVerificationStep> createState() => _BusinessVerificationStepState();
}

class _BusinessVerificationStepState extends State<BusinessVerificationStep> {
  final _businessLicenseController = TextEditingController();
  final _taxPinController = TextEditingController();
  
  File? _businessLicenseImage;
  File? _businessLogoImage;
  File? _idCopyImage;
  
  final ImagePicker _picker = ImagePicker();
  bool _hasBusinessLicense = true;
  bool _isRegisteredBusiness = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    _businessLicenseController.text = widget.initialData['businessLicense'] ?? '';
    _taxPinController.text = widget.initialData['taxPin'] ?? '';
    _hasBusinessLicense = widget.initialData['hasBusinessLicense'] ?? true;
    _isRegisteredBusiness = widget.initialData['isRegisteredBusiness'] ?? true;
  }

  @override
  void dispose() {
    _businessLicenseController.dispose();
    _taxPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Verify your business',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Help us verify your business to build trust with farmers. This information is kept secure.',
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
                  // Business Registration Status
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
                        const Text(
                          'Business Registration',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        CheckboxListTile(
                          title: const Text('My business is officially registered'),
                          subtitle: const Text('Registered with relevant authorities'),
                          value: _isRegisteredBusiness,
                          onChanged: (value) {
                            setState(() {
                              _isRegisteredBusiness = value!;
                            });
                            _updateData();
                          },
                          activeColor: const Color(0xFF2E7D32),
                          contentPadding: EdgeInsets.zero,
                        ),
                        
                        CheckboxListTile(
                          title: const Text('I have a business license'),
                          subtitle: const Text('Valid business permit or license'),
                          value: _hasBusinessLicense,
                          onChanged: (value) {
                            setState(() {
                              _hasBusinessLicense = value!;
                            });
                            _updateData();
                          },
                          activeColor: const Color(0xFF2E7D32),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Business License Number (if applicable)
                  if (_hasBusinessLicense) ...[
                    TextFormField(
                      controller: _businessLicenseController,
                      decoration: InputDecoration(
                        labelText: 'Business License Number',
                        hintText: 'Enter your license number',
                        prefixIcon: const Icon(Icons.badge),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      onChanged: (value) => _updateData(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Tax PIN (if registered)
                  if (_isRegisteredBusiness) ...[
                    TextFormField(
                      controller: _taxPinController,
                      decoration: InputDecoration(
                        labelText: 'KRA PIN Number',
                        hintText: 'Enter your KRA PIN',
                        prefixIcon: const Icon(Icons.receipt_long),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      onChanged: (value) => _updateData(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Document Upload Section
                  const Text(
                    'Upload Documents',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Business License Upload
                  if (_hasBusinessLicense)
                    _buildDocumentUpload(
                      title: 'Business License',
                      subtitle: 'Upload a clear photo of your business license',
                      icon: Icons.description,
                      image: _businessLicenseImage,
                      onTap: () => _pickImage('businessLicense'),
                    ),

                  const SizedBox(height: 16),

                  // Business Logo Upload
                  _buildDocumentUpload(
                    title: 'Business Logo (Optional)',
                    subtitle: 'Upload your business logo for better recognition',
                    icon: Icons.business,
                    image: _businessLogoImage,
                    onTap: () => _pickImage('businessLogo'),
                    isOptional: true,
                  ),

                  const SizedBox(height: 16),

                  // ID Copy Upload
                  _buildDocumentUpload(
                    title: 'Owner ID Copy',
                    subtitle: 'Upload a copy of the business owner\'s ID',
                    icon: Icons.credit_card,
                    image: _idCopyImage,
                    onTap: () => _pickImage('idCopy'),
                  ),

                  const SizedBox(height: 24),

                  // Info note
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.amber.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Your documents will be reviewed within 24-48 hours. You can start using the platform immediately.',
                            style: TextStyle(
                              color: Colors.amber.shade700,
                              fontSize: 14,
                            ),
                          ),
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
              onPressed: widget.onNext,
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
    );
  }

  Widget _buildDocumentUpload({
    required String title,
    required String subtitle,
    required IconData icon,
    required File? image,
    required VoidCallback onTap,
    bool isOptional = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: image != null ? Colors.green.shade50 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: image != null ? Colors.green.shade300 : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: image != null ? Colors.green.shade100 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                image != null ? Icons.check_circle : icon,
                color: image != null ? Colors.green.shade700 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 16),
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
                        ),
                      ),
                      if (isOptional) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Optional',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    image != null ? 'Document uploaded' : subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              image != null ? Icons.edit : Icons.camera_alt,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(String type) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        switch (type) {
          case 'businessLicense':
            _businessLicenseImage = File(image.path);
            break;
          case 'businessLogo':
            _businessLogoImage = File(image.path);
            break;
          case 'idCopy':
            _idCopyImage = File(image.path);
            break;
        }
      });
      _updateData();
    }
  }

  void _updateData() {
    widget.onDataChanged({
      'businessLicense': _businessLicenseController.text,
      'taxPin': _taxPinController.text,
      'hasBusinessLicense': _hasBusinessLicense,
      'isRegisteredBusiness': _isRegisteredBusiness,
      'businessLicenseImage': _businessLicenseImage?.path,
      'businessLogoImage': _businessLogoImage?.path,
      'idCopyImage': _idCopyImage?.path,
    });
  }
}
