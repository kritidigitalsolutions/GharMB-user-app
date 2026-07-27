class TermsConditionResponse {
  final String status;
  final bool success;
  final TermsConditionData data;

  TermsConditionResponse({
    required this.status,
    required this.success,
    required this.data,
  });

  factory TermsConditionResponse.fromJson(Map<String, dynamic> json) {
    return TermsConditionResponse(
      status: json['status'],
      success: json['success'],
      data: TermsConditionData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'success': success,
    'data': data.toJson(),
  };
}

class TermsConditionData {
  final LegalContent legalContent;

  TermsConditionData({required this.legalContent});

  factory TermsConditionData.fromJson(Map<String, dynamic> json) {
    return TermsConditionData(
      legalContent: LegalContent.fromJson(json['legalContent']),
    );
  }

  Map<String, dynamic> toJson() => {'legalContent': legalContent.toJson()};
}

class LegalContent {
  final String id;
  final String type;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final LastUpdatedBy lastUpdatedBy;

  LegalContent({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.lastUpdatedBy,
  });

  factory LegalContent.fromJson(Map<String, dynamic> json) {
    return LegalContent(
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
