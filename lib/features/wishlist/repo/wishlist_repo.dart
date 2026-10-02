import 'package:flutter/foundation.dart';
import 'package:gharmb_app/core/constants/app_urls.dart';
import 'package:gharmb_app/core/data/network/network_api_service.dart';
import 'package:gharmb_app/core/utils/local_storage/auth_storage.dart';
import 'package:gharmb_app/features/wishlist/models/wishlist_response_model.dart';

class WishlistRepo {
  final NetworkApiService _api;

  WishlistRepo({NetworkApiService? networkApiService})
      : _api = networkApiService ?? NetworkApiService();

  Future<void> _attachToken() async {
    final String token = await LocalStorageService.getToken() ?? "";
    if (token.isNotEmpty) {
      _api.setToken(token);
    }
  }

  /// 📥 GET /api/wishlist - Get all wishlist items
  Future<WishlistResponseModel?> getWishlist() async {
    try {
      await _attachToken();
      final res = await _api.getApi(AppUrls.wishlist);
      if (res != null && res is Map<String, dynamic>) {
        return WishlistResponseModel.fromJson(res);
      }
      return null;
    } catch (e) {
      debugPrint("Error in getWishlist: $e");
      return null;
    }
  }

  /// 🔄 POST /api/wishlist/toggle - Toggle wishlist item
  Future<bool> toggleWishlist({
    required String propertyId,
    String itemType = 'Property',
  }) async {
    try {
      await _attachToken();
      final payload = {
        "propertyId": propertyId,
        "property": propertyId,
        "itemType": itemType,
      };
      final res = await _api.postApi(AppUrls.toggleWishlist, payload);
      if (res != null && res is Map<String, dynamic>) {
        if (res['status'] == 'success' || res['success'] == true) {
          return true;
        }
      }
      return res != null;
    } catch (e) {
      debugPrint("Error in toggleWishlist: $e");
      return false;
    }
  }

  /// 🔍 GET /api/wishlist/check/:id - Check if item is in wishlist
  Future<bool> checkWishlist(String id) async {
    try {
      await _attachToken();
      final res = await _api.getApi(AppUrls.checkWishlist(id: id));
      if (res != null && res is Map<String, dynamic>) {
        if (res['data'] != null && res['data'] is Map<String, dynamic>) {
          return res['data']['isWishlisted'] == true ||
              res['data']['isFavorited'] == true;
        }
        return res['isWishlisted'] == true ||
            res['isFavorited'] == true ||
            res['status'] == 'success';
      }
      return false;
    } catch (e) {
      debugPrint("Error in checkWishlist: $e");
      return false;
    }
  }

  /// 🗑 DELETE /api/wishlist/:id - Remove item from wishlist
  Future<bool> removeWishlist(String id) async {
    try {
      await _attachToken();
      final res = await _api.deleteApi(AppUrls.removeWishlist(id: id), null);
      if (res != null && res is Map<String, dynamic>) {
        return res['status'] == 'success' || res['success'] == true;
      }
      return res != null;
    } catch (e) {
      debugPrint("Error in removeWishlist: $e");
      return false;
    }
  }
}
