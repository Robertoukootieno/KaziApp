import 'package:flutter/material.dart';
import 'machinery_services_screen.dart';

class MachineryBookingScreen extends StatefulWidget {
  final MachineryItem machinery;

  const MachineryBookingScreen({super.key, required this.machinery});

  @override
  State<MachineryBookingScreen> createState() => _MachineryBookingScreenState();
}

class _MachineryBookingScreenState extends State<MachineryBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Booking details
  String _selectedServiceType = '';
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _duration = 'daily';
  final int _quantity = 1;
  bool _needsDriver = false;
  bool _needsTransport = false;
  bool _needsInsurance = true;
  
  // Contact details
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  
  // Pricing
  double _basePrice = 0;
  double _driverFee = 0;
  double _transportFee = 0;
  double _insuranceFee = 0;
  double _totalPrice = 0;

  @override
  void initState() {
    super.initState();
    _selectedServiceType = widget.machinery.availableServices.first;
    _calculatePricing();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _calculatePricing() {
    setState(() {
      // Base pricing
      switch (_duration) {
        case 'hourly':
          _basePrice = widget.machinery.hourlyRate.toDouble() * _quantity;
          break;
        case 'daily':
          _basePrice = widget.machinery.dailyRate.toDouble() * _quantity;
          break;
        case 'monthly':
          _basePrice = widget.machinery.monthlyRate.toDouble() * _quantity;
          break;
      }
      
      // Additional fees
      _driverFee = _needsDriver ? (_basePrice * 0.3) : 0; // 30% of base price
      _transportFee = _needsTransport ? 5000 : 0; // Fixed transport fee
      _insuranceFee = _needsInsurance ? (_basePrice * 0.05) : 0; // 5% insurance
      
      _totalPrice = _basePrice + _driverFee + _transportFee + _insuranceFee;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Machinery'),
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
              // Machinery Summary
              _buildMachinerySummary(),
              
              const SizedBox(height: 24),
              
              // Service Type Selection
              _buildServiceTypeSelection(),
              
              const SizedBox(height: 24),
              
              // Duration and Dates
              _buildDurationSelection(),
              
              const SizedBox(height: 24),
              
              // Additional Services
              _buildAdditionalServices(),
              
              const SizedBox(height: 24),
              
              // Contact Information
              _buildContactInformation(),
              
              const SizedBox(height: 24),
              
              // Pricing Summary
              _buildPricingSummary(),
              
              const SizedBox(height: 24),
              
              // Book Button
              ElevatedButton(
                onPressed: _submitBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Confirm Booking - KSh ${_totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMachinerySummary() {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.agriculture, size: 40, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.machinery.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.machinery.category,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    Text(
                      widget.machinery.location,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const Spacer(),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text('${widget.machinery.rating}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTypeSelection() {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Service Type',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...widget.machinery.availableServices.map((service) {
            return RadioListTile<String>(
              title: Text(service),
              subtitle: Text(_getServiceDescription(service)),
              value: service,
              groupValue: _selectedServiceType,
              onChanged: (value) {
                setState(() {
                  _selectedServiceType = value!;
                  _needsDriver = service == 'Book with Driver';
                  _calculatePricing();
                });
              },
              activeColor: const Color(0xFF2E7D32),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDurationSelection() {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Duration & Schedule',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          // Duration Type
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Hourly'),
                  value: 'hourly',
                  groupValue: _duration,
                  onChanged: widget.machinery.hourlyRate > 0 ? (value) {
                    setState(() {
                      _duration = value!;
                      _calculatePricing();
                    });
                  } : null,
                  activeColor: const Color(0xFF2E7D32),
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Daily'),
                  value: 'daily',
                  groupValue: _duration,
                  onChanged: (value) {
                    setState(() {
                      _duration = value!;
                      _calculatePricing();
                    });
                  },
                  activeColor: const Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          
          RadioListTile<String>(
            title: const Text('Monthly (Lease)'),
            value: 'monthly',
            groupValue: _duration,
            onChanged: (value) {
              setState(() {
                _duration = value!;
                _calculatePricing();
              });
            },
            activeColor: const Color(0xFF2E7D32),
          ),
          
          const SizedBox(height: 16),
          
          // Date Selection
          Row(
            children: [
              Expanded(
                child: ListTile(
                  title: const Text('Start Date'),
                  subtitle: Text(_startDate?.toString().split(' ')[0] ?? 'Select date'),
                  leading: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context, true),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: const Text('End Date'),
                  subtitle: Text(_endDate?.toString().split(' ')[0] ?? 'Select date'),
                  leading: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context, false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalServices() {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Additional Services',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          CheckboxListTile(
            title: const Text('Driver & Operator'),
            subtitle: const Text('Professional operator included (+30% of base price)'),
            value: _needsDriver,
            onChanged: _selectedServiceType != 'Book with Driver' ? (value) {
              setState(() {
                _needsDriver = value!;
                _calculatePricing();
              });
            } : null,
            activeColor: const Color(0xFF2E7D32),
          ),
          
          CheckboxListTile(
            title: const Text('Transport to Farm'),
            subtitle: const Text('Delivery and pickup service (+KSh 5,000)'),
            value: _needsTransport,
            onChanged: (value) {
              setState(() {
                _needsTransport = value!;
                _calculatePricing();
              });
            },
            activeColor: const Color(0xFF2E7D32),
          ),
          
          CheckboxListTile(
            title: const Text('Insurance Coverage'),
            subtitle: const Text('Comprehensive insurance (+5% of base price)'),
            value: _needsInsurance,
            onChanged: (value) {
              setState(() {
                _needsInsurance = value!;
                _calculatePricing();
              });
            },
            activeColor: const Color(0xFF2E7D32),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInformation() {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 12),
          
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
              prefixText: '+254 ',
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 12),
          
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Farm Location',
              border: OutlineInputBorder(),
              hintText: 'Detailed address for delivery',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your farm location';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 12),
          
          TextFormField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Special Instructions (Optional)',
              border: OutlineInputBorder(),
              hintText: 'Any special requirements or notes',
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSummary() {
    return Container(
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
            'Pricing Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          _buildPriceRow('Base Price ($_duration)', _basePrice),
          if (_driverFee > 0) _buildPriceRow('Driver & Operator', _driverFee),
          if (_transportFee > 0) _buildPriceRow('Transport', _transportFee),
          if (_insuranceFee > 0) _buildPriceRow('Insurance', _insuranceFee),
          
          const Divider(),
          
          _buildPriceRow('Total', _totalPrice, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            'KSh ${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? const Color(0xFF2E7D32) : null,
            ),
          ),
        ],
      ),
    );
  }

  String _getServiceDescription(String service) {
    switch (service) {
      case 'Rent':
        return 'Short-term rental with flexible duration';
      case 'Lease':
        return 'Long-term lease for extended use';
      case 'Book with Driver':
        return 'Includes professional operator';
      case 'Self-Operate':
        return 'You operate the machinery yourself';
      default:
        return '';
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select start and end dates')),
        );
        return;
      }
      
      // TODO: Submit booking to backend
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Booking Confirmed!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Machinery: ${widget.machinery.name}'),
              Text('Service: $_selectedServiceType'),
              Text('Duration: $_duration'),
              Text('Total: KSh ${_totalPrice.toStringAsFixed(0)}'),
              const SizedBox(height: 8),
              const Text('You will receive a confirmation SMS shortly.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to machinery list
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
