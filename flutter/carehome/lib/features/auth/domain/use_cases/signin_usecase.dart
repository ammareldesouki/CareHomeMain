import 'package:dartz/dartz.dart';

import '../../../../../core/failure/failure.dart';

import '../../data/models/singIn_request.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repo_interface.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(SignInRequest request) =>
      repository.signIn(request);
}