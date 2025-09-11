import 'package:flutter/material.dart';

// Equipment Status Enum
enum EquipmentStatus {
  available,
  rented,
  maintenance,
  outOfService,
  reserved,
}

extension EquipmentStatusExtension on EquipmentStatus {
  String get displayName {
    switch (this) {
      case EquipmentStatus.available:
        return 'Available';
      case EquipmentStatus.rented:
        return 'Rented';
      case EquipmentStatus.maintenance:
        return 'Maintenance';
      case EquipmentStatus.outOfService:
        return 'Out of Service';
      case EquipmentStatus.reserved:
        return 'Reserved';
    }
  }

  Color get color {
    switch (this) {
      case EquipmentStatus.available:
        return Colors.green;
      case EquipmentStatus.rented:
        return Colors.blue;
      case EquipmentStatus.maintenance:
        return Colors.orange;
      case EquipmentStatus.outOfService:
        return Colors.red;
      case EquipmentStatus.reserved:
        return Colors.purple;
    }
  }

  IconData get icon {
    switch (this) {
      case EquipmentStatus.available:
        return Icons.check_circle;
      case EquipmentStatus.rented:
        return Icons.schedule;
      case EquipmentStatus.maintenance:
        return Icons.build;
      case EquipmentStatus.outOfService:
        return Icons.error;
      case EquipmentStatus.reserved:
        return Icons.bookmark;
    }
  }
}

// Equipment Category Enum
enum EquipmentCategory {
  tractors,
  harvesters,
  plows,
  seeders,
  sprayers,
  cultivators,
  mowers,
  balers,
  tillers,
  other,
}

extension EquipmentCategoryExtension on EquipmentCategory {
  String get displayName {
    switch (this) {
      case EquipmentCategory.tractors:
        return 'Tractors';
      case EquipmentCategory.harvesters:
        return 'Harvesters';
      case EquipmentCategory.plows:
        return 'Plows';
      case EquipmentCategory.seeders:
        return 'Seeders';
      case EquipmentCategory.sprayers:
        return 'Sprayers';
      case EquipmentCategory.cultivators:
        return 'Cultivators';
      case EquipmentCategory.mowers:
        return 'Mowers';
      case EquipmentCategory.balers:
        return 'Balers';
      case EquipmentCategory.tillers:
        return 'Tillers';
      case EquipmentCategory.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case EquipmentCategory.tractors:
        return Icons.agriculture;
      case EquipmentCategory.harvesters:
        return Icons.grass;
      case EquipmentCategory.plows:
        return Icons.landscape;
      case EquipmentCategory.seeders:
        return Icons.scatter_plot;
      case EquipmentCategory.sprayers:
        return Icons.water_drop;
      case EquipmentCategory.cultivators:
        return Icons.terrain;
      case EquipmentCategory.mowers:
        return Icons.content_cut;
      case EquipmentCategory.balers:
        return Icons.inventory_2;
      case EquipmentCategory.tillers:
        return Icons.waves;
      case EquipmentCategory.other:
        return Icons.build;
    }
  }
}

// Rental Status Enum
enum RentalStatus {
  pending,
  confirmed,
  active,
  completed,
  cancelled,
  overdue,
}

extension RentalStatusExtension on RentalStatus {
  String get displayName {
    switch (this) {
      case RentalStatus.pending:
        return 'Pending';
      case RentalStatus.confirmed:
        return 'Confirmed';
      case RentalStatus.active:
        return 'Active';
      case RentalStatus.completed:
        return 'Completed';
      case RentalStatus.cancelled:
        return 'Cancelled';
      case RentalStatus.overdue:
        return 'Overdue';
    }
  }

  Color get color {
    switch (this) {
      case RentalStatus.pending:
        return Colors.orange;
      case RentalStatus.confirmed:
        return Colors.blue;
      case RentalStatus.active:
        return Colors.green;
      case RentalStatus.completed:
        return Colors.grey;
      case RentalStatus.cancelled:
        return Colors.red;
      case RentalStatus.overdue:
        return Colors.deepOrange;
    }
  }
}

// Equipment Model
class Equipment {
  final String id;
  final String name;
  final String model;
  final String brand;
  final int year;
  final EquipmentCategory category;
  final EquipmentStatus status;
  final String description;
  final List<String> specifications;
  final double hourlyRate;
  final double dailyRate;
  final double weeklyRate;
  final String? imageUrl;
  final List<String> imageUrls;
  final String location;
  final double? latitude;
  final double? longitude;
  final int engineHours;
  final DateTime lastMaintenanceDate;
  final DateTime nextMaintenanceDate;
  final String? currentRentalId;
  final List<String> operatorIds;
  final bool requiresOperator;
  final bool deliveryAvailable;
  final double deliveryRadius;
  final double deliveryFee;
  final DateTime createdAt;
  final DateTime updatedAt;

  Equipment({
    required this.id,
    required this.name,
    required this.model,
    required this.brand,
    required this.year,
    required this.category,
    required this.status,
    required this.description,
    required this.specifications,
    required this.hourlyRate,
    required this.dailyRate,
    required this.weeklyRate,
    this.imageUrl,
    required this.imageUrls,
    required this.location,
    this.latitude,
    this.longitude,
    required this.engineHours,
    required this.lastMaintenanceDate,
    required this.nextMaintenanceDate,
    this.currentRentalId,
    required this.operatorIds,
    required this.requiresOperator,
    required this.deliveryAvailable,
    required this.deliveryRadius,
    required this.deliveryFee,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isAvailable => status == EquipmentStatus.available;
  bool get needsMaintenance => DateTime.now().isAfter(nextMaintenanceDate);
  
  String get displayRate {
    if (dailyRate > 0) {
      return 'KSh ${dailyRate.toStringAsFixed(0)}/day';
    } else if (hourlyRate > 0) {
      return 'KSh ${hourlyRate.toStringAsFixed(0)}/hour';
    } else {
      return 'KSh ${weeklyRate.toStringAsFixed(0)}/week';
    }
  }
}

// Rental Booking Model
class RentalBooking {
  final String id;
  final String equipmentId;
  final String equipmentName;
  final String farmerId;
  final String farmerName;
  final String farmerPhone;
  final String farmerEmail;
  final DateTime startDate;
  final DateTime endDate;
  final int durationDays;
  final double totalAmount;
  final double depositAmount;
  final RentalStatus status;
  final String? operatorId;
  final String? operatorName;
  final bool deliveryRequested;
  final String? deliveryAddress;
  final double? deliveryFee;
  final String farmLocation;
  final String county;
  final String purpose;
  final String? specialInstructions;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String? cancellationReason;
  final double? actualHours;
  final String? notes;

  RentalBooking({
    required this.id,
    required this.equipmentId,
    required this.equipmentName,
    required this.farmerId,
    required this.farmerName,
    required this.farmerPhone,
    required this.farmerEmail,
    required this.startDate,
    required this.endDate,
    required this.durationDays,
    required this.totalAmount,
    required this.depositAmount,
    required this.status,
    this.operatorId,
    this.operatorName,
    required this.deliveryRequested,
    this.deliveryAddress,
    this.deliveryFee,
    required this.farmLocation,
    required this.county,
    required this.purpose,
    this.specialInstructions,
    required this.createdAt,
    this.confirmedAt,
    this.startedAt,
    this.completedAt,
    this.cancellationReason,
    this.actualHours,
    this.notes,
  });

  bool get isActive => status == RentalStatus.active;
  bool get isOverdue => status == RentalStatus.overdue || 
                       (status == RentalStatus.active && DateTime.now().isAfter(endDate));
  
  int get daysRemaining {
    if (status != RentalStatus.active) return 0;
    return endDate.difference(DateTime.now()).inDays;
  }
}

// Equipment Operator Model
class EquipmentOperator {
  final String id;
  final String name;
  final String phone;
  final String email;
  final List<EquipmentCategory> certifiedCategories;
  final int experienceYears;
  final double rating;
  final int totalJobs;
  final bool isAvailable;
  final String location;
  final List<String> certifications;
  final DateTime? nextAvailableDate;
  final double hourlyRate;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  EquipmentOperator({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.certifiedCategories,
    required this.experienceYears,
    required this.rating,
    required this.totalJobs,
    required this.isAvailable,
    required this.location,
    required this.certifications,
    this.nextAvailableDate,
    required this.hourlyRate,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  String get experienceLevel {
    if (experienceYears < 2) return 'Beginner';
    if (experienceYears < 5) return 'Intermediate';
    if (experienceYears < 10) return 'Experienced';
    return 'Expert';
  }
}

// Maintenance Record Model
class MaintenanceRecord {
  final String id;
  final String equipmentId;
  final String equipmentName;
  final String type; // 'routine', 'repair', 'inspection'
  final String description;
  final DateTime scheduledDate;
  final DateTime? completedDate;
  final String status; // 'scheduled', 'in_progress', 'completed', 'cancelled'
  final double cost;
  final String? technicianName;
  final String? technicianPhone;
  final List<String> partsReplaced;
  final List<String> serviceNotes;
  final int? engineHoursAtService;
  final String? invoiceNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  MaintenanceRecord({
    required this.id,
    required this.equipmentId,
    required this.equipmentName,
    required this.type,
    required this.description,
    required this.scheduledDate,
    this.completedDate,
    required this.status,
    required this.cost,
    this.technicianName,
    this.technicianPhone,
    required this.partsReplaced,
    required this.serviceNotes,
    this.engineHoursAtService,
    this.invoiceNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isCompleted => status == 'completed';
  bool get isOverdue => status != 'completed' && DateTime.now().isAfter(scheduledDate);
}
