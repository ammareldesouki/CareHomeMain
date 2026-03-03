import 'package:dartz/dartz.dart';

import '../../../../../core/failure/failure.dart';
import '../../../../../core/failure/server_failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repo_interface.dart';
import '../data_sources/auth_remote_datasource.dart';

import '../models/singIn_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> signIn(SignInRequest request) async {
    try {
      final response = await remoteDataSource.signIn(request);
      final entity = UserEntity(
        token: response.token,
        email: response.email,
        role: response.role,
        userId: response.userId,
      );
      return Right(entity);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}