// ─── Main Response Model ─────────────────────────────────────────────────────

class NewsResponse {
  final String status;
  final int results;
  final int totalCount;
  final NewsData data;

  NewsResponse({
    required this.status,
    required this.results,
    required this.totalCount,
    required this.data,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    return NewsResponse(
      status: json['status'] ?? '',
      results: json['results'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      data: NewsData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'results': results,
      'totalCount': totalCount,
      'data': data.toJson(),
    };
  }
}

// ─── Data Model ──────────────────────────────────────────────────────────────

class NewsData {
  final List<News> news;

  NewsData({required this.news});

  factory NewsData.fromJson(Map<String, dynamic> json) {
    return NewsData(
      news: (json['news'] as List<dynamic>? ?? [])
          .map((e) => News.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'news': news.map((e) => e.toJson()).toList()};
  }
}

// ─── News Model ──────────────────────────────────────────────────────────────

class News {
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

  News({
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

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
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
  News copyWith({
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
    return News(
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
    return 'News(id: $id, title: $title, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is News &&
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
} // ─── News Category Enum ──────────────────────────────────────────────────────

enum NewsCategory { rbiRates, prices, newLaunches, policy, market, other }

extension NewsCategoryExtension on String {
  NewsCategory toNewsCategory() {
    switch (this) {
      case 'rbi_rates':
        return NewsCategory.rbiRates;
      case 'prices':
        return NewsCategory.prices;
      case 'new_launches':
        return NewsCategory.newLaunches;
      case 'policy':
        return NewsCategory.policy;
      case 'market':
        return NewsCategory.market;
      default:
        return NewsCategory.other;
    }
  }
}

extension NewsCategoryString on NewsCategory {
  String get string {
    switch (this) {
      case NewsCategory.rbiRates:
        return 'rbi_rates';
      case NewsCategory.prices:
        return 'prices';
      case NewsCategory.newLaunches:
        return 'new_launches';
      case NewsCategory.policy:
        return 'policy';
      case NewsCategory.market:
        return 'market';
      case NewsCategory.other:
        return 'other';
    }
  }

  String get displayName {
    switch (this) {
      case NewsCategory.rbiRates:
        return 'RBI Rates';
      case NewsCategory.prices:
        return 'Prices';
      case NewsCategory.newLaunches:
        return 'New Launches';
      case NewsCategory.policy:
        return 'Policy';
      case NewsCategory.market:
        return 'Market';
      case NewsCategory.other:
        return 'Other';
    }
  }
}
// ─── News Extensions ─────────────────────────────────────────────────────────

extension NewsExtension on News {
  String get formattedPublishedAt {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) return 'Yesterday';
      if (difference.inDays < 7) return '${difference.inDays} days ago';
      if (difference.inDays < 30) return '${difference.inDays ~/ 7} weeks ago';
      if (difference.inDays < 365)
        return '${difference.inDays ~/ 30} months ago';
      return '${difference.inDays ~/ 365} years ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hr${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  String get formattedViews {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M views';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K views';
    } else {
      return '$views views';
    }
  }

  String get readTimeDisplay {
    return '$readTime min read';
  }

  String get shortTitle {
    if (title.length <= 60) return title;
    return '${title.substring(0, 60)}...';
  }

  String get shortDescriptionDisplay {
    if (shortDescription.length <= 100) return shortDescription;
    return '${shortDescription.substring(0, 100)}...';
  }

  bool get hasImage => image.isNotEmpty;

  NewsCategory get categoryEnum => category.toNewsCategory();

  String get categoryDisplayName => categoryEnum.displayName;
}
