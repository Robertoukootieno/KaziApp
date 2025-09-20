import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../providers/analytics_providers.dart';

class UserBehaviorWidget extends ConsumerWidget {
  const UserBehaviorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final behaviorAsync = ref.watch(userBehaviorAnalyticsProvider);

    return behaviorAsync.when(
      data: (behavior) => _buildBehaviorContent(context, behavior),
      loading: () => const LoadingWidget(),
      error: (error, stack) => CustomErrorWidget(
        error: error.toString(),
        onRetry: () => ref.refresh(userBehaviorAnalyticsProvider),
      ),
    );
  }

  Widget _buildBehaviorContent(BuildContext context, UserBehaviorAnalytics behavior) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Behavior Analytics',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // User journey and feature usage
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 1200;
              
              if (isDesktop) {
                return Row(
                  children: [
                    Expanded(child: _buildUserJourney(context, behavior.userJourney)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildFeatureUsage(context, behavior.featureUsage)),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildUserJourney(context, behavior.userJourney),
                    const SizedBox(height: 16),
                    _buildFeatureUsage(context, behavior.featureUsage),
                  ],
                );
              }
            },
          ),
          
          const SizedBox(height: 24),
          
          // Session and device analytics
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 1200;
              
              if (isDesktop) {
                return Row(
                  children: [
                    Expanded(child: _buildSessionAnalytics(context, behavior.sessionAnalytics)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildDeviceAnalytics(context, behavior.deviceAnalytics)),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildSessionAnalytics(context, behavior.sessionAnalytics),
                    const SizedBox(height: 16),
                    _buildDeviceAnalytics(context, behavior.deviceAnalytics),
                  ],
                );
              }
            },
          ),
          
          const SizedBox(height: 24),
          
          // Geographic data and cohort analysis
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 1200;
              
              if (isDesktop) {
                return Row(
                  children: [
                    Expanded(child: _buildGeographicData(context, behavior.geographicData)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildCohortAnalysis(context, behavior.cohortAnalysis)),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildGeographicData(context, behavior.geographicData),
                    const SizedBox(height: 16),
                    _buildCohortAnalysis(context, behavior.cohortAnalysis),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserJourney(BuildContext context, Map<String, dynamic> userJourney) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Journey',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: Center(
                child: Text(
                  'User Journey Visualization\n(Interactive flow chart would be here)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureUsage(BuildContext context, Map<String, dynamic> featureUsage) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Feature Usage',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: ListView(
                children: [
                  _buildFeatureUsageItem('Dashboard', 85, Colors.blue),
                  _buildFeatureUsageItem('Reports', 72, Colors.green),
                  _buildFeatureUsageItem('Analytics', 68, Colors.orange),
                  _buildFeatureUsageItem('Settings', 45, Colors.purple),
                  _buildFeatureUsageItem('Help', 23, Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureUsageItem(String feature, int usage, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              feature,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: usage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$usage%',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionAnalytics(BuildContext context, Map<String, dynamic> sessionAnalytics) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Session Analytics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: Column(
                children: [
                  _buildSessionMetric('Average Session Duration', '12m 34s', Icons.access_time),
                  _buildSessionMetric('Pages per Session', '4.2', Icons.pages),
                  _buildSessionMetric('Bounce Rate', '32%', Icons.exit_to_app),
                  _buildSessionMetric('Return Visitors', '68%', Icons.repeat),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionMetric(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceAnalytics(BuildContext context, Map<String, dynamic> deviceAnalytics) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device Analytics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: Column(
                children: [
                  _buildDeviceBreakdown('Mobile', 65, Colors.blue),
                  _buildDeviceBreakdown('Desktop', 28, Colors.green),
                  _buildDeviceBreakdown('Tablet', 7, Colors.orange),
                  const SizedBox(height: 16),
                  _buildOSBreakdown(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceBreakdown(String device, int percentage, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              device,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$percentage%',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildOSBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Operating Systems',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            _buildOSChip('Android', 45, Colors.green),
            _buildOSChip('iOS', 35, Colors.blue),
            _buildOSChip('Windows', 15, Colors.orange),
            _buildOSChip('macOS', 5, Colors.grey),
          ],
        ),
      ],
    );
  }

  Widget _buildOSChip(String os, int percentage, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$os $percentage%',
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildGeographicData(BuildContext context, Map<String, dynamic> geographicData) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Geographic Distribution',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: Column(
                children: [
                  _buildCountryItem('Kenya', 45, Colors.green),
                  _buildCountryItem('Uganda', 25, Colors.blue),
                  _buildCountryItem('Tanzania', 20, Colors.orange),
                  _buildCountryItem('Rwanda', 7, Colors.purple),
                  _buildCountryItem('Others', 3, Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryItem(String country, int percentage, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              country,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$percentage%',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildCohortAnalysis(BuildContext context, List<Map<String, dynamic>> cohortAnalysis) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cohort Analysis',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: SingleChildScrollView(
                child: Table(
                  border: TableBorder.all(color: Colors.grey[300]!),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey[100]),
                      children: [
                        _buildTableCell('Cohort', isHeader: true),
                        _buildTableCell('Week 0', isHeader: true),
                        _buildTableCell('Week 1', isHeader: true),
                        _buildTableCell('Week 2', isHeader: true),
                        _buildTableCell('Week 3', isHeader: true),
                      ],
                    ),
                    ...List.generate(5, (index) {
                      return TableRow(
                        children: [
                          _buildTableCell('Jan ${index + 1}'),
                          _buildTableCell('100%', color: Colors.green),
                          _buildTableCell('${85 - index * 5}%', color: Colors.orange),
                          _buildTableCell('${70 - index * 8}%', color: Colors.red),
                          _buildTableCell('${60 - index * 10}%', color: Colors.red),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false, Color? color}) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: color ?? (isHeader ? Colors.black : Colors.grey[700]),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
