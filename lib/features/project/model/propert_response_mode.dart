class PropertyResponse {
  final String status;
  final int results;
  final int? total;
  final int? page;
  final int? limit;
  final int? totalPages;
  final bool? hasMore;
  final PropertyData data;

  PropertyResponse({
    required this.status,
    required this.results,
    this.total,
    this.page,
    this.limit,
    this.totalPages,
    this.hasMore,
    required this.data,
  });

  factory PropertyResponse.fromJson(Map<String, dynamic> json) {
    final dynamic rawData = json['data'];
    return PropertyResponse(
      status: json['status']?.toString() ?? '',
      results: _toInt(json['results'] ?? json['count']),
      total: json['total'] != null
          ? _toInt(json['total'])
          : (json['totalProperties'] != null
              ? _toInt(json['totalProperties'])
              : (json['totalDocs'] != null ? _toInt(json['totalDocs']) : null)),
      page: json['page'] != null
          ? _toInt(json['page'])
          : (json['currentPage'] != null ? _toInt(json['currentPage']) : null),
      limit: json['limit'] != null ? _toInt(json['limit']) : null,
      totalPages: json['totalPages'] != null ? _toInt(json['totalPages']) : null,
      hasMore: json['hasMore'] is bool ? json['hasMore'] as bool : null,
      data: PropertyData.fromJson(rawData ?? json),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'results': results,
    'total': total,
    'page': page,
    'limit': limit,
    'totalPages': totalPages,
    'hasMore': hasMore,
    'data': data.toJson(),
  };

  static int _toInt(dynamic val) {
    if (val == null) return 0;
    if (val is num) return val.toInt();
    return int.tryParse(val.toString()) ?? 0;
  }
}

class PropertyData {
  final List<PropertyModel> properties;

  PropertyData({required this.properties});

  factory PropertyData.fromJson(dynamic json) {
    if (json == null) return PropertyData(properties: []);

    if (json is List) {
      return PropertyData(
        properties: json
            .whereType<Map<String, dynamic>>()
            .map((e) => PropertyModel.fromJson(e))
            .toList(),
      );
    }

    if (json is Map<String, dynamic>) {
      final list = json['properties'] ??
          json['docs'] ??
          json['results'] ??
          json['data'];
      if (list is List) {
        return PropertyData(
          properties: list
              .whereType<Map<String, dynamic>>()
              .map((e) => PropertyModel.fromJson(e))
              .toList(),
        );
      }
    }

    return PropertyData(properties: []);
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
  final bool keyHandover;
  final bool openToAllBuyers;
  final bool loanAssistanceNeeded;
  final String listingTier;
  final Owner owner;
  final String approvalStatus;
  final bool isLive;
  final bool isVerified;
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
    this.keyHandover = false,
    required this.openToAllBuyers,
    required this.loanAssistanceNeeded,
    required this.listingTier,
    required this.owner,
    required this.approvalStatus,
    required this.isLive,
    this.isVerified = false,
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
      location: Location.fromJson(
        json['location'] is Map<String, dynamic>
            ? json['location']
            : {'type': 'Point', 'coordinates': [0, 0]},
      ),
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      mongoId: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      listingAs: json['listingAs']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      listingFor: json['listingFor']?.toString() ?? '',
      propertyType: json['propertyType']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      locality: json['locality']?.toString() ?? '',
      fullAddress: json['fullAddress']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      bedrooms: json['bedrooms']?.toString() ?? '',
      bathrooms: json['bathrooms']?.toString() ?? '',
      carpetArea: _toInt(json['carpetArea']),
      builtUpArea: _toInt(json['builtUpArea']),
      floorNo: json['floorNo']?.toString() ?? '-',
      totalFloors: json['totalFloors']?.toString() ?? '-',
      ageOfProperty: json['ageOfProperty']?.toString() ?? '',
      furnishing: json['furnishing']?.toString() ?? '-',
      facingDirection: json['facingDirection']?.toString() ?? '-',
      parking: json['parking']?.toString() ?? '-',
      amenities: json['amenities'] is List
          ? List<String>.from(
              (json['amenities'] as List).map((e) => e.toString()),
            )
          : [],
      preferredTenants: json['preferredTenants'] is List
          ? List<String>.from(
              (json['preferredTenants'] as List).map((e) => e.toString()),
            )
          : [],
      petsAllowed: json['petsAllowed'] == true || json['petsAllowed']?.toString() == 'true',
      smokingAllowed: json['smokingAllowed'] == true || json['smokingAllowed']?.toString() == 'true',
      brokerageFree: json['brokerageFree'] == true || json['brokerageFree']?.toString() == 'true',
      rentNegotiable: json['rentNegotiable'] == true || json['rentNegotiable']?.toString() == 'true',
      images: json['images'] is List
          ? List<String>.from((json['images'] as List).map((e) => e.toString()))
          : [],
      price: _toInt(json['price']),
      securityDeposit: _toInt(json['securityDeposit']),
      maintenanceCharges: _toInt(json['maintenanceCharges']),
      maintenanceIncludedInRent: json['maintenanceIncludedInRent'] == true ||
          json['maintenanceIncludedInRent']?.toString() == 'true',
      brokerageFee: _toInt(json['brokerageFee']),
      otherCharges: _toInt(json['otherCharges']),
      vastuCompliant: json['vastuCompliant'] == true || json['vastuCompliant']?.toString() == 'true',
      keyHandover: json['keyHandover'] == true || json['keyHandover']?.toString() == 'true',
      openToAllBuyers: json['openToAllBuyers'] != false && json['openToAllBuyers']?.toString() != 'false',
      loanAssistanceNeeded: json['loanAssistanceNeeded'] == true ||
          json['loanAssistanceNeeded']?.toString() == 'true',
      listingTier: json['listingTier']?.toString() ?? 'standard',
      owner: Owner.fromJson(
        json['owner'] is Map<String, dynamic> ? json['owner'] : {},
      ),
      approvalStatus: json['approvalStatus']?.toString() ?? 'pending',
      isLive: json['isLive'] != false && json['isLive']?.toString() != 'false',
      isVerified: json['isVerified'] == true || json['isVerified']?.toString() == 'true',
      viewsCount: _toInt(json['viewsCount']),
      shortlistedCount: _toInt(json['shortlistedCount']),
      inquiriesCount: _toInt(json['inquiriesCount']),
      tokensCount: _toInt(json['tokensCount']),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
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
    'keyHandover': keyHandover,
    'openToAllBuyers': openToAllBuyers,
    'loanAssistanceNeeded': loanAssistanceNeeded,
    'listingTier': listingTier,
    'owner': owner.toJson(),
    'approvalStatus': approvalStatus,
    'isLive': isLive,
    'isVerified': isVerified,
    'viewsCount': viewsCount,
    'shortlistedCount': shortlistedCount,
    'inquiriesCount': inquiriesCount,
    'tokensCount': tokensCount,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'submissionId': submissionId,
  };

  static int _toInt(dynamic val) {
    if (val == null) return 0;
    if (val is num) return val.toInt();
    return int.tryParse(val.toString()) ?? 0;
  }

  // ─── Native helper getters for UI, Filters & Providers ──────────────────

  bool get isReraApproved =>
      approvalStatus.toLowerCase() == 'approved' || isVerified;

  bool get isReadyToMove =>
      ageOfProperty.toLowerCase().contains('ready') ||
      ageOfProperty.trim() == '0';

  String get locationLabel =>
      locality.isNotEmpty ? '$locality, $city' : (city.isNotEmpty ? city : 'Location on request');

  String get bhkLabel =>
      bedrooms.isNotEmpty && bedrooms != '0' ? '$bedrooms BHK' : (propertyType.isNotEmpty ? propertyType : 'Residential');

  String get possessionLabel =>
      ageOfProperty.trim().isEmpty ? 'Ready to Move' : ageOfProperty;

  String get imageUrl => images.isNotEmpty ? images.first : '';

  String get gradientKey {
    const keys = ['dark_blue', 'dark_teal', 'dark_yellow'];
    return keys[id.hashCode.abs() % keys.length];
  }

  String get startingPriceLabel {
    if (price >= 10000000) {
      final cr = price / 10000000;
      return '₹${cr.toStringAsFixed(cr.truncateToDouble() == cr ? 0 : 2)} Cr';
    } else if (price >= 100000) {
      final l = price / 100000;
      return '₹${l.toStringAsFixed(l.truncateToDouble() == l ? 0 : 1)} L';
    } else if (price > 0) {
      return '₹$price';
    }
    return '₹ Price on Request';
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({required this.type, required this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    final rawCoords = json['coordinates'];
    List<double> coords = [0.0, 0.0];
    if (rawCoords is List) {
      coords = rawCoords.map((e) {
        if (e is num) return e.toDouble();
        return double.tryParse(e?.toString() ?? '') ?? 0.0;
      }).toList();
    }
    return Location(
      type: json['type']?.toString() ?? 'Point',
      coordinates: coords,
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
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      profilePicture: json['profilePicture']?.toString() ?? '',
      isVerified: json['isVerified'] == true || json['isVerified']?.toString() == 'true',
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
