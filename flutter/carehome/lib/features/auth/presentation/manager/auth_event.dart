part of 'auth_bloc.dart';

abstract class AuthEvent {}

// ── App start ────────────────────────────────────────────────────────────────
/// Fired from SplashScreen — checks secure storage for a saved token.
class CheckAuthStatusEvent extends AuthEvent {}

// ── Sign In ──────────────────────────────────────────────────────────────────
class SignInEvent extends AuthEvent {
  final SignInRequest request;
  SignInEvent(this.request);
}

// ── Biometric ────────────────────────────────────────────────────────────────
/// Fires OS biometric prompt, then silently re-calls login API.
class BiometricLoginEvent extends AuthEvent {}

/// Saves the user's choice after the "Enable biometric?" dialog.
class EnableBiometricEvent extends AuthEvent {
  final bool enable;

  EnableBiometricEvent(this.enable);
}

// ── Logout ───────────────────────────────────────────────────────────────────
class LogoutEvent extends AuthEvent {}

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