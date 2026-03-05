class SignInResponse {
  final String token;
  final String expiresAtUtc;
  final String email;
  final String role;
  final String userId;
  final bool workStatus;

  const SignInResponse({
    required this.token,
    required this.expiresAtUtc,
    required this.email,
    required this.role,
    required this.userId,
    this.workStatus = false,
  });

  factory SignInResponse.fromMap(Map<String, dynamic> map) => SignInResponse(
    token: map['token'] ?? '',
    expiresAtUtc: map['expiresAtUtc'] ?? '',
    email: map['email'] ?? '',
    role: map['role'] ?? '',
    userId: map['userId'] ?? '',
    workStatus: map['workStatus'] ?? false,
  );
}