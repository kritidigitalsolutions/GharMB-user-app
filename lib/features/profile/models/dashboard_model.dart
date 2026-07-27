// dashboard_response.dart

import 'package:flutter/material.dart';

class DashboardResponse {
  final String? status;
  final DashboardData? data;

  DashboardResponse({this.status, this.data});

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      status: json["status"]?.toString(),
      data: json["data"] is Map
          ? DashboardData.fromJson(Map<String, dynamic>.from(json["data"]))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {"status": status, "data": data?.toJson()};
  }
}

class DashboardData {
  final ProfileModel? profile;
  final CountersModel? counters;
  final PerformanceModel? performance;
  final MyPropertiesModel? myProperties;

  DashboardData({
    this.profile,
    this.counters,
    this.performance,
    this.myProperties,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      profile: json["profile"] is Map
          ? ProfileModel.fromJson(Map<String, dynamic>.from(json["profile"]))
          : null,
      counters: json["counters"] is Map
          ? CountersModel.fromJson(Map<String, dynamic>.from(json["counters"]))
          : null,
      performance: json["performance"] is Map
          ? PerformanceModel.fromJson(
              Map<String, dynamic>.from(json["performance"]),
            )
          : null,
      myProperties: json["myProperties"] is Map
          ? MyPropertiesModel.fromJson(
              Map<String, dynamic>.from(json["myProperties"]),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "profile": profile?.toJson(),
      "counters": counters?.toJson(),
      "performance": performance?.toJson(),
      "myProperties": myProperties?.toJson(),
    };
  }
}

class ProfileModel {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? role;
  final bool? isVerified;
  final AddressModel? address;

  ProfileModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.isVerified,
    this.address,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json["id"]?.toString(),
      name: json["name"]?.toString(),
      email: json["email"]?.toString(),
      phone: json["phone"]?.toString(),
      role: json["role"]?.toString(),
      isVerified: json["isVerified"] as bool?,
      address: json["address"] is Map
          ? AddressModel.fromJson(Map<String, dynamic>.from(json["address"]))
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
      "isVerified": isVerified,
      "address": address?.toJson(),
    };
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
}

class CountersModel {
  final int? totalListings;
  final int? liveListings;
  final int? pendingListings;
  final int? rejectedListings;
  final int? pendingTokens;
  final int? acceptedTokens;

  CountersModel({
    this.totalListings,
    this.liveListings,
    this.pendingListings,
    this.rejectedListings,
    this.pendingTokens,
    this.acceptedTokens,
  });

  factory CountersModel.fromJson(Map<String, dynamic> json) {
    return CountersModel(
      totalListings: json["totalListings"] as int?,
      liveListings: json["liveListings"] as int?,
      pendingListings: json["pendingListings"] as int?,
      rejectedListings: json["rejectedListings"] as int?,
      pendingTokens: json["pendingTokens"] as int?,
      acceptedTokens: json["acceptedTokens"] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "totalListings": totalListings,
      "liveListings": liveListings,
      "pendingListings": pendingListings,
      "rejectedListings": rejectedListings,
      "pendingTokens": pendingTokens,
      "acceptedTokens": acceptedTokens,
    };
  }
}

class PerformanceModel {
  final int? views;
  final int? shortlisted;
  final int? inquiries;
  final int? tokensReceived;

  PerformanceModel({
    this.views,
    this.shortlisted,
    this.inquiries,
    this.tokensReceived,
  });

  factory PerformanceModel.fromJson(Map<String, dynamic> json) {
    return PerformanceModel(
      views: json["views"] as int?,
      shortlisted: json["shortlisted"] as int?,
      inquiries: json["inquiries"] as int?,
      tokensReceived: json["tokensReceived"] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "views": views,
      "shortlisted": shortlisted,
      "inquiries": inquiries,
      "tokensReceived": tokensReceived,
    };
  }
}

class MyPropertiesModel {
  final List<PropertyDashboardItem>? live;
  final List<PropertyDashboardItem>? pending;
  final List<PropertyDashboardItem>? rejected;

  MyPropertiesModel({this.live, this.pending, this.rejected});

  factory MyPropertiesModel.fromJson(Map<String, dynamic> json) {
    return MyPropertiesModel(
      live: json["live"] is List
          ? (json["live"] as List)
                .map(
                  (item) => PropertyDashboardItem.fromJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList()
          : null,
      pending: json["pending"] is List
          ? (json["pending"] as List)
                .map(
                  (item) => PropertyDashboardItem.fromJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList()
          : null,
      rejected: json["rejected"] is List
          ? (json["rejected"] as List)
                .map(
                  (item) => PropertyDashboardItem.fromJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "live": live?.map((item) => item.toJson()).toList(),
      "pending": pending?.map((item) => item.toJson()).toList(),
      "rejected": rejected?.map((item) => item.toJson()).toList(),
    };
  }

  int get totalProperties =>
      (live?.length ?? 0) + (pending?.length ?? 0) + (rejected?.length ?? 0);
}

class PropertyDashboardItem {
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
  final bool? brokerageFree;
  final bool? rentNegotiable;
  final String? availableFrom;
  final List<String>? images;
  final int? price;
  final int? securityDeposit;
  final int? maintenanceCharges;
  final bool? maintenanceIncludedInRent;
  final int? brokerageFee;
  final int? otherCharges;
  final bool? vastuCompliant;
  final bool? openToAllBuyers;
  final bool? loanAssistanceNeeded;
  final String? listingTier;
  final LocationModel? location;
  final String? owner;
  final String? approvalStatus;
  final bool? isLive;
  final int? viewsCount;
  final int? shortlistedCount;
  final int? inquiriesCount;
  final int? tokensCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? version;

  PropertyDashboardItem({
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

  factory PropertyDashboardItem.fromJson(Map<String, dynamic> json) {
    return PropertyDashboardItem(
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
      images: json["images"] is List ? List<String>.from(json["images"]) : null,
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

  String get statusDisplay {
    if (isLive == true) return 'Live';
    if (isPending) return 'Pending';
    if (isRejected) return 'Rejected';
    if (isApproved) return 'Approved';
    return 'Draft';
  }

  Color get statusColor {
    if (isLive == true) return Colors.green;
    if (isPending) return Colors.orange;
    if (isRejected) return Colors.red;
    if (isApproved) return Colors.blue;
    return Colors.grey;
  }
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
