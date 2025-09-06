import 'package:flutter/material.dart';
import 'machinery_booking_screen.dart';
import 'machinery_details_screen.dart';

class MachineryServicesScreen extends StatefulWidget {
  const MachineryServicesScreen({super.key});

  @override
  State<MachineryServicesScreen> createState() => _MachineryServicesScreenState();
}

class _MachineryServicesScreenState extends State<MachineryServicesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';
  String _selectedServiceType = 'All';

  final List<String> _categories = [
    'All', 'Tractors', 'Harvesters', 'Planting', 'Irrigation', 'Processing', 'Transport'
  ];

  final List<String> _serviceTypes = [
    'All', 'Rent', 'Lease', 'Book with Driver', 'Self-Operate'
  ];

  final List<MachineryItem> _machineryItems = [
    MachineryItem(
      id: '1',
      name: 'John Deere 5075E Tractor',
      category: 'Tractors',
      image: 'assets/images/tractor_john_deere.jpg',
      hourlyRate: 2500,
      dailyRate: 15000,
      monthlyRate: 350000,
      description: 'Powerful 75HP tractor perfect for medium to large farms',
      specifications: ['75 HP Engine', '4WD', 'Power Steering', 'PTO'],
      availableServices: ['Rent', 'Lease', 'Book with Driver'],
      location: 'Nakuru',
      rating: 4.8,
      availability: true,
    ),
    MachineryItem(
      id: '2',
      name: 'Massey Ferguson 385 4WD',
      category: 'Tractors',
      image: 'assets/images/tractor_massey.jpg',
      hourlyRate: 2200,
      dailyRate: 13000,
      monthlyRate: 320000,
      description: 'Reliable 85HP tractor with excellent fuel efficiency',
      specifications: ['85 HP Engine', '4WD', 'Hydraulic System', 'PTO'],
      availableServices: ['Rent', 'Lease', 'Book with Driver', 'Self-Operate'],
      location: 'Eldoret',
      rating: 4.6,
      availability: true,
    ),
    MachineryItem(
      id: '3',
      name: 'Combine Harvester - New Holland',
      category: 'Harvesters',
      image: 'assets/images/harvester_newholland.jpg',
      hourlyRate: 8000,
      dailyRate: 45000,
      monthlyRate: 900000,
      description: 'High-capacity combine harvester for wheat, maize, and rice',
      specifications: ['6m Cutting Width', 'Grain Tank 9000L', 'GPS Ready'],
      availableServices: ['Rent', 'Book with Driver'],
      location: 'Kitale',
      rating: 4.9,
      availability: true,
    ),
    MachineryItem(
      id: '4',
      name: 'Seed Planter - 4 Row',
      category: 'Planting',
      image: 'assets/images/planter_4row.jpg',
      hourlyRate: 1500,
      dailyRate: 8000,
      monthlyRate: 180000,
      description: 'Precision seed planter for maize, beans, and sorghum',
      specifications: ['4 Row Planting', 'Fertilizer Hopper', 'Depth Control'],
      availableServices: ['Rent', 'Lease', 'Self-Operate'],
      location: 'Naivasha',
      rating: 4.5,
      availability: false,
    ),
    MachineryItem(
      id: '5',
      name: 'Irrigation System - Pivot',
      category: 'Irrigation',
      image: 'assets/images/irrigation_pivot.jpg',
      hourlyRate: 0,
      dailyRate: 25000,
      monthlyRate: 450000,
      description: 'Center pivot irrigation system for large scale farming',
      specifications: ['500m Radius', 'GPS Control', 'Variable Rate'],
      availableServices: ['Lease', 'Book with Driver'],
      location: 'Mwea',
      rating: 4.7,
      availability: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<MachineryItem> get _filteredItems {
    return _machineryItems.where((item) {
      final categoryMatch = _selectedCategory == 'All' || item.category == _selectedCategory;
      final serviceMatch = _selectedServiceType == 'All' || 
          item.availableServices.contains(_selectedServiceType);
      return categoryMatch && serviceMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Machinery Services'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Browse', icon: Icon(Icons.search)),
            Tab(text: 'My Bookings', icon: Icon(Icons.bookmark)),
            Tab(text: 'Favorites', icon: Icon(Icons.favorite)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBrowseTab(),
          _buildMyBookingsTab(),
          _buildFavoritesTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "machinery_services_fab",
        onPressed: () => _showQuickBooking(context),
        backgroundColor: const Color(0xFF2E7D32),
        icon: const Icon(Icons.add),
        label: const Text('Quick Book'),
      ),
    );
  }

  Widget _buildBrowseTab() {
    return Column(
      children: [
        // Service Types Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose Your Service Type',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildServiceTypeCard('Rent', Icons.access_time, 'Hourly/Daily rates')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildServiceTypeCard('Lease', Icons.calendar_month, 'Long-term use')),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildServiceTypeCard('With Driver', Icons.person, 'Operator included')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildServiceTypeCard('Self-Operate', Icons.build, 'You operate')),
                ],
              ),
            ],
          ),
        ),
        
        // Filters
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(value: category, child: Text(category));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedServiceType,
                  decoration: const InputDecoration(
                    labelText: 'Service Type',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _serviceTypes.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedServiceType = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        
        // Machinery List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filteredItems.length,
            itemBuilder: (context, index) {
              final item = _filteredItems[index];
              return _buildMachineryCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServiceTypeCard(String title, IconData icon, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMachineryCard(MachineryItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MachineryDetailsScreen(machinery: item),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and Status
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    color: Colors.grey[300],
                  ),
                  child: const Icon(Icons.agriculture, size: 80, color: Colors.grey),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: item.availability ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.availability ? 'Available' : 'Booked',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.category,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text('${item.rating}'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      Text(item.location, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  
                  // Pricing
                  Row(
                    children: [
                      if (item.hourlyRate > 0) ...[
                        _buildPriceTag('KSh ${item.hourlyRate}/hr'),
                        const SizedBox(width: 8),
                      ],
                      _buildPriceTag('KSh ${item.dailyRate}/day'),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: item.availability ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MachineryBookingScreen(machinery: item),
                            ),
                          );
                        } : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Book Now'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceTag(String price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        price,
        style: const TextStyle(
          color: Color(0xFF2E7D32),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildMyBookingsTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No bookings yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text('Your machinery bookings will appear here'),
        ],
      ),
    );
  }

  Widget _buildFavoritesTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text('Save machinery you like for quick access'),
        ],
      ),
    );
  }

  void _showQuickBooking(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Quick Booking',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Need machinery urgently? Call our hotline for immediate assistance.'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement call functionality
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Calling +254 700 MACHINERY...')),
                );
              },
              icon: const Icon(Icons.phone),
              label: const Text('Call +254 700 MACHINERY'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MachineryItem {
  final String id;
  final String name;
  final String category;
  final String image;
  final int hourlyRate;
  final int dailyRate;
  final int monthlyRate;
  final String description;
  final List<String> specifications;
  final List<String> availableServices;
  final String location;
  final double rating;
  final bool availability;

  MachineryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.hourlyRate,
    required this.dailyRate,
    required this.monthlyRate,
    required this.description,
    required this.specifications,
    required this.availableServices,
    required this.location,
    required this.rating,
    required this.availability,
  });
}
