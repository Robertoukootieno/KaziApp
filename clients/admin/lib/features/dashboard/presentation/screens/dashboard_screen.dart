import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/stat_card.dart';
import '../../../../shared/widgets/chart_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(),
            const SizedBox(height: AppConstants.largePadding),
            
            // Stats Overview
            _buildStatsOverview(),
            const SizedBox(height: AppConstants.largePadding),
            
            // Charts Section
            _buildChartsSection(),
            const SizedBox(height: AppConstants.largePadding),
            
            // Recent Activity
            _buildRecentActivity(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to KaziApp Admin',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    'Monitor and manage your agricultural platform',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.agriculture,
              size: 64,
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Platform Overview',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= AppConstants.desktopBreakpoint;
            final isTablet = constraints.maxWidth >= AppConstants.tabletBreakpoint;
            
            int crossAxisCount = 2;
            if (isDesktop) {
              crossAxisCount = 4;
            } else if (isTablet) {
              crossAxisCount = 3;
            }
            
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: AppConstants.defaultPadding,
              mainAxisSpacing: AppConstants.defaultPadding,
              childAspectRatio: 1.5,
              children: [
                StatCard(
                  title: 'Total Users',
                  value: '12,543',
                  icon: Icons.people,
                  color: AppTheme.primarySwatch,
                  trend: '+12%',
                  isPositive: true,
                ),
                StatCard(
                  title: 'Farmers',
                  value: '8,234',
                  icon: Icons.agriculture,
                  color: Colors.green,
                  trend: '+8%',
                  isPositive: true,
                ),
                StatCard(
                  title: 'Service Providers',
                  value: '2,156',
                  icon: Icons.business,
                  color: Colors.blue,
                  trend: '+15%',
                  isPositive: true,
                ),
                StatCard(
                  title: 'Active Sessions',
                  value: '1,432',
                  icon: Icons.online_prediction,
                  color: Colors.orange,
                  trend: '-3%',
                  isPositive: false,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildChartsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analytics',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= AppConstants.desktopBreakpoint;
            
            if (isDesktop) {
              return Row(
                children: [
                  Expanded(child: _buildUserGrowthChart()),
                  const SizedBox(width: AppConstants.defaultPadding),
                  Expanded(child: _buildUserTypeChart()),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildUserGrowthChart(),
                  const SizedBox(height: AppConstants.defaultPadding),
                  _buildUserTypeChart(),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildUserGrowthChart() {
    return ChartCard(
      title: 'User Growth',
      child: SizedBox(
        height: 300,
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 3),
                  FlSpot(1, 4),
                  FlSpot(2, 3.5),
                  FlSpot(3, 5),
                  FlSpot(4, 4.5),
                  FlSpot(5, 6),
                  FlSpot(6, 5.5),
                ],
                isCurved: true,
                color: AppTheme.primarySwatch,
                barWidth: 3,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppTheme.primarySwatch.withOpacity(0.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeChart() {
    return ChartCard(
      title: 'User Distribution',
      child: SizedBox(
        height: 300,
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(
                value: 65,
                title: 'Farmers\n65%',
                color: Colors.green,
                radius: 100,
              ),
              PieChartSectionData(
                value: 20,
                title: 'Service\nProviders\n20%',
                color: Colors.blue,
                radius: 100,
              ),
              PieChartSectionData(
                value: 10,
                title: 'Buyers\n10%',
                color: Colors.orange,
                radius: 100,
              ),
              PieChartSectionData(
                value: 5,
                title: 'Others\n5%',
                color: Colors.purple,
                radius: 100,
              ),
            ],
            centerSpaceRadius: 40,
            sectionsSpace: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.chartColors[index % AppTheme.chartColors.length].withOpacity(0.2),
                  child: Icon(
                    _getActivityIcon(index),
                    color: AppTheme.chartColors[index % AppTheme.chartColors.length],
                  ),
                ),
                title: Text(_getActivityTitle(index)),
                subtitle: Text(_getActivitySubtitle(index)),
                trailing: Text(
                  _getActivityTime(index),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getActivityIcon(int index) {
    const icons = [
      Icons.person_add,
      Icons.business_center,
      Icons.agriculture,
      Icons.analytics,
      Icons.security,
    ];
    return icons[index % icons.length];
  }

  String _getActivityTitle(int index) {
    const titles = [
      'New farmer registered',
      'Service provider verified',
      'Crop disease diagnosed',
      'Monthly report generated',
      'Security alert resolved',
    ];
    return titles[index % titles.length];
  }

  String _getActivitySubtitle(int index) {
    const subtitles = [
      'John Doe from Nakuru County',
      'VetCare Services approved',
      'Maize blight detected in Kiambu',
      'User engagement metrics updated',
      'Suspicious login attempt blocked',
    ];
    return subtitles[index % subtitles.length];
  }

  String _getActivityTime(int index) {
    const times = [
      '2 min ago',
      '15 min ago',
      '1 hour ago',
      '3 hours ago',
      '1 day ago',
    ];
    return times[index % times.length];
  }
}
