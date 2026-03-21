import 'package:dio/dio.dart';

import '../../../../../core/constants/api.dart';
import '../../../../../core/failure/server_failure.dart';
import '../../../../../core/network/dio_handler.dart';
import '../models/admin_profile_model.dart';
import '../models/carehome_profile_model.dart';
import '../models/psw_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<PswProfileModel> getPswProfile();

  Future<CareHomeProfileModel> getCareHomeProfile();

  Future<AdminProfileModel> getAdminProfile();

  Future<PswProfileModel> updatePswProfile(Map<String, dynamic> data);

  Future<CareHomeProfileModel> updateCareHomeProfile(Map<String, dynamic> data);

  Future<bool> updatePswDocument({
    required String documentType,
    required String filePath,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio = NetworkDioHandler().dio;

  static String _basename(String path) {
    final normalized = path.replaceAll('\\', '/');
    final i = normalized.lastIndexOf('/');
    return i >= 0 && i < normalized.length - 1
        ? normalized.substring(i + 1)
        : normalized;
  }

  @override
  Future<PswProfileModel> getPswProfile() async {
    try {
      final response = await _dio.get(EndPoints.profile);
      return PswProfileModel.fromMap(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        throw ServerFailure.fromMap(data);
      }
      throw ServerFailure(message: e.message ?? 'Failed to load profile');
    }
  }

  @override
  Future<CareHomeProfileModel> getCareHomeProfile() async {
    try {
      final response = await _dio.get(EndPoints.profile);
      return CareHomeProfileModel.fromMap(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        throw ServerFailure.fromMap(data);
      }
      throw ServerFailure(message: e.message ?? 'Failed to load profile');
    }
  }

  @override
  Future<PswProfileModel> updatePswProfile(Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(EndPoints.profile, data: data);
      return PswProfileModel.fromMap(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final responseData = e.response?.data;
      if (responseData is Map<String, dynamic>) {
        throw ServerFailure.fromMap(responseData);
      }
      throw ServerFailure(message: e.message ?? 'Failed to update profile');
    }
  }

  @override
  Future<CareHomeProfileModel> updateCareHomeProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.put(EndPoints.profile, data: data);
      return CareHomeProfileModel.fromMap(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      final responseData = e.response?.data;
      if (responseData is Map<String, dynamic>) {
        throw ServerFailure.fromMap(responseData);
      }
      throw ServerFailure(message: e.message ?? 'Failed to update profile');
    }
  }

  @override
  Future<bool> updatePswDocument({
    required String documentType,
    required String filePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'documentType': documentType,
        'file': await MultipartFile.fromFile(
          filePath,
          filename: _basename(filePath),
        ),
      });
      await _dio.put(
        EndPoints.updateProfileDocument,
        data: formData,
        options: Options(
          sendTimeout: const Duration(minutes: 3),
          receiveTimeout: const Duration(minutes: 3),
        ),
      );
      return true;
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        throw ServerFailure.fromMap(data);
      }
      throw ServerFailure(message: e.message ?? 'Failed to update document');
    }
  }

  @override
  Future<AdminProfileModel> getAdminProfile() async {
    try {
      final response = await _dio.get(EndPoints.profile);
      return AdminProfileModel.fromMap(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        throw ServerFailure.fromMap(data);
      }
      throw ServerFailure(message: e.message ?? 'Failed to load profile');
    }
  }
}
