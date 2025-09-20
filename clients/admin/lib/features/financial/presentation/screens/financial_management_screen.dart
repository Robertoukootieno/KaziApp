import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/permission_manager.dart';
import '../../../../shared/models/admin_user.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../providers/financial_providers.dart';
import '../widgets/financial_stats_cards.dart';
import '../widgets/transaction_filters_widget.dart';
import '../widgets/fraud_detection_widget.dart';
import '../widgets/payment_processing_widget.dart';
import '../widgets/revenue_analytics_widget.dart';
import '../widgets/financial_reports_widget.dart';

class FinancialManagementScreen extends ConsumerStatefulWidget {
  const FinancialManagementScreen({super.key});

  @override
  ConsumerState<FinancialManagementScreen> createState() =>
      _FinancialManagementScreenState();
}

class _FinancialManagementScreenState
    extends ConsumerState<FinancialManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final Set<String> _selectedTransactions = {};
  TransactionSearchFilters _currentFilters = const TransactionSearchFilters();

  final List<String> _tabs = [
    'Transaction Overview',
    'Payment Processing',
    'Fraud Detection',
    'Revenue Analytics',
    'Financial Reports',
    'Compliance',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    ref.read(transactionListProvider.notifier).loadTransactions();
    ref.read(financialStatisticsProvider.notifier).loadStatistics();
    ref.read(fraudAlertsProvider.notifier).loadAlerts();
    ref.read(revenueAnalyticsProvider.notifier).loadAnalytics();
    ref.read(paymentMethodsProvider.notifier).loadPaymentMethods();
  }

  @override
  Widget build(BuildContext context) {
    final permissionManager = ref.watch(permissionManagerProvider);
    
    // Check permissions
    if (!permissionManager.checkCategoryAccess(PermissionCategory.financialManagement).granted) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('Access Denied'),
              Text('You don\'t have permission to access financial management.'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildStatsSection(),
          _buildTabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTransactionOverviewTab(),
                _buildPaymentProcessingTab(),
                _buildFraudDetectionTab(),
                _buildRevenueAnalyticsTab(),
                _buildFinancialReportsTab(),
                _buildComplianceTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.account_balance, size: 32, color: Color(0xFF388E3C)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Financial Management & Transaction Oversight',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Monitor transactions, payments, fraud detection, and financial analytics',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const Spacer(),
          if (_selectedTransactions.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF388E3C).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${_selectedTransactions.length} selected',
                style: const TextStyle(
                  color: Color(0xFF388E3C),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh Data',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportTransactions,
            tooltip: 'Export Transactions',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
            tooltip: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    final statisticsAsync = ref.watch(financialStatisticsProvider);
    
    return statisticsAsync.when(
      data: (statistics) => FinancialStatsCards(statistics: statistics),
      loading: () => const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => SizedBox(
        height: 120,
        child: Center(
          child: Text('Error loading statistics: $error'),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        labelColor: const Color(0xFF388E3C),
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: const Color(0xFF388E3C),
      ),
    );
  }

  Widget _buildTransactionOverviewTab() {
    return Column(
      children: [
        TransactionFiltersWidget(
          filters: _currentFilters,
          onFiltersChanged: (filters) {
            setState(() {
              _currentFilters = filters;
            });
            ref.read(transactionListProvider.notifier).loadTransactions(filters: filters);
          },
        ),
        Expanded(
          child: _buildTransactionsList(),
        ),
      ],
    );
  }

  Widget _buildTransactionsList() {
    final transactionsAsync = ref.watch(transactionListProvider);
    
    return transactionsAsync.when(
      data: (transactionsData) {
        final transactions = transactionsData['transactions'] as List<FinancialTransaction>;
        final total = transactionsData['total'] as int;
        
        if (transactions.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No transactions found'),
                Text('Try adjusting your filters'),
              ],
            ),
          );
        }
        
        return Card(
          margin: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: _selectedTransactions.length == transactions.length,
                      tristate: true,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedTransactions.addAll(transactions.map((t) => t.id));
                          } else {
                            _selectedTransactions.clear();
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Showing ${transactions.length} of $total transactions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    if (_selectedTransactions.isNotEmpty)
                      Text(
                        '${_selectedTransactions.length} selected',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF388E3C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: DataTable2(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 1600,
                  columns: const [
                    DataColumn2(label: Text(''), size: ColumnSize.S),
                    DataColumn2(label: Text('Transaction ID'), size: ColumnSize.M),
                    DataColumn2(label: Text('User'), size: ColumnSize.L),
                    DataColumn2(label: Text('Type'), size: ColumnSize.S),
                    DataColumn2(label: Text('Amount'), size: ColumnSize.M),
                    DataColumn2(label: Text('Status'), size: ColumnSize.S),
                    DataColumn2(label: Text('Payment Method'), size: ColumnSize.M),
                    DataColumn2(label: Text('Date'), size: ColumnSize.M),
                    DataColumn2(label: Text('Actions'), size: ColumnSize.M),
                  ],
                  rows: transactions.map((transaction) => _buildTransactionRow(transaction)).toList(),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const LoadingWidget(),
      error: (error, stack) => ErrorWidget(
        error: error.toString(),
        onRetry: () => ref.read(transactionListProvider.notifier).loadTransactions(),
      ),
    );
  }

  DataRow _buildTransactionRow(FinancialTransaction transaction) {
    final isSelected = _selectedTransactions.contains(transaction.id);
    
    return DataRow(
      selected: isSelected,
      onSelectChanged: (selected) {
        setState(() {
          if (selected == true) {
            _selectedTransactions.add(transaction.id);
          } else {
            _selectedTransactions.remove(transaction.id);
          }
        });
      },
      cells: [
        DataCell(
          Checkbox(
            value: isSelected,
            onChanged: (selected) {
              setState(() {
                if (selected == true) {
                  _selectedTransactions.add(transaction.id);
                } else {
                  _selectedTransactions.remove(transaction.id);
                }
              });
            },
          ),
        ),
        DataCell(
          Text(
            transaction.id.substring(0, 8),
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                transaction.userName,
                style: const TextStyle(fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                transaction.userEmail,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getTransactionTypeColor(transaction.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              transaction.type,
              style: TextStyle(
                color: _getTransactionTypeColor(transaction.type),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        DataCell(
          Text(
            '\$${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: transaction.type == 'credit' ? Colors.green : Colors.red,
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getTransactionStatusColor(transaction.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              transaction.status,
              style: TextStyle(
                color: _getTransactionStatusColor(transaction.status),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getPaymentMethodIcon(transaction.paymentMethod),
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                transaction.paymentMethod,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            _formatDate(transaction.createdAt),
            style: const TextStyle(fontSize: 12),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.visibility, size: 16),
                onPressed: () => _viewTransactionDetails(transaction.id),
                tooltip: 'View Details',
              ),
              if (transaction.status == 'pending')
                IconButton(
                  icon: const Icon(Icons.check, size: 16),
                  onPressed: () => _approveTransaction(transaction.id),
                  tooltip: 'Approve',
                ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 16),
                onSelected: (action) => _handleTransactionAction(action, transaction.id),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'refund',
                    child: Text('Refund'),
                  ),
                  const PopupMenuItem(
                    value: 'dispute',
                    child: Text('Mark as Dispute'),
                  ),
                  const PopupMenuItem(
                    value: 'fraud',
                    child: Text('Flag as Fraud'),
                  ),
                  const PopupMenuItem(
                    value: 'export',
                    child: Text('Export Details'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentProcessingTab() {
    return const PaymentProcessingWidget();
  }

  Widget _buildFraudDetectionTab() {
    return const FraudDetectionWidget();
  }

  Widget _buildRevenueAnalyticsTab() {
    return const RevenueAnalyticsWidget();
  }

  Widget _buildFinancialReportsTab() {
    return const FinancialReportsWidget();
  }

  Widget _buildComplianceTab() {
    return const Center(child: Text('Compliance - Coming Soon'));
  }

  Widget? _buildFloatingActionButton() {
    final currentTab = _tabController.index;
    final permissionManager = ref.watch(permissionManagerProvider);
    
    switch (currentTab) {
      case 0: // Transaction Overview
        if (permissionManager.checkPermission(Permission.transactionsCreate).granted) {
          return FloatingActionButton.extended(
            onPressed: _createTransaction,
            icon: const Icon(Icons.add),
            label: const Text('New Transaction'),
          );
        }
        break;
      case 4: // Financial Reports
        return FloatingActionButton.extended(
          onPressed: _generateReport,
          icon: const Icon(Icons.assessment),
          label: const Text('Generate Report'),
        );
    }
    return null;
  }

  Color _getTransactionTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'credit':
      case 'deposit':
        return Colors.green;
      case 'debit':
      case 'withdrawal':
        return Colors.red;
      case 'transfer':
        return Colors.blue;
      case 'fee':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getTransactionStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'success':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
      case 'cancelled':
        return Colors.red;
      case 'processing':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getPaymentMethodIcon(String method) {
    switch (method.toLowerCase()) {
      case 'credit_card':
        return Icons.credit_card;
      case 'debit_card':
        return Icons.payment;
      case 'bank_transfer':
        return Icons.account_balance;
      case 'mobile_money':
        return Icons.phone_android;
      case 'paypal':
        return Icons.account_balance_wallet;
      default:
        return Icons.payment;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  // Action handlers
  void _refreshData() {
    _loadInitialData();
  }

  void _exportTransactions() {
    // TODO: Implement export functionality
  }

  void _openSettings() {
    // TODO: Implement settings
  }

  void _createTransaction() {
    // TODO: Implement create transaction
  }

  void _generateReport() {
    // TODO: Implement generate report
  }

  void _viewTransactionDetails(String transactionId) {
    // TODO: Implement view transaction details
  }

  void _approveTransaction(String transactionId) {
    // TODO: Implement approve transaction
  }

  void _handleTransactionAction(String action, String transactionId) {
    // TODO: Implement transaction actions
  }
}
