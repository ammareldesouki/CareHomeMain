import 'package:carehome/features/auth/data/models/signup_request.dart';
import 'package:carehome/features/auth/domain/entities/signUp_response.dart';
import 'package:carehome/features/auth/domain/entities/user_entity.dart';
import 'package:carehome/features/auth/domain/repositories/auth_repo_interface.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';

class SignUpUseCase {
  AuthRepoInterFace authRepo;

  SignUpUseCase(this.authRepo);

  Future<Either<Failure, SignUpResponse>> call(SignupRequest user) {
    return authRepo.signUp(user);
  }
}
