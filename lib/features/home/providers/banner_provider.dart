import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/features/home/models/response/home_banner_response.dart';
import 'package:gharmb_app/features/home/repo/banner_repo.dart';

final bannerRepoProvider = Provider<BannerRepo>((ref) {
  return BannerRepo();
});

/// 🌟 Home Banners Future Provider
final homeBannersProvider =
    FutureProvider<HomeBannerResponse?>((ref) async {
  final repo = ref.watch(bannerRepoProvider);
  return repo.getHomeBanners();
});
