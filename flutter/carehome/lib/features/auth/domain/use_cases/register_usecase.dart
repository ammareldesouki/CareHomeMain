import 'package:carehome/features/auth/domain/entities/user_entity.dart';
import 'package:carehome/features/auth/domain/repositories/auth_repo_interface.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';

class SignUpUseCase {
  AuthRepoInterFace authRepo;

  SignUpUseCase(this.authRepo);

  Future<Either<Failure, UserEntity>> call(
    String name,
    String email,
    String password,
    String phone,
    String role,
  ) {
    return authRepo.signUp(
      email: email,
      password: password,
      name: name,
      phone: phone,
      role: role,
    );
  }
}
