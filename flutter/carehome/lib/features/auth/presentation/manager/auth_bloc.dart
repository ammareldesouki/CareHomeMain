import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/failure/server_failure.dart';
import '../../../../../core/network/dio_handler.dart';
import '../../../psw/registration/data/data_sources/psw_auth_datasourse.dart';
import '../../../psw/registration/data/models/signup_register_psw.dart';
import '../../../psw/registration/data/repositories/psw_rigster_repo_impl.dart';
import '../../../psw/registration/domain/usecases/psw_signup_usecases.dart';
import '../../data/data_sources/auth_remote_datasource.dart';
import '../../data/models/singIn_request.dart';
import '../../data/repositories/auth_repo_imp.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/use_cases/signin_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    final signInUseCase = SignInUseCase(
      AuthRepositoryImpl(remoteDataSource: AuthRemoteDataSourceImpl()),
    );

    final registerPswUseCase = RegisterPswUseCase(
      PswRegistrationRepositoryImpl(
        remoteDataSource: PswRegistrationRemoteDataSourceImpl(),
      ),
    );

    // ── Sign In ──────────────────────────────────────────────────────────────
    on<SignInEvent>((event, emit) async {
      emit(AuthSignInLoading());
      final result = await signInUseCase(event.request);
      result.fold(
        (failure) {
          final msg = failure is ServerFailure
              ? (failure.messageEn ?? failure.message ?? 'Login failed')
              : 'Something went wrong';
          emit(AuthSignInError(msg));
        },
        (user) {
          NetworkDioHandler().setAuthToken(user.token);
          // ✅ Store userId + role so any screen can read it from the singleton
          NetworkDioHandler().setCurrentUser(
            userId: user.userId,
            role: user.role,
          );
          emit(AuthSignInSuccess(user));
        },
      );
    });

    // ── PSW Sign Up ──────────────────────────────────────────────────────────
    on<PswSignUpEvent>((event, emit) async {
      emit(AuthSignUpLoading());
      final request = PswRegisterRequest(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
        phoneNumber: event.phoneNumber,
        dateOfBirth: event.dateOfBirth,
        gender: event.gender,
        address: AddressRequest(
          apartmentNumber: int.tryParse(event.apartmentNumber) ?? 0,
          street: event.street,
          city: event.city,
          state: event.state,
          postalCode: event.postalCode,
          country: event.country,
        ),
      );
      final result = await registerPswUseCase(request);
      result.fold(
        (failure) {
          final msg = failure is ServerFailure
              ? (failure.messageEn ?? failure.message ?? 'Registration failed')
              : 'Something went wrong';
          emit(AuthSignUpError(msg));
        },
        (entity) {
          NetworkDioHandler().setAuthToken(entity.token);
          NetworkDioHandler().setCurrentUser(
            userId: entity.userId,
            role: 'PSW',
          );
          emit(AuthSignUpSuccess(token: entity.token, userId: entity.userId));
        },
      );
    });
  }
}