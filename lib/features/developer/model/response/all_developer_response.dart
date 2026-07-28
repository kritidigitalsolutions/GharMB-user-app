class AllDeveloperResponse {
  final String status;
  final int results;
  final DeveloperData data;

  AllDeveloperResponse({
    required this.status,
    required this.results,
    required this.data,
  });

  factory AllDeveloperResponse.fromJson(Map<String, dynamic> json) {
    return AllDeveloperResponse(
      status: json['status'] ?? '',
      results: json['results'] ?? 0,
      data: DeveloperData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'results': results, 'data': data.toJson()};
  }
}

class DeveloperData {
  final List<Developer> developers;

  DeveloperData({required this.developers});

  factory DeveloperData.fromJson(Map<String, dynamic> json) {
    return DeveloperData(
      developers: (json['developers'] as List<dynamic>? ?? [])
          .map((e) => Developer.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'developers': developers.map((e) => e.toJson()).toList()};
  }
}

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
  final int projectCount;
  final String projectCountDisplay;

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
    required this.projectCount,
    required this.projectCountDisplay,
  });

  factory Developer.fromJson(Map<String, dynamic> json) {
    return Developer(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      companyName: json['companyName'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      logo: json['logo'] ?? '',
      cityOfOperation: json['cityOfOperation'] ?? '',
      yearsInBusiness: json['yearsInBusiness'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      projectCount: json['projectCount'] ?? 0,
      projectCountDisplay: json['projectCountDisplay'] ?? '',
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
      'projectCount': projectCount,
      'projectCountDisplay': projectCountDisplay,
    };
  }
}
