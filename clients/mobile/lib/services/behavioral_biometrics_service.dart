import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Note: sensors_plus package would be added to pubspec.yaml in production

/// Behavioral Biometrics Service for continuous user authentication
class BehavioralBiometricsService {
  static final BehavioralBiometricsService _instance = BehavioralBiometricsService._internal();
  factory BehavioralBiometricsService() => _instance;
  BehavioralBiometricsService._internal();

  // Behavioral data storage
  final List<TouchEvent> _touchEvents = [];
  final List<TypingEvent> _typingEvents = [];
  final List<MotionEvent> _motionEvents = [];
  final List<NavigationEvent> _navigationEvents = [];
  
  // User behavioral profile
  BehavioralProfile? _userProfile;
  bool _isLearning = true;
  int _samplesCollected = 0;
  
  // Configuration
  static const int _minSamplesForProfile = 100;
  static const int _maxStoredEvents = 1000;
  static const double _anomalyThreshold = 0.7;
  static const String _profileKey = 'behavioral_profile';

  /// Initialize behavioral biometrics service
  Future<void> initialize() async {
    try {
      await _loadUserProfile();
      _startMotionSensors();

      debugPrint('🧠 Behavioral Biometrics Service initialized');
      debugPrint('📊 Learning mode: $_isLearning, Samples: $_samplesCollected');
    } catch (e) {
      debugPrint('❌ Failed to initialize Behavioral Biometrics: $e');
    }
  }

  /// Start learning mode for behavioral biometrics
  void startLearning() {
    _isLearning = true;
    _samplesCollected = 0;
    debugPrint('🧠 Started behavioral learning mode');
  }

  /// Record keystroke event for behavioral analysis
  void recordKeystroke({
    required String key,
    required DateTime timestamp,
    required double duration,
  }) {
    final event = TypingEvent(
      key: key,
      timestamp: timestamp,
      type: TypingEventType.keyDown,
      dwellTime: Duration(milliseconds: duration.toInt()),
    );

    _typingEvents.add(event);
    _maintainEventLimit(_typingEvents);

    if (_isLearning) {
      _samplesCollected++;
      _checkLearningCompletion();
    } else {
      _analyzeTyping(event);
    }
  }

  /// Record touch event for behavioral analysis
  void recordTouchEvent({
    required double x,
    required double y,
    required TouchType type,
    required double pressure,
    required double size,
    int? pointerId,
  }) {
    final event = TouchEvent(
      timestamp: DateTime.now(),
      x: x,
      y: y,
      type: type,
      pressure: pressure,
      size: size,
      pointerId: pointerId ?? 0,
    );

    _touchEvents.add(event);
    _maintainEventLimit(_touchEvents);
    
    if (_isLearning) {
      _samplesCollected++;
      _checkLearningCompletion();
    } else {
      _analyzeTouch(event);
    }
  }

  /// Record typing event for keystroke dynamics
  void recordTypingEvent({
    required String key,
    required TypingEventType type,
    required Duration dwellTime,
    Duration? flightTime,
  }) {
    final event = TypingEvent(
      timestamp: DateTime.now(),
      key: key,
      type: type,
      dwellTime: dwellTime,
      flightTime: flightTime,
    );

    _typingEvents.add(event);
    _maintainEventLimit(_typingEvents);
    
    if (_isLearning) {
      _samplesCollected++;
      _checkLearningCompletion();
    } else {
      _analyzeTyping(event);
    }
  }

  /// Record navigation event for usage pattern analysis
  void recordNavigationEvent({
    required String fromScreen,
    required String toScreen,
    required Duration timeSpent,
    required NavigationMethod method,
  }) {
    final event = NavigationEvent(
      timestamp: DateTime.now(),
      fromScreen: fromScreen,
      toScreen: toScreen,
      timeSpent: timeSpent,
      method: method,
    );

    _navigationEvents.add(event);
    _maintainEventLimit(_navigationEvents);
    
    if (_isLearning) {
      _samplesCollected++;
      _checkLearningCompletion();
    } else {
      _analyzeNavigation(event);
    }
  }

  /// Start motion sensors for gait and movement analysis
  void _startMotionSensors() {
    // Note: In production, this would use sensors_plus package
    // For now, we'll simulate motion events for demonstration
    debugPrint('🏃 Motion sensors initialized (simulated)');

    // Simulate periodic motion events
    // In production, this would be:
    // accelerometerEvents.listen((AccelerometerEvent event) { ... });
    // gyroscopeEvents.listen((GyroscopeEvent event) { ... });
  }

  /// Analyze touch patterns for anomalies
  void _analyzeTouch(TouchEvent event) {
    if (_userProfile == null) return;

    final touchProfile = _userProfile!.touchProfile;
    double anomalyScore = 0.0;

    // Analyze pressure patterns
    final pressureDiff = (event.pressure - touchProfile.averagePressure).abs();
    anomalyScore += pressureDiff / touchProfile.pressureStdDev;

    // Analyze touch size patterns
    final sizeDiff = (event.size - touchProfile.averageSize).abs();
    anomalyScore += sizeDiff / touchProfile.sizeStdDev;

    // Analyze touch velocity (if previous touch exists)
    if (_touchEvents.length > 1) {
      final previousTouch = _touchEvents[_touchEvents.length - 2];
      final velocity = _calculateTouchVelocity(previousTouch, event);
      final velocityDiff = (velocity - touchProfile.averageVelocity).abs();
      anomalyScore += velocityDiff / touchProfile.velocityStdDev;
    }

    // Normalize anomaly score
    anomalyScore = anomalyScore / 3.0;

    if (anomalyScore > _anomalyThreshold) {
      _recordAnomaly(AnomalyType.touch, anomalyScore, {
        'pressure': event.pressure,
        'size': event.size,
        'x': event.x,
        'y': event.y,
      });
    }
  }

  /// Analyze typing patterns for keystroke dynamics
  void _analyzeTyping(TypingEvent event) {
    if (_userProfile == null) return;

    final typingProfile = _userProfile!.typingProfile;
    double anomalyScore = 0.0;

    // Analyze dwell time patterns
    final keyProfile = typingProfile.keyProfiles[event.key];
    if (keyProfile != null) {
      final dwellDiff = (event.dwellTime.inMilliseconds - keyProfile.averageDwellTime).abs();
      anomalyScore += dwellDiff / keyProfile.dwellTimeStdDev;

      // Analyze flight time patterns (if available)
      if (event.flightTime != null && keyProfile.averageFlightTime > 0) {
        final flightDiff = (event.flightTime!.inMilliseconds - keyProfile.averageFlightTime).abs();
        anomalyScore += flightDiff / keyProfile.flightTimeStdDev;
        anomalyScore = anomalyScore / 2.0;
      }
    }

    if (anomalyScore > _anomalyThreshold) {
      _recordAnomaly(AnomalyType.typing, anomalyScore, {
        'key': event.key,
        'dwellTime': event.dwellTime.inMilliseconds,
        'flightTime': event.flightTime?.inMilliseconds,
      });
    }
  }

  /// Analyze navigation patterns
  void _analyzeNavigation(NavigationEvent event) {
    if (_userProfile == null) return;

    final navProfile = _userProfile!.navigationProfile;
    double anomalyScore = 0.0;

    // Analyze time spent on screens
    final screenProfile = navProfile.screenProfiles[event.fromScreen];
    if (screenProfile != null) {
      final timeDiff = (event.timeSpent.inSeconds - screenProfile.averageTimeSpent).abs();
      anomalyScore += timeDiff / screenProfile.timeSpentStdDev;
    }

    // Analyze navigation patterns
    final transitionKey = '${event.fromScreen}->${event.toScreen}';
    final transitionFreq = navProfile.transitionFrequencies[transitionKey] ?? 0;
    if (transitionFreq < navProfile.averageTransitionFrequency * 0.1) {
      anomalyScore += 1.0; // Unusual navigation pattern
    }

    if (anomalyScore > _anomalyThreshold) {
      _recordAnomaly(AnomalyType.navigation, anomalyScore, {
        'fromScreen': event.fromScreen,
        'toScreen': event.toScreen,
        'timeSpent': event.timeSpent.inSeconds,
        'method': event.method.toString(),
      });
    }
  }

  /// Analyze motion patterns for gait analysis
  void _analyzeMotion(MotionEvent event) {
    if (_userProfile == null) return;

    final motionProfile = _userProfile!.motionProfile;
    double anomalyScore = 0.0;

    if (event.type == MotionType.accelerometer) {
      // Analyze acceleration patterns
      final magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      final magnitudeDiff = (magnitude - motionProfile.averageAcceleration).abs();
      anomalyScore += magnitudeDiff / motionProfile.accelerationStdDev;

      // Analyze gait frequency (simplified)
      if (_motionEvents.length > 10) {
        final recentEvents = _motionEvents.sublist(_motionEvents.length - 10);
        final frequency = _calculateMotionFrequency(recentEvents);
        final frequencyDiff = (frequency - motionProfile.averageGaitFrequency).abs();
        anomalyScore += frequencyDiff / motionProfile.gaitFrequencyStdDev;
      }

      anomalyScore = anomalyScore / 2.0;
    }

    if (anomalyScore > _anomalyThreshold) {
      _recordAnomaly(AnomalyType.motion, anomalyScore, {
        'type': event.type.toString(),
        'x': event.x,
        'y': event.y,
        'z': event.z,
      });
    }
  }

  /// Build user behavioral profile from collected data
  Future<void> _buildUserProfile() async {
    if (_samplesCollected < _minSamplesForProfile) return;

    try {
      final touchProfile = _buildTouchProfile();
      final typingProfile = _buildTypingProfile();
      final navigationProfile = _buildNavigationProfile();
      final motionProfile = _buildMotionProfile();

      _userProfile = BehavioralProfile(
        touchProfile: touchProfile,
        typingProfile: typingProfile,
        navigationProfile: navigationProfile,
        motionProfile: motionProfile,
        createdAt: DateTime.now(),
        samplesUsed: _samplesCollected,
      );

      await _saveUserProfile();
      _isLearning = false;

      debugPrint('✅ Behavioral profile created with $_samplesCollected samples');
    } catch (e) {
      debugPrint('❌ Failed to build behavioral profile: $e');
    }
  }

  /// Build touch behavior profile
  TouchProfile _buildTouchProfile() {
    final pressures = _touchEvents.map((e) => e.pressure).toList();
    final sizes = _touchEvents.map((e) => e.size).toList();
    final velocities = <double>[];

    for (int i = 1; i < _touchEvents.length; i++) {
      final velocity = _calculateTouchVelocity(_touchEvents[i - 1], _touchEvents[i]);
      velocities.add(velocity);
    }

    return TouchProfile(
      averagePressure: _calculateMean(pressures),
      pressureStdDev: _calculateStdDev(pressures),
      averageSize: _calculateMean(sizes),
      sizeStdDev: _calculateStdDev(sizes),
      averageVelocity: _calculateMean(velocities),
      velocityStdDev: _calculateStdDev(velocities),
    );
  }

  /// Build typing behavior profile
  TypingProfile _buildTypingProfile() {
    final keyProfiles = <String, KeyProfile>{};

    for (final key in _typingEvents.map((e) => e.key).toSet()) {
      final keyEvents = _typingEvents.where((e) => e.key == key).toList();
      final dwellTimes = keyEvents.map((e) => e.dwellTime.inMilliseconds.toDouble()).toList();
      final flightTimes = keyEvents
          .where((e) => e.flightTime != null)
          .map((e) => e.flightTime!.inMilliseconds.toDouble())
          .toList();

      keyProfiles[key] = KeyProfile(
        averageDwellTime: _calculateMean(dwellTimes),
        dwellTimeStdDev: _calculateStdDev(dwellTimes),
        averageFlightTime: flightTimes.isNotEmpty ? _calculateMean(flightTimes) : 0,
        flightTimeStdDev: flightTimes.isNotEmpty ? _calculateStdDev(flightTimes) : 0,
      );
    }

    return TypingProfile(keyProfiles: keyProfiles);
  }

  /// Build navigation behavior profile
  NavigationProfile _buildNavigationProfile() {
    final screenProfiles = <String, ScreenProfile>{};
    final transitionFrequencies = <String, int>{};

    // Build screen profiles
    for (final screen in _navigationEvents.map((e) => e.fromScreen).toSet()) {
      final screenEvents = _navigationEvents.where((e) => e.fromScreen == screen).toList();
      final timesSpent = screenEvents.map((e) => e.timeSpent.inSeconds.toDouble()).toList();

      screenProfiles[screen] = ScreenProfile(
        averageTimeSpent: _calculateMean(timesSpent),
        timeSpentStdDev: _calculateStdDev(timesSpent),
      );
    }

    // Build transition frequencies
    for (final event in _navigationEvents) {
      final transitionKey = '${event.fromScreen}->${event.toScreen}';
      transitionFrequencies[transitionKey] = (transitionFrequencies[transitionKey] ?? 0) + 1;
    }

    final averageTransitionFreq = transitionFrequencies.values.isNotEmpty
        ? transitionFrequencies.values.reduce((a, b) => a + b) / transitionFrequencies.length
        : 0.0;

    return NavigationProfile(
      screenProfiles: screenProfiles,
      transitionFrequencies: transitionFrequencies,
      averageTransitionFrequency: averageTransitionFreq,
    );
  }

  /// Build motion behavior profile
  MotionProfile _buildMotionProfile() {
    final accelerometerEvents = _motionEvents.where((e) => e.type == MotionType.accelerometer).toList();
    final accelerations = accelerometerEvents.map((e) {
      return sqrt(e.x * e.x + e.y * e.y + e.z * e.z);
    }).toList();

    final gaitFrequencies = <double>[];
    for (int i = 0; i < accelerometerEvents.length - 10; i += 10) {
      final segment = accelerometerEvents.sublist(i, i + 10);
      gaitFrequencies.add(_calculateMotionFrequency(segment));
    }

    return MotionProfile(
      averageAcceleration: _calculateMean(accelerations),
      accelerationStdDev: _calculateStdDev(accelerations),
      averageGaitFrequency: _calculateMean(gaitFrequencies),
      gaitFrequencyStdDev: _calculateStdDev(gaitFrequencies),
    );
  }

  /// Utility methods
  double _calculateTouchVelocity(TouchEvent from, TouchEvent to) {
    final distance = sqrt(pow(to.x - from.x, 2) + pow(to.y - from.y, 2));
    final timeDiff = to.timestamp.difference(from.timestamp).inMilliseconds;
    return timeDiff > 0 ? distance / timeDiff : 0.0;
  }

  double _calculateMotionFrequency(List<MotionEvent> events) {
    if (events.length < 2) return 0.0;
    
    final timeSpan = events.last.timestamp.difference(events.first.timestamp).inMilliseconds;
    return timeSpan > 0 ? events.length / (timeSpan / 1000.0) : 0.0;
  }

  double _calculateMean(List<double> values) {
    if (values.isEmpty) return 0.0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  double _calculateStdDev(List<double> values) {
    if (values.length < 2) return 1.0;
    
    final mean = _calculateMean(values);
    final variance = values.map((v) => pow(v - mean, 2)).reduce((a, b) => a + b) / values.length;
    return sqrt(variance);
  }

  void _maintainEventLimit<T>(List<T> events) {
    while (events.length > _maxStoredEvents) {
      events.removeAt(0);
    }
  }

  void _checkLearningCompletion() {
    if (_samplesCollected >= _minSamplesForProfile && _isLearning) {
      _buildUserProfile();
    }
  }

  void _recordAnomaly(AnomalyType type, double score, Map<String, dynamic> data) {
    debugPrint('🚨 Behavioral anomaly detected: $type (score: ${score.toStringAsFixed(2)})');
    
    // In production, this would trigger security alerts
    // For now, just log the anomaly
  }

  /// Save/Load user profile
  Future<void> _saveUserProfile() async {
    if (_userProfile == null) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = jsonEncode(_userProfile!.toJson());
      await prefs.setString(_profileKey, profileJson);
    } catch (e) {
      debugPrint('❌ Failed to save behavioral profile: $e');
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(_profileKey);
      
      if (profileJson != null) {
        final profileData = jsonDecode(profileJson);
        _userProfile = BehavioralProfile.fromJson(profileData);
        _isLearning = false;
        _samplesCollected = _userProfile!.samplesUsed;
        
        debugPrint('✅ Behavioral profile loaded');
      }
    } catch (e) {
      debugPrint('❌ Failed to load behavioral profile: $e');
    }
  }

  /// Public getters
  bool get isLearning => _isLearning;
  int get samplesCollected => _samplesCollected;
  BehavioralProfile? get userProfile => _userProfile;
  double get profileCompleteness => (_samplesCollected / _minSamplesForProfile).clamp(0.0, 1.0);
}

// Supporting classes and enums
class TouchEvent {
  final DateTime timestamp;
  final double x, y;
  final TouchType type;
  final double pressure;
  final double size;
  final int pointerId;

  TouchEvent({
    required this.timestamp,
    required this.x,
    required this.y,
    required this.type,
    required this.pressure,
    required this.size,
    required this.pointerId,
  });
}

class TypingEvent {
  final DateTime timestamp;
  final String key;
  final TypingEventType type;
  final Duration dwellTime;
  final Duration? flightTime;

  TypingEvent({
    required this.timestamp,
    required this.key,
    required this.type,
    required this.dwellTime,
    this.flightTime,
  });
}

class NavigationEvent {
  final DateTime timestamp;
  final String fromScreen;
  final String toScreen;
  final Duration timeSpent;
  final NavigationMethod method;

  NavigationEvent({
    required this.timestamp,
    required this.fromScreen,
    required this.toScreen,
    required this.timeSpent,
    required this.method,
  });
}

class MotionEvent {
  final DateTime timestamp;
  final MotionType type;
  final double x, y, z;

  MotionEvent({
    required this.timestamp,
    required this.type,
    required this.x,
    required this.y,
    required this.z,
  });
}

class BehavioralProfile {
  final TouchProfile touchProfile;
  final TypingProfile typingProfile;
  final NavigationProfile navigationProfile;
  final MotionProfile motionProfile;
  final DateTime createdAt;
  final int samplesUsed;

  BehavioralProfile({
    required this.touchProfile,
    required this.typingProfile,
    required this.navigationProfile,
    required this.motionProfile,
    required this.createdAt,
    required this.samplesUsed,
  });

  Map<String, dynamic> toJson() => {
    'touchProfile': touchProfile.toJson(),
    'typingProfile': typingProfile.toJson(),
    'navigationProfile': navigationProfile.toJson(),
    'motionProfile': motionProfile.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'samplesUsed': samplesUsed,
  };

  factory BehavioralProfile.fromJson(Map<String, dynamic> json) => BehavioralProfile(
    touchProfile: TouchProfile.fromJson(json['touchProfile']),
    typingProfile: TypingProfile.fromJson(json['typingProfile']),
    navigationProfile: NavigationProfile.fromJson(json['navigationProfile']),
    motionProfile: MotionProfile.fromJson(json['motionProfile']),
    createdAt: DateTime.parse(json['createdAt']),
    samplesUsed: json['samplesUsed'],
  );
}

class TouchProfile {
  final double averagePressure, pressureStdDev;
  final double averageSize, sizeStdDev;
  final double averageVelocity, velocityStdDev;

  TouchProfile({
    required this.averagePressure,
    required this.pressureStdDev,
    required this.averageSize,
    required this.sizeStdDev,
    required this.averageVelocity,
    required this.velocityStdDev,
  });

  Map<String, dynamic> toJson() => {
    'averagePressure': averagePressure,
    'pressureStdDev': pressureStdDev,
    'averageSize': averageSize,
    'sizeStdDev': sizeStdDev,
    'averageVelocity': averageVelocity,
    'velocityStdDev': velocityStdDev,
  };

  factory TouchProfile.fromJson(Map<String, dynamic> json) => TouchProfile(
    averagePressure: json['averagePressure'],
    pressureStdDev: json['pressureStdDev'],
    averageSize: json['averageSize'],
    sizeStdDev: json['sizeStdDev'],
    averageVelocity: json['averageVelocity'],
    velocityStdDev: json['velocityStdDev'],
  );
}

class TypingProfile {
  final Map<String, KeyProfile> keyProfiles;

  TypingProfile({required this.keyProfiles});

  Map<String, dynamic> toJson() => {
    'keyProfiles': keyProfiles.map((k, v) => MapEntry(k, v.toJson())),
  };

  factory TypingProfile.fromJson(Map<String, dynamic> json) => TypingProfile(
    keyProfiles: (json['keyProfiles'] as Map<String, dynamic>)
        .map((k, v) => MapEntry(k, KeyProfile.fromJson(v))),
  );
}

class KeyProfile {
  final double averageDwellTime, dwellTimeStdDev;
  final double averageFlightTime, flightTimeStdDev;

  KeyProfile({
    required this.averageDwellTime,
    required this.dwellTimeStdDev,
    required this.averageFlightTime,
    required this.flightTimeStdDev,
  });

  Map<String, dynamic> toJson() => {
    'averageDwellTime': averageDwellTime,
    'dwellTimeStdDev': dwellTimeStdDev,
    'averageFlightTime': averageFlightTime,
    'flightTimeStdDev': flightTimeStdDev,
  };

  factory KeyProfile.fromJson(Map<String, dynamic> json) => KeyProfile(
    averageDwellTime: json['averageDwellTime'],
    dwellTimeStdDev: json['dwellTimeStdDev'],
    averageFlightTime: json['averageFlightTime'],
    flightTimeStdDev: json['flightTimeStdDev'],
  );
}

class NavigationProfile {
  final Map<String, ScreenProfile> screenProfiles;
  final Map<String, int> transitionFrequencies;
  final double averageTransitionFrequency;

  NavigationProfile({
    required this.screenProfiles,
    required this.transitionFrequencies,
    required this.averageTransitionFrequency,
  });

  Map<String, dynamic> toJson() => {
    'screenProfiles': screenProfiles.map((k, v) => MapEntry(k, v.toJson())),
    'transitionFrequencies': transitionFrequencies,
    'averageTransitionFrequency': averageTransitionFrequency,
  };

  factory NavigationProfile.fromJson(Map<String, dynamic> json) => NavigationProfile(
    screenProfiles: (json['screenProfiles'] as Map<String, dynamic>)
        .map((k, v) => MapEntry(k, ScreenProfile.fromJson(v))),
    transitionFrequencies: Map<String, int>.from(json['transitionFrequencies']),
    averageTransitionFrequency: json['averageTransitionFrequency'],
  );
}

class ScreenProfile {
  final double averageTimeSpent, timeSpentStdDev;

  ScreenProfile({
    required this.averageTimeSpent,
    required this.timeSpentStdDev,
  });

  Map<String, dynamic> toJson() => {
    'averageTimeSpent': averageTimeSpent,
    'timeSpentStdDev': timeSpentStdDev,
  };

  factory ScreenProfile.fromJson(Map<String, dynamic> json) => ScreenProfile(
    averageTimeSpent: json['averageTimeSpent'],
    timeSpentStdDev: json['timeSpentStdDev'],
  );
}

class MotionProfile {
  final double averageAcceleration, accelerationStdDev;
  final double averageGaitFrequency, gaitFrequencyStdDev;

  MotionProfile({
    required this.averageAcceleration,
    required this.accelerationStdDev,
    required this.averageGaitFrequency,
    required this.gaitFrequencyStdDev,
  });

  Map<String, dynamic> toJson() => {
    'averageAcceleration': averageAcceleration,
    'accelerationStdDev': accelerationStdDev,
    'averageGaitFrequency': averageGaitFrequency,
    'gaitFrequencyStdDev': gaitFrequencyStdDev,
  };

  factory MotionProfile.fromJson(Map<String, dynamic> json) => MotionProfile(
    averageAcceleration: json['averageAcceleration'],
    accelerationStdDev: json['accelerationStdDev'],
    averageGaitFrequency: json['averageGaitFrequency'],
    gaitFrequencyStdDev: json['gaitFrequencyStdDev'],
  );
}

enum TouchType { down, move, up, cancel }
enum TypingEventType { keyDown, keyUp }
enum NavigationMethod { tap, swipe, backButton, deepLink }
enum MotionType { accelerometer, gyroscope, magnetometer }
enum AnomalyType { touch, typing, navigation, motion }
