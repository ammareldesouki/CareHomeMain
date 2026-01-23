import 'package:carehome/features/auth/data/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as api show post;

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);

  Future<UserModel> register(
    String name,
    String email,
    String password,
    String phone,
    String role,
  );

  Future<void> forgetPassword(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    final response = await Dio().post(
      'http://10.0.2.2:8000/api/login',
      data: {'email': email, 'password': password},
    );

    return UserModel.fromJson(response.data);
  }

  @override
  Future<void> forgetPassword(String email) async {
    final response = await Dio().post(
      'http://10.0.2.2:8000/api/login',
      data: {'email': email},
    );
  }

  @override
  Future<UserModel> register(
    String name,
    String email,
    String password,
    String phone,
    String role,
  ) async {
    final response = await Dio().post(
      'http://10.0.2.2:8000/api/login',
      data: {
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
        'role': role,
      },
    );

    return UserModel.fromJson(response.data);
  }
}
