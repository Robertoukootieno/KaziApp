class BusinessAnalytics {
  final String providerId;
  final DateTime periodStart;
  final DateTime periodEnd;
  final RevenueAnalytics revenue;
  final BookingAnalytics bookings;
  final CustomerAnalytics customers;
  final ServiceAnalytics services;
  final InventoryAnalytics inventory;
  final PerformanceMetrics performance;
  final List<TrendData> trends;
  final DateTime generatedAt;

  BusinessAnalytics({
    required this.providerId,
    required this.periodStart,
    required this.periodEnd,
    required this.revenue,
    required this.bookings,
    required this.customers,
    required this.services,
    required this.inventory,
    required this.performance,
    required this.trends,
    required this.generatedAt,
  });

  factory BusinessAnalytics.fromJson(Map<String, dynamic> json) {
    return BusinessAnalytics(
      providerId: json['providerId'],
      periodStart: DateTime.parse(json['periodStart']),
      periodEnd: DateTime.parse(json['periodEnd']),
      revenue: RevenueAnalytics.fromJson(json['revenue']),
      bookings: BookingAnalytics.fromJson(json['bookings']),
      customers: CustomerAnalytics.fromJson(json['customers']),
      services: ServiceAnalytics.fromJson(json['services']),
      inventory: InventoryAnalytics.fromJson(json['inventory']),
      performance: PerformanceMetrics.fromJson(json['performance']),
      trends: (json['trends'] as List)
          .map((trend) => TrendData.fromJson(trend))
          .toList(),
      generatedAt: DateTime.parse(json['generatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'providerId': providerId,
      'periodStart': periodStart.toIso8601String(),
      'periodEnd': periodEnd.toIso8601String(),
      'revenue': revenue.toJson(),
      'bookings': bookings.toJson(),
      'customers': customers.toJson(),
      'services': services.toJson(),
      'inventory': inventory.toJson(),
      'performance': performance.toJson(),
      'trends': trends.map((trend) => trend.toJson()).toList(),
      'generatedAt': generatedAt.toIso8601String(),
    };
  }
}

class RevenueAnalytics {
  final double totalRevenue;
  final double previousPeriodRevenue;
  final double growthRate;
  final double averageOrderValue;
  final double totalExpenses;
  final double netProfit;
  final double profitMargin;
  final Map<String, double> revenueByService;
  final Map<String, double> revenueByMonth;
  final List<PaymentMethodStats> paymentMethods;

  RevenueAnalytics({
    required this.totalRevenue,
    required this.previousPeriodRevenue,
    required this.growthRate,
    required this.averageOrderValue,
    required this.totalExpenses,
    required this.netProfit,
    required this.profitMargin,
    required this.revenueByService,
    required this.revenueByMonth,
    required this.paymentMethods,
  });

  factory RevenueAnalytics.fromJson(Map<String, dynamic> json) {
    return RevenueAnalytics(
      totalRevenue: (json['totalRevenue'] ?? 0.0).toDouble(),
      previousPeriodRevenue: (json['previousPeriodRevenue'] ?? 0.0).toDouble(),
      growthRate: (json['growthRate'] ?? 0.0).toDouble(),
      averageOrderValue: (json['averageOrderValue'] ?? 0.0).toDouble(),
      totalExpenses: (json['totalExpenses'] ?? 0.0).toDouble(),
      netProfit: (json['netProfit'] ?? 0.0).toDouble(),
      profitMargin: (json['profitMargin'] ?? 0.0).toDouble(),
      revenueByService: Map<String, double>.from(json['revenueByService'] ?? {}),
      revenueByMonth: Map<String, double>.from(json['revenueByMonth'] ?? {}),
      paymentMethods: (json['paymentMethods'] as List?)
          ?.map((pm) => PaymentMethodStats.fromJson(pm))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRevenue': totalRevenue,
      'previousPeriodRevenue': previousPeriodRevenue,
      'growthRate': growthRate,
      'averageOrderValue': averageOrderValue,
      'totalExpenses': totalExpenses,
      'netProfit': netProfit,
      'profitMargin': profitMargin,
      'revenueByService': revenueByService,
      'revenueByMonth': revenueByMonth,
      'paymentMethods': paymentMethods.map((pm) => pm.toJson()).toList(),
    };
  }
}

class BookingAnalytics {
  final int totalBookings;
  final int previousPeriodBookings;
  final double bookingGrowthRate;
  final int completedBookings;
  final int cancelledBookings;
  final int noShowBookings;
  final double completionRate;
  final double cancellationRate;
  final double averageBookingValue;
  final Map<String, int> bookingsByStatus;
  final Map<String, int> bookingsByService;
  final Map<String, int> bookingsByDay;
  final List<PeakHour> peakHours;

  BookingAnalytics({
    required this.totalBookings,
    required this.previousPeriodBookings,
    required this.bookingGrowthRate,
    required this.completedBookings,
    required this.cancelledBookings,
    required this.noShowBookings,
    required this.completionRate,
    required this.cancellationRate,
    required this.averageBookingValue,
    required this.bookingsByStatus,
    required this.bookingsByService,
    required this.bookingsByDay,
    required this.peakHours,
  });

  factory BookingAnalytics.fromJson(Map<String, dynamic> json) {
    return BookingAnalytics(
      totalBookings: json['totalBookings'] ?? 0,
      previousPeriodBookings: json['previousPeriodBookings'] ?? 0,
      bookingGrowthRate: (json['bookingGrowthRate'] ?? 0.0).toDouble(),
      completedBookings: json['completedBookings'] ?? 0,
      cancelledBookings: json['cancelledBookings'] ?? 0,
      noShowBookings: json['noShowBookings'] ?? 0,
      completionRate: (json['completionRate'] ?? 0.0).toDouble(),
      cancellationRate: (json['cancellationRate'] ?? 0.0).toDouble(),
      averageBookingValue: (json['averageBookingValue'] ?? 0.0).toDouble(),
      bookingsByStatus: Map<String, int>.from(json['bookingsByStatus'] ?? {}),
      bookingsByService: Map<String, int>.from(json['bookingsByService'] ?? {}),
      bookingsByDay: Map<String, int>.from(json['bookingsByDay'] ?? {}),
      peakHours: (json['peakHours'] as List?)
          ?.map((ph) => PeakHour.fromJson(ph))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalBookings': totalBookings,
      'previousPeriodBookings': previousPeriodBookings,
      'bookingGrowthRate': bookingGrowthRate,
      'completedBookings': completedBookings,
      'cancelledBookings': cancelledBookings,
      'noShowBookings': noShowBookings,
      'completionRate': completionRate,
      'cancellationRate': cancellationRate,
      'averageBookingValue': averageBookingValue,
      'bookingsByStatus': bookingsByStatus,
      'bookingsByService': bookingsByService,
      'bookingsByDay': bookingsByDay,
      'peakHours': peakHours.map((ph) => ph.toJson()).toList(),
    };
  }
}

class CustomerAnalytics {
  final int totalCustomers;
  final int newCustomers;
  final int returningCustomers;
  final double customerRetentionRate;
  final double customerLifetimeValue;
  final double averageCustomerSpend;
  final Map<String, int> customersByType;
  final Map<String, int> customersByLocation;
  final List<TopCustomer> topCustomers;

  CustomerAnalytics({
    required this.totalCustomers,
    required this.newCustomers,
    required this.returningCustomers,
    required this.customerRetentionRate,
    required this.customerLifetimeValue,
    required this.averageCustomerSpend,
    required this.customersByType,
    required this.customersByLocation,
    required this.topCustomers,
  });

  factory CustomerAnalytics.fromJson(Map<String, dynamic> json) {
    return CustomerAnalytics(
      totalCustomers: json['totalCustomers'] ?? 0,
      newCustomers: json['newCustomers'] ?? 0,
      returningCustomers: json['returningCustomers'] ?? 0,
      customerRetentionRate: (json['customerRetentionRate'] ?? 0.0).toDouble(),
      customerLifetimeValue: (json['customerLifetimeValue'] ?? 0.0).toDouble(),
      averageCustomerSpend: (json['averageCustomerSpend'] ?? 0.0).toDouble(),
      customersByType: Map<String, int>.from(json['customersByType'] ?? {}),
      customersByLocation: Map<String, int>.from(json['customersByLocation'] ?? {}),
      topCustomers: (json['topCustomers'] as List?)
          ?.map((tc) => TopCustomer.fromJson(tc))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCustomers': totalCustomers,
      'newCustomers': newCustomers,
      'returningCustomers': returningCustomers,
      'customerRetentionRate': customerRetentionRate,
      'customerLifetimeValue': customerLifetimeValue,
      'averageCustomerSpend': averageCustomerSpend,
      'customersByType': customersByType,
      'customersByLocation': customersByLocation,
      'topCustomers': topCustomers.map((tc) => tc.toJson()).toList(),
    };
  }
}

class ServiceAnalytics {
  final int totalServices;
  final int activeServices;
  final Map<String, int> servicePopularity;
  final Map<String, double> serviceRevenue;
  final Map<String, double> serviceRatings;
  final List<TopService> topServices;
  final List<UnderperformingService> underperformingServices;

  ServiceAnalytics({
    required this.totalServices,
    required this.activeServices,
    required this.servicePopularity,
    required this.serviceRevenue,
    required this.serviceRatings,
    required this.topServices,
    required this.underperformingServices,
  });

  factory ServiceAnalytics.fromJson(Map<String, dynamic> json) {
    return ServiceAnalytics(
      totalServices: json['totalServices'] ?? 0,
      activeServices: json['activeServices'] ?? 0,
      servicePopularity: Map<String, int>.from(json['servicePopularity'] ?? {}),
      serviceRevenue: Map<String, double>.from(json['serviceRevenue'] ?? {}),
      serviceRatings: Map<String, double>.from(json['serviceRatings'] ?? {}),
      topServices: (json['topServices'] as List?)
          ?.map((ts) => TopService.fromJson(ts))
          .toList() ?? [],
      underperformingServices: (json['underperformingServices'] as List?)
          ?.map((us) => UnderperformingService.fromJson(us))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalServices': totalServices,
      'activeServices': activeServices,
      'servicePopularity': servicePopularity,
      'serviceRevenue': serviceRevenue,
      'serviceRatings': serviceRatings,
      'topServices': topServices.map((ts) => ts.toJson()).toList(),
      'underperformingServices': underperformingServices.map((us) => us.toJson()).toList(),
    };
  }
}

class InventoryAnalytics {
  final int totalItems;
  final int lowStockItems;
  final int outOfStockItems;
  final int expiredItems;
  final int expiringSoonItems;
  final double totalInventoryValue;
  final double averageStockTurnover;
  final Map<String, int> itemsByCategory;
  final List<FastMovingItem> fastMovingItems;
  final List<SlowMovingItem> slowMovingItems;

  InventoryAnalytics({
    required this.totalItems,
    required this.lowStockItems,
    required this.outOfStockItems,
    required this.expiredItems,
    required this.expiringSoonItems,
    required this.totalInventoryValue,
    required this.averageStockTurnover,
    required this.itemsByCategory,
    required this.fastMovingItems,
    required this.slowMovingItems,
  });

  factory InventoryAnalytics.fromJson(Map<String, dynamic> json) {
    return InventoryAnalytics(
      totalItems: json['totalItems'] ?? 0,
      lowStockItems: json['lowStockItems'] ?? 0,
      outOfStockItems: json['outOfStockItems'] ?? 0,
      expiredItems: json['expiredItems'] ?? 0,
      expiringSoonItems: json['expiringSoonItems'] ?? 0,
      totalInventoryValue: (json['totalInventoryValue'] ?? 0.0).toDouble(),
      averageStockTurnover: (json['averageStockTurnover'] ?? 0.0).toDouble(),
      itemsByCategory: Map<String, int>.from(json['itemsByCategory'] ?? {}),
      fastMovingItems: (json['fastMovingItems'] as List?)
          ?.map((fmi) => FastMovingItem.fromJson(fmi))
          .toList() ?? [],
      slowMovingItems: (json['slowMovingItems'] as List?)
          ?.map((smi) => SlowMovingItem.fromJson(smi))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalItems': totalItems,
      'lowStockItems': lowStockItems,
      'outOfStockItems': outOfStockItems,
      'expiredItems': expiredItems,
      'expiringSoonItems': expiringSoonItems,
      'totalInventoryValue': totalInventoryValue,
      'averageStockTurnover': averageStockTurnover,
      'itemsByCategory': itemsByCategory,
      'fastMovingItems': fastMovingItems.map((fmi) => fmi.toJson()).toList(),
      'slowMovingItems': slowMovingItems.map((smi) => smi.toJson()).toList(),
    };
  }
}

class PerformanceMetrics {
  final double overallRating;
  final int totalReviews;
  final double responseTime; // in hours
  final double onTimeDeliveryRate;
  final double customerSatisfactionScore;
  final int repeatCustomerRate;
  final Map<String, double> ratingDistribution;

  PerformanceMetrics({
    required this.overallRating,
    required this.totalReviews,
    required this.responseTime,
    required this.onTimeDeliveryRate,
    required this.customerSatisfactionScore,
    required this.repeatCustomerRate,
    required this.ratingDistribution,
  });

  factory PerformanceMetrics.fromJson(Map<String, dynamic> json) {
    return PerformanceMetrics(
      overallRating: (json['overallRating'] ?? 0.0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      responseTime: (json['responseTime'] ?? 0.0).toDouble(),
      onTimeDeliveryRate: (json['onTimeDeliveryRate'] ?? 0.0).toDouble(),
      customerSatisfactionScore: (json['customerSatisfactionScore'] ?? 0.0).toDouble(),
      repeatCustomerRate: json['repeatCustomerRate'] ?? 0,
      ratingDistribution: Map<String, double>.from(json['ratingDistribution'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overallRating': overallRating,
      'totalReviews': totalReviews,
      'responseTime': responseTime,
      'onTimeDeliveryRate': onTimeDeliveryRate,
      'customerSatisfactionScore': customerSatisfactionScore,
      'repeatCustomerRate': repeatCustomerRate,
      'ratingDistribution': ratingDistribution,
    };
  }
}

// Supporting classes for analytics
class TrendData {
  final String metric;
  final List<DataPoint> dataPoints;
  final String period;
  final double changePercentage;

  TrendData({
    required this.metric,
    required this.dataPoints,
    required this.period,
    required this.changePercentage,
  });

  factory TrendData.fromJson(Map<String, dynamic> json) {
    return TrendData(
      metric: json['metric'],
      dataPoints: (json['dataPoints'] as List)
          .map((dp) => DataPoint.fromJson(dp))
          .toList(),
      period: json['period'],
      changePercentage: (json['changePercentage'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'metric': metric,
      'dataPoints': dataPoints.map((dp) => dp.toJson()).toList(),
      'period': period,
      'changePercentage': changePercentage,
    };
  }
}

class DataPoint {
  final String label;
  final double value;
  final DateTime timestamp;

  DataPoint({
    required this.label,
    required this.value,
    required this.timestamp,
  });

  factory DataPoint.fromJson(Map<String, dynamic> json) {
    return DataPoint(
      label: json['label'],
      value: (json['value'] ?? 0.0).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class PaymentMethodStats {
  final String method;
  final double amount;
  final int count;
  final double percentage;

  PaymentMethodStats({
    required this.method,
    required this.amount,
    required this.count,
    required this.percentage,
  });

  factory PaymentMethodStats.fromJson(Map<String, dynamic> json) {
    return PaymentMethodStats(
      method: json['method'],
      amount: (json['amount'] ?? 0.0).toDouble(),
      count: json['count'] ?? 0,
      percentage: (json['percentage'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'amount': amount,
      'count': count,
      'percentage': percentage,
    };
  }
}

class PeakHour {
  final int hour;
  final int bookingCount;
  final String timeRange;

  PeakHour({
    required this.hour,
    required this.bookingCount,
    required this.timeRange,
  });

  factory PeakHour.fromJson(Map<String, dynamic> json) {
    return PeakHour(
      hour: json['hour'],
      bookingCount: json['bookingCount'],
      timeRange: json['timeRange'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hour': hour,
      'bookingCount': bookingCount,
      'timeRange': timeRange,
    };
  }
}

class TopCustomer {
  final String id;
  final String name;
  final double totalSpent;
  final int bookingCount;

  TopCustomer({
    required this.id,
    required this.name,
    required this.totalSpent,
    required this.bookingCount,
  });

  factory TopCustomer.fromJson(Map<String, dynamic> json) {
    return TopCustomer(
      id: json['id'],
      name: json['name'],
      totalSpent: (json['totalSpent'] ?? 0.0).toDouble(),
      bookingCount: json['bookingCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'totalSpent': totalSpent,
      'bookingCount': bookingCount,
    };
  }
}

class TopService {
  final String id;
  final String name;
  final double revenue;
  final int bookingCount;
  final double rating;

  TopService({
    required this.id,
    required this.name,
    required this.revenue,
    required this.bookingCount,
    required this.rating,
  });

  factory TopService.fromJson(Map<String, dynamic> json) {
    return TopService(
      id: json['id'],
      name: json['name'],
      revenue: (json['revenue'] ?? 0.0).toDouble(),
      bookingCount: json['bookingCount'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'revenue': revenue,
      'bookingCount': bookingCount,
      'rating': rating,
    };
  }
}

class UnderperformingService {
  final String id;
  final String name;
  final double revenue;
  final int bookingCount;
  final double rating;
  final String reason;

  UnderperformingService({
    required this.id,
    required this.name,
    required this.revenue,
    required this.bookingCount,
    required this.rating,
    required this.reason,
  });

  factory UnderperformingService.fromJson(Map<String, dynamic> json) {
    return UnderperformingService(
      id: json['id'],
      name: json['name'],
      revenue: (json['revenue'] ?? 0.0).toDouble(),
      bookingCount: json['bookingCount'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      reason: json['reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'revenue': revenue,
      'bookingCount': bookingCount,
      'rating': rating,
      'reason': reason,
    };
  }
}

class FastMovingItem {
  final String id;
  final String name;
  final double turnoverRate;
  final int unitsSold;

  FastMovingItem({
    required this.id,
    required this.name,
    required this.turnoverRate,
    required this.unitsSold,
  });

  factory FastMovingItem.fromJson(Map<String, dynamic> json) {
    return FastMovingItem(
      id: json['id'],
      name: json['name'],
      turnoverRate: (json['turnoverRate'] ?? 0.0).toDouble(),
      unitsSold: json['unitsSold'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'turnoverRate': turnoverRate,
      'unitsSold': unitsSold,
    };
  }
}

class SlowMovingItem {
  final String id;
  final String name;
  final double turnoverRate;
  final int daysInStock;
  final double currentStock;

  SlowMovingItem({
    required this.id,
    required this.name,
    required this.turnoverRate,
    required this.daysInStock,
    required this.currentStock,
  });

  factory SlowMovingItem.fromJson(Map<String, dynamic> json) {
    return SlowMovingItem(
      id: json['id'],
      name: json['name'],
      turnoverRate: (json['turnoverRate'] ?? 0.0).toDouble(),
      daysInStock: json['daysInStock'] ?? 0,
      currentStock: (json['currentStock'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'turnoverRate': turnoverRate,
      'daysInStock': daysInStock,
      'currentStock': currentStock,
    };
  }
}
