import 'package:flutter/foundation.dart';
import 'package:gharmb_app/core/constants/app_urls.dart';
import 'package:gharmb_app/core/data/exception/app_exception.dart';
import 'package:gharmb_app/core/data/network/network_api_service.dart';
import 'package:gharmb_app/features/property/models/response/near_properties_response.dart';

class CommercialRepo {
  final NetworkApiService _api = NetworkApiService();

  /// 1. GET /api/commercial-spaces (User directory with search, filter, pagination)
  Future<NearPropertiesResponse?> getCommercialProperties({
    String? category,
    String? listingFor, // 'Sale' / 'Rent' / 'Lease'
    String? propertyType, // 'Shop / Retail', 'Office Space', 'Showroom', etc.
    double? minPrice,
    double? maxPrice,
    double? minArea,
    double? maxArea,
    String? city,
    String? locality,
    String? search,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      // Primary: Dedicated /api/commercial-spaces endpoint
      final dedicatedListingFor = listingFor != null
          ? (listingFor.toLowerCase() == 'sell' || listingFor.toLowerCase() == 'buy'
              ? 'Sale'
              : (listingFor.toLowerCase() == 'rent' ? 'Rent' : listingFor))
          : null;

      final url = AppUrls.commercialSpacesList(
        spaceType: propertyType,
        listingFor: dedicatedListingFor,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minArea: minArea,
        maxArea: maxArea,
        city: city,
        locality: locality,
        search: search,
        page: page,
        limit: limit,
      );

      debugPrint('🏢 [CommercialRepo] GET API URL: $url');
      final res = await _api.getApi(url);
      debugPrint('🏢 [CommercialRepo] API Response: $res');

      NearPropertiesResponse? parsed;
      if (res is Map<String, dynamic>) {
        parsed = NearPropertiesResponse.fromJson(res);
      }

      // Fallback: If empty, also try /api/properties?category=commercial
      if (parsed == null || parsed.data.properties.isEmpty) {
        final fallbackUrl = AppUrls.commercialProperties(
          category: category ?? 'commercial',
          listingFor: listingFor,
          propertyType: propertyType,
          page: page,
          limit: limit,
        );
        debugPrint('🏢 [CommercialRepo] Fallback URL: $fallbackUrl');
        try {
          final fallbackRes = await _api.getApi(fallbackUrl);
          if (fallbackRes is Map<String, dynamic>) {
            final fallbackParsed = NearPropertiesResponse.fromJson(fallbackRes);
            if (fallbackParsed.data.properties.isNotEmpty) {
              return fallbackParsed;
            }
          }
        } catch (_) {}
      }

      return parsed;
    } on AppException catch (e) {
      debugPrint('❌ [CommercialRepo] AppException: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('❌ [CommercialRepo] Error: $e');
      throw FetchDataException('Failed to fetch commercial spaces: $e');
    }
  }

  /// 2. GET /api/commercial-spaces/featured (Featured commercial listings)
  Future<NearPropertiesResponse?> getFeaturedCommercialSpaces({
    String? spaceType,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final url = AppUrls.commercialFeaturedSpaces(
        spaceType: spaceType,
        page: page,
        limit: limit,
      );
      final res = await _api.getApi(url);
      if (res is Map<String, dynamic>) {
        return NearPropertiesResponse.fromJson(res);
      }
      return null;
    } catch (e) {
      debugPrint('❌ [CommercialRepo] getFeaturedCommercialSpaces Error: $e');
      return null;
    }
  }

  /// 3. GET /api/commercial-spaces/near-me (Proximity search)
  Future<NearPropertiesResponse?> getNearMeCommercialSpaces({
    double? lat,
    double? lng,
    double radius = 50,
    String radiusUnit = 'km',
    String? city,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final url = AppUrls.commercialNearMe(
        lat: lat,
        lng: lng,
        radius: radius,
        radiusUnit: radiusUnit,
        city: city,
        page: page,
        limit: limit,
      );
      final res = await _api.getApi(url);
      if (res is Map<String, dynamic>) {
        return NearPropertiesResponse.fromJson(res);
      }
      return null;
    } catch (e) {
      debugPrint('❌ [CommercialRepo] getNearMeCommercialSpaces Error: $e');
      return null;
    }
  }

  /// 4. GET /api/commercial-spaces/types (Summary counts per type)
  Future<Map<String, dynamic>?> getCommercialSpaceTypes() async {
    try {
      final url = AppUrls.commercialSpaceTypes;
      final res = await _api.getApi(url);
      if (res is Map<String, dynamic>) {
        return res;
      }
      return null;
    } catch (e) {
      debugPrint('❌ [CommercialRepo] getCommercialSpaceTypes Error: $e');
      return null;
    }
  }

  /// 5. GET /api/commercial-spaces/:id (Single space detail)
  Future<Property?> getCommercialSpaceDetail(String id) async {
    try {
      final url = AppUrls.commercialSpaceDetail(id: id);
      final res = await _api.getApi(url);
      if (res is Map<String, dynamic>) {
        final data = res['data'];
        if (data is Map<String, dynamic>) {
          final spaceMap = data['space'] ?? data['property'] ?? data;
          if (spaceMap is Map<String, dynamic>) {
            return Property.fromJson(spaceMap);
          }
        }
      }
      return null;
    } catch (e) {
      debugPrint('❌ [CommercialRepo] getCommercialSpaceDetail Error: $e');
      return null;
    }
  }

  /// 6. GET /api/commercial-spaces/my-dashboard (User's owner/agent commercial dashboard)
  Future<Map<String, dynamic>?> getCommercialDashboard({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      final url = AppUrls.commercialUserDashboard(
        page: page,
        limit: limit,
        status: status,
      );
      final res = await _api.getApi(url);
      if (res is Map<String, dynamic>) {
        return res;
      }
      return null;
    } catch (e) {
      debugPrint('❌ [CommercialRepo] getCommercialDashboard Error: $e');
      return null;
    }
  }
}
