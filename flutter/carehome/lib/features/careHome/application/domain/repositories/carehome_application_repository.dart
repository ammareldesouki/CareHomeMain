import 'package:dartz/dartz.dart';
import '../../../../../core/failure/failure.dart';
import '../entities/carehome_application_entity.dart';

abstract class CareHomeApplicationRepository {
  /// GET /api/carehome/applications/{offerId}
  Future<Either<Failure, List<CareHomeApplicationEntity>>>
  getApplicationsByOffer(String offerId);

  /// POST /api/carehome/applications/accept
  /// Body: { shiftId, jobRequestItemId }
  Future<Either<Failure, void>> acceptApplication({
    required String shiftId,
    required String jobRequestItemId,
  });

  /// POST /api/carehome/applications/reject
  /// Body: { jobRequestItemId }
  Future<Either<Failure, void>> rejectApplication(String jobRequestItemId);
}
