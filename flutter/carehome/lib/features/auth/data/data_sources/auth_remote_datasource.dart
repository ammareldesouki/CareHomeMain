import 'package:dio/dio.dart';

import '../../../../../core/constants/api.dart';
import '../../../../../core/failure/server_failure.dart';
import '../../../../../core/network/dio_handler.dart';
import '../../domain/entities/signin_response.dart';
import '../models/singIn_request.dart';


abstract class AuthRemoteDataSource {
  Future<SignInResponse> signIn(SignInRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio = NetworkDioHandler().dio;

  @override
  Future<SignInResponse> signIn(SignInRequest request) async {
    try {
      final response = await _dio.post(
        EndPoints.login,
        data: request.toMap(),
      );
      return SignInResponse.fromMap(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        throw ServerFailure.fromMap(data);
      }
      throw ServerFailure(message: e.message ?? 'Unknown error');
    }
  }
}