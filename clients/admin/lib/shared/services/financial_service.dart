import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

/// Financial service for transaction and payment management
class FinancialService {
  final Dio _dio;

  FinancialService(this._dio);

  /// Get transactions with filtering and pagination
  Future<Map<String, dynamic>> getTransactions({
    int page = 1,
    int limit = 50,
    Map<String, dynamic>? filters,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        ...?filters,
      };

      final response = await _dio.get(
        '/admin/financial/transactions',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  /// Get transaction by ID
  Future<Map<String, dynamic>> getTransactionById(String transactionId) async {
    try {
      final response = await _dio.get('/admin/financial/transactions/$transactionId');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch transaction: $e');
    }
  }

  /// Create a new transaction
  Future<Map<String, dynamic>> createTransaction({
    required String userId,
    required String type,
    required double amount,
    required String currency,
    required String paymentMethod,
    String? description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _dio.post('/admin/financial/transactions', data: {
        'user_id': userId,
        'type': type,
        'amount': amount,
        'currency': currency,
        'payment_method': paymentMethod,
        if (description != null) 'description': description,
        if (metadata != null) 'metadata': metadata,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }

  /// Update transaction status
  Future<void> updateTransactionStatus(String transactionId, String status, {String? reason}) async {
    try {
      await _dio.patch('/admin/financial/transactions/$transactionId/status', data: {
        'status': status,
        if (reason != null) 'reason': reason,
      });
    } catch (e) {
      throw Exception('Failed to update transaction status: $e');
    }
  }

  /// Process refund
  Future<Map<String, dynamic>> processRefund(String transactionId, {
    double? amount,
    String? reason,
  }) async {
    try {
      final response = await _dio.post('/admin/financial/transactions/$transactionId/refund', data: {
        if (amount != null) 'amount': amount,
        if (reason != null) 'reason': reason,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to process refund: $e');
    }
  }

  /// Get financial statistics
  Future<Map<String, dynamic>> getFinancialStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
      if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();

      final response = await _dio.get(
        '/admin/financial/statistics',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch financial statistics: $e');
    }
  }

  /// Get revenue analytics
  Future<Map<String, dynamic>> getRevenueAnalytics({
    String? timeRange,
    String? granularity,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (timeRange != null) queryParams['time_range'] = timeRange;
      if (granularity != null) queryParams['granularity'] = granularity;

      final response = await _dio.get(
        '/admin/financial/revenue-analytics',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch revenue analytics: $e');
    }
  }

  /// Get fraud alerts
  Future<Map<String, dynamic>> getFraudAlerts({
    String? severity,
    String? status,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (severity != null) queryParams['severity'] = severity;
      if (status != null) queryParams['status'] = status;
      if (limit != null) queryParams['limit'] = limit;

      final response = await _dio.get(
        '/admin/financial/fraud-alerts',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch fraud alerts: $e');
    }
  }

  /// Create fraud alert
  Future<Map<String, dynamic>> createFraudAlert({
    required String transactionId,
    required String alertType,
    required String severity,
    required String description,
    required double riskScore,
    required Map<String, dynamic> riskFactors,
  }) async {
    try {
      final response = await _dio.post('/admin/financial/fraud-alerts', data: {
        'transaction_id': transactionId,
        'alert_type': alertType,
        'severity': severity,
        'description': description,
        'risk_score': riskScore,
        'risk_factors': riskFactors,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to create fraud alert: $e');
    }
  }

  /// Resolve fraud alert
  Future<void> resolveFraudAlert(String alertId, String resolution) async {
    try {
      await _dio.patch('/admin/financial/fraud-alerts/$alertId/resolve', data: {
        'resolution': resolution,
      });
    } catch (e) {
      throw Exception('Failed to resolve fraud alert: $e');
    }
  }

  /// Get payment methods
  Future<Map<String, dynamic>> getPaymentMethods() async {
    try {
      final response = await _dio.get('/admin/financial/payment-methods');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch payment methods: $e');
    }
  }

  /// Create payment method
  Future<Map<String, dynamic>> createPaymentMethod({
    required String name,
    required String type,
    required Map<String, dynamic> configuration,
    required double processingFee,
    required String currency,
    required List<String> supportedCountries,
  }) async {
    try {
      final response = await _dio.post('/admin/financial/payment-methods', data: {
        'name': name,
        'type': type,
        'configuration': configuration,
        'processing_fee': processingFee,
        'currency': currency,
        'supported_countries': supportedCountries,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to create payment method: $e');
    }
  }

  /// Update payment method
  Future<void> updatePaymentMethod(String methodId, Map<String, dynamic> updates) async {
    try {
      await _dio.patch('/admin/financial/payment-methods/$methodId', data: updates);
    } catch (e) {
      throw Exception('Failed to update payment method: $e');
    }
  }

  /// Delete payment method
  Future<void> deletePaymentMethod(String methodId) async {
    try {
      await _dio.delete('/admin/financial/payment-methods/$methodId');
    } catch (e) {
      throw Exception('Failed to delete payment method: $e');
    }
  }

  /// Get transaction disputes
  Future<Map<String, dynamic>> getTransactionDisputes({
    String? status,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;
      if (limit != null) queryParams['limit'] = limit;

      final response = await _dio.get(
        '/admin/financial/disputes',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch transaction disputes: $e');
    }
  }

  /// Handle transaction dispute
  Future<void> handleTransactionDispute(String disputeId, String action, {String? notes}) async {
    try {
      await _dio.patch('/admin/financial/disputes/$disputeId', data: {
        'action': action,
        if (notes != null) 'notes': notes,
      });
    } catch (e) {
      throw Exception('Failed to handle transaction dispute: $e');
    }
  }

  /// Get chargeback information
  Future<Map<String, dynamic>> getChargebacks({
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;
      if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
      if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();

      final response = await _dio.get(
        '/admin/financial/chargebacks',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch chargebacks: $e');
    }
  }

  /// Process chargeback
  Future<void> processChargeback(String chargebackId, String action, {String? evidence}) async {
    try {
      await _dio.patch('/admin/financial/chargebacks/$chargebackId', data: {
        'action': action,
        if (evidence != null) 'evidence': evidence,
      });
    } catch (e) {
      throw Exception('Failed to process chargeback: $e');
    }
  }

  /// Get financial reports
  Future<Map<String, dynamic>> getFinancialReports({
    required String reportType,
    DateTime? startDate,
    DateTime? endDate,
    String? format,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'report_type': reportType,
      };
      if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
      if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();
      if (format != null) queryParams['format'] = format;

      final response = await _dio.get(
        '/admin/financial/reports',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch financial reports: $e');
    }
  }

  /// Generate financial report
  Future<String> generateFinancialReport({
    required String reportType,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? metrics,
    String? format,
  }) async {
    try {
      final response = await _dio.post('/admin/financial/reports/generate', data: {
        'report_type': reportType,
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
        if (metrics != null) 'metrics': metrics,
        if (format != null) 'format': format,
      });
      return response.data['data']['download_url'] as String;
    } catch (e) {
      throw Exception('Failed to generate financial report: $e');
    }
  }

  /// Get compliance data
  Future<Map<String, dynamic>> getComplianceData({
    String? complianceType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (complianceType != null) queryParams['compliance_type'] = complianceType;
      if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
      if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();

      final response = await _dio.get(
        '/admin/financial/compliance',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch compliance data: $e');
    }
  }

  /// Export transactions
  Future<String> exportTransactions({
    Map<String, dynamic>? filters,
    String? format,
    List<String>? fields,
  }) async {
    try {
      final response = await _dio.post('/admin/financial/transactions/export', data: {
        if (filters != null) 'filters': filters,
        if (format != null) 'format': format,
        if (fields != null) 'fields': fields,
      });
      return response.data['data']['download_url'] as String;
    } catch (e) {
      throw Exception('Failed to export transactions: $e');
    }
  }

  /// Bulk transaction operations
  Future<Map<String, dynamic>> bulkTransactionOperation({
    required List<String> transactionIds,
    required String operation,
    Map<String, dynamic>? operationData,
  }) async {
    try {
      final response = await _dio.post('/admin/financial/transactions/bulk-operation', data: {
        'transaction_ids': transactionIds,
        'operation': operation,
        if (operationData != null) 'operation_data': operationData,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to perform bulk transaction operation: $e');
    }
  }

  /// Get transaction analytics
  Future<Map<String, dynamic>> getTransactionAnalytics({
    String? timeRange,
    String? groupBy,
    List<String>? metrics,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (timeRange != null) queryParams['time_range'] = timeRange;
      if (groupBy != null) queryParams['group_by'] = groupBy;
      if (metrics != null) queryParams['metrics'] = metrics.join(',');

      final response = await _dio.get(
        '/admin/financial/analytics',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch transaction analytics: $e');
    }
  }

  /// Get payment processor status
  Future<Map<String, dynamic>> getPaymentProcessorStatus() async {
    try {
      final response = await _dio.get('/admin/financial/processor-status');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch payment processor status: $e');
    }
  }

  /// Test payment processor connection
  Future<Map<String, dynamic>> testPaymentProcessorConnection(String processorId) async {
    try {
      final response = await _dio.post('/admin/financial/test-processor', data: {
        'processor_id': processorId,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to test payment processor connection: $e');
    }
  }

  /// Get financial audit logs
  Future<Map<String, dynamic>> getFinancialAuditLogs({
    String? action,
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (action != null) queryParams['action'] = action;
      if (userId != null) queryParams['user_id'] = userId;
      if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
      if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();
      if (limit != null) queryParams['limit'] = limit;

      final response = await _dio.get(
        '/admin/financial/audit-logs',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch financial audit logs: $e');
    }
  }
}

/// Financial service provider
final financialServiceProvider = Provider<FinancialService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return FinancialService(apiService.dio);
});
