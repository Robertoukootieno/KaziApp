import 'package:flutter/material.dart';

class VetsScreen extends StatefulWidget {
  const VetsScreen({super.key});

  @override
  State<VetsScreen> createState() => _VetsScreenState();
}

class _VetsScreenState extends State<VetsScreen> {
  String _currentLocation = 'Nakuru, Kenya';
  String _requestStatus = 'idle'; // idle, selecting_animal, searching, vet_found, in_progress
  String? _selectedAnimal;
  Map<String, dynamic>? _selectedVet;

  // Animal types for issue selection
  final List<Map<String, dynamic>> _animalTypes = [
    {'name': 'Cattle', 'icon': Icons.agriculture, 'color': Colors.brown},
    {'name': 'Goats', 'icon': Icons.pets, 'color': Colors.orange},
    {'name': 'Sheep', 'icon': Icons.pets, 'color': Colors.grey},
    {'name': 'Poultry', 'icon': Icons.egg, 'color': Colors.yellow},
    {'name': 'Pigs', 'icon': Icons.pets, 'color': Colors.pink},
    {'name': 'Crops', 'icon': Icons.grass, 'color': Colors.green},
  ];

  // Nearby vets (simulated)
  final List<Map<String, dynamic>> _nearbyVets = [
    {
      'id': 'vet_001',
      'name': 'Dr. Sarah Wanjiku',
      'specialty': 'Livestock & Dairy',
      'rating': 4.8,
      'experience': '8 years',
      'eta': '12 min',
      'distance': '2.3 km',
      'price': 1500,
      'isAvailable': true,
    },
    {
      'id': 'vet_002', 
      'name': 'Dr. James Ochieng',
      'specialty': 'Poultry & Small Animals',
      'rating': 4.9,
      'experience': '12 years',
      'eta': '8 min',
      'distance': '1.8 km',
      'price': 1800,
      'isAvailable': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map Background (Simulated)
          _buildMapView(),
          
          // Top App Bar
          _buildTopAppBar(),
          
          // Main Content Based on Status
          if (_requestStatus == 'idle') ...[
            _buildFindVetButton(),
            _buildQuickActions(),
          ] else if (_requestStatus == 'selecting_animal') ...[
            _buildAnimalSelectionSheet(),
          ] else if (_requestStatus == 'searching') ...[
            _buildSearchingSheet(),
          ] else if (_requestStatus == 'vet_found') ...[
            _buildVetFoundSheet(),
          ],
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE8F5E8), Color(0xFFF1F8E9)],
        ),
      ),
      child: Stack(
        children: [
          // User location marker
          Positioned(
            left: MediaQuery.of(context).size.width * 0.5 - 15,
            top: MediaQuery.of(context).size.height * 0.5 - 15,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ),
          
          // Vet markers
          Positioned(
            left: MediaQuery.of(context).size.width * 0.3,
            top: MediaQuery.of(context).size.height * 0.3,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.medical_services, color: Colors.white, size: 20),
            ),
          ),
          
          Positioned(
            left: MediaQuery.of(context).size.width * 0.7,
            top: MediaQuery.of(context).size.height * 0.4,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.medical_services, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.arrow_back, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Find Veterinarian',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _currentLocation,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.menu, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFindVetButton() {
    return Positioned(
      bottom: 120,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.medical_services,
                    color: Color(0xFF2E7D32),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Need a Veterinarian?',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Get expert help for your animals and crops',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _requestStatus = 'selecting_animal';
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text(
                'Find Vet Now',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Positioned(
      bottom: 20,
      left: 16,
      right: 16,
      child: Row(
        children: [
          Expanded(
            child: _buildQuickActionCard(
              'Emergency',
              Icons.emergency,
              Colors.red,
              () => _showEmergencyDialog(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickActionCard(
              'USSD *123#',
              Icons.phone,
              Colors.orange,
              () => _showUSSDDialog(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickActionCard(
              'AI Diagnosis',
              Icons.camera_alt,
              Colors.blue,
              () => Navigator.pushNamed(context, '/ai_diagnosis'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimalSelectionSheet() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'What animal needs help?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: _animalTypes.length,
              itemBuilder: (context, index) {
                final animal = _animalTypes[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAnimal = animal['name'];
                      _requestStatus = 'searching';
                    });
                    _searchForVets();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: (animal['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: (animal['color'] as Color).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          animal['icon'] as IconData,
                          size: 32,
                          color: animal['color'] as Color,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          animal['name'] as String,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _requestStatus = 'idle';
                });
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchingSheet() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
            ),
            const SizedBox(height: 20),
            Text(
              'Finding vets for $_selectedAnimal...',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'We\'re matching you with the best available veterinarians in your area',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _requestStatus = 'idle';
                });
              },
              child: const Text('Cancel Search'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVetFoundSheet() {
    if (_selectedVet == null) return const SizedBox.shrink();

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF2E7D32),
                  child: Text(
                    _selectedVet!['name'].toString().split(' ').map((n) => n[0]).take(2).join(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedVet!['name'],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _selectedVet!['specialty'],
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${_selectedVet!['rating']} • ${_selectedVet!['experience']}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'ETA: ${_selectedVet!['eta']}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    Text(
                      'KSh ${_selectedVet!['price']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _requestStatus = 'searching';
                      });
                      _searchForVets();
                    },
                    child: const Text('Find Another'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      _bookVet();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Book Now'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  void _searchForVets() async {
    await Future.delayed(const Duration(seconds: 2));

    // Find best available vet
    final availableVets = _nearbyVets.where((vet) => vet['isAvailable'] == true).toList();
    if (availableVets.isNotEmpty) {
      setState(() {
        _selectedVet = availableVets.first;
        _requestStatus = 'vet_found';
      });
    }
  }

  void _bookVet() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking ${_selectedVet!['name']}...'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Veterinary Care'),
        content: const Text(
          '24/7 Emergency Hotline:\n+254 700 123 456\n\nFor immediate assistance with critical animal health issues.',
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
          'Dial *123*3# from any phone to:\n\n• Find nearby vets\n• Book consultations\n• Get emergency help\n• Check consultation history\n\nWorks on any phone, even without internet!',
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
}
