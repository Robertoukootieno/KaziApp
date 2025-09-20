import 'package:flutter/material.dart';
import '../providers/analytics_providers.dart';

class AnalyticsStatsCards extends StatelessWidget {
  final AnalyticsOverview overview;
  final String timeRange;

  const AnalyticsStatsCards({
    super.key,
    required this.overview,
    required this.timeRange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 1200;
          final isTablet = constraints.maxWidth >= 768;
          
          int crossAxisCount;
          if (isDesktop) {
            crossAxisCount = 4;
          } else if (isTablet) {
            crossAxisCount = 2;
          } else {
            crossAxisCount = 1;
          }

          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isDesktop ? 2.5 : (isTablet ? 2.0 : 3.0),
            children: [
              _buildStatCard(
                context,
                'Total Users',
                overview.totalUsers.toString(),
                Icons.people,
                Colors.blue,
                _getGrowthPercentage('users'),
              ),
              _buildStatCard(
                context,
                'Active Users',
                overview.activeUsers.toString(),
                Icons.person_outline,
                Colors.green,
                _getGrowthPercentage('active_users'),
              ),
              _buildStatCard(
                context,
                'Total Revenue',
                '\$${_formatNumber(overview.totalRevenue)}',
                Icons.attach_money,
                Colors.purple,
                _getGrowthPercentage('revenue'),
              ),
              _buildStatCard(
                context,
                'Engagement Rate',
                '${overview.engagementRate.toStringAsFixed(1)}%',
                Icons.trending_up,
                Colors.orange,
                _getGrowthPercentage('engagement'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    double? growthPercentage,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const Spacer(),
                if (growthPercentage != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: growthPercentage >= 0 
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          growthPercentage >= 0 
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          size: 12,
                          color: growthPercentage >= 0 ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${growthPercentage.abs().toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: growthPercentage >= 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toStringAsFixed(0);
    }
  }

  double? _getGrowthPercentage(String metric) {
    // This would typically come from the API data
    // For now, return mock data
    switch (metric) {
      case 'users':
        return 12.5;
      case 'active_users':
        return 8.3;
      case 'revenue':
        return 15.7;
      case 'engagement':
        return -2.1;
      default:
        return null;
    }
  }
}
