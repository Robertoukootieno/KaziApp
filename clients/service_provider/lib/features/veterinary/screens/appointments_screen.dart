import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/veterinary_models.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Mock data - In real app, this would come from API
  final List<Appointment> _appointments = [
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
    Appointment(
      id: '3',
      farmerId: 'farmer3',
      farmerName: 'Peter Mwangi',
      farmerPhone: '+254734567890',
      animalType: 'Poultry',
      animalBreed: 'Broiler',
      animalCount: 50,
      serviceType: 'Health Check',
      description: 'Routine health check for broiler chickens',
      scheduledDate: DateTime.now().add(const Duration(days: 1)),
      scheduledTime: const TimeOfDay(hour: 10, minute: 0),
      location: 'Thika Farm',
      county: 'Kiambu',
      status: AppointmentStatus.confirmed,
      priority: AppointmentPriority.normal,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Appointments'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'All'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAppointmentsList(_getTodayAppointments()),
          _buildAppointmentsList(_getUpcomingAppointments()),
          _buildAppointmentsList(_getCompletedAppointments()),
          _buildAppointmentsList(_appointments),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewAppointmentDialog,
        backgroundColor: const Color(0xFF1976D2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  List<Appointment> _getTodayAppointments() {
    final today = DateTime.now();
    return _appointments.where((appointment) {
      return appointment.scheduledDate.year == today.year &&
             appointment.scheduledDate.month == today.month &&
             appointment.scheduledDate.day == today.day;
    }).toList();
  }

  List<Appointment> _getUpcomingAppointments() {
    final today = DateTime.now();
    return _appointments.where((appointment) {
      return appointment.scheduledDate.isAfter(today) &&
             appointment.status != AppointmentStatus.completed &&
             appointment.status != AppointmentStatus.cancelled;
    }).toList();
  }

  List<Appointment> _getCompletedAppointments() {
    return _appointments.where((appointment) {
      return appointment.status == AppointmentStatus.completed;
    }).toList();
  }

  Widget _buildAppointmentsList(List<Appointment> appointments) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No appointments found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Appointments will appear here when scheduled',
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
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return _buildAppointmentCard(appointment);
      },
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showAppointmentDetails(appointment),
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
                          appointment.farmerName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${appointment.animalCount} ${appointment.animalType} (${appointment.animalBreed})',
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
                          color: appointment.status.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          appointment.status.displayName,
                          style: TextStyle(
                            fontSize: 12,
                            color: appointment.status.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (appointment.priority == AppointmentPriority.emergency) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'EMERGENCY',
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
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${DateFormat('MMM dd, yyyy').format(appointment.scheduledDate)} at ${appointment.scheduledTime.format(context)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${appointment.location}, ${appointment.county}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              Text(
                appointment.serviceType,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1976D2),
                ),
              ),
              
              if (appointment.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  appointment.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showAppointmentDetails(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Appointment Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Farmer: ${appointment.farmerName}'),
            Text('Phone: ${appointment.farmerPhone}'),
            Text('Animals: ${appointment.animalCount} ${appointment.animalType}'),
            Text('Service: ${appointment.serviceType}'),
            Text('Status: ${appointment.status.displayName}'),
            Text('Priority: ${appointment.priority.displayName}'),
            if (appointment.description.isNotEmpty)
              Text('Description: ${appointment.description}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (appointment.status == AppointmentStatus.pending)
            ElevatedButton(
              onPressed: () {
                // Confirm appointment
                Navigator.pop(context);
                _confirmAppointment(appointment);
              },
              child: const Text('Confirm'),
            ),
        ],
      ),
    );
  }

  void _confirmAppointment(Appointment appointment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Appointment with ${appointment.farmerName} confirmed'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showNewAppointmentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Appointment'),
        content: const Text('New appointment booking feature coming soon!'),
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
