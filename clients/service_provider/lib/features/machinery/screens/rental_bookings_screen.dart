import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/machinery_models.dart';

class RentalBookingsScreen extends StatefulWidget {
  const RentalBookingsScreen({super.key});

  @override
  State<RentalBookingsScreen> createState() => _RentalBookingsScreenState();
}

class _RentalBookingsScreenState extends State<RentalBookingsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Mock data
  final List<RentalBooking> _bookings = [
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
    RentalBooking(
      id: 'rental2',
      equipmentId: '1',
      equipmentName: 'John Deere 5075E',
      farmerId: 'farmer2',
      farmerName: 'Mary Wanjiku',
      farmerPhone: '+254723456789',
      farmerEmail: 'mary@example.com',
      startDate: DateTime.now().add(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 7)),
      durationDays: 5,
      totalAmount: 40000.0,
      depositAmount: 12000.0,
      status: RentalStatus.confirmed,
      operatorId: 'op1',
      operatorName: 'Samuel Kiprop',
      deliveryRequested: false,
      farmLocation: 'Nakuru Farm',
      county: 'Nakuru',
      purpose: 'Harvesting wheat crop',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      confirmedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    RentalBooking(
      id: 'rental3',
      equipmentId: '4',
      equipmentName: 'Case IH Combine Harvester',
      farmerId: 'farmer3',
      farmerName: 'David Kimani',
      farmerPhone: '+254734567890',
      farmerEmail: 'david@example.com',
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      endDate: DateTime.now().subtract(const Duration(days: 5)),
      durationDays: 5,
      totalAmount: 125000.0,
      depositAmount: 40000.0,
      status: RentalStatus.completed,
      operatorId: 'op4',
      operatorName: 'Joseph Mutua',
      deliveryRequested: true,
      deliveryAddress: 'Eldoret Farm, Uasin Gishu County',
      deliveryFee: 5000.0,
      farmLocation: 'Eldoret Farm',
      county: 'Uasin Gishu',
      purpose: 'Maize harvesting',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      confirmedAt: DateTime.now().subtract(const Duration(days: 12)),
      startedAt: DateTime.now().subtract(const Duration(days: 10)),
      completedAt: DateTime.now().subtract(const Duration(days: 5)),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Rental Bookings'),
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
            Tab(text: 'All Bookings'),
            Tab(text: 'Pending'),
            Tab(text: 'Active'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingsList(_bookings),
          _buildBookingsList(_getBookingsByStatus(RentalStatus.pending)),
          _buildBookingsList(_getBookingsByStatus(RentalStatus.active)),
          _buildBookingsList(_getUpcomingBookings()),
          _buildBookingsList(_getBookingsByStatus(RentalStatus.completed)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewBookingDialog,
        backgroundColor: const Color(0xFF1976D2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  List<RentalBooking> _getBookingsByStatus(RentalStatus status) {
    return _bookings.where((booking) => booking.status == status).toList();
  }

  List<RentalBooking> _getUpcomingBookings() {
    return _bookings.where((booking) => 
        booking.status == RentalStatus.confirmed && 
        booking.startDate.isAfter(DateTime.now())).toList();
  }

  Widget _buildBookingsList(List<RentalBooking> bookings) {
    if (bookings.isEmpty) {
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
              'No bookings found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Rental bookings will appear here',
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
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _buildBookingCard(booking);
      },
    );
  }

  Widget _buildBookingCard(RentalBooking booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showBookingDetails(booking),
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
                          booking.equipmentName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          booking.farmerName,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
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
                          color: booking.status.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          booking.status.displayName,
                          style: TextStyle(
                            fontSize: 12,
                            color: booking.status.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (booking.isOverdue) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'OVERDUE',
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
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${DateFormat('MMM dd').format(booking.startDate)} - ${DateFormat('MMM dd, yyyy').format(booking.endDate)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${booking.durationDays} days',
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
                      '${booking.farmLocation}, ${booking.county}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    booking.operatorName ?? 'No operator assigned',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'KSh ${booking.totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                ],
              ),
              
              if (booking.deliveryRequested) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.local_shipping,
                      size: 16,
                      color: Colors.blue.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Delivery requested',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              
              if (booking.purpose.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Purpose: ${booking.purpose}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontStyle: FontStyle.italic,
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

  void _showBookingDetails(RentalBooking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Booking Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Equipment: ${booking.equipmentName}'),
              Text('Customer: ${booking.farmerName}'),
              Text('Phone: ${booking.farmerPhone}'),
              Text('Email: ${booking.farmerEmail}'),
              Text('Duration: ${booking.durationDays} days'),
              Text('Start: ${DateFormat('MMM dd, yyyy').format(booking.startDate)}'),
              Text('End: ${DateFormat('MMM dd, yyyy').format(booking.endDate)}'),
              Text('Status: ${booking.status.displayName}'),
              Text('Total Amount: KSh ${booking.totalAmount.toStringAsFixed(0)}'),
              Text('Deposit: KSh ${booking.depositAmount.toStringAsFixed(0)}'),
              if (booking.operatorName != null) Text('Operator: ${booking.operatorName}'),
              if (booking.deliveryRequested) Text('Delivery: Yes (KSh ${booking.deliveryFee?.toStringAsFixed(0) ?? '0'})'),
              Text('Purpose: ${booking.purpose}'),
              if (booking.specialInstructions != null) Text('Instructions: ${booking.specialInstructions}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (booking.status == RentalStatus.pending)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _confirmBooking(booking);
              },
              child: const Text('Confirm'),
            ),
        ],
      ),
    );
  }

  void _confirmBooking(RentalBooking booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking for ${booking.farmerName} confirmed'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showNewBookingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Booking'),
        content: const Text('New booking feature coming soon!'),
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
