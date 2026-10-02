import 'package:flutter/foundation.dart';
import 'package:gharmb_app/core/constants/app_urls.dart';
import 'package:gharmb_app/core/data/network/network_api_service.dart';
import 'package:gharmb_app/features/home/models/response/home_banner_response.dart';

class BannerRepo {
  final NetworkApiService _api = NetworkApiService();

  /// 📥 Fetch Home Page Banners
  Future<HomeBannerResponse?> getHomeBanners() async {
    try {
      debugPrint('🖼️ [BannerRepo] Calling Home Banners: ${AppUrls.homeBanners}');
      final res = await _api.getApi(AppUrls.homeBanners);
      debugPrint('🖼️ [BannerRepo] Response: $res');

      if (res != null && res is Map<String, dynamic>) {
        return HomeBannerResponse.fromJson(res);
      }
      return null;
    } catch (e) {
      debugPrint('❌ [BannerRepo] Error fetching home banners: $e');
      return null;
    }
  }

  /// 👆 Track Banner Click
  Future<bool> trackBannerClick(String bannerId) async {
    if (bannerId.isEmpty) return false;
    try {
      final url = AppUrls.bannerClick(id: bannerId);
      debugPrint('🖱️ [BannerRepo] Tracking Banner Click: $url');
      final res = await _api.patchApi(url, null);
      return res != null;
    } catch (e) {
      debugPrint('❌ [BannerRepo] Error tracking click: $e');
      return false;
    }
  }
}
