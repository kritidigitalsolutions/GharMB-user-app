class TermsConditionResponse {
  final String status;
  final bool success;
  final TermsConditionData? data;

  TermsConditionResponse({
    required this.status,
    required this.success,
    this.data,
  });

  factory TermsConditionResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return TermsConditionResponse(status: '', success: false);
    }
    return TermsConditionResponse(
      status: json['status']?.toString() ?? '',
      success: json['success'] == true,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? TermsConditionData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'success': success,
    if (data != null) 'data': data!.toJson(),
  };
}

class TermsConditionData {
  final LegalContent? legalContent;

  TermsConditionData({this.legalContent});

  factory TermsConditionData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return TermsConditionData();
    final contentJson = json['legalContent'] ?? json['pageContent'] ?? json['content'];
    return TermsConditionData(
      legalContent: contentJson is Map<String, dynamic>
          ? LegalContent.fromJson(contentJson)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    if (legalContent != null) 'legalContent': legalContent!.toJson(),
  };
}

class LegalContent {
  final String id;
  final String type;
  final String title;
  final String content;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? version;
  final LastUpdatedBy? lastUpdatedBy;

  LegalContent({
    this.id = '',
    this.type = '',
    this.title = '',
    this.content = '',
    this.createdAt,
    this.updatedAt,
    this.version,
    this.lastUpdatedBy,
  });

  factory LegalContent.fromJson(Map<String, dynamic>? json) {
    if (json == null) return LegalContent();
    return LegalContent(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      version: json['__v'] is int
          ? json['__v'] as int
          : int.tryParse(json['__v']?.toString() ?? ''),
      lastUpdatedBy: json['lastUpdatedBy'] is Map<String, dynamic>
          ? LastUpdatedBy.fromJson(json['lastUpdatedBy'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'type': type,
    'title': title,
    'content': content,
    if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    if (version != null) '__v': version,
    if (lastUpdatedBy != null) 'lastUpdatedBy': lastUpdatedBy!.toJson(),
  };
}

class LastUpdatedBy {
  final String id;
  final String name;
  final String email;

  LastUpdatedBy({
    this.id = '',
    this.name = '',
    this.email = '',
  });

  factory LastUpdatedBy.fromJson(Map<String, dynamic>? json) {
    if (json == null) return LastUpdatedBy();
    return LastUpdatedBy(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'_id': id, 'name': name, 'email': email};
}
