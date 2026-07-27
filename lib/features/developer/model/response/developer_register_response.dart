// developer_registration_response.dart

class DeveloperRegistrationResponse {
  final String status;
  final String message;
  final String token;
  final DeveloperData data;

  DeveloperRegistrationResponse({
    required this.status,
    required this.message,
    required this.token,
    required this.data,
  });

  factory DeveloperRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return DeveloperRegistrationResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      data: DeveloperData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'token': token,
      'data': data.toJson(),
    };
  }
}

class DeveloperData {
  final DeveloperUser user;

  DeveloperData({required this.user});

  factory DeveloperData.fromJson(Map<String, dynamic> json) {
    return DeveloperData(user: DeveloperUser.fromJson(json['user'] ?? {}));
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson()};
  }
}

class DeveloperUser {
  final String id;
  final String name;
  final String companyName;
  final String phone;
  final String role;
  final String reraNumber;
  final String gstNumber;
  final String yearsInBusiness;
  final String cityOfOperation;
  final DeveloperDocs builderDocs;
  final String builderVerificationStatus;

  DeveloperUser({
    required this.id,
    required this.name,
    required this.companyName,
    required this.phone,
    required this.role,
    required this.reraNumber,
    required this.gstNumber,
    required this.yearsInBusiness,
    required this.cityOfOperation,
    required this.builderDocs,
    required this.builderVerificationStatus,
  });

  factory DeveloperUser.fromJson(Map<String, dynamic> json) {
    return DeveloperUser(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      companyName: json['companyName'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      reraNumber: json['reraNumber'] ?? '',
      gstNumber: json['gstNumber'] ?? '',
      yearsInBusiness: json['yearsInBusiness'] ?? '',
      cityOfOperation: json['cityOfOperation'] ?? '',
      builderDocs: DeveloperDocs.fromJson(json['builderDocs'] ?? {}),
      builderVerificationStatus: json['builderVerificationStatus'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'companyName': companyName,
      'phone': phone,
      'role': role,
      'reraNumber': reraNumber,
      'gstNumber': gstNumber,
      'yearsInBusiness': yearsInBusiness,
      'cityOfOperation': cityOfOperation,
      'builderDocs': builderDocs.toJson(),
      'builderVerificationStatus': builderVerificationStatus,
    };
  }
}

class DeveloperDocs {
  final String reraCertificate;
  final String panCard;
  final String companyLogo;

  DeveloperDocs({
    required this.reraCertificate,
    required this.panCard,
    required this.companyLogo,
  });

  factory DeveloperDocs.fromJson(Map<String, dynamic> json) {
    return DeveloperDocs(
      reraCertificate: json['reraCertificate'] ?? '',
      panCard: json['panCard'] ?? '',
      companyLogo: json['companyLogo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reraCertificate': reraCertificate,
      'panCard': panCard,
      'companyLogo': companyLogo,
    };
  }
}
