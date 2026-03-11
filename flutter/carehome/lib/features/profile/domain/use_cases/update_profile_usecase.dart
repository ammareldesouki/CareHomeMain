import 'package:dartz/dartz.dart';

import '../../../../../core/failure/failure.dart';
import '../entities/carehome_profile_entity.dart';
import '../entities/psw_profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdatePswProfileUseCase {
  final ProfileRepository repository;

  UpdatePswProfileUseCase(this.repository);

  Future<Either<Failure, PswProfileEntity>> call(Map<String, dynamic> data) =>
      repository.updatePswProfile(data);
}

class UpdateCareHomeProfileUseCase {
  final ProfileRepository repository;

  UpdateCareHomeProfileUseCase(this.repository);

  Future<Either<Failure, CareHomeProfileEntity>> call(
    Map<String, dynamic> data,
  ) => repository.updateCareHomeProfile(data);
}

class UpdatePswDocumentUseCase {
  final ProfileRepository repository;

  UpdatePswDocumentUseCase(this.repository);

  Future<Either<Failure, bool>> call({
    required String documentType,
    required String filePath,
  }) => repository.updatePswDocument(
    documentType: documentType,
    filePath: filePath,
  );
}
