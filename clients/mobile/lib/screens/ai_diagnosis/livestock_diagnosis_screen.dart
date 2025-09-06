import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class LivestockDiagnosisScreen extends StatefulWidget {
  final String animalType;

  const LivestockDiagnosisScreen({super.key, required this.animalType});

  @override
  State<LivestockDiagnosisScreen> createState() => _LivestockDiagnosisScreenState();
}

class _LivestockDiagnosisScreenState extends State<LivestockDiagnosisScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isAnalyzing = false;
  Map<String, dynamic>? _diagnosisResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.animalType} Diagnosis'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Card
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
              child: Column(
                children: [
                  Text(
                    _getAnimalEmoji(widget.animalType),
                    style: const TextStyle(fontSize: 64),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${widget.animalType} Health Diagnosis',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Take a clear photo of your animal to get AI-powered health diagnosis',
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
            
            // Image Preview
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.grey.shade50,
              ),
              child: _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error, size: 48, color: Colors.red),
                                SizedBox(height: 8),
                                Text('Error loading image'),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'No image selected',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Take a photo or select from gallery',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            
            const SizedBox(height: 24),
            
            // Camera Options
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isAnalyzing ? null : () => _takePhoto(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Photo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isAnalyzing ? null : () => _takePhoto(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('From Gallery'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2E7D32),
                      side: const BorderSide(color: Color(0xFF2E7D32)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Analyze Button
            if (_selectedImage != null && !_isAnalyzing)
              ElevatedButton.icon(
                onPressed: _analyzeImage,
                icon: const Icon(Icons.psychology),
                label: const Text('Analyze Image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            
            // Analysis Progress
            if (_isAnalyzing)
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
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Analyzing animal health...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Our AI is examining the image for health issues and symptoms',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            
            // Diagnosis Results
            if (_diagnosisResult != null)
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _diagnosisResult!['severity'] == 'High' 
                              ? Icons.warning 
                              : Icons.check_circle,
                          color: _diagnosisResult!['severity'] == 'High' 
                              ? Colors.red 
                              : Colors.green,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _diagnosisResult!['condition'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Confidence: ${_diagnosisResult!['confidence']}%',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_diagnosisResult!['description']),
                    
                    const SizedBox(height: 16),
                    
                    const Text(
                      'Recommended Actions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...(_diagnosisResult!['actions'] as List<String>).map(
                      (action) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• '),
                            Expanded(child: Text(action)),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _contactVet,
                            icon: const Icon(Icons.medical_services),
                            label: const Text('Contact Vet'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _buyTreatment,
                            icon: const Icon(Icons.shopping_cart),
                            label: const Text('Buy Medicine'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D32),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 24),
            
            // Photography Tips
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Photography Tips for Best Results',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTip('📸', 'Take clear, well-lit photos'),
                  _buildTip('🔍', 'Focus on affected areas (eyes, skin, wounds)'),
                  _buildTip('📏', 'Include the whole animal if possible'),
                  _buildTip('🌅', 'Best results in natural daylight'),
                  _buildTip('📱', 'Hold phone steady for sharp images'),
                  _buildTip('🚫', 'Avoid using flash as it may stress the animal'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAnimalEmoji(String animalType) {
    switch (animalType) {
      case 'Cattle': return '🐄';
      case 'Goats': return '🐐';
      case 'Sheep': return '🐑';
      case 'Pigs': return '🐷';
      case 'Poultry': return '🐔';
      default: return '🐾';
    }
  }

  Widget _buildTip(String emoji, String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _takePhoto(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _diagnosisResult = null;
        });

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                source == ImageSource.camera
                  ? 'Photo captured successfully! Tap "Analyze Image" to diagnose.'
                  : 'Image selected successfully! Tap "Analyze Image" to diagnose.'
              ),
              backgroundColor: const Color(0xFF2E7D32),
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Analyze',
                textColor: Colors.white,
                onPressed: () {
                  if (_selectedImage != null) {
                    _analyzeImage();
                  }
                },
              ),
            ),
          );
        }
      } else {
        // User cancelled
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                source == ImageSource.camera
                  ? 'Camera cancelled'
                  : 'Image selection cancelled'
              ),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Error accessing ${source == ImageSource.camera ? 'camera' : 'gallery'}';

        if (e.toString().contains('camera_access_denied')) {
          errorMessage = 'Camera permission denied. Please enable camera access in settings.';
        } else if (e.toString().contains('photo_access_denied')) {
          errorMessage = 'Photo library access denied. Please enable photo access in settings.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Settings',
              textColor: Colors.white,
              onPressed: () {
                _showPermissionDialog(source);
              },
            ),
          ),
        );
      }
    }
  }

  void _showPermissionDialog(ImageSource source) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${source == ImageSource.camera ? 'Camera' : 'Photo'} Permission Required'),
        content: Text(
          'This app needs ${source == ImageSource.camera ? 'camera' : 'photo library'} access to capture images for AI diagnosis. '
          'Please enable the permission in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // In a real app, you would open app settings here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enable camera/photo permissions in device settings'),
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _analyzeImage() async {
    setState(() {
      _isAnalyzing = true;
    });

    // Simulate AI analysis
    await Future.delayed(const Duration(seconds: 3));

    // Mock diagnosis result based on animal type
    setState(() {
      _isAnalyzing = false;
      _diagnosisResult = _getMockDiagnosis(widget.animalType);
    });
  }

  Map<String, dynamic> _getMockDiagnosis(String animalType) {
    switch (animalType) {
      case 'Cattle':
        return {
          'condition': 'Mastitis (Early Stage)',
          'confidence': 82,
          'severity': 'Medium',
          'description': 'Early signs of mastitis detected. The udder shows mild inflammation which is common in dairy cattle.',
          'actions': [
            'Isolate the affected animal',
            'Apply warm compress to the udder',
            'Consult veterinarian for antibiotic treatment',
            'Improve milking hygiene',
            'Monitor temperature regularly',
          ],
        };
      case 'Poultry':
        return {
          'condition': 'Newcastle Disease',
          'confidence': 91,
          'severity': 'High',
          'description': 'Signs consistent with Newcastle Disease. This is a highly contagious viral infection affecting poultry.',
          'actions': [
            'Immediately isolate affected birds',
            'Contact veterinarian urgently',
            'Disinfect the coop thoroughly',
            'Vaccinate healthy birds',
            'Report to local animal health authorities',
          ],
        };
      default:
        return {
          'condition': 'Healthy Animal',
          'confidence': 95,
          'severity': 'Low',
          'description': 'The animal appears healthy with no visible signs of disease or distress.',
          'actions': [
            'Continue regular health monitoring',
            'Maintain good nutrition',
            'Ensure clean water supply',
            'Schedule routine veterinary checkups',
          ],
        };
    }
  }

  void _contactVet() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Veterinarian'),
        content: Text(
          'Would you like to book a consultation with a veterinarian specializing in ${widget.animalType.toLowerCase()}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Redirecting to veterinarian booking...'),
                  backgroundColor: Color(0xFF2E7D32),
                ),
              );
            },
            child: const Text('Book Consultation'),
          ),
        ],
      ),
    );
  }

  void _buyTreatment() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buy Treatment'),
        content: Text(
          'Recommended treatments for ${_diagnosisResult!['condition']}:\n\n'
          '• Antibiotics - KSh 850\n'
          '• Anti-inflammatory - KSh 420\n'
          '• Vitamins & supplements - KSh 320',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Redirecting to treatment marketplace...'),
                  backgroundColor: Color(0xFF2E7D32),
                ),
              );
            },
            child: const Text('View Products'),
          ),
        ],
      ),
    );
  }
}
