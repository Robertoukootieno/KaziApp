import 'package:flutter/material.dart';

// Appointment Models
class Appointment {
  final String id;
  final String farmerId;
  final String farmerName;
  final String farmerPhone;
  final String animalType;
  final String animalBreed;
  final int animalCount;
  final String serviceType;
  final String description;
  final DateTime scheduledDate;
  final TimeOfDay scheduledTime;
  final String location;
  final String county;
  final AppointmentStatus status;
  final AppointmentPriority priority;
  final double? estimatedCost;
  final String? notes;
  final DateTime createdAt;
  final DateTime? completedAt;

  const Appointment({
    required this.id,
    required this.farmerId,
    required this.farmerName,
    required this.farmerPhone,
    required this.animalType,
    required this.animalBreed,
    required this.animalCount,
    required this.serviceType,
    required this.description,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.location,
    required this.county,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.estimatedCost,
    this.notes,
    this.completedAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      farmerId: json['farmerId'],
      farmerName: json['farmerName'],
      farmerPhone: json['farmerPhone'],
      animalType: json['animalType'],
      animalBreed: json['animalBreed'],
      animalCount: json['animalCount'],
      serviceType: json['serviceType'],
      description: json['description'],
      scheduledDate: DateTime.parse(json['scheduledDate']),
      scheduledTime: TimeOfDay(
        hour: json['scheduledHour'],
        minute: json['scheduledMinute'],
      ),
      location: json['location'],
      county: json['county'],
      status: AppointmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AppointmentStatus.pending,
      ),
      priority: AppointmentPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => AppointmentPriority.normal,
      ),
      estimatedCost: json['estimatedCost']?.toDouble(),
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerId': farmerId,
      'farmerName': farmerName,
      'farmerPhone': farmerPhone,
      'animalType': animalType,
      'animalBreed': animalBreed,
      'animalCount': animalCount,
      'serviceType': serviceType,
      'description': description,
      'scheduledDate': scheduledDate.toIso8601String(),
      'scheduledHour': scheduledTime.hour,
      'scheduledMinute': scheduledTime.minute,
      'location': location,
      'county': county,
      'status': status.name,
      'priority': priority.name,
      'estimatedCost': estimatedCost,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}

enum AppointmentStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
  noShow,
}

enum AppointmentPriority {
  low,
  normal,
  high,
  emergency,
}

extension AppointmentStatusExtension on AppointmentStatus {
  String get displayName {
    switch (this) {
      case AppointmentStatus.pending:
        return 'Pending';
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.inProgress:
        return 'In Progress';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.noShow:
        return 'No Show';
    }
  }

  Color get color {
    switch (this) {
      case AppointmentStatus.pending:
        return Colors.orange;
      case AppointmentStatus.confirmed:
        return Colors.blue;
      case AppointmentStatus.inProgress:
        return Colors.purple;
      case AppointmentStatus.completed:
        return Colors.green;
      case AppointmentStatus.cancelled:
        return Colors.red;
      case AppointmentStatus.noShow:
        return Colors.grey;
    }
  }
}

extension AppointmentPriorityExtension on AppointmentPriority {
  String get displayName {
    switch (this) {
      case AppointmentPriority.low:
        return 'Low';
      case AppointmentPriority.normal:
        return 'Normal';
      case AppointmentPriority.high:
        return 'High';
      case AppointmentPriority.emergency:
        return 'Emergency';
    }
  }

  Color get color {
    switch (this) {
      case AppointmentPriority.low:
        return Colors.green;
      case AppointmentPriority.normal:
        return Colors.blue;
      case AppointmentPriority.high:
        return Colors.orange;
      case AppointmentPriority.emergency:
        return Colors.red;
    }
  }
}

// Patient Record Models
class PatientRecord {
  final String id;
  final String farmerId;
  final String farmerName;
  final String animalId;
  final String animalName;
  final String animalType;
  final String breed;
  final String gender;
  final DateTime dateOfBirth;
  final double? weight;
  final String? color;
  final String? markings;
  final List<MedicalHistory> medicalHistory;
  final List<Vaccination> vaccinations;
  final List<Treatment> treatments;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PatientRecord({
    required this.id,
    required this.farmerId,
    required this.farmerName,
    required this.animalId,
    required this.animalName,
    required this.animalType,
    required this.breed,
    required this.gender,
    required this.dateOfBirth,
    required this.medicalHistory,
    required this.vaccinations,
    required this.treatments,
    required this.createdAt,
    required this.updatedAt,
    this.weight,
    this.color,
    this.markings,
    this.notes,
  });

  factory PatientRecord.fromJson(Map<String, dynamic> json) {
    return PatientRecord(
      id: json['id'],
      farmerId: json['farmerId'],
      farmerName: json['farmerName'],
      animalId: json['animalId'],
      animalName: json['animalName'],
      animalType: json['animalType'],
      breed: json['breed'],
      gender: json['gender'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      weight: json['weight']?.toDouble(),
      color: json['color'],
      markings: json['markings'],
      medicalHistory: (json['medicalHistory'] as List?)
          ?.map((e) => MedicalHistory.fromJson(e))
          .toList() ?? [],
      vaccinations: (json['vaccinations'] as List?)
          ?.map((e) => Vaccination.fromJson(e))
          .toList() ?? [],
      treatments: (json['treatments'] as List?)
          ?.map((e) => Treatment.fromJson(e))
          .toList() ?? [],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerId': farmerId,
      'farmerName': farmerName,
      'animalId': animalId,
      'animalName': animalName,
      'animalType': animalType,
      'breed': breed,
      'gender': gender,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'weight': weight,
      'color': color,
      'markings': markings,
      'medicalHistory': medicalHistory.map((e) => e.toJson()).toList(),
      'vaccinations': vaccinations.map((e) => e.toJson()).toList(),
      'treatments': treatments.map((e) => e.toJson()).toList(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class MedicalHistory {
  final String id;
  final DateTime date;
  final String condition;
  final String symptoms;
  final String diagnosis;
  final String treatment;
  final String veterinarianId;
  final String veterinarianName;
  final String? notes;

  const MedicalHistory({
    required this.id,
    required this.date,
    required this.condition,
    required this.symptoms,
    required this.diagnosis,
    required this.treatment,
    required this.veterinarianId,
    required this.veterinarianName,
    this.notes,
  });

  factory MedicalHistory.fromJson(Map<String, dynamic> json) {
    return MedicalHistory(
      id: json['id'],
      date: DateTime.parse(json['date']),
      condition: json['condition'],
      symptoms: json['symptoms'],
      diagnosis: json['diagnosis'],
      treatment: json['treatment'],
      veterinarianId: json['veterinarianId'],
      veterinarianName: json['veterinarianName'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'condition': condition,
      'symptoms': symptoms,
      'diagnosis': diagnosis,
      'treatment': treatment,
      'veterinarianId': veterinarianId,
      'veterinarianName': veterinarianName,
      'notes': notes,
    };
  }
}

class Vaccination {
  final String id;
  final String vaccineName;
  final String vaccineType;
  final DateTime dateAdministered;
  final DateTime? nextDueDate;
  final String batchNumber;
  final String manufacturer;
  final double dosage;
  final String veterinarianId;
  final String veterinarianName;
  final String? notes;

  const Vaccination({
    required this.id,
    required this.vaccineName,
    required this.vaccineType,
    required this.dateAdministered,
    required this.batchNumber,
    required this.manufacturer,
    required this.dosage,
    required this.veterinarianId,
    required this.veterinarianName,
    this.nextDueDate,
    this.notes,
  });

  factory Vaccination.fromJson(Map<String, dynamic> json) {
    return Vaccination(
      id: json['id'],
      vaccineName: json['vaccineName'],
      vaccineType: json['vaccineType'],
      dateAdministered: DateTime.parse(json['dateAdministered']),
      nextDueDate: json['nextDueDate'] != null ? DateTime.parse(json['nextDueDate']) : null,
      batchNumber: json['batchNumber'],
      manufacturer: json['manufacturer'],
      dosage: json['dosage'].toDouble(),
      veterinarianId: json['veterinarianId'],
      veterinarianName: json['veterinarianName'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vaccineName': vaccineName,
      'vaccineType': vaccineType,
      'dateAdministered': dateAdministered.toIso8601String(),
      'nextDueDate': nextDueDate?.toIso8601String(),
      'batchNumber': batchNumber,
      'manufacturer': manufacturer,
      'dosage': dosage,
      'veterinarianId': veterinarianId,
      'veterinarianName': veterinarianName,
      'notes': notes,
    };
  }
}

class Treatment {
  final String id;
  final DateTime date;
  final String treatmentType;
  final String medication;
  final String dosage;
  final String frequency;
  final int duration;
  final String instructions;
  final double cost;
  final String veterinarianId;
  final String veterinarianName;
  final String? notes;

  const Treatment({
    required this.id,
    required this.date,
    required this.treatmentType,
    required this.medication,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.instructions,
    required this.cost,
    required this.veterinarianId,
    required this.veterinarianName,
    this.notes,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      id: json['id'],
      date: DateTime.parse(json['date']),
      treatmentType: json['treatmentType'],
      medication: json['medication'],
      dosage: json['dosage'],
      frequency: json['frequency'],
      duration: json['duration'],
      instructions: json['instructions'],
      cost: json['cost'].toDouble(),
      veterinarianId: json['veterinarianId'],
      veterinarianName: json['veterinarianName'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'treatmentType': treatmentType,
      'medication': medication,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
      'instructions': instructions,
      'cost': cost,
      'veterinarianId': veterinarianId,
      'veterinarianName': veterinarianName,
      'notes': notes,
    };
  }
}

// Inventory Models
class InventoryItem {
  final String id;
  final String name;
  final String category;
  final String type;
  final int currentStock;
  final int minimumStock;
  final String unit;
  final double unitPrice;
  final String? supplier;
  final DateTime? expiryDate;
  final String? batchNumber;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.type,
    required this.currentStock,
    required this.minimumStock,
    required this.unit,
    required this.unitPrice,
    required this.createdAt,
    required this.updatedAt,
    this.supplier,
    this.expiryDate,
    this.batchNumber,
    this.description,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      type: json['type'],
      currentStock: json['currentStock'],
      minimumStock: json['minimumStock'],
      unit: json['unit'],
      unitPrice: json['unitPrice'].toDouble(),
      supplier: json['supplier'],
      expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
      batchNumber: json['batchNumber'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'type': type,
      'currentStock': currentStock,
      'minimumStock': minimumStock,
      'unit': unit,
      'unitPrice': unitPrice,
      'supplier': supplier,
      'expiryDate': expiryDate?.toIso8601String(),
      'batchNumber': batchNumber,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  bool get isLowStock => currentStock <= minimumStock;
  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    final daysUntilExpiry = expiryDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 30;
  }
}
