import 'package:flutter/material.dart';

class AIDiagnosisScreen extends StatefulWidget {
  const AIDiagnosisScreen({super.key});

  @override
  State<AIDiagnosisScreen> createState() => _AIDiagnosisScreenState();
}

class _AIDiagnosisScreenState extends State<AIDiagnosisScreen> {
  bool _isAnalyzing = false;
  Map<String, dynamic>? _diagnosisResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Crop Diagnosis'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.camera_alt,
                      size: 64,
                      color: Color(0xFF2E7D32),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'AI-Powered Crop Diagnosis',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Take a photo of your crop to get instant disease detection and treatment recommendations',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
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
                    onPressed: _isAnalyzing ? null : () => _takePhoto('camera'),
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
                    onPressed: _isAnalyzing ? null : () => _takePhoto('gallery'),
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
            
            // Analysis Progress
            if (_isAnalyzing)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Analyzing your crop...',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Our AI is examining the image for diseases, pests, and nutrient deficiencies',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            
            // Diagnosis Results
            if (_diagnosisResult != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
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
                                  _diagnosisResult!['disease'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Confidence: ${_diagnosisResult!['confidence']}%',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
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
                        'Treatment Recommendations',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...(_diagnosisResult!['treatments'] as List<String>).map(
                        (treatment) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• '),
                              Expanded(child: Text(treatment)),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _contactVet(),
                              icon: const Icon(Icons.medical_services),
                              label: const Text('Contact Vet'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _buyTreatment(),
                              icon: const Icon(Icons.shopping_cart),
                              label: const Text('Buy Treatment'),
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
              ),
            
            const SizedBox(height: 24),
            
            // Tips Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Photography Tips',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTip('📸', 'Take clear, well-lit photos'),
                    _buildTip('🔍', 'Focus on affected areas'),
                    _buildTip('📏', 'Include leaves, stems, or fruits'),
                    _buildTip('🌅', 'Best results in natural daylight'),
                    _buildTip('📱', 'Hold phone steady for sharp images'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // USSD Alternative
            Container(
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
                    'No Camera? Use USSD!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Dial *123*2# to describe symptoms and get diagnosis via SMS',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  void _takePhoto(String source) async {
    setState(() {
      _isAnalyzing = true;
      _diagnosisResult = null;
    });

    // Simulate photo capture and analysis
    await Future.delayed(const Duration(seconds: 3));

    // Mock diagnosis result
    setState(() {
      _isAnalyzing = false;
      _diagnosisResult = {
        'disease': 'Tomato Late Blight',
        'confidence': 87,
        'severity': 'High',
        'description': 'Late blight is a serious disease that affects tomato plants, causing dark spots on leaves and stems. It spreads rapidly in humid conditions.',
        'treatments': [
          'Apply copper-based fungicide immediately',
          'Remove and destroy affected plant parts',
          'Improve air circulation around plants',
          'Avoid overhead watering',
          'Consider resistant varieties for next season',
        ],
      };
    });
  }

  void _contactVet() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Veterinarian'),
        content: const Text(
          'Would you like to book a consultation with a crop specialist to discuss this diagnosis?',
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
        content: const Text(
          'Recommended products for Tomato Late Blight:\n\n• Copper-based fungicide - KSh 450\n• Organic neem oil spray - KSh 320\n• Disease-resistant seeds - KSh 280',
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
                  content: Text('Redirecting to marketplace...'),
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
