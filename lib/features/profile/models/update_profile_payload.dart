class UserProfilePayload {
  final String name;
  final String email;
  final String phone;
  final String city;
  final String? profilePicture;

  UserProfilePayload({
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    this.profilePicture,
  });

  factory UserProfilePayload.fromJson(Map<String, dynamic> json) {
    return UserProfilePayload(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      city: json['city'] ?? '',
      profilePicture: json['profilePicture']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
      'city': city,
    };
    if (profilePicture != null && profilePicture!.isNotEmpty) {
      map['profilePicture'] = profilePicture;
    }
    return map;
  }
}
