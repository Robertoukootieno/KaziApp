class Customer {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? profileImageUrl;
  final String location;
  final CustomerType customerType;
  final FarmDetails? farmDetails;
  final List<String> preferredServices;
  final double totalSpent;
  final int totalBookings;
  final double rating;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastBookingDate;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.profileImageUrl,
    required this.location,
    required this.customerType,
    this.farmDetails,
    required this.preferredServices,
    this.totalSpent = 0.0,
    this.totalBookings = 0,
    this.rating = 0.0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.lastBookingDate,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
      location: json['location'],
      customerType: CustomerType.values.firstWhere(
        (e) => e.toString().split('.').last == json['customerType'],
      ),
      farmDetails: json['farmDetails'] != null 
          ? FarmDetails.fromJson(json['farmDetails']) 
          : null,
      preferredServices: List<String>.from(json['preferredServices'] ?? []),
      totalSpent: (json['totalSpent'] ?? 0.0).toDouble(),
      totalBookings: json['totalBookings'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      lastBookingDate: json['lastBookingDate'] != null 
          ? DateTime.parse(json['lastBookingDate']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'location': location,
      'customerType': customerType.toString().split('.').last,
      'farmDetails': farmDetails?.toJson(),
      'preferredServices': preferredServices,
      'totalSpent': totalSpent,
      'totalBookings': totalBookings,
      'rating': rating,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastBookingDate': lastBookingDate?.toIso8601String(),
    };
  }

  Customer copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
    String? location,
    CustomerType? customerType,
    FarmDetails? farmDetails,
    List<String>? preferredServices,
    double? totalSpent,
    int? totalBookings,
    double? rating,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastBookingDate,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      location: location ?? this.location,
      customerType: customerType ?? this.customerType,
      farmDetails: farmDetails ?? this.farmDetails,
      preferredServices: preferredServices ?? this.preferredServices,
      totalSpent: totalSpent ?? this.totalSpent,
      totalBookings: totalBookings ?? this.totalBookings,
      rating: rating ?? this.rating,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastBookingDate: lastBookingDate ?? this.lastBookingDate,
    );
  }
}

enum CustomerType {
  smallScaleFarmer,
  mediumScaleFarmer,
  largeScaleFarmer,
  agribusiness,
  cooperative,
  individual,
}

extension CustomerTypeExtension on CustomerType {
  String get displayName {
    switch (this) {
      case CustomerType.smallScaleFarmer:
        return 'Small Scale Farmer';
      case CustomerType.mediumScaleFarmer:
        return 'Medium Scale Farmer';
      case CustomerType.largeScaleFarmer:
        return 'Large Scale Farmer';
      case CustomerType.agribusiness:
        return 'Agribusiness';
      case CustomerType.cooperative:
        return 'Cooperative';
      case CustomerType.individual:
        return 'Individual';
    }
  }

  String get icon {
    switch (this) {
      case CustomerType.smallScaleFarmer:
        return '🌱';
      case CustomerType.mediumScaleFarmer:
        return '🌾';
      case CustomerType.largeScaleFarmer:
        return '🚜';
      case CustomerType.agribusiness:
        return '🏢';
      case CustomerType.cooperative:
        return '🤝';
      case CustomerType.individual:
        return '👤';
    }
  }
}

class FarmDetails {
  final double farmSize; // in acres
  final List<String> cropTypes;
  final List<String> livestockTypes;
  final Map<String, int> livestockCount;
  final String farmingType; // organic, conventional, mixed
  final List<String> challenges;
  final String? soilType;
  final String? waterSource;

  FarmDetails({
    required this.farmSize,
    required this.cropTypes,
    required this.livestockTypes,
    required this.livestockCount,
    required this.farmingType,
    required this.challenges,
    this.soilType,
    this.waterSource,
  });

  factory FarmDetails.fromJson(Map<String, dynamic> json) {
    return FarmDetails(
      farmSize: (json['farmSize'] ?? 0.0).toDouble(),
      cropTypes: List<String>.from(json['cropTypes'] ?? []),
      livestockTypes: List<String>.from(json['livestockTypes'] ?? []),
      livestockCount: Map<String, int>.from(json['livestockCount'] ?? {}),
      farmingType: json['farmingType'] ?? 'conventional',
      challenges: List<String>.from(json['challenges'] ?? []),
      soilType: json['soilType'],
      waterSource: json['waterSource'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'farmSize': farmSize,
      'cropTypes': cropTypes,
      'livestockTypes': livestockTypes,
      'livestockCount': livestockCount,
      'farmingType': farmingType,
      'challenges': challenges,
      'soilType': soilType,
      'waterSource': waterSource,
    };
  }
}

class CustomerInteraction {
  final String id;
  final String customerId;
  final String providerId;
  final InteractionType type;
  final String title;
  final String? description;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;

  CustomerInteraction({
    required this.id,
    required this.customerId,
    required this.providerId,
    required this.type,
    required this.title,
    this.description,
    required this.metadata,
    required this.createdAt,
  });

  factory CustomerInteraction.fromJson(Map<String, dynamic> json) {
    return CustomerInteraction(
      id: json['id'],
      customerId: json['customerId'],
      providerId: json['providerId'],
      type: InteractionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      title: json['title'],
      description: json['description'],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'providerId': providerId,
      'type': type.toString().split('.').last,
      'title': title,
      'description': description,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

enum InteractionType {
  booking,
  call,
  message,
  email,
  visit,
  complaint,
  feedback,
  inquiry,
}

extension InteractionTypeExtension on InteractionType {
  String get displayName {
    switch (this) {
      case InteractionType.booking:
        return 'Booking';
      case InteractionType.call:
        return 'Phone Call';
      case InteractionType.message:
        return 'Message';
      case InteractionType.email:
        return 'Email';
      case InteractionType.visit:
        return 'Visit';
      case InteractionType.complaint:
        return 'Complaint';
      case InteractionType.feedback:
        return 'Feedback';
      case InteractionType.inquiry:
        return 'Inquiry';
    }
  }

  String get icon {
    switch (this) {
      case InteractionType.booking:
        return '📅';
      case InteractionType.call:
        return '📞';
      case InteractionType.message:
        return '💬';
      case InteractionType.email:
        return '📧';
      case InteractionType.visit:
        return '🏠';
      case InteractionType.complaint:
        return '⚠️';
      case InteractionType.feedback:
        return '⭐';
      case InteractionType.inquiry:
        return '❓';
    }
  }
}
