class Service {
  final String id;
  final String providerId;
  final String name;
  final String description;
  final ServiceCategory category;
  final double price;
  final PricingType pricingType;
  final int duration; // in minutes
  final List<String> tags;
  final bool isActive;
  final bool isAvailable;
  final List<String> imageUrls;
  final ServiceAvailability availability;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  Service({
    required this.id,
    required this.providerId,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.pricingType,
    required this.duration,
    required this.tags,
    this.isActive = true,
    this.isAvailable = true,
    required this.imageUrls,
    required this.availability,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      providerId: json['providerId'],
      name: json['name'],
      description: json['description'],
      category: ServiceCategory.values.firstWhere(
        (e) => e.toString().split('.').last == json['category'],
      ),
      price: (json['price'] ?? 0.0).toDouble(),
      pricingType: PricingType.values.firstWhere(
        (e) => e.toString().split('.').last == json['pricingType'],
      ),
      duration: json['duration'] ?? 60,
      tags: List<String>.from(json['tags'] ?? []),
      isActive: json['isActive'] ?? true,
      isAvailable: json['isAvailable'] ?? true,
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      availability: ServiceAvailability.fromJson(json['availability'] ?? {}),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'providerId': providerId,
      'name': name,
      'description': description,
      'category': category.toString().split('.').last,
      'price': price,
      'pricingType': pricingType.toString().split('.').last,
      'duration': duration,
      'tags': tags,
      'isActive': isActive,
      'isAvailable': isAvailable,
      'imageUrls': imageUrls,
      'availability': availability.toJson(),
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Service copyWith({
    String? id,
    String? providerId,
    String? name,
    String? description,
    ServiceCategory? category,
    double? price,
    PricingType? pricingType,
    int? duration,
    List<String>? tags,
    bool? isActive,
    bool? isAvailable,
    List<String>? imageUrls,
    ServiceAvailability? availability,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Service(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      pricingType: pricingType ?? this.pricingType,
      duration: duration ?? this.duration,
      tags: tags ?? this.tags,
      isActive: isActive ?? this.isActive,
      isAvailable: isAvailable ?? this.isAvailable,
      imageUrls: imageUrls ?? this.imageUrls,
      availability: availability ?? this.availability,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum ServiceCategory {
  veterinaryConsultation,
  vaccination,
  surgery,
  diagnostics,
  animalNutrition,
  breeding,
  farmEquipment,
  seeds,
  fertilizers,
  pesticides,
  animalFeed,
  farmSupplies,
  machinery,
  delivery,
  training,
  consultation,
}

extension ServiceCategoryExtension on ServiceCategory {
  String get displayName {
    switch (this) {
      case ServiceCategory.veterinaryConsultation:
        return 'Veterinary Consultation';
      case ServiceCategory.vaccination:
        return 'Vaccination';
      case ServiceCategory.surgery:
        return 'Surgery';
      case ServiceCategory.diagnostics:
        return 'Diagnostics';
      case ServiceCategory.animalNutrition:
        return 'Animal Nutrition';
      case ServiceCategory.breeding:
        return 'Breeding Services';
      case ServiceCategory.farmEquipment:
        return 'Farm Equipment';
      case ServiceCategory.seeds:
        return 'Seeds';
      case ServiceCategory.fertilizers:
        return 'Fertilizers';
      case ServiceCategory.pesticides:
        return 'Pesticides';
      case ServiceCategory.animalFeed:
        return 'Animal Feed';
      case ServiceCategory.farmSupplies:
        return 'Farm Supplies';
      case ServiceCategory.machinery:
        return 'Machinery';
      case ServiceCategory.delivery:
        return 'Delivery';
      case ServiceCategory.training:
        return 'Training';
      case ServiceCategory.consultation:
        return 'Consultation';
    }
  }

  String get icon {
    switch (this) {
      case ServiceCategory.veterinaryConsultation:
        return '🩺';
      case ServiceCategory.vaccination:
        return '💉';
      case ServiceCategory.surgery:
        return '🏥';
      case ServiceCategory.diagnostics:
        return '🔬';
      case ServiceCategory.animalNutrition:
        return '🥗';
      case ServiceCategory.breeding:
        return '🐄';
      case ServiceCategory.farmEquipment:
        return '🔧';
      case ServiceCategory.seeds:
        return '🌱';
      case ServiceCategory.fertilizers:
        return '🧪';
      case ServiceCategory.pesticides:
        return '🚿';
      case ServiceCategory.animalFeed:
        return '🌾';
      case ServiceCategory.farmSupplies:
        return '📦';
      case ServiceCategory.machinery:
        return '🚜';
      case ServiceCategory.delivery:
        return '🚚';
      case ServiceCategory.training:
        return '📚';
      case ServiceCategory.consultation:
        return '💬';
    }
  }
}

enum PricingType {
  fixed,
  hourly,
  perAnimal,
  perAcre,
  perKg,
  perLiter,
  perPiece,
  negotiable,
}

extension PricingTypeExtension on PricingType {
  String get displayName {
    switch (this) {
      case PricingType.fixed:
        return 'Fixed Price';
      case PricingType.hourly:
        return 'Per Hour';
      case PricingType.perAnimal:
        return 'Per Animal';
      case PricingType.perAcre:
        return 'Per Acre';
      case PricingType.perKg:
        return 'Per Kg';
      case PricingType.perLiter:
        return 'Per Liter';
      case PricingType.perPiece:
        return 'Per Piece';
      case PricingType.negotiable:
        return 'Negotiable';
    }
  }

  String get unit {
    switch (this) {
      case PricingType.fixed:
        return '';
      case PricingType.hourly:
        return '/hr';
      case PricingType.perAnimal:
        return '/animal';
      case PricingType.perAcre:
        return '/acre';
      case PricingType.perKg:
        return '/kg';
      case PricingType.perLiter:
        return '/L';
      case PricingType.perPiece:
        return '/piece';
      case PricingType.negotiable:
        return '';
    }
  }
}

class ServiceAvailability {
  final Map<String, List<TimeSlot>> weeklySchedule;
  final List<DateTime> unavailableDates;
  final bool isAlwaysAvailable;
  final int advanceBookingDays;
  final int maxBookingsPerDay;

  ServiceAvailability({
    required this.weeklySchedule,
    required this.unavailableDates,
    this.isAlwaysAvailable = false,
    this.advanceBookingDays = 30,
    this.maxBookingsPerDay = 10,
  });

  factory ServiceAvailability.fromJson(Map<String, dynamic> json) {
    Map<String, List<TimeSlot>> schedule = {};
    if (json['weeklySchedule'] != null) {
      (json['weeklySchedule'] as Map<String, dynamic>).forEach((day, slots) {
        schedule[day] = (slots as List)
            .map((slot) => TimeSlot.fromJson(slot))
            .toList();
      });
    }

    return ServiceAvailability(
      weeklySchedule: schedule,
      unavailableDates: (json['unavailableDates'] as List?)
          ?.map((date) => DateTime.parse(date))
          .toList() ?? [],
      isAlwaysAvailable: json['isAlwaysAvailable'] ?? false,
      advanceBookingDays: json['advanceBookingDays'] ?? 30,
      maxBookingsPerDay: json['maxBookingsPerDay'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> schedule = {};
    weeklySchedule.forEach((day, slots) {
      schedule[day] = slots.map((slot) => slot.toJson()).toList();
    });

    return {
      'weeklySchedule': schedule,
      'unavailableDates': unavailableDates.map((date) => date.toIso8601String()).toList(),
      'isAlwaysAvailable': isAlwaysAvailable,
      'advanceBookingDays': advanceBookingDays,
      'maxBookingsPerDay': maxBookingsPerDay,
    };
  }
}

class TimeSlot {
  final String startTime;
  final String endTime;
  final bool isAvailable;

  TimeSlot({
    required this.startTime,
    required this.endTime,
    this.isAvailable = true,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      startTime: json['startTime'],
      endTime: json['endTime'],
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'isAvailable': isAvailable,
    };
  }
}
