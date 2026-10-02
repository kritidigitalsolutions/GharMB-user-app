class DeveloperReviewsResponse {
  final String status;
  final int results;
  final ReviewStats? stats;
  final List<DeveloperReviewItem> reviews;

  DeveloperReviewsResponse({
    required this.status,
    required this.results,
    this.stats,
    this.reviews = const [],
  });

  factory DeveloperReviewsResponse.fromJson(Map<String, dynamic> json) {
    // Stats may be at root or inside data
    ReviewStats? parsedStats;
    if (json['stats'] != null && json['stats'] is Map<String, dynamic>) {
      parsedStats = ReviewStats.fromJson(json['stats'] as Map<String, dynamic>);
    } else if (json['data'] != null &&
        json['data'] is Map<String, dynamic> &&
        json['data']['stats'] != null) {
      parsedStats =
          ReviewStats.fromJson(json['data']['stats'] as Map<String, dynamic>);
    }

    // Reviews may be under data.reviews or data list
    List<DeveloperReviewItem> parsedReviews = [];
    if (json['data'] != null) {
      if (json['data'] is Map<String, dynamic> &&
          json['data']['reviews'] is List) {
        parsedReviews = (json['data']['reviews'] as List)
            .map((e) => DeveloperReviewItem.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (json['data'] is List) {
        parsedReviews = (json['data'] as List)
            .map((e) => DeveloperReviewItem.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } else if (json['reviews'] is List) {
      parsedReviews = (json['reviews'] as List)
          .map((e) => DeveloperReviewItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return DeveloperReviewsResponse(
      status: json['status']?.toString() ?? '',
      results: json['results'] is int
          ? json['results'] as int
          : (int.tryParse(json['results']?.toString() ?? '') ?? parsedReviews.length),
      stats: parsedStats,
      reviews: parsedReviews,
    );
  }
}

class ReviewStats {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> breakdown;

  ReviewStats({
    required this.averageRating,
    required this.totalReviews,
    required this.breakdown,
  });

  factory ReviewStats.fromJson(Map<String, dynamic> json) {
    final rawBreakdown = json['breakdown'];
    Map<int, int> map = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    if (rawBreakdown is Map) {
      rawBreakdown.forEach((key, value) {
        final star = int.tryParse(key.toString());
        final count = int.tryParse(value.toString()) ?? 0;
        if (star != null && star >= 1 && star <= 5) {
          map[star] = count;
        }
      });
    }

    return ReviewStats(
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['totalReviews'] is int
          ? json['totalReviews'] as int
          : (int.tryParse(json['totalReviews']?.toString() ?? '') ?? 0),
      breakdown: map,
    );
  }

  double fractionForStar(int star) {
    if (totalReviews == 0) return 0.0;
    final count = breakdown[star] ?? 0;
    return (count / totalReviews).clamp(0.0, 1.0);
  }
}

class DeveloperReviewItem {
  final String id;
  final String developerId;
  final double rating;
  final String comment;
  final List<String> tags;
  final String tag;
  final ReviewerInfo? reviewer;
  final DateTime? createdAt;

  DeveloperReviewItem({
    required this.id,
    required this.developerId,
    required this.rating,
    required this.comment,
    this.tags = const [],
    this.tag = '',
    this.reviewer,
    this.createdAt,
  });

  factory DeveloperReviewItem.fromJson(Map<String, dynamic> json) {
    List<String> parsedTags = [];
    if (json['whatAreYouRating'] is List) {
      parsedTags = (json['whatAreYouRating'] as List)
          .map((e) => e.toString())
          .toList();
    } else if (json['tags'] is List) {
      parsedTags = (json['tags'] as List).map((e) => e.toString()).toList();
    } else if (json['tag'] != null && json['tag'].toString().isNotEmpty) {
      parsedTags = json['tag']
          .toString()
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    DateTime? parsedDate;
    if (json['createdAt'] != null) {
      parsedDate = DateTime.tryParse(json['createdAt'].toString());
    }

    return DeveloperReviewItem(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      developerId: json['developer'] is Map
          ? (json['developer']['_id']?.toString() ?? '')
          : (json['developer']?.toString() ?? ''),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      comment: json['comment']?.toString() ??
          json['review']?.toString() ??
          json['message']?.toString() ??
          json['experience']?.toString() ??
          '',
      tags: parsedTags,
      tag: json['tag']?.toString() ?? parsedTags.join(', '),
      reviewer: json['reviewer'] != null && json['reviewer'] is Map<String, dynamic>
          ? ReviewerInfo.fromJson(json['reviewer'] as Map<String, dynamic>)
          : (json['user'] != null && json['user'] is Map<String, dynamic>
              ? ReviewerInfo.fromJson(json['user'] as Map<String, dynamic>)
              : null),
      createdAt: parsedDate,
    );
  }

  String get timeAgo {
    if (createdAt == null) return 'Recently';
    final diff = DateTime.now().difference(createdAt!);
    if (diff.inDays > 365) {
      final years = (diff.inDays / 365).floor();
      return '$years ${years == 1 ? "year" : "years"} ago';
    } else if (diff.inDays > 30) {
      final months = (diff.inDays / 30).floor();
      return '$months ${months == 1 ? "month" : "months"} ago';
    } else if (diff.inDays > 0) {
      return '${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} ${diff.inMinutes == 1 ? "min" : "mins"} ago';
    }
    return 'Just now';
  }
}

class ReviewerInfo {
  final String id;
  final String name;
  final String profilePicture;

  ReviewerInfo({
    required this.id,
    required this.name,
    this.profilePicture = '',
  });

  factory ReviewerInfo.fromJson(Map<String, dynamic> json) {
    return ReviewerInfo(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ??
          json['fullName']?.toString() ??
          'Verified Buyer',
      profilePicture: json['profilePicture']?.toString() ??
          json['avatar']?.toString() ??
          '',
    );
  }

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'VB';
  }
}

class MyReviewResponse {
  final bool hasReviewed;
  final DeveloperReviewItem? review;

  MyReviewResponse({
    required this.hasReviewed,
    this.review,
  });

  factory MyReviewResponse.fromJson(Map<String, dynamic> json) {
    return MyReviewResponse(
      hasReviewed: json['hasReviewed'] == true ||
          (json['data'] != null && json['data']['hasReviewed'] == true),
      review: json['data'] != null &&
              json['data']['review'] != null &&
              json['data']['review'] is Map<String, dynamic>
          ? DeveloperReviewItem.fromJson(
              json['data']['review'] as Map<String, dynamic>)
          : (json['review'] != null && json['review'] is Map<String, dynamic>
              ? DeveloperReviewItem.fromJson(
                  json['review'] as Map<String, dynamic>)
              : null),
    );
  }
}
