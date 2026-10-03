class TokenConfigModel {
  final List<int> tokenAmounts;
  final int defaultTokenAmount;
  final int minTokenAmount;
  final int maxTokenAmount;
  final String adjustmentNote;
  final bool allowTokenBooking;
  final TokenPropertyInfo? property;

  TokenConfigModel({
    this.tokenAmounts = const [2000, 5000],
    this.defaultTokenAmount = 2000,
    this.minTokenAmount = 1000,
    this.maxTokenAmount = 100000,
    this.adjustmentNote =
        'Token amount will be adjusted in security deposit or first month\'s rent',
    this.allowTokenBooking = true,
    this.property,
  });

  factory TokenConfigModel.fromJson(Map<String, dynamic> json) {
    final amountsRaw = json['tokenAmounts'];
    List<int> amounts = [2000, 5000];
    if (amountsRaw is List) {
      amounts = amountsRaw
          .map((e) => (e as num?)?.toInt() ?? 0)
          .where((e) => e > 0)
          .toList();
      if (amounts.isEmpty) amounts = [2000, 5000];
    }

    return TokenConfigModel(
      tokenAmounts: amounts,
      defaultTokenAmount: (json['defaultTokenAmount'] as num?)?.toInt() ??
          (amounts.isNotEmpty ? amounts.first : 2000),
      minTokenAmount: (json['minTokenAmount'] as num?)?.toInt() ?? 1000,
      maxTokenAmount: (json['maxTokenAmount'] as num?)?.toInt() ?? 100000,
      adjustmentNote: json['adjustmentNote']?.toString() ??
          'Token amount will be adjusted in security deposit or first month\'s rent',
      allowTokenBooking: json['allowTokenBooking'] != false,
      property: json['property'] is Map<String, dynamic>
          ? TokenPropertyInfo.fromJson(json['property'] as Map<String, dynamic>)
          : null,
    );
  }
}

class TokenPropertyInfo {
  final String id;
  final String title;
  final int price;
  final int monthlyRent;
  final String category;
  final String listingFor;
  final String city;
  final String locality;

  TokenPropertyInfo({
    this.id = '',
    this.title = '',
    this.price = 0,
    this.monthlyRent = 0,
    this.category = '',
    this.listingFor = '',
    this.city = '',
    this.locality = '',
  });

  factory TokenPropertyInfo.fromJson(Map<String, dynamic> json) {
    return TokenPropertyInfo(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      monthlyRent: (json['monthlyRent'] as num?)?.toInt() ??
          (json['price'] as num?)?.toInt() ??
          0,
      category: json['category']?.toString() ?? '',
      listingFor: json['listingFor']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      locality: json['locality']?.toString() ?? '',
    );
  }
}

class TokenBookingSubmissionRequest {
  final String propertyId;
  final Map<String, dynamic> personalDetails;
  final Map<String, dynamic> familyDetails;
  final Map<String, dynamic> occupationDetails;
  final Map<String, dynamic> idProof;
  final int tokenAmount;
  final int monthlyRent;
  final String totalAgreedPrice;
  final String paymentMethod;
  final String transactionId;

  TokenBookingSubmissionRequest({
    required this.propertyId,
    required this.personalDetails,
    required this.familyDetails,
    required this.occupationDetails,
    required this.idProof,
    required this.tokenAmount,
    required this.monthlyRent,
    required this.totalAgreedPrice,
    this.paymentMethod = 'upi',
    this.transactionId = '',
  });

  Map<String, dynamic> toJson() => {
        'propertyId': propertyId,
        'personalDetails': personalDetails,
        'familyDetails': familyDetails,
        'occupationDetails': occupationDetails,
        'idProof': idProof,
        'tokenAmount': tokenAmount,
        'monthlyRent': monthlyRent,
        'totalAgreedPrice': totalAgreedPrice,
        'paymentMethod': paymentMethod,
        if (transactionId.isNotEmpty) 'transactionId': transactionId,
      };
}

class TokenBookingResponse {
  final String status;
  final String message;
  final TokenRequestItem? tokenRequest;

  TokenBookingResponse({
    required this.status,
    required this.message,
    this.tokenRequest,
  });

  factory TokenBookingResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic> ? json['data'] : json;
    return TokenBookingResponse(
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      tokenRequest: data['tokenRequest'] is Map<String, dynamic>
          ? TokenRequestItem.fromJson(data['tokenRequest'])
          : (json['tokenRequest'] is Map<String, dynamic>
              ? TokenRequestItem.fromJson(json['tokenRequest'])
              : null),
    );
  }
}

class TokenRequestItem {
  final String id;
  final String tokenRequestId;
  final String propertyId;
  final int tokenAmount;
  final String status;
  final String escrowStatus;
  final String paymentStatus;
  final String paymentMethod;
  final String utrRef;
  final DateTime? createdAt;
  final TokenPropertyInfo? property;

  TokenRequestItem({
    required this.id,
    required this.tokenRequestId,
    required this.propertyId,
    required this.tokenAmount,
    required this.status,
    required this.escrowStatus,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.utrRef,
    this.createdAt,
    this.property,
  });

  factory TokenRequestItem.fromJson(Map<String, dynamic> json) {
    return TokenRequestItem(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      tokenRequestId: json['tokenRequestId']?.toString() ??
          json['_id']?.toString() ??
          '#TKN-REQ',
      propertyId: json['property'] is Map
          ? (json['property']['_id']?.toString() ??
              json['property']['id']?.toString() ??
              '')
          : json['property']?.toString() ?? '',
      tokenAmount: (json['tokenAmount'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? 'pending',
      escrowStatus: json['escrowStatus']?.toString() ?? 'Escrow Held',
      paymentStatus: json['paymentStatus']?.toString() ?? 'paid',
      paymentMethod: json['paymentMethod']?.toString() ?? 'upi',
      utrRef: json['utrRef']?.toString() ??
          json['transactionId']?.toString() ??
          '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      property: json['property'] is Map<String, dynamic>
          ? TokenPropertyInfo.fromJson(json['property'])
          : null,
    );
  }
}
