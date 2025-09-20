// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FarmLocationImpl _$$FarmLocationImplFromJson(Map<String, dynamic> json) =>
    _$FarmLocationImpl(
      county: json['county'] as String,
      subCounty: json['subCounty'] as String,
      ward: json['ward'] as String?,
      village: json['village'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      gpsCoordinates: json['gpsCoordinates'] as String?,
      elevation: (json['elevation'] as num?)?.toDouble(),
      soilType: json['soilType'] as String?,
      climateZone: json['climateZone'] as String?,
    );

Map<String, dynamic> _$$FarmLocationImplToJson(_$FarmLocationImpl instance) =>
    <String, dynamic>{
      'county': instance.county,
      'subCounty': instance.subCounty,
      'ward': instance.ward,
      'village': instance.village,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'gpsCoordinates': instance.gpsCoordinates,
      'elevation': instance.elevation,
      'soilType': instance.soilType,
      'climateZone': instance.climateZone,
    };

_$CropInfoImpl _$$CropInfoImplFromJson(Map<String, dynamic> json) =>
    _$CropInfoImpl(
      cropName: json['cropName'] as String,
      variety: json['variety'] as String,
      acreage: (json['acreage'] as num).toDouble(),
      plantingDate: json['plantingDate'] as String?,
      harvestDate: json['harvestDate'] as String?,
      growthStage: json['growthStage'] as String?,
      expectedYield: (json['expectedYield'] as num?)?.toDouble(),
      actualYield: (json['actualYield'] as num?)?.toDouble(),
      challenges: (json['challenges'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$CropInfoImplToJson(_$CropInfoImpl instance) =>
    <String, dynamic>{
      'cropName': instance.cropName,
      'variety': instance.variety,
      'acreage': instance.acreage,
      'plantingDate': instance.plantingDate,
      'harvestDate': instance.harvestDate,
      'growthStage': instance.growthStage,
      'expectedYield': instance.expectedYield,
      'actualYield': instance.actualYield,
      'challenges': instance.challenges,
      'additionalData': instance.additionalData,
    };

_$LivestockInfoImpl _$$LivestockInfoImplFromJson(Map<String, dynamic> json) =>
    _$LivestockInfoImpl(
      animalType: json['animalType'] as String,
      breed: json['breed'] as String,
      count: (json['count'] as num).toInt(),
      purpose: json['purpose'] as String?,
      averageAge: (json['averageAge'] as num?)?.toInt(),
      healthStatus: json['healthStatus'] as String?,
      averageWeight: (json['averageWeight'] as num?)?.toDouble(),
      vaccinations: (json['vaccinations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$LivestockInfoImplToJson(_$LivestockInfoImpl instance) =>
    <String, dynamic>{
      'animalType': instance.animalType,
      'breed': instance.breed,
      'count': instance.count,
      'purpose': instance.purpose,
      'averageAge': instance.averageAge,
      'healthStatus': instance.healthStatus,
      'averageWeight': instance.averageWeight,
      'vaccinations': instance.vaccinations,
      'additionalData': instance.additionalData,
    };

_$FarmEquipmentImpl _$$FarmEquipmentImplFromJson(Map<String, dynamic> json) =>
    _$FarmEquipmentImpl(
      equipmentName: json['equipmentName'] as String,
      type: json['type'] as String,
      brand: json['brand'] as String?,
      model: json['model'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      condition: json['condition'] as String?,
      purchaseDate: json['purchaseDate'] == null
          ? null
          : DateTime.parse(json['purchaseDate'] as String),
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble(),
      maintenanceStatus: json['maintenanceStatus'] as String?,
    );

Map<String, dynamic> _$$FarmEquipmentImplToJson(_$FarmEquipmentImpl instance) =>
    <String, dynamic>{
      'equipmentName': instance.equipmentName,
      'type': instance.type,
      'brand': instance.brand,
      'model': instance.model,
      'quantity': instance.quantity,
      'condition': instance.condition,
      'purchaseDate': instance.purchaseDate?.toIso8601String(),
      'purchasePrice': instance.purchasePrice,
      'maintenanceStatus': instance.maintenanceStatus,
    };

_$FarmPerformanceMetricsImpl _$$FarmPerformanceMetricsImplFromJson(
        Map<String, dynamic> json) =>
    _$FarmPerformanceMetricsImpl(
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      totalExpenses: (json['totalExpenses'] as num).toDouble(),
      netProfit: (json['netProfit'] as num).toDouble(),
      profitMargin: (json['profitMargin'] as num).toDouble(),
      yieldPerAcre: (json['yieldPerAcre'] as num).toDouble(),
      totalTransactions: (json['totalTransactions'] as num).toInt(),
      successfulHarvests: (json['successfulHarvests'] as num).toInt(),
      customerSatisfactionScore:
          (json['customerSatisfactionScore'] as num).toDouble(),
      veterinaryConsultations: (json['veterinaryConsultations'] as num).toInt(),
      marketplaceListings: (json['marketplaceListings'] as num).toInt(),
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$FarmPerformanceMetricsImplToJson(
        _$FarmPerformanceMetricsImpl instance) =>
    <String, dynamic>{
      'totalRevenue': instance.totalRevenue,
      'totalExpenses': instance.totalExpenses,
      'netProfit': instance.netProfit,
      'profitMargin': instance.profitMargin,
      'yieldPerAcre': instance.yieldPerAcre,
      'totalTransactions': instance.totalTransactions,
      'successfulHarvests': instance.successfulHarvests,
      'customerSatisfactionScore': instance.customerSatisfactionScore,
      'veterinaryConsultations': instance.veterinaryConsultations,
      'marketplaceListings': instance.marketplaceListings,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };

_$VerificationDocumentImpl _$$VerificationDocumentImplFromJson(
        Map<String, dynamic> json) =>
    _$VerificationDocumentImpl(
      id: json['id'] as String,
      documentType: json['documentType'] as String,
      documentName: json['documentName'] as String,
      fileUrl: json['fileUrl'] as String,
      status: json['status'] as String,
      rejectionReason: json['rejectionReason'] as String?,
      uploadedAt: json['uploadedAt'] == null
          ? null
          : DateTime.parse(json['uploadedAt'] as String),
      reviewedAt: json['reviewedAt'] == null
          ? null
          : DateTime.parse(json['reviewedAt'] as String),
      reviewedBy: json['reviewedBy'] as String?,
    );

Map<String, dynamic> _$$VerificationDocumentImplToJson(
        _$VerificationDocumentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'documentType': instance.documentType,
      'documentName': instance.documentName,
      'fileUrl': instance.fileUrl,
      'status': instance.status,
      'rejectionReason': instance.rejectionReason,
      'uploadedAt': instance.uploadedAt?.toIso8601String(),
      'reviewedAt': instance.reviewedAt?.toIso8601String(),
      'reviewedBy': instance.reviewedBy,
    };

_$FarmerImpl _$$FarmerImplFromJson(Map<String, dynamic> json) => _$FarmerImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      middleName: json['middleName'] as String?,
      phoneNumber: json['phoneNumber'] as String,
      alternatePhone: json['alternatePhone'] as String?,
      profilePicture: json['profilePicture'] as String?,
      verificationStatus: $enumDecode(
          _$FarmerVerificationStatusEnumMap, json['verificationStatus']),
      farmLocation:
          FarmLocation.fromJson(json['farmLocation'] as Map<String, dynamic>),
      farmName: json['farmName'] as String?,
      farmSize: (json['farmSize'] as num).toDouble(),
      primaryFarmType: $enumDecode(_$FarmTypeEnumMap, json['primaryFarmType']),
      secondaryFarmTypes: (json['secondaryFarmTypes'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$FarmTypeEnumMap, e))
          .toList(),
      experienceLevel:
          $enumDecode(_$ExperienceLevelEnumMap, json['experienceLevel']),
      crops: (json['crops'] as List<dynamic>)
          .map((e) => CropInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      livestock: (json['livestock'] as List<dynamic>)
          .map((e) => LivestockInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      equipment: (json['equipment'] as List<dynamic>?)
          ?.map((e) => FarmEquipment.fromJson(e as Map<String, dynamic>))
          .toList(),
      performanceMetrics: FarmPerformanceMetrics.fromJson(
          json['performanceMetrics'] as Map<String, dynamic>),
      documents: (json['documents'] as List<dynamic>?)
          ?.map((e) => VerificationDocument.fromJson(e as Map<String, dynamic>))
          .toList(),
      isActive: json['isActive'] as bool,
      isVerified: json['isVerified'] as bool,
      bio: json['bio'] as String?,
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      certifications: (json['certifications'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      socialMedia: (json['socialMedia'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
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
      preferences: json['preferences'] as Map<String, dynamic>?,
      settings: json['settings'] as Map<String, dynamic>?,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$FarmerImplToJson(_$FarmerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'middleName': instance.middleName,
      'phoneNumber': instance.phoneNumber,
      'alternatePhone': instance.alternatePhone,
      'profilePicture': instance.profilePicture,
      'verificationStatus':
          _$FarmerVerificationStatusEnumMap[instance.verificationStatus]!,
      'farmLocation': instance.farmLocation,
      'farmName': instance.farmName,
      'farmSize': instance.farmSize,
      'primaryFarmType': _$FarmTypeEnumMap[instance.primaryFarmType]!,
      'secondaryFarmTypes': instance.secondaryFarmTypes
          ?.map((e) => _$FarmTypeEnumMap[e]!)
          .toList(),
      'experienceLevel': _$ExperienceLevelEnumMap[instance.experienceLevel]!,
      'crops': instance.crops,
      'livestock': instance.livestock,
      'equipment': instance.equipment,
      'performanceMetrics': instance.performanceMetrics,
      'documents': instance.documents,
      'isActive': instance.isActive,
      'isVerified': instance.isVerified,
      'bio': instance.bio,
      'languages': instance.languages,
      'certifications': instance.certifications,
      'socialMedia': instance.socialMedia,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'verifiedAt': instance.verifiedAt?.toIso8601String(),
      'verifiedBy': instance.verifiedBy,
      'lastActiveAt': instance.lastActiveAt?.toIso8601String(),
      'suspensionReason': instance.suspensionReason,
      'suspendedAt': instance.suspendedAt?.toIso8601String(),
      'suspendedBy': instance.suspendedBy,
      'preferences': instance.preferences,
      'settings': instance.settings,
      'additionalData': instance.additionalData,
    };

const _$FarmerVerificationStatusEnumMap = {
  FarmerVerificationStatus.pending: 'pending',
  FarmerVerificationStatus.inReview: 'in_review',
  FarmerVerificationStatus.verified: 'verified',
  FarmerVerificationStatus.rejected: 'rejected',
  FarmerVerificationStatus.suspended: 'suspended',
};

const _$FarmTypeEnumMap = {
  FarmType.cropFarming: 'crop_farming',
  FarmType.livestockFarming: 'livestock_farming',
  FarmType.mixedFarming: 'mixed_farming',
  FarmType.poultryFarming: 'poultry_farming',
  FarmType.dairyFarming: 'dairy_farming',
  FarmType.fishFarming: 'fish_farming',
  FarmType.horticulture: 'horticulture',
  FarmType.agroForestry: 'agro_forestry',
};

const _$ExperienceLevelEnumMap = {
  ExperienceLevel.beginner: 'beginner',
  ExperienceLevel.intermediate: 'intermediate',
  ExperienceLevel.experienced: 'experienced',
  ExperienceLevel.expert: 'expert',
};
