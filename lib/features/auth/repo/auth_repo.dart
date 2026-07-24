import 'package:gharmb_app/core/constants/app_urls.dart';
import 'package:gharmb_app/core/data/exception/app_exception.dart';
import 'package:gharmb_app/core/data/network/network_api_service.dart';
import 'package:gharmb_app/core/utils/local_storage/auth_storage.dart';
import 'package:gharmb_app/features/auth/models/request/user_register_req_model.dart';
import 'package:gharmb_app/features/auth/models/response/auth_response_model.dart';

class AuthRepo {
  final NetworkApiService _api = NetworkApiService();

  // register

  Future<Map<String, dynamic>> userRegister(UserRegisterReqModel model) async {
    try {
      final res = await _api.postApi(AppUrls.register, model.toJson());

      if (res is Map<String, dynamic>) {
        return res;
      }

      return {"data": res};
    } on AppException {
      rethrow;
    } catch (e) {
      throw FetchDataException(e.toString());
    }
  }

  // login

  Future<Map<String, dynamic>> login(String phone) async {
    try {
      final res = await _api.postApi(AppUrls.login, {"phone": phone});

      if (res is Map<String, dynamic>) {
        return res;
      }

      return {"data": res};
    } on AppException {
      rethrow;
    } catch (e) {
      throw FetchDataException(e.toString());
    }
  }

  // Otp verify

  Future<AuthResponseModel> verifyOTP(String phone, String otp) async {
    try {
      final res = await _api.postApi(AppUrls.verifyOtp, {
        "phone": phone,
        "otp": otp,
      });

      return AuthResponseModel.fromJson(res);
    } on AppException {
      rethrow;
    } catch (e) {
      throw FetchDataException(e.toString());
    }
  }

  Future<Map<String, dynamic>> completedRegister(
    UserRegisterReqModel model,
  ) async {
    try {
      final String token = await LocalStorageService.getToken() ?? '';
      _api.setToken(token);
      final res = await _api.pacthApi(AppUrls.register, model.toJson());

      if (res is Map<String, dynamic>) {
        return res;
      }

      return {"data": res};
    } on AppException {
      rethrow;
    } catch (e) {
      throw FetchDataException(e.toString());
    }
  }
}
