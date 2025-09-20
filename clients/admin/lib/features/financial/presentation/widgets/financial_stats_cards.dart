import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/stat_card.dart';
import '../providers/financial_providers.dart';

class FinancialStatsCards extends StatelessWidget {
  final FinancialStatistics statistics;

  const FinancialStatsCards({
    super.key,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          int crossAxisCount;
          double childAspectRatio;
          
          if (screenWidth < 600) {
            // Mobile: 1 card per row
            crossAxisCount = 1;
            childAspectRatio = 3.0;
          } else if (screenWidth < 900) {
            // Small tablet: 2 cards per row
            crossAxisCount = 2;
            childAspectRatio = 2.0;
          } else if (screenWidth < 1200) {
            // Large tablet: 3 cards per row
            crossAxisCount = 3;
            childAspectRatio = 1.8;
          } else {
            // Desktop: 5 cards per row
            crossAxisCount = 5;
            childAspectRatio = 1.5;
          }
          
          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppConstants.defaultPadding,
            mainAxisSpacing: AppConstants.defaultPadding,
            childAspectRatio: childAspectRatio,
            children: [
              StatCard(
                title: 'Total Revenue',
                value: 'KSh ${_formatCurrency(statistics.totalRevenue)}',
                icon: Icons.attach_money,
                color: Colors.green,
                trend: _calculateTrend(statistics.totalRevenue, 'revenue'),
                isPositive: true,
              ),
              StatCard(
                title: 'Total Transactions',
                value: statistics.totalTransactions.toString(),
                icon: Icons.payment,
                color: const Color(0xFF1976D2),
                trend: _calculateTrend(statistics.totalTransactions.toDouble(), 'transactions'),
                isPositive: true,
                subtitle: 'All time',
              ),
              StatCard(
                title: 'Pending Payments',
                value: statistics.pendingPayments.toString(),
                icon: Icons.pending,
                color: Colors.orange,
                trend: _calculateTrend(statistics.pendingPayments.toDouble(), 'pending'),
                isPositive: false,
                subtitle: 'Needs processing',
              ),
              StatCard(
                title: 'Failed Transactions',
                value: statistics.failedTransactions.toString(),
                icon: Icons.error,
                color: Colors.red,
                trend: _calculateTrend(statistics.failedTransactions.toDouble(), 'failed'),
                isPositive: false,
                subtitle: '${_getPercentage(statistics.failedTransactions, statistics.totalTransactions)}% failure rate',
              ),
              StatCard(
                title: 'Average Transaction',
                value: 'KSh ${_formatCurrency(statistics.averageTransactionAmount)}',
                icon: Icons.trending_up,
                color: Colors.purple,
                trend: '+${_formatCurrency(statistics.averageTransactionAmount * 0.05)}',
                isPositive: true,
                subtitle: 'Per transaction',
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toStringAsFixed(0);
    }
  }

  String _calculateTrend(double currentValue, String type) {
    // Mock trend calculation - in real app, this would come from historical data
    switch (type) {
      case 'revenue':
        return '+${_formatCurrency(currentValue * 0.12)}';
      case 'transactions':
        return '+${(currentValue * 0.08).round()}';
      case 'pending':
        return '-${(currentValue * 0.15).round()}';
      case 'failed':
        return '-${(currentValue * 0.05).round()}';
      default:
        return '+0';
    }
  }

  String _getPercentage(int value, int total) {
    if (total == 0) return '0.0';
    return ((value / total) * 100).toStringAsFixed(1);
  }
}
