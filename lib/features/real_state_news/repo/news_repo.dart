import 'package:gharmb_app/core/constants/app_urls.dart';
import 'package:gharmb_app/core/data/network/network_api_service.dart';
import 'package:gharmb_app/features/real_state_news/models/featured_news_response_model.dart';
import 'package:gharmb_app/features/real_state_news/models/news_detail_response_model.dart';
import 'package:gharmb_app/features/real_state_news/models/news_response_model.dart';

class NewsRepo {
  final NetworkApiService _api = NetworkApiService();
  Future<NewsResponse?> allNews() async {
    final res = await _api.getApi(AppUrls.allNews);
    if (res == null) {
      print("api is empty");
    }
    return NewsResponse.fromJson(res);
  }

  Future<FeaturedNewsResponse?> allFeaturedNews() async {
    final res = await _api.getApi(AppUrls.featuredNews);
    if (res == null) {
      print("api is empty");
    }
    return FeaturedNewsResponse.fromJson(res);
  }

  Future<NewsDetailResponse?> newsDetail({required String id}) async {
    final res = await _api.getApi(AppUrls.newsDetail(id: id));
    if (res == null) {
      print("api is not working!");
    }
    return NewsDetailResponse.fromJson(res);
  }

  Future<NewsResponse?> categoryNews({required String categoryId}) async {
    final res = await _api.getApi(AppUrls.categoryNews(id: categoryId));
    if (res == null) {
      print("api is not working!");
    }
    return NewsResponse.fromJson(res);
  }
}
