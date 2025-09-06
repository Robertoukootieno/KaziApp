import 'package:flutter/material.dart';

class BusinessInfoStep extends StatefulWidget {
  final VoidCallback onNext;
  final Function(Map<String, dynamic>) onDataChanged;
  final Map<String, dynamic> initialData;

  const BusinessInfoStep({
    super.key,
    required this.onNext,
    required this.onDataChanged,
    required this.initialData,
  });

  @override
  State<BusinessInfoStep> createState() => _BusinessInfoStepState();
}

class _BusinessInfoStepState extends State<BusinessInfoStep> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  String _selectedCounty = '';
  String _selectedSubCounty = '';
  int _yearsInBusiness = 1;

  final List<String> _counties = [
    'Nairobi', 'Nakuru', 'Kiambu', 'Machakos', 'Kajiado', 'Murang\'a',
    'Nyeri', 'Kirinyaga', 'Nyandarua', 'Laikipia', 'Meru', 'Tharaka Nithi',
    'Embu', 'Kitui', 'Makueni', 'Nzaui', 'Mombasa', 'Kwale', 'Kilifi',
    'Tana River', 'Lamu', 'Taita Taveta', 'Garissa', 'Wajir', 'Mandera',
    'Marsabit', 'Isiolo', 'Samburu', 'Turkana', 'West Pokot', 'Trans Nzoia',
    'Uasin Gishu', 'Elgeyo Marakwet', 'Nandi', 'Baringo', 'Kericho',
    'Bomet', 'Kakamega', 'Vihiga', 'Bungoma', 'Busia', 'Siaya', 'Kisumu',
    'Homa Bay', 'Migori', 'Kisii', 'Nyamira'
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    _businessNameController.text = widget.initialData['businessName'] ?? '';
    _descriptionController.text = widget.initialData['description'] ?? '';
    _addressController.text = widget.initialData['address'] ?? '';
    _phoneController.text = widget.initialData['phone'] ?? '';
    _emailController.text = widget.initialData['email'] ?? '';
    _selectedCounty = widget.initialData['county'] ?? '';
    _selectedSubCounty = widget.initialData['subCounty'] ?? '';
    _yearsInBusiness = widget.initialData['yearsInBusiness'] ?? 1;
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
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
              'Tell us about your business',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Provide details about your business to help farmers understand your services better.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 32),

            // Form fields
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Business Name
                    TextFormField(
                      controller: _businessNameController,
                      decoration: InputDecoration(
                        labelText: 'Business Name *',
                        hintText: 'Enter your business name',
                        prefixIcon: const Icon(Icons.business),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your business name';
                        }
                        return null;
                      },
                      onChanged: _updateData,
                    ),

                    const SizedBox(height: 20),

                    // Business Description
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Business Description *',
                        hintText: 'Describe your services and what makes you unique',
                        prefixIcon: const Icon(Icons.description),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please describe your business';
                        }
                        return null;
                      },
                      onChanged: _updateData,
                    ),

                    const SizedBox(height: 20),

                    // County Selection
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCounty.isEmpty ? null : _selectedCounty,
                      decoration: InputDecoration(
                        labelText: 'County *',
                        prefixIcon: const Icon(Icons.location_on),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      items: _counties.map((county) {
                        return DropdownMenuItem(
                          value: county,
                          child: Text(county),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCounty = value!;
                          _selectedSubCounty = ''; // Reset sub-county
                        });
                        _updateData();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your county';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Physical Address
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Physical Address *',
                        hintText: 'Street address, building, town',
                        prefixIcon: const Icon(Icons.home),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                      onChanged: _updateData,
                    ),

                    const SizedBox(height: 20),

                    // Phone Number
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Business Phone *',
                        hintText: '0712345678',
                        prefixIcon: const Icon(Icons.phone),
                        prefixText: '+254 ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (value.length < 9) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                      onChanged: _updateData,
                    ),

                    const SizedBox(height: 20),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Business Email *',
                        hintText: 'business@example.com',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
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
                      onChanged: _updateData,
                    ),

                    const SizedBox(height: 32),

                    // Years in Business
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Years in Business',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.business_center, color: Colors.grey),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Slider(
                                  value: _yearsInBusiness.toDouble(),
                                  min: 1,
                                  max: 30,
                                  divisions: 29,
                                  activeColor: const Color(0xFF2E7D32),
                                  label: '$_yearsInBusiness ${_yearsInBusiness == 1 ? 'year' : 'years'}',
                                  onChanged: (value) {
                                    setState(() {
                                      _yearsInBusiness = value.round();
                                    });
                                    _updateData();
                                  },
                                ),
                              ),
                              Text(
                                '$_yearsInBusiness',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ],
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

  void _updateData([String? value]) {
    widget.onDataChanged({
      'businessName': _businessNameController.text,
      'description': _descriptionController.text,
      'address': _addressController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
      'county': _selectedCounty,
      'subCounty': _selectedSubCounty,
      'yearsInBusiness': _yearsInBusiness,
    });
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      _updateData();
      widget.onNext();
    }
  }
}
