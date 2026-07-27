// property_payload.dart

class OwnerPropertListingPayload {
  final String? listingAs;
  final String? category;
  final String? listingFor;
  final String? propertyType;
  final String? title;
  final String? city;
  final String? locality;
  final String? fullAddress;
  final String? pincode;
  final String? description;
  final String? bedrooms;
  final String? bathrooms;
  final int? carpetArea;
  final int? builtUpArea;
  final String? floorNo;
  final String? totalFloors;
  final String? ageOfProperty;
  final String? furnishing;
  final String? facingDirection;
  final String? parking;
  final List<String>? amenities;
  final List<String>? preferredTenants;
  final bool? petsAllowed;
  final bool? smokingAllowed;
  final String? noticePeriod;
  final String? availableFrom;
  final List<String>? images;
  final int? price;
  final int? securityDeposit;
  final int? maintenanceCharges;
  final bool? maintenanceIncludedInRent;
  final int? brokerageFee;
  final bool? vastuCompliant;
  final bool? openToAllBuyers;
  final bool? loanAssistanceNeeded;
  final String? listingTier;
  final LocationPayload? location;

  OwnerPropertListingPayload({
    this.listingAs,
    this.category,
    this.listingFor,
    this.propertyType,
    this.title,
    this.city,
    this.locality,
    this.fullAddress,
    this.pincode,
    this.description,
    this.bedrooms,
    this.bathrooms,
    this.carpetArea,
    this.builtUpArea,
    this.floorNo,
    this.totalFloors,
    this.ageOfProperty,
    this.furnishing,
    this.facingDirection,
    this.parking,
    this.amenities,
    this.preferredTenants,
    this.petsAllowed,
    this.smokingAllowed,
    this.noticePeriod,
    this.availableFrom,
    this.images,
    this.price,
    this.securityDeposit,
    this.maintenanceCharges,
    this.maintenanceIncludedInRent,
    this.brokerageFee,
    this.vastuCompliant,
    this.openToAllBuyers,
    this.loanAssistanceNeeded,
    this.listingTier,
    this.location,
  });

  factory OwnerPropertListingPayload.fromJson(Map<String, dynamic> json) {
    return OwnerPropertListingPayload(
      listingAs: json["listingAs"]?.toString(),
      category: json["category"]?.toString(),
      listingFor: json["listingFor"]?.toString(),
      propertyType: json["propertyType"]?.toString(),
      title: json["title"]?.toString(),
      city: json["city"]?.toString(),
      locality: json["locality"]?.toString(),
      fullAddress: json["fullAddress"]?.toString(),
      pincode: json["pincode"]?.toString(),
      description: json["description"]?.toString(),
      bedrooms: json["bedrooms"]?.toString(),
      bathrooms: json["bathrooms"]?.toString(),
      carpetArea: json["carpetArea"] as int?,
      builtUpArea: json["builtUpArea"] as int?,
      floorNo: json["floorNo"]?.toString(),
      totalFloors: json["totalFloors"]?.toString(),
      ageOfProperty: json["ageOfProperty"]?.toString(),
      furnishing: json["furnishing"]?.toString(),
      facingDirection: json["facingDirection"]?.toString(),
      parking: json["parking"]?.toString(),
      amenities: json["amenities"] is List
          ? List<String>.from(json["amenities"])
          : null,
      preferredTenants: json["preferredTenants"] is List
          ? List<String>.from(json["preferredTenants"])
          : null,
      petsAllowed: json["petsAllowed"] as bool?,
      smokingAllowed: json["smokingAllowed"] as bool?,
      noticePeriod: json["noticePeriod"]?.toString(),
      availableFrom: json["availableFrom"]?.toString(),
      images: json["images"] is List
          ? List<String>.from(json["images"])
          : null,
      price: json["price"] as int?,
      securityDeposit: json["securityDeposit"] as int?,
      maintenanceCharges: json["maintenanceCharges"] as int?,
      maintenanceIncludedInRent: json["maintenanceIncludedInRent"] as bool?,
      brokerageFee: json["brokerageFee"] as int?,
      vastuCompliant: json["vastuCompliant"] as bool?,
      openToAllBuyers: json["openToAllBuyers"] as bool?,
      loanAssistanceNeeded: json["loanAssistanceNeeded"] as bool?,
      listingTier: json["listingTier"]?.toString(),
      location: json["location"] is Map
          ? LocationPayload.fromJson(Map<String, dynamic>.from(json["location"]))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "listingAs": listingAs,
      "category": category,
      "listingFor": listingFor,
      "propertyType": propertyType,
      "title": title,
      "city": city,
      "locality": locality,
      "fullAddress": fullAddress,
      "pincode": pincode,
      "description": description,
      "bedrooms": bedrooms,
      "bathrooms": bathrooms,
      "carpetArea": carpetArea,
      "builtUpArea": builtUpArea,
      "floorNo": floorNo,
      "totalFloors": totalFloors,
      "ageOfProperty": ageOfProperty,
      "furnishing": furnishing,
      "facingDirection": facingDirection,
      "parking": parking,
      "amenities": amenities,
      "preferredTenants": preferredTenants,
      "petsAllowed": petsAllowed,
      "smokingAllowed": smokingAllowed,
      "noticePeriod": noticePeriod,
      "availableFrom": availableFrom,
      "images": images,
      "price": price,
      "securityDeposit": securityDeposit,
      "maintenanceCharges": maintenanceCharges,
      "maintenanceIncludedInRent": maintenanceIncludedInRent,
      "brokerageFee": brokerageFee,
      "vastuCompliant": vastuCompliant,
      "openToAllBuyers": openToAllBuyers,
      "loanAssistanceNeeded": loanAssistanceNeeded,
      "listingTier": listingTier,
      "location": location?.toJson(),
    };
  }

  // Helper method to create a copy with updated fields
  OwnerPropertListingPayload copyWith({
    String? listingAs,
    String? category,
    String? listingFor,
    String? propertyType,
    String? title,
    String? city,
    String? locality,
    String? fullAddress,
    String? pincode,
    String? description,
    String? bedrooms,
    String? bathrooms,
    int? carpetArea,
    int? builtUpArea,
    String? floorNo,
    String? totalFloors,
    String? ageOfProperty,
    String? furnishing,
    String? facingDirection,
    String? parking,
    List<String>? amenities,
    List<String>? preferredTenants,
    bool? petsAllowed,
    bool? smokingAllowed,
    String? noticePeriod,
    String? availableFrom,
    List<String>? images,
    int? price,
    int? securityDeposit,
    int? maintenanceCharges,
    bool? maintenanceIncludedInRent,
    int? brokerageFee,
    bool? vastuCompliant,
    bool? openToAllBuyers,
    bool? loanAssistanceNeeded,
    String? listingTier,
    LocationPayload? location,
  }) {
    return OwnerPropertListingPayload(
      listingAs: listingAs ?? this.listingAs,
      category: category ?? this.category,
      listingFor: listingFor ?? this.listingFor,
      propertyType: propertyType ?? this.propertyType,
      title: title ?? this.title,
      city: city ?? this.city,
      locality: locality ?? this.locality,
      fullAddress: fullAddress ?? this.fullAddress,
      pincode: pincode ?? this.pincode,
      description: description ?? this.description,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      carpetArea: carpetArea ?? this.carpetArea,
      builtUpArea: builtUpArea ?? this.builtUpArea,
      floorNo: floorNo ?? this.floorNo,
      totalFloors: totalFloors ?? this.totalFloors,
      ageOfProperty: ageOfProperty ?? this.ageOfProperty,
      furnishing: furnishing ?? this.furnishing,
      facingDirection: facingDirection ?? this.facingDirection,
      parking: parking ?? this.parking,
      amenities: amenities ?? this.amenities,
      preferredTenants: preferredTenants ?? this.preferredTenants,
      petsAllowed: petsAllowed ?? this.petsAllowed,
      smokingAllowed: smokingAllowed ?? this.smokingAllowed,
      noticePeriod: noticePeriod ?? this.noticePeriod,
      availableFrom: availableFrom ?? this.availableFrom,
      images: images ?? this.images,
      price: price ?? this.price,
      securityDeposit: securityDeposit ?? this.securityDeposit,
      maintenanceCharges: maintenanceCharges ?? this.maintenanceCharges,
      maintenanceIncludedInRent: maintenanceIncludedInRent ?? this.maintenanceIncludedInRent,
      brokerageFee: brokerageFee ?? this.brokerageFee,
      vastuCompliant: vastuCompliant ?? this.vastuCompliant,
      openToAllBuyers: openToAllBuyers ?? this.openToAllBuyers,
      loanAssistanceNeeded: loanAssistanceNeeded ?? this.loanAssistanceNeeded,
      listingTier: listingTier ?? this.listingTier,
      location: location ?? this.location,
    );
  }
}

class LocationPayload {
  final String? type;
  final List<double>? coordinates;

  const LocationPayload({
    this.type,
    this.coordinates,
  });

  factory LocationPayload.fromJson(Map<String, dynamic> json) {
    return LocationPayload(
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
    return {
      "type": type,
      "coordinates": coordinates,
    };
  }

  LocationPayload copyWith({
    String? type,
    List<double>? coordinates,
  }) {
    return LocationPayload(
      type: type ?? this.type,
      coordinates: coordinates ?? this.coordinates,
    );
  }

  // Helper to create location from latitude and longitude
  factory LocationPayload.fromLatLng({
    required double latitude,
    required double longitude,
    String type = 'Point',
  }) {
    return LocationPayload(
      type: type,
      coordinates: [longitude, latitude],
    );
  }

  double? get latitude {
    if (coordinates == null || coordinates!.length < 2) {
      return null;
    }
    return coordinates![1];
  }

  double? get longitude {
    if (coordinates == null || coordinates!.isEmpty) {
      return null;
    }
    return coordinates![0];
  }
}