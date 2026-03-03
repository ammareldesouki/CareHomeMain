class SignInRequest {
  final String email;
  final String password;

  const SignInRequest({required this.email, required this.password});

  Map<String, dynamic> toMap() =>
      {
        'email': email,
        'password': password,
      };
}