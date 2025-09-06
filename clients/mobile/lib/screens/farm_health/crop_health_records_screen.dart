import 'package:flutter/material.dart';

class CropHealthRecordsScreen extends StatefulWidget {
  const CropHealthRecordsScreen({super.key});

  @override
  State<CropHealthRecordsScreen> createState() => _CropHealthRecordsScreenState();
}

class _CropHealthRecordsScreenState extends State<CropHealthRecordsScreen> {
  String _selectedFilter = 'All';
  
  final List<String> _filterOptions = ['All', 'Cereals', 'Vegetables', 'Fruits', 'Legumes', 'Cash Crops'];
  
  // Sample crop health records
  final List<Map<String, dynamic>> _cropRecords = [
    {
      'id': 'C001',
      'name': 'Maize Plot A',
      'crop': 'Maize',
      'variety': 'Hybrid 614',
      'category': 'Cereals',
      'plantingDate': '2023-11-15',
      'expectedHarvest': '2024-03-15',
      'area': '2.5 acres',
      'healthScore': 89,
      'status': 'Healthy',
      'growthStage': 'Tasseling',
      'soilHealth': 85,
      'treatments': [
        {
          'date': '2024-01-10',
          'issue': 'Fall Armyworm',
          'treatment': 'Emamectin Benzoate',
          'cost': 2500,
          'effectiveness': 95,
          'notes': 'Early detection, treatment successful',
        },
        {
          'date': '2023-12-20',
          'issue': 'Nitrogen Deficiency',
          'treatment': 'Urea Fertilizer (50kg)',
          'cost': 3200,
          'effectiveness': 88,
          'notes': 'Leaves showing yellowing, applied top dressing',
        },
      ],
      'productivity': {
        'expectedYield': '3.2 tons/acre',
        'avgYield': '2.8 tons/acre',
        'trend': 'improving',
        'lastYield': '2.9 tons/acre',
      },
      'aiInsights': [
        'Yield potential 14% above regional average',
        'Optimal planting date for next season: Nov 10-20',
        'Consider resistant variety for armyworm control',
      ],
      'weatherImpact': {
        'rainfall': 'Adequate (450mm)',
        'temperature': 'Optimal range',
        'humidity': 'Moderate risk',
      },
    },
    {
      'id': 'C002',
      'name': 'Tomato Greenhouse B',
      'crop': 'Tomatoes',
      'variety': 'Roma VF',
      'category': 'Vegetables',
      'plantingDate': '2023-12-01',
      'expectedHarvest': '2024-02-15',
      'area': '0.5 acres',
      'healthScore': 76,
      'status': 'Minor Issue',
      'growthStage': 'Fruiting',
      'soilHealth': 82,
      'treatments': [
        {
          'date': '2024-01-08',
          'issue': 'Early Blight',
          'treatment': 'Copper Fungicide',
          'cost': 1800,
          'effectiveness': 78,
          'notes': 'Detected brown spots on lower leaves',
        },
        {
          'date': '2023-12-25',
          'issue': 'Aphid Infestation',
          'treatment': 'Neem Oil Spray',
          'cost': 600,
          'effectiveness': 92,
          'notes': 'Organic treatment, good results',
        },
      ],
      'productivity': {
        'expectedYield': '15 tons/acre',
        'avgYield': '12 tons/acre',
        'trend': 'stable',
        'lastYield': '14.2 tons/acre',
      },
      'aiInsights': [
        'Early blight risk high in current humidity',
        'Improve greenhouse ventilation',
        'Consider disease-resistant varieties',
      ],
      'weatherImpact': {
        'rainfall': 'Controlled (greenhouse)',
        'temperature': 'Controlled 22-28°C',
        'humidity': 'High (85%) - risk factor',
      },
    },
    {
      'id': 'C003',
      'name': 'Coffee Block C',
      'crop': 'Coffee',
      'variety': 'Arabica SL28',
      'category': 'Cash Crops',
      'plantingDate': '2020-04-15',
      'expectedHarvest': '2024-10-15',
      'area': '1.8 acres',
      'healthScore': 94,
      'status': 'Excellent',
      'growthStage': 'Flowering',
      'soilHealth': 91,
      'treatments': [
        {
          'date': '2024-01-05',
          'issue': 'Preventive Care',
          'treatment': 'Organic Mulching',
          'cost': 800,
          'effectiveness': 95,
          'notes': 'Routine soil health maintenance',
        },
      ],
      'productivity': {
        'expectedYield': '1.2 tons/acre',
        'avgYield': '0.9 tons/acre',
        'trend': 'improving',
        'lastYield': '1.1 tons/acre',
      },
      'aiInsights': [
        'Excellent soil health supporting high yield',
        'Optimal altitude and climate conditions',
        'Premium quality potential - target specialty market',
      ],
      'weatherImpact': {
        'rainfall': 'Ideal (1200mm annually)',
        'temperature': 'Perfect (18-24°C)',
        'humidity': 'Optimal (60-70%)',
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.agriculture, color: Colors.white),
            SizedBox(width: 8),
            Text('Crop Health Records'),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddCropDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filterOptions.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      backgroundColor: Colors.grey[200],
                      selectedColor: const Color(0xFF2E7D32).withOpacity(0.2),
                      checkmarkColor: const Color(0xFF2E7D32),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // Crops List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _getFilteredCrops().length,
              itemBuilder: (context, index) {
                final crop = _getFilteredCrops()[index];
                return _buildCropCard(crop);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "crop_records_fab",
        onPressed: () => _showAddRecordDialog(),
        backgroundColor: const Color(0xFF2E7D32),
        icon: const Icon(Icons.add),
        label: const Text('Add Record'),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredCrops() {
    if (_selectedFilter == 'All') {
      return _cropRecords;
    }
    return _cropRecords.where((crop) => crop['category'] == _selectedFilter).toList();
  }

  Widget _buildCropCard(Map<String, dynamic> crop) {
    Color statusColor;
    switch (crop['status']) {
      case 'Excellent':
        statusColor = Colors.green[700]!;
        break;
      case 'Healthy':
        statusColor = Colors.green;
        break;
      case 'Minor Issue':
        statusColor = Colors.orange;
        break;
      case 'Critical':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.agriculture,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            crop['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              crop['status'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${crop['crop']} • ${crop['variety']} • ${crop['area']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        'Stage: ${crop['growthStage']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Health Score',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '${crop['healthScore']}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem('Soil Health', '${crop['soilHealth']}%', Icons.grass),
                    ),
                    Expanded(
                      child: _buildDetailItem('Expected Harvest', crop['expectedHarvest'], Icons.calendar_today),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showCropDetails(crop),
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text('View Details'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _addCropRecord(crop),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add Record'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF2E7D32),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showCropDetails(Map<String, dynamic> crop) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CropDetailScreen(crop: crop),
      ),
    );
  }

  void _addCropRecord(Map<String, dynamic> crop) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Record for ${crop['name']}'),
        content: const Text('This will open the crop record form.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to add crop record form
            },
            child: const Text('Add Record'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Crops'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Enter crop name or plot ID...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showAddCropDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Crop'),
        content: const Text('This will open the crop registration form.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to add crop form
            },
            child: const Text('Add Crop'),
          ),
        ],
      ),
    );
  }

  void _showAddRecordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Crop Record'),
        content: const Text('Choose a crop to add a health record for.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Show crop selection
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}

// Crop Detail Screen
class CropDetailScreen extends StatelessWidget {
  final Map<String, dynamic> crop;

  const CropDetailScreen({super.key, required this.crop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(crop['name']),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Crop Detail Screen - Coming Soon'),
      ),
    );
  }
}
