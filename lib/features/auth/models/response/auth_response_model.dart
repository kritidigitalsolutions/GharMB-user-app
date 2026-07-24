class AuthResponseModel {
  final String? status;
  final String? token;
  final AuthDataModel? data;

  const AuthResponseModel({this.status, this.token, this.data});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      status: json["status"]?.toString(),
      token: json["token"]?.toString(),
      data: json["data"] is Map
          ? AuthDataModel.fromJson(Map<String, dynamic>.from(json["data"]))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {"status": status, "token": token, "data": data?.toJson()};
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
  final AddressModel? address;
  final LocationModel? location;
  final bool? isOnboardingCompleted;

  const AuthUserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.location,
    this.isOnboardingCompleted,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json["id"]?.toString(),
      name: json["name"]?.toString(),
      email: json["email"]?.toString(),
      phone: json["phone"]?.toString(),
      address: json["address"] is Map
          ? AddressModel.fromJson(Map<String, dynamic>.from(json["address"]))
          : null,
      location: json["location"] is Map
          ? LocationModel.fromJson(Map<String, dynamic>.from(json["location"]))
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
      "address": address?.toJson(),
      "location": location?.toJson(),
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
