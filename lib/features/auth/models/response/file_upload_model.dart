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
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? UploadData.fromJson(json['data'] as Map<String, dynamic>)
          : (json['urls'] != null || json['fileUrls'] != null || json['data'] is List
              ? UploadData.fromJson(json)
              : UploadData(fileUrls: [], count: 0)),
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
    final rawList = json['fileUrls'] ?? json['urls'] ?? json['files'] ?? (json['data'] is List ? json['data'] : null);
    List<String> urls = [];
    if (rawList is List) {
      urls = rawList.map((e) => e.toString()).toList();
    } else if (json['url'] != null) {
      urls = [json['url'].toString()];
    }
    return UploadData(
      fileUrls: urls,
      count: json['count'] is int
          ? json['count'] as int
          : (int.tryParse(json['count']?.toString() ?? '') ?? urls.length),
    );
  }

  // Method for converting to JSON
  Map<String, dynamic> toJson() {
    return {'fileUrls': fileUrls, 'count': count};
  }
}
