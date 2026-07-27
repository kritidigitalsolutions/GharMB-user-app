class PrivacyPolicyResponse {
  final String status;
  final bool success;
  final PrivacyPolicyData data;

  PrivacyPolicyResponse({
    required this.status,
    required this.success,
    required this.data,
  });

  factory PrivacyPolicyResponse.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyResponse(
      status: json['status'],
      success: json['success'],
      data: PrivacyPolicyData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'success': success,
    'data': data.toJson(),
  };
}

class PrivacyPolicyData {
  final PrivacyContent legalContent;

  PrivacyPolicyData({required this.legalContent});

  factory PrivacyPolicyData.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyData(
      legalContent: PrivacyContent.fromJson(json['legalContent']),
    );
  }

  Map<String, dynamic> toJson() => {'legalContent': legalContent.toJson()};
}

class PrivacyContent {
  final String id;
  final String type;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final LastUpdatedBy lastUpdatedBy;

  PrivacyContent({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.lastUpdatedBy,
  });

  factory PrivacyContent.fromJson(Map<String, dynamic> json) {
    return PrivacyContent(
      id: json['_id'],
      type: json['type'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      version: json['__v'],
      lastUpdatedBy: LastUpdatedBy.fromJson(json['lastUpdatedBy']),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'type': type,
    'title': title,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': version,
    'lastUpdatedBy': lastUpdatedBy.toJson(),
  };
}

class LastUpdatedBy {
  final String id;
  final String name;
  final String email;

  LastUpdatedBy({required this.id, required this.name, required this.email});

  factory LastUpdatedBy.fromJson(Map<String, dynamic> json) {
    return LastUpdatedBy(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {'_id': id, 'name': name, 'email': email};
}
