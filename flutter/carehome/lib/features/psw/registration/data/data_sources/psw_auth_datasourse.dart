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

  static String _basename(String path) {
    final normalized = path.replaceAll('\\', '/');
    final i = normalized.lastIndexOf('/');
    return i >= 0 && i < normalized.length - 1
        ? normalized.substring(i + 1)
        : normalized;
  }

  static Future<MultipartFile> _filePart(String path) =>
      MultipartFile.fromFile(path, filename: _basename(path));

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
      final optionalAid = firstAidOrCprFilePath;
      final formData = FormData.fromMap({
        'ProofIdentityType': proofIdentityType,
        'WorkStatus': workStatus,
        'ProofIdentityFile': await _filePart(proofIdentityFilePath),
        'PswCertificateFile': await _filePart(pswCertificateFilePath),
        'CVFile': await _filePart(cvFilePath),
        'ImmunizationRecordFile': await _filePart(immunizationRecordFilePath),
        'CriminalRecordFile': await _filePart(criminalRecordFilePath),
        if (optionalAid != null) 'FirstAidOrCPRFile': await _filePart(
            optionalAid),
      });

      await _dio.post(
        EndPoints.completeProfile,
        data: formData,
        options: Options(
          sendTimeout: const Duration(minutes: 3),
          receiveTimeout: const Duration(minutes: 3),
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        throw ServerFailure.fromMap(data);
      }
      throw ServerFailure(message: e.message ?? 'Unknown error');
    }
  }
}
