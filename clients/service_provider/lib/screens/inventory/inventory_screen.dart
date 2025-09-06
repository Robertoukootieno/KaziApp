import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory, size: 64, color: Color(0xFF2E7D32)),
            SizedBox(height: 16),
            Text(
              'Inventory Management',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('Manage your products and stock'),
          ],
        ),
      ),
    );
  }
}
