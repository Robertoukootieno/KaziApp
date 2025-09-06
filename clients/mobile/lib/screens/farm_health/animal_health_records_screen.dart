import 'package:flutter/material.dart';

class AnimalHealthRecordsScreen extends StatefulWidget {
  const AnimalHealthRecordsScreen({super.key});

  @override
  State<AnimalHealthRecordsScreen> createState() => _AnimalHealthRecordsScreenState();
}

class _AnimalHealthRecordsScreenState extends State<AnimalHealthRecordsScreen> {
  String _selectedFilter = 'All';
  
  final List<String> _filterOptions = ['All', 'Cattle', 'Goats', 'Sheep', 'Poultry', 'Pigs'];
  
  // Sample animal health records
  final List<Map<String, dynamic>> _animalRecords = [
    {
      'id': 'A001',
      'name': 'Bessie',
      'type': 'Cattle',
      'breed': 'Holstein',
      'age': '3 years',
      'weight': '450 kg',
      'healthScore': 92,
      'lastCheckup': '2024-01-10',
      'status': 'Healthy',
      'vaccinations': ['FMD', 'Anthrax', 'Blackleg'],
      'treatments': [
        {
          'date': '2024-01-10',
          'condition': 'Routine Checkup',
          'treatment': 'Vitamin supplements',
          'vet': 'Dr. Sarah Wanjiku',
          'cost': 500,
          'notes': 'Good overall health, minor weight loss noted',
        },
        {
          'date': '2023-12-15',
          'condition': 'Mastitis',
          'treatment': 'Antibiotics (Penicillin)',
          'vet': 'Dr. James Ochieng',
          'cost': 1200,
          'notes': 'Full recovery after 7-day treatment',
        },
      ],
      'productivity': {
        'milkYield': '18 L/day',
        'avgYield': '16.5 L/day',
        'trend': 'improving',
      },
      'aiInsights': [
        'Milk yield 9% above average for breed',
        'Weight loss pattern suggests dietary adjustment needed',
        'Vaccination schedule up to date',
      ],
    },
    {
      'id': 'G003',
      'name': 'Kiko',
      'type': 'Goats',
      'breed': 'Boer',
      'age': '2 years',
      'weight': '35 kg',
      'healthScore': 88,
      'lastCheckup': '2024-01-08',
      'status': 'Healthy',
      'vaccinations': ['PPR', 'Anthrax'],
      'treatments': [
        {
          'date': '2024-01-08',
          'condition': 'Deworming',
          'treatment': 'Albendazole',
          'vet': 'Dr. Mary Njeri',
          'cost': 200,
          'notes': 'Routine deworming, good body condition',
        },
      ],
      'productivity': {
        'weightGain': '2.5 kg/month',
        'avgGain': '2.1 kg/month',
        'trend': 'stable',
      },
      'aiInsights': [
        'Weight gain above average for age group',
        'Due for PPR booster vaccination next month',
        'Consider breeding program inclusion',
      ],
    },
    {
      'id': 'P012',
      'name': 'Henrietta',
      'type': 'Poultry',
      'breed': 'Rhode Island Red',
      'age': '8 months',
      'weight': '2.1 kg',
      'healthScore': 85,
      'lastCheckup': '2024-01-12',
      'status': 'Minor Issue',
      'vaccinations': ['Newcastle', 'Gumboro', 'Fowl Pox'],
      'treatments': [
        {
          'date': '2024-01-12',
          'condition': 'Respiratory Infection',
          'treatment': 'Tylosin (antibiotic)',
          'vet': 'Dr. Peter Mwangi',
          'cost': 150,
          'notes': 'Mild respiratory symptoms, responding well to treatment',
        },
      ],
      'productivity': {
        'eggProduction': '5 eggs/week',
        'avgProduction': '6 eggs/week',
        'trend': 'declining',
      },
      'aiInsights': [
        'Egg production 17% below average - monitor closely',
        'Respiratory issues common in current weather',
        'Consider coop ventilation improvements',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.pets, color: Colors.white),
            SizedBox(width: 8),
            Text('Animal Health Records'),
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
            onPressed: () => _showAddAnimalDialog(),
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
          
          // Animals List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _getFilteredAnimals().length,
              itemBuilder: (context, index) {
                final animal = _getFilteredAnimals()[index];
                return _buildAnimalCard(animal);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "animal_records_fab",
        onPressed: () => _showAddRecordDialog(),
        backgroundColor: const Color(0xFF2E7D32),
        icon: const Icon(Icons.add),
        label: const Text('Add Record'),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredAnimals() {
    if (_selectedFilter == 'All') {
      return _animalRecords;
    }
    return _animalRecords.where((animal) => animal['type'] == _selectedFilter).toList();
  }

  Widget _buildAnimalCard(Map<String, dynamic> animal) {
    Color statusColor;
    switch (animal['status']) {
      case 'Healthy':
        statusColor = Colors.green;
        break;
      case 'Minor Issue':
        statusColor = Colors.orange;
        break;
      case 'Sick':
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
                CircleAvatar(
                  radius: 25,
                  backgroundColor: statusColor,
                  child: Text(
                    animal['name'][0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
                            animal['name'],
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
                              animal['status'],
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
                        '${animal['type']} • ${animal['breed']} • ${animal['age']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
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
                      '${animal['healthScore']}',
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
                      child: _buildDetailItem('Weight', animal['weight'], Icons.monitor_weight),
                    ),
                    Expanded(
                      child: _buildDetailItem('Last Checkup', animal['lastCheckup'], Icons.calendar_today),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showAnimalDetails(animal),
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
                        onPressed: () => _addHealthRecord(animal),
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

  void _showAnimalDetails(Map<String, dynamic> animal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnimalDetailScreen(animal: animal),
      ),
    );
  }

  void _addHealthRecord(Map<String, dynamic> animal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Health Record for ${animal['name']}'),
        content: const Text('This will open the health record form.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to add health record form
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
        title: const Text('Search Animals'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Enter animal name or ID...',
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

  void _showAddAnimalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Animal'),
        content: const Text('This will open the animal registration form.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to add animal form
            },
            child: const Text('Add Animal'),
          ),
        ],
      ),
    );
  }

  void _showAddRecordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Health Record'),
        content: const Text('Choose an animal to add a health record for.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Show animal selection
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}

// Animal Detail Screen
class AnimalDetailScreen extends StatelessWidget {
  final Map<String, dynamic> animal;

  const AnimalDetailScreen({super.key, required this.animal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(animal['name']),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Animal Detail Screen - Coming Soon'),
      ),
    );
  }
}
