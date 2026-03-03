class UserEntity {
  final String token;
  final String email;
  final String role;
  final String userId;

  const UserEntity({
    required this.token,
    required this.email,
    required this.role,
    required this.userId,
  });
}