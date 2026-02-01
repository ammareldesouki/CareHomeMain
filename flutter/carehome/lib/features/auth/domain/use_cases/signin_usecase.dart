import 'package:carehome/features/auth/data/models/singIn_request.dart';
import 'package:carehome/features/auth/domain/entities/signin_response.dart';
import 'package:carehome/features/auth/domain/entities/user_entity.dart';
import 'package:carehome/features/auth/domain/repositories/auth_repo_interface.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';

class SignInUseCase {
  final AuthRepoInterFace authRepo;

  SignInUseCase(this.authRepo);

  Future<Either<Failure, SignInResponse>> call(SignInRequest user) {
    return authRepo.signIn(user);
  }
}
