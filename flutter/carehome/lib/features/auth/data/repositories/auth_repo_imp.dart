import 'package:carehome/features/auth/domain/repositories/auth_repo_interface.dart';

import '../../domain/entities/user_entity.dart';
import '../data_sources/auth_remote_datasource.dart';

class AuthRepoImpl implements AuthRepoInterFace {
  final AuthRemoteDataSource remote;

  AuthRepoImpl(this.remote);

  @override
  forgetPassword({required String email}) async {
    // TODO: implement forgetPassword
    return await remote.forgetPassword(email);
  }

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    return await remote.login(email, password);
  }

  @override
  Future<UserEntity> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    return await remote.register(name, email, password, phone, role);
  }
}
