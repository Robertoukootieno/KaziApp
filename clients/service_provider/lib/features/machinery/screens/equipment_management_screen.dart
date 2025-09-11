import 'package:flutter/material.dart';
import '../models/machinery_models.dart';

class EquipmentManagementScreen extends StatefulWidget {
  const EquipmentManagementScreen({super.key});

  @override
  State<EquipmentManagementScreen> createState() => _EquipmentManagementScreenState();
}

class _EquipmentManagementScreenState extends State<EquipmentManagementScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  EquipmentCategory? _selectedCategory;

  // Mock data
  final List<Equipment> _equipment = [
    Equipment(
      id: '1',
      name: 'John Deere 5075E',
      model: '5075E',
      brand: 'John Deere',
      year: 2022,
      category: EquipmentCategory.tractors,
      status: EquipmentStatus.available,
      description: 'Versatile utility tractor perfect for farming operations',
      specifications: ['75 HP', '4WD', 'Power Steering', 'PTO'],
      hourlyRate: 1500.0,
      dailyRate: 8000.0,
      weeklyRate: 45000.0,
      imageUrls: [],
      location: 'Nakuru',
      engineHours: 1250,
      lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 30)),
      nextMaintenanceDate: DateTime.now().add(const Duration(days: 60)),
      operatorIds: ['op1', 'op2'],
      requiresOperator: true,
      deliveryAvailable: true,
      deliveryRadius: 50.0,
      deliveryFee: 2000.0,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Equipment(
      id: '2',
      name: 'Massey Ferguson 385',
      model: '385',
      brand: 'Massey Ferguson',
      year: 2021,
      category: EquipmentCategory.tractors,
      status: EquipmentStatus.rented,
      description: 'Reliable tractor for medium-scale farming',
      specifications: ['85 HP', '2WD', 'Hydraulic Lift'],
      hourlyRate: 1200.0,
      dailyRate: 7000.0,
      weeklyRate: 40000.0,
      imageUrls: [],
      location: 'Eldoret',
      engineHours: 2100,
      lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 45)),
      nextMaintenanceDate: DateTime.now().add(const Duration(days: 45)),
      currentRentalId: 'rental1',
      operatorIds: ['op3'],
      requiresOperator: true,
      deliveryAvailable: true,
      deliveryRadius: 30.0,
      deliveryFee: 1500.0,
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Equipment(
      id: '3',
      name: 'New Holland TC5070',
      model: 'TC5070',
      brand: 'New Holland',
      year: 2020,
      category: EquipmentCategory.tractors,
      status: EquipmentStatus.maintenance,
      description: 'Compact tractor ideal for small farms',
      specifications: ['70 HP', '4WD', 'Loader Ready'],
      hourlyRate: 1000.0,
      dailyRate: 6000.0,
      weeklyRate: 35000.0,
      imageUrls: [],
      location: 'Meru',
      engineHours: 3200,
      lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 2)),
      nextMaintenanceDate: DateTime.now().add(const Duration(days: 88)),
      operatorIds: ['op1'],
      requiresOperator: false,
      deliveryAvailable: false,
      deliveryRadius: 0.0,
      deliveryFee: 0.0,
      createdAt: DateTime.now().subtract(const Duration(days: 150)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Equipment(
      id: '4',
      name: 'Case IH Combine Harvester',
      model: 'Axial-Flow 250',
      brand: 'Case IH',
      year: 2023,
      category: EquipmentCategory.harvesters,
      status: EquipmentStatus.available,
      description: 'High-capacity combine harvester for grain crops',
      specifications: ['300 HP', 'Grain Tank 10,700L', 'Auto Guidance'],
      hourlyRate: 3500.0,
      dailyRate: 25000.0,
      weeklyRate: 150000.0,
      imageUrls: [],
      location: 'Nakuru',
      engineHours: 450,
      lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 15)),
      nextMaintenanceDate: DateTime.now().add(const Duration(days: 75)),
      operatorIds: ['op4'],
      requiresOperator: true,
      deliveryAvailable: true,
      deliveryRadius: 100.0,
      deliveryFee: 5000.0,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Equipment Management'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All Equipment'),
            Tab(text: 'Available'),
            Tab(text: 'Rented'),
            Tab(text: 'Maintenance'),
            Tab(text: 'Categories'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Container(
            color: const Color(0xFF1976D2),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search equipment by name, model, or brand...',
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
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryFilter(null, 'All'),
                      ...EquipmentCategory.values.map((category) =>
                        _buildCategoryFilter(category, category.displayName),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Equipment List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEquipmentList(_getFilteredEquipment()),
                _buildEquipmentList(_getEquipmentByStatus(EquipmentStatus.available)),
                _buildEquipmentList(_getEquipmentByStatus(EquipmentStatus.rented)),
                _buildEquipmentList(_getEquipmentByStatus(EquipmentStatus.maintenance)),
                _buildCategoriesView(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEquipmentDialog,
        backgroundColor: const Color(0xFF1976D2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCategoryFilter(EquipmentCategory? category, String label) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = selected ? category : null;
          });
        },
        backgroundColor: Colors.white.withValues(alpha: 0.2),
        selectedColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? const Color(0xFF1976D2) : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  List<Equipment> _getFilteredEquipment() {
    var filtered = _equipment.where((equipment) {
      final matchesSearch = _searchQuery.isEmpty ||
          equipment.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          equipment.model.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          equipment.brand.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesCategory = _selectedCategory == null || equipment.category == _selectedCategory;
      
      return matchesSearch && matchesCategory;
    }).toList();
    
    return filtered;
  }

  List<Equipment> _getEquipmentByStatus(EquipmentStatus status) {
    return _getFilteredEquipment().where((equipment) => equipment.status == status).toList();
  }

  Widget _buildEquipmentList(List<Equipment> equipmentList) {
    if (equipmentList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.agriculture,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No equipment found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty || _selectedCategory != null
                  ? 'Try adjusting your search or filters'
                  : 'Add equipment to get started',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: equipmentList.length,
      itemBuilder: (context, index) {
        final equipment = equipmentList[index];
        return _buildEquipmentCard(equipment);
      },
    );
  }

  Widget _buildEquipmentCard(Equipment equipment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showEquipmentDetails(equipment),
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
                          equipment.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${equipment.brand} ${equipment.model} (${equipment.year})',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: equipment.status.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              equipment.status.icon,
                              size: 14,
                              color: equipment.status.color,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              equipment.status.displayName,
                              style: TextStyle(
                                fontSize: 12,
                                color: equipment.status.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (equipment.needsMaintenance) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'MAINTENANCE DUE',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: equipment.category.icon == Icons.agriculture 
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      equipment.category.icon,
                      color: equipment.category.icon == Icons.agriculture 
                          ? Colors.green
                          : Colors.blue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          equipment.category.displayName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          equipment.displayRate,
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color(0xFF1976D2),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            equipment.location,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${equipment.engineHours}h',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              
              if (equipment.specifications.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: equipment.specifications.take(3).map((spec) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      spec,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesView() {
    final categories = EquipmentCategory.values;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final categoryEquipment = _equipment.where((e) => e.category == category).toList();

        if (categoryEquipment.isEmpty) return const SizedBox.shrink();

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: Icon(category.icon, color: const Color(0xFF1976D2)),
            title: Text(
              category.displayName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${categoryEquipment.length} equipment'),
            children: categoryEquipment.map((equipment) => ListTile(
              title: Text(equipment.name),
              subtitle: Text('${equipment.brand} ${equipment.model}'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: equipment.status.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  equipment.status.displayName,
                  style: TextStyle(
                    fontSize: 12,
                    color: equipment.status.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              onTap: () => _showEquipmentDetails(equipment),
            )).toList(),
          ),
        );
      },
    );
  }

  void _showEquipmentDetails(Equipment equipment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(equipment.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Brand: ${equipment.brand}'),
              Text('Model: ${equipment.model}'),
              Text('Year: ${equipment.year}'),
              Text('Category: ${equipment.category.displayName}'),
              Text('Status: ${equipment.status.displayName}'),
              Text('Location: ${equipment.location}'),
              Text('Engine Hours: ${equipment.engineHours}'),
              Text('Rate: ${equipment.displayRate}'),
              if (equipment.requiresOperator) const Text('Requires Operator: Yes'),
              if (equipment.deliveryAvailable) Text('Delivery Available: ${equipment.deliveryRadius}km radius'),
              const SizedBox(height: 8),
              const Text('Specifications:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...equipment.specifications.map((spec) => Text('• $spec')),
              const SizedBox(height: 8),
              Text('Description: ${equipment.description}'),
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
              _showEditEquipmentDialog(equipment);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _showAddEquipmentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Equipment'),
        content: const Text('Add new equipment feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showEditEquipmentDialog(Equipment equipment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${equipment.name}'),
        content: const Text('Edit equipment feature coming soon!'),
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
