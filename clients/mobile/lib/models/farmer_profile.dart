class FarmerProfile {
  final String id;
  final String name;
  final String phone;
  final String farmName;
  final String location;
  final String county;
  final String farmingType;
  final String experienceLevel;
  final double farmSize;
  final List<String> crops;
  final List<String> livestock;
  final String language;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> additionalData;

  FarmerProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.farmName,
    required this.location,
    required this.county,
    required this.farmingType,
    required this.experienceLevel,
    required this.farmSize,
    required this.crops,
    required this.livestock,
    required this.language,
    required this.createdAt,
    required this.updatedAt,
    required this.additionalData,
  });

  // Create a copy with updated fields
  FarmerProfile copyWith({
    String? id,
    String? name,
    String? phone,
    String? farmName,
    String? location,
    String? county,
    String? farmingType,
    String? experienceLevel,
    double? farmSize,
    List<String>? crops,
    List<String>? livestock,
    String? language,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? additionalData,
  }) {
    return FarmerProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      farmName: farmName ?? this.farmName,
      location: location ?? this.location,
      county: county ?? this.county,
      farmingType: farmingType ?? this.farmingType,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      farmSize: farmSize ?? this.farmSize,
      crops: crops ?? this.crops,
      livestock: livestock ?? this.livestock,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'farmName': farmName,
      'location': location,
      'county': county,
      'farmingType': farmingType,
      'experienceLevel': experienceLevel,
      'farmSize': farmSize,
      'crops': crops,
      'livestock': livestock,
      'language': language,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'additionalData': additionalData,
    };
  }

  // Create from JSON
  factory FarmerProfile.fromJson(Map<String, dynamic> json) {
    return FarmerProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      farmName: json['farmName'] ?? '',
      location: json['location'] ?? '',
      county: json['county'] ?? '',
      farmingType: json['farmingType'] ?? '',
      experienceLevel: json['experienceLevel'] ?? '',
      farmSize: (json['farmSize'] ?? 0.0).toDouble(),
      crops: List<String>.from(json['crops'] ?? []),
      livestock: List<String>.from(json['livestock'] ?? []),
      language: json['language'] ?? 'English',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      additionalData: Map<String, dynamic>.from(json['additionalData'] ?? {}),
    );
  }

  // Get farming type icon
  String get farmingTypeIcon {
    switch (farmingType) {
      case 'Crop Farming':
        return '🌾';
      case 'Livestock Farming':
        return '🐄';
      case 'Mixed Farming':
        return '🚜';
      case 'Poultry Farming':
        return '🐔';
      case 'Dairy Farming':
        return '🥛';
      case 'Fish Farming':
        return '🐟';
      case 'Horticulture':
        return '🌺';
      case 'Agro-forestry':
        return '🌳';
      default:
        return '🌱';
    }
  }

  // Get experience level color
  String get experienceLevelColor {
    if (experienceLevel.contains('Beginner')) return '#FF9800';
    if (experienceLevel.contains('Intermediate')) return '#2196F3';
    if (experienceLevel.contains('Experienced')) return '#4CAF50';
    if (experienceLevel.contains('Expert')) return '#9C27B0';
    return '#757575';
  }

  // Get farm size category
  String get farmSizeCategory {
    if (farmSize < 1.0) return 'Small Scale';
    if (farmSize < 5.0) return 'Medium Scale';
    if (farmSize < 20.0) return 'Large Scale';
    return 'Commercial';
  }

  // Check if profile is complete
  bool get isComplete {
    return name.isNotEmpty &&
           phone.isNotEmpty &&
           farmName.isNotEmpty &&
           location.isNotEmpty &&
           county.isNotEmpty &&
           farmingType.isNotEmpty &&
           experienceLevel.isNotEmpty &&
           farmSize > 0 &&
           (crops.isNotEmpty || livestock.isNotEmpty);
  }

  @override
  String toString() {
    return 'FarmerProfile(id: $id, name: $name, farmingType: $farmingType, farmSize: $farmSize)';
  }
}

class FarmerPreferences {
  final List<String> selectedServices;
  final Map<String, bool> notificationSettings;
  final String preferredLanguage;
  final String theme;
  final Map<String, dynamic> customSettings;
  final DateTime updatedAt;

  FarmerPreferences({
    required this.selectedServices,
    required this.notificationSettings,
    required this.preferredLanguage,
    required this.theme,
    required this.customSettings,
    required this.updatedAt,
  });

  // Create a copy with updated fields
  FarmerPreferences copyWith({
    List<String>? selectedServices,
    Map<String, bool>? notificationSettings,
    String? preferredLanguage,
    String? theme,
    Map<String, dynamic>? customSettings,
    DateTime? updatedAt,
  }) {
    return FarmerPreferences(
      selectedServices: selectedServices ?? this.selectedServices,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      theme: theme ?? this.theme,
      customSettings: customSettings ?? this.customSettings,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'selectedServices': selectedServices,
      'notificationSettings': notificationSettings,
      'preferredLanguage': preferredLanguage,
      'theme': theme,
      'customSettings': customSettings,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory FarmerPreferences.fromJson(Map<String, dynamic> json) {
    return FarmerPreferences(
      selectedServices: List<String>.from(json['selectedServices'] ?? []),
      notificationSettings: Map<String, bool>.from(json['notificationSettings'] ?? {}),
      preferredLanguage: json['preferredLanguage'] ?? 'English',
      theme: json['theme'] ?? 'light',
      customSettings: Map<String, dynamic>.from(json['customSettings'] ?? {}),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  @override
  String toString() {
    return 'FarmerPreferences(language: $preferredLanguage, theme: $theme, services: ${selectedServices.length})';
  }
}

class FarmingActivity {
  final String id;
  final String farmerId;
  final String type; // 'planting', 'harvesting', 'treatment', 'feeding', etc.
  final String description;
  final DateTime date;
  final String? cropType;
  final String? animalType;
  final double? cost;
  final String? notes;
  final Map<String, dynamic> metadata;

  FarmingActivity({
    required this.id,
    required this.farmerId,
    required this.type,
    required this.description,
    required this.date,
    this.cropType,
    this.animalType,
    this.cost,
    this.notes,
    required this.metadata,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerId': farmerId,
      'type': type,
      'description': description,
      'date': date.toIso8601String(),
      'cropType': cropType,
      'animalType': animalType,
      'cost': cost,
      'notes': notes,
      'metadata': metadata,
    };
  }

  // Create from JSON
  factory FarmingActivity.fromJson(Map<String, dynamic> json) {
    return FarmingActivity(
      id: json['id'] ?? '',
      farmerId: json['farmerId'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      cropType: json['cropType'],
      animalType: json['animalType'],
      cost: json['cost']?.toDouble(),
      notes: json['notes'],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  @override
  String toString() {
    return 'FarmingActivity(id: $id, type: $type, date: $date)';
  }
}
