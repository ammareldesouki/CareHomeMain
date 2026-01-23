import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/failure/server_failure.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      // on<SignInEvent>((_signIn));
    });
  }
  // FutureOr<void> _signIn(SignInEvent event, Emitter<AuthState> emit) async {
  //   emit(AuthSignInLoading());
  //   final result = await sl<SignInUseCase>().call(event.data);
  //   return result.fold((fail) {
  //     var serverErorr = fail as ServerFailure;
  //     emit(AuthSignInError(error: serverErorr.message ?? "Failed to sign in"));
  //   }, (data) => emit(AuthSignInSuccess()));
  // }
}
