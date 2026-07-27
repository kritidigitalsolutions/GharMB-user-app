// developer_registration_payload.dart

class DeveloperRegistrationPayload {
  final String companyName;
  final String reraNumber;
  final String gstNumber;
  final String yearsInBusiness;
  final String cityOfOperation;
  final String reraCertificate;
  final String panCard;
  final String companyLogo;

  DeveloperRegistrationPayload({
    required this.companyName,
    required this.reraNumber,
    required this.gstNumber,
    required this.yearsInBusiness,
    required this.cityOfOperation,
    required this.reraCertificate,
    required this.panCard,
    required this.companyLogo,
  });

  factory DeveloperRegistrationPayload.fromJson(Map<String, dynamic> json) {
    return DeveloperRegistrationPayload(
      companyName: json['companyName'] ?? '',
      reraNumber: json['reraNumber'] ?? '',
      gstNumber: json['gstNumber'] ?? '',
      yearsInBusiness: json['yearsInBusiness'] ?? '',
      cityOfOperation: json['cityOfOperation'] ?? '',
      reraCertificate: json['reraCertificate'] ?? '',
      panCard: json['panCard'] ?? '',
      companyLogo: json['companyLogo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'reraNumber': reraNumber,
      'gstNumber': gstNumber,
      'yearsInBusiness': yearsInBusiness,
      'cityOfOperation': cityOfOperation,
      'reraCertificate': reraCertificate,
      'panCard': panCard,
      'companyLogo': companyLogo,
    };
  }

  // Optional: Copy with method
  DeveloperRegistrationPayload copyWith({
    String? companyName,
    String? reraNumber,
    String? gstNumber,
    String? yearsInBusiness,
    String? cityOfOperation,
    String? reraCertificate,
    String? panCard,
    String? companyLogo,
  }) {
    return DeveloperRegistrationPayload(
      companyName: companyName ?? this.companyName,
      reraNumber: reraNumber ?? this.reraNumber,
      gstNumber: gstNumber ?? this.gstNumber,
      yearsInBusiness: yearsInBusiness ?? this.yearsInBusiness,
      cityOfOperation: cityOfOperation ?? this.cityOfOperation,
      reraCertificate: reraCertificate ?? this.reraCertificate,
      panCard: panCard ?? this.panCard,
      companyLogo: companyLogo ?? this.companyLogo,
    );
  }
}
