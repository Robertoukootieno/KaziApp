import 'package:flutter/material.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _selectedLocation = 'Nakuru';
  
  final List<String> _locations = [
    'Nakuru',
    'Nairobi',
    'Mombasa',
    'Kisumu',
    'Eldoret',
    'Thika',
  ];

  final Map<String, dynamic> _currentWeather = {
    'temperature': 24,
    'condition': 'Partly Cloudy',
    'humidity': 65,
    'windSpeed': 12,
    'rainfall': 2.5,
    'uvIndex': 6,
    'icon': Icons.wb_cloudy,
  };

  final List<Map<String, dynamic>> _forecast = [
    {
      'day': 'Today',
      'high': 26,
      'low': 18,
      'condition': 'Partly Cloudy',
      'icon': Icons.wb_cloudy,
      'rainfall': 10,
    },
    {
      'day': 'Tomorrow',
      'high': 28,
      'low': 20,
      'condition': 'Sunny',
      'icon': Icons.wb_sunny,
      'rainfall': 0,
    },
    {
      'day': 'Wednesday',
      'high': 25,
      'low': 17,
      'condition': 'Light Rain',
      'icon': Icons.grain,
      'rainfall': 80,
    },
    {
      'day': 'Thursday',
      'high': 23,
      'low': 16,
      'condition': 'Rainy',
      'icon': Icons.grain,
      'rainfall': 90,
    },
    {
      'day': 'Friday',
      'high': 27,
      'low': 19,
      'condition': 'Partly Cloudy',
      'icon': Icons.wb_cloudy,
      'rainfall': 20,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather & Climate'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          DropdownButton<String>(
            value: _selectedLocation,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            underline: Container(),
            dropdownColor: const Color(0xFF2E7D32),
            style: const TextStyle(color: Colors.white),
            items: _locations.map((String location) {
              return DropdownMenuItem<String>(
                value: location,
                child: Text(location),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedLocation = newValue!;
              });
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Current Weather Card
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      _selectedLocation,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateTime.now().toString().split(' ')[0],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _currentWeather['icon'],
                          size: 64,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_currentWeather['temperature']}°C',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              _currentWeather['condition'],
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Weather Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildWeatherDetail(
                      'Humidity',
                      '${_currentWeather['humidity']}%',
                      Icons.water_drop,
                    ),
                  ),
                  Expanded(
                    child: _buildWeatherDetail(
                      'Wind',
                      '${_currentWeather['windSpeed']} km/h',
                      Icons.air,
                    ),
                  ),
                  Expanded(
                    child: _buildWeatherDetail(
                      'Rainfall',
                      '${_currentWeather['rainfall']} mm',
                      Icons.grain,
                    ),
                  ),
                  Expanded(
                    child: _buildWeatherDetail(
                      'UV Index',
                      '${_currentWeather['uvIndex']}',
                      Icons.wb_sunny,
                    ),
                  ),
                ],
              ),
            ),
            
            // 5-Day Forecast
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '5-Day Forecast',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...(_forecast.map((day) => _buildForecastItem(day))),
                ],
              ),
            ),
            
            // Farming Recommendations
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.agriculture,
                            color: Color(0xFF2E7D32),
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Farming Recommendations',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildRecommendation(
                        '🌱',
                        'Planting',
                        'Good conditions for planting maize and beans this week',
                      ),
                      _buildRecommendation(
                        '💧',
                        'Irrigation',
                        'Reduce watering - rain expected Wednesday and Thursday',
                      ),
                      _buildRecommendation(
                        '🌾',
                        'Harvesting',
                        'Ideal weather for harvesting dry crops this weekend',
                      ),
                      _buildRecommendation(
                        '🦠',
                        'Disease Alert',
                        'High humidity may increase fungal disease risk',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Climate Insights
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.insights,
                            color: Color(0xFF2E7D32),
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Climate Insights',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInsightItem('Seasonal Outlook', 'Long rains expected to start in March'),
                      _buildInsightItem('Temperature Trend', 'Temperatures 2°C above average this month'),
                      _buildInsightItem('Rainfall Pattern', 'Total rainfall 15% below seasonal average'),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _showDetailedClimate(),
                        icon: const Icon(Icons.analytics),
                        label: const Text('View Detailed Analysis'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // USSD Weather
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.phone,
                      color: Colors.orange,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Get Weather via USSD',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Dial *123*3# for weather updates via SMS',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(
              icon,
              color: const Color(0xFF2E7D32),
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastItem(Map<String, dynamic> day) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          day['icon'],
          color: const Color(0xFF2E7D32),
          size: 32,
        ),
        title: Text(
          day['day'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(day['condition']),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${day['high']}°/${day['low']}°',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              '${day['rainfall']}%',
              style: TextStyle(
                color: Colors.blue[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendation(String emoji, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.circle,
            size: 8,
            color: Color(0xFF2E7D32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailedClimate() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detailed Climate Analysis',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Historical Data (Last 30 days)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildClimateData('Average Temperature', '23.5°C', '↑ 1.2°C from last month'),
            _buildClimateData('Total Rainfall', '45.2mm', '↓ 12mm from average'),
            _buildClimateData('Humidity', '68%', '↑ 5% from last month'),
            _buildClimateData('Sunny Days', '18 days', '↑ 3 days from average'),
            const SizedBox(height: 20),
            const Text(
              'Seasonal Forecast',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text('• Long rains expected to start in mid-March'),
            const Text('• Above-average temperatures likely to continue'),
            const Text('• Drought risk remains low for this region'),
            const Text('• Optimal planting window: March 15 - April 30'),
          ],
        ),
      ),
    );
  }

  Widget _buildClimateData(String label, String value, String trend) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                trend,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
