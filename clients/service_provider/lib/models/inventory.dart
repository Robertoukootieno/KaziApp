class InventoryItem {
  final String id;
  final String providerId;
  final String name;
  final String? description;
  final String? sku;
  final String? barcode;
  final InventoryCategory category;
  final String? brand;
  final String unit; // kg, liter, piece, etc.
  final double currentStock;
  final double minStockLevel;
  final double maxStockLevel;
  final double unitCost;
  final double sellingPrice;
  final String? supplier;
  final String? supplierContact;
  final DateTime? expiryDate;
  final DateTime? lastRestocked;
  final List<String> imageUrls;
  final Map<String, dynamic> specifications;
  final bool isActive;
  final bool trackExpiry;
  final DateTime createdAt;
  final DateTime updatedAt;

  InventoryItem({
    required this.id,
    required this.providerId,
    required this.name,
    this.description,
    this.sku,
    this.barcode,
    required this.category,
    this.brand,
    required this.unit,
    required this.currentStock,
    required this.minStockLevel,
    required this.maxStockLevel,
    required this.unitCost,
    required this.sellingPrice,
    this.supplier,
    this.supplierContact,
    this.expiryDate,
    this.lastRestocked,
    required this.imageUrls,
    required this.specifications,
    this.isActive = true,
    this.trackExpiry = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'],
      providerId: json['providerId'],
      name: json['name'],
      description: json['description'],
      sku: json['sku'],
      barcode: json['barcode'],
      category: InventoryCategory.values.firstWhere(
        (e) => e.toString().split('.').last == json['category'],
      ),
      brand: json['brand'],
      unit: json['unit'],
      currentStock: (json['currentStock'] ?? 0.0).toDouble(),
      minStockLevel: (json['minStockLevel'] ?? 0.0).toDouble(),
      maxStockLevel: (json['maxStockLevel'] ?? 0.0).toDouble(),
      unitCost: (json['unitCost'] ?? 0.0).toDouble(),
      sellingPrice: (json['sellingPrice'] ?? 0.0).toDouble(),
      supplier: json['supplier'],
      supplierContact: json['supplierContact'],
      expiryDate: json['expiryDate'] != null 
          ? DateTime.parse(json['expiryDate']) 
          : null,
      lastRestocked: json['lastRestocked'] != null 
          ? DateTime.parse(json['lastRestocked']) 
          : null,
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      specifications: Map<String, dynamic>.from(json['specifications'] ?? {}),
      isActive: json['isActive'] ?? true,
      trackExpiry: json['trackExpiry'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'providerId': providerId,
      'name': name,
      'description': description,
      'sku': sku,
      'barcode': barcode,
      'category': category.toString().split('.').last,
      'brand': brand,
      'unit': unit,
      'currentStock': currentStock,
      'minStockLevel': minStockLevel,
      'maxStockLevel': maxStockLevel,
      'unitCost': unitCost,
      'sellingPrice': sellingPrice,
      'supplier': supplier,
      'supplierContact': supplierContact,
      'expiryDate': expiryDate?.toIso8601String(),
      'lastRestocked': lastRestocked?.toIso8601String(),
      'imageUrls': imageUrls,
      'specifications': specifications,
      'isActive': isActive,
      'trackExpiry': trackExpiry,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  InventoryItem copyWith({
    String? id,
    String? providerId,
    String? name,
    String? description,
    String? sku,
    String? barcode,
    InventoryCategory? category,
    String? brand,
    String? unit,
    double? currentStock,
    double? minStockLevel,
    double? maxStockLevel,
    double? unitCost,
    double? sellingPrice,
    String? supplier,
    String? supplierContact,
    DateTime? expiryDate,
    DateTime? lastRestocked,
    List<String>? imageUrls,
    Map<String, dynamic>? specifications,
    bool? isActive,
    bool? trackExpiry,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      name: name ?? this.name,
      description: description ?? this.description,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      unit: unit ?? this.unit,
      currentStock: currentStock ?? this.currentStock,
      minStockLevel: minStockLevel ?? this.minStockLevel,
      maxStockLevel: maxStockLevel ?? this.maxStockLevel,
      unitCost: unitCost ?? this.unitCost,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      supplier: supplier ?? this.supplier,
      supplierContact: supplierContact ?? this.supplierContact,
      expiryDate: expiryDate ?? this.expiryDate,
      lastRestocked: lastRestocked ?? this.lastRestocked,
      imageUrls: imageUrls ?? this.imageUrls,
      specifications: specifications ?? this.specifications,
      isActive: isActive ?? this.isActive,
      trackExpiry: trackExpiry ?? this.trackExpiry,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isLowStock => currentStock <= minStockLevel;
  bool get isOutOfStock => currentStock <= 0;
  bool get isOverStock => currentStock >= maxStockLevel;
  
  bool get isExpired {
    if (!trackExpiry || expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }
  
  bool get isExpiringSoon {
    if (!trackExpiry || expiryDate == null) return false;
    final daysUntilExpiry = expiryDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 30 && daysUntilExpiry > 0;
  }

  double get profitMargin {
    if (unitCost == 0) return 0;
    return ((sellingPrice - unitCost) / unitCost) * 100;
  }

  double get totalValue => currentStock * unitCost;
}

enum InventoryCategory {
  medicines,
  vaccines,
  feeds,
  seeds,
  fertilizers,
  pesticides,
  equipment,
  tools,
  supplies,
  consumables,
}

extension InventoryCategoryExtension on InventoryCategory {
  String get displayName {
    switch (this) {
      case InventoryCategory.medicines:
        return 'Medicines';
      case InventoryCategory.vaccines:
        return 'Vaccines';
      case InventoryCategory.feeds:
        return 'Animal Feeds';
      case InventoryCategory.seeds:
        return 'Seeds';
      case InventoryCategory.fertilizers:
        return 'Fertilizers';
      case InventoryCategory.pesticides:
        return 'Pesticides';
      case InventoryCategory.equipment:
        return 'Equipment';
      case InventoryCategory.tools:
        return 'Tools';
      case InventoryCategory.supplies:
        return 'Supplies';
      case InventoryCategory.consumables:
        return 'Consumables';
    }
  }

  String get icon {
    switch (this) {
      case InventoryCategory.medicines:
        return '💊';
      case InventoryCategory.vaccines:
        return '💉';
      case InventoryCategory.feeds:
        return '🌾';
      case InventoryCategory.seeds:
        return '🌱';
      case InventoryCategory.fertilizers:
        return '🧪';
      case InventoryCategory.pesticides:
        return '🚿';
      case InventoryCategory.equipment:
        return '⚙️';
      case InventoryCategory.tools:
        return '🔧';
      case InventoryCategory.supplies:
        return '📦';
      case InventoryCategory.consumables:
        return '🔄';
    }
  }
}

class StockMovement {
  final String id;
  final String inventoryItemId;
  final String providerId;
  final MovementType type;
  final double quantity;
  final double unitCost;
  final String? reason;
  final String? reference;
  final String? notes;
  final DateTime createdAt;
  final String createdBy;

  StockMovement({
    required this.id,
    required this.inventoryItemId,
    required this.providerId,
    required this.type,
    required this.quantity,
    required this.unitCost,
    this.reason,
    this.reference,
    this.notes,
    required this.createdAt,
    required this.createdBy,
  });

  factory StockMovement.fromJson(Map<String, dynamic> json) {
    return StockMovement(
      id: json['id'],
      inventoryItemId: json['inventoryItemId'],
      providerId: json['providerId'],
      type: MovementType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      quantity: (json['quantity'] ?? 0.0).toDouble(),
      unitCost: (json['unitCost'] ?? 0.0).toDouble(),
      reason: json['reason'],
      reference: json['reference'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      createdBy: json['createdBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inventoryItemId': inventoryItemId,
      'providerId': providerId,
      'type': type.toString().split('.').last,
      'quantity': quantity,
      'unitCost': unitCost,
      'reason': reason,
      'reference': reference,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
    };
  }

  double get totalValue => quantity * unitCost;
}

enum MovementType {
  stockIn,
  stockOut,
  adjustment,
  transfer,
  damaged,
  expired,
  returned,
}

extension MovementTypeExtension on MovementType {
  String get displayName {
    switch (this) {
      case MovementType.stockIn:
        return 'Stock In';
      case MovementType.stockOut:
        return 'Stock Out';
      case MovementType.adjustment:
        return 'Adjustment';
      case MovementType.transfer:
        return 'Transfer';
      case MovementType.damaged:
        return 'Damaged';
      case MovementType.expired:
        return 'Expired';
      case MovementType.returned:
        return 'Returned';
    }
  }

  String get icon {
    switch (this) {
      case MovementType.stockIn:
        return '📥';
      case MovementType.stockOut:
        return '📤';
      case MovementType.adjustment:
        return '⚖️';
      case MovementType.transfer:
        return '🔄';
      case MovementType.damaged:
        return '💥';
      case MovementType.expired:
        return '⏰';
      case MovementType.returned:
        return '↩️';
    }
  }

  bool get isIncoming {
    return this == MovementType.stockIn || 
           this == MovementType.returned ||
           (this == MovementType.adjustment);
  }

  bool get isOutgoing {
    return this == MovementType.stockOut || 
           this == MovementType.damaged ||
           this == MovementType.expired ||
           this == MovementType.transfer;
  }
}
