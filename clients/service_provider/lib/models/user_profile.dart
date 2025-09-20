import 'package:flutter/material.dart';

// User Profile Type Enum
enum UserProfileType {
  selfRegistered,
  businessRegistered,
}

extension UserProfileTypeExtension on UserProfileType {
  String get displayName {
    switch (this) {
      case UserProfileType.selfRegistered:
        return 'Individual Service Provider';
      case UserProfileType.businessRegistered:
        return 'Business Service Provider';
    }
  }

  IconData get icon {
    switch (this) {
      case UserProfileType.selfRegistered:
        return Icons.person;
      case UserProfileType.businessRegistered:
        return Icons.business;
    }
  }
}

// Account Status Enum
enum AccountStatus {
  active,
  inactive,
  suspended,
  pendingVerification,
  verified,
}

extension AccountStatusExtension on AccountStatus {
  String get displayName {
    switch (this) {
      case AccountStatus.active:
        return 'Active';
      case AccountStatus.inactive:
        return 'Inactive';
      case AccountStatus.suspended:
        return 'Suspended';
      case AccountStatus.pendingVerification:
        return 'Pending Verification';
      case AccountStatus.verified:
        return 'Verified';
    }
  }

  Color get color {
    switch (this) {
      case AccountStatus.active:
        return Colors.green;
      case AccountStatus.inactive:
        return Colors.grey;
      case AccountStatus.suspended:
        return Colors.red;
      case AccountStatus.pendingVerification:
        return Colors.orange;
      case AccountStatus.verified:
        return Colors.blue;
    }
  }
}

// Notification Preferences Model
class NotificationPreferences {
  final bool emailNotifications;
  final bool pushNotifications;
  final bool smsNotifications;
  final bool marketingEmails;
  final bool orderUpdates;
  final bool appointmentReminders;
  final bool systemAlerts;

  NotificationPreferences({
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.smsNotifications = false,
    this.marketingEmails = false,
    this.orderUpdates = true,
    this.appointmentReminders = true,
    this.systemAlerts = true,
  });

  NotificationPreferences copyWith({
    bool? emailNotifications,
    bool? pushNotifications,
    bool? smsNotifications,
    bool? marketingEmails,
    bool? orderUpdates,
    bool? appointmentReminders,
    bool? systemAlerts,
  }) {
    return NotificationPreferences(
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      marketingEmails: marketingEmails ?? this.marketingEmails,
      orderUpdates: orderUpdates ?? this.orderUpdates,
      appointmentReminders: appointmentReminders ?? this.appointmentReminders,
      systemAlerts: systemAlerts ?? this.systemAlerts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emailNotifications': emailNotifications,
      'pushNotifications': pushNotifications,
      'smsNotifications': smsNotifications,
      'marketingEmails': marketingEmails,
      'orderUpdates': orderUpdates,
      'appointmentReminders': appointmentReminders,
      'systemAlerts': systemAlerts,
    };
  }

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      emailNotifications: json['emailNotifications'] ?? true,
      pushNotifications: json['pushNotifications'] ?? true,
      smsNotifications: json['smsNotifications'] ?? false,
      marketingEmails: json['marketingEmails'] ?? false,
      orderUpdates: json['orderUpdates'] ?? true,
      appointmentReminders: json['appointmentReminders'] ?? true,
      systemAlerts: json['systemAlerts'] ?? true,
    );
  }
}

// Privacy Settings Model
class PrivacySettings {
  final bool profileVisibility;
  final bool contactInfoVisibility;
  final bool serviceHistoryVisibility;
  final bool allowDataCollection;
  final bool allowLocationTracking;

  PrivacySettings({
    this.profileVisibility = true,
    this.contactInfoVisibility = false,
    this.serviceHistoryVisibility = false,
    this.allowDataCollection = true,
    this.allowLocationTracking = false,
  });

  PrivacySettings copyWith({
    bool? profileVisibility,
    bool? contactInfoVisibility,
    bool? serviceHistoryVisibility,
    bool? allowDataCollection,
    bool? allowLocationTracking,
  }) {
    return PrivacySettings(
      profileVisibility: profileVisibility ?? this.profileVisibility,
      contactInfoVisibility: contactInfoVisibility ?? this.contactInfoVisibility,
      serviceHistoryVisibility: serviceHistoryVisibility ?? this.serviceHistoryVisibility,
      allowDataCollection: allowDataCollection ?? this.allowDataCollection,
      allowLocationTracking: allowLocationTracking ?? this.allowLocationTracking,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profileVisibility': profileVisibility,
      'contactInfoVisibility': contactInfoVisibility,
      'serviceHistoryVisibility': serviceHistoryVisibility,
      'allowDataCollection': allowDataCollection,
      'allowLocationTracking': allowLocationTracking,
    };
  }

  factory PrivacySettings.fromJson(Map<String, dynamic> json) {
    return PrivacySettings(
      profileVisibility: json['profileVisibility'] ?? true,
      contactInfoVisibility: json['contactInfoVisibility'] ?? false,
      serviceHistoryVisibility: json['serviceHistoryVisibility'] ?? false,
      allowDataCollection: json['allowDataCollection'] ?? true,
      allowLocationTracking: json['allowLocationTracking'] ?? false,
    );
  }
}

// Business Information Model
class BusinessInformation {
  final String? businessName;
  final String? businessRegistrationNumber;
  final String? businessType;
  final String? businessAddress;
  final String? businessPhone;
  final String? businessEmail;
  final String? businessWebsite;
  final String? taxNumber;
  final String? description;
  final String? businessLicense;
  final String? taxPin;
  final int? yearsInBusiness;
  final bool hasBusinessLicense;
  final bool isRegisteredBusiness;
  final String? businessLicenseImagePath;
  final String? businessLogoImagePath;
  final String? idCopyImagePath;
  final List<String> businessDocuments;
  final bool isVerified;

  BusinessInformation({
    this.businessName,
    this.businessRegistrationNumber,
    this.businessType,
    this.businessAddress,
    this.businessPhone,
    this.businessEmail,
    this.businessWebsite,
    this.taxNumber,
    this.description,
    this.businessLicense,
    this.taxPin,
    this.yearsInBusiness,
    this.hasBusinessLicense = false,
    this.isRegisteredBusiness = false,
    this.businessLicenseImagePath,
    this.businessLogoImagePath,
    this.idCopyImagePath,
    this.businessDocuments = const [],
    this.isVerified = false,
  });

  BusinessInformation copyWith({
    String? businessName,
    String? businessRegistrationNumber,
    String? businessType,
    String? businessAddress,
    String? businessPhone,
    String? businessEmail,
    String? businessWebsite,
    String? taxNumber,
    String? description,
    String? businessLicense,
    String? taxPin,
    int? yearsInBusiness,
    bool? hasBusinessLicense,
    bool? isRegisteredBusiness,
    String? businessLicenseImagePath,
    String? businessLogoImagePath,
    String? idCopyImagePath,
    List<String>? businessDocuments,
    bool? isVerified,
  }) {
    return BusinessInformation(
      businessName: businessName ?? this.businessName,
      businessRegistrationNumber: businessRegistrationNumber ?? this.businessRegistrationNumber,
      businessType: businessType ?? this.businessType,
      businessAddress: businessAddress ?? this.businessAddress,
      businessPhone: businessPhone ?? this.businessPhone,
      businessEmail: businessEmail ?? this.businessEmail,
      businessWebsite: businessWebsite ?? this.businessWebsite,
      taxNumber: taxNumber ?? this.taxNumber,
      description: description ?? this.description,
      businessLicense: businessLicense ?? this.businessLicense,
      taxPin: taxPin ?? this.taxPin,
      yearsInBusiness: yearsInBusiness ?? this.yearsInBusiness,
      hasBusinessLicense: hasBusinessLicense ?? this.hasBusinessLicense,
      isRegisteredBusiness: isRegisteredBusiness ?? this.isRegisteredBusiness,
      businessLicenseImagePath: businessLicenseImagePath ?? this.businessLicenseImagePath,
      businessLogoImagePath: businessLogoImagePath ?? this.businessLogoImagePath,
      idCopyImagePath: idCopyImagePath ?? this.idCopyImagePath,
      businessDocuments: businessDocuments ?? this.businessDocuments,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessName': businessName,
      'businessRegistrationNumber': businessRegistrationNumber,
      'businessType': businessType,
      'businessAddress': businessAddress,
      'businessPhone': businessPhone,
      'businessEmail': businessEmail,
      'businessWebsite': businessWebsite,
      'taxNumber': taxNumber,
      'description': description,
      'businessLicense': businessLicense,
      'taxPin': taxPin,
      'yearsInBusiness': yearsInBusiness,
      'hasBusinessLicense': hasBusinessLicense,
      'isRegisteredBusiness': isRegisteredBusiness,
      'businessLicenseImagePath': businessLicenseImagePath,
      'businessLogoImagePath': businessLogoImagePath,
      'idCopyImagePath': idCopyImagePath,
      'businessDocuments': businessDocuments,
      'isVerified': isVerified,
    };
  }

  factory BusinessInformation.fromJson(Map<String, dynamic> json) {
    return BusinessInformation(
      businessName: json['businessName'],
      businessRegistrationNumber: json['businessRegistrationNumber'],
      businessType: json['businessType'],
      businessAddress: json['businessAddress'],
      businessPhone: json['businessPhone'],
      businessEmail: json['businessEmail'],
      businessWebsite: json['businessWebsite'],
      taxNumber: json['taxNumber'],
      description: json['description'],
      businessLicense: json['businessLicense'],
      taxPin: json['taxPin'],
      yearsInBusiness: json['yearsInBusiness'],
      hasBusinessLicense: json['hasBusinessLicense'] ?? false,
      isRegisteredBusiness: json['isRegisteredBusiness'] ?? false,
      businessLicenseImagePath: json['businessLicenseImagePath'],
      businessLogoImagePath: json['businessLogoImagePath'],
      idCopyImagePath: json['idCopyImagePath'],
      businessDocuments: List<String>.from(json['businessDocuments'] ?? []),
      isVerified: json['isVerified'] ?? false,
    );
  }
}

// User Profile Model
class UserProfile {
  final String id;
  final UserProfileType profileType;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final String? bio;
  final String? location;
  final String? county;
  final String? subCounty;
  final String? serviceType;
  final String? serviceTypeName;
  final List<String> serviceCategories;
  final String? experience;
  final String? servicesOffered;
  final AccountStatus accountStatus;
  final BusinessInformation? businessInfo;
  final NotificationPreferences notificationPreferences;
  final PrivacySettings privacySettings;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLoginAt;
  final bool isProfileComplete;
  final double profileCompletionPercentage;

  UserProfile({
    required this.id,
    required this.profileType,
    required this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.profileImageUrl,
    this.bio,
    this.location,
    this.county,
    this.subCounty,
    this.serviceType,
    this.serviceTypeName,
    this.serviceCategories = const [],
    this.experience,
    this.servicesOffered,
    this.accountStatus = AccountStatus.active,
    this.businessInfo,
    NotificationPreferences? notificationPreferences,
    PrivacySettings? privacySettings,
    required this.createdAt,
    required this.updatedAt,
    this.lastLoginAt,
    this.isProfileComplete = false,
    this.profileCompletionPercentage = 0.0,
  }) : notificationPreferences = notificationPreferences ?? NotificationPreferences(),
       privacySettings = privacySettings ?? PrivacySettings();

  String get displayName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (businessInfo?.businessName != null) {
      return businessInfo!.businessName!;
    } else {
      return email.split('@').first;
    }
  }

  String get initials {
    if (firstName != null && lastName != null) {
      return '${firstName![0]}${lastName![0]}'.toUpperCase();
    } else if (firstName != null) {
      return firstName![0].toUpperCase();
    } else if (businessInfo?.businessName != null) {
      final words = businessInfo!.businessName!.split(' ');
      if (words.length >= 2) {
        return '${words[0][0]}${words[1][0]}'.toUpperCase();
      } else {
        return words[0][0].toUpperCase();
      }
    } else {
      return email[0].toUpperCase();
    }
  }

  bool get isBusinessProfile => profileType == UserProfileType.businessRegistered;
  bool get isIndividualProfile => profileType == UserProfileType.selfRegistered;

  UserProfile copyWith({
    String? id,
    UserProfileType? profileType,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
    String? bio,
    String? location,
    String? county,
    String? subCounty,
    String? serviceType,
    String? serviceTypeName,
    List<String>? serviceCategories,
    String? experience,
    String? servicesOffered,
    AccountStatus? accountStatus,
    BusinessInformation? businessInfo,
    NotificationPreferences? notificationPreferences,
    PrivacySettings? privacySettings,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
    bool? isProfileComplete,
    double? profileCompletionPercentage,
  }) {
    return UserProfile(
      id: id ?? this.id,
      profileType: profileType ?? this.profileType,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      county: county ?? this.county,
      subCounty: subCounty ?? this.subCounty,
      serviceType: serviceType ?? this.serviceType,
      serviceTypeName: serviceTypeName ?? this.serviceTypeName,
      serviceCategories: serviceCategories ?? this.serviceCategories,
      experience: experience ?? this.experience,
      servicesOffered: servicesOffered ?? this.servicesOffered,
      accountStatus: accountStatus ?? this.accountStatus,
      businessInfo: businessInfo ?? this.businessInfo,
      notificationPreferences: notificationPreferences ?? this.notificationPreferences,
      privacySettings: privacySettings ?? this.privacySettings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      profileCompletionPercentage: profileCompletionPercentage ?? this.profileCompletionPercentage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profileType': profileType.name,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'location': location,
      'county': county,
      'subCounty': subCounty,
      'serviceType': serviceType,
      'serviceTypeName': serviceTypeName,
      'serviceCategories': serviceCategories,
      'experience': experience,
      'servicesOffered': servicesOffered,
      'accountStatus': accountStatus.name,
      'businessInfo': businessInfo?.toJson(),
      'notificationPreferences': notificationPreferences.toJson(),
      'privacySettings': privacySettings.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'isProfileComplete': isProfileComplete,
      'profileCompletionPercentage': profileCompletionPercentage,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      profileType: UserProfileType.values.firstWhere(
        (e) => e.name == json['profileType'],
        orElse: () => UserProfileType.selfRegistered,
      ),
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
      bio: json['bio'],
      location: json['location'],
      county: json['county'],
      subCounty: json['subCounty'],
      serviceType: json['serviceType'],
      serviceTypeName: json['serviceTypeName'],
      serviceCategories: List<String>.from(json['serviceCategories'] ?? []),
      experience: json['experience'],
      servicesOffered: json['servicesOffered'],
      accountStatus: AccountStatus.values.firstWhere(
        (e) => e.name == json['accountStatus'],
        orElse: () => AccountStatus.active,
      ),
      businessInfo: json['businessInfo'] != null
          ? BusinessInformation.fromJson(json['businessInfo'])
          : null,
      notificationPreferences: NotificationPreferences.fromJson(
        json['notificationPreferences'] ?? {}
      ),
      privacySettings: PrivacySettings.fromJson(
        json['privacySettings'] ?? {}
      ),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'])
          : null,
      isProfileComplete: json['isProfileComplete'] ?? false,
      profileCompletionPercentage: (json['profileCompletionPercentage'] ?? 0.0).toDouble(),
    );
  }
}
