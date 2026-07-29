class UserProfilePayload {
  final String name;
  final String email;
  final String phone;
  final String city;

  UserProfilePayload({
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
  });

  factory UserProfilePayload.fromJson(Map<String, dynamic> json) {
    return UserProfilePayload(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      city: json['city'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'phone': phone, 'city': city};
  }
}
