import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';

/// Content service for managing notifications, announcements, and educational content
class ContentService {
  final Dio _dio;

  ContentService(this._dio);

  /// Get notifications with filtering and pagination
  Future<Map<String, dynamic>> getNotifications({
    int page = 1,
    int limit = 50,
    Map<String, dynamic>? filters,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        ...?filters,
      };

      final response = await _dio.get(
        '/admin/content/notifications',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  /// Get notification by ID
  Future<Map<String, dynamic>> getNotificationById(String notificationId) async {
    try {
      final response = await _dio.get('/admin/content/notifications/$notificationId');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch notification: $e');
    }
  }

  /// Create a new notification
  Future<Map<String, dynamic>> createNotification({
    required String title,
    required String message,
    required String type,
    required String targetAudience,
    DateTime? scheduledAt,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _dio.post('/admin/content/notifications', data: {
        'title': title,
        'message': message,
        'type': type,
        'target_audience': targetAudience,
        if (scheduledAt != null) 'scheduled_at': scheduledAt.toIso8601String(),
        if (metadata != null) 'metadata': metadata,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to create notification: $e');
    }
  }

  /// Update notification
  Future<Map<String, dynamic>> updateNotification(String notificationId, Map<String, dynamic> updates) async {
    try {
      final response = await _dio.patch('/admin/content/notifications/$notificationId', data: updates);
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to update notification: $e');
    }
  }

  /// Send notification
  Future<void> sendNotification(String notificationId) async {
    try {
      await _dio.post('/admin/content/notifications/$notificationId/send');
    } catch (e) {
      throw Exception('Failed to send notification: $e');
    }
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _dio.delete('/admin/content/notifications/$notificationId');
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  /// Get notification analytics
  Future<Map<String, dynamic>> getNotificationAnalytics(String notificationId) async {
    try {
      final response = await _dio.get('/admin/content/notifications/$notificationId/analytics');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch notification analytics: $e');
    }
  }

  /// Get announcements
  Future<Map<String, dynamic>> getAnnouncements({
    String? status,
    String? type,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;
      if (type != null) queryParams['type'] = type;
      if (limit != null) queryParams['limit'] = limit;

      final response = await _dio.get(
        '/admin/content/announcements',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch announcements: $e');
    }
  }

  /// Create announcement
  Future<Map<String, dynamic>> createAnnouncement({
    required String title,
    required String content,
    required String type,
    required String priority,
    required String targetAudience,
    required DateTime startDate,
    DateTime? endDate,
    bool isSticky = false,
  }) async {
    try {
      final response = await _dio.post('/admin/content/announcements', data: {
        'title': title,
        'content': content,
        'type': type,
        'priority': priority,
        'target_audience': targetAudience,
        'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
        'is_sticky': isSticky,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to create announcement: $e');
    }
  }

  /// Update announcement
  Future<Map<String, dynamic>> updateAnnouncement(String announcementId, Map<String, dynamic> updates) async {
    try {
      final response = await _dio.patch('/admin/content/announcements/$announcementId', data: updates);
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to update announcement: $e');
    }
  }

  /// Delete announcement
  Future<void> deleteAnnouncement(String announcementId) async {
    try {
      await _dio.delete('/admin/content/announcements/$announcementId');
    } catch (e) {
      throw Exception('Failed to delete announcement: $e');
    }
  }

  /// Get educational content
  Future<Map<String, dynamic>> getEducationalContent({
    String? category,
    String? status,
    String? difficulty,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (category != null) queryParams['category'] = category;
      if (status != null) queryParams['status'] = status;
      if (difficulty != null) queryParams['difficulty'] = difficulty;
      if (limit != null) queryParams['limit'] = limit;

      final response = await _dio.get(
        '/admin/content/educational',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch educational content: $e');
    }
  }

  /// Create educational content
  Future<Map<String, dynamic>> createEducationalContent({
    required String title,
    required String description,
    required String content,
    required String contentType,
    required String category,
    required List<String> tags,
    required String difficulty,
    required int estimatedReadTime,
  }) async {
    try {
      final response = await _dio.post('/admin/content/educational', data: {
        'title': title,
        'description': description,
        'content': content,
        'content_type': contentType,
        'category': category,
        'tags': tags,
        'difficulty': difficulty,
        'estimated_read_time': estimatedReadTime,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to create educational content: $e');
    }
  }

  /// Update educational content
  Future<Map<String, dynamic>> updateEducationalContent(String contentId, Map<String, dynamic> updates) async {
    try {
      final response = await _dio.patch('/admin/content/educational/$contentId', data: updates);
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to update educational content: $e');
    }
  }

  /// Publish educational content
  Future<void> publishEducationalContent(String contentId) async {
    try {
      await _dio.post('/admin/content/educational/$contentId/publish');
    } catch (e) {
      throw Exception('Failed to publish educational content: $e');
    }
  }

  /// Delete educational content
  Future<void> deleteEducationalContent(String contentId) async {
    try {
      await _dio.delete('/admin/content/educational/$contentId');
    } catch (e) {
      throw Exception('Failed to delete educational content: $e');
    }
  }

  /// Get policy updates
  Future<Map<String, dynamic>> getPolicyUpdates({
    String? status,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;
      if (limit != null) queryParams['limit'] = limit;

      final response = await _dio.get(
        '/admin/content/policies',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch policy updates: $e');
    }
  }

  /// Create policy update
  Future<Map<String, dynamic>> createPolicyUpdate({
    required String title,
    required String description,
    required String content,
    required String version,
    required DateTime effectiveDate,
    bool requiresAcknowledgment = false,
  }) async {
    try {
      final response = await _dio.post('/admin/content/policies', data: {
        'title': title,
        'description': description,
        'content': content,
        'version': version,
        'effective_date': effectiveDate.toIso8601String(),
        'requires_acknowledgment': requiresAcknowledgment,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to create policy update: $e');
    }
  }

  /// Update policy update
  Future<Map<String, dynamic>> updatePolicyUpdate(String policyId, Map<String, dynamic> updates) async {
    try {
      final response = await _dio.patch('/admin/content/policies/$policyId', data: updates);
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to update policy update: $e');
    }
  }

  /// Publish policy update
  Future<void> publishPolicyUpdate(String policyId) async {
    try {
      await _dio.post('/admin/content/policies/$policyId/publish');
    } catch (e) {
      throw Exception('Failed to publish policy update: $e');
    }
  }

  /// Get policy acknowledgments
  Future<Map<String, dynamic>> getPolicyAcknowledgments(String policyId) async {
    try {
      final response = await _dio.get('/admin/content/policies/$policyId/acknowledgments');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch policy acknowledgments: $e');
    }
  }

  /// Get communication channels
  Future<Map<String, dynamic>> getCommunicationChannels() async {
    try {
      final response = await _dio.get('/admin/content/channels');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch communication channels: $e');
    }
  }

  /// Create communication channel
  Future<Map<String, dynamic>> createCommunicationChannel({
    required String name,
    required String type,
    required Map<String, dynamic> configuration,
  }) async {
    try {
      final response = await _dio.post('/admin/content/channels', data: {
        'name': name,
        'type': type,
        'configuration': configuration,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to create communication channel: $e');
    }
  }

  /// Update communication channel
  Future<void> updateCommunicationChannel(String channelId, Map<String, dynamic> updates) async {
    try {
      await _dio.patch('/admin/content/channels/$channelId', data: updates);
    } catch (e) {
      throw Exception('Failed to update communication channel: $e');
    }
  }

  /// Test communication channel
  Future<Map<String, dynamic>> testCommunicationChannel(String channelId) async {
    try {
      final response = await _dio.post('/admin/content/channels/$channelId/test');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to test communication channel: $e');
    }
  }

  /// Delete communication channel
  Future<void> deleteCommunicationChannel(String channelId) async {
    try {
      await _dio.delete('/admin/content/channels/$channelId');
    } catch (e) {
      throw Exception('Failed to delete communication channel: $e');
    }
  }

  /// Get content statistics
  Future<Map<String, dynamic>> getContentStatistics() async {
    try {
      final response = await _dio.get('/admin/content/statistics');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch content statistics: $e');
    }
  }

  /// Get content templates
  Future<Map<String, dynamic>> getContentTemplates({
    String? type,
    String? category,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (type != null) queryParams['type'] = type;
      if (category != null) queryParams['category'] = category;

      final response = await _dio.get(
        '/admin/content/templates',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch content templates: $e');
    }
  }

  /// Create content template
  Future<Map<String, dynamic>> createContentTemplate({
    required String name,
    required String type,
    required String category,
    required Map<String, dynamic> template,
  }) async {
    try {
      final response = await _dio.post('/admin/content/templates', data: {
        'name': name,
        'type': type,
        'category': category,
        'template': template,
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to create content template: $e');
    }
  }

  /// Bulk send notifications
  Future<Map<String, dynamic>> bulkSendNotifications({
    required List<String> notificationIds,
    DateTime? scheduledAt,
  }) async {
    try {
      final response = await _dio.post('/admin/content/notifications/bulk-send', data: {
        'notification_ids': notificationIds,
        if (scheduledAt != null) 'scheduled_at': scheduledAt.toIso8601String(),
      });
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to bulk send notifications: $e');
    }
  }

  /// Export content
  Future<String> exportContent({
    required String contentType,
    Map<String, dynamic>? filters,
    String? format,
  }) async {
    try {
      final response = await _dio.post('/admin/content/export', data: {
        'content_type': contentType,
        if (filters != null) 'filters': filters,
        if (format != null) 'format': format,
      });
      return response.data['data']['download_url'] as String;
    } catch (e) {
      throw Exception('Failed to export content: $e');
    }
  }

  /// Get content engagement analytics
  Future<Map<String, dynamic>> getContentEngagementAnalytics({
    String? contentType,
    String? timeRange,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (contentType != null) queryParams['content_type'] = contentType;
      if (timeRange != null) queryParams['time_range'] = timeRange;

      final response = await _dio.get(
        '/admin/content/analytics/engagement',
        queryParameters: queryParams,
      );
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch content engagement analytics: $e');
    }
  }

  /// Schedule content publication
  Future<void> scheduleContentPublication(String contentId, DateTime publishAt) async {
    try {
      await _dio.post('/admin/content/schedule-publication', data: {
        'content_id': contentId,
        'publish_at': publishAt.toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to schedule content publication: $e');
    }
  }

  /// Get content moderation queue
  Future<Map<String, dynamic>> getContentModerationQueue() async {
    try {
      final response = await _dio.get('/admin/content/moderation-queue');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to fetch content moderation queue: $e');
    }
  }

  /// Moderate content
  Future<void> moderateContent(String contentId, String action, {String? reason}) async {
    try {
      await _dio.post('/admin/content/moderate', data: {
        'content_id': contentId,
        'action': action,
        if (reason != null) 'reason': reason,
      });
    } catch (e) {
      throw Exception('Failed to moderate content: $e');
    }
  }
}

/// Content service provider
final contentServiceProvider = Provider<ContentService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ContentService(apiService.dio);
});
