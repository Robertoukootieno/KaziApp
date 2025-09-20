import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/services/financial_service.dart';

/// Transaction search filters
class TransactionSearchFilters {
  final String? search;
  final String? type;
  final String? status;
  final String? paymentMethod;
  final double? minAmount;
  final double? maxAmount;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? userId;
  final String? sortBy;
  final String? sortOrder;

  const TransactionSearchFilters({
    this.search,
    this.type,
    this.status,
    this.paymentMethod,
    this.minAmount,
    this.maxAmount,
    this.startDate,
    this.endDate,
    this.userId,
    this.sortBy,
    this.sortOrder,
  });

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};
    
    if (search != null && search!.isNotEmpty) params['search'] = search;
    if (type != null) params['type'] = type;
    if (status != null) params['status'] = status;
    if (paymentMethod != null) params['payment_method'] = paymentMethod;
    if (minAmount != null) params['min_amount'] = minAmount;
    if (maxAmount != null) params['max_amount'] = maxAmount;
    if (startDate != null) params['start_date'] = startDate!.toIso8601String();
    if (endDate != null) params['end_date'] = endDate!.toIso8601String();
    if (userId != null) params['user_id'] = userId;
    if (sortBy != null) params['sort_by'] = sortBy;
    if (sortOrder != null) params['sort_order'] = sortOrder;
    
    return params;
  }
}

/// Financial transaction model
class FinancialTransaction {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String type;
  final double amount;
  final String currency;
  final String status;
  final String paymentMethod;
  final String? description;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? failureReason;

  const FinancialTransaction({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.type,
    required this.amount,
    required this.currency,
    required this.status,
    required this.paymentMethod,
    this.description,
    this.metadata,
    required this.createdAt,
    this.completedAt,
    this.failureReason,
  });

  factory FinancialTransaction.fromJson(Map<String, dynamic> json) {
    return FinancialTransaction(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      userEmail: json['user_email'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      status: json['status'] as String,
      paymentMethod: json['payment_method'] as String,
      description: json['description'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      failureReason: json['failure_reason'] as String?,
    );
  }
}

/// Financial statistics model
class FinancialStatistics {
  final double totalRevenue;
  final double totalTransactions;
  final int transactionCount;
  final double averageTransactionValue;
  final double pendingAmount;
  final double refundedAmount;
  final Map<String, double> revenueByType;
  final Map<String, int> transactionsByStatus;
  final Map<String, double> revenueByPaymentMethod;
  final List<Map<String, dynamic>> revenueHistory;
  final double fraudRate;
  final double chargebackRate;

  const FinancialStatistics({
    required this.totalRevenue,
    required this.totalTransactions,
    required this.transactionCount,
    required this.averageTransactionValue,
    required this.pendingAmount,
    required this.refundedAmount,
    required this.revenueByType,
    required this.transactionsByStatus,
    required this.revenueByPaymentMethod,
    required this.revenueHistory,
    required this.fraudRate,
    required this.chargebackRate,
  });

  factory FinancialStatistics.fromJson(Map<String, dynamic> json) {
    return FinancialStatistics(
      totalRevenue: (json['total_revenue'] as num).toDouble(),
      totalTransactions: (json['total_transactions'] as num).toDouble(),
      transactionCount: json['transaction_count'] as int,
      averageTransactionValue: (json['average_transaction_value'] as num).toDouble(),
      pendingAmount: (json['pending_amount'] as num).toDouble(),
      refundedAmount: (json['refunded_amount'] as num).toDouble(),
      revenueByType: Map<String, double>.from(
        (json['revenue_by_type'] as Map).map(
          (key, value) => MapEntry(key as String, (value as num).toDouble()),
        ),
      ),
      transactionsByStatus: Map<String, int>.from(json['transactions_by_status'] as Map),
      revenueByPaymentMethod: Map<String, double>.from(
        (json['revenue_by_payment_method'] as Map).map(
          (key, value) => MapEntry(key as String, (value as num).toDouble()),
        ),
      ),
      revenueHistory: List<Map<String, dynamic>>.from(json['revenue_history'] as List),
      fraudRate: (json['fraud_rate'] as num).toDouble(),
      chargebackRate: (json['chargeback_rate'] as num).toDouble(),
    );
  }
}

/// Fraud alert model
class FraudAlert {
  final String id;
  final String transactionId;
  final String userId;
  final String alertType;
  final String severity;
  final String description;
  final double riskScore;
  final Map<String, dynamic> riskFactors;
  final String status;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? resolvedBy;

  const FraudAlert({
    required this.id,
    required this.transactionId,
    required this.userId,
    required this.alertType,
    required this.severity,
    required this.description,
    required this.riskScore,
    required this.riskFactors,
    required this.status,
    required this.createdAt,
    this.resolvedAt,
    this.resolvedBy,
  });

  factory FraudAlert.fromJson(Map<String, dynamic> json) {
    return FraudAlert(
      id: json['id'] as String,
      transactionId: json['transaction_id'] as String,
      userId: json['user_id'] as String,
      alertType: json['alert_type'] as String,
      severity: json['severity'] as String,
      description: json['description'] as String,
      riskScore: (json['risk_score'] as num).toDouble(),
      riskFactors: json['risk_factors'] as Map<String, dynamic>,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      resolvedAt: json['resolved_at'] != null 
          ? DateTime.parse(json['resolved_at'] as String)
          : null,
      resolvedBy: json['resolved_by'] as String?,
    );
  }
}

/// Payment method model
class PaymentMethod {
  final String id;
  final String name;
  final String type;
  final bool isActive;
  final Map<String, dynamic> configuration;
  final double processingFee;
  final String currency;
  final List<String> supportedCountries;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.type,
    required this.isActive,
    required this.configuration,
    required this.processingFee,
    required this.currency,
    required this.supportedCountries,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      isActive: json['is_active'] as bool,
      configuration: json['configuration'] as Map<String, dynamic>,
      processingFee: (json['processing_fee'] as num).toDouble(),
      currency: json['currency'] as String,
      supportedCountries: List<String>.from(json['supported_countries'] as List),
    );
  }
}

/// Transaction list state notifier
class TransactionListNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final FinancialService _service;

  TransactionListNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadTransactions({
    int page = 1,
    int limit = 50,
    TransactionSearchFilters? filters,
  }) async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getTransactions(
        page: page,
        limit: limit,
        filters: filters?.toQueryParameters(),
      );
      
      final transactions = (result['transactions'] as List)
          .map((json) => FinancialTransaction.fromJson(json))
          .toList();
      
      state = AsyncValue.data({
        'transactions': transactions,
        'total': result['total'],
        'page': result['page'],
        'limit': result['limit'],
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Financial statistics state notifier
class FinancialStatisticsNotifier extends StateNotifier<AsyncValue<FinancialStatistics>> {
  final FinancialService _service;

  FinancialStatisticsNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getFinancialStatistics(
        startDate: startDate,
        endDate: endDate,
      );
      state = AsyncValue.data(FinancialStatistics.fromJson(result));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Fraud alerts state notifier
class FraudAlertsNotifier extends StateNotifier<AsyncValue<List<FraudAlert>>> {
  final FinancialService _service;

  FraudAlertsNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadAlerts({
    String? severity,
    String? status,
    int? limit,
  }) async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getFraudAlerts(
        severity: severity,
        status: status,
        limit: limit,
      );
      final alerts = (result['alerts'] as List)
          .map((json) => FraudAlert.fromJson(json))
          .toList();
      state = AsyncValue.data(alerts);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> resolveAlert(String alertId, String resolution) async {
    try {
      await _service.resolveFraudAlert(alertId, resolution);
      await loadAlerts(); // Refresh alerts
    } catch (error) {
      rethrow;
    }
  }
}

/// Revenue analytics state notifier
class RevenueAnalyticsNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final FinancialService _service;

  RevenueAnalyticsNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadAnalytics({
    String? timeRange,
    String? granularity,
  }) async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getRevenueAnalytics(
        timeRange: timeRange,
        granularity: granularity,
      );
      state = AsyncValue.data(result);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Payment methods state notifier
class PaymentMethodsNotifier extends StateNotifier<AsyncValue<List<PaymentMethod>>> {
  final FinancialService _service;

  PaymentMethodsNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadPaymentMethods() async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getPaymentMethods();
      final methods = (result['payment_methods'] as List)
          .map((json) => PaymentMethod.fromJson(json))
          .toList();
      state = AsyncValue.data(methods);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updatePaymentMethod(String methodId, Map<String, dynamic> updates) async {
    try {
      await _service.updatePaymentMethod(methodId, updates);
      await loadPaymentMethods(); // Refresh methods
    } catch (error) {
      rethrow;
    }
  }
}

/// Providers
final transactionListProvider = StateNotifierProvider<TransactionListNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  final service = ref.watch(financialServiceProvider);
  return TransactionListNotifier(service);
});

final financialStatisticsProvider = StateNotifierProvider<FinancialStatisticsNotifier, AsyncValue<FinancialStatistics>>((ref) {
  final service = ref.watch(financialServiceProvider);
  return FinancialStatisticsNotifier(service);
});

final fraudAlertsProvider = StateNotifierProvider<FraudAlertsNotifier, AsyncValue<List<FraudAlert>>>((ref) {
  final service = ref.watch(financialServiceProvider);
  return FraudAlertsNotifier(service);
});

final revenueAnalyticsProvider = StateNotifierProvider<RevenueAnalyticsNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  final service = ref.watch(financialServiceProvider);
  return RevenueAnalyticsNotifier(service);
});

final paymentMethodsProvider = StateNotifierProvider<PaymentMethodsNotifier, AsyncValue<List<PaymentMethod>>>((ref) {
  final service = ref.watch(financialServiceProvider);
  return PaymentMethodsNotifier(service);
});

/// Selected transaction provider
final selectedTransactionProvider = StateProvider<String?>((ref) => null);

/// Transaction details provider
final transactionDetailsProvider = FutureProvider.family<FinancialTransaction, String>((ref, transactionId) async {
  final service = ref.watch(financialServiceProvider);
  final result = await service.getTransactionById(transactionId);
  return FinancialTransaction.fromJson(result);
});

/// Active fraud alerts count provider
final activeFraudAlertsCountProvider = Provider<int>((ref) {
  final alertsAsync = ref.watch(fraudAlertsProvider);
  return alertsAsync.when(
    data: (alerts) => alerts.where((alert) => alert.status != 'resolved').length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// High-risk transactions provider
final highRiskTransactionsProvider = Provider<List<FinancialTransaction>>((ref) {
  final transactionsAsync = ref.watch(transactionListProvider);
  return transactionsAsync.when(
    data: (data) {
      final transactions = data['transactions'] as List<FinancialTransaction>;
      return transactions.where((transaction) => 
          transaction.amount > 1000 || transaction.status == 'pending').toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
