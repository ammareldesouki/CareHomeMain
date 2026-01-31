import 'package:carehome/core/constants/api.dart';
import 'package:carehome/core/network/dio_handler.dart';
import 'package:carehome/features/auth/data/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as api show post;

abstract class AuthRemoteDataSource {
  Future<Response> login(String email, String password);

  Future<Response> register(
    String name,
    String email,
    String password,
    String phone,
    String role,
  );

  Future<void> forgetPassword(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final NetworkDioHandler networkDioHandler;

  AuthRemoteDataSourceImpl(this.networkDioHandler);

  @override
  Future<Response> login(String email, String password) async {
    return networkDioHandler.dio.post(
      EndPoints.AuhtLogin,
      data: {'email': email, 'password': password},
    );
  }

  @override
  Future<void> forgetPassword(String email) async {
    final response = await Dio().post(
      'http://10.0.2.2:8000/api/login',
      data: {'email': email},
    );
  }

  @override
  Future<Response> register(
    String name,
    String email,
    String password,
    String phone,
    String role,
  ) async {
    return networkDioHandler.dio.post(
      EndPoints.Rigester,
      data: {
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
        'role': role,
      },
    );

  }
}
