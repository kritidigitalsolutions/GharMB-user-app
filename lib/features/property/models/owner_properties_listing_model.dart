// property_listing_response.dart

class PropertyListingResponse {
  final String? status;
  final String? message;
  final PropertyListingData? data;

  PropertyListingResponse({
    this.status,
    this.message,
    this.data,
  });

  factory PropertyListingResponse.fromJson(Map<String, dynamic> json) {
    return PropertyListingResponse(
      status: json["status"]?.toString(),
      message: json["message"]?.toString(),
      data: json["data"] is Map
          ? PropertyListingData.fromJson(Map<String, dynamic>.from(json["data"]))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "data": data?.toJson(),
    };
  }
}

class PropertyListingData {
  final String? submissionId;
  final PropertyModel? property;

  PropertyListingData({
    this.submissionId,
    this.property,
  });

  factory PropertyListingData.fromJson(Map<String, dynamic> json) {
    return PropertyListingData(
      submissionId: json["submissionId"]?.toString(),
      property: json["property"] is Map
          ? PropertyModel.fromJson(Map<String, dynamic>.from(json["property"]))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "submissionId": submissionId,
      "property": property?.toJson(),
    };
  }
}

class PropertyModel {
  // Basic Info
  final String? id;
  final String? submissionId;
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
  
  // Room Details
  final String? bedrooms;
  final String? bathrooms;
  
  // Area Details
  final int? carpetArea;
  final int? builtUpArea;
  
  // Floor Details
  final String? floorNo;
  final String? totalFloors;
  final String? ageOfProperty;
  final String? furnishing;
  final String? facingDirection;
  final String? parking;
  
  // Amenities & Preferences
  final List<String>? amenities;
  final List<String>? preferredTenants;
  final bool? petsAllowed;
  final bool? smokingAllowed;
  
  // Rental Details
  final String? noticePeriod;
  final bool? brokerageFree;
  final bool? rentNegotiable;
  final String? availableFrom;
  
  // Images
  final List<String>? images;
  
  // Pricing
  final int? price;
  final int? securityDeposit;
  final int? maintenanceCharges;
  final bool? maintenanceIncludedInRent;
  final int? brokerageFee;
  final int? otherCharges;
  
  // Additional Features
  final bool? vastuCompliant;
  final bool? openToAllBuyers;
  final bool? loanAssistanceNeeded;
  final String? listingTier;
  
  // Location
  final LocationModel? location;
  
  // Owner & Status
  final String? owner;
  final String? approvalStatus;
  final bool? isLive;
  
  // Analytics
  final int? viewsCount;
  final int? shortlistedCount;
  final int? inquiriesCount;
  final int? tokensCount;
  
  // Timestamps
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? version;

  PropertyModel({
    this.id,
    this.submissionId,
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
    this.brokerageFree,
    this.rentNegotiable,
    this.availableFrom,
    this.images,
    this.price,
    this.securityDeposit,
    this.maintenanceCharges,
    this.maintenanceIncludedInRent,
    this.brokerageFee,
    this.otherCharges,
    this.vastuCompliant,
    this.openToAllBuyers,
    this.loanAssistanceNeeded,
    this.listingTier,
    this.location,
    this.owner,
    this.approvalStatus,
    this.isLive,
    this.viewsCount,
    this.shortlistedCount,
    this.inquiriesCount,
    this.tokensCount,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json["id"]?.toString() ?? json["_id"]?.toString(),
      submissionId: json["submissionId"]?.toString(),
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
      brokerageFree: json["brokerageFree"] as bool?,
      rentNegotiable: json["rentNegotiable"] as bool?,
      availableFrom: json["availableFrom"]?.toString(),
      images: json["images"] is List
          ? List<String>.from(json["images"])
          : null,
      price: json["price"] as int?,
      securityDeposit: json["securityDeposit"] as int?,
      maintenanceCharges: json["maintenanceCharges"] as int?,
      maintenanceIncludedInRent: json["maintenanceIncludedInRent"] as bool?,
      brokerageFee: json["brokerageFee"] as int?,
      otherCharges: json["otherCharges"] as int?,
      vastuCompliant: json["vastuCompliant"] as bool?,
      openToAllBuyers: json["openToAllBuyers"] as bool?,
      loanAssistanceNeeded: json["loanAssistanceNeeded"] as bool?,
      listingTier: json["listingTier"]?.toString(),
      location: json["location"] is Map
          ? LocationModel.fromJson(Map<String, dynamic>.from(json["location"]))
          : null,
      owner: json["owner"]?.toString(),
      approvalStatus: json["approvalStatus"]?.toString(),
      isLive: json["isLive"] as bool?,
      viewsCount: json["viewsCount"] as int?,
      shortlistedCount: json["shortlistedCount"] as int?,
      inquiriesCount: json["inquiriesCount"] as int?,
      tokensCount: json["tokensCount"] as int?,
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
      "id": id,
      "_id": id,
      "submissionId": submissionId,
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
      "brokerageFree": brokerageFree,
      "rentNegotiable": rentNegotiable,
      "availableFrom": availableFrom,
      "images": images,
      "price": price,
      "securityDeposit": securityDeposit,
      "maintenanceCharges": maintenanceCharges,
      "maintenanceIncludedInRent": maintenanceIncludedInRent,
      "brokerageFee": brokerageFee,
      "otherCharges": otherCharges,
      "vastuCompliant": vastuCompliant,
      "openToAllBuyers": openToAllBuyers,
      "loanAssistanceNeeded": loanAssistanceNeeded,
      "listingTier": listingTier,
      "location": location?.toJson(),
      "owner": owner,
      "approvalStatus": approvalStatus,
      "isLive": isLive,
      "viewsCount": viewsCount,
      "shortlistedCount": shortlistedCount,
      "inquiriesCount": inquiriesCount,
      "tokensCount": tokensCount,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "__v": version,
    };
  }

  // Helper methods
  bool get isApproved => approvalStatus?.toLowerCase() == 'approved';
  bool get isPending => approvalStatus?.toLowerCase() == 'pending';
  bool get isRejected => approvalStatus?.toLowerCase() == 'rejected';
  
  String get formattedPrice {
    if (price == null) return '₹0';
    return '₹${price!.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }
  
  String get formattedArea {
    if (carpetArea == null) return '0 sq.ft';
    return '${carpetArea} sq.ft';
  }
}

class LocationModel {
  final String? type;
  final List<double>? coordinates;

  const LocationModel({
    this.type,
    this.coordinates,
  });

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
    return {
      "type": type,
      "coordinates": coordinates,
    };
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