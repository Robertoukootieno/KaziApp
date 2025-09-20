import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/stat_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(context),
            const SizedBox(height: 32),
            
            // Stats Overview
            _buildStatsOverview(),
            const SizedBox(height: 32),
            
            // Recent Activity
            _buildRecentActivity(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to KaziApp Admin',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Monitor and manage your agricultural platform',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.dashboard,
              size: 64,
              color: Colors.green,
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
        const Text(
          'Platform Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
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
              // Large tablet: 2 cards per row
              crossAxisCount = 2;
              childAspectRatio = 1.8;
            } else {
              // Desktop: 4 cards per row
              crossAxisCount = 4;
              childAspectRatio = 1.5;
            }

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: childAspectRatio,
              children: [
                StatCard(
                  title: 'Total Farmers',
                  value: '12,543',
                  icon: Icons.people,
                  color: Colors.blue,
                ),
                StatCard(
                  title: 'Service Providers',
                  value: '1,234',
                  icon: Icons.business,
                  color: Colors.green,
                ),
                StatCard(
                  title: 'Active Transactions',
                  value: '8,765',
                  icon: Icons.payment,
                  color: Colors.orange,
                ),
                StatCard(
                  title: 'System Health',
                  value: '99.9%',
                  icon: Icons.health_and_safety,
                  color: Colors.red,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.withValues(alpha: 0.1),
                    child: const Icon(Icons.person, color: Colors.green),
                  ),
                  title: Text('New farmer registration #${1000 + index}'),
                  subtitle: Text('${index + 1} minutes ago'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
