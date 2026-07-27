class UploadResponse {
  final String status;
  final String message;
  final UploadData data;

  UploadResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  // Factory constructor for creating from JSON
  factory UploadResponse.fromJson(Map<String, dynamic> json) {
    return UploadResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: UploadData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  // Method for converting to JSON
  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'data': data.toJson()};
  }
}

class UploadData {
  final List<String> fileUrls;
  final int count;

  UploadData({required this.fileUrls, required this.count});

  // Factory constructor for creating from JSON
  factory UploadData.fromJson(Map<String, dynamic> json) {
    return UploadData(
      fileUrls: List<String>.from(json['fileUrls'] as List),
      count: json['count'] as int,
    );
  }

  // Method for converting to JSON
  Map<String, dynamic> toJson() {
    return {'fileUrls': fileUrls, 'count': count};
  }
}
