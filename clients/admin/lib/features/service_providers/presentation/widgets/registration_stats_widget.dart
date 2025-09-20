import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/models/service_provider_registration.dart';
import '../../providers/registration_providers.dart';

class RegistrationStatsWidget extends ConsumerWidget {
  const RegistrationStatsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(registrationStatisticsProvider);

    return statsAsync.when(
      data: (stats) => _buildStatsContent(context, stats),
      loading: () => const LoadingWidget(),
      error: (error, stack) => CustomErrorWidget(
        error: error.toString(),
        onRetry: () => ref.refresh(registrationStatisticsProvider),
      ),
    );
  }

  Widget _buildStatsContent(BuildContext context, Map<String, dynamic> stats) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Registration Statistics',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Overview cards
          _buildOverviewCards(stats),
          const SizedBox(height: 32),
          
          // Charts section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status distribution chart
              Expanded(
                child: _buildStatusChart(stats),
              ),
              const SizedBox(width: 24),
              
              // Service type distribution chart
              Expanded(
                child: _buildServiceTypeChart(stats),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Recent activity
          _buildRecentActivity(stats),
        ],
      ),
    );
  }

  Widget _buildOverviewCards(Map<String, dynamic> stats) {
    final totalRegistrations = stats['total'] ?? 0;
    final pendingRegistrations = stats['pending'] ?? 0;
    final approvedRegistrations = stats['approved'] ?? 0;
    final rejectedRegistrations = stats['rejected'] ?? 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 800;
        
        if (isSmallScreen) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildStatCard('Total', totalRegistrations, Icons.people, Colors.blue)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard('Pending', pendingRegistrations, Icons.pending, Colors.orange)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildStatCard('Approved', approvedRegistrations, Icons.check_circle, Colors.green)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard('Rejected', rejectedRegistrations, Icons.cancel, Colors.red)),
                ],
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Expanded(child: _buildStatCard('Total', totalRegistrations, Icons.people, Colors.blue)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Pending', pendingRegistrations, Icons.pending, Colors.orange)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Approved', approvedRegistrations, Icons.check_circle, Colors.green)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Rejected', rejectedRegistrations, Icons.cancel, Colors.red)),
            ],
          );
        }
      },
    );
  }

  Widget _buildStatCard(String title, int value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const Spacer(),
                Text(
                  value.toString(),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChart(Map<String, dynamic> stats) {
    final statusData = stats['statusDistribution'] as Map<String, dynamic>? ?? {};
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Status Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _buildStatusPieChartSections(statusData),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildStatusLegend(statusData),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceTypeChart(Map<String, dynamic> stats) {
    final serviceTypeData = stats['serviceTypeDistribution'] as Map<String, dynamic>? ?? {};
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Service Type Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxServiceTypeValue(serviceTypeData),
                  barGroups: _buildServiceTypeBarGroups(serviceTypeData),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final types = serviceTypeData.keys.toList();
                          if (value.toInt() < types.length) {
                            return Text(
                              _formatServiceTypeName(types[value.toInt()]),
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(Map<String, dynamic> stats) {
    final recentActivity = stats['recentActivity'] as List<dynamic>? ?? [];
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (recentActivity.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'No recent activity',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ...recentActivity.take(5).map((activity) => _buildActivityItem(activity)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    final type = activity['type'] ?? '';
    final message = activity['message'] ?? '';
    final timestamp = DateTime.tryParse(activity['timestamp'] ?? '') ?? DateTime.now();
    
    IconData icon;
    Color color;
    
    switch (type) {
      case 'registration_submitted':
        icon = Icons.person_add;
        color = Colors.blue;
        break;
      case 'registration_approved':
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case 'registration_rejected':
        icon = Icons.cancel;
        color = Colors.red;
        break;
      default:
        icon = Icons.info;
        color = Colors.grey;
    }
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  _formatTimestamp(timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildStatusPieChartSections(Map<String, dynamic> statusData) {
    final colors = {
      'pending': Colors.orange,
      'approved': Colors.green,
      'rejected': Colors.red,
      'under_review': Colors.blue,
    };
    
    return statusData.entries.map((entry) {
      final status = entry.key;
      final value = (entry.value as num).toDouble();
      final color = colors[status] ?? Colors.grey;
      
      return PieChartSectionData(
        color: color,
        value: value,
        title: '${value.toInt()}',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildStatusLegend(Map<String, dynamic> statusData) {
    final colors = {
      'pending': Colors.orange,
      'approved': Colors.green,
      'rejected': Colors.red,
      'under_review': Colors.blue,
    };
    
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: statusData.entries.map((entry) {
        final status = entry.key;
        final value = entry.value;
        final color = colors[status] ?? Colors.grey;
        
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${_formatStatusName(status)}: $value',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }

  List<BarChartGroupData> _buildServiceTypeBarGroups(Map<String, dynamic> serviceTypeData) {
    return serviceTypeData.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final value = (entry.value.value as num).toDouble();
      
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            color: Colors.blue,
            width: 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    }).toList();
  }

  double _getMaxServiceTypeValue(Map<String, dynamic> serviceTypeData) {
    if (serviceTypeData.isEmpty) return 10;
    final maxValue = serviceTypeData.values.map((v) => (v as num).toDouble()).reduce((a, b) => a > b ? a : b);
    return maxValue * 1.2; // Add 20% padding
  }

  String _formatServiceTypeName(String serviceType) {
    switch (serviceType) {
      case 'veterinarian':
        return 'Vet';
      case 'machinery_provider':
        return 'Machinery';
      case 'input_supplier':
        return 'Inputs';
      case 'transport_service':
        return 'Transport';
      case 'financial_service':
        return 'Finance';
      case 'consultant':
        return 'Consult';
      default:
        return serviceType;
    }
  }

  String _formatStatusName(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'under_review':
        return 'Under Review';
      default:
        return status;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
