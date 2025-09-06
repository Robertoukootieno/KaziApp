import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications, size: 64, color: Color(0xFF2E7D32)),
            SizedBox(height: 16),
            Text(
              'Notifications',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('View your notifications and alerts'),
          ],
        ),
      ),
    );
  }
}
