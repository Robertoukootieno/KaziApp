import 'package:freezed_annotation/freezed_annotation.dart';

part 'farmer.freezed.dart';
part 'farmer.g.dart';

/// Farmer verification status
enum FarmerVerificationStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('in_review')
  inReview,
  @JsonValue('verified')
  verified,
  @JsonValue('rejected')
  rejected,
  @JsonValue('suspended')
  suspended,
}

/// Farm type
enum FarmType {
  @JsonValue('crop_farming')
  cropFarming,
  @JsonValue('livestock_farming')
  livestockFarming,
  @JsonValue('mixed_farming')
  mixedFarming,
  @JsonValue('poultry_farming')
  poultryFarming,
  @JsonValue('dairy_farming')
  dairyFarming,
  @JsonValue('fish_farming')
  fishFarming,
  @JsonValue('horticulture')
  horticulture,
  @JsonValue('agro_forestry')
  agroForestry,
}

/// Experience level
enum ExperienceLevel {
  @JsonValue('beginner')
  beginner,
  @JsonValue('intermediate')
  intermediate,
  @JsonValue('experienced')
  experienced,
  @JsonValue('expert')
  expert,
}

/// Farm location
@freezed
class FarmLocation with _$FarmLocation {
  const factory FarmLocation({
    required String county,
    required String subCounty,
    String? ward,
    String? village,
    String? address,
    double? latitude,
    double? longitude,
    String? gpsCoordinates,
    double? elevation,
    String? soilType,
    String? climateZone,
  }) = _FarmLocation;

  factory FarmLocation.fromJson(Map<String, dynamic> json) =>
      _$FarmLocationFromJson(json);
}

/// Crop information
@freezed
class CropInfo with _$CropInfo {
  const factory CropInfo({
    required String cropName,
    required String variety,
    required double acreage,
    String? plantingDate,
    String? harvestDate,
    String? growthStage,
    double? expectedYield,
    double? actualYield,
    List<String>? challenges,
    Map<String, dynamic>? additionalData,
  }) = _CropInfo;

  factory CropInfo.fromJson(Map<String, dynamic> json) =>
      _$CropInfoFromJson(json);
}

/// Livestock information
@freezed
class LivestockInfo with _$LivestockInfo {
  const factory LivestockInfo({
    required String animalType,
    required String breed,
    required int count,
    String? purpose, // dairy, meat, breeding, etc.
    int? averageAge,
    String? healthStatus,
    double? averageWeight,
    List<String>? vaccinations,
    Map<String, dynamic>? additionalData,
  }) = _LivestockInfo;

  factory LivestockInfo.fromJson(Map<String, dynamic> json) =>
      _$LivestockInfoFromJson(json);
}

/// Farm equipment
@freezed
class FarmEquipment with _$FarmEquipment {
  const factory FarmEquipment({
    required String equipmentName,
    required String type,
    String? brand,
    String? model,
    int? quantity,
    String? condition,
    DateTime? purchaseDate,
    double? purchasePrice,
    String? maintenanceStatus,
  }) = _FarmEquipment;

  factory FarmEquipment.fromJson(Map<String, dynamic> json) =>
      _$FarmEquipmentFromJson(json);
}

/// Farm performance metrics
@freezed
class FarmPerformanceMetrics with _$FarmPerformanceMetrics {
  const factory FarmPerformanceMetrics({
    required double totalRevenue,
    required double totalExpenses,
    required double netProfit,
    required double profitMargin,
    required double yieldPerAcre,
    required int totalTransactions,
    required int successfulHarvests,
    required double customerSatisfactionScore,
    required int veterinaryConsultations,
    required int marketplaceListings,
    DateTime? lastUpdated,
  }) = _FarmPerformanceMetrics;

  factory FarmPerformanceMetrics.fromJson(Map<String, dynamic> json) =>
      _$FarmPerformanceMetricsFromJson(json);
}

/// Verification document
@freezed
class VerificationDocument with _$VerificationDocument {
  const factory VerificationDocument({
    required String id,
    required String documentType,
    required String documentName,
    required String fileUrl,
    required String status, // pending, approved, rejected
    String? rejectionReason,
    DateTime? uploadedAt,
    DateTime? reviewedAt,
    String? reviewedBy,
  }) = _VerificationDocument;

  factory VerificationDocument.fromJson(Map<String, dynamic> json) =>
      _$VerificationDocumentFromJson(json);
}

/// Farmer profile
@freezed
class Farmer with _$Farmer {
  const factory Farmer({
    required String id,
    required String userId,
    required String email,
    required String firstName,
    required String lastName,
    String? middleName,
    required String phoneNumber,
    String? alternatePhone,
    String? profilePicture,
    required FarmerVerificationStatus verificationStatus,
    required FarmLocation farmLocation,
    String? farmName,
    required double farmSize, // in acres
    required FarmType primaryFarmType,
    List<FarmType>? secondaryFarmTypes,
    required ExperienceLevel experienceLevel,
    required List<CropInfo> crops,
    required List<LivestockInfo> livestock,
    List<FarmEquipment>? equipment,
    required FarmPerformanceMetrics performanceMetrics,
    List<VerificationDocument>? documents,
    required bool isActive,
    required bool isVerified,
    String? bio,
    List<String>? languages,
    List<String>? certifications,
    Map<String, String>? socialMedia,
    required DateTime joinedAt,
    DateTime? verifiedAt,
    String? verifiedBy,
    DateTime? lastActiveAt,
    String? suspensionReason,
    DateTime? suspendedAt,
    String? suspendedBy,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? settings,
    Map<String, dynamic>? additionalData,
  }) = _Farmer;

  factory Farmer.fromJson(Map<String, dynamic> json) =>
      _$FarmerFromJson(json);
}

/// Extension for farmer utilities
extension FarmerExtensions on Farmer {
  /// Get farmer's full name
  String get fullName {
    final parts = [firstName, middleName, lastName]
        .where((part) => part != null && part.isNotEmpty)
        .toList();
    return parts.join(' ');
  }

  /// Get farmer's initials
  String get initials {
    final firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }

  /// Get verification status display name
  String get verificationStatusDisplayName {
    switch (verificationStatus) {
      case FarmerVerificationStatus.pending:
        return 'Pending';
      case FarmerVerificationStatus.inReview:
        return 'In Review';
      case FarmerVerificationStatus.verified:
        return 'Verified';
      case FarmerVerificationStatus.rejected:
        return 'Rejected';
      case FarmerVerificationStatus.suspended:
        return 'Suspended';
    }
  }

  /// Get primary farm type display name
  String get primaryFarmTypeDisplayName {
    switch (primaryFarmType) {
      case FarmType.cropFarming:
        return 'Crop Farming';
      case FarmType.livestockFarming:
        return 'Livestock Farming';
      case FarmType.mixedFarming:
        return 'Mixed Farming';
      case FarmType.poultryFarming:
        return 'Poultry Farming';
      case FarmType.dairyFarming:
        return 'Dairy Farming';
      case FarmType.fishFarming:
        return 'Fish Farming';
      case FarmType.horticulture:
        return 'Horticulture';
      case FarmType.agroForestry:
        return 'Agro-forestry';
    }
  }

  /// Get experience level display name
  String get experienceLevelDisplayName {
    switch (experienceLevel) {
      case ExperienceLevel.beginner:
        return 'Beginner (0-2 years)';
      case ExperienceLevel.intermediate:
        return 'Intermediate (3-5 years)';
      case ExperienceLevel.experienced:
        return 'Experienced (6-10 years)';
      case ExperienceLevel.expert:
        return 'Expert (10+ years)';
    }
  }

  /// Check if farmer needs verification
  bool get needsVerification => 
      verificationStatus == FarmerVerificationStatus.pending ||
      verificationStatus == FarmerVerificationStatus.inReview;

  /// Check if farmer is suspended
  bool get isSuspended => verificationStatus == FarmerVerificationStatus.suspended;

  /// Get total crop acreage
  double get totalCropAcreage {
    return crops.fold(0.0, (sum, crop) => sum + crop.acreage);
  }

  /// Get total livestock count
  int get totalLivestockCount {
    return livestock.fold(0, (sum, animal) => sum + animal.count);
  }

  /// Get farm location display
  String get farmLocationDisplay {
    final parts = [
      farmLocation.village,
      farmLocation.ward,
      farmLocation.subCounty,
      farmLocation.county,
    ].where((part) => part != null && part.isNotEmpty).toList();
    return parts.join(', ');
  }

  /// Get days since joining
  int get daysSinceJoining {
    return DateTime.now().difference(joinedAt).inDays;
  }

  /// Get days since last active
  int? get daysSinceLastActive {
    if (lastActiveAt == null) return null;
    return DateTime.now().difference(lastActiveAt!).inDays;
  }

  /// Check if farmer is recently active (within 7 days)
  bool get isRecentlyActive {
    final daysSince = daysSinceLastActive;
    return daysSince != null && daysSince <= 7;
  }

  /// Get performance score (0-100)
  double get performanceScore {
    double score = 0.0;
    
    // Base score for being verified
    if (isVerified) score += 20;
    
    // Score based on profit margin
    if (performanceMetrics.profitMargin > 0) {
      score += (performanceMetrics.profitMargin * 20).clamp(0, 30);
    }
    
    // Score based on customer satisfaction
    score += (performanceMetrics.customerSatisfactionScore * 20).clamp(0, 25);
    
    // Score based on activity
    if (isRecentlyActive) score += 15;
    
    // Score based on completeness of profile
    if (bio != null && bio!.isNotEmpty) score += 5;
    if (profilePicture != null) score += 5;
    
    return score.clamp(0, 100);
  }
}
