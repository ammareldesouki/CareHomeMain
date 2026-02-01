import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:carehome/core/constants/api.dart';
import 'package:carehome/features/auth/data/models/singIn_request.dart';
import 'package:carehome/features/auth/domain/entities/signin_response.dart';
import 'package:meta/meta.dart';

import '../../../../core/failure/server_failure.dart';
import '../../../../core/network/dio_handler.dart';
import '../../data/data_sources/auth_remote_datasource.dart';
import '../../data/models/signup_request.dart';
import '../../data/repositories/auth_repo_imp.dart';
import '../../domain/entities/signUp_response.dart';
import '../../domain/repositories/auth_repo_interface.dart';
import '../../domain/use_cases/register_usecase.dart';
import '../../domain/use_cases/signin_usecase.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late SignInUseCase signInUseCase;
  late SignUpUseCase signUpUseCase;
  late AuthRepoInterFace authRepo;
  late AuthRemoteDataSource authRemoteDataSource;





  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      on<SignInEvent>((_signIn));
      on<SignUpEvent>((_signUp));

    });
  }

  FutureOr<void> _signIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthSignInLoading());
    authRemoteDataSource =
        AuthRemoteDataSourceImpl(NetworkDioHandler(ApiConstat.baseUrl));
    authRepo = AuthRepoImpl(authRemoteDataSource);
    signInUseCase = SignInUseCase(authRepo);
    final result = await signInUseCase.call(event.user);
    return result.fold((fail) {
      var serverErorr = fail as ServerFailure;
      emit(AuthSignInError(error: serverErorr.message ?? "Failed to sign in"));
    }, (data) => emit(AuthSignInSuccess(user: data)));
  }

  FutureOr<void> _signUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthSignInLoading());

    authRemoteDataSource =
        AuthRemoteDataSourceImpl(NetworkDioHandler(ApiConstat.baseUrl));
    authRepo = AuthRepoImpl(authRemoteDataSource);
    signUpUseCase = SignUpUseCase(authRepo);
    final result = await signUpUseCase.call(event.user);

    return result.fold((fail) {
      var serverErorr = fail as ServerFailure;
      emit(AuthSignUpError(error: serverErorr.message ?? "Failed to sign in"));
    }, (data) => emit(AuthSignUpSuccess(user: data)));
  }
}
