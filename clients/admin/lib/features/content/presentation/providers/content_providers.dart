import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/services/content_service.dart';

/// Content search filters
class ContentSearchFilters {
  final String? search;
  final String? type;
  final String? status;
  final String? targetAudience;
  final DateTime? createdAfter;
  final DateTime? createdBefore;
  final String? sortBy;
  final String? sortOrder;

  const ContentSearchFilters({
    this.search,
    this.type,
    this.status,
    this.targetAudience,
    this.createdAfter,
    this.createdBefore,
    this.sortBy,
    this.sortOrder,
  });

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};
    
    if (search != null && search!.isNotEmpty) params['search'] = search;
    if (type != null) params['type'] = type;
    if (status != null) params['status'] = status;
    if (targetAudience != null) params['target_audience'] = targetAudience;
    if (createdAfter != null) params['created_after'] = createdAfter!.toIso8601String();
    if (createdBefore != null) params['created_before'] = createdBefore!.toIso8601String();
    if (sortBy != null) params['sort_by'] = sortBy;
    if (sortOrder != null) params['sort_order'] = sortOrder;
    
    return params;
  }
}

/// App notification model
class AppNotification {
  final String id;
  final String title;
  final String message;
  final String type;
  final String targetAudience;
  final String status;
  final int sentCount;
  final int totalRecipients;
  final double openRate;
  final double clickRate;
  final DateTime createdAt;
  final DateTime? scheduledAt;
  final DateTime? sentAt;
  final Map<String, dynamic>? metadata;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.targetAudience,
    required this.status,
    required this.sentCount,
    required this.totalRecipients,
    required this.openRate,
    required this.clickRate,
    required this.createdAt,
    this.scheduledAt,
    this.sentAt,
    this.metadata,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      targetAudience: json['target_audience'] as String,
      status: json['status'] as String,
      sentCount: json['sent_count'] as int,
      totalRecipients: json['total_recipients'] as int,
      openRate: (json['open_rate'] as num).toDouble(),
      clickRate: (json['click_rate'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      scheduledAt: json['scheduled_at'] != null 
          ? DateTime.parse(json['scheduled_at'] as String)
          : null,
      sentAt: json['sent_at'] != null 
          ? DateTime.parse(json['sent_at'] as String)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}

/// Announcement model
class Announcement {
  final String id;
  final String title;
  final String content;
  final String type;
  final String priority;
  final String status;
  final String targetAudience;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isSticky;
  final int viewCount;
  final DateTime createdAt;
  final String createdBy;

  const Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.priority,
    required this.status,
    required this.targetAudience,
    required this.startDate,
    this.endDate,
    required this.isSticky,
    required this.viewCount,
    required this.createdAt,
    required this.createdBy,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      type: json['type'] as String,
      priority: json['priority'] as String,
      status: json['status'] as String,
      targetAudience: json['target_audience'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] != null 
          ? DateTime.parse(json['end_date'] as String)
          : null,
      isSticky: json['is_sticky'] as bool,
      viewCount: json['view_count'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      createdBy: json['created_by'] as String,
    );
  }
}

/// Educational content model
class EducationalContent {
  final String id;
  final String title;
  final String description;
  final String content;
  final String contentType;
  final String category;
  final List<String> tags;
  final String difficulty;
  final int estimatedReadTime;
  final String status;
  final int viewCount;
  final double rating;
  final DateTime createdAt;
  final DateTime? publishedAt;
  final String createdBy;

  const EducationalContent({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.contentType,
    required this.category,
    required this.tags,
    required this.difficulty,
    required this.estimatedReadTime,
    required this.status,
    required this.viewCount,
    required this.rating,
    required this.createdAt,
    this.publishedAt,
    required this.createdBy,
  });

  factory EducationalContent.fromJson(Map<String, dynamic> json) {
    return EducationalContent(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      content: json['content'] as String,
      contentType: json['content_type'] as String,
      category: json['category'] as String,
      tags: List<String>.from(json['tags'] as List),
      difficulty: json['difficulty'] as String,
      estimatedReadTime: json['estimated_read_time'] as int,
      status: json['status'] as String,
      viewCount: json['view_count'] as int,
      rating: (json['rating'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      publishedAt: json['published_at'] != null 
          ? DateTime.parse(json['published_at'] as String)
          : null,
      createdBy: json['created_by'] as String,
    );
  }
}

/// Policy update model
class PolicyUpdate {
  final String id;
  final String title;
  final String description;
  final String content;
  final String version;
  final String status;
  final DateTime effectiveDate;
  final bool requiresAcknowledgment;
  final int acknowledgmentCount;
  final int totalUsers;
  final DateTime createdAt;
  final String createdBy;

  const PolicyUpdate({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.version,
    required this.status,
    required this.effectiveDate,
    required this.requiresAcknowledgment,
    required this.acknowledgmentCount,
    required this.totalUsers,
    required this.createdAt,
    required this.createdBy,
  });

  factory PolicyUpdate.fromJson(Map<String, dynamic> json) {
    return PolicyUpdate(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      content: json['content'] as String,
      version: json['version'] as String,
      status: json['status'] as String,
      effectiveDate: DateTime.parse(json['effective_date'] as String),
      requiresAcknowledgment: json['requires_acknowledgment'] as bool,
      acknowledgmentCount: json['acknowledgment_count'] as int,
      totalUsers: json['total_users'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      createdBy: json['created_by'] as String,
    );
  }
}

/// Communication channel model
class CommunicationChannel {
  final String id;
  final String name;
  final String type;
  final bool isActive;
  final Map<String, dynamic> configuration;
  final int messagesSent;
  final double deliveryRate;
  final double engagementRate;
  final DateTime createdAt;

  const CommunicationChannel({
    required this.id,
    required this.name,
    required this.type,
    required this.isActive,
    required this.configuration,
    required this.messagesSent,
    required this.deliveryRate,
    required this.engagementRate,
    required this.createdAt,
  });

  factory CommunicationChannel.fromJson(Map<String, dynamic> json) {
    return CommunicationChannel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      isActive: json['is_active'] as bool,
      configuration: json['configuration'] as Map<String, dynamic>,
      messagesSent: json['messages_sent'] as int,
      deliveryRate: (json['delivery_rate'] as num).toDouble(),
      engagementRate: (json['engagement_rate'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

/// Content statistics model
class ContentStatistics {
  final int totalNotifications;
  final int totalAnnouncements;
  final int totalEducationalContent;
  final int totalPolicyUpdates;
  final int activeChannels;
  final double averageEngagementRate;
  final Map<String, int> contentByType;
  final Map<String, int> notificationsByStatus;
  final Map<String, double> channelPerformance;
  final List<Map<String, dynamic>> engagementHistory;

  const ContentStatistics({
    required this.totalNotifications,
    required this.totalAnnouncements,
    required this.totalEducationalContent,
    required this.totalPolicyUpdates,
    required this.activeChannels,
    required this.averageEngagementRate,
    required this.contentByType,
    required this.notificationsByStatus,
    required this.channelPerformance,
    required this.engagementHistory,
  });

  factory ContentStatistics.fromJson(Map<String, dynamic> json) {
    return ContentStatistics(
      totalNotifications: json['total_notifications'] as int,
      totalAnnouncements: json['total_announcements'] as int,
      totalEducationalContent: json['total_educational_content'] as int,
      totalPolicyUpdates: json['total_policy_updates'] as int,
      activeChannels: json['active_channels'] as int,
      averageEngagementRate: (json['average_engagement_rate'] as num).toDouble(),
      contentByType: Map<String, int>.from(json['content_by_type'] as Map),
      notificationsByStatus: Map<String, int>.from(json['notifications_by_status'] as Map),
      channelPerformance: Map<String, double>.from(
        (json['channel_performance'] as Map).map(
          (key, value) => MapEntry(key as String, (value as num).toDouble()),
        ),
      ),
      engagementHistory: List<Map<String, dynamic>>.from(json['engagement_history'] as List),
    );
  }
}

/// Notification list state notifier
class NotificationListNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final ContentService _service;

  NotificationListNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadNotifications({
    int page = 1,
    int limit = 50,
    ContentSearchFilters? filters,
  }) async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getNotifications(
        page: page,
        limit: limit,
        filters: filters?.toQueryParameters(),
      );
      
      final notifications = (result['notifications'] as List)
          .map((json) => AppNotification.fromJson(json))
          .toList();
      
      state = AsyncValue.data({
        'notifications': notifications,
        'total': result['total'],
        'page': result['page'],
        'limit': result['limit'],
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Announcement list state notifier
class AnnouncementListNotifier extends StateNotifier<AsyncValue<List<Announcement>>> {
  final ContentService _service;

  AnnouncementListNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadAnnouncements({
    String? status,
    String? type,
  }) async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getAnnouncements(
        status: status,
        type: type,
      );
      final announcements = (result['announcements'] as List)
          .map((json) => Announcement.fromJson(json))
          .toList();
      state = AsyncValue.data(announcements);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Educational content state notifier
class EducationalContentNotifier extends StateNotifier<AsyncValue<List<EducationalContent>>> {
  final ContentService _service;

  EducationalContentNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadContent({
    String? category,
    String? status,
  }) async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getEducationalContent(
        category: category,
        status: status,
      );
      final content = (result['content'] as List)
          .map((json) => EducationalContent.fromJson(json))
          .toList();
      state = AsyncValue.data(content);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Policy updates state notifier
class PolicyUpdatesNotifier extends StateNotifier<AsyncValue<List<PolicyUpdate>>> {
  final ContentService _service;

  PolicyUpdatesNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadPolicies({String? status}) async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getPolicyUpdates(status: status);
      final policies = (result['policies'] as List)
          .map((json) => PolicyUpdate.fromJson(json))
          .toList();
      state = AsyncValue.data(policies);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Communication channels state notifier
class CommunicationChannelsNotifier extends StateNotifier<AsyncValue<List<CommunicationChannel>>> {
  final ContentService _service;

  CommunicationChannelsNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadChannels() async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getCommunicationChannels();
      final channels = (result['channels'] as List)
          .map((json) => CommunicationChannel.fromJson(json))
          .toList();
      state = AsyncValue.data(channels);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Content statistics state notifier
class ContentStatisticsNotifier extends StateNotifier<AsyncValue<ContentStatistics>> {
  final ContentService _service;

  ContentStatisticsNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> loadStatistics() async {
    try {
      state = const AsyncValue.loading();
      final result = await _service.getContentStatistics();
      state = AsyncValue.data(ContentStatistics.fromJson(result));
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Providers
final notificationListProvider = StateNotifierProvider<NotificationListNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  final service = ref.watch(contentServiceProvider);
  return NotificationListNotifier(service);
});

final announcementListProvider = StateNotifierProvider<AnnouncementListNotifier, AsyncValue<List<Announcement>>>((ref) {
  final service = ref.watch(contentServiceProvider);
  return AnnouncementListNotifier(service);
});

final educationalContentProvider = StateNotifierProvider<EducationalContentNotifier, AsyncValue<List<EducationalContent>>>((ref) {
  final service = ref.watch(contentServiceProvider);
  return EducationalContentNotifier(service);
});

final policyUpdatesProvider = StateNotifierProvider<PolicyUpdatesNotifier, AsyncValue<List<PolicyUpdate>>>((ref) {
  final service = ref.watch(contentServiceProvider);
  return PolicyUpdatesNotifier(service);
});

final communicationChannelsProvider = StateNotifierProvider<CommunicationChannelsNotifier, AsyncValue<List<CommunicationChannel>>>((ref) {
  final service = ref.watch(contentServiceProvider);
  return CommunicationChannelsNotifier(service);
});

final contentStatisticsProvider = StateNotifierProvider<ContentStatisticsNotifier, AsyncValue<ContentStatistics>>((ref) {
  final service = ref.watch(contentServiceProvider);
  return ContentStatisticsNotifier(service);
});

/// Selected content provider
final selectedContentProvider = StateProvider<String?>((ref) => null);

/// Notification details provider
final notificationDetailsProvider = FutureProvider.family<AppNotification, String>((ref, notificationId) async {
  final service = ref.watch(contentServiceProvider);
  final result = await service.getNotificationById(notificationId);
  return AppNotification.fromJson(result);
});

/// Pending notifications count provider
final pendingNotificationsCountProvider = Provider<int>((ref) {
  final notificationsAsync = ref.watch(notificationListProvider);
  return notificationsAsync.when(
    data: (data) {
      final notifications = data['notifications'] as List<AppNotification>;
      return notifications.where((notification) => notification.status == 'draft').length;
    },
    loading: () => 0,
    error: (_, __) => 0,
  );
});
