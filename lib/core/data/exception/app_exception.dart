class AppException implements Exception {
  final String message;
  final String prefix;
  final dynamic data;
  final int? statusCode;

  AppException(
    this.message,
    this.prefix, {
    this.data,
    this.statusCode,
  });

  @override
  String toString() {
    return "$prefix $message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message, dynamic data, int? statusCode])
    : super(
        message ?? "Error During Communication",
        "FetchDataException: ",
        data: data,
        statusCode: statusCode,
      );
}

class BadRequestException extends AppException {
  BadRequestException([String? message, dynamic data, int? statusCode])
    : super(
        message ?? "Invalid Request",
        "BadRequestException: ",
        data: data,
        statusCode: statusCode,
      );
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String? message, dynamic data, int? statusCode])
    : super(
        message ?? "Unauthorized Request",
        "UnauthorizedException: ",
        data: data,
        statusCode: statusCode,
      );
}

class ForbiddenException extends AppException {
  ForbiddenException([String? message, dynamic data])
    : super(
        message ?? "Account Suspended or Access Denied",
        "ForbiddenException: ",
        data: data,
        statusCode: 403,
      );
}

class NotFoundException extends AppException {
  NotFoundException([String? message, dynamic data])
    : super(
        message ?? "Resource Not Found",
        "NotFoundException: ",
        data: data,
        statusCode: 404,
      );
}

class ConflictException extends AppException {
  ConflictException([String? message, dynamic data])
    : super(
        message ?? "Resource Already Exists",
        "ConflictException: ",
        data: data,
        statusCode: 409,
      );
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message, dynamic data, int? statusCode])
    : super(
        message ?? "Invalid Input",
        "InvalidInputException: ",
        data: data,
        statusCode: statusCode,
      );
}
