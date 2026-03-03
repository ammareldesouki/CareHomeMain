class AuthResponse {
  final String token;
  final String expiresAtUtc;
  final String email;
  final String role;
  final String userId;

  const AuthResponse({
    required this.token,
    required this.expiresAtUtc,
    required this.email,
    required this.role,
    required this.userId,
  });

  factory AuthResponse.fromMap(Map<String, dynamic> map) => AuthResponse(
    token: map['token'] ?? '',
    expiresAtUtc: map['expiresAtUtc'] ?? '',
    email: map['email'] ?? '',
    role: map['role'] ?? '',
    userId: map['userId'] ?? '',
  );
}
