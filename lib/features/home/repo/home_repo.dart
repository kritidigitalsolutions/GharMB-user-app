import 'package:gharmb_app/core/constants/app_urls.dart';
import 'package:gharmb_app/core/data/network/network_api_service.dart';
import 'package:gharmb_app/core/utils/local_storage/auth_storage.dart';
import 'package:gharmb_app/features/home/models/response/notification_detail_response.dart';
import 'package:gharmb_app/features/home/models/response/notification_response_model.dart';

class HomeRepo {
  final NetworkApiService _api = NetworkApiService();
  Future<NotificationResponse?> allUserNotification() async {
    final String token = await LocalStorageService.getToken() ?? "";
    if (token.isEmpty) {
      print("no token!");
      return null;
    }
    _api.setToken(token);
    final res = await _api.getApi(AppUrls.allNotifications);
    if (res == null) {
      print("no response!");
      return null;
    }
    return NotificationResponse.fromJson(res);
  }

  Future<NotificationDetailResponse?> notificationRead({
    required String id,
  }) async {
    final String token = await LocalStorageService.getToken() ?? "";
    if (token.isEmpty) {
      print("no token!");
      return null;
    }
    _api.setToken(token);
    final res = await _api.pacthApi(AppUrls.readNotification(id: id), null);
    if (res == null) {
      print("no response!");
      return null;
    }
    return NotificationDetailResponse.fromJson(res);
  }

  Future<bool> markAllNotification() async {
    final String token = await LocalStorageService.getToken() ?? "";
    if (token.isEmpty) {
      print("token is null");
      return false;
    }
    _api.setToken(token);
    final res = await _api.postApi(AppUrls.markAllNofication, null);
    if (res == null) {
      print("no response");
      return false;
    }
    print("all notification mark");
    return true;
  }
}
