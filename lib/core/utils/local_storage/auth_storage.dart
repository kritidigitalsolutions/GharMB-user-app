import 'dart:convert';

import 'package:gharmb_app/features/auth/models/response/auth_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService._();

  static const String _tokenKey = "auth_token";
  static const String _userKey = "auth_user";
  static const String _authResponseKey = "auth_response";

  static Future<void> saveAuthResponse(AuthResponseModel response) async {
    final prefs = await SharedPreferences.getInstance();

    final token = response.token;
    final user = response.data?.user;

    if (token != null && token.isNotEmpty) {
      await prefs.setString(_tokenKey, token);
    }

    if (user != null) {
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
    }

    // Optional: complete response store
    await prefs.setString(_authResponseKey, jsonEncode(response.toJson()));
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<AuthUserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    final userData = prefs.getString(_userKey);

    if (userData == null || userData.isEmpty) {
      return null;
    }

    try {
      final decodedData = jsonDecode(userData);

      if (decodedData is Map<String, dynamic>) {
        return AuthUserModel.fromJson(decodedData);
      }

      if (decodedData is Map) {
        return AuthUserModel.fromJson(Map<String, dynamic>.from(decodedData));
      }

      return null;
    } catch (error) {
      return null;
    }
  }

  static Future<AuthResponseModel?> getAuthResponse() async {
    final prefs = await SharedPreferences.getInstance();

    final responseData = prefs.getString(_authResponseKey);

    if (responseData == null || responseData.isEmpty) {
      return null;
    }

    try {
      final decodedData = jsonDecode(responseData);

      if (decodedData is Map) {
        return AuthResponseModel.fromJson(
          Map<String, dynamic>.from(decodedData),
        );
      }

      return null;
    } catch (error) {
      return null;
    }
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    await prefs.remove(_authResponseKey);
  }
}
