part of 'auth_bloc.dart';

abstract class AuthEvent {}

// ── Sign In ──────────────────────────────────────────────────────────────────
class SignInEvent extends AuthEvent {
  final SignInRequest request;

  SignInEvent(this.request);
}

// ── PSW Sign Up ──────────────────────────────────────────────────────────────
class PswSignUpEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phoneNumber;
  final String dateOfBirth;
  final String gender;
  final String apartmentNumber;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  PswSignUpEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.gender,
    required this.apartmentNumber,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });
}