// user_profile_response.dart

import 'dart:ui';

import 'package:flutter/material.dart';

class UserProfileResponse {
  final String? status;
  final UserProfileData? data;

  UserProfileResponse({this.status, this.data});

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      status: json["status"]?.toString(),
      data: json["data"] is Map
          ? UserProfileData.fromJson(Map<String, dynamic>.from(json["data"]))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {"status": status, "data": data?.toJson()};
  }
}

class UserProfileData {
  final UserModel? user;

  UserProfileData({this.user});

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      user: json["user"] is Map
          ? UserModel.fromJson(Map<String, dynamic>.from(json["user"]))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {"user": user?.toJson()};
  }
}

class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? role;
  final String? agentVerificationStatus;
  final String? builderVerificationStatus;
  final bool? isOnboardingCompleted;
  final String? profilePicture;
  final bool? isVerified;
  final String? authProvider;
  final List<String>? intents;
  final AddressModel? address;
  final LocationModel? location;
  final PreferencesModel? preferences;
  final NotificationSettingsModel? notificationSettings;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? version;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.agentVerificationStatus,
    this.builderVerificationStatus,
    this.isOnboardingCompleted,
    this.profilePicture,
    this.isVerified,
    this.authProvider,
    this.intents,
    this.address,
    this.location,
    this.preferences,
    this.notificationSettings,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"]?.toString() ?? json["id"]?.toString(),
      name: json["name"]?.toString(),
      email: json["email"]?.toString(),
      phone: json["phone"]?.toString(),
      role: json["role"]?.toString(),
      agentVerificationStatus: json["agentVerificationStatus"]?.toString(),
      builderVerificationStatus: json["builderVerificationStatus"]?.toString(),
      isOnboardingCompleted: json["isOnboardingCompleted"] as bool?,
      profilePicture: json["profilePicture"]?.toString(),
      isVerified: json["isVerified"] as bool?,
      authProvider: json["authProvider"]?.toString(),
      intents: json["intents"] is List
          ? List<String>.from(json["intents"])
          : null,
      address: json["address"] is Map
          ? AddressModel.fromJson(Map<String, dynamic>.from(json["address"]))
          : null,
      location: json["location"] is Map
          ? LocationModel.fromJson(Map<String, dynamic>.from(json["location"]))
          : null,
      preferences: json["preferences"] is Map
          ? PreferencesModel.fromJson(
              Map<String, dynamic>.from(json["preferences"]),
            )
          : null,
      notificationSettings: json["notificationSettings"] is Map
          ? NotificationSettingsModel.fromJson(
              Map<String, dynamic>.from(json["notificationSettings"]),
            )
          : null,
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"].toString())
          : null,
      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"].toString())
          : null,
      version: json["__v"] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "role": role,
      "agentVerificationStatus": agentVerificationStatus,
      "builderVerificationStatus": builderVerificationStatus,
      "isOnboardingCompleted": isOnboardingCompleted,
      "profilePicture": profilePicture,
      "isVerified": isVerified,
      "authProvider": authProvider,
      "intents": intents,
      "address": address?.toJson(),
      "location": location?.toJson(),
      "preferences": preferences?.toJson(),
      "notificationSettings": notificationSettings?.toJson(),
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "__v": version,
    };
  }

  // Helper methods
  bool get isBuyer => role?.toLowerCase() == 'buyer';
  bool get isAgent => role?.toLowerCase() == 'agent';
  bool get isBuilder => role?.toLowerCase() == 'builder';

  bool get isAgentVerified =>
      agentVerificationStatus?.toLowerCase() == 'verified';
  bool get isBuilderVerified =>
      builderVerificationStatus?.toLowerCase() == 'verified';

  bool get hasCompletedOnboarding => isOnboardingCompleted ?? false;

  String get displayName => name ?? 'User';
  String get initialLetter =>
      name?.isNotEmpty == true ? name![0].toUpperCase() : 'U';

  String get verificationStatus {
    if (isAgentVerified) return 'Agent Verified';
    if (isBuilderVerified) return 'Builder Verified';
    if (role?.toLowerCase() == 'agent') return 'Agent (Unverified)';
    if (role?.toLowerCase() == 'builder') return 'Builder (Unverified)';
    return 'Verified User';
  }
}

class AddressModel {
  final String? formattedAddress;
  final String? city;
  final String? state;
  final String? pincode;

  AddressModel({this.formattedAddress, this.city, this.state, this.pincode});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      formattedAddress: json["formattedAddress"]?.toString(),
      city: json["city"]?.toString(),
      state: json["state"]?.toString(),
      pincode: json["pincode"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "formattedAddress": formattedAddress,
      "city": city,
      "state": state,
      "pincode": pincode,
    };
  }

  String get fullAddress => formattedAddress ?? '$city, $state - $pincode';
}

class LocationModel {
  final String? type;
  final List<double>? coordinates;

  LocationModel({this.type, this.coordinates});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      type: json["type"]?.toString(),
      coordinates: json["coordinates"] is List
          ? (json["coordinates"] as List)
                .whereType<num>()
                .map((value) => value.toDouble())
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {"type": type, "coordinates": coordinates};
  }

  double? get longitude {
    if (coordinates == null || coordinates!.isEmpty) {
      return null;
    }
    return coordinates![0];
  }

  double? get latitude {
    if (coordinates == null || coordinates!.length < 2) {
      return null;
    }
    return coordinates![1];
  }
}

class PreferencesModel {
  final List<String>? preferredCities;
  final List<String>? propertyTypes;
  final int? minBudget;
  final int? maxBudget;
  final List<String>? bedrooms;

  PreferencesModel({
    this.preferredCities,
    this.propertyTypes,
    this.minBudget,
    this.maxBudget,
    this.bedrooms,
  });

  factory PreferencesModel.fromJson(Map<String, dynamic> json) {
    return PreferencesModel(
      preferredCities: json["preferredCities"] is List
          ? List<String>.from(json["preferredCities"])
          : null,
      propertyTypes: json["propertyTypes"] is List
          ? List<String>.from(json["propertyTypes"])
          : null,
      minBudget: json["minBudget"] as int?,
      maxBudget: json["maxBudget"] as int?,
      bedrooms: json["bedrooms"] is List
          ? List<String>.from(json["bedrooms"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "preferredCities": preferredCities,
      "propertyTypes": propertyTypes,
      "minBudget": minBudget,
      "maxBudget": maxBudget,
      "bedrooms": bedrooms,
    };
  }

  String get budgetRange {
    if (minBudget == null && maxBudget == null) return 'No budget set';
    if (minBudget == null) return 'Up to ₹${maxBudget}L';
    if (maxBudget == null) return '₹${minBudget}L+';
    return '₹${minBudget}L - ₹${maxBudget}L';
  }

  String get preferredCitiesDisplay {
    if (preferredCities == null || preferredCities!.isEmpty) {
      return 'No cities selected';
    }
    return preferredCities!.join(', ');
  }

  String get propertyTypesDisplay {
    if (propertyTypes == null || propertyTypes!.isEmpty) {
      return 'No property types selected';
    }
    return propertyTypes!.join(', ');
  }
}

class NotificationSettingsModel {
  final bool? priceDropAlerts;
  final bool? newListingAlerts;
  final bool? bookingUpdates;
  final bool? platformUpdates;

  NotificationSettingsModel({
    this.priceDropAlerts,
    this.newListingAlerts,
    this.bookingUpdates,
    this.platformUpdates,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      priceDropAlerts: json["priceDropAlerts"] as bool?,
      newListingAlerts: json["newListingAlerts"] as bool?,
      bookingUpdates: json["bookingUpdates"] as bool?,
      platformUpdates: json["platformUpdates"] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "priceDropAlerts": priceDropAlerts,
      "newListingAlerts": newListingAlerts,
      "bookingUpdates": bookingUpdates,
      "platformUpdates": platformUpdates,
    };
  }

  int get enabledCount {
    int count = 0;
    if (priceDropAlerts == true) count++;
    if (newListingAlerts == true) count++;
    if (bookingUpdates == true) count++;
    if (platformUpdates == true) count++;
    return count;
  }

  int get totalCount => 4;
}

// ─── Enums for better type safety ────────────────────────────────────────────

enum UserRole { buyer, agent, builder, admin }

enum VerificationStatus { verified, unverified, pending, rejected }

enum Intent { buy, sell, rent, exploreProjects }

enum AuthProvider { mobile, email, google, facebook }

extension UserRoleExtension on UserRole {
  String get value {
    switch (this) {
      case UserRole.buyer:
        return 'buyer';
      case UserRole.agent:
        return 'agent';
      case UserRole.builder:
        return 'builder';
      case UserRole.admin:
        return 'admin';
    }
  }

  static UserRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'buyer':
        return UserRole.buyer;
      case 'agent':
        return UserRole.agent;
      case 'builder':
        return UserRole.builder;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.buyer;
    }
  }

  String get displayName {
    switch (this) {
      case UserRole.buyer:
        return 'Buyer';
      case UserRole.agent:
        return 'Real Estate Agent';
      case UserRole.builder:
        return 'Builder/Developer';
      case UserRole.admin:
        return 'Admin';
    }
  }
}

extension VerificationStatusExtension on VerificationStatus {
  String get value {
    switch (this) {
      case VerificationStatus.verified:
        return 'verified';
      case VerificationStatus.unverified:
        return 'unverified';
      case VerificationStatus.pending:
        return 'pending';
      case VerificationStatus.rejected:
        return 'rejected';
    }
  }

  static VerificationStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'verified':
        return VerificationStatus.verified;
      case 'unverified':
        return VerificationStatus.unverified;
      case 'pending':
        return VerificationStatus.pending;
      case 'rejected':
        return VerificationStatus.rejected;
      default:
        return VerificationStatus.unverified;
    }
  }

  String get displayName {
    switch (this) {
      case VerificationStatus.verified:
        return 'Verified';
      case VerificationStatus.unverified:
        return 'Unverified';
      case VerificationStatus.pending:
        return 'Pending Verification';
      case VerificationStatus.rejected:
        return 'Verification Rejected';
    }
  }

  Color get color {
    switch (this) {
      case VerificationStatus.verified:
        return Colors.green;
      case VerificationStatus.unverified:
        return Colors.grey;
      case VerificationStatus.pending:
        return Colors.orange;
      case VerificationStatus.rejected:
        return Colors.red;
    }
  }
}
