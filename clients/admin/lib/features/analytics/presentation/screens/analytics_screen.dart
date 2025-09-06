import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/stat_card.dart';
import '../../../../shared/widgets/chart_card.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = '7d';

  final List<String> _analyticsCategories = [
    'Overview',
    'Users',
    'Engagement',
    'Revenue',
    'Performance',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _analyticsCategories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          _buildHeader(),
          
          // Period selector
          _buildPeriodSelector(),
          
          // Tabs
          _buildTabs(),
          
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildUsersTab(),
                _buildEngagementTab(),
                _buildRevenueTab(),
                _buildPerformanceTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Analytics Dashboard',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'Monitor platform performance and user behavior',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
            ],
          ),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: _exportReport,
                icon: const Icon(Icons.download),
                label: const Text('Export Report'),
              ),
              const SizedBox(width: AppConstants.smallPadding),
              ElevatedButton.icon(
                onPressed: _refreshData,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: Row(
        children: [
          const Text('Period: '),
          const SizedBox(width: AppConstants.smallPadding),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: '24h', label: Text('24h')),
              ButtonSegment(value: '7d', label: Text('7d')),
              ButtonSegment(value: '30d', label: Text('30d')),
              ButtonSegment(value: '90d', label: Text('90d')),
              ButtonSegment(value: '1y', label: Text('1y')),
            ],
            selected: {_selectedPeriod},
            onSelectionChanged: (Set<String> selection) {
              setState(() {
                _selectedPeriod = selection.first;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabs: _analyticsCategories.map((category) => Tab(text: category)).toList(),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          // Key metrics
          _buildKeyMetrics(),
          const SizedBox(height: AppConstants.largePadding),
          
          // Charts
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= AppConstants.desktopBreakpoint;
              
              if (isDesktop) {
                return Row(
                  children: [
                    Expanded(child: _buildTrafficChart()),
                    const SizedBox(width: AppConstants.defaultPadding),
                    Expanded(child: _buildDeviceChart()),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildTrafficChart(),
                    const SizedBox(height: AppConstants.defaultPadding),
                    _buildDeviceChart(),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildKeyMetrics() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= AppConstants.desktopBreakpoint;
        final crossAxisCount = isDesktop ? 4 : 2;
        
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: AppConstants.defaultPadding,
          mainAxisSpacing: AppConstants.defaultPadding,
          childAspectRatio: 1.5,
          children: [
            StatCard(
              title: 'Page Views',
              value: '45.2K',
              icon: Icons.visibility,
              color: Colors.blue,
              trend: '+12.5%',
              isPositive: true,
            ),
            StatCard(
              title: 'Unique Visitors',
              value: '12.8K',
              icon: Icons.people,
              color: Colors.green,
              trend: '+8.2%',
              isPositive: true,
            ),
            StatCard(
              title: 'Bounce Rate',
              value: '32.1%',
              icon: Icons.exit_to_app,
              color: Colors.orange,
              trend: '-2.1%',
              isPositive: true,
            ),
            StatCard(
              title: 'Avg. Session',
              value: '4m 32s',
              icon: Icons.timer,
              color: Colors.purple,
              trend: '+15s',
              isPositive: true,
            ),
          ],
        );
      },
    );
  }

  Widget _buildTrafficChart() {
    return ChartCard(
      title: 'Traffic Overview',
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
      child: SizedBox(
        height: 300,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1000,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey.shade300,
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 1,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    const style = TextStyle(fontSize: 12);
                    Widget text;
                    switch (value.toInt()) {
                      case 0:
                        text = const Text('Mon', style: style);
                        break;
                      case 1:
                        text = const Text('Tue', style: style);
                        break;
                      case 2:
                        text = const Text('Wed', style: style);
                        break;
                      case 3:
                        text = const Text('Thu', style: style);
                        break;
                      case 4:
                        text = const Text('Fri', style: style);
                        break;
                      case 5:
                        text = const Text('Sat', style: style);
                        break;
                      case 6:
                        text = const Text('Sun', style: style);
                        break;
                      default:
                        text = const Text('', style: style);
                        break;
                    }
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: text,
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1000,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    return Text(
                      '${(value / 1000).toInt()}K',
                      style: const TextStyle(fontSize: 12),
                    );
                  },
                  reservedSize: 42,
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: 6,
            minY: 0,
            maxY: 6000,
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 3000),
                  FlSpot(1, 4200),
                  FlSpot(2, 3800),
                  FlSpot(3, 5100),
                  FlSpot(4, 4800),
                  FlSpot(5, 5500),
                  FlSpot(6, 4900),
                ],
                isCurved: true,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primarySwatch,
                    AppTheme.primarySwatch.withOpacity(0.3),
                  ],
                ),
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primarySwatch.withOpacity(0.3),
                      AppTheme.primarySwatch.withOpacity(0.1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceChart() {
    return ChartCard(
      title: 'Device Usage',
      child: SizedBox(
        height: 300,
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(
                value: 45,
                title: 'Mobile\n45%',
                color: Colors.blue,
                radius: 80,
                titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              PieChartSectionData(
                value: 35,
                title: 'Desktop\n35%',
                color: Colors.green,
                radius: 80,
                titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              PieChartSectionData(
                value: 20,
                title: 'Tablet\n20%',
                color: Colors.orange,
                radius: 80,
                titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
            centerSpaceRadius: 40,
            sectionsSpace: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildUsersTab() {
    return const Center(
      child: Text('Users Analytics - Coming Soon'),
    );
  }

  Widget _buildEngagementTab() {
    return const Center(
      child: Text('Engagement Analytics - Coming Soon'),
    );
  }

  Widget _buildRevenueTab() {
    return const Center(
      child: Text('Revenue Analytics - Coming Soon'),
    );
  }

  Widget _buildPerformanceTab() {
    return const Center(
      child: Text('Performance Analytics - Coming Soon'),
    );
  }

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export report functionality coming soon')),
    );
  }

  void _refreshData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data refreshed successfully')),
    );
  }
}
