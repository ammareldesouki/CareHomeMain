class SignInResponse {
  final String token;
  final String expiresAtUtc;
  final String email;
  final String role;
  final String userId;

  const SignInResponse({
    required this.token,
    required this.expiresAtUtc,
    required this.email,
    required this.role,
    required this.userId,
  });

  factory SignInResponse.fromMap(Map<String, dynamic> map) => SignInResponse(
    token: map['token'] ?? '',
    expiresAtUtc: map['expiresAtUtc'] ?? '',
    email: map['email'] ?? '',
    role: map['role'] ?? '',
    userId: map['userId'] ?? '',
  );
}