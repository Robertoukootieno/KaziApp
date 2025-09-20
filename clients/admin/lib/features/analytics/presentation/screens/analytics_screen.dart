import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/business_intelligence_widget.dart';
import '../widgets/custom_dashboard_widget.dart';
import '../widgets/data_export_widget.dart';
import '../widgets/predictive_analytics_widget.dart';
import '../widgets/user_behavior_widget.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(
              icon: Icon(Icons.dashboard),
              text: 'Overview',
            ),
            Tab(
              icon: Icon(Icons.people),
              text: 'User Behavior',
            ),
            Tab(
              icon: Icon(Icons.business),
              text: 'Business Intelligence',
            ),
            Tab(
              icon: Icon(Icons.trending_up),
              text: 'Predictive Analytics',
            ),
            Tab(
              icon: Icon(Icons.dashboard_customize),
              text: 'Custom Dashboard',
            ),
            Tab(
              icon: Icon(Icons.file_download),
              text: 'Data Export',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _OverviewTab(),
          _UserBehaviorTab(),
          _BusinessIntelligenceTab(),
          _PredictiveAnalyticsTab(),
          _CustomDashboardTab(),
          _DataExportTab(),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Analytics Overview',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildSimpleAnalyticsStatsCards(),
          const SizedBox(height: 32),
          const Text(
            'Key Metrics Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          const _MetricsSummaryCard(),
        ],
      ),
    );
  }

  Widget _buildSimpleAnalyticsStatsCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        if (screenWidth < 600) {
          // Mobile: Stack cards vertically
          return Column(
            children: [
              _buildStatCard(
                'Total Users',
                '15,234',
                '+8.7%',
                Colors.blue,
                Icons.people,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                'Revenue',
                'KSh 2.4M',
                '+15.2%',
                Colors.green,
                Icons.attach_money,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                'Engagement',
                '68%',
                '+2.1%',
                Colors.orange,
                Icons.trending_up,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                'Conversion',
                '12.5%',
                '+1.8%',
                Colors.purple,
                Icons.trending_up,
              ),
            ],
          );
        } else if (screenWidth < 900) {
          // Tablet: 2x2 grid
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Users',
                      '15,234',
                      '+8.7%',
                      Colors.blue,
                      Icons.people,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Revenue',
                      'KSh 2.4M',
                      '+15.2%',
                      Colors.green,
                      Icons.attach_money,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Engagement',
                      '68%',
                      '+2.1%',
                      Colors.orange,
                      Icons.trending_up,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Conversion',
                      '12.5%',
                      '+1.8%',
                      Colors.purple,
                      Icons.trending_up,
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          // Desktop: Single row
          return Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Users',
                  '15,234',
                  '+8.7%',
                  Colors.blue,
                  Icons.people,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Revenue',
                  'KSh 2.4M',
                  '+15.2%',
                  Colors.green,
                  Icons.attach_money,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Engagement',
                  '68%',
                  '+2.1%',
                  Colors.orange,
                  Icons.trending_up,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Conversion',
                  '12.5%',
                  '+1.8%',
                  Colors.purple,
                  Icons.trending_up,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildStatCard(String title, String value, String change, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Text(
                change,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricsSummaryCard extends StatelessWidget {
  const _MetricsSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    'Total Users',
                    '15,234',
                    '+8.7%',
                    Colors.blue,
                    Icons.people,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    'Revenue',
                    'KSh 2.4M',
                    '+15.2%',
                    Colors.green,
                    Icons.attach_money,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    'Engagement',
                    '68%',
                    '+2.1%',
                    Colors.orange,
                    Icons.trending_up,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    'Conversion',
                    '12.5%',
                    '+1.8%',
                    Colors.purple,
                    Icons.trending_up,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    String title,
    String value,
    String change,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Text(
                change,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _UserBehaviorTab extends StatelessWidget {
  const _UserBehaviorTab();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Behavior Analytics',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24),
          UserBehaviorWidget(),
        ],
      ),
    );
  }
}

class _BusinessIntelligenceTab extends StatelessWidget {
  const _BusinessIntelligenceTab();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Business Intelligence',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24),
          BusinessIntelligenceWidget(),
        ],
      ),
    );
  }
}

class _PredictiveAnalyticsTab extends StatelessWidget {
  const _PredictiveAnalyticsTab();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Predictive Analytics',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24),
          PredictiveAnalyticsWidget(),
        ],
      ),
    );
  }
}

class _CustomDashboardTab extends StatelessWidget {
  const _CustomDashboardTab();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Custom Dashboard',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24),
          CustomDashboardWidget(),
        ],
      ),
    );
  }
}

class _DataExportTab extends StatelessWidget {
  const _DataExportTab();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data Export',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24),
          DataExportWidget(),
        ],
      ),
    );
  }
}
