part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class RegisterEvent extends AuthEvent {}

class ForgetPasswordEvent extends AuthEvent {}

class SignInEvent extends AuthEvent {
  SignInRequest user;

  SignInEvent(this.user);
}

class SignUpEvent extends AuthEvent {
  SignupRequest user;

  SignUpEvent(this.user);
}