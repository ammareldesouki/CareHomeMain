import 'package:dartz/dartz.dart';
import '../../../../../core/failure/failure.dart';
import '../../../../../core/failure/server_failure.dart';
import '../../domain/entities/psw_application_entity.dart';
import '../../domain/repositories/psw_application_repository.dart';
import '../data_sources/psw_application_remote_dataSource.dart';

class PswApplicationRepositoryImpl implements PswApplicationRepository {
  final PswApplicationRemoteDataSource remoteDataSource;

  PswApplicationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> apply({
    required String offerId,
    required List<String> shiftIds,
  }) async {
    try {
      await remoteDataSource.apply(offerId: offerId, shiftIds: shiftIds);
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PswApplicationEntity>>>
  getMyApplications() async {
    try {
      final list = await remoteDataSource.getMyApplications();
      return Right(list);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelApplication(
    String jobRequestItemId,
  ) async {
    try {
      await remoteDataSource.cancelApplication(jobRequestItemId);
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
