class NearPropertiesResponse {
  final String status;
  final int results;
  final int totalCount;
  final PropertyData data;

  NearPropertiesResponse({
    required this.status,
    required this.results,
    required this.totalCount,
    required this.data,
  });

  factory NearPropertiesResponse.fromJson(Map<String, dynamic> json) {
    return NearPropertiesResponse(
      status: json['status'] ?? '',
      results: json['results'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      data: PropertyData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'results': results,
    'totalCount': totalCount,
    'data': data.toJson(),
  };
}

class PropertyData {
  final List<Property> properties;

  PropertyData({required this.properties});

  factory PropertyData.fromJson(Map<String, dynamic> json) {
    final list = json['properties'] ?? json['spaces'];
    return PropertyData(
      properties: (list is List<dynamic> ? list : [])
          .map((e) => Property.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'properties': properties.map((e) => e.toJson()).toList(),
  };
}

class Property {
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
  final bool keyHandover;
  final bool isVerified;
  final bool openToAllBuyers;
  final bool loanAssistanceNeeded;
  final String listingTier;
  final bool allowInstallments;
  final InstallmentDetails? installmentDetails; // null when not applicable
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
  final int version;

  Property({
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
    required this.keyHandover,
    required this.isVerified,
    required this.openToAllBuyers,
    required this.loanAssistanceNeeded,
    required this.listingTier,
    required this.allowInstallments,
    required this.installmentDetails,
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
    required this.version,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      location: Location.fromJson(
        json['location'] is Map<String, dynamic> ? json['location'] : {},
      ),
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      mongoId: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      listingAs: json['listingAs']?.toString() ?? '',
      category:
          json['category']?.toString() ??
          (json['spaceType'] != null ? 'commercial' : ''),
      listingFor: json['listingFor']?.toString() ?? '',
      propertyType:
          json['propertyType']?.toString() ??
          json['spaceType']?.toString() ??
          '',
      title: json['title']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      locality: json['locality']?.toString() ?? '',
      fullAddress: json['fullAddress']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      bedrooms: json['bedrooms']?.toString() ?? '',
      bathrooms: json['bathrooms']?.toString() ?? '',
      carpetArea: (json['carpetArea'] as num?)?.toInt() ?? 0,
      builtUpArea: (json['builtUpArea'] as num?)?.toInt() ?? 0,
      floorNo: json['floorNo']?.toString() ?? '',
      totalFloors: json['totalFloors']?.toString() ?? '',
      ageOfProperty: json['ageOfProperty']?.toString() ?? '',
      furnishing: json['furnishing']?.toString() ?? '',
      facingDirection: json['facingDirection']?.toString() ?? '',
      parking: json['parking']?.toString() ?? '',
      amenities:
          (json['amenities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      preferredTenants:
          (json['preferredTenants'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      petsAllowed: json['petsAllowed'] ?? false,
      smokingAllowed: json['smokingAllowed'] ?? false,
      brokerageFree: json['brokerageFree'] ?? false,
      rentNegotiable: json['rentNegotiable'] ?? false,
      images:
          ((json['images'] ?? json['photos']) as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      price: (json['price'] as num?)?.toInt() ?? 0,
      securityDeposit: (json['securityDeposit'] as num?)?.toInt() ?? 0,
      maintenanceCharges: (json['maintenanceCharges'] as num?)?.toInt() ?? 0,
      maintenanceIncludedInRent: json['maintenanceIncludedInRent'] ?? false,
      brokerageFee: (json['brokerageFee'] as num?)?.toInt() ?? 0,
      otherCharges: (json['otherCharges'] as num?)?.toInt() ?? 0,
      vastuCompliant: json['vastuCompliant'] ?? false,
      keyHandover: json['keyHandover'] ?? false,
      isVerified: json['isVerified'] ?? false,
      openToAllBuyers: json['openToAllBuyers'] ?? false,
      loanAssistanceNeeded: json['loanAssistanceNeeded'] ?? false,
      listingTier: json['listingTier']?.toString() ?? '',
      allowInstallments: json['allowInstallments'] == true,
      installmentDetails: json['installmentDetails'] is Map<String, dynamic>
          ? InstallmentDetails.fromJson(json['installmentDetails'])
          : null,
      owner: Owner.fromJson(
        json['owner'] is Map<String, dynamic> ? json['owner'] : {},
      ),
      approvalStatus: json['approvalStatus']?.toString() ?? '',
      isLive: json['isLive'] ?? false,
      viewsCount: (json['viewsCount'] as num?)?.toInt() ?? 0,
      shortlistedCount: (json['shortlistedCount'] as num?)?.toInt() ?? 0,
      inquiriesCount: (json['inquiriesCount'] as num?)?.toInt() ?? 0,
      tokensCount: (json['tokensCount'] as num?)?.toInt() ?? 0,
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
      submissionId: json['submissionId']?.toString() ?? '',
      version: (json['__v'] as num?)?.toInt() ?? 0,
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
    'keyHandover': keyHandover,
    'isVerified': isVerified,
    'openToAllBuyers': openToAllBuyers,
    'loanAssistanceNeeded': loanAssistanceNeeded,
    'listingTier': listingTier,
    'allowInstallments': allowInstallments,
    'installmentDetails': installmentDetails?.toJson(),
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
    '__v': version,
  };
}

class InstallmentDetails {
  final int downPaymentAmount;
  final int downPaymentPercentage;
  final int numberOfInstallments;
  final String installmentFrequency;
  final int installmentAmount;
  final int interestRate;
  final int installmentDurationMonths;
  final int gracePeriodDays;
  final String termsAndConditions;

  InstallmentDetails({
    required this.downPaymentAmount,
    required this.downPaymentPercentage,
    required this.numberOfInstallments,
    required this.installmentFrequency,
    required this.installmentAmount,
    required this.interestRate,
    required this.installmentDurationMonths,
    required this.gracePeriodDays,
    required this.termsAndConditions,
  });

  factory InstallmentDetails.fromJson(Map<String, dynamic> json) {
    return InstallmentDetails(
      downPaymentAmount: (json['downPaymentAmount'] as num?)?.toInt() ?? 0,
      downPaymentPercentage:
          (json['downPaymentPercentage'] as num?)?.toInt() ?? 0,
      numberOfInstallments:
          (json['numberOfInstallments'] as num?)?.toInt() ?? 0,
      installmentFrequency:
          json['installmentFrequency']?.toString() ?? 'Monthly',
      installmentAmount: (json['installmentAmount'] as num?)?.toInt() ?? 0,
      interestRate: (json['interestRate'] as num?)?.toInt() ?? 0,
      installmentDurationMonths:
          (json['installmentDurationMonths'] as num?)?.toInt() ?? 0,
      gracePeriodDays: (json['gracePeriodDays'] as num?)?.toInt() ?? 0,
      termsAndConditions: json['termsAndConditions']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'downPaymentAmount': downPaymentAmount,
    'downPaymentPercentage': downPaymentPercentage,
    'numberOfInstallments': numberOfInstallments,
    'installmentFrequency': installmentFrequency,
    'installmentAmount': installmentAmount,
    'interestRate': interestRate,
    'installmentDurationMonths': installmentDurationMonths,
    'gracePeriodDays': gracePeriodDays,
    'termsAndConditions': termsAndConditions,
  };
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({required this.type, required this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? '',
      coordinates: (json['coordinates'] as List<dynamic>? ?? [])
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
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      isVerified: json['isVerified'] ?? false,
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
