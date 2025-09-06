import 'package:flutter/material.dart';

class VetSearchScreen extends StatefulWidget {
  const VetSearchScreen({super.key});

  @override
  State<VetSearchScreen> createState() => _VetSearchScreenState();
}

class _VetSearchScreenState extends State<VetSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSpecialty = 'All';
  String _selectedLocation = 'All';
  
  final List<String> _specialties = [
    'All', 'Large Animals', 'Small Animals', 'Poultry', 'Dairy', 'Swine', 'Equine'
  ];
  
  final List<String> _locations = [
    'All', 'Nairobi', 'Nakuru', 'Eldoret', 'Mombasa', 'Kisumu', 'Thika'
  ];

  final List<VetProfile> _vets = [
    VetProfile(
      id: '1',
      name: 'Dr. Sarah Wanjiku',
      specialty: 'Large Animals',
      location: 'Nakuru',
      rating: 4.8,
      experience: '8 years',
      phone: '+254 712 345 678',
      email: 'sarah.wanjiku@vetcare.com',
      image: 'assets/images/vet_sarah.jpg',
      description: 'Specialized in cattle and goat health with extensive experience in dairy farming.',
      services: ['Health Checkups', 'Vaccinations', 'Surgery', 'Emergency Care'],
      availability: 'Available',
      consultationFee: 2500,
    ),
    VetProfile(
      id: '2',
      name: 'Dr. James Mwangi',
      specialty: 'Poultry',
      location: 'Eldoret',
      rating: 4.9,
      experience: '12 years',
      phone: '+254 723 456 789',
      email: 'james.mwangi@poultryvet.com',
      image: 'assets/images/vet_james.jpg',
      description: 'Expert in poultry diseases and commercial chicken farming health management.',
      services: ['Disease Diagnosis', 'Vaccination Programs', 'Nutrition Advice', 'Farm Visits'],
      availability: 'Available',
      consultationFee: 2000,
    ),
    VetProfile(
      id: '3',
      name: 'Dr. Mary Achieng',
      specialty: 'Small Animals',
      location: 'Nairobi',
      rating: 4.7,
      experience: '6 years',
      phone: '+254 734 567 890',
      email: 'mary.achieng@smallvet.com',
      image: 'assets/images/vet_mary.jpg',
      description: 'Focuses on small livestock including goats, sheep, and rabbits.',
      services: ['General Medicine', 'Surgery', 'Reproductive Health', 'Nutrition'],
      availability: 'Busy',
      consultationFee: 1800,
    ),
    VetProfile(
      id: '4',
      name: 'Dr. Peter Kiprotich',
      specialty: 'Dairy',
      location: 'Nakuru',
      rating: 4.6,
      experience: '10 years',
      phone: '+254 745 678 901',
      email: 'peter.kiprotich@dairyvet.com',
      image: 'assets/images/vet_peter.jpg',
      description: 'Dairy specialist with focus on milk production optimization and udder health.',
      services: ['Mastitis Treatment', 'Breeding Advice', 'Nutrition Planning', 'Herd Health'],
      availability: 'Available',
      consultationFee: 3000,
    ),
  ];

  List<VetProfile> get _filteredVets {
    return _vets.where((vet) {
      final matchesSearch = _searchController.text.isEmpty ||
          vet.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          vet.specialty.toLowerCase().contains(_searchController.text.toLowerCase());
      
      final matchesSpecialty = _selectedSpecialty == 'All' || vet.specialty == _selectedSpecialty;
      final matchesLocation = _selectedLocation == 'All' || vet.location == _selectedLocation;
      
      return matchesSearch && matchesSpecialty && matchesLocation;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Veterinarian'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search and Filters
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name or specialty...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF2E7D32)),
                    ),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                
                const SizedBox(height: 12),
                
                // Filters
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedSpecialty,
                        decoration: const InputDecoration(
                          labelText: 'Specialty',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: _specialties.map((specialty) {
                          return DropdownMenuItem(value: specialty, child: Text(specialty));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSpecialty = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedLocation,
                        decoration: const InputDecoration(
                          labelText: 'Location',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: _locations.map((location) {
                          return DropdownMenuItem(value: location, child: Text(location));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedLocation = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Results
          Expanded(
            child: _filteredVets.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No veterinarians found',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text('Try adjusting your search criteria'),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredVets.length,
                    itemBuilder: (context, index) {
                      final vet = _filteredVets[index];
                      return _buildVetCard(vet);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildVetCard(VetProfile vet) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
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
                    vet.name.split(' ').map((n) => n[0]).join(),
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
                        vet.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        vet.specialty,
                        style: const TextStyle(
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.grey),
                          Text(vet.location, style: const TextStyle(color: Colors.grey)),
                          const SizedBox(width: 16),
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          Text('${vet.rating}'),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: vet.availability == 'Available' ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    vet.availability,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Text(
              vet.description,
              style: const TextStyle(fontSize: 14),
            ),
            
            const SizedBox(height: 12),
            
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: vet.services.map((service) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  service,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )).toList(),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Text(
                  'Consultation: KSh ${vet.consultationFee}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _makeCall(vet),
                      icon: const Icon(Icons.phone, color: Color(0xFF2E7D32)),
                      tooltip: 'Audio Call',
                    ),
                    IconButton(
                      onPressed: () => _startChat(vet),
                      icon: const Icon(Icons.chat, color: Color(0xFF2E7D32)),
                      tooltip: 'Chat',
                    ),
                    IconButton(
                      onPressed: () => _startVideoCall(vet),
                      icon: const Icon(Icons.video_call, color: Color(0xFF2E7D32)),
                      tooltip: 'Video Call',
                    ),
                    ElevatedButton(
                      onPressed: () => _bookConsultation(vet),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Book'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _makeCall(VetProfile vet) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Audio Call'),
        content: Text('Call ${vet.name} at ${vet.phone}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling ${vet.name}...')),
              );
            },
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }

  void _startChat(VetProfile vet) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Chat'),
        content: Text('Start a chat conversation with ${vet.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Starting chat with ${vet.name}...')),
              );
            },
            child: const Text('Start Chat'),
          ),
        ],
      ),
    );
  }

  void _startVideoCall(VetProfile vet) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Video Call'),
        content: Text('Start a video call with ${vet.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Starting video call with ${vet.name}...')),
              );
            },
            child: const Text('Start Call'),
          ),
        ],
      ),
    );
  }

  void _bookConsultation(VetProfile vet) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Book Consultation'),
        content: Text('Book a consultation with ${vet.name}?\n\nFee: KSh ${vet.consultationFee}'),
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
                  content: Text('Booking consultation with ${vet.name}...'),
                  backgroundColor: const Color(0xFF2E7D32),
                ),
              );
            },
            child: const Text('Book Now'),
          ),
        ],
      ),
    );
  }
}

class VetProfile {
  final String id;
  final String name;
  final String specialty;
  final String location;
  final double rating;
  final String experience;
  final String phone;
  final String email;
  final String image;
  final String description;
  final List<String> services;
  final String availability;
  final int consultationFee;

  VetProfile({
    required this.id,
    required this.name,
    required this.specialty,
    required this.location,
    required this.rating,
    required this.experience,
    required this.phone,
    required this.email,
    required this.image,
    required this.description,
    required this.services,
    required this.availability,
    required this.consultationFee,
  });
}
