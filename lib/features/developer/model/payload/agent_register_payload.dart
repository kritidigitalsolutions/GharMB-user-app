class AgentRegistrationPayload {
  final String name;
  final String phone;
  final String reraNumber;
  final String experience;
  final String cityOfOperation;
  final String reraCertificate;
  final String aadhaarCard;
  final String profilePhoto;

  AgentRegistrationPayload({
    required this.name,
    required this.phone,
    required this.reraNumber,
    required this.experience,
    required this.cityOfOperation,
    required this.reraCertificate,
    required this.aadhaarCard,
    required this.profilePhoto,
  });

  factory AgentRegistrationPayload.fromJson(Map<String, dynamic> json) {
    return AgentRegistrationPayload(
      name: json['name'] ?? "",
      phone: json['phone'] ?? "",
      reraNumber: json['reraNumber'] ?? '',
      experience: json['experience'] ?? '',
      cityOfOperation: json['cityOfOperation'] ?? '',
      reraCertificate: json['reraCertificate'] ?? '',
      aadhaarCard: json['aadhaarCard'] ?? '',
      profilePhoto: json['profilePhoto'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'reraNumber': reraNumber,
      'experience': experience,
      'cityOfOperation': cityOfOperation,
      'reraCertificate': reraCertificate,
      'aadhaarCard': aadhaarCard,
      'profilePhoto': profilePhoto,
    };
  }

  // Optional: Copy with method for updating specific fields
  AgentRegistrationPayload copyWith({
    String? name,
    String? phone,
    String? reraNumber,
    String? experience,
    String? cityOfOperation,
    String? reraCertificate,
    String? aadhaarCard,
    String? profilePhoto,
  }) {
    return AgentRegistrationPayload(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      reraNumber: reraNumber ?? this.reraNumber,
      experience: experience ?? this.experience,
      cityOfOperation: cityOfOperation ?? this.cityOfOperation,
      reraCertificate: reraCertificate ?? this.reraCertificate,
      aadhaarCard: aadhaarCard ?? this.aadhaarCard,
      profilePhoto: profilePhoto ?? this.profilePhoto,
    );
  }
}
