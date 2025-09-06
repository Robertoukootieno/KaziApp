import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../services/services.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  final BookingService _bookingService = BookingService();

  late TabController _tabController;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  List<Booking> _allBookings = [];
  List<Booking> _selectedDayBookings = [];
  final Map<DateTime, List<Booking>> _bookingsByDate = {};
  bool _isLoading = true;

  BookingStatus? _statusFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final bookings = await _bookingService.getBookings();
      setState(() {
        _allBookings = bookings;
        _organizeBookingsByDate();
        _updateSelectedDayBookings();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading bookings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _organizeBookingsByDate() {
    _bookingsByDate.clear();
    for (final booking in _allBookings) {
      final date = DateTime(
        booking.scheduledDate.year,
        booking.scheduledDate.month,
        booking.scheduledDate.day,
      );

      if (_bookingsByDate[date] == null) {
        _bookingsByDate[date] = [];
      }
      _bookingsByDate[date]!.add(booking);
    }
  }

  void _updateSelectedDayBookings() {
    final selectedDate = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
    );

    setState(() {
      _selectedDayBookings = _bookingsByDate[selectedDate] ?? [];
    });
  }

  List<Booking> _getBookingsForDay(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    return _bookingsByDate[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.calendar_today), text: 'Calendar'),
            Tab(icon: Icon(Icons.list), text: 'All'),
            Tab(icon: Icon(Icons.pending), text: 'Pending'),
            Tab(icon: Icon(Icons.today), text: 'Today'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _showFilterDialog,
            icon: const Icon(Icons.filter_list),
          ),
          IconButton(
            onPressed: _loadBookings,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildCalendarTab(),
                _buildAllBookingsTab(),
                _buildPendingBookingsTab(),
                _buildTodayBookingsTab(),
              ],
            ),
    );
  }

  Widget _buildCalendarTab() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: TableCalendar<Booking>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            eventLoader: _getBookingsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: false,
              weekendTextStyle: TextStyle(color: Colors.red),
              holidayTextStyle: TextStyle(color: Colors.red),
              markerDecoration: BoxDecoration(
                color: Color(0xFF2E7D32),
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Color(0xFF2E7D32),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              formatButtonTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _updateSelectedDayBookings();
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
          ),
        ),

        const Divider(height: 1),

        // Selected day bookings
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Bookings for ${DateFormat('EEEE, MMMM d, y').format(_selectedDay)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: _selectedDayBookings.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_busy,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No bookings for this day',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _selectedDayBookings.length,
                        itemBuilder: (context, index) {
                          final booking = _selectedDayBookings[index];
                          return _buildBookingCard(booking);
                        },
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAllBookingsTab() {
    final filteredBookings = _statusFilter != null
        ? _allBookings.where((b) => b.status == _statusFilter).toList()
        : _allBookings;

    return filteredBookings.isEmpty
        ? _buildEmptyState('No bookings found')
        : RefreshIndicator(
            onRefresh: _loadBookings,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredBookings.length,
              itemBuilder: (context, index) {
                final booking = filteredBookings[index];
                return _buildBookingCard(booking);
              },
            ),
          );
  }

  Widget _buildPendingBookingsTab() {
    final pendingBookings = _allBookings
        .where((booking) => booking.status == BookingStatus.pending)
        .toList();

    return pendingBookings.isEmpty
        ? _buildEmptyState('No pending bookings')
        : RefreshIndicator(
            onRefresh: _loadBookings,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pendingBookings.length,
              itemBuilder: (context, index) {
                final booking = pendingBookings[index];
                return _buildBookingCard(booking, showActions: true);
              },
            ),
          );
  }

  Widget _buildTodayBookingsTab() {
    final today = DateTime.now();
    final todayBookings = _allBookings.where((booking) {
      return booking.scheduledDate.year == today.year &&
             booking.scheduledDate.month == today.month &&
             booking.scheduledDate.day == today.day;
    }).toList();

    return todayBookings.isEmpty
        ? _buildEmptyState('No bookings for today')
        : RefreshIndicator(
            onRefresh: _loadBookings,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: todayBookings.length,
              itemBuilder: (context, index) {
                final booking = todayBookings[index];
                return _buildBookingCard(booking, showActions: true);
              },
            ),
          );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bookings will appear here when customers make appointments',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Booking booking, {bool showActions = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
                children: [
                  CircleAvatar(
                    backgroundColor: _getStatusColor(booking.status).withValues(alpha: 0.1),
                    child: Icon(
                      _getStatusIcon(booking.status),
                      color: _getStatusColor(booking.status),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.customerName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          booking.customerPhone,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
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
                          color: _getStatusColor(booking.status).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          booking.status.displayName,
                          style: TextStyle(
                            color: _getStatusColor(booking.status),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'KSh ${booking.totalAmount.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
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
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('MMM d, y').format(booking.scheduledDate),
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    booking.scheduledTime,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              if (booking.customerLocation != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        booking.customerLocation!,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],

              if (booking.notes != null && booking.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  booking.notes!,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              if (showActions && booking.status == BookingStatus.pending) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _handleBookingAction(booking, 'reject'),
                        icon: const Icon(Icons.close, size: 18),
                        label: const Text('Reject'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _handleBookingAction(booking, 'confirm'),
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('Confirm'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
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

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.blue;
      case BookingStatus.inProgress:
        return Colors.purple;
      case BookingStatus.completed:
        return Colors.green;
      case BookingStatus.cancelled:
        return Colors.red;
      case BookingStatus.noShow:
        return Colors.grey;
      case BookingStatus.rescheduled:
        return Colors.amber;
    }
  }

  IconData _getStatusIcon(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Icons.schedule;
      case BookingStatus.confirmed:
        return Icons.check_circle;
      case BookingStatus.inProgress:
        return Icons.play_circle;
      case BookingStatus.completed:
        return Icons.check_circle_outline;
      case BookingStatus.cancelled:
        return Icons.cancel;
      case BookingStatus.noShow:
        return Icons.person_off;
      case BookingStatus.rescheduled:
        return Icons.update;
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Bookings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Filter by status:'),
            const SizedBox(height: 16),
            ...BookingStatus.values.map((status) {
              final isSelected = _statusFilter == status;
              return ListTile(
                title: Text(status.displayName),
                leading: Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: isSelected ? const Color(0xFF2E7D32) : Colors.grey,
                ),
                onTap: () {
                  setState(() {
                    _statusFilter = status;
                  });
                },
              );
            }),
            ListTile(
              title: const Text('All Bookings'),
              leading: Icon(
                _statusFilter == null ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: _statusFilter == null ? const Color(0xFF2E7D32) : Colors.grey,
              ),
              onTap: () {
                setState(() {
                  _statusFilter = null;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _updateSelectedDayBookings();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showBookingDetails(Booking booking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingDetailsScreen(
          booking: booking,
          onBookingUpdated: () {
            _loadBookings();
          },
        ),
      ),
    );
  }

  void _handleBookingAction(Booking booking, String action) async {
    bool success = false;
    String message = '';

    switch (action) {
      case 'confirm':
        success = await _bookingService.confirmBooking(booking.id);
        message = success ? 'Booking confirmed successfully' : 'Failed to confirm booking';
        break;
      case 'reject':
        success = await _bookingService.cancelBooking(booking.id, 'Rejected by service provider');
        message = success ? 'Booking rejected successfully' : 'Failed to reject booking';
        break;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? const Color(0xFF2E7D32) : Colors.red,
        ),
      );

      if (success) {
        _loadBookings();
      }
    }
  }
}

// Placeholder for BookingDetailsScreen - would be implemented separately
class BookingDetailsScreen extends StatelessWidget {
  final Booking booking;
  final VoidCallback onBookingUpdated;

  const BookingDetailsScreen({
    super.key,
    required this.booking,
    required this.onBookingUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Booking Details - To be implemented'),
      ),
    );
  }
}
