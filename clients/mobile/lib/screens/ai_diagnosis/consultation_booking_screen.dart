import 'package:flutter/material.dart';

class ConsultationBookingScreen extends StatefulWidget {
  const ConsultationBookingScreen({super.key});

  @override
  State<ConsultationBookingScreen> createState() => _ConsultationBookingScreenState();
}

class _ConsultationBookingScreenState extends State<ConsultationBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  // Booking details
  String _selectedVet = '';
  String _selectedService = '';
  String _consultationType = 'In-Person';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  
  final List<String> _availableVets = [
    'Dr. Sarah Wanjiku - Large Animals',
    'Dr. James Mwangi - Poultry',
    'Dr. Mary Achieng - Small Animals',
    'Dr. Peter Kiprotich - Dairy',
  ];
  
  final List<String> _services = [
    'General Health Checkup',
    'Vaccination',
    'Disease Diagnosis',
    'Surgery Consultation',
    'Breeding Advice',
    'Nutrition Planning',
    'Emergency Care',
  ];
  
  final List<String> _consultationTypes = [
    'In-Person',
    'Video Call',
    'Phone Call',
    'Farm Visit',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Consultation'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 48,
                      color: Color(0xFF2E7D32),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Schedule Your Consultation',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Book a consultation with our expert veterinarians',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Personal Information
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2E7D32)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2E7D32)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your location';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Consultation Details
              const Text(
                'Consultation Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              DropdownButtonFormField<String>(
                initialValue: _selectedVet.isEmpty ? null : _selectedVet,
                decoration: InputDecoration(
                  labelText: 'Select Veterinarian',
                  prefixIcon: const Icon(Icons.medical_services),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2E7D32)),
                  ),
                ),
                items: _availableVets.map((vet) {
                  return DropdownMenuItem(value: vet, child: Text(vet));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedVet = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a veterinarian';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                initialValue: _selectedService.isEmpty ? null : _selectedService,
                decoration: InputDecoration(
                  labelText: 'Service Required',
                  prefixIcon: const Icon(Icons.healing),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2E7D32)),
                  ),
                ),
                items: _services.map((service) {
                  return DropdownMenuItem(value: service, child: Text(service));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedService = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a service';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                initialValue: _consultationType,
                decoration: InputDecoration(
                  labelText: 'Consultation Type',
                  prefixIcon: const Icon(Icons.video_call),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2E7D32)),
                  ),
                ),
                items: _consultationTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _consultationType = value!;
                  });
                },
              ),
              
              const SizedBox(height: 24),
              
              // Date and Time Selection
              const Text(
                'Schedule',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Date'),
                      subtitle: Text(_selectedDate?.toString().split(' ')[0] ?? 'Select date'),
                      leading: const Icon(Icons.calendar_today),
                      onTap: () => _selectDate(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ListTile(
                      title: const Text('Time'),
                      subtitle: Text(_selectedTime?.format(context) ?? 'Select time'),
                      leading: const Icon(Icons.access_time),
                      onTap: () => _selectTime(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Describe the Issue',
                  hintText: 'Please describe the animal\'s symptoms or your concerns...',
                  prefixIcon: const Icon(Icons.description),
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
              
              // Pricing Information
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Consultation Fees',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildPriceRow('In-Person Consultation', 'KSh 2,500'),
                    _buildPriceRow('Video Call', 'KSh 1,800'),
                    _buildPriceRow('Phone Call', 'KSh 1,200'),
                    _buildPriceRow('Farm Visit', 'KSh 3,500 + Transport'),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Book Button
              ElevatedButton(
                onPressed: _bookConsultation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Book Consultation',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String service, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(service),
          Text(
            price,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _bookConsultation() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select date and time'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Veterinarian: $_selectedVet'),
              Text('Service: $_selectedService'),
              Text('Type: $_consultationType'),
              Text('Date: ${_selectedDate!.toString().split(' ')[0]}'),
              Text('Time: ${_selectedTime!.format(context)}'),
              const SizedBox(height: 8),
              const Text(
                'You will receive a confirmation SMS with payment details.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to previous screen
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Consultation booked successfully! You will receive a confirmation SMS.'),
                    backgroundColor: Color(0xFF2E7D32),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
              ),
              child: const Text('Confirm Booking'),
            ),
          ],
        ),
      );
    }
  }
}
