import 'package:dio/dio.dart';

import '../../../../../core/constants/api.dart';
import '../../../../../core/failure/server_failure.dart';
import '../../../../../core/network/dio_handler.dart';
import '../../../../auth/domain/entities/signin_response.dart';
import '../../domain/entities/carehome_register_request.dart';

abstract class CareHomeRegistrationRemoteDataSource {
  Future<SignInResponse> registerCareHome(CareHomeRegisterRequest request);

  Future<SignInResponse> registerIndividual(IndividualRegisterRequest request);
}

class CareHomeRegistrationRemoteDataSourceImpl
    implements CareHomeRegistrationRemoteDataSource {
  final Dio _dio = NetworkDioHandler().dio;

  @override
  Future<SignInResponse> registerCareHome(
    CareHomeRegisterRequest request,
  ) async {
    try {
      final response = await _dio.post(
        EndPoints.registerCareHome,
        data: request.toMap(),
      );
      return SignInResponse.fromMap(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  @override
  Future<SignInResponse> registerIndividual(
    IndividualRegisterRequest request,
  ) async {
    try {
      final response = await _dio.post(
        EndPoints.registerIndividual,
        data: request.toMap(),
      );
      return SignInResponse.fromMap(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  void _handleError(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) throw ServerFailure.fromMap(data);
    throw ServerFailure(message: e.message ?? 'Registration failed');
  }
}
