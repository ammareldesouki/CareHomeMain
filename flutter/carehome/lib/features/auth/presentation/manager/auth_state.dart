part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

// ── Sign In states ───────────────────────────────────────────────────────────
class AuthSignInLoading extends AuthState {}

class AuthSignInSuccess extends AuthState {
  final UserEntity user;

  AuthSignInSuccess(this.user);
}

class AuthSignInError extends AuthState {
  final String error;

  AuthSignInError(this.error);
}

// ── Sign Up states ───────────────────────────────────────────────────────────
class AuthSignUpLoading extends AuthState {}

class AuthSignUpSuccess extends AuthState {
  final String token;
  final String userId;

  AuthSignUpSuccess({required this.token, required this.userId});
}

class AuthSignUpError extends AuthState {
  final String error;

  AuthSignUpError(this.error);
}