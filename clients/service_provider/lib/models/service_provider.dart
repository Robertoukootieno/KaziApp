class ServiceProvider {
  final String id;
  final String businessName;
  final String email;
  final String phoneNumber;
  final String location;
  final ServiceType serviceType;
  final String? description;
  final String? profileImageUrl;
  final BusinessDetails businessDetails;
  final List<String> serviceAreas;
  final List<Certification> certifications;
  final double rating;
  final int totalReviews;
  final bool isVerified;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceProvider({
    required this.id,
    required this.businessName,
    required this.email,
    required this.phoneNumber,
    required this.location,
    required this.serviceType,
    this.description,
    this.profileImageUrl,
    required this.businessDetails,
    required this.serviceAreas,
    required this.certifications,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.isVerified = false,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) {
    return ServiceProvider(
      id: json['id'],
      businessName: json['businessName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      location: json['location'],
      serviceType: ServiceType.values.firstWhere(
        (e) => e.toString().split('.').last == json['serviceType'],
      ),
      description: json['description'],
      profileImageUrl: json['profileImageUrl'],
      businessDetails: BusinessDetails.fromJson(json['businessDetails']),
      serviceAreas: List<String>.from(json['serviceAreas'] ?? []),
      certifications: (json['certifications'] as List?)
          ?.map((cert) => Certification.fromJson(cert))
          .toList() ?? [],
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      isVerified: json['isVerified'] ?? false,
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'businessName': businessName,
      'email': email,
      'phoneNumber': phoneNumber,
      'location': location,
      'serviceType': serviceType.toString().split('.').last,
      'description': description,
      'profileImageUrl': profileImageUrl,
      'businessDetails': businessDetails.toJson(),
      'serviceAreas': serviceAreas,
      'certifications': certifications.map((cert) => cert.toJson()).toList(),
      'rating': rating,
      'totalReviews': totalReviews,
      'isVerified': isVerified,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ServiceProvider copyWith({
    String? id,
    String? businessName,
    String? email,
    String? phoneNumber,
    String? location,
    ServiceType? serviceType,
    String? description,
    String? profileImageUrl,
    BusinessDetails? businessDetails,
    List<String>? serviceAreas,
    List<Certification>? certifications,
    double? rating,
    int? totalReviews,
    bool? isVerified,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceProvider(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      serviceType: serviceType ?? this.serviceType,
      description: description ?? this.description,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      businessDetails: businessDetails ?? this.businessDetails,
      serviceAreas: serviceAreas ?? this.serviceAreas,
      certifications: certifications ?? this.certifications,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum ServiceType {
  veterinarian,
  agrovet,
  retailer,
  supermarket,
  machinery,
  feedSupplier,
  seedsSupplier,
  fertilizerSupplier,
}

extension ServiceTypeExtension on ServiceType {
  String get displayName {
    switch (this) {
      case ServiceType.veterinarian:
        return 'Veterinarian';
      case ServiceType.agrovet:
        return 'Agrovet';
      case ServiceType.retailer:
        return 'Retailer';
      case ServiceType.supermarket:
        return 'Supermarket';
      case ServiceType.machinery:
        return 'Machinery Provider';
      case ServiceType.feedSupplier:
        return 'Feed Supplier';
      case ServiceType.seedsSupplier:
        return 'Seeds Supplier';
      case ServiceType.fertilizerSupplier:
        return 'Fertilizer Supplier';
    }
  }

  String get icon {
    switch (this) {
      case ServiceType.veterinarian:
        return '🏥';
      case ServiceType.agrovet:
        return '🏪';
      case ServiceType.retailer:
        return '🛒';
      case ServiceType.supermarket:
        return '🏬';
      case ServiceType.machinery:
        return '🚚';
      case ServiceType.feedSupplier:
        return '🌾';
      case ServiceType.seedsSupplier:
        return '🌱';
      case ServiceType.fertilizerSupplier:
        return '🧪';
    }
  }

  String get description {
    switch (this) {
      case ServiceType.veterinarian:
        return 'Animal health services';
      case ServiceType.agrovet:
        return 'Agricultural supplies & medicines';
      case ServiceType.retailer:
        return 'Farm products & equipment';
      case ServiceType.supermarket:
        return 'Large scale retail';
      case ServiceType.machinery:
        return 'Farm equipment & machinery';
      case ServiceType.feedSupplier:
        return 'Animal feed & nutrition';
      case ServiceType.seedsSupplier:
        return 'Quality seeds & planting materials';
      case ServiceType.fertilizerSupplier:
        return 'Fertilizers & soil amendments';
    }
  }
}

class BusinessDetails {
  final String? registrationNumber;
  final String? taxNumber;
  final String? licenseNumber;
  final String? address;
  final String? website;
  final Map<String, String> operatingHours;
  final List<String> paymentMethods;
  final bool hasDelivery;
  final double? deliveryRadius;
  final double? deliveryFee;

  BusinessDetails({
    this.registrationNumber,
    this.taxNumber,
    this.licenseNumber,
    this.address,
    this.website,
    required this.operatingHours,
    required this.paymentMethods,
    this.hasDelivery = false,
    this.deliveryRadius,
    this.deliveryFee,
  });

  factory BusinessDetails.fromJson(Map<String, dynamic> json) {
    return BusinessDetails(
      registrationNumber: json['registrationNumber'],
      taxNumber: json['taxNumber'],
      licenseNumber: json['licenseNumber'],
      address: json['address'],
      website: json['website'],
      operatingHours: Map<String, String>.from(json['operatingHours'] ?? {}),
      paymentMethods: List<String>.from(json['paymentMethods'] ?? []),
      hasDelivery: json['hasDelivery'] ?? false,
      deliveryRadius: json['deliveryRadius']?.toDouble(),
      deliveryFee: json['deliveryFee']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'registrationNumber': registrationNumber,
      'taxNumber': taxNumber,
      'licenseNumber': licenseNumber,
      'address': address,
      'website': website,
      'operatingHours': operatingHours,
      'paymentMethods': paymentMethods,
      'hasDelivery': hasDelivery,
      'deliveryRadius': deliveryRadius,
      'deliveryFee': deliveryFee,
    };
  }
}

class Certification {
  final String id;
  final String name;
  final String issuingAuthority;
  final DateTime issueDate;
  final DateTime? expiryDate;
  final String? certificateUrl;
  final bool isVerified;

  Certification({
    required this.id,
    required this.name,
    required this.issuingAuthority,
    required this.issueDate,
    this.expiryDate,
    this.certificateUrl,
    this.isVerified = false,
  });

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      id: json['id'],
      name: json['name'],
      issuingAuthority: json['issuingAuthority'],
      issueDate: DateTime.parse(json['issueDate']),
      expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
      certificateUrl: json['certificateUrl'],
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'issuingAuthority': issuingAuthority,
      'issueDate': issueDate.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'certificateUrl': certificateUrl,
      'isVerified': isVerified,
    };
  }

  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    final daysUntilExpiry = expiryDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 30 && daysUntilExpiry > 0;
  }
}
