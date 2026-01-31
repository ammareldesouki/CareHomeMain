import 'package:carehome/features/auth/data/data_sources/auth_remote_datasource.dart';
import 'package:carehome/features/auth/data/repositories/auth_repo_imp.dart';
import 'package:carehome/features/auth/domain/repositories/auth_repo_interface.dart';
import 'package:carehome/features/di/serve_locator.dart';

import '../../core/constants/api.dart';
import '../../core/network/dio_handler.dart';
import '../auth/domain/use_cases/register_usecase.dart';
import '../auth/domain/use_cases/signin_usecase.dart';
import '../auth/presentation/manager/auth_bloc.dart';

abstract class AuthDi {
  // Dio
  // Data Source
  // Repository
  // Use Cases
  // Bloc
  static Future<void> setUp() async {
    sl
      ..registerLazySingleton(() => NetworkDioHandler(ApiConstat.baseUrl))
      ..registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(sl.get<NetworkDioHandler>()),
      )
      ..registerLazySingleton<AuthRepoInterFace>(
        () => AuthRepoImpl(sl.get<AuthRemoteDataSource>()),
      )
      ..registerLazySingleton(() => SignInUseCase(sl.get<AuthRepoInterFace>()))
      ..registerLazySingleton(() => SignUpUseCase(sl.get<AuthRepoInterFace>()))
      ..registerLazySingleton<AuthBloc>(() => AuthBloc());
    // ..registerLazySingleton(()=>ForgetPasswordUseCase(sl.get<AuthRepositoriseInterface>()));
  }
}
