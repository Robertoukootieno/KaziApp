import 'package:flutter/material.dart';

// Product Category Enum
enum ProductCategory {
  seeds,
  fertilizers,
  pesticides,
  animalFeed,
  farmTools,
  irrigation,
  livestock,
  poultry,
  dairy,
  crops,
  vegetables,
  fruits,
  other,
}

extension ProductCategoryExtension on ProductCategory {
  String get displayName {
    switch (this) {
      case ProductCategory.seeds:
        return 'Seeds';
      case ProductCategory.fertilizers:
        return 'Fertilizers';
      case ProductCategory.pesticides:
        return 'Pesticides';
      case ProductCategory.animalFeed:
        return 'Animal Feed';
      case ProductCategory.farmTools:
        return 'Farm Tools';
      case ProductCategory.irrigation:
        return 'Irrigation';
      case ProductCategory.livestock:
        return 'Livestock';
      case ProductCategory.poultry:
        return 'Poultry';
      case ProductCategory.dairy:
        return 'Dairy';
      case ProductCategory.crops:
        return 'Crops';
      case ProductCategory.vegetables:
        return 'Vegetables';
      case ProductCategory.fruits:
        return 'Fruits';
      case ProductCategory.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case ProductCategory.seeds:
        return Icons.scatter_plot;
      case ProductCategory.fertilizers:
        return Icons.science;
      case ProductCategory.pesticides:
        return Icons.bug_report;
      case ProductCategory.animalFeed:
        return Icons.pets;
      case ProductCategory.farmTools:
        return Icons.build;
      case ProductCategory.irrigation:
        return Icons.water_drop;
      case ProductCategory.livestock:
        return Icons.agriculture;
      case ProductCategory.poultry:
        return Icons.egg_alt;
      case ProductCategory.dairy:
        return Icons.local_drink;
      case ProductCategory.crops:
        return Icons.grass;
      case ProductCategory.vegetables:
        return Icons.local_florist;
      case ProductCategory.fruits:
        return Icons.apple;
      case ProductCategory.other:
        return Icons.category;
    }
  }

  Color get color {
    switch (this) {
      case ProductCategory.seeds:
        return Colors.brown;
      case ProductCategory.fertilizers:
        return Colors.green;
      case ProductCategory.pesticides:
        return Colors.red;
      case ProductCategory.animalFeed:
        return Colors.orange;
      case ProductCategory.farmTools:
        return Colors.grey;
      case ProductCategory.irrigation:
        return Colors.blue;
      case ProductCategory.livestock:
        return Colors.purple;
      case ProductCategory.poultry:
        return Colors.yellow;
      case ProductCategory.dairy:
        return Colors.indigo;
      case ProductCategory.crops:
        return Colors.lightGreen;
      case ProductCategory.vegetables:
        return Colors.teal;
      case ProductCategory.fruits:
        return Colors.pink;
      case ProductCategory.other:
        return Colors.blueGrey;
    }
  }
}

// Product Status Enum
enum ProductStatus {
  active,
  inactive,
  outOfStock,
  discontinued,
}

extension ProductStatusExtension on ProductStatus {
  String get displayName {
    switch (this) {
      case ProductStatus.active:
        return 'Active';
      case ProductStatus.inactive:
        return 'Inactive';
      case ProductStatus.outOfStock:
        return 'Out of Stock';
      case ProductStatus.discontinued:
        return 'Discontinued';
    }
  }

  Color get color {
    switch (this) {
      case ProductStatus.active:
        return Colors.green;
      case ProductStatus.inactive:
        return Colors.orange;
      case ProductStatus.outOfStock:
        return Colors.red;
      case ProductStatus.discontinued:
        return Colors.grey;
    }
  }
}

// Order Status Enum
enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
  returned,
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.returned:
        return 'Returned';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.processing:
        return Colors.purple;
      case OrderStatus.shipped:
        return Colors.indigo;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      case OrderStatus.returned:
        return Colors.brown;
    }
  }

  IconData get icon {
    switch (this) {
      case OrderStatus.pending:
        return Icons.schedule;
      case OrderStatus.confirmed:
        return Icons.check_circle;
      case OrderStatus.processing:
        return Icons.settings;
      case OrderStatus.shipped:
        return Icons.local_shipping;
      case OrderStatus.delivered:
        return Icons.done_all;
      case OrderStatus.cancelled:
        return Icons.cancel;
      case OrderStatus.returned:
        return Icons.keyboard_return;
    }
  }
}

// Supplier Type Enum
enum SupplierType {
  agrovet,
  feedSupplier,
  seedSupplier,
  fertilizerSupplier,
  retailer,
  manufacturer,
  distributor,
  other,
}

extension SupplierTypeExtension on SupplierType {
  String get displayName {
    switch (this) {
      case SupplierType.agrovet:
        return 'Agrovet';
      case SupplierType.feedSupplier:
        return 'Feed Supplier';
      case SupplierType.seedSupplier:
        return 'Seed Supplier';
      case SupplierType.fertilizerSupplier:
        return 'Fertilizer Supplier';
      case SupplierType.retailer:
        return 'General Retailer';
      case SupplierType.manufacturer:
        return 'Manufacturer';
      case SupplierType.distributor:
        return 'Distributor';
      case SupplierType.other:
        return 'Other';
    }
  }
}

// Product Model
class Product {
  final String id;
  final String name;
  final String description;
  final ProductCategory category;
  final ProductStatus status;
  final double price;
  final double? discountPrice;
  final String unit; // kg, liters, pieces, etc.
  final int stockQuantity;
  final int minStockLevel;
  final String? brand;
  final String? manufacturer;
  final List<String> imageUrls;
  final List<String> tags;
  final Map<String, dynamic> specifications;
  final double? weight;
  final String? dimensions;
  final DateTime? expiryDate;
  final String? batchNumber;
  final bool isFeatured;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.status,
    required this.price,
    this.discountPrice,
    required this.unit,
    required this.stockQuantity,
    required this.minStockLevel,
    this.brand,
    this.manufacturer,
    required this.imageUrls,
    required this.tags,
    required this.specifications,
    this.weight,
    this.dimensions,
    this.expiryDate,
    this.batchNumber,
    required this.isFeatured,
    required this.rating,
    required this.reviewCount,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isOnSale => discountPrice != null && discountPrice! < price;
  bool get isLowStock => stockQuantity <= minStockLevel;
  bool get isOutOfStock => stockQuantity <= 0;
  
  double get effectivePrice => discountPrice ?? price;
  double get discountPercentage => 
      isOnSale ? ((price - discountPrice!) / price * 100) : 0;
}

// Order Model
class Order {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final List<OrderItem> items;
  final double subtotal;
  final double taxAmount;
  final double shippingFee;
  final double discountAmount;
  final double totalAmount;
  final OrderStatus status;
  final String paymentMethod;
  final String paymentStatus;
  final String shippingAddress;
  final String? deliveryInstructions;
  final DateTime orderDate;
  final DateTime? confirmedAt;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;
  final String? trackingNumber;
  final String? notes;

  Order({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.items,
    required this.subtotal,
    required this.taxAmount,
    required this.shippingFee,
    required this.discountAmount,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.shippingAddress,
    this.deliveryInstructions,
    required this.orderDate,
    this.confirmedAt,
    this.shippedAt,
    this.deliveredAt,
    this.trackingNumber,
    this.notes,
  });

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  bool get isPaid => paymentStatus == 'paid';
  bool get canCancel => status == OrderStatus.pending || status == OrderStatus.confirmed;
}

// Order Item Model
class OrderItem {
  final String productId;
  final String productName;
  final String productImage;
  final double unitPrice;
  final int quantity;
  final double totalPrice;
  final String? variant;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.unitPrice,
    required this.quantity,
    required this.totalPrice,
    this.variant,
  });
}

// Customer Model
class Customer {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? address;
  final String? county;
  final String? farmType;
  final int totalOrders;
  final double totalSpent;
  final DateTime lastOrderDate;
  final DateTime registeredAt;
  final bool isActive;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.address,
    this.county,
    this.farmType,
    required this.totalOrders,
    required this.totalSpent,
    required this.lastOrderDate,
    required this.registeredAt,
    required this.isActive,
  });

  String get customerTier {
    if (totalSpent >= 100000) return 'Premium';
    if (totalSpent >= 50000) return 'Gold';
    if (totalSpent >= 20000) return 'Silver';
    return 'Bronze';
  }
}

// Promotion Model
class Promotion {
  final String id;
  final String name;
  final String description;
  final String type; // percentage, fixed_amount, buy_one_get_one
  final double value;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> applicableProductIds;
  final List<ProductCategory> applicableCategories;
  final double? minimumOrderAmount;
  final int? usageLimit;
  final int usageCount;
  final bool isActive;

  Promotion({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.value,
    required this.startDate,
    required this.endDate,
    required this.applicableProductIds,
    required this.applicableCategories,
    this.minimumOrderAmount,
    this.usageLimit,
    required this.usageCount,
    required this.isActive,
  });

  bool get isExpired => DateTime.now().isAfter(endDate);
  bool get isUpcoming => DateTime.now().isBefore(startDate);
  bool get isRunning => DateTime.now().isAfter(startDate) && DateTime.now().isBefore(endDate);
}

// Inventory Alert Model
class InventoryAlert {
  final String id;
  final String productId;
  final String productName;
  final String alertType; // low_stock, out_of_stock, expiring_soon
  final String message;
  final DateTime createdAt;
  final bool isRead;

  InventoryAlert({
    required this.id,
    required this.productId,
    required this.productName,
    required this.alertType,
    required this.message,
    required this.createdAt,
    required this.isRead,
  });
}
