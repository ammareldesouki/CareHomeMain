part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthSignInLoading extends AuthState {}

class AuthSignInSuccess extends AuthState {}

class AuthSignInError extends AuthState {
  final String error;

  AuthSignInError({required this.error});
}
