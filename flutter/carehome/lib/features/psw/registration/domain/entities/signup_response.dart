class AuthResponse {
  final String token;
  final String expiresAtUtc;
  final String email;
  final String role;
  final String userId;
  final bool workStatus;

  const AuthResponse({
    required this.token,
    required this.expiresAtUtc,
    required this.email,
    required this.role,
    required this.userId,
    required this.workStatus,
  });

  factory AuthResponse.fromMap(Map<String, dynamic> map) => AuthResponse(
    token: (map['token'] ?? map['accessToken'] ?? map['access_token'] ?? '')
        .toString(),
    expiresAtUtc: map['expiresAtUtc'] ?? '',
    email: map['email'] ?? '',
    role: map['role'] ?? '',
    userId: map['userId'] ?? '',
    workStatus: map['workStatus'] ?? false,
  );
}
