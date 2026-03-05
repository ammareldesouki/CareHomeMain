// domain/repositories/carehome_registration_repository.dart
import 'package:dartz/dartz.dart';

import '../../../../../core/failure/failure.dart';
import '../../../../auth/domain/entities/user_entity.dart';
import '../entities/carehome_register_request.dart';

abstract class CareHomeRegistrationRepository {
  Future<Either<Failure, UserEntity>> registerCareHome(
    CareHomeRegisterRequest request,
  );

  Future<Either<Failure, UserEntity>> registerIndividual(
    IndividualRegisterRequest request,
  );
}
