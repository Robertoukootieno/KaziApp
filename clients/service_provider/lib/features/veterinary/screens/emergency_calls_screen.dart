import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/veterinary_models.dart';

class EmergencyCallsScreen extends StatefulWidget {
  const EmergencyCallsScreen({super.key});

  @override
  State<EmergencyCallsScreen> createState() => _EmergencyCallsScreenState();
}

class _EmergencyCallsScreenState extends State<EmergencyCallsScreen> {
  // Mock emergency calls data
  final List<Appointment> _emergencyCalls = [
    Appointment(
      id: 'emergency1',
      farmerId: 'farmer2',
      farmerName: 'Mary Wanjiku',
      farmerPhone: '+254723456789',
      animalType: 'Goats',
      animalBreed: 'Boer',
      animalCount: 1,
      serviceType: 'Emergency Treatment',
      description: 'Goat is not eating and appears very weak. Started this morning.',
      scheduledDate: DateTime.now(),
      scheduledTime: TimeOfDay.now(),
      location: 'Nakuru Farm',
      county: 'Nakuru',
      status: AppointmentStatus.pending,
      priority: AppointmentPriority.emergency,
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    Appointment(
      id: 'emergency2',
      farmerId: 'farmer4',
      farmerName: 'James Mwangi',
      farmerPhone: '+254745678901',
      animalType: 'Cattle',
      animalBreed: 'Ayrshire',
      animalCount: 1,
      serviceType: 'Emergency Surgery',
      description: 'Cow injured by barbed wire, deep cut on leg, bleeding heavily.',
      scheduledDate: DateTime.now().subtract(const Duration(hours: 1)),
      scheduledTime: const TimeOfDay(hour: 13, minute: 0),
      location: 'Meru Farm',
      county: 'Meru',
      status: AppointmentStatus.inProgress,
      priority: AppointmentPriority.emergency,
      createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
    ),
    Appointment(
      id: 'emergency3',
      farmerId: 'farmer5',
      farmerName: 'Grace Nyambura',
      farmerPhone: '+254756789012',
      animalType: 'Poultry',
      animalBreed: 'Layers',
      animalCount: 20,
      serviceType: 'Disease Outbreak',
      description: 'Multiple chickens showing symptoms of Newcastle disease.',
      scheduledDate: DateTime.now().subtract(const Duration(hours: 3)),
      scheduledTime: const TimeOfDay(hour: 11, minute: 30),
      location: 'Nyeri Farm',
      county: 'Nyeri',
      status: AppointmentStatus.completed,
      priority: AppointmentPriority.emergency,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      completedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final activeCalls = _emergencyCalls.where((call) => 
        call.status != AppointmentStatus.completed && 
        call.status != AppointmentStatus.cancelled).toList();
    
    final completedCalls = _emergencyCalls.where((call) => 
        call.status == AppointmentStatus.completed).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text('Emergency Calls'),
          backgroundColor: Colors.red.shade600,
          foregroundColor: Colors.white,
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(
                icon: Icon(Icons.emergency),
                text: 'Active',
              ),
              Tab(
                icon: Icon(Icons.check_circle),
                text: 'Completed',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildEmergencyList(activeCalls, isActive: true),
            _buildEmergencyList(completedCalls, isActive: false),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showEmergencyHotline,
          backgroundColor: Colors.red.shade600,
          child: const Icon(Icons.phone, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildEmergencyList(List<Appointment> calls, {required bool isActive}) {
    if (calls.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? Icons.emergency : Icons.check_circle,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              isActive ? 'No active emergency calls' : 'No completed emergency calls',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isActive 
                  ? 'Emergency calls will appear here when received'
                  : 'Completed emergency calls will appear here',
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
      itemCount: calls.length,
      itemBuilder: (context, index) {
        final call = calls[index];
        return _buildEmergencyCard(call, isActive: isActive);
      },
    );
  }

  Widget _buildEmergencyCard(Appointment call, {required bool isActive}) {
    final timeAgo = _getTimeAgo(call.createdAt);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isActive ? Colors.red.shade200 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showEmergencyDetails(call),
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
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.emergency,
                                color: Colors.red.shade600,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'EMERGENCY',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          call.farmerName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${call.animalCount} ${call.animalType} (${call.animalBreed})',
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
                          color: call.status.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          call.status.displayName,
                          style: TextStyle(
                            fontSize: 12,
                            color: call.status.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      call.serviceType,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      call.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
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
                      '${call.location}, ${call.county}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.phone,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    call.farmerPhone,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              
              if (isActive) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _callFarmer(call),
                        icon: const Icon(Icons.phone, size: 16),
                        label: const Text('Call'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _respondToEmergency(call),
                        icon: const Icon(Icons.directions_car, size: 16),
                        label: const Text('Respond'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _showEmergencyDetails(Appointment call) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.emergency, color: Colors.red.shade600),
            const SizedBox(width: 8),
            const Text('Emergency Details'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Farmer', call.farmerName),
              _buildDetailRow('Phone', call.farmerPhone),
              _buildDetailRow('Location', '${call.location}, ${call.county}'),
              _buildDetailRow('Animals', '${call.animalCount} ${call.animalType} (${call.animalBreed})'),
              _buildDetailRow('Service Type', call.serviceType),
              _buildDetailRow('Status', call.status.displayName),
              _buildDetailRow('Reported', DateFormat('MMM dd, yyyy HH:mm').format(call.createdAt)),
              const SizedBox(height: 8),
              const Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(call.description),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (call.status != AppointmentStatus.completed)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _respondToEmergency(call);
              },
              icon: const Icon(Icons.directions_car),
              label: const Text('Respond'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _callFarmer(Appointment call) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling ${call.farmerName} at ${call.farmerPhone}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _respondToEmergency(Appointment call) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Respond to Emergency'),
        content: Text('Are you ready to respond to ${call.farmerName}\'s emergency call?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Responding to ${call.farmerName}\'s emergency'),
                  backgroundColor: Colors.red.shade600,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            child: const Text('Respond'),
          ),
        ],
      ),
    );
  }

  void _showEmergencyHotline() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.phone, color: Colors.red.shade600),
            const SizedBox(width: 8),
            const Text('Emergency Hotline'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('24/7 Emergency Veterinary Hotline'),
            SizedBox(height: 16),
            Text(
              '+254 700 123 456',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('Available for urgent animal health emergencies'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Calling emergency hotline...'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Call Now'),
          ),
        ],
      ),
    );
  }
}
