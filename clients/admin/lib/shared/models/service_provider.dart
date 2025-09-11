import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_provider.freezed.dart';
part 'service_provider.g.dart';

/// Service provider verification status
enum VerificationStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('under_review')
  underReview,
  @JsonValue('verified')
  verified,
  @JsonValue('rejected')
  rejected,
  @JsonValue('suspended')
  suspended,
  @JsonValue('expired')
  expired,
}

/// Service provider types
enum ServiceProviderType {
  @JsonValue('veterinarian')
  veterinarian,
  @JsonValue('agricultural_consultant')
  agriculturalConsultant,
  @JsonValue('equipment_rental')
  equipmentRental,
  @JsonValue('input_supplier')
  inputSupplier,
  @JsonValue('logistics')
  logistics,
  @JsonValue('financial_services')
  financialServices,
  @JsonValue('insurance')
  insurance,
  @JsonValue('training_provider')
  trainingProvider,
  @JsonValue('market_linkage')
  marketLinkage,
  @JsonValue('other')
  other,
}

/// Service categories
enum ServiceCategory {
  @JsonValue('animal_health')
  animalHealth,
  @JsonValue('crop_protection')
  cropProtection,
  @JsonValue('soil_management')
  soilManagement,
  @JsonValue('irrigation')
  irrigation,
  @JsonValue('machinery')
  machinery,
  @JsonValue('seeds_fertilizers')
  seedsFertilizers,
  @JsonValue('transportation')
  transportation,
  @JsonValue('storage')
  storage,
  @JsonValue('processing')
  processing,
  @JsonValue('marketing')
  marketing,
  @JsonValue('finance')
  finance,
  @JsonValue('insurance')
  insurance,
  @JsonValue('training')
  training,
  @JsonValue('certification')
  certification,
}

/// Business registration information
@freezed
class BusinessRegistration with _$BusinessRegistration {
  const factory BusinessRegistration({
    required String businessName,
    required String registrationNumber,
    required String taxId,
    String? licenseNumber,
    DateTime? licenseExpiryDate,
    required String businessType,
    required String registrationCountry,
    required String registrationState,
    required String registrationCity,
    required DateTime registrationDate,
    List<String>? certifications,
    Map<String, dynamic>? additionalDocuments,
  }) = _BusinessRegistration;

  factory BusinessRegistration.fromJson(Map<String, dynamic> json) =>
      _$BusinessRegistrationFromJson(json);
}

/// Professional qualifications
@freezed
class ProfessionalQualification with _$ProfessionalQualification {
  const factory ProfessionalQualification({
    required String id,
    required String qualificationType,
    required String institution,
    required String degree,
    required String fieldOfStudy,
    required DateTime graduationDate,
    String? licenseNumber,
    DateTime? licenseExpiryDate,
    String? issuingAuthority,
    List<String>? specializations,
    bool? isVerified,
    DateTime? verificationDate,
    String? verificationNotes,
  }) = _ProfessionalQualification;

  factory ProfessionalQualification.fromJson(Map<String, dynamic> json) =>
      _$ProfessionalQualificationFromJson(json);
}

/// Service offering
@freezed
class ServiceOffering with _$ServiceOffering {
  const factory ServiceOffering({
    required String id,
    required String serviceName,
    required String description,
    required ServiceCategory category,
    required List<String> subCategories,
    required double basePrice,
    required String pricingModel, // 'fixed', 'hourly', 'per_unit', 'negotiable'
    String? currency,
    required int estimatedDuration, // in minutes
    required List<String> serviceAreas, // counties/regions served
    required int maxTravelDistance, // in kilometers
    double? travelCostPerKm,
    required bool isActive,
    Map<String, dynamic>? additionalDetails,
    List<String>? requiredEquipment,
    List<String>? prerequisites,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ServiceOffering;

  factory ServiceOffering.fromJson(Map<String, dynamic> json) =>
      _$ServiceOfferingFromJson(json);
}

/// Performance metrics
@freezed
class PerformanceMetrics with _$PerformanceMetrics {
  const factory PerformanceMetrics({
    required String providerId,
    required int totalBookings,
    required int completedBookings,
    required int cancelledBookings,
    required double completionRate,
    required double averageRating,
    required int totalReviews,
    required double responseTime, // average response time in hours
    required double onTimeRate,
    required int repeatCustomers,
    required double revenue,
    required DateTime lastUpdated,
    Map<String, int>? ratingDistribution,
    Map<String, double>? monthlyMetrics,
    List<String>? topServices,
    List<String>? serviceAreas,
  }) = _PerformanceMetrics;

  factory PerformanceMetrics.fromJson(Map<String, dynamic> json) =>
      _$PerformanceMetricsFromJson(json);
}

/// Verification document
@freezed
class VerificationDocument with _$VerificationDocument {
  const factory VerificationDocument({
    required String id,
    required String documentType,
    required String fileName,
    required String fileUrl,
    required String uploadedBy,
    required DateTime uploadedAt,
    VerificationStatus? verificationStatus,
    String? verifiedBy,
    DateTime? verifiedAt,
    String? verificationNotes,
    DateTime? expiryDate,
    Map<String, dynamic>? metadata,
  }) = _VerificationDocument;

  factory VerificationDocument.fromJson(Map<String, dynamic> json) =>
      _$VerificationDocumentFromJson(json);
}

/// Service provider profile
@freezed
class ServiceProvider with _$ServiceProvider {
  const factory ServiceProvider({
    required String id,
    required String userId,
    required String email,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    String? alternatePhone,
    required String profilePicture,
    required ServiceProviderType providerType,
    required VerificationStatus verificationStatus,
    required BusinessRegistration businessRegistration,
    required List<ProfessionalQualification> qualifications,
    required List<ServiceOffering> services,
    required List<VerificationDocument> documents,
    required PerformanceMetrics performanceMetrics,
    required List<String> serviceAreas,
    required String address,
    required String city,
    required String state,
    required String country,
    required String postalCode,
    double? latitude,
    double? longitude,
    required bool isActive,
    required bool isAvailable,
    String? bio,
    List<String>? languages,
    Map<String, String>? socialMedia,
    String? website,
    required DateTime joinedAt,
    DateTime? verifiedAt,
    String? verifiedBy,
    DateTime? lastActiveAt,
    String? suspensionReason,
    DateTime? suspendedAt,
    String? suspendedBy,
    Map<String, dynamic>? settings,
    Map<String, dynamic>? preferences,
  }) = _ServiceProvider;

  factory ServiceProvider.fromJson(Map<String, dynamic> json) =>
      _$ServiceProviderFromJson(json);
}

/// Verification request
@freezed
class VerificationRequest with _$VerificationRequest {
  const factory VerificationRequest({
    required String id,
    required String providerId,
    required String providerName,
    required String providerEmail,
    required ServiceProviderType providerType,
    required VerificationStatus status,
    required List<String> documentIds,
    required String requestedBy,
    required DateTime requestedAt,
    String? assignedTo,
    DateTime? assignedAt,
    String? reviewedBy,
    DateTime? reviewedAt,
    String? reviewNotes,
    String? rejectionReason,
    List<String>? requiredActions,
    int? priority,
    DateTime? dueDate,
    Map<String, dynamic>? metadata,
  }) = _VerificationRequest;

  factory VerificationRequest.fromJson(Map<String, dynamic> json) =>
      _$VerificationRequestFromJson(json);
}

/// Service provider analytics
@freezed
class ServiceProviderAnalytics with _$ServiceProviderAnalytics {
  const factory ServiceProviderAnalytics({
    required String providerId,
    required DateTime periodStart,
    required DateTime periodEnd,
    required int totalBookings,
    required int newBookings,
    required int completedBookings,
    required int cancelledBookings,
    required double revenue,
    required double averageBookingValue,
    required double customerSatisfaction,
    required int newCustomers,
    required int repeatCustomers,
    required double responseTime,
    required double completionTime,
    Map<String, int>? bookingsByService,
    Map<String, double>? revenueByService,
    Map<String, int>? bookingsByArea,
    Map<String, double>? monthlyTrends,
    List<String>? topPerformingServices,
    List<String>? improvementAreas,
  }) = _ServiceProviderAnalytics;

  factory ServiceProviderAnalytics.fromJson(Map<String, dynamic> json) =>
      _$ServiceProviderAnalyticsFromJson(json);
}

/// Helper class for service provider management
class ServiceProviderHelper {
  static String getVerificationStatusLabel(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.pending:
        return 'Pending Review';
      case VerificationStatus.underReview:
        return 'Under Review';
      case VerificationStatus.verified:
        return 'Verified';
      case VerificationStatus.rejected:
        return 'Rejected';
      case VerificationStatus.suspended:
        return 'Suspended';
      case VerificationStatus.expired:
        return 'Expired';
    }
  }

  static String getProviderTypeLabel(ServiceProviderType type) {
    switch (type) {
      case ServiceProviderType.veterinarian:
        return 'Veterinarian';
      case ServiceProviderType.agriculturalConsultant:
        return 'Agricultural Consultant';
      case ServiceProviderType.equipmentRental:
        return 'Equipment Rental';
      case ServiceProviderType.inputSupplier:
        return 'Input Supplier';
      case ServiceProviderType.logistics:
        return 'Logistics';
      case ServiceProviderType.financialServices:
        return 'Financial Services';
      case ServiceProviderType.insurance:
        return 'Insurance';
      case ServiceProviderType.trainingProvider:
        return 'Training Provider';
      case ServiceProviderType.marketLinkage:
        return 'Market Linkage';
      case ServiceProviderType.other:
        return 'Other';
    }
  }

  static bool isVerificationExpired(ServiceProvider provider) {
    if (provider.verificationStatus != VerificationStatus.verified) {
      return false;
    }
    
    // Check if any critical documents are expired
    final now = DateTime.now();
    return provider.documents.any((doc) => 
      doc.expiryDate != null && doc.expiryDate!.isBefore(now));
  }

  static double calculateCompletionRate(PerformanceMetrics metrics) {
    if (metrics.totalBookings == 0) return 0.0;
    return (metrics.completedBookings / metrics.totalBookings) * 100;
  }

  static String getPerformanceGrade(PerformanceMetrics metrics) {
    final completionRate = calculateCompletionRate(metrics);
    final rating = metrics.averageRating;
    
    if (completionRate >= 95 && rating >= 4.5) return 'A+';
    if (completionRate >= 90 && rating >= 4.0) return 'A';
    if (completionRate >= 85 && rating >= 3.5) return 'B+';
    if (completionRate >= 80 && rating >= 3.0) return 'B';
    if (completionRate >= 70 && rating >= 2.5) return 'C';
    return 'D';
  }
}
