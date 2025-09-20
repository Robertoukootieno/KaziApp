import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/stat_card.dart';
import '../providers/service_provider_providers.dart';

class ServiceProviderStatsCards extends StatelessWidget {
  final ServiceProviderStatistics statistics;

  const ServiceProviderStatsCards({
    super.key,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          // Main stats row
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= AppConstants.desktopBreakpoint;
              final crossAxisCount = isDesktop ? 5 : (constraints.maxWidth >= 600 ? 3 : 2);
              
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: AppConstants.defaultPadding,
                mainAxisSpacing: AppConstants.defaultPadding,
                childAspectRatio: 1.5,
                children: [
                  StatCard(
                    title: 'Total Providers',
                    value: statistics.totalProviders.toString(),
                    icon: Icons.business,
                    color: const Color(0xFF1976D2),
                    trend: _calculateTrend(statistics.totalProviders, 'total'),
                    isPositive: true,
                  ),
                  StatCard(
                    title: 'Verified',
                    value: statistics.verifiedProviders.toString(),
                    icon: Icons.verified,
                    color: Colors.green,
                    trend: _calculateTrend(statistics.verifiedProviders, 'verified'),
                    isPositive: true,
                    subtitle: '${_getPercentage(statistics.verifiedProviders, statistics.totalProviders)}% of total',
                  ),
                  StatCard(
                    title: 'Pending Verification',
                    value: statistics.pendingVerification.toString(),
                    icon: Icons.pending,
                    color: Colors.orange,
                    trend: _calculateTrend(statistics.pendingVerification, 'pending'),
                    isPositive: false,
                    subtitle: 'Needs attention',
                  ),
                  StatCard(
                    title: 'Active Providers',
                    value: statistics.activeProviders.toString(),
                    icon: Icons.check_circle,
                    color: Colors.teal,
                    trend: _calculateTrend(statistics.activeProviders, 'active'),
                    isPositive: true,
                    subtitle: '${_getPercentage(statistics.activeProviders, statistics.totalProviders)}% active',
                  ),
                  StatCard(
                    title: 'Average Rating',
                    value: statistics.averageRating.toStringAsFixed(1),
                    icon: Icons.star,
                    color: Colors.amber,
                    trend: '+0.2',
                    isPositive: true,
                    subtitle: 'Out of 5.0',
                  ),
                ],
              );
            },
          ),
          
          const SizedBox(height: AppConstants.largePadding),
          
          // Charts section
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= AppConstants.desktopBreakpoint;
              
              if (isDesktop) {
                return Row(
                  children: [
                    Expanded(child: _buildProviderTypeChart()),
                    const SizedBox(width: AppConstants.defaultPadding),
                    Expanded(child: _buildLocationChart()),
                    const SizedBox(width: AppConstants.defaultPadding),
                    Expanded(child: _buildVerificationQueueChart()),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildProviderTypeChart(),
                    const SizedBox(height: AppConstants.defaultPadding),
                    _buildLocationChart(),
                    const SizedBox(height: AppConstants.defaultPadding),
                    _buildVerificationQueueChart(),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProviderTypeChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Providers by Type',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _buildProviderTypeSections(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(statistics.providersByType, _getTypeColors()),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Locations',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxLocationValue().toDouble(),
                  barGroups: _buildLocationBars(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final locations = statistics.providersByLocation.keys.toList();
                          if (value.toInt() < locations.length) {
                            return Text(
                              locations[value.toInt()],
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationQueueChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verification Queue',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _buildVerificationQueueSections(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(statistics.verificationQueue, _getQueueColors()),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildProviderTypeSections() {
    final colors = _getTypeColors();
    return statistics.providersByType.entries.map((entry) {
      final percentage = (entry.value / statistics.totalProviders) * 100;
      return PieChartSectionData(
        color: colors[entry.key] ?? Colors.grey,
        value: entry.value.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  List<PieChartSectionData> _buildVerificationQueueSections() {
    final colors = _getQueueColors();
    final total = statistics.verificationQueue.values.fold(0, (sum, value) => sum + value);
    
    return statistics.verificationQueue.entries.map((entry) {
      final percentage = total > 0 ? (entry.value / total) * 100 : 0.0;
      return PieChartSectionData(
        color: colors[entry.key] ?? Colors.grey,
        value: entry.value.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  List<BarChartGroupData> _buildLocationBars() {
    final locations = statistics.providersByLocation.entries.take(5).toList();
    return locations.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.value.toDouble(),
            color: const Color(0xFF1976D2),
            width: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildLegend(Map<String, int> data, Map<String, Color> colors) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: data.entries.map((entry) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: colors[entry.key] ?? Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${entry.key} (${entry.value})',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }

  Map<String, Color> _getTypeColors() {
    return {
      'veterinarian': Colors.green,
      'agrovet': Colors.blue,
      'equipment_provider': Colors.orange,
      'feed_supplier': Colors.purple,
      'financial_service': Colors.teal,
      'other': Colors.grey,
    };
  }

  Map<String, Color> _getQueueColors() {
    return {
      'pending_documents': Colors.orange,
      'under_review': Colors.blue,
      'awaiting_approval': Colors.amber,
      'rejected': Colors.red,
    };
  }

  String _calculateTrend(int current, String type) {
    // This would typically come from historical data
    // For now, return mock trends
    switch (type) {
      case 'total':
        return '+12%';
      case 'verified':
        return '+8%';
      case 'pending':
        return '+5%';
      case 'active':
        return '+15%';
      default:
        return '+0%';
    }
  }

  String _getPercentage(int value, int total) {
    if (total == 0) return '0';
    return ((value / total) * 100).toStringAsFixed(1);
  }

  int _getMaxLocationValue() {
    if (statistics.providersByLocation.isEmpty) return 10;
    return statistics.providersByLocation.values.reduce((a, b) => a > b ? a : b);
  }
}
