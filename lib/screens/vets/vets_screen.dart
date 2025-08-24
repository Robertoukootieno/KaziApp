import 'package:flutter/material.dart';

class VetsScreen extends StatefulWidget {
  const VetsScreen({super.key});

  @override
  State<VetsScreen> createState() => _VetsScreenState();
}

class _VetsScreenState extends State<VetsScreen> {
  String _selectedSpecialty = 'All';
  String _selectedLocation = 'All';
  bool _isOnlineOnly = false;

  final List<String> _specialties = [
    'All',
    'Livestock',
    'Poultry',
    'Dairy Cattle',
    'Small Animals',
    'Large Animals',
    'Crop Diseases',
  ];

  final List<String> _locations = [
    'All',
    'Nairobi',
    'Mombasa',
    'Kisumu',
    'Nakuru',
    'Eldoret',
    'Thika',
  ];

  final List<Map<String, dynamic>> _vets = [
    {
      'name': 'Dr. Sarah Wanjiku',
      'specialty': 'Livestock & Dairy',
      'location': 'Nairobi',
      'rating': 4.8,
      'experience': '8 years',
      'price': 'KSh 1,500',
      'isOnline': true,
      'image': 'assets/images/vet1.jpg',
      'languages': ['English', 'Kiswahili', 'Kikuyu'],
    },
    {
      'name': 'Dr. James Ochieng',
      'specialty': 'Poultry & Small Animals',
      'location': 'Kisumu',
      'rating': 4.9,
      'experience': '12 years',
      'price': 'KSh 1,200',
      'isOnline': true,
      'image': 'assets/images/vet2.jpg',
      'languages': ['English', 'Kiswahili', 'Luo'],
    },
    {
      'name': 'Dr. Mary Chebet',
      'specialty': 'Crop Diseases',
      'location': 'Eldoret',
      'rating': 4.7,
      'experience': '6 years',
      'price': 'KSh 1,000',
      'isOnline': false,
      'image': 'assets/images/vet3.jpg',
      'languages': ['English', 'Kiswahili', 'Kalenjin'],
    },
    {
      'name': 'Dr. Peter Mwangi',
      'specialty': 'Large Animals',
      'location': 'Nakuru',
      'rating': 4.6,
      'experience': '10 years',
      'price': 'KSh 1,800',
      'isOnline': true,
      'image': 'assets/images/vet4.jpg',
      'languages': ['English', 'Kiswahili'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Veterinarians'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedSpecialty,
                        decoration: InputDecoration(
                          labelText: 'Specialty',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: _specialties.map((String specialty) {
                          return DropdownMenuItem<String>(
                            value: specialty,
                            child: Text(specialty),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedSpecialty = newValue!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedLocation,
                        decoration: InputDecoration(
                          labelText: 'Location',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: _locations.map((String location) {
                          return DropdownMenuItem<String>(
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedLocation = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Checkbox(
                      value: _isOnlineOnly,
                      onChanged: (bool? value) {
                        setState(() {
                          _isOnlineOnly = value!;
                        });
                      },
                      activeColor: const Color(0xFF2E7D32),
                    ),
                    const Text('Online consultation only'),
                  ],
                ),
              ],
            ),
          ),
          
          // Emergency Banner
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.emergency, color: Colors.red, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Emergency?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const Text(
                        'Call our 24/7 emergency hotline',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showEmergencyDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Call Now'),
                ),
              ],
            ),
          ),
          
          // Vets List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _getFilteredVets().length,
              itemBuilder: (context, index) {
                final vet = _getFilteredVets()[index];
                return _buildVetCard(vet);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showUSSDDialog();
        },
        backgroundColor: Colors.orange,
        icon: const Icon(Icons.phone),
        label: const Text('USSD *123#'),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredVets() {
    return _vets.where((vet) {
      bool matchesSpecialty = _selectedSpecialty == 'All' || 
          vet['specialty'].toString().contains(_selectedSpecialty);
      bool matchesLocation = _selectedLocation == 'All' || 
          vet['location'] == _selectedLocation;
      bool matchesOnline = !_isOnlineOnly || vet['isOnline'] == true;
      
      return matchesSpecialty && matchesLocation && matchesOnline;
    }).toList();
  }

  Widget _buildVetCard(Map<String, dynamic> vet) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF2E7D32),
                  child: Text(
                    vet['name'].toString().split(' ').map((n) => n[0]).join(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vet['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        vet['specialty'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            vet['location'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                          if (vet['isOnline'])
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Online',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          vet['rating'].toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      vet['experience'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Languages
            Wrap(
              spacing: 8,
              children: (vet['languages'] as List<String>).map((language) {
                return Chip(
                  label: Text(
                    language,
                    style: const TextStyle(fontSize: 10),
                  ),
                  backgroundColor: const Color(0xFF2E7D32).withOpacity(0.1),
                  side: BorderSide.none,
                );
              }).toList(),
            ),
            
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showVetDetails(vet);
                    },
                    icon: const Icon(Icons.info_outline),
                    label: const Text('Details'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2E7D32),
                      side: const BorderSide(color: Color(0xFF2E7D32)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _bookConsultation(vet);
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: Text('Book ${vet['price']}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
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

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Veterinarians'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Enter vet name or specialty...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Veterinary Care'),
        content: const Text(
          '24/7 Emergency Hotline:\n+254 700 123 456\n\nFor immediate assistance with:\n• Animal emergencies\n• Poisoning cases\n• Severe injuries\n• Critical conditions',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Simulate phone call
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Calling emergency hotline...'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Call Now'),
          ),
        ],
      ),
    );
  }

  void _showUSSDDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('USSD Vet Services'),
        content: const Text(
          'Dial *123# from any phone to:\n\n• Find nearby vets\n• Get emergency contacts\n• Check vet availability\n• Book consultations\n\nWorks without internet!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showVetDetails(Map<String, dynamic> vet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                vet['name'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                vet['specialty'],
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'About',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Experienced veterinarian with ${vet['experience']} of practice. Specializes in ${vet['specialty'].toLowerCase()} with a focus on preventive care and treatment.',
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _bookConsultation(vet);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                      ),
                      child: const Text('Book Consultation'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _bookConsultation(Map<String, dynamic> vet) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Book with ${vet['name']}'),
        content: Text(
          'Consultation fee: ${vet['price']}\n\nChoose your preferred time and payment method.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Booking confirmed with ${vet['name']}!'),
                  backgroundColor: const Color(0xFF2E7D32),
                ),
              );
            },
            child: const Text('Confirm Booking'),
          ),
        ],
      ),
    );
  }
}
