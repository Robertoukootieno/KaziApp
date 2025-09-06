import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'livestock_diagnosis_screen.dart';
import 'crop_diagnosis_screen.dart';
import 'vet_search_screen.dart';
import 'consultation_booking_screen.dart';
import 'treatment_purchase_screen.dart';

class AIDiagnosisScreen extends StatefulWidget {
  const AIDiagnosisScreen({super.key});

  @override
  State<AIDiagnosisScreen> createState() => _AIDiagnosisScreenState();
}

class _AIDiagnosisScreenState extends State<AIDiagnosisScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text('AI Diagnosis'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Livestock', icon: Icon(Icons.pets)),
            Tab(text: 'Crops', icon: Icon(Icons.eco)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _showQuickActions(context),
            icon: const Icon(Icons.medical_services),
            tooltip: 'Quick Actions',
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Access Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.search,
                    label: 'Find Vet',
                    onTap: () => _navigateToVetSearch(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.calendar_today,
                    label: 'Book Consult',
                    onTap: () => _navigateToConsultation(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.shopping_cart,
                    label: 'Buy Treatment',
                    onTap: () => _navigateToTreatment(),
                  ),
                ),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLivestockTab(),
                _buildCropsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "ai_diagnosis_fab",
        onPressed: () => _showDiagnosisOptions(context),
        backgroundColor: const Color(0xFF2E7D32),
        icon: const Icon(Icons.camera_alt),
        label: const Text('Start Diagnosis'),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLivestockTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.pets,
                  size: 64,
                  color: Color(0xFF2E7D32),
                ),
                SizedBox(height: 16),
                Text(
                  'Livestock Health Diagnosis',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'AI-powered diagnosis for cattle, goats, sheep, pigs, and poultry',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Animal Categories
          const Text(
            'Select Animal Type',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _buildAnimalCard('Cattle', Icons.agriculture, '🐄', () => _navigateToLivestockDiagnosis('Cattle')),
              _buildAnimalCard('Goats', Icons.pets, '🐐', () => _navigateToLivestockDiagnosis('Goats')),
              _buildAnimalCard('Sheep', Icons.pets, '🐑', () => _navigateToLivestockDiagnosis('Sheep')),
              _buildAnimalCard('Pigs', Icons.pets, '🐷', () => _navigateToLivestockDiagnosis('Pigs')),
              _buildAnimalCard('Poultry', Icons.pets, '🐔', () => _navigateToLivestockDiagnosis('Poultry')),
              _buildAnimalCard('Other', Icons.pets, '🐾', () => _navigateToLivestockDiagnosis('Other')),
            ],
          ),

          const SizedBox(height: 24),

          // Recent Diagnoses
          _buildRecentDiagnoses('livestock'),
        ],
      ),
    );
  }

  Widget _buildCropsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.eco,
                  size: 64,
                  color: Color(0xFF2E7D32),
                ),
                SizedBox(height: 16),
                Text(
                  'Crop Disease Diagnosis',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'AI-powered diagnosis for crop diseases, pests, and nutrient deficiencies',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Crop Categories
          const Text(
            'Select Crop Type',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _buildCropCard('Maize', Icons.grass, '🌽', () => _navigateToCropDiagnosis('Maize')),
              _buildCropCard('Beans', Icons.eco, '🫘', () => _navigateToCropDiagnosis('Beans')),
              _buildCropCard('Tomatoes', Icons.eco, '🍅', () => _navigateToCropDiagnosis('Tomatoes')),
              _buildCropCard('Potatoes', Icons.eco, '🥔', () => _navigateToCropDiagnosis('Potatoes')),
              _buildCropCard('Coffee', Icons.eco, '☕', () => _navigateToCropDiagnosis('Coffee')),
              _buildCropCard('Other', Icons.eco, '🌱', () => _navigateToCropDiagnosis('Other')),
            ],
          ),

          const SizedBox(height: 24),

          // Recent Diagnoses
          _buildRecentDiagnoses('crops'),
        ],
      ),
    );
  }

  Widget _buildAnimalCard(String name, IconData icon, String emoji, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCropCard(String name, IconData icon, String emoji, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentDiagnoses(String type) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Diagnoses',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'No recent diagnoses yet. Start by taking a photo!',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showDiagnosisOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Start Diagnosis',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _tabController.animateTo(0);
                    },
                    icon: const Icon(Icons.pets),
                    label: const Text('Livestock'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _tabController.animateTo(1);
                    },
                    icon: const Icon(Icons.eco),
                    label: const Text('Crops'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.search, color: Color(0xFF2E7D32)),
              title: const Text('Find Veterinarian'),
              subtitle: const Text('Search for vets in your area'),
              onTap: () {
                Navigator.pop(context);
                _navigateToVetSearch();
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Color(0xFF2E7D32)),
              title: const Text('Book Consultation'),
              subtitle: const Text('Schedule a vet consultation'),
              onTap: () {
                Navigator.pop(context);
                _navigateToConsultation();
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart, color: Color(0xFF2E7D32)),
              title: const Text('Buy Treatment'),
              subtitle: const Text('Purchase medicines and treatments'),
              onTap: () {
                Navigator.pop(context);
                _navigateToTreatment();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Navigation methods
  void _navigateToLivestockDiagnosis(String animalType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LivestockDiagnosisScreen(animalType: animalType),
      ),
    );
  }

  void _navigateToCropDiagnosis(String cropType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CropDiagnosisScreen(cropType: cropType),
      ),
    );
  }

  void _navigateToVetSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VetSearchScreen()),
    );
  }

  void _navigateToConsultation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ConsultationBookingScreen()),
    );
  }

  void _navigateToTreatment() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TreatmentPurchaseScreen()),
    );
  }
}
