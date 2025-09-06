import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics, size: 64, color: Color(0xFF2E7D32)),
            SizedBox(height: 16),
            Text(
              'Business Analytics',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('View your business performance'),
          ],
        ),
      ),
    );
  }
}
