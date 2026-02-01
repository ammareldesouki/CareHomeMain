part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthSignInLoading extends AuthState {}

class AuthSignInSuccess extends AuthState {
  final SignInResponse user;

  AuthSignInSuccess({required this.user});
}

class AuthSignInError extends AuthState {
  final String error;

  AuthSignInError({required this.error});
}

class AuthSignUpLoading extends AuthState {}

class AuthSignUpSuccess extends AuthState {
  final SignUpResponse user;

  AuthSignUpSuccess({required this.user});
}

class AuthSignUpError extends AuthState {
  final String error;

  AuthSignUpError({required this.error});
}
