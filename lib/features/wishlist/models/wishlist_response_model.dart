class WishlistResponseModel {
  final String status;
  final bool success;
  final int count;
  final int results;
  final WishlistData? data;

  WishlistResponseModel({
    required this.status,
    required this.success,
    required this.count,
    required this.results,
    this.data,
  });

  factory WishlistResponseModel.fromJson(Map<String, dynamic> json) {
    return WishlistResponseModel(
      status: json['status']?.toString() ?? '',
      success: json['success'] ?? (json['status'] == 'success'),
      count: json['count'] is int
          ? json['count'] as int
          : (int.tryParse(json['count']?.toString() ?? '') ?? 0),
      results: json['results'] is int
          ? json['results'] as int
          : (int.tryParse(json['results']?.toString() ?? '') ?? 0),
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? WishlistData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'success': success,
    'count': count,
    'results': results,
    'data': data?.toJson(),
  };
}

class WishlistData {
  final List<WishlistItem> wishlist;
  final List<WishlistPropertyItem> properties;

  WishlistData({this.wishlist = const [], this.properties = const []});

  factory WishlistData.fromJson(Map<String, dynamic> json) {
    return WishlistData(
      wishlist:
          (json['wishlist'] as List<dynamic>?)
              ?.map((e) => WishlistItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      properties:
          (json['properties'] as List<dynamic>?)
              ?.map(
                (e) => WishlistPropertyItem.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'wishlist': wishlist.map((e) => e.toJson()).toList(),
    'properties': properties.map((e) => e.toJson()).toList(),
  };
}

class WishlistItem {
  final String id;
  final String user;
  final String itemType;
  final WishlistPropertyItem? property;
  final bool isWishlisted;
  final bool isFavorited;

  WishlistItem({
    required this.id,
    required this.user,
    required this.itemType,
    this.property,
    this.isWishlisted = true,
    this.isFavorited = true,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      user: json['user']?.toString() ?? '',
      itemType: json['itemType']?.toString() ?? 'Property',
      property:
          json['property'] != null && json['property'] is Map<String, dynamic>
          ? WishlistPropertyItem.fromJson(
              json['property'] as Map<String, dynamic>,
            )
          : null,
      isWishlisted: json['isWishlisted'] ?? true,
      isFavorited: json['isFavorited'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'user': user,
    'itemType': itemType,
    'property': property?.toJson(),
    'isWishlisted': isWishlisted,
    'isFavorited': isFavorited,
  };
}

class WishlistPropertyItem {
  final String id;
  String get mongoId => id;
  final String title;
  final int price;
  final String city;
  final String locality;
  final String fullAddress;
  final String bedrooms;
  final int carpetArea;
  final List<String> images;
  final bool isVerified;
  final String approvalStatus;

  WishlistPropertyItem({
    required this.id,
    required this.title,
    required this.price,
    required this.city,
    required this.locality,
    required this.fullAddress,
    required this.bedrooms,
    required this.carpetArea,
    required this.images,
    this.isVerified = false,
    this.approvalStatus = '',
  });

  factory WishlistPropertyItem.fromJson(Map<String, dynamic> json) {
    return WishlistPropertyItem(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      price: json['price'] is int
          ? json['price'] as int
          : (int.tryParse(json['price']?.toString() ?? '') ?? 0),
      city: json['city']?.toString() ?? '',
      locality: json['locality']?.toString() ?? '',
      fullAddress: json['fullAddress']?.toString() ?? '',
      bedrooms: json['bedrooms']?.toString() ?? '',
      carpetArea: json['carpetArea'] is int
          ? json['carpetArea'] as int
          : (int.tryParse(json['carpetArea']?.toString() ?? '') ?? 0),
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isVerified: json['isVerified'] ?? false,
      approvalStatus: json['approvalStatus']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'title': title,
    'price': price,
    'city': city,
    'locality': locality,
    'fullAddress': fullAddress,
    'bedrooms': bedrooms,
    'carpetArea': carpetArea,
    'images': images,
    'isVerified': isVerified,
    'approvalStatus': approvalStatus,
  };

  String get formattedPrice {
    if (price >= 10000000) {
      return '₹${(price / 10000000).toStringAsFixed(2)} Cr';
    } else if (price >= 100000) {
      return '₹${(price / 100000).toStringAsFixed(2)} L';
    } else {
      return '₹$price';
    }
  }

  String get formattedLocation {
    if (locality.isNotEmpty && city.isNotEmpty) {
      return '$locality, $city';
    } else if (locality.isNotEmpty) {
      return locality;
    } else if (city.isNotEmpty) {
      return city;
    } else {
      return fullAddress;
    }
  }
}
