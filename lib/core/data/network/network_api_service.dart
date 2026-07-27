import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gharmb_app/core/data/exception/app_exception.dart';
import 'package:gharmb_app/core/data/network/base_api_service.dart';

class NetworkApiService extends BaseApiService {
  late Dio _dio;

  NetworkApiService() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {"Content-Type": "application/json"},
      ),
    );

    /// Interceptor for logging
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint("➡️ REQUEST [${options.method}] => ${options.uri}");
          final safeHeaders = Map<String, dynamic>.from(options.headers);
          if (safeHeaders.containsKey("Authorization")) {
            safeHeaders["Authorization"] = "Bearer ***";
          }
          debugPrint("Headers: $safeHeaders");
          debugPrint("Data: ${options.data}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint("✅ RESPONSE [${response.statusCode}] => ${response.data}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          debugPrint("❌ ERROR [${e.response?.statusCode}] => ${e.message}");
          return handler.next(e);
        },
      ),
    );
  }

  /// 🔑 Set Authorization Token
  void setToken(String token) {
    _dio.options.headers["Authorization"] = "Bearer $token";
    debugPrint("🔐 Authorization token set");
  }

  /// ❌ Remove Token (Logout)
  void clearToken() {
    _dio.options.headers.remove("Authorization");
    debugPrint("🔓 Token Cleared");
  }

  @override
  Future<dynamic> getApi(String url) async {
    try {
      debugPrint("GET API CALL => $url");
      final response = await _dio.get(url);
      return returnResponse(response);
    } on DioException catch (e) {
      debugPrint("GET API ERROR => ${e.message}");
      throw _handleDioError(e);
    }
  }

  @override
  Future<dynamic> postApi(String url, dynamic data) async {
    try {
      debugPrint("POST API CALL => $url");
      debugPrint("POST DATA => $data");

      final response = await _dio.post(url, data: data);
      return returnResponse(response);
    } on DioException catch (e) {
      debugPrint("POST API ERROR => ${e.message}");
      throw _handleDioError(e);
    }
  }

  @override
  Future<dynamic> pacthApi(String url, dynamic data) async {
    try {
      debugPrint("POST API CALL => $url");
      debugPrint("POST DATA => $data");

      final response = await _dio.patch(url, data: data);
      return returnResponse(response);
    } on DioException catch (e) {
      debugPrint("POST API ERROR => ${e.message}");
      throw _handleDioError(e);
    }
  }

  @override
  Future<dynamic> putApi(String url, dynamic data) async {
    try {
      debugPrint("PUT API CALL => $url");
      debugPrint("PUT DATA => $data");

      final response = await _dio.put(url, data: data);
      return returnResponse(response);
    } on DioException catch (e) {
      debugPrint("PUT API ERROR => ${e.message}");
      throw _handleDioError(e);
    }
  }

  @override
  Future<dynamic> deleteApi(String url, dynamic data) async {
    try {
      debugPrint("DELETE API CALL => $url");

      final response = await _dio.delete(url, data: data);
      return returnResponse(response);
    } on DioException catch (e) {
      debugPrint("DELETE API ERROR => ${e.message}");
      throw _handleDioError(e);
    }
  }

  @override
  Future<dynamic> uploadMultipartApi(
    String url,
    Map<String, dynamic> fields, {
    List<MultipartFileData>? files,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    try {
      debugPrint("UPLOAD API CALL => $url");
      debugPrint("UPLOAD FIELDS => $fields");

      final formMap = <String, dynamic>{...fields};

      if (files != null && files.isNotEmpty) {
        for (final fileData in files) {
          final file = File(fileData.filePath);
          if (!await file.exists()) {
            throw BadRequestException(
              "File not found at path: ${fileData.filePath}",
            );
          }

          final multipartFile = await MultipartFile.fromFile(
            fileData.filePath,
            filename: fileData.fileName ?? fileData.filePath.split('/').last,
          );

          // Support multiple files under the same field name
          if (formMap[fileData.fieldName] == null) {
            formMap[fileData.fieldName] = multipartFile;
          } else if (formMap[fileData.fieldName] is List) {
            (formMap[fileData.fieldName] as List).add(multipartFile);
          } else {
            formMap[fileData.fieldName] = [
              formMap[fileData.fieldName],
              multipartFile,
            ];
          }
        }
      }

      final formData = FormData.fromMap(formMap);

      final response = await _dio.post(
        url,
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
        onSendProgress: onSendProgress,
      );
      return returnResponse(response);
    } on DioException catch (e) {
      debugPrint("UPLOAD API ERROR => ${e.message}");
      throw _handleDioError(e);
    }
  }

  AppException _handleDioError(DioException error) {
    debugPrint("HANDLE ERROR => ${error.response?.data}");

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return FetchDataException("Connection timeout");

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        final message = _extractErrorMessage(error.response?.data);

        if (statusCode == 400) {
          return BadRequestException(message);
        } else if (statusCode == 401 || statusCode == 403) {
          return UnauthorizedException(message);
        } else if (statusCode >= 500) {
          return FetchDataException(message);
        } else {
          return BadRequestException(message);
        }

      case DioExceptionType.cancel:
        return FetchDataException("Request cancelled");

      case DioExceptionType.unknown:
      default:
        return FetchDataException("No Internet Connection");
    }
  }

  String _extractErrorMessage(dynamic data) {
    if (data is Map) {
      final message = data['message'] ?? data['error'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }

      final errors = data['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          return firstError.first.toString();
        }
        return firstError.toString();
      }
    }

    if (data is String && data.trim().isNotEmpty) return data.trim();
    return "Something went wrong. Please try again.";
  }
}

dynamic returnResponse(Response response) {
  switch (response.statusCode) {
    case 200:
    case 201:
      return response.data;

    case 400:
      throw BadRequestException(response.data.toString());

    case 401:
    case 403:
      throw UnauthorizedException(response.data.toString());

    case 500:
    default:
      throw FetchDataException(
        "Error occurred with status code : ${response.statusCode}",
      );
  }
}
