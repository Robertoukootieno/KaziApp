import 'package:flutter/material.dart';
import '../../services/farmer_profile_service.dart';
import '../../models/farmer_profile.dart';

class FarmerProfileScreen extends StatefulWidget {
  const FarmerProfileScreen({super.key});

  @override
  State<FarmerProfileScreen> createState() => _FarmerProfileScreenState();
}

class _FarmerProfileScreenState extends State<FarmerProfileScreen> {
  final FarmerProfileService _profileService = FarmerProfileService();
  FarmerProfile? _profile;
  FarmerPreferences? _preferences;
  bool _isLoading = true;
  bool _isEditing = false;

  // Controllers for editing
  final _nameController = TextEditingController();
  final _farmNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _farmSizeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _farmNameController.dispose();
    _locationController.dispose();
    _farmSizeController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      await _profileService.initialize();
      setState(() {
        _profile = _profileService.currentProfile;
        _preferences = _profileService.currentPreferences;
        _isLoading = false;
      });

      if (_profile != null) {
        _nameController.text = _profile!.name;
        _farmNameController.text = _profile!.farmName;
        _locationController.text = _profile!.location;
        _farmSizeController.text = _profile!.farmSize.toString();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to load profile: $e');
    }
  }

  Future<void> _saveProfile() async {
    try {
      await _profileService.updateProfile({
        'name': _nameController.text.trim(),
        'farmName': _farmNameController.text.trim(),
        'location': _locationController.text.trim(),
        'farmSize': double.tryParse(_farmSizeController.text) ?? _profile!.farmSize,
      });

      setState(() {
        _profile = _profileService.currentProfile;
        _isEditing = false;
      });

      _showSuccessSnackBar('Profile updated successfully!');
    } catch (e) {
      _showErrorSnackBar('Failed to update profile: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF2E7D32),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: [
          if (_profile != null && !_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveProfile,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _profile == null
              ? _buildNoProfileView()
              : _buildProfileView(),
    );
  }

  Widget _buildNoProfileView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No profile found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please complete registration to create your profile',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    final stats = _profileService.getFarmerStats();
    final recommendations = _profileService.getPersonalizedRecommendations();
    final features = _profileService.getCustomizedFeatures();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Profile Header Card
          _buildProfileHeaderCard(),
          
          const SizedBox(height: 16),
          
          // Farm Statistics Card
          _buildStatsCard(stats),
          
          const SizedBox(height: 16),
          
          // Profile Details Card
          _buildProfileDetailsCard(),
          
          const SizedBox(height: 16),
          
          // Farming Details Card
          _buildFarmingDetailsCard(),
          
          const SizedBox(height: 16),
          
          // Personalized Recommendations Card
          _buildRecommendationsCard(recommendations),
          
          const SizedBox(height: 16),
          
          // App Features Card
          _buildFeaturesCard(features),
        ],
      ),
    );
  }

  Widget _buildProfileHeaderCard() {
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
          // Profile Avatar
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Text(
              _profile!.name.split(' ').map((n) => n[0]).take(2).join().toUpperCase(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Name and Farm
          if (_isEditing)
            Column(
              children: [
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _farmNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Farm Name',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                Text(
                  _profile!.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  _profile!.farmName,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          
          const SizedBox(height: 16),
          
          // Farming Type Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _profile!.farmingTypeIcon,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
                Text(
                  _profile!.farmingType,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(Map<String, dynamic> stats) {
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
          const Text(
            'Farm Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Profile Complete',
                  '${stats['profileCompleteness']?.toInt() ?? 0}%',
                  Icons.person,
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Farm Size',
                  '${_profile!.farmSize} acres',
                  Icons.landscape,
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProfileDetailsCard() {
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
          const Text(
            'Profile Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Phone', _profile!.phone, Icons.phone),
          _buildDetailRow('Location', _profile!.location, Icons.location_on),
          _buildDetailRow('County', _profile!.county, Icons.map),
          _buildDetailRow('Language', _profile!.language, Icons.language),
        ],
      ),
    );
  }

  Widget _buildFarmingDetailsCard() {
    return const Center(child: Text('Farming Details - Coming Soon'));
  }

  Widget _buildRecommendationsCard(List<String> recommendations) {
    return const Center(child: Text('Recommendations - Coming Soon'));
  }

  Widget _buildFeaturesCard(Map<String, bool> features) {
    return const Center(child: Text('Features - Coming Soon'));
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
