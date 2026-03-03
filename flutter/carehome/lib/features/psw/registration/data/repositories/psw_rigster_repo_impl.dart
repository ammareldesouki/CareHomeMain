import 'package:dartz/dartz.dart';

import '../../../../../core/failure/failure.dart';
import '../../../../../core/failure/server_failure.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/psw_register_repo.dart';
import '../data_sources/psw_auth_datasourse.dart';
import '../models/signup_register_psw.dart';

class PswRegistrationRepositoryImpl implements PswRegistrationRepository {
  final PswRegistrationRemoteDataSource remoteDataSource;

  PswRegistrationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AuthEntity>> registerPsw(
    PswRegisterRequest request,
  ) async {
    try {
      final response = await remoteDataSource.registerPsw(request);
      final entity = AuthEntity(
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

  @override
  Future<Either<Failure, void>> completeProfile({
    required String proofIdentityType,
    required bool workStatus,
    required String proofIdentityFilePath,
    required String pswCertificateFilePath,
    required String cvFilePath,
    required String immunizationRecordFilePath,
    required String criminalRecordFilePath,
    String? firstAidOrCprFilePath,
  }) async {
    try {
      await remoteDataSource.completeProfile(
        proofIdentityType: proofIdentityType,
        workStatus: workStatus,
        proofIdentityFilePath: proofIdentityFilePath,
        pswCertificateFilePath: pswCertificateFilePath,
        cvFilePath: cvFilePath,
        immunizationRecordFilePath: immunizationRecordFilePath,
        criminalRecordFilePath: criminalRecordFilePath,
        firstAidOrCprFilePath: firstAidOrCprFilePath,
      );
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
