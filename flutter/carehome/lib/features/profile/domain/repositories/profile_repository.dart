import 'package:dartz/dartz.dart';

import '../../../../../core/failure/failure.dart';
import '../entities/admin_profile_entity.dart';
import '../entities/carehome_profile_entity.dart';
import '../entities/psw_profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, PswProfileEntity>> getPswProfile();

  Future<Either<Failure, CareHomeProfileEntity>> getCareHomeProfile();

  Future<Either<Failure, AdminProfileEntity>> getAdminProfile();

  Future<Either<Failure, PswProfileEntity>> updatePswProfile(
    Map<String, dynamic> data,
  );

  Future<Either<Failure, CareHomeProfileEntity>> updateCareHomeProfile(
    Map<String, dynamic> data,
  );

  Future<Either<Failure, bool>> updatePswDocument({
    required String documentType,
    required String filePath,
  });
}
