// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BusinessRegistrationImpl _$$BusinessRegistrationImplFromJson(
        Map<String, dynamic> json) =>
    _$BusinessRegistrationImpl(
      businessName: json['businessName'] as String,
      registrationNumber: json['registrationNumber'] as String,
      taxId: json['taxId'] as String,
      licenseNumber: json['licenseNumber'] as String?,
      licenseExpiryDate: json['licenseExpiryDate'] == null
          ? null
          : DateTime.parse(json['licenseExpiryDate'] as String),
      businessType: json['businessType'] as String,
      registrationCountry: json['registrationCountry'] as String,
      registrationState: json['registrationState'] as String,
      registrationCity: json['registrationCity'] as String,
      registrationDate: DateTime.parse(json['registrationDate'] as String),
      certifications: (json['certifications'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      additionalDocuments: json['additionalDocuments'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$BusinessRegistrationImplToJson(
        _$BusinessRegistrationImpl instance) =>
    <String, dynamic>{
      'businessName': instance.businessName,
      'registrationNumber': instance.registrationNumber,
      'taxId': instance.taxId,
      'licenseNumber': instance.licenseNumber,
      'licenseExpiryDate': instance.licenseExpiryDate?.toIso8601String(),
      'businessType': instance.businessType,
      'registrationCountry': instance.registrationCountry,
      'registrationState': instance.registrationState,
      'registrationCity': instance.registrationCity,
      'registrationDate': instance.registrationDate.toIso8601String(),
      'certifications': instance.certifications,
      'additionalDocuments': instance.additionalDocuments,
    };

_$ProfessionalQualificationImpl _$$ProfessionalQualificationImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfessionalQualificationImpl(
      id: json['id'] as String,
      qualificationType: json['qualificationType'] as String,
      institution: json['institution'] as String,
      degree: json['degree'] as String,
      fieldOfStudy: json['fieldOfStudy'] as String,
      graduationDate: DateTime.parse(json['graduationDate'] as String),
      licenseNumber: json['licenseNumber'] as String?,
      licenseExpiryDate: json['licenseExpiryDate'] == null
          ? null
          : DateTime.parse(json['licenseExpiryDate'] as String),
      issuingAuthority: json['issuingAuthority'] as String?,
      specializations: (json['specializations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isVerified: json['isVerified'] as bool?,
      verificationDate: json['verificationDate'] == null
          ? null
          : DateTime.parse(json['verificationDate'] as String),
      verificationNotes: json['verificationNotes'] as String?,
    );

Map<String, dynamic> _$$ProfessionalQualificationImplToJson(
        _$ProfessionalQualificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'qualificationType': instance.qualificationType,
      'institution': instance.institution,
      'degree': instance.degree,
      'fieldOfStudy': instance.fieldOfStudy,
      'graduationDate': instance.graduationDate.toIso8601String(),
      'licenseNumber': instance.licenseNumber,
      'licenseExpiryDate': instance.licenseExpiryDate?.toIso8601String(),
      'issuingAuthority': instance.issuingAuthority,
      'specializations': instance.specializations,
      'isVerified': instance.isVerified,
      'verificationDate': instance.verificationDate?.toIso8601String(),
      'verificationNotes': instance.verificationNotes,
    };

_$ServiceOfferingImpl _$$ServiceOfferingImplFromJson(
        Map<String, dynamic> json) =>
    _$ServiceOfferingImpl(
      id: json['id'] as String,
      serviceName: json['serviceName'] as String,
      description: json['description'] as String,
      category: $enumDecode(_$ServiceCategoryEnumMap, json['category']),
      subCategories: (json['subCategories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      basePrice: (json['basePrice'] as num).toDouble(),
      pricingModel: json['pricingModel'] as String,
      currency: json['currency'] as String?,
      estimatedDuration: (json['estimatedDuration'] as num).toInt(),
      serviceAreas: (json['serviceAreas'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      maxTravelDistance: (json['maxTravelDistance'] as num).toInt(),
      travelCostPerKm: (json['travelCostPerKm'] as num?)?.toDouble(),
      isActive: json['isActive'] as bool,
      additionalDetails: json['additionalDetails'] as Map<String, dynamic>?,
      requiredEquipment: (json['requiredEquipment'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      prerequisites: (json['prerequisites'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ServiceOfferingImplToJson(
        _$ServiceOfferingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serviceName': instance.serviceName,
      'description': instance.description,
      'category': _$ServiceCategoryEnumMap[instance.category]!,
      'subCategories': instance.subCategories,
      'basePrice': instance.basePrice,
      'pricingModel': instance.pricingModel,
      'currency': instance.currency,
      'estimatedDuration': instance.estimatedDuration,
      'serviceAreas': instance.serviceAreas,
      'maxTravelDistance': instance.maxTravelDistance,
      'travelCostPerKm': instance.travelCostPerKm,
      'isActive': instance.isActive,
      'additionalDetails': instance.additionalDetails,
      'requiredEquipment': instance.requiredEquipment,
      'prerequisites': instance.prerequisites,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$ServiceCategoryEnumMap = {
  ServiceCategory.animalHealth: 'animal_health',
  ServiceCategory.cropProtection: 'crop_protection',
  ServiceCategory.soilManagement: 'soil_management',
  ServiceCategory.irrigation: 'irrigation',
  ServiceCategory.machinery: 'machinery',
  ServiceCategory.seedsFertilizers: 'seeds_fertilizers',
  ServiceCategory.transportation: 'transportation',
  ServiceCategory.storage: 'storage',
  ServiceCategory.processing: 'processing',
  ServiceCategory.marketing: 'marketing',
  ServiceCategory.finance: 'finance',
  ServiceCategory.insurance: 'insurance',
  ServiceCategory.training: 'training',
  ServiceCategory.certification: 'certification',
};

_$PerformanceMetricsImpl _$$PerformanceMetricsImplFromJson(
        Map<String, dynamic> json) =>
    _$PerformanceMetricsImpl(
      providerId: json['providerId'] as String,
      totalBookings: (json['totalBookings'] as num).toInt(),
      completedBookings: (json['completedBookings'] as num).toInt(),
      cancelledBookings: (json['cancelledBookings'] as num).toInt(),
      completionRate: (json['completionRate'] as num).toDouble(),
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: (json['totalReviews'] as num).toInt(),
      responseTime: (json['responseTime'] as num).toDouble(),
      onTimeRate: (json['onTimeRate'] as num).toDouble(),
      repeatCustomers: (json['repeatCustomers'] as num).toInt(),
      revenue: (json['revenue'] as num).toDouble(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      ratingDistribution:
          (json['ratingDistribution'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      monthlyMetrics: (json['monthlyMetrics'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      topServices: (json['topServices'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      serviceAreas: (json['serviceAreas'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$PerformanceMetricsImplToJson(
        _$PerformanceMetricsImpl instance) =>
    <String, dynamic>{
      'providerId': instance.providerId,
      'totalBookings': instance.totalBookings,
      'completedBookings': instance.completedBookings,
      'cancelledBookings': instance.cancelledBookings,
      'completionRate': instance.completionRate,
      'averageRating': instance.averageRating,
      'totalReviews': instance.totalReviews,
      'responseTime': instance.responseTime,
      'onTimeRate': instance.onTimeRate,
      'repeatCustomers': instance.repeatCustomers,
      'revenue': instance.revenue,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'ratingDistribution': instance.ratingDistribution,
      'monthlyMetrics': instance.monthlyMetrics,
      'topServices': instance.topServices,
      'serviceAreas': instance.serviceAreas,
    };

_$VerificationDocumentImpl _$$VerificationDocumentImplFromJson(
        Map<String, dynamic> json) =>
    _$VerificationDocumentImpl(
      id: json['id'] as String,
      documentType: json['documentType'] as String,
      fileName: json['fileName'] as String,
      fileUrl: json['fileUrl'] as String,
      uploadedBy: json['uploadedBy'] as String,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      verificationStatus: $enumDecodeNullable(
          _$VerificationStatusEnumMap, json['verificationStatus']),
      verifiedBy: json['verifiedBy'] as String?,
      verifiedAt: json['verifiedAt'] == null
          ? null
          : DateTime.parse(json['verifiedAt'] as String),
      verificationNotes: json['verificationNotes'] as String?,
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$VerificationDocumentImplToJson(
        _$VerificationDocumentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'documentType': instance.documentType,
      'fileName': instance.fileName,
      'fileUrl': instance.fileUrl,
      'uploadedBy': instance.uploadedBy,
      'uploadedAt': instance.uploadedAt.toIso8601String(),
      'verificationStatus':
          _$VerificationStatusEnumMap[instance.verificationStatus],
      'verifiedBy': instance.verifiedBy,
      'verifiedAt': instance.verifiedAt?.toIso8601String(),
      'verificationNotes': instance.verificationNotes,
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$VerificationStatusEnumMap = {
  VerificationStatus.pending: 'pending',
  VerificationStatus.underReview: 'under_review',
  VerificationStatus.verified: 'verified',
  VerificationStatus.rejected: 'rejected',
  VerificationStatus.suspended: 'suspended',
  VerificationStatus.expired: 'expired',
};

_$ServiceProviderImpl _$$ServiceProviderImplFromJson(
        Map<String, dynamic> json) =>
    _$ServiceProviderImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      alternatePhone: json['alternatePhone'] as String?,
      profilePicture: json['profilePicture'] as String,
      providerType:
          $enumDecode(_$ServiceProviderTypeEnumMap, json['providerType']),
      verificationStatus:
          $enumDecode(_$VerificationStatusEnumMap, json['verificationStatus']),
      businessRegistration: BusinessRegistration.fromJson(
          json['businessRegistration'] as Map<String, dynamic>),
      qualifications: (json['qualifications'] as List<dynamic>)
          .map((e) =>
              ProfessionalQualification.fromJson(e as Map<String, dynamic>))
          .toList(),
      services: (json['services'] as List<dynamic>)
          .map((e) => ServiceOffering.fromJson(e as Map<String, dynamic>))
          .toList(),
      documents: (json['documents'] as List<dynamic>)
          .map((e) => VerificationDocument.fromJson(e as Map<String, dynamic>))
          .toList(),
      performanceMetrics: PerformanceMetrics.fromJson(
          json['performanceMetrics'] as Map<String, dynamic>),
      serviceAreas: (json['serviceAreas'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      postalCode: json['postalCode'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isActive: json['isActive'] as bool,
      isAvailable: json['isAvailable'] as bool,
      bio: json['bio'] as String?,
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      socialMedia: (json['socialMedia'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      website: json['website'] as String?,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      verifiedAt: json['verifiedAt'] == null
          ? null
          : DateTime.parse(json['verifiedAt'] as String),
      verifiedBy: json['verifiedBy'] as String?,
      lastActiveAt: json['lastActiveAt'] == null
          ? null
          : DateTime.parse(json['lastActiveAt'] as String),
      suspensionReason: json['suspensionReason'] as String?,
      suspendedAt: json['suspendedAt'] == null
          ? null
          : DateTime.parse(json['suspendedAt'] as String),
      suspendedBy: json['suspendedBy'] as String?,
      settings: json['settings'] as Map<String, dynamic>?,
      preferences: json['preferences'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ServiceProviderImplToJson(
        _$ServiceProviderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'alternatePhone': instance.alternatePhone,
      'profilePicture': instance.profilePicture,
      'providerType': _$ServiceProviderTypeEnumMap[instance.providerType]!,
      'verificationStatus':
          _$VerificationStatusEnumMap[instance.verificationStatus]!,
      'businessRegistration': instance.businessRegistration,
      'qualifications': instance.qualifications,
      'services': instance.services,
      'documents': instance.documents,
      'performanceMetrics': instance.performanceMetrics,
      'serviceAreas': instance.serviceAreas,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'postalCode': instance.postalCode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'isActive': instance.isActive,
      'isAvailable': instance.isAvailable,
      'bio': instance.bio,
      'languages': instance.languages,
      'socialMedia': instance.socialMedia,
      'website': instance.website,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'verifiedAt': instance.verifiedAt?.toIso8601String(),
      'verifiedBy': instance.verifiedBy,
      'lastActiveAt': instance.lastActiveAt?.toIso8601String(),
      'suspensionReason': instance.suspensionReason,
      'suspendedAt': instance.suspendedAt?.toIso8601String(),
      'suspendedBy': instance.suspendedBy,
      'settings': instance.settings,
      'preferences': instance.preferences,
    };

const _$ServiceProviderTypeEnumMap = {
  ServiceProviderType.veterinarian: 'veterinarian',
  ServiceProviderType.agriculturalConsultant: 'agricultural_consultant',
  ServiceProviderType.equipmentRental: 'equipment_rental',
  ServiceProviderType.inputSupplier: 'input_supplier',
  ServiceProviderType.logistics: 'logistics',
  ServiceProviderType.financialServices: 'financial_services',
  ServiceProviderType.insurance: 'insurance',
  ServiceProviderType.trainingProvider: 'training_provider',
  ServiceProviderType.marketLinkage: 'market_linkage',
  ServiceProviderType.other: 'other',
};

_$VerificationRequestImpl _$$VerificationRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$VerificationRequestImpl(
      id: json['id'] as String,
      providerId: json['providerId'] as String,
      providerName: json['providerName'] as String,
      providerEmail: json['providerEmail'] as String,
      providerType:
          $enumDecode(_$ServiceProviderTypeEnumMap, json['providerType']),
      status: $enumDecode(_$VerificationStatusEnumMap, json['status']),
      documentIds: (json['documentIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      requestedBy: json['requestedBy'] as String,
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      assignedTo: json['assignedTo'] as String?,
      assignedAt: json['assignedAt'] == null
          ? null
          : DateTime.parse(json['assignedAt'] as String),
      reviewedBy: json['reviewedBy'] as String?,
      reviewedAt: json['reviewedAt'] == null
          ? null
          : DateTime.parse(json['reviewedAt'] as String),
      reviewNotes: json['reviewNotes'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      requiredActions: (json['requiredActions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      priority: (json['priority'] as num?)?.toInt(),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$VerificationRequestImplToJson(
        _$VerificationRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'providerId': instance.providerId,
      'providerName': instance.providerName,
      'providerEmail': instance.providerEmail,
      'providerType': _$ServiceProviderTypeEnumMap[instance.providerType]!,
      'status': _$VerificationStatusEnumMap[instance.status]!,
      'documentIds': instance.documentIds,
      'requestedBy': instance.requestedBy,
      'requestedAt': instance.requestedAt.toIso8601String(),
      'assignedTo': instance.assignedTo,
      'assignedAt': instance.assignedAt?.toIso8601String(),
      'reviewedBy': instance.reviewedBy,
      'reviewedAt': instance.reviewedAt?.toIso8601String(),
      'reviewNotes': instance.reviewNotes,
      'rejectionReason': instance.rejectionReason,
      'requiredActions': instance.requiredActions,
      'priority': instance.priority,
      'dueDate': instance.dueDate?.toIso8601String(),
      'metadata': instance.metadata,
    };

_$ServiceProviderAnalyticsImpl _$$ServiceProviderAnalyticsImplFromJson(
        Map<String, dynamic> json) =>
    _$ServiceProviderAnalyticsImpl(
      providerId: json['providerId'] as String,
      periodStart: DateTime.parse(json['periodStart'] as String),
      periodEnd: DateTime.parse(json['periodEnd'] as String),
      totalBookings: (json['totalBookings'] as num).toInt(),
      newBookings: (json['newBookings'] as num).toInt(),
      completedBookings: (json['completedBookings'] as num).toInt(),
      cancelledBookings: (json['cancelledBookings'] as num).toInt(),
      revenue: (json['revenue'] as num).toDouble(),
      averageBookingValue: (json['averageBookingValue'] as num).toDouble(),
      customerSatisfaction: (json['customerSatisfaction'] as num).toDouble(),
      newCustomers: (json['newCustomers'] as num).toInt(),
      repeatCustomers: (json['repeatCustomers'] as num).toInt(),
      responseTime: (json['responseTime'] as num).toDouble(),
      completionTime: (json['completionTime'] as num).toDouble(),
      bookingsByService:
          (json['bookingsByService'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      revenueByService:
          (json['revenueByService'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      bookingsByArea: (json['bookingsByArea'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      monthlyTrends: (json['monthlyTrends'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      topPerformingServices: (json['topPerformingServices'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      improvementAreas: (json['improvementAreas'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$ServiceProviderAnalyticsImplToJson(
        _$ServiceProviderAnalyticsImpl instance) =>
    <String, dynamic>{
      'providerId': instance.providerId,
      'periodStart': instance.periodStart.toIso8601String(),
      'periodEnd': instance.periodEnd.toIso8601String(),
      'totalBookings': instance.totalBookings,
      'newBookings': instance.newBookings,
      'completedBookings': instance.completedBookings,
      'cancelledBookings': instance.cancelledBookings,
      'revenue': instance.revenue,
      'averageBookingValue': instance.averageBookingValue,
      'customerSatisfaction': instance.customerSatisfaction,
      'newCustomers': instance.newCustomers,
      'repeatCustomers': instance.repeatCustomers,
      'responseTime': instance.responseTime,
      'completionTime': instance.completionTime,
      'bookingsByService': instance.bookingsByService,
      'revenueByService': instance.revenueByService,
      'bookingsByArea': instance.bookingsByArea,
      'monthlyTrends': instance.monthlyTrends,
      'topPerformingServices': instance.topPerformingServices,
      'improvementAreas': instance.improvementAreas,
    };
