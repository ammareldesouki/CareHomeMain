class UserEntity {
  final String id;

  // final String name;
  final String email;
  final String role;
  final String token;

  const UserEntity({
    required this.id,
    // required this.name,
    required this.email,
    required this.role,
    required this.token,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['userId'],
      // name: json['name'],
      email: json['email'],
      role: json['role'],
      token: json['token'],
    );
  }
}
