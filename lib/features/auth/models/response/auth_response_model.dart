class AuthResponseModel {
  final String? status;
  final String? message;
  final String? token;
  final bool? needsBasicInfo;
  final bool? isBasicInfoCompleted;
  final bool? isOnboardingCompleted;
  final bool? isNewUser;
  final bool? accountNotFound;
  final bool? accountExists;
  final String? phone;
  final String? otp;
  final String? nextScreen;
  final AuthDataModel? data;

  const AuthResponseModel({
    this.status,
    this.message,
    this.token,
    this.needsBasicInfo,
    this.isBasicInfoCompleted,
    this.isOnboardingCompleted,
    this.isNewUser,
    this.accountNotFound,
    this.accountExists,
    this.phone,
    this.otp,
    this.nextScreen,
    this.data,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    AuthDataModel? data;
    if (json["data"] is Map) {
      data = AuthDataModel.fromJson(Map<String, dynamic>.from(json["data"]));
    } else if (json["user"] is Map) {
      data = AuthDataModel(
        user: AuthUserModel.fromJson(Map<String, dynamic>.from(json["user"])),
      );
    }

    return AuthResponseModel(
      status:
          json["status"]?.toString() ??
          (json["success"] == true ? "success" : null),
      message: json["message"]?.toString(),
      token: json["token"]?.toString(),
      needsBasicInfo: json["needsBasicInfo"] is bool
          ? json["needsBasicInfo"]
          : null,
      isBasicInfoCompleted: json["isBasicInfoCompleted"] is bool
          ? json["isBasicInfoCompleted"]
          : null,
      isOnboardingCompleted: json["isOnboardingCompleted"] is bool
          ? json["isOnboardingCompleted"]
          : null,
      isNewUser: json["isNewUser"] is bool
          ? json["isNewUser"]
          : (json["nextScreen"] == "register" || json["nextScreen"] == "basic_info"),
      accountNotFound: json["accountNotFound"] is bool
          ? json["accountNotFound"]
          : null,
      accountExists: json["accountExists"] is bool
          ? json["accountExists"]
          : null,
      phone: json["phone"]?.toString() ??
          json["verifiedPhone"]?.toString() ??
          (json["data"] is Map ? json["data"]["phone"]?.toString() : null),
      otp:
          json["otp"]?.toString() ??
          (json["data"] is Map ? json["data"]["otp"]?.toString() : null),
      nextScreen: json["nextScreen"]?.toString(),
      data: data,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "token": token,
      "needsBasicInfo": needsBasicInfo,
      "isBasicInfoCompleted": isBasicInfoCompleted,
      "isOnboardingCompleted": isOnboardingCompleted,
      "nextScreen": nextScreen,
      "data": data?.toJson(),
    };
  }
}

class AuthDataModel {
  final AuthUserModel? user;

  const AuthDataModel({this.user});

  factory AuthDataModel.fromJson(Map<String, dynamic> json) {
    return AuthDataModel(
      user: json["user"] is Map
          ? AuthUserModel.fromJson(Map<String, dynamic>.from(json["user"]))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {"user": user?.toJson()};
  }
}

class AuthUserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? role;
  final String? profilePicture;
  final String? authProvider;
  final AddressModel? address;
  final LocationModel? location;
  final bool? isBasicInfoCompleted;
  final bool? isOnboardingCompleted;

  const AuthUserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.profilePicture,
    this.authProvider,
    this.address,
    this.location,
    this.isBasicInfoCompleted,
    this.isOnboardingCompleted,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: (json["id"] ?? json["_id"])?.toString(),
      name: json["name"]?.toString(),
      email: json["email"]?.toString(),
      phone: json["phone"]?.toString(),
      role: json["role"]?.toString(),
      profilePicture: json["profilePicture"]?.toString(),
      authProvider: json["authProvider"]?.toString(),
      address: json["address"] is Map
          ? AddressModel.fromJson(Map<String, dynamic>.from(json["address"]))
          : null,
      location: json["location"] is Map
          ? LocationModel.fromJson(Map<String, dynamic>.from(json["location"]))
          : null,
      isBasicInfoCompleted: json["isBasicInfoCompleted"] is bool
          ? json["isBasicInfoCompleted"]
          : null,
      isOnboardingCompleted: json["isOnboardingCompleted"] is bool
          ? json["isOnboardingCompleted"]
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "role": role,
      "profilePicture": profilePicture,
      "authProvider": authProvider,
      "address": address?.toJson(),
      "location": location?.toJson(),
      "isBasicInfoCompleted": isBasicInfoCompleted,
      "isOnboardingCompleted": isOnboardingCompleted,
    };
  }
}

class AddressModel {
  final String? formattedAddress;
  final String? city;
  final String? state;
  final String? pincode;

  const AddressModel({
    this.formattedAddress,
    this.city,
    this.state,
    this.pincode,
  });

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
}

class LocationModel {
  final String? type;
  final List<double>? coordinates;

  const LocationModel({this.type, this.coordinates});

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
