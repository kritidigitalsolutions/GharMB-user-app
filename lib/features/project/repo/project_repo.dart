import 'package:gharmb_app/core/constants/app_urls.dart';
import 'package:gharmb_app/core/data/network/network_api_service.dart';
import 'package:gharmb_app/core/utils/local_storage/auth_storage.dart';
import 'package:gharmb_app/features/project/model/propert_response_mode.dart';

class ProjectRepo {
  final NetworkApiService _api;

  ProjectRepo(this._api);

  Future<PropertyResponse?> allProperties() async {
    final String token = await LocalStorageService.getToken() ?? "";

    if (token.isEmpty) {
      print("Token is null");
      return null;
    }

    _api.setToken(token);

    final response = await _api.getApi(AppUrls.allProperties);

    if (response == null) {
      return null;
    }

    return PropertyResponse.fromJson(response);
  }
}
