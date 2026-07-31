// ---------------------------------------------------------------------------
// Top-level Response
// ---------------------------------------------------------------------------
class EnquirySubmitResponse {
  final String status;
  final String message;
  final EnquiryData data;

  EnquirySubmitResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory EnquirySubmitResponse.fromJson(Map<String, dynamic> json) {
    return EnquirySubmitResponse(
      status: json['status'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: EnquiryData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

// ---------------------------------------------------------------------------
// Data wrapper (holds enquiry)
// ---------------------------------------------------------------------------
class EnquiryData {
  final Enquiry enquiry;

  EnquiryData({required this.enquiry});

  factory EnquiryData.fromJson(Map<String, dynamic> json) {
    return EnquiryData(
      enquiry: Enquiry.fromJson(json['enquiry'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enquiry': enquiry.toJson(),
    };
  }
}

// ---------------------------------------------------------------------------
// Enquiry model
// ---------------------------------------------------------------------------
class Enquiry {
  final String developer;
  final String client;
  final String message;
  final String status;
  final String id;
  final String createdAt;
  final String updatedAt;
  final int v; // __v

  Enquiry({
    required this.developer,
    required this.client,
    required this.message,
    required this.status,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Enquiry.fromJson(Map<String, dynamic> json) {
    return Enquiry(
      developer: json['developer'] as String? ?? '',
      client: json['client'] as String? ?? '',
      message: json['message'] as String? ?? '',
      status: json['status'] as String? ?? '',
      id: json['_id'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      v: json['__v'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'developer': developer,
      'client': client,
      'message': message,
      'status': status,
      '_id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}