/// Pure domain entity – no framework dependencies.
class AuthEntity {
  final String token;
  final String email;
  final String role;
  final String userId;

  const AuthEntity({
    required this.token,
    required this.email,
    required this.role,
    required this.userId,
  });
}
