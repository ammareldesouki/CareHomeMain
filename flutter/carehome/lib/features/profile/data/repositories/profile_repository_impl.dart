import 'package:dartz/dartz.dart';

import '../../../../../core/failure/failure.dart';
import '../../../../../core/failure/server_failure.dart';
import '../../domain/entities/admin_profile_entity.dart';
import '../../domain/entities/carehome_profile_entity.dart';
import '../../domain/entities/psw_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../data_sources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PswProfileEntity>> getPswProfile() async {
    try {
      final result = await remoteDataSource.getPswProfile();
      return Right(result);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminProfileEntity>> getAdminProfile() async {
    try {
      final result = await remoteDataSource.getAdminProfile();
      return Right(result);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CareHomeProfileEntity>> getCareHomeProfile() async {
    try {
      final result = await remoteDataSource.getCareHomeProfile();
      return Right(result);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PswProfileEntity>> updatePswProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await remoteDataSource.updatePswProfile(data);
      return Right(result);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CareHomeProfileEntity>> updateCareHomeProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await remoteDataSource.updateCareHomeProfile(data);
      return Right(result);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updatePswDocument({
    required String documentType,
    required String filePath,
  }) async {
    try {
      final result = await remoteDataSource.updatePswDocument(
        documentType: documentType,
        filePath: filePath,
      );
      return Right(result);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
