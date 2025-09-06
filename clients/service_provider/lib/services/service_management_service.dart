import 'dart:io';
import '../models/models.dart';
import 'api_service.dart';

class ServiceManagementService {
  final ApiService _apiService = ApiService();
  
  // Singleton pattern
  static final ServiceManagementService _instance = ServiceManagementService._internal();
  factory ServiceManagementService() => _instance;
  ServiceManagementService._internal();

  Future<List<Service>> getServices({
    int page = 1,
    int limit = 20,
    bool? isActive,
    ServiceCategory? category,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _getMockServices();
  }

  Future<Service?> getService(String serviceId) async {
    try {
      final response = await _apiService.get<Service>(
        ApiEndpoints.service(serviceId),
        fromJson: (json) => Service.fromJson(json),
      );

      if (response.isSuccess) {
        return response.data;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Service?> createService({
    required String name,
    required String description,
    required ServiceCategory category,
    required double price,
    required PricingType pricingType,
    required int duration,
    required List<String> tags,
    required ServiceAvailability availability,
    List<String>? imageUrls,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final serviceData = {
        'name': name,
        'description': description,
        'category': category.toString().split('.').last,
        'price': price,
        'pricingType': pricingType.toString().split('.').last,
        'duration': duration,
        'tags': tags,
        'availability': availability.toJson(),
        'imageUrls': imageUrls ?? [],
        'metadata': metadata ?? {},
        'isActive': true,
        'isAvailable': true,
      };

      final response = await _apiService.post<Service>(
        ApiEndpoints.services,
        body: serviceData,
        fromJson: (json) => Service.fromJson(json),
      );

      if (response.isSuccess) {
        return response.data;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Service?> updateService(String serviceId, {
    String? name,
    String? description,
    ServiceCategory? category,
    double? price,
    PricingType? pricingType,
    int? duration,
    List<String>? tags,
    bool? isActive,
    bool? isAvailable,
    ServiceAvailability? availability,
    List<String>? imageUrls,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      
      if (name != null) updateData['name'] = name;
      if (description != null) updateData['description'] = description;
      if (category != null) updateData['category'] = category.toString().split('.').last;
      if (price != null) updateData['price'] = price;
      if (pricingType != null) updateData['pricingType'] = pricingType.toString().split('.').last;
      if (duration != null) updateData['duration'] = duration;
      if (tags != null) updateData['tags'] = tags;
      if (isActive != null) updateData['isActive'] = isActive;
      if (isAvailable != null) updateData['isAvailable'] = isAvailable;
      if (availability != null) updateData['availability'] = availability.toJson();
      if (imageUrls != null) updateData['imageUrls'] = imageUrls;
      if (metadata != null) updateData['metadata'] = metadata;

      final response = await _apiService.put<Service>(
        ApiEndpoints.service(serviceId),
        body: updateData,
        fromJson: (json) => Service.fromJson(json),
      );

      if (response.isSuccess) {
        return response.data;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteService(String serviceId) async {
    try {
      final response = await _apiService.delete(
        ApiEndpoints.service(serviceId),
      );

      return response.isSuccess;
    } catch (e) {
      return false;
    }
  }

  Future<bool> toggleServiceStatus(String serviceId, bool isActive) async {
    try {
      final response = await _apiService.put(
        ApiEndpoints.service(serviceId),
        body: {'isActive': isActive},
      );

      return response.isSuccess;
    } catch (e) {
      return false;
    }
  }

  Future<bool> toggleServiceAvailability(String serviceId, bool isAvailable) async {
    try {
      final response = await _apiService.put(
        ApiEndpoints.service(serviceId),
        body: {'isAvailable': isAvailable},
      );

      return response.isSuccess;
    } catch (e) {
      return false;
    }
  }

  Future<List<String>> uploadServiceImages(List<File> images) async {
    final uploadedUrls = <String>[];
    
    for (final image in images) {
      try {
        final response = await _apiService.uploadFile(
          ApiEndpoints.uploadImage,
          image,
        );
        
        if (response.isSuccess && response.data != null) {
          uploadedUrls.add(response.data!);
        }
      } catch (e) {
        // Continue with other images even if one fails
        continue;
      }
    }
    
    return uploadedUrls;
  }

  Future<List<ServiceCategory>> getServiceCategories() async {
    try {
      final response = await _apiService.get<List<Map<String, dynamic>>>(
        ApiEndpoints.serviceCategories,
      );

      if (response.isSuccess && response.data != null) {
        return response.data!
            .map((categoryData) => ServiceCategory.values.firstWhere(
                  (e) => e.toString().split('.').last == categoryData['id'],
                ))
            .toList();
      }
      
      return ServiceCategory.values;
    } catch (e) {
      return ServiceCategory.values;
    }
  }

  Future<Map<String, dynamic>> getServiceStats(String serviceId) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '${ApiEndpoints.service(serviceId)}/stats',
      );

      if (response.isSuccess && response.data != null) {
        return response.data!;
      }
      
      return {};
    } catch (e) {
      return {};
    }
  }

  Future<List<Service>> getPopularServices({int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _getMockServices().take(limit).toList();
  }

  Future<List<Service>> searchServices(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final services = _getMockServices();
    final lowercaseQuery = query.toLowerCase();

    return services.where((service) {
      return service.name.toLowerCase().contains(lowercaseQuery) ||
             service.description.toLowerCase().contains(lowercaseQuery) ||
             service.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  // Helper methods for service management
  List<Service> filterServicesByCategory(List<Service> services, ServiceCategory category) {
    return services.where((service) => service.category == category).toList();
  }

  List<Service> filterActiveServices(List<Service> services) {
    return services.where((service) => service.isActive).toList();
  }

  List<Service> filterAvailableServices(List<Service> services) {
    return services.where((service) => service.isAvailable).toList();
  }

  List<Service> sortServicesByPrice(List<Service> services, {bool ascending = true}) {
    final sorted = List<Service>.from(services);
    sorted.sort((a, b) {
      final comparison = a.price.compareTo(b.price);
      return ascending ? comparison : -comparison;
    });
    return sorted;
  }

  List<Service> sortServicesByName(List<Service> services, {bool ascending = true}) {
    final sorted = List<Service>.from(services);
    sorted.sort((a, b) {
      final comparison = a.name.compareTo(b.name);
      return ascending ? comparison : -comparison;
    });
    return sorted;
  }

  List<Service> sortServicesByCreatedDate(List<Service> services, {bool ascending = true}) {
    final sorted = List<Service>.from(services);
    sorted.sort((a, b) {
      final comparison = a.createdAt.compareTo(b.createdAt);
      return ascending ? comparison : -comparison;
    });
    return sorted;
  }

  Map<ServiceCategory, int> getServiceCategoryCounts(List<Service> services) {
    final counts = <ServiceCategory, int>{};
    
    for (final category in ServiceCategory.values) {
      counts[category] = services.where((service) => service.category == category).length;
    }
    
    return counts;
  }

  double calculateAveragePrice(List<Service> services) {
    if (services.isEmpty) return 0.0;
    
    final totalPrice = services.fold(0.0, (sum, service) => sum + service.price);
    return totalPrice / services.length;
  }

  List<Service> getServicesByPriceRange(
    List<Service> services,
    double minPrice,
    double maxPrice,
  ) {
    return services.where((service) {
      return service.price >= minPrice && service.price <= maxPrice;
    }).toList();
  }

  // Mock data for testing
  List<Service> _getMockServices() {
    return [
      Service(
        id: '1',
        providerId: 'provider1',
        name: 'Cattle Vaccination',
        description: 'Complete vaccination service for cattle including FMD, Anthrax, and other common diseases.',
        category: ServiceCategory.vaccination,
        price: 2500.0,
        pricingType: PricingType.perAnimal,
        duration: 60,
        tags: ['vaccination', 'cattle', 'health'],
        isActive: true,
        isAvailable: true,
        imageUrls: [],
        metadata: {},
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
        availability: ServiceAvailability(
          weeklySchedule: {
            'monday': [],
            'tuesday': [],
            'wednesday': [],
            'thursday': [],
            'friday': [],
          },
          unavailableDates: [],
          maxBookingsPerDay: 10,
          advanceBookingDays: 7,
        ),
      ),
      Service(
        id: '2',
        providerId: 'provider1',
        name: 'Crop Consultation',
        description: 'Expert advice on crop management, pest control, and yield optimization.',
        category: ServiceCategory.consultation,
        price: 1500.0,
        pricingType: PricingType.hourly,
        duration: 90,
        tags: ['consultation', 'crops', 'farming'],
        isActive: true,
        isAvailable: true,
        imageUrls: [],
        metadata: {},
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now(),
        availability: ServiceAvailability(
          weeklySchedule: {
            'monday': [],
            'tuesday': [],
            'wednesday': [],
            'thursday': [],
            'friday': [],
            'saturday': [],
          },
          unavailableDates: [],
          maxBookingsPerDay: 8,
          advanceBookingDays: 3,
        ),
      ),
    ];
  }
}
