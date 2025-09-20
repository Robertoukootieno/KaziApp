// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_provider_registration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceProviderRegistrationImpl _$$ServiceProviderRegistrationImplFromJson(
        Map<String, dynamic> json) =>
    _$ServiceProviderRegistrationImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      serviceType: json['serviceType'] as String,
      businessName: json['businessName'] as String,
      businessDescription: json['businessDescription'] as String,
      businessAddress: json['businessAddress'] as String,
      county: json['county'] as String,
      subCounty: json['subCounty'] as String,
      ward: json['ward'] as String,
      hasBusinessLicense: json['hasBusinessLicense'] as bool,
      isRegisteredBusiness: json['isRegisteredBusiness'] as bool,
      businessLicense: json['businessLicense'] as String?,
      taxPin: json['taxPin'] as String?,
      businessLicenseImageUrl: json['businessLicenseImageUrl'] as String?,
      businessLogoImageUrl: json['businessLogoImageUrl'] as String?,
      idCopyImageUrl: json['idCopyImageUrl'] as String?,
      status: $enumDecode(_$RegistrationStatusEnumMap, json['status']),
      rejectionReason: json['rejectionReason'] as String?,
      adminNotes: json['adminNotes'] as String?,
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      reviewedAt: json['reviewedAt'] == null
          ? null
          : DateTime.parse(json['reviewedAt'] as String),
      reviewedBy: json['reviewedBy'] as String?,
      additionalData:
          json['additionalData'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$ServiceProviderRegistrationImplToJson(
        _$ServiceProviderRegistrationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'serviceType': instance.serviceType,
      'businessName': instance.businessName,
      'businessDescription': instance.businessDescription,
      'businessAddress': instance.businessAddress,
      'county': instance.county,
      'subCounty': instance.subCounty,
      'ward': instance.ward,
      'hasBusinessLicense': instance.hasBusinessLicense,
      'isRegisteredBusiness': instance.isRegisteredBusiness,
      'businessLicense': instance.businessLicense,
      'taxPin': instance.taxPin,
      'businessLicenseImageUrl': instance.businessLicenseImageUrl,
      'businessLogoImageUrl': instance.businessLogoImageUrl,
      'idCopyImageUrl': instance.idCopyImageUrl,
      'status': _$RegistrationStatusEnumMap[instance.status]!,
      'rejectionReason': instance.rejectionReason,
      'adminNotes': instance.adminNotes,
      'submittedAt': instance.submittedAt.toIso8601String(),
      'reviewedAt': instance.reviewedAt?.toIso8601String(),
      'reviewedBy': instance.reviewedBy,
      'additionalData': instance.additionalData,
    };

const _$RegistrationStatusEnumMap = {
  RegistrationStatus.pending: 'pending',
  RegistrationStatus.underReview: 'under_review',
  RegistrationStatus.approved: 'approved',
  RegistrationStatus.rejected: 'rejected',
  RegistrationStatus.requiresAdditionalInfo: 'requires_additional_info',
};

_$RegistrationDocumentImpl _$$RegistrationDocumentImplFromJson(
        Map<String, dynamic> json) =>
    _$RegistrationDocumentImpl(
      id: json['id'] as String,
      registrationId: json['registrationId'] as String,
      type: $enumDecode(_$DocumentTypeEnumMap, json['type']),
      fileName: json['fileName'] as String,
      fileUrl: json['fileUrl'] as String,
      mimeType: json['mimeType'] as String,
      fileSize: (json['fileSize'] as num).toInt(),
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      status: $enumDecodeNullable(_$DocumentStatusEnumMap, json['status']) ??
          DocumentStatus.pending,
      verificationNotes: json['verificationNotes'] as String?,
    );

Map<String, dynamic> _$$RegistrationDocumentImplToJson(
        _$RegistrationDocumentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'registrationId': instance.registrationId,
      'type': _$DocumentTypeEnumMap[instance.type]!,
      'fileName': instance.fileName,
      'fileUrl': instance.fileUrl,
      'mimeType': instance.mimeType,
      'fileSize': instance.fileSize,
      'uploadedAt': instance.uploadedAt.toIso8601String(),
      'status': _$DocumentStatusEnumMap[instance.status]!,
      'verificationNotes': instance.verificationNotes,
    };

const _$DocumentTypeEnumMap = {
  DocumentType.businessLicense: 'business_license',
  DocumentType.businessLogo: 'business_logo',
  DocumentType.idCopy: 'id_copy',
  DocumentType.taxCertificate: 'tax_certificate',
  DocumentType.other: 'other',
};

const _$DocumentStatusEnumMap = {
  DocumentStatus.pending: 'pending',
  DocumentStatus.verified: 'verified',
  DocumentStatus.rejected: 'rejected',
};

_$RegistrationApprovalRequestImpl _$$RegistrationApprovalRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$RegistrationApprovalRequestImpl(
      id: json['id'] as String,
      registrationId: json['registrationId'] as String,
      adminId: json['adminId'] as String,
      action: $enumDecode(_$ApprovalActionEnumMap, json['action']),
      reason: json['reason'] as String?,
      notes: json['notes'] as String?,
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$RegistrationApprovalRequestImplToJson(
        _$RegistrationApprovalRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'registrationId': instance.registrationId,
      'adminId': instance.adminId,
      'action': _$ApprovalActionEnumMap[instance.action]!,
      'reason': instance.reason,
      'notes': instance.notes,
      'requestedAt': instance.requestedAt.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$ApprovalActionEnumMap = {
  ApprovalAction.approve: 'approve',
  ApprovalAction.reject: 'reject',
  ApprovalAction.requestMoreInfo: 'request_more_info',
};

_$RegistrationNotificationImpl _$$RegistrationNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$RegistrationNotificationImpl(
      id: json['id'] as String,
      registrationId: json['registrationId'] as String,
      recipientId: json['recipientId'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      title: json['title'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
      data: json['data'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$RegistrationNotificationImplToJson(
        _$RegistrationNotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'registrationId': instance.registrationId,
      'recipientId': instance.recipientId,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'title': instance.title,
      'message': instance.message,
      'createdAt': instance.createdAt.toIso8601String(),
      'isRead': instance.isRead,
      'data': instance.data,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.registrationSubmitted: 'registration_submitted',
  NotificationType.registrationApproved: 'registration_approved',
  NotificationType.registrationRejected: 'registration_rejected',
  NotificationType.additionalInfoRequired: 'additional_info_required',
  NotificationType.documentVerified: 'document_verified',
  NotificationType.documentRejected: 'document_rejected',
};
