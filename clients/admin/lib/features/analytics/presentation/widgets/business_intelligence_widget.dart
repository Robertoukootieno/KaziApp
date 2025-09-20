import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../providers/analytics_providers.dart';

class BusinessIntelligenceWidget extends ConsumerWidget {
  const BusinessIntelligenceWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final biAsync = ref.watch(businessIntelligenceProvider);

    return biAsync.when(
      data: (bi) => _buildBIContent(context, bi),
      loading: () => const LoadingWidget(),
      error: (error, stack) => CustomErrorWidget(
        error: error.toString(),
        onRetry: () => ref.refresh(businessIntelligenceProvider),
      ),
    );
  }

  Widget _buildBIContent(BuildContext context, BusinessIntelligence bi) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Business Intelligence Dashboard',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // KPI Metrics
          _buildKPIMetrics(context, bi.kpiMetrics),
          
          const SizedBox(height: 24),
          
          // Performance indicators and competitive analysis
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 1200;
              
              if (isDesktop) {
                return Row(
                  children: [
                    Expanded(child: _buildPerformanceIndicators(context, bi.performanceIndicators)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildCompetitiveAnalysis(context, bi.competitiveAnalysis)),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildPerformanceIndicators(context, bi.performanceIndicators),
                    const SizedBox(height: 16),
                    _buildCompetitiveAnalysis(context, bi.competitiveAnalysis),
                  ],
                );
              }
            },
          ),
          
          const SizedBox(height: 24),
          
          // Business reports and market insights
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 1200;
              
              if (isDesktop) {
                return Row(
                  children: [
                    Expanded(child: _buildBusinessReports(context, bi.businessReports)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildMarketInsights(context, bi.marketInsights)),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildBusinessReports(context, bi.businessReports),
                    const SizedBox(height: 16),
                    _buildMarketInsights(context, bi.marketInsights),
                  ],
                );
              }
            },
          ),
          
          const SizedBox(height: 24),
          
          // Actionable insights
          _buildActionableInsights(context, bi.actionableInsights),
        ],
      ),
    );
  }

  Widget _buildKPIMetrics(BuildContext context, Map<String, dynamic> kpiMetrics) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Key Performance Indicators',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 1000;
                final isTablet = constraints.maxWidth >= 600;
                
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
                  childAspectRatio: 2.5,
                  children: [
                    _buildKPICard('Revenue Growth', '+15.7%', Icons.trending_up, Colors.green),
                    _buildKPICard('Customer Acquisition', '2,340', Icons.person_add, Colors.blue),
                    _buildKPICard('Market Share', '12.5%', Icons.pie_chart, Colors.purple),
                    _buildKPICard('ROI', '245%', Icons.attach_money, Colors.orange),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKPICard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceIndicators(BuildContext context, Map<String, dynamic> indicators) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Indicators',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: ListView(
                children: [
                  _buildIndicatorItem('Customer Satisfaction', 4.2, 5.0, Colors.green),
                  _buildIndicatorItem('Service Quality', 3.8, 5.0, Colors.blue),
                  _buildIndicatorItem('Response Time', 2.5, 5.0, Colors.orange),
                  _buildIndicatorItem('Resolution Rate', 4.5, 5.0, Colors.purple),
                  _buildIndicatorItem('User Engagement', 3.9, 5.0, Colors.teal),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicatorItem(String name, double value, double maxValue, Color color) {
    final percentage = (value / maxValue) * 100;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Text(
                '${value.toStringAsFixed(1)}/${maxValue.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: value / maxValue,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          const SizedBox(height: 4),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompetitiveAnalysis(BuildContext context, Map<String, dynamic> competitive) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Competitive Analysis',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: Column(
                children: [
                  _buildCompetitorItem('KaziApp', 12.5, Colors.blue, isUs: true),
                  _buildCompetitorItem('Competitor A', 18.2, Colors.red),
                  _buildCompetitorItem('Competitor B', 15.8, Colors.orange),
                  _buildCompetitorItem('Competitor C', 9.3, Colors.green),
                  _buildCompetitorItem('Others', 44.2, Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompetitorItem(String name, double marketShare, Color color, {bool isUs = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUs ? color.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isUs ? Border.all(color: color.withOpacity(0.3)) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isUs ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            '${marketShare.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessReports(BuildContext context, List<Map<String, dynamic>> reports) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Business Reports',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: reports.take(5).length,
                itemBuilder: (context, index) {
                  final report = reports[index];
                  return _buildReportItem(report);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportItem(Map<String, dynamic> report) {
    final status = report['status'] as String? ?? 'completed';
    final color = _getStatusColor(status);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.description,
            size: 20,
            color: color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report['name'] as String? ?? 'Report',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  report['description'] as String? ?? 'No description',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketInsights(BuildContext context, Map<String, dynamic> insights) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Market Insights',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: ListView(
                children: [
                  _buildInsightItem(
                    'Market Growth',
                    'Agricultural technology market is growing at 15% annually',
                    Icons.trending_up,
                    Colors.green,
                  ),
                  _buildInsightItem(
                    'User Behavior',
                    'Mobile usage increased by 23% in the last quarter',
                    Icons.phone_android,
                    Colors.blue,
                  ),
                  _buildInsightItem(
                    'Seasonal Trends',
                    'Peak usage during planting and harvest seasons',
                    Icons.calendar_today,
                    Colors.orange,
                  ),
                  _buildInsightItem(
                    'Regional Expansion',
                    'High demand in rural areas of East Africa',
                    Icons.location_on,
                    Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(String title, String description, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
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

  Widget _buildActionableInsights(BuildContext context, List<Map<String, dynamic>> insights) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actionable Insights',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...insights.take(3).map((insight) => _buildActionableInsightItem(insight)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionableInsightItem(Map<String, dynamic> insight) {
    final priority = insight['priority'] as String? ?? 'medium';
    final color = _getPriorityColor(priority);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  priority.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.lightbulb, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            insight['title'] as String? ?? 'Insight',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            insight['description'] as String? ?? 'No description available',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          if (insight['action'] != null) ...[
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
              ),
              child: Text(insight['action'] as String),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
