import '../models/models.dart';
import 'api_service.dart';

class CustomerService {
  final ApiService _apiService = ApiService();
  
  // Singleton pattern
  static final CustomerService _instance = CustomerService._internal();
  factory CustomerService() => _instance;
  CustomerService._internal();

  Future<List<Customer>> getCustomers({
    int page = 1,
    int limit = 20,
    String? search,
    CustomerType? type,
    bool? isActive,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _getMockCustomers();
  }

  Future<Customer?> getCustomer(String customerId) async {
    try {
      final response = await _apiService.get<Customer>(
        ApiEndpoints.customer(customerId),
        fromJson: (json) => Customer.fromJson(json),
      );

      if (response.isSuccess) {
        return response.data;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<CustomerInteraction>> getCustomerInteractions(String customerId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return []; // Return empty list for now
  }

  Future<bool> addCustomerInteraction({
    required String customerId,
    required InteractionType type,
    required String title,
    String? description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.customerInteractions(customerId),
        body: {
          'type': type.toString().split('.').last,
          'title': title,
          if (description != null) 'description': description,
          'metadata': metadata ?? {},
        },
      );

      return response.isSuccess;
    } catch (e) {
      return false;
    }
  }

  Future<List<Customer>> getTopCustomers({int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final customers = _getMockCustomers();
    customers.sort((a, b) => b.totalSpent.compareTo(a.totalSpent));
    return customers.take(limit).toList();
  }

  Future<List<Customer>> getRecentCustomers({int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _getMockCustomers().take(limit).toList();
  }

  Future<Map<String, dynamic>> getCustomerStats() async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '${ApiEndpoints.customers}/stats',
      );

      if (response.isSuccess && response.data != null) {
        return response.data!;
      }
      
      return {};
    } catch (e) {
      return {};
    }
  }

  Future<List<Customer>> searchCustomers(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final customers = _getMockCustomers();
    final lowercaseQuery = query.toLowerCase();

    return customers.where((customer) {
      return customer.name.toLowerCase().contains(lowercaseQuery) ||
             customer.phoneNumber.contains(query) ||
             customer.email.toLowerCase().contains(lowercaseQuery) ||
             customer.location.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Helper methods for customer management
  List<Customer> filterCustomersByType(List<Customer> customers, CustomerType type) {
    return customers.where((customer) => customer.customerType == type).toList();
  }

  List<Customer> filterActiveCustomers(List<Customer> customers) {
    return customers.where((customer) => customer.isActive).toList();
  }

  List<Customer> sortCustomersByName(List<Customer> customers, {bool ascending = true}) {
    final sorted = List<Customer>.from(customers);
    sorted.sort((a, b) {
      final comparison = a.name.compareTo(b.name);
      return ascending ? comparison : -comparison;
    });
    return sorted;
  }

  List<Customer> sortCustomersByTotalSpent(List<Customer> customers, {bool ascending = false}) {
    final sorted = List<Customer>.from(customers);
    sorted.sort((a, b) {
      final comparison = a.totalSpent.compareTo(b.totalSpent);
      return ascending ? comparison : -comparison;
    });
    return sorted;
  }

  List<Customer> sortCustomersByLastBooking(List<Customer> customers, {bool ascending = false}) {
    final sorted = List<Customer>.from(customers);
    sorted.sort((a, b) {
      if (a.lastBookingDate == null && b.lastBookingDate == null) return 0;
      if (a.lastBookingDate == null) return 1;
      if (b.lastBookingDate == null) return -1;
      
      final comparison = a.lastBookingDate!.compareTo(b.lastBookingDate!);
      return ascending ? comparison : -comparison;
    });
    return sorted;
  }

  Map<CustomerType, int> getCustomerTypeCounts(List<Customer> customers) {
    final counts = <CustomerType, int>{};
    
    for (final type in CustomerType.values) {
      counts[type] = customers.where((customer) => customer.customerType == type).length;
    }
    
    return counts;
  }

  double calculateTotalCustomerValue(List<Customer> customers) {
    return customers.fold(0.0, (sum, customer) => sum + customer.totalSpent);
  }

  double calculateAverageCustomerValue(List<Customer> customers) {
    if (customers.isEmpty) return 0.0;
    return calculateTotalCustomerValue(customers) / customers.length;
  }

  List<Customer> getHighValueCustomers(List<Customer> customers, double threshold) {
    return customers.where((customer) => customer.totalSpent >= threshold).toList();
  }

  List<Customer> getInactiveCustomers(List<Customer> customers, {int daysSinceLastBooking = 90}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysSinceLastBooking));
    
    return customers.where((customer) {
      if (customer.lastBookingDate == null) return true;
      return customer.lastBookingDate!.isBefore(cutoffDate);
    }).toList();
  }

  Map<String, int> getCustomersByLocation(List<Customer> customers) {
    final locationCounts = <String, int>{};
    
    for (final customer in customers) {
      locationCounts[customer.location] = (locationCounts[customer.location] ?? 0) + 1;
    }
    
    return locationCounts;
  }

  List<Customer> getCustomersWithFarms(List<Customer> customers) {
    return customers.where((customer) => customer.farmDetails != null).toList();
  }

  Map<String, int> getCropTypeCounts(List<Customer> customers) {
    final cropCounts = <String, int>{};
    
    for (final customer in customers) {
      if (customer.farmDetails != null) {
        for (final crop in customer.farmDetails!.cropTypes) {
          cropCounts[crop] = (cropCounts[crop] ?? 0) + 1;
        }
      }
    }
    
    return cropCounts;
  }

  Map<String, int> getLivestockTypeCounts(List<Customer> customers) {
    final livestockCounts = <String, int>{};
    
    for (final customer in customers) {
      if (customer.farmDetails != null) {
        for (final livestock in customer.farmDetails!.livestockTypes) {
          livestockCounts[livestock] = (livestockCounts[livestock] ?? 0) + 1;
        }
      }
    }
    
    return livestockCounts;
  }

  double calculateAverageFarmSize(List<Customer> customers) {
    final customersWithFarms = getCustomersWithFarms(customers);
    if (customersWithFarms.isEmpty) return 0.0;
    
    final totalFarmSize = customersWithFarms.fold(
      0.0,
      (sum, customer) => sum + customer.farmDetails!.farmSize,
    );
    
    return totalFarmSize / customersWithFarms.length;
  }

  // Mock data for testing
  List<Customer> _getMockCustomers() {
    return [
      Customer(
        id: '1',
        name: 'John Kamau',
        phoneNumber: '+254712345678',
        email: 'john@example.com',
        location: 'Nakuru',
        customerType: CustomerType.smallScaleFarmer,
        preferredServices: ['Veterinary', 'Crop Consultation'],
        isActive: true,
        totalSpent: 15000.0,
        totalBookings: 5,
        rating: 4.8,
        lastBookingDate: DateTime.now().subtract(const Duration(days: 10)),
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        updatedAt: DateTime.now(),
        farmDetails: FarmDetails(
          farmSize: 5.0,
          cropTypes: ['Maize', 'Beans'],
          livestockTypes: ['Cattle', 'Goats'],
          livestockCount: {'Cattle': 10, 'Goats': 25},
          farmingType: 'mixed',
          challenges: ['Pest control', 'Water shortage'],
          soilType: 'Clay loam',
          waterSource: 'Borehole',
        ),
      ),
      Customer(
        id: '2',
        name: 'Mary Wanjiku',
        phoneNumber: '+254723456789',
        email: 'mary@example.com',
        location: 'Eldoret',
        customerType: CustomerType.agribusiness,
        preferredServices: ['Equipment Rental', 'Training'],
        isActive: true,
        totalSpent: 8500.0,
        totalBookings: 3,
        rating: 4.5,
        lastBookingDate: DateTime.now().subtract(const Duration(days: 5)),
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}
