import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gharmb_app/core/constants/app_urls.dart';
import 'package:gharmb_app/core/data/network/network_api_service.dart';
import 'package:gharmb_app/core/utils/local_storage/auth_storage.dart';
import 'package:gharmb_app/features/property/models/token_booking_model.dart';

class TokenBookingRepo {
  final NetworkApiService _api;

  TokenBookingRepo([NetworkApiService? api])
    : _api = api ?? NetworkApiService();

  Future<TokenConfigModel?> getTokenConfig(String propertyId) async {
    try {
      final token = await LocalStorageService.getToken();
      if (token != null && token.isNotEmpty) {
        _api.setToken(token);
      }

      final res = await _api.getApi(
        AppUrls.tokenConfig(propertyId: propertyId),
      );
      if (res != null && res['data'] is Map<String, dynamic>) {
        return TokenConfigModel.fromJson(res['data'] as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> uploadIdProof(File file) async {
    try {
      final token = await LocalStorageService.getToken();
      final dio = Dio();
      if (token != null && token.isNotEmpty) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      }

      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await dio.post(AppUrls.uploadSingle, data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map) {
          final url =
              data['url']?.toString() ??
              (data['file'] is Map ? data['file']['path']?.toString() : null) ??
              (data['data'] is Map ? data['data']['url']?.toString() : null);
          return url;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<TokenBookingResponse?> submitTokenBooking(
    TokenBookingSubmissionRequest request,
  ) async {
    final token = await LocalStorageService.getToken();
    if (token != null && token.isNotEmpty) {
      _api.setToken(token);
    }

    final res = await _api.postApi(
      request.toJson() as String,
      AppUrls.tokenBooking,
    );

    if (res != null) {
      return TokenBookingResponse.fromJson(res as Map<String, dynamic>);
    }
    return null;
  }

  Future<List<TokenRequestItem>> getMyTokenRequests({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final token = await LocalStorageService.getToken();
      if (token != null && token.isNotEmpty) {
        _api.setToken(token);
      }

      final res = await _api.getApi(
        AppUrls.myTokenRequests(page: page, limit: limit),
      );

      if (res != null && res['data'] is Map<String, dynamic>) {
        final list = res['data']['tokenRequests'] ?? res['data']['requests'];
        if (list is List) {
          return list
              .map((e) => TokenRequestItem.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> cancelTokenBooking(String id) async {
    try {
      final token = await LocalStorageService.getToken();
      if (token != null && token.isNotEmpty) {
        _api.setToken(token);
      }

      final res = await _api.patchApi(
        {} as String,
        AppUrls.cancelTokenBooking(id: id),
      );
      return res != null;
    } catch (e) {
      return false;
    }
  }
}
