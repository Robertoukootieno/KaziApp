import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class OfflineSyncService {
  static final OfflineSyncService _instance = OfflineSyncService._internal();
  factory OfflineSyncService() => _instance;
  OfflineSyncService._internal();

  final Connectivity _connectivity = Connectivity();
  SharedPreferences? _prefs;
  
  static const String _pendingActionsKey = 'pending_actions';
  static const String _cachedDataKey = 'cached_data';
  static const String _lastSyncKey = 'last_sync';

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    
    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
    
    // Check initial connectivity and sync if online
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      await syncPendingActions();
    }
  }

  void _onConnectivityChanged(ConnectivityResult result) {
    if (result != ConnectivityResult.none) {
      // Device came back online, sync pending actions
      syncPendingActions();
    }
  }

  Future<bool> isOnline() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> queueAction({
    required String action,
    required String endpoint,
    required Map<String, dynamic> data,
    String method = 'POST',
  }) async {
    if (_prefs == null) return;

    final pendingActions = await getPendingActions();
    
    final actionData = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'action': action,
      'endpoint': endpoint,
      'method': method,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    };

    pendingActions.add(actionData);
    
    await _prefs!.setString(_pendingActionsKey, jsonEncode(pendingActions));
    
    // Try to sync immediately if online
    if (await isOnline()) {
      await syncPendingActions();
    }
  }

  Future<List<Map<String, dynamic>>> getPendingActions() async {
    if (_prefs == null) return [];

    final actionsJson = _prefs!.getString(_pendingActionsKey);
    if (actionsJson == null) return [];

    try {
      final actionsList = jsonDecode(actionsJson) as List;
      return actionsList.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error parsing pending actions: $e');
      return [];
    }
  }

  Future<void> syncPendingActions() async {
    if (_prefs == null || !await isOnline()) return;

    final pendingActions = await getPendingActions();
    if (pendingActions.isEmpty) return;

    final successfulActions = <String>[];

    for (final action in pendingActions) {
      try {
        final success = await _executeAction(action);
        if (success) {
          successfulActions.add(action['id']);
        }
      } catch (e) {
        print('Error executing action ${action['id']}: $e');
      }
    }

    // Remove successful actions from pending list
    final remainingActions = pendingActions
        .where((action) => !successfulActions.contains(action['id']))
        .toList();

    await _prefs!.setString(_pendingActionsKey, jsonEncode(remainingActions));
    
    // Update last sync timestamp
    await _prefs!.setString(_lastSyncKey, DateTime.now().toIso8601String());

    print('Synced ${successfulActions.length} actions, ${remainingActions.length} remaining');
  }

  Future<bool> _executeAction(Map<String, dynamic> action) async {
    try {
      final endpoint = action['endpoint'] as String;
      final method = action['method'] as String;
      final data = action['data'] as Map<String, dynamic>;

      final uri = Uri.parse(endpoint);
      final headers = {
        'Content-Type': 'application/json',
        // Add authentication headers if needed
      };

      http.Response response;

      switch (method.toUpperCase()) {
        case 'POST':
          response = await http.post(uri, headers: headers, body: jsonEncode(data));
          break;
        case 'PUT':
          response = await http.put(uri, headers: headers, body: jsonEncode(data));
          break;
        case 'PATCH':
          response = await http.patch(uri, headers: headers, body: jsonEncode(data));
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
          break;
        default:
          response = await http.get(uri, headers: headers);
      }

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      print('Error executing HTTP request: $e');
      return false;
    }
  }

  Future<void> cacheData(String key, Map<String, dynamic> data) async {
    if (_prefs == null) return;

    final cachedData = await getCachedData();
    cachedData[key] = {
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    };

    await _prefs!.setString(_cachedDataKey, jsonEncode(cachedData));
  }

  Future<Map<String, dynamic>?> getCachedData([String? key]) async {
    if (_prefs == null) return null;

    final cachedDataJson = _prefs!.getString(_cachedDataKey);
    if (cachedDataJson == null) return null;

    try {
      final cachedData = jsonDecode(cachedDataJson) as Map<String, dynamic>;
      
      if (key != null) {
        final keyData = cachedData[key];
        return keyData != null ? keyData['data'] : null;
      }
      
      return cachedData;
    } catch (e) {
      print('Error parsing cached data: $e');
      return null;
    }
  }

  Future<void> clearCache([String? key]) async {
    if (_prefs == null) return;

    if (key != null) {
      final cachedData = await getCachedData();
      if (cachedData != null) {
        cachedData.remove(key);
        await _prefs!.setString(_cachedDataKey, jsonEncode(cachedData));
      }
    } else {
      await _prefs!.remove(_cachedDataKey);
    }
  }

  Future<DateTime?> getLastSyncTime() async {
    if (_prefs == null) return null;

    final lastSyncString = _prefs!.getString(_lastSyncKey);
    if (lastSyncString == null) return null;

    try {
      return DateTime.parse(lastSyncString);
    } catch (e) {
      print('Error parsing last sync time: $e');
      return null;
    }
  }

  Future<int> getPendingActionsCount() async {
    final actions = await getPendingActions();
    return actions.length;
  }

  Future<void> clearAllPendingActions() async {
    if (_prefs == null) return;
    await _prefs!.remove(_pendingActionsKey);
  }
}
