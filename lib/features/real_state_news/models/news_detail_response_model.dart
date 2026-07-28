// ─── News Detail Response Model ─────────────────────────────────────────────

class NewsDetailResponse {
  final String status;
  final NewsDetailData data;

  NewsDetailResponse({required this.status, required this.data});

  factory NewsDetailResponse.fromJson(Map<String, dynamic> json) {
    return NewsDetailResponse(
      status: json['status'] ?? '',
      data: NewsDetailData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'data': data.toJson()};
  }
}

// ─── News Detail Data Model ─────────────────────────────────────────────────

class NewsDetailData {
  final NewsDetail news;

  NewsDetailData({required this.news});

  factory NewsDetailData.fromJson(Map<String, dynamic> json) {
    return NewsDetailData(news: NewsDetail.fromJson(json['news'] ?? {}));
  }

  Map<String, dynamic> toJson() {
    return {'news': news.toJson()};
  }
}

// ─── News Detail Model ──────────────────────────────────────────────────────

class NewsDetail {
  final String id;
  final String title;
  final String shortDescription;
  final String description;
  final String image;
  final String category;
  final int readTime;
  final bool isPublished;
  final bool isFeatured;
  final DateTime publishedAt;
  final int views;
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;

  NewsDetail({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.description,
    required this.image,
    required this.category,
    required this.readTime,
    required this.isPublished,
    required this.isFeatured,
    required this.publishedAt,
    required this.views,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NewsDetail.fromJson(Map<String, dynamic> json) {
    return NewsDetail(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      shortDescription: json['shortDescription'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      category: json['category'] ?? '',
      readTime: json['readTime'] ?? 0,
      isPublished: json['isPublished'] ?? false,
      isFeatured: json['isFeatured'] ?? false,
      publishedAt: DateTime.parse(
        json['publishedAt'] ?? DateTime.now().toIso8601String(),
      ),
      views: json['views'] ?? 0,
      version: json['__v'] ?? 0,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'shortDescription': shortDescription,
      'description': description,
      'image': image,
      'category': category,
      'readTime': readTime,
      'isPublished': isPublished,
      'isFeatured': isFeatured,
      'publishedAt': publishedAt.toIso8601String(),
      'views': views,
      '__v': version,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Copy method for immutability
  NewsDetail copyWith({
    String? id,
    String? title,
    String? shortDescription,
    String? description,
    String? image,
    String? category,
    int? readTime,
    bool? isPublished,
    bool? isFeatured,
    DateTime? publishedAt,
    int? views,
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NewsDetail(
      id: id ?? this.id,
      title: title ?? this.title,
      shortDescription: shortDescription ?? this.shortDescription,
      description: description ?? this.description,
      image: image ?? this.image,
      category: category ?? this.category,
      readTime: readTime ?? this.readTime,
      isPublished: isPublished ?? this.isPublished,
      isFeatured: isFeatured ?? this.isFeatured,
      publishedAt: publishedAt ?? this.publishedAt,
      views: views ?? this.views,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'NewsDetail(id: $id, title: $title, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NewsDetail &&
        other.id == id &&
        other.title == title &&
        other.shortDescription == shortDescription &&
        other.description == description &&
        other.image == image &&
        other.category == category &&
        other.readTime == readTime &&
        other.isPublished == isPublished &&
        other.isFeatured == isFeatured &&
        other.publishedAt == publishedAt &&
        other.views == views &&
        other.version == version &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        shortDescription.hashCode ^
        description.hashCode ^
        image.hashCode ^
        category.hashCode ^
        readTime.hashCode ^
        isPublished.hashCode ^
        isFeatured.hashCode ^
        publishedAt.hashCode ^
        views.hashCode ^
        version.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
