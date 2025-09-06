class AppNotification {
  final String id;
  final String providerId;
  final String title;
  final String message;
  final NotificationType type;
  final NotificationPriority priority;
  final bool isRead;
  final Map<String, dynamic> data;
  final String? actionUrl;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime? readAt;
  final DateTime? expiresAt;

  AppNotification({
    required this.id,
    required this.providerId,
    required this.title,
    required this.message,
    required this.type,
    required this.priority,
    this.isRead = false,
    required this.data,
    this.actionUrl,
    this.imageUrl,
    required this.createdAt,
    this.readAt,
    this.expiresAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      providerId: json['providerId'],
      title: json['title'],
      message: json['message'],
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      priority: NotificationPriority.values.firstWhere(
        (e) => e.toString().split('.').last == json['priority'],
      ),
      isRead: json['isRead'] ?? false,
      data: Map<String, dynamic>.from(json['data'] ?? {}),
      actionUrl: json['actionUrl'],
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'providerId': providerId,
      'title': title,
      'message': message,
      'type': type.toString().split('.').last,
      'priority': priority.toString().split('.').last,
      'isRead': isRead,
      'data': data,
      'actionUrl': actionUrl,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  AppNotification copyWith({
    String? id,
    String? providerId,
    String? title,
    String? message,
    NotificationType? type,
    NotificationPriority? priority,
    bool? isRead,
    Map<String, dynamic>? data,
    String? actionUrl,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? readAt,
    DateTime? expiresAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
      actionUrl: actionUrl ?? this.actionUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  Duration get timeAgo {
    return DateTime.now().difference(createdAt);
  }

  String get timeAgoText {
    final duration = timeAgo;
    if (duration.inDays > 0) {
      return '${duration.inDays}d ago';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ago';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

enum NotificationType {
  booking,
  payment,
  review,
  system,
  promotion,
  reminder,
  alert,
  message,
  update,
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.booking:
        return 'Booking';
      case NotificationType.payment:
        return 'Payment';
      case NotificationType.review:
        return 'Review';
      case NotificationType.system:
        return 'System';
      case NotificationType.promotion:
        return 'Promotion';
      case NotificationType.reminder:
        return 'Reminder';
      case NotificationType.alert:
        return 'Alert';
      case NotificationType.message:
        return 'Message';
      case NotificationType.update:
        return 'Update';
    }
  }

  String get icon {
    switch (this) {
      case NotificationType.booking:
        return '📅';
      case NotificationType.payment:
        return '💰';
      case NotificationType.review:
        return '⭐';
      case NotificationType.system:
        return '⚙️';
      case NotificationType.promotion:
        return '🎉';
      case NotificationType.reminder:
        return '⏰';
      case NotificationType.alert:
        return '⚠️';
      case NotificationType.message:
        return '💬';
      case NotificationType.update:
        return '🔄';
    }
  }

  String get color {
    switch (this) {
      case NotificationType.booking:
        return 'blue';
      case NotificationType.payment:
        return 'green';
      case NotificationType.review:
        return 'orange';
      case NotificationType.system:
        return 'grey';
      case NotificationType.promotion:
        return 'purple';
      case NotificationType.reminder:
        return 'amber';
      case NotificationType.alert:
        return 'red';
      case NotificationType.message:
        return 'teal';
      case NotificationType.update:
        return 'indigo';
    }
  }
}

enum NotificationPriority {
  low,
  normal,
  high,
  urgent,
}

extension NotificationPriorityExtension on NotificationPriority {
  String get displayName {
    switch (this) {
      case NotificationPriority.low:
        return 'Low';
      case NotificationPriority.normal:
        return 'Normal';
      case NotificationPriority.high:
        return 'High';
      case NotificationPriority.urgent:
        return 'Urgent';
    }
  }

  String get color {
    switch (this) {
      case NotificationPriority.low:
        return 'grey';
      case NotificationPriority.normal:
        return 'blue';
      case NotificationPriority.high:
        return 'orange';
      case NotificationPriority.urgent:
        return 'red';
    }
  }

  int get sortOrder {
    switch (this) {
      case NotificationPriority.urgent:
        return 4;
      case NotificationPriority.high:
        return 3;
      case NotificationPriority.normal:
        return 2;
      case NotificationPriority.low:
        return 1;
    }
  }
}

class NotificationSettings {
  final String providerId;
  final bool enablePushNotifications;
  final bool enableEmailNotifications;
  final bool enableSmsNotifications;
  final Map<NotificationType, bool> typeSettings;
  final Map<NotificationPriority, bool> prioritySettings;
  final String? quietHoursStart;
  final String? quietHoursEnd;
  final List<String> mutedDays;
  final DateTime updatedAt;

  NotificationSettings({
    required this.providerId,
    this.enablePushNotifications = true,
    this.enableEmailNotifications = true,
    this.enableSmsNotifications = false,
    required this.typeSettings,
    required this.prioritySettings,
    this.quietHoursStart,
    this.quietHoursEnd,
    required this.mutedDays,
    required this.updatedAt,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    Map<NotificationType, bool> typeSettings = {};
    if (json['typeSettings'] != null) {
      (json['typeSettings'] as Map<String, dynamic>).forEach((key, value) {
        final type = NotificationType.values.firstWhere(
          (e) => e.toString().split('.').last == key,
        );
        typeSettings[type] = value;
      });
    }

    Map<NotificationPriority, bool> prioritySettings = {};
    if (json['prioritySettings'] != null) {
      (json['prioritySettings'] as Map<String, dynamic>).forEach((key, value) {
        final priority = NotificationPriority.values.firstWhere(
          (e) => e.toString().split('.').last == key,
        );
        prioritySettings[priority] = value;
      });
    }

    return NotificationSettings(
      providerId: json['providerId'],
      enablePushNotifications: json['enablePushNotifications'] ?? true,
      enableEmailNotifications: json['enableEmailNotifications'] ?? true,
      enableSmsNotifications: json['enableSmsNotifications'] ?? false,
      typeSettings: typeSettings,
      prioritySettings: prioritySettings,
      quietHoursStart: json['quietHoursStart'],
      quietHoursEnd: json['quietHoursEnd'],
      mutedDays: List<String>.from(json['mutedDays'] ?? []),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, bool> typeSettingsJson = {};
    typeSettings.forEach((type, enabled) {
      typeSettingsJson[type.toString().split('.').last] = enabled;
    });

    Map<String, bool> prioritySettingsJson = {};
    prioritySettings.forEach((priority, enabled) {
      prioritySettingsJson[priority.toString().split('.').last] = enabled;
    });

    return {
      'providerId': providerId,
      'enablePushNotifications': enablePushNotifications,
      'enableEmailNotifications': enableEmailNotifications,
      'enableSmsNotifications': enableSmsNotifications,
      'typeSettings': typeSettingsJson,
      'prioritySettings': prioritySettingsJson,
      'quietHoursStart': quietHoursStart,
      'quietHoursEnd': quietHoursEnd,
      'mutedDays': mutedDays,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  bool shouldReceiveNotification(AppNotification notification) {
    // Check if notifications are enabled
    if (!enablePushNotifications) return false;

    // Check type settings
    if (typeSettings.containsKey(notification.type) && 
        !typeSettings[notification.type]!) {
      return false;
    }

    // Check priority settings
    if (prioritySettings.containsKey(notification.priority) && 
        !prioritySettings[notification.priority]!) {
      return false;
    }

    // Check quiet hours
    if (quietHoursStart != null && quietHoursEnd != null) {
      final now = DateTime.now();
      final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      
      if (currentTime.compareTo(quietHoursStart!) >= 0 && 
          currentTime.compareTo(quietHoursEnd!) <= 0) {
        // Only allow urgent notifications during quiet hours
        return notification.priority == NotificationPriority.urgent;
      }
    }

    // Check muted days
    final dayName = _getDayName(DateTime.now().weekday);
    if (mutedDays.contains(dayName)) {
      return notification.priority == NotificationPriority.urgent;
    }

    return true;
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return 'Unknown';
    }
  }
}
