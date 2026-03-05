import 'package:dartz/dartz.dart';

import '../../../../../core/failure/failure.dart';
import '../../../../../core/failure/server_failure.dart';
import '../../../../auth/domain/entities/user_entity.dart';
import '../../domain/entities/carehome_register_request.dart';
import '../../domain/repositories/care_home_registration_repository.dart';
import '../data_sources/care_home_registration_remote_datasource.dart';

class CareHomeRegistrationRepositoryImpl
    implements CareHomeRegistrationRepository {
  final CareHomeRegistrationRemoteDataSource remoteDataSource;

  CareHomeRegistrationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> registerCareHome(
    CareHomeRegisterRequest request,
  ) async {
    try {
      final res = await remoteDataSource.registerCareHome(request);
      return Right(
        UserEntity(
          token: res.token,
          email: res.email,
          role: res.role,
          userId: res.userId,
        ),
      );
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> registerIndividual(
    IndividualRegisterRequest request,
  ) async {
    try {
      final res = await remoteDataSource.registerIndividual(request);
      return Right(
        UserEntity(
          token: res.token,
          email: res.email,
          role: res.role,
          userId: res.userId,
        ),
      );
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
