class AboutUsResponse {
  final String status;
  final bool success;
  final AboutUsData data;

  AboutUsResponse({
    required this.status,
    required this.success,
    required this.data,
  });

  factory AboutUsResponse.fromJson(Map<String, dynamic> json) {
    return AboutUsResponse(
      status: json['status'],
      success: json['success'],
      data: AboutUsData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'success': success,
    'data': data.toJson(),
  };
}

class AboutUsData {
  final PageContent pageContent;

  AboutUsData({required this.pageContent});

  factory AboutUsData.fromJson(Map<String, dynamic> json) {
    return AboutUsData(pageContent: PageContent.fromJson(json['pageContent']));
  }

  Map<String, dynamic> toJson() => {'pageContent': pageContent.toJson()};
}

class PageContent {
  final String id;
  final String type;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final LastUpdatedBy lastUpdatedBy;

  PageContent({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.lastUpdatedBy,
  });

  factory PageContent.fromJson(Map<String, dynamic> json) {
    return PageContent(
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
