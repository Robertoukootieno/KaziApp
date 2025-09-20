import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_provider_registration.freezed.dart';
part 'service_provider_registration.g.dart';

@freezed
class ServiceProviderRegistration with _$ServiceProviderRegistration {
  const factory ServiceProviderRegistration({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String serviceType,
    required String businessName,
    required String businessDescription,
    required String businessAddress,
    required String county,
    required String subCounty,
    required String ward,
    required bool hasBusinessLicense,
    required bool isRegisteredBusiness,
    String? businessLicense,
    String? taxPin,
    String? businessLicenseImageUrl,
    String? businessLogoImageUrl,
    String? idCopyImageUrl,
    required RegistrationStatus status,
    String? rejectionReason,
    String? adminNotes,
    required DateTime submittedAt,
    DateTime? reviewedAt,
    String? reviewedBy,
    @Default({}) Map<String, dynamic> additionalData,
  }) = _ServiceProviderRegistration;

  factory ServiceProviderRegistration.fromJson(Map<String, dynamic> json) =>
      _$ServiceProviderRegistrationFromJson(json);
}

@freezed
class RegistrationDocument with _$RegistrationDocument {
  const factory RegistrationDocument({
    required String id,
    required String registrationId,
    required DocumentType type,
    required String fileName,
    required String fileUrl,
    required String mimeType,
    required int fileSize,
    required DateTime uploadedAt,
    @Default(DocumentStatus.pending) DocumentStatus status,
    String? verificationNotes,
  }) = _RegistrationDocument;

  factory RegistrationDocument.fromJson(Map<String, dynamic> json) =>
      _$RegistrationDocumentFromJson(json);
}

@freezed
class RegistrationApprovalRequest with _$RegistrationApprovalRequest {
  const factory RegistrationApprovalRequest({
    required String id,
    required String registrationId,
    required String adminId,
    required ApprovalAction action,
    String? reason,
    String? notes,
    required DateTime requestedAt,
    @Default({}) Map<String, dynamic> metadata,
  }) = _RegistrationApprovalRequest;

  factory RegistrationApprovalRequest.fromJson(Map<String, dynamic> json) =>
      _$RegistrationApprovalRequestFromJson(json);
}

@freezed
class RegistrationNotification with _$RegistrationNotification {
  const factory RegistrationNotification({
    required String id,
    required String registrationId,
    required String recipientId,
    required NotificationType type,
    required String title,
    required String message,
    required DateTime createdAt,
    @Default(false) bool isRead,
    @Default({}) Map<String, dynamic> data,
  }) = _RegistrationNotification;

  factory RegistrationNotification.fromJson(Map<String, dynamic> json) =>
      _$RegistrationNotificationFromJson(json);
}

enum RegistrationStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('under_review')
  underReview,
  @JsonValue('approved')
  approved,
  @JsonValue('rejected')
  rejected,
  @JsonValue('requires_additional_info')
  requiresAdditionalInfo,
}

enum DocumentType {
  @JsonValue('business_license')
  businessLicense,
  @JsonValue('business_logo')
  businessLogo,
  @JsonValue('id_copy')
  idCopy,
  @JsonValue('tax_certificate')
  taxCertificate,
  @JsonValue('other')
  other,
}

enum DocumentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('verified')
  verified,
  @JsonValue('rejected')
  rejected,
}

enum ApprovalAction {
  @JsonValue('approve')
  approve,
  @JsonValue('reject')
  reject,
  @JsonValue('request_more_info')
  requestMoreInfo,
}

enum NotificationType {
  @JsonValue('registration_submitted')
  registrationSubmitted,
  @JsonValue('registration_approved')
  registrationApproved,
  @JsonValue('registration_rejected')
  registrationRejected,
  @JsonValue('additional_info_required')
  additionalInfoRequired,
  @JsonValue('document_verified')
  documentVerified,
  @JsonValue('document_rejected')
  documentRejected,
}

// Extension methods for better UX
extension RegistrationStatusExtension on RegistrationStatus {
  String get displayName {
    switch (this) {
      case RegistrationStatus.pending:
        return 'Pending Review';
      case RegistrationStatus.underReview:
        return 'Under Review';
      case RegistrationStatus.approved:
        return 'Approved';
      case RegistrationStatus.rejected:
        return 'Rejected';
      case RegistrationStatus.requiresAdditionalInfo:
        return 'Additional Info Required';
    }
  }

  Color get color {
    switch (this) {
      case RegistrationStatus.pending:
        return const Color(0xFFF57C00); // Orange
      case RegistrationStatus.underReview:
        return const Color(0xFF1976D2); // Blue
      case RegistrationStatus.approved:
        return const Color(0xFF388E3C); // Green
      case RegistrationStatus.rejected:
        return const Color(0xFFD32F2F); // Red
      case RegistrationStatus.requiresAdditionalInfo:
        return const Color(0xFF7B1FA2); // Purple
    }
  }

  IconData get icon {
    switch (this) {
      case RegistrationStatus.pending:
        return Icons.pending;
      case RegistrationStatus.underReview:
        return Icons.rate_review;
      case RegistrationStatus.approved:
        return Icons.check_circle;
      case RegistrationStatus.rejected:
        return Icons.cancel;
      case RegistrationStatus.requiresAdditionalInfo:
        return Icons.info;
    }
  }
}

extension DocumentTypeExtension on DocumentType {
  String get displayName {
    switch (this) {
      case DocumentType.businessLicense:
        return 'Business License';
      case DocumentType.businessLogo:
        return 'Business Logo';
      case DocumentType.idCopy:
        return 'ID Copy';
      case DocumentType.taxCertificate:
        return 'Tax Certificate';
      case DocumentType.other:
        return 'Other Document';
    }
  }

  IconData get icon {
    switch (this) {
      case DocumentType.businessLicense:
        return Icons.description;
      case DocumentType.businessLogo:
        return Icons.business;
      case DocumentType.idCopy:
        return Icons.credit_card;
      case DocumentType.taxCertificate:
        return Icons.receipt_long;
      case DocumentType.other:
        return Icons.attach_file;
    }
  }
}
