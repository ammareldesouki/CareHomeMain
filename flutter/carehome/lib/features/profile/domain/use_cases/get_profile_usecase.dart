import 'package:dartz/dartz.dart';

import '../../../../../core/failure/failure.dart';
import '../entities/admin_profile_entity.dart';
import '../entities/carehome_profile_entity.dart';
import '../entities/psw_profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetPswProfileUseCase {
  final ProfileRepository repository;

  GetPswProfileUseCase(this.repository);

  Future<Either<Failure, PswProfileEntity>> call() =>
      repository.getPswProfile();
}

class GetCareHomeProfileUseCase {
  final ProfileRepository repository;

  GetCareHomeProfileUseCase(this.repository);

  Future<Either<Failure, CareHomeProfileEntity>> call() =>
      repository.getCareHomeProfile();
}

class GetAdminProfileUseCase {
  final ProfileRepository repository;

  GetAdminProfileUseCase(this.repository);

  Future<Either<Failure, AdminProfileEntity>> call() =>
      repository.getAdminProfile();
}
