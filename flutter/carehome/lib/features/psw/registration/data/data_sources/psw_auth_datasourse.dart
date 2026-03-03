import 'package:dio/dio.dart';

import '../../../../../core/constants/api.dart';
import '../../../../../core/failure/server_failure.dart';
import '../../../../../core/network/dio_handler.dart';
import '../../domain/entities/signup_response.dart';
import '../models/signup_register_psw.dart';

abstract class PswRegistrationRemoteDataSource {
  Future<AuthResponse> registerPsw(PswRegisterRequest request);

  Future<void> completeProfile({
    required String proofIdentityType,
    required bool workStatus,
    required String proofIdentityFilePath,
    required String pswCertificateFilePath,
    required String cvFilePath,
    required String immunizationRecordFilePath,
    required String criminalRecordFilePath,
    String? firstAidOrCprFilePath,
  });
}

class PswRegistrationRemoteDataSourceImpl
    implements PswRegistrationRemoteDataSource {
  // Use the singleton Dio instance
  final Dio _dio = NetworkDioHandler().dio;

  @override
  Future<AuthResponse> registerPsw(PswRegisterRequest request) async {
    try {
      final response = await _dio.post(
        EndPoints.PwRegister,
        data: request.toMap(),
      );
      return AuthResponse.fromMap(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        throw ServerFailure.fromMap(data);
      }
      throw ServerFailure(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<void> completeProfile({
    required String proofIdentityType,
    required bool workStatus,
    required String proofIdentityFilePath,
    required String pswCertificateFilePath,
    required String cvFilePath,
    required String immunizationRecordFilePath,
    required String criminalRecordFilePath,
    String? firstAidOrCprFilePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'ProofIdentityType': proofIdentityType,
        'WorkStatus': workStatus,
        'ProofIdentityFile': await MultipartFile.fromFile(
          proofIdentityFilePath,
        ),
        'PswCertificateFile': await MultipartFile.fromFile(
          pswCertificateFilePath,
        ),
        'CVFile': await MultipartFile.fromFile(cvFilePath),
        'ImmunizationRecordFile': await MultipartFile.fromFile(
          immunizationRecordFilePath,
        ),
        'CriminalRecordFile': await MultipartFile.fromFile(
          criminalRecordFilePath,
        ),
        if (firstAidOrCprFilePath != null)
          'FirstAidOrCPRFile': await MultipartFile.fromFile(
            firstAidOrCprFilePath,
          ),
      });

      await _dio.post(EndPoints.completeProfile, data: formData);
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        throw ServerFailure.fromMap(data);
      }
      throw ServerFailure(message: e.message ?? 'Unknown error');
    }
  }
}
