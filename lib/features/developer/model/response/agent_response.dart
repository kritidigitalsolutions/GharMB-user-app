class AgentRegistrationResponse {
  final String status;
  final String message;
  final String token;
  final UserData data;

  AgentRegistrationResponse({
    required this.status,
    required this.message,
    required this.token,
    required this.data,
  });

  factory AgentRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return AgentRegistrationResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      data: UserData.fromJson(json['data'] ?? {}),
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

class UserData {
  final User user;

  UserData({required this.user});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(user: User.fromJson(json['user'] ?? {}));
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson()};
  }
}

class User {
  final String id;
  final String name;
  final String phone;
  final String role;
  final String reraNumber;
  final String experience;
  final String cityOfOperation;
  final VerificationDocs verificationDocs;
  final String agentVerificationStatus;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.reraNumber,
    required this.experience,
    required this.cityOfOperation,
    required this.verificationDocs,
    required this.agentVerificationStatus,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      reraNumber: json['reraNumber'] ?? '',
      experience: json['experience'] ?? '',
      cityOfOperation: json['cityOfOperation'] ?? '',
      verificationDocs: VerificationDocs.fromJson(
        json['verificationDocs'] ?? {},
      ),
      agentVerificationStatus: json['agentVerificationStatus'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'role': role,
      'reraNumber': reraNumber,
      'experience': experience,
      'cityOfOperation': cityOfOperation,
      'verificationDocs': verificationDocs.toJson(),
      'agentVerificationStatus': agentVerificationStatus,
    };
  }
}

class VerificationDocs {
  final String reraCertificate;
  final String aadhaarCard;
  final String profilePhoto;

  VerificationDocs({
    required this.reraCertificate,
    required this.aadhaarCard,
    required this.profilePhoto,
  });

  factory VerificationDocs.fromJson(Map<String, dynamic> json) {
    return VerificationDocs(
      reraCertificate: json['reraCertificate'] ?? '',
      aadhaarCard: json['aadhaarCard'] ?? '',
      profilePhoto: json['profilePhoto'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reraCertificate': reraCertificate,
      'aadhaarCard': aadhaarCard,
      'profilePhoto': profilePhoto,
    };
  }
}
