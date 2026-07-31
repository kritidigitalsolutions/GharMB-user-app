class PropertyResponse {
  final String status;
  final int results;
  final PropertyData data;

  PropertyResponse({
    required this.status,
    required this.results,
    required this.data,
  });

  factory PropertyResponse.fromJson(Map<String, dynamic> json) {
    return PropertyResponse(
      status: json['status'],
      results: json['results'],
      data: PropertyData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'results': results,
    'data': data.toJson(),
  };
}

class PropertyData {
  final List<PropertyModel> properties;

  PropertyData({required this.properties});

  factory PropertyData.fromJson(Map<String, dynamic> json) {
    return PropertyData(
      properties: (json['properties'] as List)
          .map((e) => PropertyModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'properties': properties.map((e) => e.toJson()).toList(),
  };
}

class PropertyModel {
  final Location location;
  final String id;
  final String mongoId;
  final String listingAs;
  final String category;
  final String listingFor;
  final String propertyType;
  final String title;
  final String city;
  final String locality;
  final String fullAddress;
  final String pincode;
  final String description;
  final String bedrooms;
  final String bathrooms;
  final int carpetArea;
  final int builtUpArea;
  final String floorNo;
  final String totalFloors;
  final String ageOfProperty;
  final String furnishing;
  final String facingDirection;
  final String parking;
  final List<String> amenities;
  final List<String> preferredTenants;
  final bool petsAllowed;
  final bool smokingAllowed;
  final bool brokerageFree;
  final bool rentNegotiable;
  final List<String> images;
  final int price;
  final int securityDeposit;
  final int maintenanceCharges;
  final bool maintenanceIncludedInRent;
  final int brokerageFee;
  final int otherCharges;
  final bool vastuCompliant;
  final bool openToAllBuyers;
  final bool loanAssistanceNeeded;
  final String listingTier;
  final Owner owner;
  final String approvalStatus;
  final bool isLive;
  final int viewsCount;
  final int shortlistedCount;
  final int inquiriesCount;
  final int tokensCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String submissionId;

  PropertyModel({
    required this.location,
    required this.id,
    required this.mongoId,
    required this.listingAs,
    required this.category,
    required this.listingFor,
    required this.propertyType,
    required this.title,
    required this.city,
    required this.locality,
    required this.fullAddress,
    required this.pincode,
    required this.description,
    required this.bedrooms,
    required this.bathrooms,
    required this.carpetArea,
    required this.builtUpArea,
    required this.floorNo,
    required this.totalFloors,
    required this.ageOfProperty,
    required this.furnishing,
    required this.facingDirection,
    required this.parking,
    required this.amenities,
    required this.preferredTenants,
    required this.petsAllowed,
    required this.smokingAllowed,
    required this.brokerageFree,
    required this.rentNegotiable,
    required this.images,
    required this.price,
    required this.securityDeposit,
    required this.maintenanceCharges,
    required this.maintenanceIncludedInRent,
    required this.brokerageFee,
    required this.otherCharges,
    required this.vastuCompliant,
    required this.openToAllBuyers,
    required this.loanAssistanceNeeded,
    required this.listingTier,
    required this.owner,
    required this.approvalStatus,
    required this.isLive,
    required this.viewsCount,
    required this.shortlistedCount,
    required this.inquiriesCount,
    required this.tokensCount,
    required this.createdAt,
    required this.updatedAt,
    required this.submissionId,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      location: Location.fromJson(json['location'] ?? {'type': 'Point', 'coordinates': [0, 0]}),
      id: json['_id'] ?? '',
      mongoId: json['_id'] ?? '',
      listingAs: json['listingAs'] ?? '',
      category: json['category'] ?? '',
      listingFor: json['listingFor'] ?? '',
      propertyType: json['propertyType'] ?? '',
      title: json['title'] ?? '',
      city: json['city'] ?? '',
      locality: json['locality'] ?? '',
      fullAddress: json['fullAddress'] ?? '',
      pincode: json['pincode']?.toString() ?? '',
      description: json['description'] ?? '',
      bedrooms: json['bedrooms']?.toString() ?? '',
      bathrooms: json['bathrooms']?.toString() ?? '',
      carpetArea: (json['carpetArea'] as num?)?.toInt() ?? 0,
      builtUpArea: (json['builtUpArea'] as num?)?.toInt() ?? 0,
      floorNo: json['floorNo']?.toString() ?? '-',
      totalFloors: json['totalFloors']?.toString() ?? '-',
      ageOfProperty: json['ageOfProperty']?.toString() ?? '',
      furnishing: json['furnishing'] ?? '-',
      facingDirection: json['facingDirection'] ?? '-',
      parking: json['parking'] ?? '-',
      amenities: List<String>.from(json['amenities'] ?? []),
      preferredTenants: List<String>.from(json['preferredTenants'] ?? []),
      petsAllowed: json['petsAllowed'] ?? false,
      smokingAllowed: json['smokingAllowed'] ?? false,
      brokerageFree: json['brokerageFree'] ?? false,
      rentNegotiable: json['rentNegotiable'] ?? false,
      images: List<String>.from(json['images'] ?? []),
      price: (json['price'] as num?)?.toInt() ?? 0,
      securityDeposit: (json['securityDeposit'] as num?)?.toInt() ?? 0,
      maintenanceCharges: (json['maintenanceCharges'] as num?)?.toInt() ?? 0,
      maintenanceIncludedInRent: json['maintenanceIncludedInRent'] ?? false,
      brokerageFee: (json['brokerageFee'] as num?)?.toInt() ?? 0,
      otherCharges: (json['otherCharges'] as num?)?.toInt() ?? 0,
      vastuCompliant: json['vastuCompliant'] ?? false,
      openToAllBuyers: json['openToAllBuyers'] ?? true,
      loanAssistanceNeeded: json['loanAssistanceNeeded'] ?? false,
      listingTier: json['listingTier'] ?? 'standard',
      owner: Owner.fromJson(json['owner'] ?? {}),
      approvalStatus: json['approvalStatus'] ?? 'pending',
      isLive: json['isLive'] ?? true,
      viewsCount: (json['viewsCount'] as num?)?.toInt() ?? 0,
      shortlistedCount: (json['shortlistedCount'] as num?)?.toInt() ?? 0,
      inquiriesCount: (json['inquiriesCount'] as num?)?.toInt() ?? 0,
      tokensCount: (json['tokensCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      submissionId: json['submissionId']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'location': location.toJson(),
    '_id': mongoId,
    'id': id,
    'listingAs': listingAs,
    'category': category,
    'listingFor': listingFor,
    'propertyType': propertyType,
    'title': title,
    'city': city,
    'locality': locality,
    'fullAddress': fullAddress,
    'pincode': pincode,
    'description': description,
    'bedrooms': bedrooms,
    'bathrooms': bathrooms,
    'carpetArea': carpetArea,
    'builtUpArea': builtUpArea,
    'floorNo': floorNo,
    'totalFloors': totalFloors,
    'ageOfProperty': ageOfProperty,
    'furnishing': furnishing,
    'facingDirection': facingDirection,
    'parking': parking,
    'amenities': amenities,
    'preferredTenants': preferredTenants,
    'petsAllowed': petsAllowed,
    'smokingAllowed': smokingAllowed,
    'brokerageFree': brokerageFree,
    'rentNegotiable': rentNegotiable,
    'images': images,
    'price': price,
    'securityDeposit': securityDeposit,
    'maintenanceCharges': maintenanceCharges,
    'maintenanceIncludedInRent': maintenanceIncludedInRent,
    'brokerageFee': brokerageFee,
    'otherCharges': otherCharges,
    'vastuCompliant': vastuCompliant,
    'openToAllBuyers': openToAllBuyers,
    'loanAssistanceNeeded': loanAssistanceNeeded,
    'listingTier': listingTier,
    'owner': owner.toJson(),
    'approvalStatus': approvalStatus,
    'isLive': isLive,
    'viewsCount': viewsCount,
    'shortlistedCount': shortlistedCount,
    'inquiriesCount': inquiriesCount,
    'tokensCount': tokensCount,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'submissionId': submissionId,
  };
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({required this.type, required this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: (json['coordinates'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {'type': type, 'coordinates': coordinates};
}

class Owner {
  final String id;
  final String name;
  final String phone;
  final String profilePicture;
  final bool isVerified;

  Owner({
    required this.id,
    required this.name,
    required this.phone,
    required this.profilePicture,
    required this.isVerified,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['_id'],
      name: json['name'],
      phone: json['phone'],
      profilePicture: json['profilePicture'],
      isVerified: json['isVerified'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'phone': phone,
    'profilePicture': profilePicture,
    'isVerified': isVerified,
  };
}
