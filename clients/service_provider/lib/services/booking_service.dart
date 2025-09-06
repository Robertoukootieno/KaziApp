import '../models/models.dart';
import 'api_service.dart';

class BookingService {
  final ApiService _apiService = ApiService();
  
  // Singleton pattern
  static final BookingService _instance = BookingService._internal();
  factory BookingService() => _instance;
  BookingService._internal();

  Future<List<Booking>> getBookings({
    int page = 1,
    int limit = 20,
    BookingStatus? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // For now, return mock data since we don't have a real API
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate API call
    return _getMockBookings();
  }

  Future<Booking?> getBooking(String bookingId) async {
    try {
      final response = await _apiService.get<Booking>(
        ApiEndpoints.booking(bookingId),
        fromJson: (json) => Booking.fromJson(json),
      );

      if (response.isSuccess) {
        return response.data;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateBookingStatus(String bookingId, BookingStatus status, {String? notes}) async {
    try {
      final response = await _apiService.put(
        ApiEndpoints.updateBookingStatus(bookingId),
        body: {
          'status': status.toString().split('.').last,
          if (notes != null) 'notes': notes,
        },
      );

      return response.isSuccess;
    } catch (e) {
      return false;
    }
  }

  Future<bool> confirmBooking(String bookingId, {String? notes}) async {
    return updateBookingStatus(bookingId, BookingStatus.confirmed, notes: notes);
  }

  Future<bool> startBooking(String bookingId, {String? notes}) async {
    return updateBookingStatus(bookingId, BookingStatus.inProgress, notes: notes);
  }

  Future<bool> completeBooking(String bookingId, {String? notes}) async {
    return updateBookingStatus(bookingId, BookingStatus.completed, notes: notes);
  }

  Future<bool> cancelBooking(String bookingId, String reason) async {
    try {
      final response = await _apiService.put(
        ApiEndpoints.updateBookingStatus(bookingId),
        body: {
          'status': BookingStatus.cancelled.toString().split('.').last,
          'cancellationReason': reason,
        },
      );

      return response.isSuccess;
    } catch (e) {
      return false;
    }
  }

  Future<bool> rescheduleBooking(
    String bookingId,
    DateTime newDate,
    String newTime, {
    String? notes,
  }) async {
    try {
      final response = await _apiService.put(
        ApiEndpoints.booking(bookingId),
        body: {
          'scheduledDate': newDate.toIso8601String(),
          'scheduledTime': newTime,
          'status': BookingStatus.rescheduled.toString().split('.').last,
          if (notes != null) 'notes': notes,
        },
      );

      return response.isSuccess;
    } catch (e) {
      return false;
    }
  }

  Future<List<Booking>> getTodaysBookings() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final allBookings = _getMockBookings();
    final today = DateTime.now();

    return allBookings.where((booking) {
      return booking.scheduledDate.year == today.year &&
             booking.scheduledDate.month == today.month &&
             booking.scheduledDate.day == today.day;
    }).toList();
  }

  Future<List<Booking>> getUpcomingBookings({int days = 7}) async {
    final now = DateTime.now();
    final endDate = now.add(Duration(days: days));

    return getBookings(
      startDate: now,
      endDate: endDate,
      status: BookingStatus.confirmed,
    );
  }

  Future<List<Booking>> getPendingBookings() async {
    return getBookings(status: BookingStatus.pending);
  }

  Future<Map<String, int>> getBookingStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final bookings = _getMockBookings();

    return {
      'total': bookings.length,
      'pending': bookings.where((b) => b.status == BookingStatus.pending).length,
      'confirmed': bookings.where((b) => b.status == BookingStatus.confirmed).length,
      'completed': bookings.where((b) => b.status == BookingStatus.completed).length,
      'cancelled': bookings.where((b) => b.status == BookingStatus.cancelled).length,
    };
  }

  Future<List<String>> getAvailableTimeSlots(DateTime date, String serviceId) async {
    try {
      final response = await _apiService.get<List<String>>(
        '/provider/availability/slots',
        queryParams: {
          'date': date.toIso8601String().split('T')[0],
          'serviceId': serviceId,
        },
      );

      if (response.isSuccess && response.data != null) {
        return response.data!;
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> blockTimeSlot(DateTime date, String timeSlot, {String? reason}) async {
    try {
      final response = await _apiService.post(
        '/provider/availability/block',
        body: {
          'date': date.toIso8601String().split('T')[0],
          'timeSlot': timeSlot,
          if (reason != null) 'reason': reason,
        },
      );

      return response.isSuccess;
    } catch (e) {
      return false;
    }
  }

  Future<bool> unblockTimeSlot(DateTime date, String timeSlot) async {
    try {
      final response = await _apiService.delete(
        '/provider/availability/block',
      );

      return response.isSuccess;
    } catch (e) {
      return false;
    }
  }

  // Helper methods for booking filtering and sorting
  List<Booking> filterBookingsByStatus(List<Booking> bookings, BookingStatus status) {
    return bookings.where((booking) => booking.status == status).toList();
  }

  List<Booking> filterBookingsByDate(List<Booking> bookings, DateTime date) {
    return bookings.where((booking) {
      final bookingDate = booking.scheduledDate;
      return bookingDate.year == date.year &&
             bookingDate.month == date.month &&
             bookingDate.day == date.day;
    }).toList();
  }

  List<Booking> sortBookingsByDate(List<Booking> bookings, {bool ascending = true}) {
    final sorted = List<Booking>.from(bookings);
    sorted.sort((a, b) {
      final comparison = a.scheduledDate.compareTo(b.scheduledDate);
      return ascending ? comparison : -comparison;
    });
    return sorted;
  }

  List<Booking> sortBookingsByTime(List<Booking> bookings, {bool ascending = true}) {
    final sorted = List<Booking>.from(bookings);
    sorted.sort((a, b) {
      final comparison = a.scheduledTime.compareTo(b.scheduledTime);
      return ascending ? comparison : -comparison;
    });
    return sorted;
  }

  double calculateTotalRevenue(List<Booking> bookings) {
    return bookings
        .where((booking) => booking.status == BookingStatus.completed)
        .fold(0.0, (sum, booking) => sum + booking.totalAmount);
  }

  Map<BookingStatus, int> getBookingStatusCounts(List<Booking> bookings) {
    final counts = <BookingStatus, int>{};
    
    for (final status in BookingStatus.values) {
      counts[status] = bookings.where((booking) => booking.status == status).length;
    }
    
    return counts;
  }

  List<Booking> searchBookings(List<Booking> bookings, String query) {
    final lowercaseQuery = query.toLowerCase();
    
    return bookings.where((booking) {
      return booking.customerName.toLowerCase().contains(lowercaseQuery) ||
             booking.customerPhone.contains(query) ||
             booking.customerEmail.toLowerCase().contains(lowercaseQuery) ||
             (booking.notes?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }

  // Mock data for testing
  List<Booking> _getMockBookings() {
    return [
      Booking(
        id: '1',
        serviceId: 'service1',
        providerId: 'provider1',
        customerId: 'customer1',
        customerName: 'John Kamau',
        customerPhone: '+254712345678',
        customerEmail: 'john@example.com',
        customerLocation: 'Nakuru',
        scheduledDate: DateTime.now().add(const Duration(days: 1)),
        scheduledTime: '10:00 AM',
        status: BookingStatus.confirmed,
        totalAmount: 2500.0,
        paymentStatus: PaymentStatus.pending,
        items: [],
        attachments: [],
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now(),
      ),
      Booking(
        id: '2',
        serviceId: 'service2',
        providerId: 'provider1',
        customerId: 'customer2',
        customerName: 'Mary Wanjiku',
        customerPhone: '+254723456789',
        customerEmail: 'mary@example.com',
        customerLocation: 'Eldoret',
        scheduledDate: DateTime.now(),
        scheduledTime: '2:00 PM',
        status: BookingStatus.pending,
        totalAmount: 1200.0,
        paymentStatus: PaymentStatus.pending,
        items: [],
        attachments: [],
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}
