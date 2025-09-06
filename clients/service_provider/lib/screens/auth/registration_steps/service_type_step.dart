import 'package:flutter/material.dart';

class ServiceTypeStep extends StatefulWidget {
  final VoidCallback onNext;
  final Function(Map<String, dynamic>) onDataChanged;
  final Map<String, dynamic> initialData;

  const ServiceTypeStep({
    super.key,
    required this.onNext,
    required this.onDataChanged,
    required this.initialData,
  });

  @override
  State<ServiceTypeStep> createState() => _ServiceTypeStepState();
}

class _ServiceTypeStepState extends State<ServiceTypeStep> {
  String _selectedServiceType = '';

  final List<Map<String, dynamic>> _serviceTypes = [
    {
      'id': 'veterinarian',
      'name': 'Veterinarian',
      'icon': '🏥',
      'description': 'Animal health services, consultations, and treatments',
      'color': const Color(0xFF1976D2),
    },
    {
      'id': 'agrovet',
      'name': 'Agrovet',
      'icon': '🏪',
      'description': 'Agricultural supplies, medicines, and equipment',
      'color': const Color(0xFF388E3C),
    },
    {
      'id': 'feed_supplier',
      'name': 'Feed Supplier',
      'icon': '🌾',
      'description': 'Animal feed, nutrition, and supplements',
      'color': const Color(0xFFFF8F00),
    },
    {
      'id': 'seeds_supplier',
      'name': 'Seeds Supplier',
      'icon': '🌱',
      'description': 'Quality seeds and planting materials',
      'color': const Color(0xFF689F38),
    },
    {
      'id': 'fertilizer_supplier',
      'name': 'Fertilizer Supplier',
      'icon': '🧪',
      'description': 'Fertilizers, soil amendments, and chemicals',
      'color': const Color(0xFF7B1FA2),
    },
    {
      'id': 'machinery_provider',
      'name': 'Machinery Provider',
      'icon': '🚚',
      'description': 'Farm equipment, machinery rental and sales',
      'color': const Color(0xFFD32F2F),
    },
    {
      'id': 'consultant',
      'name': 'Agricultural Consultant',
      'icon': '👨‍🌾',
      'description': 'Expert advice and farming consultations',
      'color': const Color(0xFF0288D1),
    },
    {
      'id': 'retailer',
      'name': 'General Retailer',
      'icon': '🛒',
      'description': 'General farm products and supplies',
      'color': const Color(0xFF5D4037),
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedServiceType = widget.initialData['serviceType'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'What type of service do you provide?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose the category that best describes your business. This helps farmers find you more easily.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 32),

          // Service types grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: _serviceTypes.length,
              itemBuilder: (context, index) {
                final service = _serviceTypes[index];
                final isSelected = _selectedServiceType == service['id'];

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedServiceType = service['id'];
                    });
                    widget.onDataChanged({
                      'serviceType': service['id'],
                      'serviceTypeName': service['name'],
                    });
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? service['color'].withOpacity(0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? service['color']
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? service['color']
                                : Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              service['icon'],
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Name
                        Text(
                          service['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? service['color']
                                : Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 8),

                        // Description
                        Text(
                          service['description'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Continue button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedServiceType.isNotEmpty ? widget.onNext : null,
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
    );
  }
}
