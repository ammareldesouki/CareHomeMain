import 'package:carehome/core/constants/api.dart';
import 'package:carehome/core/network/dio_handler.dart';
import 'package:carehome/features/auth/data/models/signup_request.dart';
import 'package:carehome/features/auth/data/models/singIn_request.dart';
import 'package:carehome/features/auth/data/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as api show post;

abstract class AuthRemoteDataSource {
  Future<Response> login(SignInRequest user);

  Future<Response> register(SignupRequest user
  );

  Future<void> forgetPassword(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final NetworkDioHandler networkDioHandler;

  AuthRemoteDataSourceImpl(this.networkDioHandler);

  @override
  Future<Response> login(SignInRequest user) async {
    return networkDioHandler.dio.post(
      EndPoints.AuhtLogin,
      data: {'email': user.email, 'password': user.password},
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
  Future<Response> register(SignupRequest user
  ) async {
    return networkDioHandler.dio.post(
      EndPoints.Rigester,
      data: {
        'email': user.email,
        'password': user.password,
        'fullName': user.fullName,
        'phoneNumber': user.phoneNumber,
        'role': user.role,
        'dateOfBirth': user.dateOfBirth
      },
    );

  }
}
