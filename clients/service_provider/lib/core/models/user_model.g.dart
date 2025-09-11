// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      providerType:
          $enumDecode(_$ServiceProviderTypeEnumMap, json['providerType']),
      status: $enumDecode(_$UserStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      profileImageUrl: json['profileImageUrl'] as String?,
      businessName: json['businessName'] as String?,
      businessRegistrationNumber: json['businessRegistrationNumber'] as String?,
      taxNumber: json['taxNumber'] as String?,
      county: json['county'] as String?,
      subCounty: json['subCounty'] as String?,
      ward: json['ward'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      bio: json['bio'] as String?,
      specializations: (json['specializations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      certifications: (json['certifications'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      yearsOfExperience: (json['yearsOfExperience'] as num?)?.toInt(),
      rating: (json['rating'] as num?)?.toDouble(),
      totalReviews: (json['totalReviews'] as num?)?.toInt(),
      isVerified: json['isVerified'] as bool?,
      isOnline: json['isOnline'] as bool?,
      lastActiveAt: json['lastActiveAt'] == null
          ? null
          : DateTime.parse(json['lastActiveAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'providerType': _$ServiceProviderTypeEnumMap[instance.providerType]!,
      'status': _$UserStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'profileImageUrl': instance.profileImageUrl,
      'businessName': instance.businessName,
      'businessRegistrationNumber': instance.businessRegistrationNumber,
      'taxNumber': instance.taxNumber,
      'county': instance.county,
      'subCounty': instance.subCounty,
      'ward': instance.ward,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'bio': instance.bio,
      'specializations': instance.specializations,
      'certifications': instance.certifications,
      'yearsOfExperience': instance.yearsOfExperience,
      'rating': instance.rating,
      'totalReviews': instance.totalReviews,
      'isVerified': instance.isVerified,
      'isOnline': instance.isOnline,
      'lastActiveAt': instance.lastActiveAt?.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$ServiceProviderTypeEnumMap = {
  ServiceProviderType.veterinarian: 'veterinarian',
  ServiceProviderType.agrovet: 'agrovet',
  ServiceProviderType.feedSupplier: 'feed_supplier',
  ServiceProviderType.seedsSupplier: 'seeds_supplier',
  ServiceProviderType.fertiliserSupplier: 'fertiliser_supplier',
  ServiceProviderType.machineryProvider: 'machinery_provider',
  ServiceProviderType.agriculturalConsultant: 'agricultural_consultant',
  ServiceProviderType.generalRetailer: 'general_retailer',
  ServiceProviderType.logisticsTransportation: 'logistics_transportation',
  ServiceProviderType.insurance: 'insurance',
  ServiceProviderType.trainingProvider: 'training_provider',
  ServiceProviderType.financialServices: 'financial_services',
  ServiceProviderType.marketLinkage: 'market_linkage',
};

const _$UserStatusEnumMap = {
  UserStatus.pending: 'pending',
  UserStatus.active: 'active',
  UserStatus.suspended: 'suspended',
  UserStatus.deactivated: 'deactivated',
  UserStatus.banned: 'banned',
};

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      userId: json['userId'] as String,
      businessName: json['businessName'] as String,
      businessDescription: json['businessDescription'] as String,
      serviceCategories: (json['serviceCategories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      businessHours:
          BusinessHours.fromJson(json['businessHours'] as Map<String, dynamic>),
      contactInfo:
          ContactInfo.fromJson(json['contactInfo'] as Map<String, dynamic>),
      locationInfo:
          LocationInfo.fromJson(json['locationInfo'] as Map<String, dynamic>),
      businessLogo: json['businessLogo'] as String?,
      businessImages: (json['businessImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      certifications: (json['certifications'] as List<dynamic>?)
          ?.map((e) => Certification.fromJson(e as Map<String, dynamic>))
          .toList(),
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      paymentMethods: json['paymentMethods'] == null
          ? null
          : PaymentMethods.fromJson(
              json['paymentMethods'] as Map<String, dynamic>),
      socialMediaLinks: json['socialMediaLinks'] == null
          ? null
          : SocialMediaLinks.fromJson(
              json['socialMediaLinks'] as Map<String, dynamic>),
      settings: json['settings'] == null
          ? null
          : BusinessSettings.fromJson(json['settings'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'businessName': instance.businessName,
      'businessDescription': instance.businessDescription,
      'serviceCategories': instance.serviceCategories,
      'businessHours': instance.businessHours,
      'contactInfo': instance.contactInfo,
      'locationInfo': instance.locationInfo,
      'businessLogo': instance.businessLogo,
      'businessImages': instance.businessImages,
      'certifications': instance.certifications,
      'languages': instance.languages,
      'paymentMethods': instance.paymentMethods,
      'socialMediaLinks': instance.socialMediaLinks,
      'settings': instance.settings,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$BusinessHoursImpl _$$BusinessHoursImplFromJson(Map<String, dynamic> json) =>
    _$BusinessHoursImpl(
      monday: DaySchedule.fromJson(json['monday'] as Map<String, dynamic>),
      tuesday: DaySchedule.fromJson(json['tuesday'] as Map<String, dynamic>),
      wednesday:
          DaySchedule.fromJson(json['wednesday'] as Map<String, dynamic>),
      thursday: DaySchedule.fromJson(json['thursday'] as Map<String, dynamic>),
      friday: DaySchedule.fromJson(json['friday'] as Map<String, dynamic>),
      saturday: DaySchedule.fromJson(json['saturday'] as Map<String, dynamic>),
      sunday: DaySchedule.fromJson(json['sunday'] as Map<String, dynamic>),
      holidays: (json['holidays'] as List<dynamic>?)
          ?.map((e) => Holiday.fromJson(e as Map<String, dynamic>))
          .toList(),
      timezone: json['timezone'] as String?,
    );

Map<String, dynamic> _$$BusinessHoursImplToJson(_$BusinessHoursImpl instance) =>
    <String, dynamic>{
      'monday': instance.monday,
      'tuesday': instance.tuesday,
      'wednesday': instance.wednesday,
      'thursday': instance.thursday,
      'friday': instance.friday,
      'saturday': instance.saturday,
      'sunday': instance.sunday,
      'holidays': instance.holidays,
      'timezone': instance.timezone,
    };

_$DayScheduleImpl _$$DayScheduleImplFromJson(Map<String, dynamic> json) =>
    _$DayScheduleImpl(
      isOpen: json['isOpen'] as bool,
      openTime: json['openTime'] as String?,
      closeTime: json['closeTime'] as String?,
      breaks: (json['breaks'] as List<dynamic>?)
          ?.map((e) => BreakTime.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$DayScheduleImplToJson(_$DayScheduleImpl instance) =>
    <String, dynamic>{
      'isOpen': instance.isOpen,
      'openTime': instance.openTime,
      'closeTime': instance.closeTime,
      'breaks': instance.breaks,
    };

_$BreakTimeImpl _$$BreakTimeImplFromJson(Map<String, dynamic> json) =>
    _$BreakTimeImpl(
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$BreakTimeImplToJson(_$BreakTimeImpl instance) =>
    <String, dynamic>{
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'description': instance.description,
    };

_$HolidayImpl _$$HolidayImplFromJson(Map<String, dynamic> json) =>
    _$HolidayImpl(
      name: json['name'] as String,
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String?,
      isRecurring: json['isRecurring'] as bool?,
    );

Map<String, dynamic> _$$HolidayImplToJson(_$HolidayImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'date': instance.date.toIso8601String(),
      'description': instance.description,
      'isRecurring': instance.isRecurring,
    };

_$ContactInfoImpl _$$ContactInfoImplFromJson(Map<String, dynamic> json) =>
    _$ContactInfoImpl(
      primaryPhone: json['primaryPhone'] as String,
      secondaryPhone: json['secondaryPhone'] as String?,
      whatsappNumber: json['whatsappNumber'] as String?,
      email: json['email'] as String,
      website: json['website'] as String?,
      facebookPage: json['facebookPage'] as String?,
      instagramHandle: json['instagramHandle'] as String?,
      twitterHandle: json['twitterHandle'] as String?,
      linkedinProfile: json['linkedinProfile'] as String?,
    );

Map<String, dynamic> _$$ContactInfoImplToJson(_$ContactInfoImpl instance) =>
    <String, dynamic>{
      'primaryPhone': instance.primaryPhone,
      'secondaryPhone': instance.secondaryPhone,
      'whatsappNumber': instance.whatsappNumber,
      'email': instance.email,
      'website': instance.website,
      'facebookPage': instance.facebookPage,
      'instagramHandle': instance.instagramHandle,
      'twitterHandle': instance.twitterHandle,
      'linkedinProfile': instance.linkedinProfile,
    };

_$LocationInfoImpl _$$LocationInfoImplFromJson(Map<String, dynamic> json) =>
    _$LocationInfoImpl(
      county: json['county'] as String,
      subCounty: json['subCounty'] as String,
      ward: json['ward'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      serviceRadius: (json['serviceRadius'] as num?)?.toDouble(),
      serviceAreas: (json['serviceAreas'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      landmark: json['landmark'] as String?,
      directions: json['directions'] as String?,
    );

Map<String, dynamic> _$$LocationInfoImplToJson(_$LocationInfoImpl instance) =>
    <String, dynamic>{
      'county': instance.county,
      'subCounty': instance.subCounty,
      'ward': instance.ward,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'serviceRadius': instance.serviceRadius,
      'serviceAreas': instance.serviceAreas,
      'landmark': instance.landmark,
      'directions': instance.directions,
    };

_$CertificationImpl _$$CertificationImplFromJson(Map<String, dynamic> json) =>
    _$CertificationImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      issuingOrganization: json['issuingOrganization'] as String,
      issueDate: DateTime.parse(json['issueDate'] as String),
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      certificateNumber: json['certificateNumber'] as String?,
      certificateUrl: json['certificateUrl'] as String?,
      isVerified: json['isVerified'] as bool?,
    );

Map<String, dynamic> _$$CertificationImplToJson(_$CertificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'issuingOrganization': instance.issuingOrganization,
      'issueDate': instance.issueDate.toIso8601String(),
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'certificateNumber': instance.certificateNumber,
      'certificateUrl': instance.certificateUrl,
      'isVerified': instance.isVerified,
    };

_$PaymentMethodsImpl _$$PaymentMethodsImplFromJson(Map<String, dynamic> json) =>
    _$PaymentMethodsImpl(
      acceptsCash: json['acceptsCash'] as bool?,
      acceptsMpesa: json['acceptsMpesa'] as bool?,
      acceptsBankTransfer: json['acceptsBankTransfer'] as bool?,
      acceptsCard: json['acceptsCard'] as bool?,
      mpesaNumber: json['mpesaNumber'] as String?,
      bankName: json['bankName'] as String?,
      accountNumber: json['accountNumber'] as String?,
      accountName: json['accountName'] as String?,
      supportedCards: (json['supportedCards'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$PaymentMethodsImplToJson(
        _$PaymentMethodsImpl instance) =>
    <String, dynamic>{
      'acceptsCash': instance.acceptsCash,
      'acceptsMpesa': instance.acceptsMpesa,
      'acceptsBankTransfer': instance.acceptsBankTransfer,
      'acceptsCard': instance.acceptsCard,
      'mpesaNumber': instance.mpesaNumber,
      'bankName': instance.bankName,
      'accountNumber': instance.accountNumber,
      'accountName': instance.accountName,
      'supportedCards': instance.supportedCards,
    };

_$SocialMediaLinksImpl _$$SocialMediaLinksImplFromJson(
        Map<String, dynamic> json) =>
    _$SocialMediaLinksImpl(
      facebook: json['facebook'] as String?,
      instagram: json['instagram'] as String?,
      twitter: json['twitter'] as String?,
      linkedin: json['linkedin'] as String?,
      youtube: json['youtube'] as String?,
      tiktok: json['tiktok'] as String?,
      website: json['website'] as String?,
    );

Map<String, dynamic> _$$SocialMediaLinksImplToJson(
        _$SocialMediaLinksImpl instance) =>
    <String, dynamic>{
      'facebook': instance.facebook,
      'instagram': instance.instagram,
      'twitter': instance.twitter,
      'linkedin': instance.linkedin,
      'youtube': instance.youtube,
      'tiktok': instance.tiktok,
      'website': instance.website,
    };

_$BusinessSettingsImpl _$$BusinessSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$BusinessSettingsImpl(
      autoAcceptBookings: json['autoAcceptBookings'] as bool?,
      maxBookingsPerDay: (json['maxBookingsPerDay'] as num?)?.toInt(),
      advanceBookingDays: (json['advanceBookingDays'] as num?)?.toInt(),
      cancellationHours: (json['cancellationHours'] as num?)?.toInt(),
      requireDeposit: json['requireDeposit'] as bool?,
      depositPercentage: (json['depositPercentage'] as num?)?.toDouble(),
      sendReminders: json['sendReminders'] as bool?,
      reminderHours: (json['reminderHours'] as num?)?.toInt(),
      allowOnlinePayment: json['allowOnlinePayment'] as bool?,
      allowInstantBooking: json['allowInstantBooking'] as bool?,
      cancellationPolicy: json['cancellationPolicy'] as String?,
      refundPolicy: json['refundPolicy'] as String?,
    );

Map<String, dynamic> _$$BusinessSettingsImplToJson(
        _$BusinessSettingsImpl instance) =>
    <String, dynamic>{
      'autoAcceptBookings': instance.autoAcceptBookings,
      'maxBookingsPerDay': instance.maxBookingsPerDay,
      'advanceBookingDays': instance.advanceBookingDays,
      'cancellationHours': instance.cancellationHours,
      'requireDeposit': instance.requireDeposit,
      'depositPercentage': instance.depositPercentage,
      'sendReminders': instance.sendReminders,
      'reminderHours': instance.reminderHours,
      'allowOnlinePayment': instance.allowOnlinePayment,
      'allowInstantBooking': instance.allowInstantBooking,
      'cancellationPolicy': instance.cancellationPolicy,
      'refundPolicy': instance.refundPolicy,
    };
