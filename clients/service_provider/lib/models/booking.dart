class Booking {
  final String id;
  final String serviceId;
  final String providerId;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String? customerLocation;
  final DateTime scheduledDate;
  final String scheduledTime;
  final BookingStatus status;
  final String? notes;
  final String? customerNotes;
  final double totalAmount;
  final PaymentStatus paymentStatus;
  final String? paymentMethod;
  final String? paymentReference;
  final List<BookingItem> items;
  final BookingLocation? location;
  final List<String> attachments;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;

  Booking({
    required this.id,
    required this.serviceId,
    required this.providerId,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    this.customerLocation,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.status,
    this.notes,
    this.customerNotes,
    required this.totalAmount,
    required this.paymentStatus,
    this.paymentMethod,
    this.paymentReference,
    required this.items,
    this.location,
    required this.attachments,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    this.cancelledAt,
    this.cancellationReason,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      serviceId: json['serviceId'],
      providerId: json['providerId'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerEmail: json['customerEmail'],
      customerLocation: json['customerLocation'],
      scheduledDate: DateTime.parse(json['scheduledDate']),
      scheduledTime: json['scheduledTime'],
      status: BookingStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      notes: json['notes'],
      customerNotes: json['customerNotes'],
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['paymentStatus'],
      ),
      paymentMethod: json['paymentMethod'],
      paymentReference: json['paymentReference'],
      items: (json['items'] as List?)
          ?.map((item) => BookingItem.fromJson(item))
          .toList() ?? [],
      location: json['location'] != null 
          ? BookingLocation.fromJson(json['location']) 
          : null,
      attachments: List<String>.from(json['attachments'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt']) 
          : null,
      cancelledAt: json['cancelledAt'] != null 
          ? DateTime.parse(json['cancelledAt']) 
          : null,
      cancellationReason: json['cancellationReason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceId': serviceId,
      'providerId': providerId,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'customerLocation': customerLocation,
      'scheduledDate': scheduledDate.toIso8601String(),
      'scheduledTime': scheduledTime,
      'status': status.toString().split('.').last,
      'notes': notes,
      'customerNotes': customerNotes,
      'totalAmount': totalAmount,
      'paymentStatus': paymentStatus.toString().split('.').last,
      'paymentMethod': paymentMethod,
      'paymentReference': paymentReference,
      'items': items.map((item) => item.toJson()).toList(),
      'location': location?.toJson(),
      'attachments': attachments,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'cancellationReason': cancellationReason,
    };
  }

  Booking copyWith({
    String? id,
    String? serviceId,
    String? providerId,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? customerLocation,
    DateTime? scheduledDate,
    String? scheduledTime,
    BookingStatus? status,
    String? notes,
    String? customerNotes,
    double? totalAmount,
    PaymentStatus? paymentStatus,
    String? paymentMethod,
    String? paymentReference,
    List<BookingItem>? items,
    BookingLocation? location,
    List<String>? attachments,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    String? cancellationReason,
  }) {
    return Booking(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      providerId: providerId ?? this.providerId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      customerLocation: customerLocation ?? this.customerLocation,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      customerNotes: customerNotes ?? this.customerNotes,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentReference: paymentReference ?? this.paymentReference,
      items: items ?? this.items,
      location: location ?? this.location,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
    );
  }
}

enum BookingStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
  noShow,
  rescheduled,
}

extension BookingStatusExtension on BookingStatus {
  String get displayName {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.noShow:
        return 'No Show';
      case BookingStatus.rescheduled:
        return 'Rescheduled';
    }
  }

  String get color {
    switch (this) {
      case BookingStatus.pending:
        return 'orange';
      case BookingStatus.confirmed:
        return 'blue';
      case BookingStatus.inProgress:
        return 'purple';
      case BookingStatus.completed:
        return 'green';
      case BookingStatus.cancelled:
        return 'red';
      case BookingStatus.noShow:
        return 'grey';
      case BookingStatus.rescheduled:
        return 'amber';
    }
  }
}

enum PaymentStatus {
  pending,
  paid,
  partiallyPaid,
  refunded,
  failed,
}

extension PaymentStatusExtension on PaymentStatus {
  String get displayName {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.partiallyPaid:
        return 'Partially Paid';
      case PaymentStatus.refunded:
        return 'Refunded';
      case PaymentStatus.failed:
        return 'Failed';
    }
  }
}

class BookingItem {
  final String id;
  final String name;
  final String? description;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  BookingItem({
    required this.id,
    required this.name,
    this.description,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory BookingItem.fromJson(Map<String, dynamic> json) {
    return BookingItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      quantity: json['quantity'],
      unitPrice: (json['unitPrice'] ?? 0.0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
    };
  }
}

class BookingLocation {
  final double latitude;
  final double longitude;
  final String address;
  final String? landmark;
  final String? directions;

  BookingLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.landmark,
    this.directions,
  });

  factory BookingLocation.fromJson(Map<String, dynamic> json) {
    return BookingLocation(
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      address: json['address'] ?? '',
      landmark: json['landmark'],
      directions: json['directions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'landmark': landmark,
      'directions': directions,
    };
  }
}
