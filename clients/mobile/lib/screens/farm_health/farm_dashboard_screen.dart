import 'package:flutter/material.dart';

class FarmDashboardScreen extends StatefulWidget {
  const FarmDashboardScreen({super.key});

  @override
  State<FarmDashboardScreen> createState() => _FarmDashboardScreenState();
}

class _FarmDashboardScreenState extends State<FarmDashboardScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Farm Score Data
  final Map<String, dynamic> _farmScore = {
    'overall': 87,
    'health': 92,
    'productivity': 85,
    'sustainability': 83,
    'financial': 88,
    'trend': 'improving', // improving, stable, declining
    'creditRating': 'A-',
    'lastUpdated': '2024-01-15',
  };

  // Recent Activities
  final List<Map<String, dynamic>> _recentActivities = [
    {
      'type': 'health_check',
      'title': 'Cattle Health Check',
      'description': 'All 12 cattle checked - 1 minor issue detected',
      'timestamp': '2 hours ago',
      'status': 'warning',
      'icon': Icons.medical_services,
    },
    {
      'type': 'yield_record',
      'title': 'Maize Harvest Recorded',
      'description': '2.3 tons harvested from Plot A - 15% above average',
      'timestamp': '1 day ago',
      'status': 'success',
      'icon': Icons.agriculture,
    },
    {
      'type': 'ai_diagnosis',
      'title': 'AI Disease Detection',
      'description': 'Early blight detected in tomato crop - treatment recommended',
      'timestamp': '3 days ago',
      'status': 'alert',
      'icon': Icons.psychology,
    },
    {
      'type': 'soil_test',
      'title': 'Soil Analysis Complete',
      'description': 'pH levels optimal, nitrogen slightly low',
      'timestamp': '1 week ago',
      'status': 'info',
      'icon': Icons.grass,
    },
  ];

  // Farm Statistics
  final Map<String, dynamic> _farmStats = {
    'totalAnimals': 45,
    'healthyAnimals': 43,
    'cropBatches': 8,
    'activePlots': 12,
    'avgYield': 2.1,
    'diseaseIncidents': 3,
    'treatmentSuccess': 94,
    'soilHealth': 88,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Row(
          children: [
            Icon(Icons.dashboard, color: Colors.white),
            SizedBox(width: 8),
            Text('Farm Health Dashboard'),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
            Tab(icon: Icon(Icons.pets), text: 'Animals'),
            Tab(icon: Icon(Icons.agriculture), text: 'Crops'),
            Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildAnimalsTab(),
          _buildCropsTab(),
          _buildAnalyticsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "farm_dashboard_fab",
        onPressed: () => _showAddRecordDialog(),
        backgroundColor: const Color(0xFF2E7D32),
        icon: const Icon(Icons.add),
        label: const Text('Add Record'),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Farm Score Card
          _buildFarmScoreCard(),
          
          const SizedBox(height: 16),
          
          // Quick Stats
          _buildQuickStatsGrid(),
          
          const SizedBox(height: 16),
          
          // Recent Activities
          _buildRecentActivitiesSection(),
          
          const SizedBox(height: 16),
          
          // AI Insights
          _buildAIInsightsCard(),
        ],
      ),
    );
  }

  Widget _buildFarmScoreCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Farm Health Score',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Overall Performance Rating',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      _farmScore['trend'] == 'improving' ? Icons.trending_up : 
                      _farmScore['trend'] == 'declining' ? Icons.trending_down : Icons.trending_flat,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _farmScore['trend'].toString().toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Score Display
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${_farmScore['overall']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 20),
              
              Expanded(
                child: Column(
                  children: [
                    _buildScoreBar('Health', _farmScore['health'], Colors.green),
                    const SizedBox(height: 8),
                    _buildScoreBar('Productivity', _farmScore['productivity'], Colors.blue),
                    const SizedBox(height: 8),
                    _buildScoreBar('Sustainability', _farmScore['sustainability'], Colors.orange),
                    const SizedBox(height: 8),
                    _buildScoreBar('Financial', _farmScore['financial'], Colors.purple),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Credit Rating: ${_farmScore['creditRating']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Updated: ${_farmScore['lastUpdated']}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBar(String label, int score, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: score / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$score',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('Total Animals', '${_farmStats['totalAnimals']}',
                      '${_farmStats['healthyAnimals']} healthy', Icons.pets, Colors.blue),
        _buildStatCard('Active Plots', '${_farmStats['activePlots']}',
                      '${_farmStats['cropBatches']} crop batches', Icons.agriculture, Colors.green),
        _buildStatCard('Avg Yield', '${_farmStats['avgYield']} tons',
                      '${_farmStats['treatmentSuccess']}% success rate', Icons.trending_up, Colors.orange),
        _buildStatCard('Soil Health', '${_farmStats['soilHealth']}%',
                      '${_farmStats['diseaseIncidents']} incidents', Icons.grass, Colors.purple),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(Icons.arrow_upward, color: color, size: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Activities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => _showAllActivities(),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _recentActivities.length,
          itemBuilder: (context, index) {
            final activity = _recentActivities[index];
            return _buildActivityCard(activity);
          },
        ),
      ],
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    Color statusColor;
    switch (activity['status']) {
      case 'success':
        statusColor = Colors.green;
        break;
      case 'warning':
        statusColor = Colors.orange;
        break;
      case 'alert':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.blue;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              activity['icon'],
              color: statusColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity['description'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity['timestamp'],
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.grey[400],
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildAIInsightsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: Colors.purple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'AI Insights & Recommendations',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInsightItem(
            'Disease Pattern Detected',
            'Cattle show 23% higher respiratory issues during rainy season. Consider preventive vaccination.',
            Icons.warning,
            Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildInsightItem(
            'Yield Optimization',
            'Plot B shows 18% better yield with current fertilizer schedule. Apply to other plots.',
            Icons.trending_up,
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildInsightItem(
            'Credit Score Impact',
            'Consistent health records could improve your credit rating by 12 points.',
            Icons.account_balance,
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(String title, String description, IconData icon, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildAnimalsTab() {
    return const Center(
      child: Text('Animals Tab - Coming Soon'),
    );
  }

  Widget _buildCropsTab() {
    return const Center(
      child: Text('Crops Tab - Coming Soon'),
    );
  }

  Widget _buildAnalyticsTab() {
    return const Center(
      child: Text('Analytics Tab - Coming Soon'),
    );
  }

  void _showAddRecordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Health Record'),
        content: const Text('Choose what type of record to add:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to add record screen
            },
            child: const Text('Add Record'),
          ),
        ],
      ),
    );
  }

  void _showAllActivities() {
    // Navigate to full activities screen
  }
}
