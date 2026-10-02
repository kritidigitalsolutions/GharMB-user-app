class AppUrls {
  // static const serverUrl = "https://server.gharmb.com";
  static const serverUrl = "http://192.168.1.32:5001";
  static const baseUrl = "$serverUrl/api";

  // --------------------------------------
  // Auth
  // ---------------------------------

  static const register = "$baseUrl/user/auth/register";
  static const login = "$baseUrl/user/auth/send-otp";
  static const verifyOtp = "$baseUrl/user/auth/verify-otp";
  static const googleAuth = "$baseUrl/user/auth/google";
  static const basicInfo = "$baseUrl/user/auth/basic-info";
  static const addProperties = "$baseUrl/user/properties";
  static const dashBoardUrl = "$baseUrl/properties/my-dashboard";
  static const commercialDashboardUrl = "$baseUrl/commercial-spaces/my-dashboard";
  static const getProfile = "$baseUrl/users/me";
  static const agentRegister = "$baseUrl/user/users/register-agent";
  static const uploadFile = "$baseUrl/user/upload/multiple";
  static const developerRegister = "$baseUrl/user/users/register-developer";
  static const allProperties = "$baseUrl/properties";
  static String verifiedProperties({
    int page = 1,
    int limit = 20,
    String? category,
    String? listingFor,
    String? propertyType,
    String? city,
    String? locality,
    double? minPrice,
    double? maxPrice,
    String? search,
  }) {
    final params = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
      if (category != null && category.isNotEmpty) 'category': category,
      if (listingFor != null && listingFor.isNotEmpty) 'listingFor': listingFor,
      if (propertyType != null && propertyType.isNotEmpty)
        'propertyType': propertyType,
      if (city != null && city.isNotEmpty) 'city': city,
      if (locality != null && locality.isNotEmpty) 'locality': locality,
      if (minPrice != null) 'minPrice': minPrice.toString(),
      if (maxPrice != null) 'maxPrice': maxPrice.toString(),
      if (search != null && search.isNotEmpty) 'search': search,
    };
    final query = Uri(queryParameters: params).query;
    return '$baseUrl/properties/verified?$query';
  }

  static String latestProperties({
    int page = 1,
    int limit = 10,
    String? category,
    String? listingFor,
    String? propertyType,
    String? city,
    String? locality,
    double? minPrice,
    double? maxPrice,
    String? search,
  }) {
    final params = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
      if (category != null && category.isNotEmpty) 'category': category,
      if (listingFor != null && listingFor.isNotEmpty) 'listingFor': listingFor,
      if (propertyType != null && propertyType.isNotEmpty)
        'propertyType': propertyType,
      if (city != null && city.isNotEmpty) 'city': city,
      if (locality != null && locality.isNotEmpty) 'locality': locality,
      if (minPrice != null) 'minPrice': minPrice.toString(),
      if (maxPrice != null) 'maxPrice': maxPrice.toString(),
      if (search != null && search.isNotEmpty) 'search': search,
    };
    final query = Uri(queryParameters: params).query;
    return '$baseUrl/properties/latest?$query';
  }
  static String commercialProperties({
    String? category = 'commercial',
    String? listingFor,
    String? propertyType,
    int page = 1,
    int limit = 10,
  }) {
    final params = <String, String>{
      if (category != null && category.isNotEmpty) 'category': category,
      if (listingFor != null && listingFor.isNotEmpty) 'listingFor': listingFor,
      if (propertyType != null && propertyType.isNotEmpty)
        'propertyType': propertyType,
      'page': page.toString(),
      'limit': limit.toString(),
    };
    final query = Uri(queryParameters: params).query;
    return '$baseUrl/properties?$query';
  }

  // --------------------------------------
  // Banners
  // --------------------------------------
  static const homeBanners = "$baseUrl/banners/home";
  static String bannersByPosition({required String position}) =>
      "$baseUrl/banners?position=$position";
  static String bannerClick({required String id}) =>
      "$baseUrl/banners/$id/click";

  // --------------------------------------
  // Commercial Spaces (User Endpoints)
  // --------------------------------------
  static String commercialSpacesList({
    String? spaceType,
    String? listingFor,
    double? minPrice,
    double? maxPrice,
    double? minArea,
    double? maxArea,
    String? city,
    String? locality,
    String? search,
    int page = 1,
    int limit = 20,
  }) {
    final params = <String, String>{
      if (spaceType != null && spaceType.isNotEmpty) 'spaceType': spaceType,
      if (listingFor != null && listingFor.isNotEmpty) 'listingFor': listingFor,
      if (minPrice != null) 'minPrice': minPrice.toString(),
      if (maxPrice != null) 'maxPrice': maxPrice.toString(),
      if (minArea != null) 'minArea': minArea.toString(),
      if (maxArea != null) 'maxArea': maxArea.toString(),
      if (city != null && city.isNotEmpty) 'city': city,
      if (locality != null && locality.isNotEmpty) 'locality': locality,
      if (search != null && search.isNotEmpty) 'search': search,
      'page': page.toString(),
      'limit': limit.toString(),
    };
    final query = Uri(queryParameters: params).query;
    return '$baseUrl/commercial-spaces?$query';
  }

  static String commercialFeaturedSpaces({
    String? spaceType,
    int page = 1,
    int limit = 10,
  }) {
    final params = <String, String>{
      if (spaceType != null && spaceType.isNotEmpty) 'spaceType': spaceType,
      'page': page.toString(),
      'limit': limit.toString(),
    };
    final query = Uri(queryParameters: params).query;
    return '$baseUrl/commercial-spaces/featured?$query';
  }

  static String commercialNearMe({
    double? lat,
    double? lng,
    double radius = 50,
    String radiusUnit = 'km',
    String? city,
    int page = 1,
    int limit = 10,
  }) {
    final params = <String, String>{
      if (lat != null) 'lat': lat.toString(),
      if (lng != null) 'lng': lng.toString(),
      'radius': radius.toString(),
      'radiusUnit': radiusUnit,
      if (city != null && city.isNotEmpty) 'city': city,
      'page': page.toString(),
      'limit': limit.toString(),
    };
    final query = Uri(queryParameters: params).query;
    return '$baseUrl/commercial-spaces/near-me?$query';
  }

  static const commercialSpaceTypes = "$baseUrl/commercial-spaces/types";

  static String commercialUserDashboard({
    int page = 1,
    int limit = 10,
    String? status,
  }) {
    final params = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
      if (status != null && status.isNotEmpty) 'status': status,
    };
    final query = Uri(queryParameters: params).query;
    return '$baseUrl/commercial-spaces/my-dashboard?$query';
  }

  static String commercialSpaceDetail({required String id}) =>
      "$baseUrl/commercial-spaces/$id";

  static String keyHandover({required String id}) =>
      "$baseUrl/properties/$id/key-handover";
  static const legalTerms = "$serverUrl/api/legal/terms";
  static const legalPrivacyPolicy = "$serverUrl/api/legal/privacy-policy";
  static const legalAboutUs = "$serverUrl/api/pages/about-us";
  static const legalHelp = "$serverUrl/api/pages/help-support";
  static const updateUser = "$baseUrl/users/update-me";
  static const allDeveloper = "$baseUrl/users/developers";
  // ... existing constants ...

  static String nearProperties({
    String? city,
    required double lat,
    required double lng,
    double radius = 50, // default, can be overridden
    String radiusUnit = 'km', // default, can be overridden
  }) =>
      "$baseUrl/properties/near-me?city=$city&lat=$lat&lng=$lng&radius=$radius&radiusUnit=$radiusUnit";
  static const allNotifications = "$baseUrl/notifications";
  static String readNotification({required String id}) =>
      "$baseUrl/notifications/$id/read";
  static const markAllNofication = "$baseUrl/notifications/mark-all-read";
  static String deleteNotification({required String id}) =>
      "$baseUrl/notifications/$id";
  static const clearAllNotifications = "$baseUrl/notifications/clear-all";
  static const allNews = "$baseUrl/news";
  static String categoryNews({required String id}) =>
      "$baseUrl/news/category/$id";
  static const featuredNews = "$baseUrl/news/featured";
  static String newsDetail({required String id}) => "$baseUrl/news/$id";
  static String developerDetail({required String id}) =>
      "$baseUrl/developers/$id";
  static String enquiry({required String developerId}) =>
      "$baseUrl/developers/$developerId/enquiry";
  static String submitReview({required String developerId}) =>
      "$baseUrl/developers/$developerId/reviews";
  static String getDeveloperReview({
    required String developerId,
    int? pageNo,
    int? pageSize,
  }) => pageNo != null && pageSize != null
      ? "$baseUrl/developers/$developerId/reviews?page=$pageNo&limit=$pageSize"
      : "$baseUrl/developers/$developerId/reviews";
  static String myDeveloperReview({required String developerId}) =>
      "$baseUrl/developers/$developerId/my-review";
  static String deleteDeveloperReview({required String developerId}) =>
      "$baseUrl/developers/$developerId/reviews";
  static const directReview = "$baseUrl/reviews";

  // --------------------------------------
  // Wishlist
  // --------------------------------------
  static const wishlist = "$baseUrl/wishlist";
  static const toggleWishlist = "$baseUrl/wishlist/toggle";
  static String checkWishlist({required String id}) =>
      "$baseUrl/wishlist/check/$id";
  static String removeWishlist({required String id}) => "$baseUrl/wishlist/$id";
}
