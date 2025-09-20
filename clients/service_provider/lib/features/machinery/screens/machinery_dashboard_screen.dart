import 'package:flutter/material.dart';
import '../models/machinery_models.dart';
import 'equipment_management_screen.dart';
import 'rental_bookings_screen.dart';
import 'maintenance_screen.dart';
import 'operators_screen.dart';
import 'logistics_screen.dart';
import 'financial_screen.dart';
import 'customers_screen.dart';
import 'reports_screen.dart';
import '../../../widgets/profile_app_bar.dart';

class MachineryDashboardScreen extends StatefulWidget {
  const MachineryDashboardScreen({super.key});

  @override
  State<MachineryDashboardScreen> createState() => _MachineryDashboardScreenState();
}

class _MachineryDashboardScreenState extends State<MachineryDashboardScreen> {
  int _selectedIndex = 0;
  
  // Mock data - In real app, this would come from API
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
  ];

  final List<RentalBooking> _activeRentals = [
    RentalBooking(
      id: 'rental1',
      equipmentId: '2',
      equipmentName: 'Massey Ferguson 385',
      farmerId: 'farmer1',
      farmerName: 'Peter Mwangi',
      farmerPhone: '+254712345678',
      farmerEmail: 'peter@example.com',
      startDate: DateTime.now().subtract(const Duration(days: 3)),
      endDate: DateTime.now().add(const Duration(days: 4)),
      durationDays: 7,
      totalAmount: 49000.0,
      depositAmount: 15000.0,
      status: RentalStatus.active,
      operatorId: 'op3',
      operatorName: 'James Kiprotich',
      deliveryRequested: true,
      deliveryAddress: 'Kiambu Farm, Kiambu County',
      deliveryFee: 1500.0,
      farmLocation: 'Kiambu Farm',
      county: 'Kiambu',
      purpose: 'Land preparation for maize planting',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      confirmedAt: DateTime.now().subtract(const Duration(days: 4)),
      startedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      _buildDashboardHome(),
      const EquipmentManagementScreen(),
      const RentalBookingsScreen(),
      const MaintenanceScreen(),
      const OperatorsScreen(),
      const LogisticsScreen(),
      const FinancialScreen(),
      const CustomersScreen(),
      const ReportsScreen(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: _selectedIndex == 0 ? null : BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF1976D2),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.agriculture),
            label: 'Equipment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Rentals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Maintenance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Operators',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardHome() {
    final availableEquipment = _equipment.where((e) => e.status == EquipmentStatus.available).length;
    final rentedEquipment = _equipment.where((e) => e.status == EquipmentStatus.rented).length;
    final maintenanceEquipment = _equipment.where((e) => e.status == EquipmentStatus.maintenance).length;
    final todayRevenue = _activeRentals.fold<double>(0, (sum, rental) => sum + (rental.totalAmount / rental.durationDays));

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: const ProfileAppBar(
        title: 'Machinery Provider',
        backgroundColor: Color(0xFFFF8F00),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Welcome back, Machinery Provider!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Manage your equipment fleet efficiently',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.agriculture,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Text(
                            '🚜',
                            style: TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Machinery Provider Portal',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Quick Stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: 'Available Equipment',
                        value: '$availableEquipment',
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        title: 'Currently Rented',
                        value: '$rentedEquipment',
                        icon: Icons.schedule,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: 'In Maintenance',
                        value: '$maintenanceEquipment',
                        icon: Icons.build,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        title: 'Today\'s Revenue',
                        value: 'KSh ${todayRevenue.toStringAsFixed(0)}',
                        icon: Icons.attach_money,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Quick Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.0,
                      children: [
                        _buildQuickActionCard(
                          title: 'Equipment',
                          icon: Icons.agriculture,
                          color: Colors.green,
                          onTap: () => setState(() => _selectedIndex = 1),
                        ),
                        _buildQuickActionCard(
                          title: 'Rentals',
                          icon: Icons.calendar_today,
                          color: Colors.blue,
                          onTap: () => setState(() => _selectedIndex = 2),
                        ),
                        _buildQuickActionCard(
                          title: 'Maintenance',
                          icon: Icons.build,
                          color: Colors.orange,
                          onTap: () => setState(() => _selectedIndex = 3),
                        ),
                        _buildQuickActionCard(
                          title: 'Operators',
                          icon: Icons.people,
                          color: Colors.purple,
                          onTap: () => setState(() => _selectedIndex = 4),
                        ),
                        _buildQuickActionCard(
                          title: 'Logistics',
                          icon: Icons.local_shipping,
                          color: Colors.teal,
                          onTap: () => setState(() => _selectedIndex = 5),
                        ),
                        _buildQuickActionCard(
                          title: 'Financial',
                          icon: Icons.account_balance_wallet,
                          color: Colors.indigo,
                          onTap: () => setState(() => _selectedIndex = 6),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to add equipment
          setState(() => _selectedIndex = 1);
        },
        backgroundColor: const Color(0xFF1976D2),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Equipment',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
