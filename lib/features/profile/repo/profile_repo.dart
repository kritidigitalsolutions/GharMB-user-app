import 'package:gharmb_app/core/constants/app_urls.dart';
import 'package:gharmb_app/core/data/network/network_api_service.dart';
import 'package:gharmb_app/core/utils/local_storage/auth_storage.dart';
import 'package:gharmb_app/features/profile/models/dashboard_model.dart';
import 'package:gharmb_app/features/profile/models/profile_model.dart';
import 'package:gharmb_app/features/profile/models/update_profile_payload.dart';
import 'package:gharmb_app/features/profile/models/verification_status_model.dart';

class ProfileRepo {
  final NetworkApiService _api = NetworkApiService();

  Future<DashboardResponse?> getDashboardData() async {
    final String token = await LocalStorageService.getToken() ?? "";
    if (token.isEmpty) {
      print("No token found");
      return null;
    }
    _api.setToken(token);
    final res = await _api.getApi(AppUrls.dashBoardUrl);
    if (res == null) {
      return null;
    }
    return DashboardResponse.fromJson(res);
  }

  Future<DashboardResponse?> getCommercialDashboardData() async {
    final String token = await LocalStorageService.getToken() ?? "";
    if (token.isEmpty) {
      print("No token found");
      return null;
    }
    _api.setToken(token);
    final res = await _api.getApi(AppUrls.commercialDashboardUrl);
    if (res == null) {
      return null;
    }
    return DashboardResponse.fromJson(res);
  }

  Future<UserProfileResponse?> getUser() async {
    final String token = await LocalStorageService.getToken() ?? "";
    if (token.isEmpty) {
      print("No token found");
      return null;
    }
    _api.setToken(token);
    final res = await _api.getApi(AppUrls.getProfile);
    if (res == null) {
      return null;
    }
    return UserProfileResponse.fromJson(res);
  }

  Future<VerificationStatusResponse?> getVerificationStatus() async {
    final String token = await LocalStorageService.getToken() ?? "";
    if (token.isEmpty) {
      print("No token found");
      return null;
    }
    _api.setToken(token);
    final res = await _api.getApi(AppUrls.verificationStatus);
    if (res == null) {
      return null;
    }
    return VerificationStatusResponse.fromJson(res);
  }

  Future<UserProfileResponse?> updateProfile({
    required UserProfilePayload payload,
  }) async {
    final String token = await LocalStorageService.getToken() ?? "";
    if (token.isNotEmpty) {
      _api.setToken(token);
    }
    final url = await _api.pacthApi(AppUrls.updateUser, payload.toJson());
    if (url == null) {
      return null;
    }
    return UserProfileResponse.fromJson(url);
  }
}
