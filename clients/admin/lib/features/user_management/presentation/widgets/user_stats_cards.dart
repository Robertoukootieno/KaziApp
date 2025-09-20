import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/stat_card.dart';
import '../providers/user_management_providers.dart';

class UserStatsCards extends StatelessWidget {
  final UserStatistics statistics;

  const UserStatsCards({
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
                title: 'Total Users',
                value: statistics.totalUsers.toString(),
                icon: Icons.people,
                color: const Color(0xFF1976D2),
                trend: _calculateTrend(statistics.totalUsers, 'total'),
                isPositive: true,
              ),
              StatCard(
                title: 'Active Users',
                value: statistics.activeUsers.toString(),
                icon: Icons.check_circle,
                color: Colors.green,
                trend: _calculateTrend(statistics.activeUsers, 'active'),
                isPositive: true,
                subtitle: '${_getPercentage(statistics.activeUsers, statistics.totalUsers)}% of total',
              ),
              StatCard(
                title: 'Inactive Users',
                value: statistics.inactiveUsers.toString(),
                icon: Icons.pause_circle,
                color: Colors.orange,
                trend: _calculateTrend(statistics.inactiveUsers, 'inactive'),
                isPositive: false,
                subtitle: '${_getPercentage(statistics.inactiveUsers, statistics.totalUsers)}% of total',
              ),
              StatCard(
                title: 'Admin Users',
                value: statistics.adminUsers.toString(),
                icon: Icons.admin_panel_settings,
                color: Colors.purple,
                trend: _calculateTrend(statistics.adminUsers, 'admin'),
                isPositive: true,
                subtitle: 'System administrators',
              ),
              StatCard(
                title: 'New Users',
                value: statistics.newUsersThisMonth.toString(),
                icon: Icons.person_add,
                color: Colors.teal,
                trend: '+${statistics.newUsersThisMonth}',
                isPositive: true,
                subtitle: 'This month',
              ),
            ],
          );
        },
      ),
    );
  }

  String _calculateTrend(int currentValue, String type) {
    // Mock trend calculation - in real app, this would come from historical data
    switch (type) {
      case 'total':
        return '+${(currentValue * 0.05).round()}';
      case 'active':
        return '+${(currentValue * 0.08).round()}';
      case 'inactive':
        return '-${(currentValue * 0.03).round()}';
      case 'admin':
        return '+${(currentValue * 0.02).round()}';
      default:
        return '+0';
    }
  }

  String _getPercentage(int value, int total) {
    if (total == 0) return '0';
    return ((value / total) * 100).toStringAsFixed(1);
  }
}
