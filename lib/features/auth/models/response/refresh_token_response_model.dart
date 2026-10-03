import 'package:gharmb_app/features/auth/models/response/auth_response_model.dart';

class RefreshTokenResponseModel {
  final String? status;
  final String? message;
  final String? token;
  final String? accessToken;
  final String? refreshToken;
  final AuthUserModel? user;
  final RefreshTokenDataModel? data;

  const RefreshTokenResponseModel({
    this.status,
    this.message,
    this.token,
    this.accessToken,
    this.refreshToken,
    this.user,
    this.data,
  });

  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) {
    AuthUserModel? user;
    if (json["user"] is Map) {
      user = AuthUserModel.fromJson(Map<String, dynamic>.from(json["user"]));
    }

    RefreshTokenDataModel? data;
    if (json["data"] is Map) {
      data = RefreshTokenDataModel.fromJson(
        Map<String, dynamic>.from(json["data"]),
      );
    }

    return RefreshTokenResponseModel(
      status: json["status"]?.toString(),
      message: json["message"]?.toString(),
      token: json["token"]?.toString(),
      accessToken: json["accessToken"]?.toString(),
      refreshToken: json["refreshToken"]?.toString(),
      user: user ?? data?.user,
      data: data,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "token": token,
      "accessToken": accessToken,
      "refreshToken": refreshToken,
      "user": user?.toJson(),
      "data": data?.toJson(),
    };
  }

  /// Convenience getter for effective access token
  String? get effectiveToken =>
      token ?? accessToken ?? data?.token ?? data?.accessToken;

  /// Convenience getter for effective refresh token
  String? get effectiveRefreshToken => refreshToken ?? data?.refreshToken;

  /// Convenience getter for effective user
  AuthUserModel? get effectiveUser => user ?? data?.user;
}

class RefreshTokenDataModel {
  final String? token;
  final String? accessToken;
  final String? refreshToken;
  final AuthUserModel? user;

  const RefreshTokenDataModel({
    this.token,
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  factory RefreshTokenDataModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenDataModel(
      token: json["token"]?.toString(),
      accessToken: json["accessToken"]?.toString(),
      refreshToken: json["refreshToken"]?.toString(),
      user: json["user"] is Map
          ? AuthUserModel.fromJson(Map<String, dynamic>.from(json["user"]))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "token": token,
      "accessToken": accessToken,
      "refreshToken": refreshToken,
      "user": user?.toJson(),
    };
  }
}
