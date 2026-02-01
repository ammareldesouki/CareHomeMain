class SignupRequest {
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;
  final String dateOfBirth;
  final String role;

  SignupRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fullName'] = fullName;
    map['email'] = email;
    map['password'] = password;
    map['phoneNumber'] = phoneNumber;
    map['dateOfBirth'] = dateOfBirth;
    map['role'] = role;
    return map;
  }
}
