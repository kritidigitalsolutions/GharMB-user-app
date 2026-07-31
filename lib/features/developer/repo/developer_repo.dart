import 'package:gharmb_app/core/constants/app_urls.dart';
import 'package:gharmb_app/core/data/network/network_api_service.dart';
import 'package:gharmb_app/features/developer/model/payload/agent_register_payload.dart';
import 'package:gharmb_app/features/developer/model/payload/developer_register_payload.dart';
import 'package:gharmb_app/features/developer/model/payload/enquiry_payload.dart';
import 'package:gharmb_app/features/developer/model/payload/review_payload.dart';
import 'package:gharmb_app/features/developer/model/response/agent_response.dart';
import 'package:gharmb_app/features/developer/model/response/all_developer_response.dart';
import 'package:gharmb_app/features/developer/model/response/detail_developer_model.dart';
import 'package:gharmb_app/features/developer/model/response/developer_register_response.dart';

import '../../../core/utils/local_storage/auth_storage.dart';

class DeveloperRepo {
  final NetworkApiService _api;

  DeveloperRepo({required NetworkApiService networkApiService})
    : _api = networkApiService;

  Future<AgentRegistrationResponse?> registerAgent({
    required AgentRegistrationPayload payload,
  }) async {
    try {
      final String token = await LocalStorageService.getToken() ?? "";
      if (token.isEmpty) {
        print("Token is null");
        return null;
      }
      print("Token: $token");
      _api.setToken(token);

      final res = await _api.postApi(AppUrls.agentRegister, payload.toJson());

      // Check if response is valid
      if (res != null && res is Map<String, dynamic>) {
        return AgentRegistrationResponse.fromJson(res);
      }
      return null;
    } catch (e) {
      print("Error in registerAgent: $e");
      return null;
    }
  }

  Future<DeveloperRegistrationResponse?> registerDeveloper({
    required DeveloperRegistrationPayload payload,
  }) async {
    try {
      final String token = await LocalStorageService.getToken() ?? "";
      if (token.isEmpty) {
        print("Token is null");
        return null;
      }
      print("Token: $token");
      _api.setToken(token);

      final res = await _api.postApi(
        AppUrls.developerRegister,
        payload.toJson(),
      );

      // Check if response is valid
      if (res != null && res is Map<String, dynamic>) {
        return DeveloperRegistrationResponse.fromJson(res);
      }
      return null;
    } catch (e) {
      print("Error in registerAgent: $e");
      return null;
    }
  }

  Future<AllDeveloperResponse?> allDevelopers() async {
    final res = await _api.getApi(AppUrls.allDeveloper);
    if (res == null) {
      print("null datat");
      return null;
    }
    return AllDeveloperResponse.fromJson(res);
  }

  Future<DeveloperDetailResponse?> detailDeveloper({required String id}) async {
    final res = await _api.getApi(AppUrls.developerDetail(id: id));
    if (res == null) {
      print("null data");
      return null;
    }
    return DeveloperDetailResponse.fromJson(res);
  }

  Future<bool> submitEnquiry({
    required String developerId,
    required String message,
  }) async {
    try {
      final String token = await LocalStorageService.getToken() ?? "";
      if (token.isEmpty) {
        print("Token is null");
        return false;
      }
      _api.setToken(token);

      final payload = EnquirySubmitPayload(
        developerId: developerId,
        message: message,
      );

      final res = await _api.postApi(
        AppUrls.enquiry(developerId: developerId),
        payload.toJson(),
      );

      return res != null;
    } catch (e) {
      print("Error in submitEnquiry: $e");
      return false;
    }
  }

  Future<bool> addReviewDeveloper({
    required String developerId,
    required ReviewPayload payload,
  }) async {
    final String token = await LocalStorageService.getToken() ?? "";
    if (token.isEmpty) {
      print("token is empty");
      return false;
    }
    _api.setToken(token);
    final url = await _api.postApi(
      AppUrls.submitReview(developerId: developerId),
      payload.toJson(),
    );
    if (url == null) {
      print("url is null");
      return false;
    }
    return true;
  }
}
