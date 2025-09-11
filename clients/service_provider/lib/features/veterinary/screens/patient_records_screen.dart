import 'package:flutter/material.dart';
import '../models/veterinary_models.dart';

class PatientRecordsScreen extends StatefulWidget {
  const PatientRecordsScreen({super.key});

  @override
  State<PatientRecordsScreen> createState() => _PatientRecordsScreenState();
}

class _PatientRecordsScreenState extends State<PatientRecordsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock data
  final List<PatientRecord> _patientRecords = [
    PatientRecord(
      id: '1',
      farmerId: 'farmer1',
      farmerName: 'John Kamau',
      animalId: 'animal1',
      animalName: 'Bessie',
      animalType: 'Cattle',
      breed: 'Friesian',
      gender: 'Female',
      dateOfBirth: DateTime(2020, 3, 15),
      weight: 450.0,
      color: 'Black and White',
      medicalHistory: [],
      vaccinations: [],
      treatments: [],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    PatientRecord(
      id: '2',
      farmerId: 'farmer2',
      farmerName: 'Mary Wanjiku',
      animalId: 'animal2',
      animalName: 'Billy',
      animalType: 'Goat',
      breed: 'Boer',
      gender: 'Male',
      dateOfBirth: DateTime(2021, 8, 20),
      weight: 35.0,
      color: 'Brown and White',
      medicalHistory: [],
      vaccinations: [],
      treatments: [],
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredRecords = _patientRecords.where((record) {
      return record.animalName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             record.farmerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             record.animalType.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Patient Records'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: const Color(0xFF1976D2),
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by animal name, farmer, or type...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // Records List
          Expanded(
            child: filteredRecords.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredRecords.length,
                    itemBuilder: (context, index) {
                      final record = filteredRecords[index];
                      return _buildPatientCard(record);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPatientDialog,
        backgroundColor: const Color(0xFF1976D2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_shared,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? 'No patient records found' : 'No matching records',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty 
                ? 'Patient records will appear here when added'
                : 'Try adjusting your search terms',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(PatientRecord record) {
    final age = DateTime.now().difference(record.dateOfBirth).inDays ~/ 365;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showPatientDetails(record),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.animalName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${record.animalType} • ${record.breed}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1976D2).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getAnimalIcon(record.animalType),
                      color: const Color(0xFF1976D2),
                      size: 24,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.person,
                      label: 'Owner',
                      value: record.farmerName,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.cake,
                      label: 'Age',
                      value: '$age years',
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.scale,
                      label: 'Weight',
                      value: record.weight != null ? '${record.weight} kg' : 'Not recorded',
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.palette,
                      label: 'Color',
                      value: record.color ?? 'Not specified',
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _buildStatChip(
                        icon: Icons.medical_services,
                        count: record.medicalHistory.length,
                        label: 'Treatments',
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      _buildStatChip(
                        icon: Icons.vaccines,
                        count: record.vaccinations.length,
                        label: 'Vaccines',
                        color: Colors.green,
                      ),
                    ],
                  ),
                  Text(
                    'Last updated: ${_formatDate(record.updatedAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
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

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required int count,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getAnimalIcon(String animalType) {
    switch (animalType.toLowerCase()) {
      case 'cattle':
        return Icons.agriculture;
      case 'goat':
      case 'sheep':
        return Icons.pets;
      case 'poultry':
      case 'chicken':
        return Icons.egg_alt;
      case 'pig':
        return Icons.pets;
      default:
        return Icons.pets;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showPatientDetails(PatientRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${record.animalName} - Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Owner: ${record.farmerName}'),
              Text('Type: ${record.animalType}'),
              Text('Breed: ${record.breed}'),
              Text('Gender: ${record.gender}'),
              Text('Weight: ${record.weight ?? 'Not recorded'} kg'),
              Text('Color: ${record.color ?? 'Not specified'}'),
              const SizedBox(height: 16),
              const Text(
                'Medical History:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('${record.medicalHistory.length} treatments recorded'),
              const SizedBox(height: 8),
              const Text(
                'Vaccinations:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('${record.vaccinations.length} vaccines administered'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showEditPatientDialog(record);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _showAddPatientDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Patient'),
        content: const Text('Add new patient feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showEditPatientDialog(PatientRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${record.animalName}'),
        content: const Text('Edit patient feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
