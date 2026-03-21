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

    final authDataSource = AuthRemoteDataSourceImpl();

    // ── Logout ───────────────────────────────────────────────────────────────
    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await authDataSource.logout();
      } catch (_) {
        // Even if the API call fails, log the user out locally
      }
      await NetworkDioHandler().clearAuthToken();
      emit(AuthLoggedOut());
    });

    // ── Sign In ──────────────────────────────────────────────────────────────
    on<SignInEvent>((event, emit) async {
      emit(AuthSignInLoading());
      final result = await signInUseCase(event.request);
      await result.fold<Future<void>>(
        (failure) async {
          final msg = failure is ServerFailure
              ? (failure.messageEn ?? failure.message ?? 'Login failed')
              : 'Something went wrong';
          emit(AuthSignInError(msg));
        },
        (user) async {
          await NetworkDioHandler().setAuthToken(user.token);
          NetworkDioHandler().setCurrentUser(
            userId: user.userId,
            role: user.role,
            workStatus: user.workStatus,
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
      await result.fold<Future<void>>(
        (failure) async {
          final msg = failure is ServerFailure
              ? (failure.messageEn ?? failure.message ?? 'Registration failed')
              : 'Something went wrong';
          emit(AuthSignUpError(msg));
        },
        (entity) async {
          await NetworkDioHandler().setAuthToken(entity.token);
          NetworkDioHandler().setCurrentUser(
            userId: entity.userId,
            role: 'PSW',
            workStatus: "None",
          );
          emit(AuthSignUpSuccess(token: entity.token, userId: entity.userId));
        },
      );
    });
  }
}