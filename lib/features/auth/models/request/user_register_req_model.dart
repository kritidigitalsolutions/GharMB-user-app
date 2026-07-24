class UserRegisterReqModel {
  final String? name;
  final String? email;
  final String? phone;
  final AddressReqModel? address;
  final double? latitude;
  final double? longitude;
  final String? role;
  final List<String>? intents;
  final PreferencesReqModel? preferences;
  final NotificationSettingsReqModel? notificationSettings;

  const UserRegisterReqModel({
    this.name,
    this.email,
    this.phone,
    this.address,
    this.latitude,
    this.longitude,
    this.role,
    this.intents,
    this.preferences,
    this.notificationSettings,
  });

  factory UserRegisterReqModel.fromJson(Map<String, dynamic> json) {
    return UserRegisterReqModel(
      name: json["name"]?.toString(),
      email: json["email"]?.toString(),
      phone: json["phone"]?.toString(),

      address: json["address"] is Map
          ? AddressReqModel.fromJson(Map<String, dynamic>.from(json["address"]))
          : null,

      latitude: _toDouble(json["latitude"]),
      longitude: _toDouble(json["longitude"]),

      role: json["role"]?.toString(),
      intents: _toStringList(json["intents"]),

      preferences: json["preferences"] is Map
          ? PreferencesReqModel.fromJson(
              Map<String, dynamic>.from(json["preferences"]),
            )
          : null,

      notificationSettings: json["notificationSettings"] is Map
          ? NotificationSettingsReqModel.fromJson(
              Map<String, dynamic>.from(json["notificationSettings"]),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (name != null) "name": name,
      if (email != null) "email": email,
      if (phone != null) "phone": phone,
      if (address != null) "address": address!.toJson(),
      if (latitude != null) "latitude": latitude,
      if (longitude != null) "longitude": longitude,
      if (role != null) "role": role,
      if (intents != null) "intents": intents,
      if (preferences != null) "preferences": preferences!.toJson(),
      if (notificationSettings != null)
        "notificationSettings": notificationSettings!.toJson(),
    };
  }
}

class AddressReqModel {
  final String? formattedAddress;
  final String? city;
  final String? state;
  final String? pincode;

  const AddressReqModel({
    this.formattedAddress,
    this.city,
    this.state,
    this.pincode,
  });

  factory AddressReqModel.fromJson(Map<String, dynamic> json) {
    return AddressReqModel(
      formattedAddress: json["formattedAddress"]?.toString(),
      city: json["city"]?.toString(),
      state: json["state"]?.toString(),
      pincode: json["pincode"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (formattedAddress != null) "formattedAddress": formattedAddress,
      if (city != null) "city": city,
      if (state != null) "state": state,
      if (pincode != null) "pincode": pincode,
    };
  }
}

class PreferencesReqModel {
  final List<String>? propertyTypes;
  final num? minBudget;
  final num? maxBudget;
  final List<String>? preferredCities;
  final List<String>? bedrooms;

  const PreferencesReqModel({
    this.propertyTypes,
    this.minBudget,
    this.maxBudget,
    this.preferredCities,
    this.bedrooms,
  });

  factory PreferencesReqModel.fromJson(Map<String, dynamic> json) {
    return PreferencesReqModel(
      propertyTypes: _toStringList(json["propertyTypes"]),
      minBudget: _toNum(json["minBudget"]),
      maxBudget: _toNum(json["maxBudget"]),
      preferredCities: _toStringList(json["preferredCities"]),
      bedrooms: _toStringList(json["bedrooms"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (propertyTypes != null) "propertyTypes": propertyTypes,
      if (minBudget != null) "minBudget": minBudget,
      if (maxBudget != null) "maxBudget": maxBudget,
      if (preferredCities != null) "preferredCities": preferredCities,
      if (bedrooms != null) "bedrooms": bedrooms,
    };
  }
}

class NotificationSettingsReqModel {
  final bool? priceDropAlerts;
  final bool? newListingAlerts;
  final bool? bookingUpdates;
  final bool? platformUpdates;

  const NotificationSettingsReqModel({
    this.priceDropAlerts,
    this.newListingAlerts,
    this.bookingUpdates,
    this.platformUpdates,
  });

  factory NotificationSettingsReqModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsReqModel(
      priceDropAlerts: _toBool(json["priceDropAlerts"]),
      newListingAlerts: _toBool(json["newListingAlerts"]),
      bookingUpdates: _toBool(json["bookingUpdates"]),
      platformUpdates: _toBool(json["platformUpdates"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (priceDropAlerts != null) "priceDropAlerts": priceDropAlerts,
      if (newListingAlerts != null) "newListingAlerts": newListingAlerts,
      if (bookingUpdates != null) "bookingUpdates": bookingUpdates,
      if (platformUpdates != null) "platformUpdates": platformUpdates,
    };
  }
}

List<String>? _toStringList(dynamic value) {
  if (value is! List) return null;

  return value
      .where((item) => item != null)
      .map((item) => item.toString())
      .toList();
}

double? _toDouble(dynamic value) {
  if (value == null) return null;

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value.toString());
}

num? _toNum(dynamic value) {
  if (value == null) return null;

  if (value is num) {
    return value;
  }

  return num.tryParse(value.toString());
}

bool? _toBool(dynamic value) {
  if (value == null) return null;

  if (value is bool) {
    return value;
  }

  if (value.toString().toLowerCase() == "true") {
    return true;
  }

  if (value.toString().toLowerCase() == "false") {
    return false;
  }

  return null;
}
