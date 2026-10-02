class HomeBannerResponse {
  final String status;
  final BannerData data;

  HomeBannerResponse({
    required this.status,
    required this.data,
  });

  factory HomeBannerResponse.fromJson(Map<String, dynamic> json) {
    return HomeBannerResponse(
      status: json['status']?.toString() ?? '',
      data: BannerData.fromJson(
        (json['data'] is Map<String, dynamic>)
            ? json['data'] as Map<String, dynamic>
            : {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data.toJson(),
  };
}

class BannerData {
  final List<BannerItem> heroBanners;
  final List<BannerItem> middleBanners;
  final List<BannerItem> commercialBanners;
  final List<BannerItem> bottomBanners;

  BannerData({
    this.heroBanners = const [],
    this.middleBanners = const [],
    this.commercialBanners = const [],
    this.bottomBanners = const [],
  });

  factory BannerData.fromJson(Map<String, dynamic> json) {
    List<BannerItem> parseList(dynamic raw) {
      if (raw is List) {
        return raw
            .map((e) => BannerItem.fromJson(e as Map<String, dynamic>))
            .where((b) => b.isActive)
            .toList();
      }
      return [];
    }

    return BannerData(
      heroBanners: parseList(json['heroBanners']),
      middleBanners: parseList(json['middleBanners']),
      commercialBanners: parseList(json['commercialBanners']),
      bottomBanners: parseList(json['bottomBanners']),
    );
  }

  Map<String, dynamic> toJson() => {
    'heroBanners': heroBanners.map((e) => e.toJson()).toList(),
    'middleBanners': middleBanners.map((e) => e.toJson()).toList(),
    'commercialBanners': commercialBanners.map((e) => e.toJson()).toList(),
    'bottomBanners': bottomBanners.map((e) => e.toJson()).toList(),
  };
}

class BannerItem {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String image;
  final String mobileImage;
  final String position;
  final String linkType;
  final String linkValue;
  final String buttonText;
  final int sortOrder;
  final bool isActive;
  final int clicksCount;
  final int viewsCount;

  BannerItem({
    required this.id,
    required this.title,
    this.subtitle = '',
    this.description = '',
    required this.image,
    this.mobileImage = '',
    this.position = 'home_top',
    this.linkType = '',
    this.linkValue = '',
    this.buttonText = '',
    this.sortOrder = 0,
    this.isActive = true,
    this.clicksCount = 0,
    this.viewsCount = 0,
  });

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      mobileImage: json['mobileImage']?.toString() ?? '',
      position: json['position']?.toString() ?? 'home_top',
      linkType: json['linkType']?.toString() ?? '',
      linkValue: json['linkValue']?.toString() ?? '',
      buttonText: json['buttonText']?.toString() ?? '',
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] ?? true,
      clicksCount: (json['clicksCount'] as num?)?.toInt() ?? 0,
      viewsCount: (json['viewsCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'title': title,
    'subtitle': subtitle,
    'description': description,
    'image': image,
    'mobileImage': mobileImage,
    'position': position,
    'linkType': linkType,
    'linkValue': linkValue,
    'buttonText': buttonText,
    'sortOrder': sortOrder,
    'isActive': isActive,
    'clicksCount': clicksCount,
    'viewsCount': viewsCount,
  };

  /// Returns effective image url (prefers mobileImage if available)
  String get effectiveImage {
    if (mobileImage.isNotEmpty) return mobileImage;
    return image;
  }
}
