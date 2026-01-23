import 'package:carehome/features/auth/domain/entities/user_entity.dart';
import 'package:carehome/features/auth/domain/repositories/auth_repo_interface.dart';

class SignInUseCase {
  final AuthRepoInterFace authRepo;

  SignInUseCase(this.authRepo);

  Future<UserEntity> call(String email, String password) {
    return authRepo.signIn(email: email, password: password);
  }
}
