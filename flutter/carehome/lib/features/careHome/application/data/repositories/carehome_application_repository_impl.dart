import 'package:dartz/dartz.dart';
import '../../../../../core/failure/failure.dart';
import '../../../../../core/failure/server_failure.dart';
import '../../domain/entities/carehome_application_entity.dart';
import '../../domain/repositories/carehome_application_repository.dart';
import '../data_sources/carehome_application_remote_datasource.dart';

class CareHomeApplicationRepositoryImpl
    implements CareHomeApplicationRepository {
  final CareHomeApplicationRemoteDataSource remoteDataSource;

  CareHomeApplicationRepositoryImpl({required this.remoteDataSource});

  // Future<Either<Failure, List<CareHomeApplicationEntity>>>
  // getApplications() async {
  //   try {
  //     final list = await remoteDataSource.getApplications();
  //     return Right(list);
  //   } on ServerFailure catch (e) {
  //     return Left(e);
  //   } catch (e) {
  //     return Left(ServerFailure(message: e.toString()));
  //   }
  // }

  @override
  Future<Either<Failure, List<CareHomeApplicationEntity>>>
  getApplicationsByOffer(String offerId) async {
    try {
      final list = await remoteDataSource.getApplicationsByOffer(offerId);
      return Right(list);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> acceptApplication({
    required String shiftId,
    required String jobRequestItemId,
  }) async {
    try {
      await remoteDataSource.acceptApplication(
        shiftId: shiftId,
        jobRequestItemId: jobRequestItemId,
      );
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> rejectApplication(
    String jobRequestItemId,
  ) async {
    try {
      await remoteDataSource.rejectApplication(jobRequestItemId);
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
