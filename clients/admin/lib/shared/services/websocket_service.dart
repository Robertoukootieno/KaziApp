import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import '../../core/constants/app_constants.dart';

/// WebSocket service for real-time communication
class WebSocketService {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  
  final StreamController<Map<String, dynamic>> _messageController = 
      StreamController<Map<String, dynamic>>.broadcast();
  
  final StreamController<WebSocketConnectionState> _connectionController = 
      StreamController<WebSocketConnectionState>.broadcast();
  
  bool _isConnected = false;
  bool _shouldReconnect = true;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 5);
  static const Duration _heartbeatInterval = Duration(seconds: 30);
  
  String? _authToken;
  String? _userId;

  // Streams
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  Stream<WebSocketConnectionState> get connectionStream => _connectionController.stream;
  
  bool get isConnected => _isConnected;

  /// Initialize WebSocket connection
  Future<void> connect({String? authToken, String? userId}) async {
    _authToken = authToken;
    _userId = userId;
    _shouldReconnect = true;
    _reconnectAttempts = 0;
    
    await _connect();
  }

  /// Internal connection method
  Future<void> _connect() async {
    try {
      _connectionController.add(WebSocketConnectionState.connecting);
      
      // Build WebSocket URL with auth parameters
      final uri = Uri.parse(AppConstants.adminWsUrl).replace(
        queryParameters: {
          if (_authToken != null) 'token': _authToken!,
          if (_userId != null) 'userId': _userId!,
          'client': 'admin',
        },
      );

      debugPrint('Connecting to WebSocket: $uri');
      
      _channel = IOWebSocketChannel.connect(uri);
      
      // Listen to messages
      _subscription = _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDisconnected,
      );
      
      _isConnected = true;
      _reconnectAttempts = 0;
      _connectionController.add(WebSocketConnectionState.connected);
      
      // Start heartbeat
      _startHeartbeat();
      
      debugPrint('WebSocket connected successfully');
      
    } catch (e) {
      debugPrint('WebSocket connection error: $e');
      _connectionController.add(WebSocketConnectionState.error);
      _scheduleReconnect();
    }
  }

  /// Handle incoming messages
  void _onMessage(dynamic data) {
    try {
      final Map<String, dynamic> message = jsonDecode(data.toString());
      debugPrint('WebSocket message received: $message');
      
      // Handle system messages
      if (message['type'] == 'pong') {
        // Heartbeat response
        return;
      }
      
      _messageController.add(message);
    } catch (e) {
      debugPrint('Error parsing WebSocket message: $e');
    }
  }

  /// Handle connection errors
  void _onError(error) {
    debugPrint('WebSocket error: $error');
    _isConnected = false;
    _connectionController.add(WebSocketConnectionState.error);
    _scheduleReconnect();
  }

  /// Handle disconnection
  void _onDisconnected() {
    debugPrint('WebSocket disconnected');
    _isConnected = false;
    _connectionController.add(WebSocketConnectionState.disconnected);
    _stopHeartbeat();
    _scheduleReconnect();
  }

  /// Schedule reconnection attempt
  void _scheduleReconnect() {
    if (!_shouldReconnect || _reconnectAttempts >= _maxReconnectAttempts) {
      debugPrint('Max reconnection attempts reached or reconnection disabled');
      return;
    }
    
    _reconnectAttempts++;
    debugPrint('Scheduling reconnection attempt $_reconnectAttempts in ${_reconnectDelay.inSeconds}s');
    
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () {
      if (_shouldReconnect) {
        _connect();
      }
    });
  }

  /// Start heartbeat to keep connection alive
  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (timer) {
      if (_isConnected) {
        sendMessage({'type': 'ping', 'timestamp': DateTime.now().toIso8601String()});
      }
    });
  }

  /// Stop heartbeat timer
  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  /// Send message through WebSocket
  void sendMessage(Map<String, dynamic> message) {
    if (_isConnected && _channel != null) {
      try {
        final jsonMessage = jsonEncode(message);
        _channel!.sink.add(jsonMessage);
        debugPrint('WebSocket message sent: $message');
      } catch (e) {
        debugPrint('Error sending WebSocket message: $e');
      }
    } else {
      debugPrint('Cannot send message: WebSocket not connected');
    }
  }

  /// Subscribe to specific event types
  Stream<Map<String, dynamic>> subscribeToEvent(String eventType) {
    return messageStream.where((message) => message['type'] == eventType);
  }

  /// Subscribe to registration events
  Stream<Map<String, dynamic>> subscribeToRegistrationEvents() {
    return messageStream.where((message) => 
      message['type']?.toString().startsWith('registration_') == true);
  }

  /// Join admin room for receiving admin-specific notifications
  void joinAdminRoom() {
    sendMessage({
      'type': 'join_room',
      'room': 'admin',
      'userId': _userId,
    });
  }

  /// Leave admin room
  void leaveAdminRoom() {
    sendMessage({
      'type': 'leave_room',
      'room': 'admin',
      'userId': _userId,
    });
  }

  /// Disconnect WebSocket
  void disconnect() {
    _shouldReconnect = false;
    _stopHeartbeat();
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _channel?.sink.close();
    _isConnected = false;
    _connectionController.add(WebSocketConnectionState.disconnected);
    debugPrint('WebSocket disconnected manually');
  }

  /// Dispose resources
  void dispose() {
    disconnect();
    _messageController.close();
    _connectionController.close();
  }
}

enum WebSocketConnectionState {
  disconnected,
  connecting,
  connected,
  error,
}

/// WebSocket service provider
final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  final service = WebSocketService();
  
  // Auto-dispose when no longer needed
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});

/// Connection state provider
final webSocketConnectionProvider = StreamProvider<WebSocketConnectionState>((ref) {
  final webSocketService = ref.watch(webSocketServiceProvider);
  return webSocketService.connectionStream;
});

/// Message stream provider
final webSocketMessageProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final webSocketService = ref.watch(webSocketServiceProvider);
  return webSocketService.messageStream;
});

/// Registration events stream provider
final registrationEventsProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final webSocketService = ref.watch(webSocketServiceProvider);
  return webSocketService.subscribeToRegistrationEvents();
});
