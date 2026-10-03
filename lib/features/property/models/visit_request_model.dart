class VisitRequestListResponse {
  final String status;
  final String message;
  final VisitRequestListData? data;

  VisitRequestListResponse({
    required this.status,
    this.message = '',
    this.data,
  });

  factory VisitRequestListResponse.fromJson(Map<String, dynamic> json) {
    return VisitRequestListResponse(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? VisitRequestListData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class VisitRequestSingleResponse {
  final String status;
  final String message;
  final VisitRequestModel? visitRequest;

  VisitRequestSingleResponse({
    required this.status,
    this.message = '',
    this.visitRequest,
  });

  factory VisitRequestSingleResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    VisitRequestModel? req;
    if (data is Map<String, dynamic>) {
      if (data['visitRequest'] != null) {
        req = VisitRequestModel.fromJson(
          data['visitRequest'] as Map<String, dynamic>,
        );
      } else {
        req = VisitRequestModel.fromJson(data);
      }
    }
    return VisitRequestSingleResponse(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      visitRequest: req,
    );
  }
}

class VisitRequestListData {
  final List<VisitRequestModel> visitRequests;
  final VisitRequestCounts counts;
  final VisitRequestPagination? pagination;

  VisitRequestListData({
    required this.visitRequests,
    required this.counts,
    this.pagination,
  });

  factory VisitRequestListData.fromJson(Map<String, dynamic> json) {
    final list = json['visitRequests'] as List<dynamic>? ?? [];
    return VisitRequestListData(
      visitRequests: list
          .whereType<Map<String, dynamic>>()
          .map((e) => VisitRequestModel.fromJson(e))
          .toList(),
      counts: VisitRequestCounts.fromJson(
        json['counts'] as Map<String, dynamic>? ?? {},
      ),
      pagination: json['pagination'] != null
          ? VisitRequestPagination.fromJson(
              json['pagination'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class VisitRequestCounts {
  final int pending;
  final int accepted;
  final int rejected;
  final int total;

  const VisitRequestCounts({
    this.pending = 0,
    this.accepted = 0,
    this.rejected = 0,
    this.total = 0,
  });

  factory VisitRequestCounts.fromJson(Map<String, dynamic> json) {
    return VisitRequestCounts(
      pending: (json['pending'] as num?)?.toInt() ?? 0,
      accepted: (json['accepted'] as num?)?.toInt() ?? 0,
      rejected: (json['rejected'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }
}

class VisitRequestPagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasMore;

  VisitRequestPagination({
    this.page = 1,
    this.limit = 10,
    this.total = 0,
    this.totalPages = 1,
    this.hasMore = false,
  });

  factory VisitRequestPagination.fromJson(Map<String, dynamic> json) {
    return VisitRequestPagination(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
      hasMore: json['hasMore'] as bool? ?? false,
    );
  }
}

class VisitRequestModel {
  final String id;
  final String visitRequestId;
  final VisitRequestProperty? property;
  final VisitRequestUser? user;
  final VisitRequestUser? owner;
  final DateTime? visitDate;
  final String visitTime;
  final String status; // pending, accepted, rejected, cancelled
  final String? ownerMessage;
  final String? rejectionReason;
  final String? notes;
  final VisitRequestUserDetails? userDetails;
  final VisitRequestPropertyDetails? propertyDetails;
  final DateTime? decisionDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  VisitRequestModel({
    required this.id,
    required this.visitRequestId,
    this.property,
    this.user,
    this.owner,
    this.visitDate,
    required this.visitTime,
    required this.status,
    this.ownerMessage,
    this.rejectionReason,
    this.notes,
    this.userDetails,
    this.propertyDetails,
    this.decisionDate,
    this.createdAt,
    this.updatedAt,
  });

  bool get isPending => status.toLowerCase() == 'pending';
  bool get isAccepted => status.toLowerCase() == 'accepted';
  bool get isRejected => status.toLowerCase() == 'rejected';
  bool get isCancelled => status.toLowerCase() == 'cancelled';

  factory VisitRequestModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      return DateTime.tryParse(value.toString());
    }

    VisitRequestProperty? prop;
    if (json['property'] is Map<String, dynamic>) {
      prop = VisitRequestProperty.fromJson(
        json['property'] as Map<String, dynamic>,
      );
    }

    VisitRequestUser? usr;
    if (json['user'] is Map<String, dynamic>) {
      usr = VisitRequestUser.fromJson(json['user'] as Map<String, dynamic>);
    }

    VisitRequestUser? own;
    if (json['owner'] is Map<String, dynamic>) {
      own = VisitRequestUser.fromJson(json['owner'] as Map<String, dynamic>);
    }

    return VisitRequestModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      visitRequestId: json['visitRequestId']?.toString() ?? '',
      property: prop,
      user: usr,
      owner: own,
      visitDate: parseDate(json['visitDate']),
      visitTime: json['visitTime']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      ownerMessage: json['ownerMessage']?.toString(),
      rejectionReason: json['rejectionReason']?.toString(),
      notes: json['notes']?.toString(),
      userDetails: json['userDetails'] != null
          ? VisitRequestUserDetails.fromJson(
              json['userDetails'] as Map<String, dynamic>,
            )
          : null,
      propertyDetails: json['propertyDetails'] != null
          ? VisitRequestPropertyDetails.fromJson(
              json['propertyDetails'] as Map<String, dynamic>,
            )
          : null,
      decisionDate: parseDate(json['decisionDate']),
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }
}

class VisitRequestProperty {
  final String id;
  final String title;
  final String propertyType;
  final String locality;
  final String city;
  final String fullAddress;
  final int expectedPrice;
  final List<String> images;
  final String bedrooms;
  final String bathrooms;

  VisitRequestProperty({
    required this.id,
    this.title = '',
    this.propertyType = '',
    this.locality = '',
    this.city = '',
    this.fullAddress = '',
    this.expectedPrice = 0,
    this.images = const [],
    this.bedrooms = '',
    this.bathrooms = '',
  });

  factory VisitRequestProperty.fromJson(Map<String, dynamic> json) {
    final imgs = json['images'];
    List<String> imgList = [];
    if (imgs is List) {
      imgList = imgs.map((e) => e.toString()).toList();
    }
    return VisitRequestProperty(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      propertyType: json['propertyType']?.toString() ?? '',
      locality: json['locality']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      fullAddress: json['fullAddress']?.toString() ?? '',
      expectedPrice: (json['expectedPrice'] as num?)?.toInt() ??
          (json['price'] as num?)?.toInt() ??
          0,
      images: imgList,
      bedrooms: json['bedrooms']?.toString() ?? '',
      bathrooms: json['bathrooms']?.toString() ?? '',
    );
  }
}

class VisitRequestUser {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String? profilePicture;

  VisitRequestUser({
    required this.id,
    this.name = '',
    this.phone = '',
    this.email = '',
    this.profilePicture,
  });

  factory VisitRequestUser.fromJson(Map<String, dynamic> json) {
    return VisitRequestUser(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      profilePicture: json['profilePicture']?.toString(),
    );
  }
}

class VisitRequestUserDetails {
  final String name;
  final String phone;
  final String email;

  VisitRequestUserDetails({
    this.name = '',
    this.phone = '',
    this.email = '',
  });

  factory VisitRequestUserDetails.fromJson(Map<String, dynamic> json) {
    return VisitRequestUserDetails(
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}

class VisitRequestPropertyDetails {
  final String title;
  final String locality;
  final String city;
  final String fullAddress;

  VisitRequestPropertyDetails({
    this.title = '',
    this.locality = '',
    this.city = '',
    this.fullAddress = '',
  });

  factory VisitRequestPropertyDetails.fromJson(Map<String, dynamic> json) {
    return VisitRequestPropertyDetails(
      title: json['title']?.toString() ?? '',
      locality: json['locality']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      fullAddress: json['fullAddress']?.toString() ?? '',
    );
  }
}

class ScheduleVisitPayload {
  final String propertyId;
  final String visitDate; // "YYYY-MM-DD"
  final String visitTime; // e.g. "10:30 AM"
  final String? notes;

  ScheduleVisitPayload({
    required this.propertyId,
    required this.visitDate,
    required this.visitTime,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'propertyId': propertyId,
      'visitDate': visitDate,
      'visitTime': visitTime,
      if (notes != null && notes!.trim().isNotEmpty) 'notes': notes!.trim(),
    };
  }
}
