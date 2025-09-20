import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/veterinary_models.dart';
import 'appointments_screen.dart';
import 'patient_records_screen.dart';
import 'emergency_calls_screen.dart';
import 'inventory_screen.dart';
import 'vaccination_scheduler_screen.dart';
import 'billing_screen.dart';
import 'reports_screen.dart';
import 'client_communication_screen.dart';
import '../../../widgets/profile_app_bar.dart';

class VeterinaryDashboardScreen extends StatefulWidget {
  const VeterinaryDashboardScreen({super.key});

  @override
  State<VeterinaryDashboardScreen> createState() => _VeterinaryDashboardScreenState();
}

class _VeterinaryDashboardScreenState extends State<VeterinaryDashboardScreen> {
  int _selectedIndex = 0;
  
  // Mock data - In real app, this would come from API
  final List<Appointment> _todayAppointments = [
    Appointment(
      id: '1',
      farmerId: 'farmer1',
      farmerName: 'John Kamau',
      farmerPhone: '+254712345678',
      animalType: 'Cattle',
      animalBreed: 'Friesian',
      animalCount: 3,
      serviceType: 'Vaccination',
      description: 'Routine vaccination for dairy cows',
      scheduledDate: DateTime.now(),
      scheduledTime: const TimeOfDay(hour: 9, minute: 0),
      location: 'Kiambu Farm',
      county: 'Kiambu',
      status: AppointmentStatus.confirmed,
      priority: AppointmentPriority.normal,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Appointment(
      id: '2',
      farmerId: 'farmer2',
      farmerName: 'Mary Wanjiku',
      farmerPhone: '+254723456789',
      animalType: 'Goats',
      animalBreed: 'Boer',
      animalCount: 1,
      serviceType: 'Emergency Treatment',
      description: 'Sick goat - urgent attention needed',
      scheduledDate: DateTime.now(),
      scheduledTime: const TimeOfDay(hour: 14, minute: 30),
      location: 'Nakuru Farm',
      county: 'Nakuru',
      status: AppointmentStatus.pending,
      priority: AppointmentPriority.emergency,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      _buildDashboardHome(),
      const AppointmentsScreen(),
      const PatientRecordsScreen(),
      const EmergencyCallsScreen(),
      const InventoryScreen(),
      const VaccinationSchedulerScreen(),
      const BillingScreen(),
      const ReportsScreen(),
      const ClientCommunicationScreen(),
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
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_shared),
            label: 'Records',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emergency),
            label: 'Emergency',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardHome() {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: const ProfileAppBar(
        title: 'Veterinary Dashboard',
        backgroundColor: Color(0xFF2E7D32),
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
                                'Welcome back, Dr. Veterinarian!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Ready to care for animals today?',
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
                              Icons.medical_services,
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
                            '🐄',
                            style: TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Veterinary Services Portal',
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
                        title: 'Today\'s Appointments',
                        value: '${_todayAppointments.length}',
                        icon: Icons.calendar_today,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        title: 'Emergency Calls',
                        value: '${_todayAppointments.where((a) => a.priority == AppointmentPriority.emergency).length}',
                        icon: Icons.emergency,
                        color: Colors.red,
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
                        title: 'Patients Treated',
                        value: '24',
                        icon: Icons.pets,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        title: 'Revenue Today',
                        value: 'KSh 15,400',
                        icon: Icons.attach_money,
                        color: Colors.orange,
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
                          title: 'Appointments',
                          icon: Icons.calendar_today,
                          color: Colors.blue,
                          onTap: () => setState(() => _selectedIndex = 1),
                        ),
                        _buildQuickActionCard(
                          title: 'Emergency',
                          icon: Icons.emergency,
                          color: Colors.red,
                          onTap: () => setState(() => _selectedIndex = 3),
                        ),
                        _buildQuickActionCard(
                          title: 'Records',
                          icon: Icons.folder_shared,
                          color: Colors.green,
                          onTap: () => setState(() => _selectedIndex = 2),
                        ),
                        _buildQuickActionCard(
                          title: 'Inventory',
                          icon: Icons.inventory,
                          color: Colors.orange,
                          onTap: () => setState(() => _selectedIndex = 4),
                        ),
                        _buildQuickActionCard(
                          title: 'Vaccination',
                          icon: Icons.schedule,
                          color: Colors.purple,
                          onTap: () => setState(() => _selectedIndex = 5),
                        ),
                        _buildQuickActionCard(
                          title: 'Billing',
                          icon: Icons.receipt,
                          color: Colors.teal,
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
          // Navigate to new appointment
          setState(() => _selectedIndex = 1);
        },
        backgroundColor: const Color(0xFF1976D2),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'New Appointment',
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
