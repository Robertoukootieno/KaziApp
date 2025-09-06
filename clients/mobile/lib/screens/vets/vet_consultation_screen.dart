import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../services/webrtc_service.dart';
import '../../services/encryption_service.dart';
import '../../services/ai_image_diagnosis_service.dart';

// Simulated video renderer for demonstration
class RTCVideoRenderer {
  MediaStream? srcObject;
  Future<void> initialize() async {}
  void dispose() {}
}

class RTCVideoView extends StatelessWidget {
  final RTCVideoRenderer renderer;
  final bool mirror;

  const RTCVideoView(this.renderer, {super.key, this.mirror = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam, size: 64, color: Colors.white54),
            SizedBox(height: 16),
            Text(
              'Video Stream (Simulated)',
              style: TextStyle(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}

class VetConsultationScreen extends StatefulWidget {
  final Map<String, dynamic> vet;
  final String consultationType; // 'video', 'audio', 'chat'

  const VetConsultationScreen({
    super.key,
    required this.vet,
    this.consultationType = 'video',
  });

  @override
  State<VetConsultationScreen> createState() => _VetConsultationScreenState();
}

class _VetConsultationScreenState extends State<VetConsultationScreen> {
  final WebRTCService _webrtcService = WebRTCService();
  final EncryptionService _encryptionService = EncryptionService();
  final AIImageDiagnosisService _aiService = AIImageDiagnosisService();
  
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  final TextEditingController _chatController = TextEditingController();
  
  bool _isConnected = false;
  bool _isConnecting = false;
  bool _isMuted = false;
  bool _isCameraOff = false;
  final bool _isScreenSharing = false;
  String _connectionStatus = 'Disconnected';
  
  final List<Map<String, dynamic>> _chatMessages = [];
  final List<Map<String, dynamic>> _sharedImages = [];
  Map<String, dynamic>? _currentDiagnosis;
  
  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _webrtcService.dispose();
    _chatController.dispose();
    super.dispose();
  }

  Future<void> _initializeServices() async {
    try {
      // Initialize renderers
      await _localRenderer.initialize();
      await _remoteRenderer.initialize();
      
      // Initialize services
      await _webrtcService.initialize();
      await _encryptionService.initialize();
      await _aiService.initialize();
      
      // Set up WebRTC callbacks
      _webrtcService.onLocalStream = (stream) {
        setState(() {
          _localRenderer.srcObject = stream;
        });
      };
      
      _webrtcService.onRemoteStream = (stream) {
        setState(() {
          _remoteRenderer.srcObject = stream;
        });
      };
      
      _webrtcService.onConnectionStateChanged = (state) {
        setState(() {
          _connectionStatus = state;
          _isConnected = state == 'RTCPeerConnectionState.RTCPeerConnectionStateConnected';
        });
      };
      
      _webrtcService.onDataReceived = (data) {
        _handleReceivedData(data);
      };
      
    } catch (e) {
      _showErrorDialog('Failed to initialize services: $e');
    }
  }

  Future<void> _startCall() async {
    try {
      setState(() {
        _isConnecting = true;
      });
      
      // Start local media stream
      await _webrtcService.startLocalStream(
        video: widget.consultationType != 'audio',
        audio: true,
      );
      
      // Create offer for outgoing call
      await _webrtcService.createOffer();
      
      setState(() {
        _isConnecting = false;
        _connectionStatus = 'Calling...';
      });
      
    } catch (e) {
      setState(() {
        _isConnecting = false;
      });
      _showErrorDialog('Failed to start call: $e');
    }
  }

  Future<void> _endCall() async {
    try {
      await _webrtcService.dispose();
      Navigator.pop(context);
    } catch (e) {
      _showErrorDialog('Failed to end call: $e');
    }
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    _webrtcService.toggleMicrophone();
  }

  void _toggleCamera() {
    setState(() {
      _isCameraOff = !_isCameraOff;
    });
    _webrtcService.toggleCamera();
  }

  Future<void> _switchCamera() async {
    try {
      await _webrtcService.switchCamera();
    } catch (e) {
      _showErrorDialog('Failed to switch camera: $e');
    }
  }

  void _sendChatMessage() async {
    final message = _chatController.text.trim();
    if (message.isEmpty) return;
    
    try {
      // Encrypt message
      final encryptedMessage = _encryptionService.encryptChatMessage(
        message: message,
        senderId: 'farmer_001', // Replace with actual user ID
        receiverId: widget.vet['id'],
      );
      
      // Send via data channel
      final dataChannel = await _webrtcService.createDataChannel('chat');
      if (dataChannel != null) {
        _webrtcService.sendData(dataChannel, encryptedMessage);
      }
      
      // Add to local chat
      setState(() {
        _chatMessages.add({
          'message': message,
          'sender': 'me',
          'timestamp': DateTime.now(),
          'encrypted': true,
        });
      });
      
      _chatController.clear();
    } catch (e) {
      _showErrorDialog('Failed to send message: $e');
    }
  }

  void _handleReceivedData(Map<String, dynamic> data) {
    try {
      if (data['encrypted'] == true) {
        final decryptedMessage = _encryptionService.decryptChatMessage(data);
        
        setState(() {
          _chatMessages.add({
            'message': decryptedMessage['message'],
            'sender': 'vet',
            'timestamp': DateTime.parse(decryptedMessage['timestamp']),
            'encrypted': true,
          });
        });
      }
    } catch (e) {
      debugPrint('Error handling received data: $e');
    }
  }

  Future<void> _shareImageForDiagnosis() async {
    try {
      // In a real app, this would open image picker
      // For now, we'll simulate with a placeholder
      final imageData = Uint8List(0); // Placeholder
      
      // Run AI diagnosis
      final diagnosis = await _aiService.analyzeImage(
        imageData: imageData,
        animalType: 'cattle', // This should come from user selection
        symptoms: 'Swollen udder, abnormal milk',
      );
      
      setState(() {
        _currentDiagnosis = diagnosis;
        _sharedImages.add({
          'imageData': imageData,
          'diagnosis': diagnosis,
          'timestamp': DateTime.now(),
        });
      });
      
      // Share diagnosis with vet via encrypted channel
      final encryptedDiagnosis = _encryptionService.encryptMessage(
        diagnosis.toString()
      );
      
      final dataChannel = await _webrtcService.createDataChannel('diagnosis');
      if (dataChannel != null) {
        _webrtcService.sendData(dataChannel, {
          'type': 'ai_diagnosis',
          'data': encryptedDiagnosis,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
      }
      
    } catch (e) {
      _showErrorDialog('Failed to analyze image: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF2E7D32),
              child: Text(
                widget.vet['name'].toString().split(' ').map((n) => n[0]).take(2).join(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.vet['name'],
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  _connectionStatus,
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showVetInfo(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Video/Audio Call Area
          Expanded(
            flex: 3,
            child: _buildCallArea(),
          ),
          
          // AI Diagnosis Panel
          if (_currentDiagnosis != null)
            Container(
              height: 120,
              padding: const EdgeInsets.all(12),
              color: Colors.purple.withOpacity(0.1),
              child: _buildDiagnosisPanel(),
            ),
          
          // Chat Area
          Expanded(
            flex: 2,
            child: _buildChatArea(),
          ),
          
          // Control Panel
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: _buildControlPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildCallArea() {
    if (widget.consultationType == 'chat') {
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Chat Consultation',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('Secure encrypted messaging'),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        // Remote video (full screen)
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: _isConnected
              ? RTCVideoView(_remoteRenderer, mirror: false)
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        'Connecting to veterinarian...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
        ),
        
        // Local video (picture-in-picture)
        if (widget.consultationType == 'video')
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              width: 120,
              height: 160,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: RTCVideoView(_localRenderer, mirror: true),
              ),
            ),
          ),
        
        // Connection status overlay
        if (_isConnecting)
          Container(
            color: Colors.black.withOpacity(0.7),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Starting consultation...',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDiagnosisPanel() {
    if (_currentDiagnosis == null) return const SizedBox.shrink();

    final diagnosis = _currentDiagnosis!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.psychology, color: Colors.purple, size: 20),
            const SizedBox(width: 8),
            const Text(
              'AI Diagnosis Result',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            if (diagnosis['detected'])
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${diagnosis['disease']['confidence']}% confidence',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (diagnosis['detected'])
          Text(
            'Detected: ${diagnosis['disease']['name']}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          )
        else
          const Text(
            'No diseases detected - Animal appears healthy',
            style: TextStyle(fontSize: 14, color: Colors.green),
          ),
        const SizedBox(height: 4),
        if (diagnosis['detected'])
          Text(
            'Severity: ${diagnosis['disease']['severity']} | Treatment: ${diagnosis['treatment']['primary']}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  Widget _buildChatArea() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        children: [
          // Chat header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.chat, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                const Text(
                  'Secure Chat',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'TLS 1.3',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.camera_alt, size: 20),
                  onPressed: _shareImageForDiagnosis,
                  tooltip: 'Share image for AI diagnosis',
                ),
              ],
            ),
          ),

          // Messages list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) {
                final message = _chatMessages[index];
                return _buildChatMessage(message);
              },
            ),
          ),

          // Message input
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: (_) => _sendChatMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendChatMessage,
                  icon: const Icon(Icons.send),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessage(Map<String, dynamic> message) {
    final isMe = message['sender'] == 'me';
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF2E7D32) : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['message'],
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message['timestamp']),
                  style: TextStyle(
                    fontSize: 10,
                    color: isMe ? Colors.white70 : Colors.grey[600],
                  ),
                ),
                if (message['encrypted'] == true) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.lock,
                    size: 10,
                    color: isMe ? Colors.white70 : Colors.grey[600],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Mute button
        _buildControlButton(
          icon: _isMuted ? Icons.mic_off : Icons.mic,
          label: _isMuted ? 'Unmute' : 'Mute',
          color: _isMuted ? Colors.red : Colors.grey[700]!,
          onPressed: _toggleMute,
        ),

        // Camera button
        if (widget.consultationType == 'video')
          _buildControlButton(
            icon: _isCameraOff ? Icons.videocam_off : Icons.videocam,
            label: _isCameraOff ? 'Camera On' : 'Camera Off',
            color: _isCameraOff ? Colors.red : Colors.grey[700]!,
            onPressed: _toggleCamera,
          ),

        // Switch camera button
        if (widget.consultationType == 'video')
          _buildControlButton(
            icon: Icons.flip_camera_ios,
            label: 'Switch',
            color: Colors.grey[700]!,
            onPressed: _switchCamera,
          ),

        // Start/End call button
        _buildControlButton(
          icon: _isConnected ? Icons.call_end : Icons.call,
          label: _isConnected ? 'End Call' : 'Start Call',
          color: _isConnected ? Colors.red : Colors.green,
          onPressed: _isConnected ? _endCall : _startCall,
          isLarge: true,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    bool isLarge = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isLarge ? 60 : 48,
          height: isLarge ? 60 : 48,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: Colors.white,
              size: isLarge ? 28 : 24,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  void _showVetInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.vet['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Specialty: ${widget.vet['specialty']}'),
            Text('Experience: ${widget.vet['experience']}'),
            Text('Rating: ${widget.vet['rating']} ⭐'),
            const SizedBox(height: 8),
            const Text(
              'Secure Connection:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('• End-to-end encryption (TLS 1.3)'),
            const Text('• WebRTC secure video/audio'),
            const Text('• AI-powered diagnosis sharing'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
