import 'package:dartz/dartz.dart';

import '../../../../../core/failure/failure.dart';
import '../../data/models/signup_register_psw.dart';
import '../entities/auth_entity.dart';
import '../repositories/psw_register_repo.dart';

class RegisterPswUseCase {
  final PswRegistrationRepository repository;

  RegisterPswUseCase(this.repository);

  Future<Either<Failure, AuthEntity>> call(PswRegisterRequest request) =>
      repository.registerPsw(request);
}
