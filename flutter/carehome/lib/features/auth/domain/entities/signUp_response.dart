class SignUpResponse {
  final String token;
  final String expiresAtUtc;
  final String email;
  final String role;
  final String userId;

  SignUpResponse({
    required this.token,
    required this.expiresAtUtc,
    required this.email,
    required this.role,
    required this.userId,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      token: json['token'],
      expiresAtUtc: json['expiresAtUtc'],
      email: json['email'],
      role: json['role'],
      userId: json['userId'],
    );
  }
}
