import 'package:dartz/dartz.dart';
import '../../../../../core/failure/failure.dart';
import '../entities/psw_application_entity.dart';

abstract class PswApplicationRepository {
  Future<Either<Failure, void>> apply({
    required String offerId,
    required List<String> shiftIds,
  });

  Future<Either<Failure, List<PswApplicationEntity>>> getMyApplications();

  Future<Either<Failure, void>> cancelApplication(String jobRequestItemId);
}
