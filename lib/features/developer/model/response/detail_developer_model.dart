// ---------------------------------------------------------------------------
// Wrapper Response
// ---------------------------------------------------------------------------
class DeveloperDetailResponse {
  final String status;
  final DeveloperData data;

  DeveloperDetailResponse({
    required this.status,
    required this.data,
  });

  factory DeveloperDetailResponse.fromJson(Map<String, dynamic> json) {
    return DeveloperDetailResponse(
      status: json['status'] as String? ?? '',
      data: DeveloperData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

// ---------------------------------------------------------------------------
// Data (holds developer)
// ---------------------------------------------------------------------------
class DeveloperData {
  final Developer developer;

  DeveloperData({required this.developer});

  factory DeveloperData.fromJson(Map<String, dynamic> json) {
    return DeveloperData(
      developer: Developer.fromJson(json['developer'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'developer': developer.toJson(),
    };
  }
}

// ---------------------------------------------------------------------------
// Developer Model
// ---------------------------------------------------------------------------
class Developer {
  final String id;
  final String name;
  final String companyName;
  final String profilePicture;
  final String logo;
  final String cityOfOperation;
  final String yearsInBusiness;
  final double rating;
  final int reviewCount;
  final String bio;
  final String unitsDelivered;
  final bool isIsoCertified;
  final int projectsCount;
  final int citiesCount;

  Developer({
    required this.id,
    required this.name,
    required this.companyName,
    required this.profilePicture,
    required this.logo,
    required this.cityOfOperation,
    required this.yearsInBusiness,
    required this.rating,
    required this.reviewCount,
    required this.bio,
    required this.unitsDelivered,
    required this.isIsoCertified,
    required this.projectsCount,
    required this.citiesCount,
  });

  factory Developer.fromJson(Map<String, dynamic> json) {
    return Developer(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      companyName: json['companyName'] as String? ?? '',
      profilePicture: json['profilePicture'] as String? ?? '',
      logo: json['logo'] as String? ?? '',
      cityOfOperation: json['cityOfOperation'] as String? ?? '',
      yearsInBusiness: json['yearsInBusiness'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      bio: json['bio'] as String? ?? '',
      unitsDelivered: json['unitsDelivered'] as String? ?? '0',
      isIsoCertified: json['isIsoCertified'] as bool? ?? false,
      projectsCount: json['projectsCount'] as int? ?? 0,
      citiesCount: json['citiesCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'companyName': companyName,
      'profilePicture': profilePicture,
      'logo': logo,
      'cityOfOperation': cityOfOperation,
      'yearsInBusiness': yearsInBusiness,
      'rating': rating,
      'reviewCount': reviewCount,
      'bio': bio,
      'unitsDelivered': unitsDelivered,
      'isIsoCertified': isIsoCertified,
      'projectsCount': projectsCount,
      'citiesCount': citiesCount,
    };
  }
}