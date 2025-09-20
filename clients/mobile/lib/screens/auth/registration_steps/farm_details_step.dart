import 'package:flutter/material.dart';
import '../../../widgets/farmer_graphics.dart';

class FarmDetailsStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Function(Map<String, dynamic>) onDataChanged;
  final Map<String, dynamic> initialData;

  const FarmDetailsStep({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.onDataChanged,
    required this.initialData,
  });

  @override
  State<FarmDetailsStep> createState() => _FarmDetailsStepState();
}

class _FarmDetailsStepState extends State<FarmDetailsStep> 
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _farmNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _farmSizeController = TextEditingController();
  
  String _selectedFarmType = 'Mixed Farming';
  String _selectedExperience = '1-3 years';
  
  final List<String> _farmTypes = [
    'Mixed Farming',
    'Crop Farming',
    'Livestock Farming',
    'Poultry Farming',
    'Dairy Farming',
    'Horticulture',
    'Aquaculture',
  ];
  
  final List<String> _experienceLevels = [
    'Less than 1 year',
    '1-3 years',
    '3-5 years',
    '5-10 years',
    'More than 10 years',
  ];

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeAnimations();
  }

  void _initializeControllers() {
    _farmNameController.text = widget.initialData['farmName'] ?? '';
    _locationController.text = widget.initialData['location'] ?? '';
    _farmSizeController.text = widget.initialData['farmSize'] ?? '';
    _selectedFarmType = widget.initialData['farmType'] ?? 'Mixed Farming';
    _selectedExperience = widget.initialData['experience'] ?? '1-3 years';
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _slideController.forward();
  }

  @override
  void dispose() {
    _farmNameController.dispose();
    _locationController.dispose();
    _farmSizeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_formKey.currentState!.validate()) {
      // Update registration data
      widget.onDataChanged({
        'farmName': _farmNameController.text.trim(),
        'location': _locationController.text.trim(),
        'farmSize': _farmSizeController.text.trim(),
        'farmType': _selectedFarmType,
        'experience': _selectedExperience,
      });
      
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Farm scene illustration
            Container(
              width: 200,
              height: 120,
              margin: const EdgeInsets.only(bottom: 32),
              child: FarmerGraphics.farmScene(
                width: 200,
                height: 120,
              ),
            ),
            
            // Form card
            _buildFormCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Card(
      elevation: 20,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey[50]!,
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              const Text(
                'Tell us about your farm',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E7D32),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'This helps us provide relevant agricultural advice',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              // Farm Name field
              _buildTextField(
                controller: _farmNameController,
                label: 'Farm Name (Optional)',
                hint: 'Enter your farm name',
                icon: Icons.agriculture,
              ),
              
              const SizedBox(height: 20),
              
              // Location field
              _buildTextField(
                controller: _locationController,
                label: 'Location',
                hint: 'Enter your farm location',
                icon: Icons.location_on_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your farm location';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Farm Size field
              _buildTextField(
                controller: _farmSizeController,
                label: 'Farm Size',
                hint: 'e.g., 2 acres, 5 hectares',
                icon: Icons.straighten,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your farm size';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Farm Type dropdown
              _buildDropdownField(
                label: 'Farm Type',
                value: _selectedFarmType,
                items: _farmTypes,
                onChanged: (value) {
                  setState(() {
                    _selectedFarmType = value!;
                  });
                },
                icon: Icons.category_outlined,
              ),
              
              const SizedBox(height: 20),
              
              // Experience dropdown
              _buildDropdownField(
                label: 'Farming Experience',
                value: _selectedExperience,
                items: _experienceLevels,
                onChanged: (value) {
                  setState(() {
                    _selectedExperience = value!;
                  });
                },
                icon: Icons.timeline,
              ),
              
              const SizedBox(height: 32),
              
              // Navigation buttons
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF2E7D32)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: validator,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF2E7D32)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: OutlinedButton(
              onPressed: widget.onPrevious,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF2E7D32)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Back',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _continue,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                shadowColor: const Color(0xFF2E7D32).withValues(alpha: 0.3),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
