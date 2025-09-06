import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'encryption_service.dart';

class SignalingService {
  static final SignalingService _instance = SignalingService._internal();
  factory SignalingService() => _instance;
  SignalingService._internal();

  IO.Socket? _socket;
  final EncryptionService _encryptionService = EncryptionService();
  
  // Callbacks for WebRTC signaling
  Function(Map<String, dynamic>)? onOfferReceived;
  Function(Map<String, dynamic>)? onAnswerReceived;
  Function(Map<String, dynamic>)? onIceCandidateReceived;
  Function(String)? onUserJoined;
  Function(String)? onUserLeft;
  Function(String)? onConnectionStateChanged;
  Function(Map<String, dynamic>)? onChatMessageReceived;

  // Connection state
  bool _isConnected = false;
  String? _currentRoom;
  String? _userId;

  // Initialize signaling service
  Future<void> initialize({
    required String serverUrl,
    required String userId,
  }) async {
    try {
      _userId = userId;
      
      // Initialize encryption service
      await _encryptionService.initialize();
      
      // Configure socket connection
      _socket = IO.io(serverUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'timeout': 20000,
        'forceNew': true,
      });

      // Set up event listeners
      _setupSocketListeners();
      
      // Connect to server
      _socket!.connect();
      
      debugPrint('Signaling service initialized for user: $userId');
    } catch (e) {
      debugPrint('Error initializing signaling service: $e');
      throw Exception('Failed to initialize signaling service: $e');
    }
  }

  // Set up socket event listeners
  void _setupSocketListeners() {
    _socket!.on('connect', (_) {
      debugPrint('Connected to signaling server');
      _isConnected = true;
      onConnectionStateChanged?.call('connected');
    });

    _socket!.on('disconnect', (_) {
      debugPrint('Disconnected from signaling server');
      _isConnected = false;
      onConnectionStateChanged?.call('disconnected');
    });

    _socket!.on('connect_error', (error) {
      debugPrint('Connection error: $error');
      onConnectionStateChanged?.call('error');
    });

    // WebRTC signaling events
    _socket!.on('offer', (data) {
      debugPrint('Received offer');
      _handleEncryptedMessage(data, onOfferReceived);
    });

    _socket!.on('answer', (data) {
      debugPrint('Received answer');
      _handleEncryptedMessage(data, onAnswerReceived);
    });

    _socket!.on('ice-candidate', (data) {
      debugPrint('Received ICE candidate');
      _handleEncryptedMessage(data, onIceCandidateReceived);
    });

    // Room management events
    _socket!.on('user-joined', (data) {
      debugPrint('User joined: ${data['userId']}');
      onUserJoined?.call(data['userId']);
    });

    _socket!.on('user-left', (data) {
      debugPrint('User left: ${data['userId']}');
      onUserLeft?.call(data['userId']);
    });

    // Chat events
    _socket!.on('chat-message', (data) {
      debugPrint('Received chat message');
      _handleEncryptedMessage(data, onChatMessageReceived);
    });

    // Room events
    _socket!.on('room-joined', (data) {
      debugPrint('Joined room: ${data['roomId']}');
      _currentRoom = data['roomId'];
    });

    _socket!.on('room-left', (data) {
      debugPrint('Left room: ${data['roomId']}');
      _currentRoom = null;
    });
  }

  // Handle encrypted messages
  void _handleEncryptedMessage(
    dynamic data, 
    Function(Map<String, dynamic>)? callback
  ) {
    try {
      if (callback == null) return;
      
      final messageData = data as Map<String, dynamic>;
      
      if (messageData['encrypted'] == true) {
        final decryptedMessage = _encryptionService.decryptSignalingMessage(messageData);
        callback(decryptedMessage);
      } else {
        callback(messageData);
      }
    } catch (e) {
      debugPrint('Error handling encrypted message: $e');
    }
  }

  // Join consultation room
  Future<void> joinRoom(String roomId) async {
    if (!_isConnected || _socket == null) {
      throw Exception('Not connected to signaling server');
    }

    try {
      _socket!.emit('join-room', {
        'roomId': roomId,
        'userId': _userId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      
      debugPrint('Joining room: $roomId');
    } catch (e) {
      debugPrint('Error joining room: $e');
      throw Exception('Failed to join room: $e');
    }
  }

  // Leave consultation room
  Future<void> leaveRoom() async {
    if (!_isConnected || _socket == null || _currentRoom == null) {
      return;
    }

    try {
      _socket!.emit('leave-room', {
        'roomId': _currentRoom,
        'userId': _userId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      
      debugPrint('Leaving room: $_currentRoom');
    } catch (e) {
      debugPrint('Error leaving room: $e');
    }
  }

  // Send WebRTC offer
  Future<void> sendOffer(String targetUserId, Map<String, dynamic> offer) async {
    await _sendSignalingMessage('offer', targetUserId, offer);
  }

  // Send WebRTC answer
  Future<void> sendAnswer(String targetUserId, Map<String, dynamic> answer) async {
    await _sendSignalingMessage('answer', targetUserId, answer);
  }

  // Send ICE candidate
  Future<void> sendIceCandidate(String targetUserId, Map<String, dynamic> candidate) async {
    await _sendSignalingMessage('ice-candidate', targetUserId, candidate);
  }

  // Send chat message
  Future<void> sendChatMessage(String targetUserId, String message, {String? imageData}) async {
    final messageData = {
      'message': message,
      'imageData': imageData,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    await _sendSignalingMessage('chat-message', targetUserId, messageData);
  }

  // Send encrypted signaling message
  Future<void> _sendSignalingMessage(
    String type, 
    String targetUserId, 
    Map<String, dynamic> data
  ) async {
    if (!_isConnected || _socket == null) {
      throw Exception('Not connected to signaling server');
    }

    try {
      // Encrypt the message
      final encryptedMessage = _encryptionService.encryptSignalingMessage(data);
      
      // Send to server
      _socket!.emit(type, {
        'targetUserId': targetUserId,
        'senderId': _userId,
        'roomId': _currentRoom,
        'encrypted': true,
        'data': encryptedMessage['data'],
        'hash': encryptedMessage['hash'],
        'timestamp': encryptedMessage['timestamp'],
      });
      
      debugPrint('Sent $type message to $targetUserId');
    } catch (e) {
      debugPrint('Error sending signaling message: $e');
      throw Exception('Failed to send signaling message: $e');
    }
  }

  // Create consultation room
  Future<String> createConsultationRoom(String vetId, String farmerId) async {
    if (!_isConnected || _socket == null) {
      throw Exception('Not connected to signaling server');
    }

    try {
      final roomId = 'consultation_${farmerId}_${vetId}_${DateTime.now().millisecondsSinceEpoch}';
      
      _socket!.emit('create-room', {
        'roomId': roomId,
        'vetId': vetId,
        'farmerId': farmerId,
        'createdBy': _userId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'encrypted': true,
      });
      
      debugPrint('Created consultation room: $roomId');
      return roomId;
    } catch (e) {
      debugPrint('Error creating consultation room: $e');
      throw Exception('Failed to create consultation room: $e');
    }
  }

  // Send AI diagnosis results
  Future<void> sendAIDiagnosis(String targetUserId, Map<String, dynamic> diagnosis) async {
    try {
      final diagnosisData = {
        'type': 'ai-diagnosis',
        'diagnosis': diagnosis,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      await _sendSignalingMessage('ai-diagnosis', targetUserId, diagnosisData);
      debugPrint('Sent AI diagnosis to $targetUserId');
    } catch (e) {
      debugPrint('Error sending AI diagnosis: $e');
      throw Exception('Failed to send AI diagnosis: $e');
    }
  }

  // Send consultation status updates
  Future<void> sendConsultationStatus(String targetUserId, String status) async {
    try {
      final statusData = {
        'type': 'consultation-status',
        'status': status, // 'started', 'ended', 'paused', 'resumed'
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      await _sendSignalingMessage('consultation-status', targetUserId, statusData);
      debugPrint('Sent consultation status: $status to $targetUserId');
    } catch (e) {
      debugPrint('Error sending consultation status: $e');
    }
  }

  // Get connection statistics
  Map<String, dynamic> getConnectionStats() {
    return {
      'isConnected': _isConnected,
      'currentRoom': _currentRoom,
      'userId': _userId,
      'serverConnected': _socket?.connected ?? false,
      'encryptionEnabled': true,
      'tlsVersion': '1.3',
    };
  }

  // Dispose resources
  Future<void> dispose() async {
    try {
      if (_currentRoom != null) {
        await leaveRoom();
      }
      
      _socket?.disconnect();
      _socket?.dispose();
      _socket = null;
      
      _isConnected = false;
      _currentRoom = null;
      
      debugPrint('Signaling service disposed');
    } catch (e) {
      debugPrint('Error disposing signaling service: $e');
    }
  }

  // Getters
  bool get isConnected => _isConnected;
  String? get currentRoom => _currentRoom;
  String? get userId => _userId;
}
