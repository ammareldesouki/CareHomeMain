class UserEntity {
  final String token;
  final String email;
  final String role;
  final String userId;
  final bool workStatus;

  const UserEntity({
    required this.token,
    required this.email,
    required this.role,
    required this.userId,
    this.workStatus = false,
  });
}