import 'package:dio/dio.dart';
import '../../../../../core/failure/server_failure.dart';
import '../../../../../core/network/dio_handler.dart';
import '../models/psw_application_model.dart';

abstract class PswApplicationRemoteDataSource {
  Future<void> apply({required String offerId, required List<String> shiftIds});

  Future<List<PswApplicationModel>> getMyApplications();

  Future<void> cancelApplication(String jobRequestItemId);
}

class PswApplicationRemoteDataSourceImpl
    implements PswApplicationRemoteDataSource {
  final _dio = NetworkDioHandler().dio;

  @override
  Future<void> apply({
    required String offerId,
    required List<String> shiftIds,
  }) async {
    try {
      await _dio.post(
        '/api/apply',
        data: {'offerId': offerId, 'shiftIds': shiftIds},
      );
    } on DioException catch (e) {
      throw ServerFailure.fromMap(e.response?.data ?? {});
    }
  }

  @override
  Future<List<PswApplicationModel>> getMyApplications() async {
    try {
      final response = await _dio.get('/api/psw/applications');
      final List data = response.data is List
          ? response.data
          : (response.data['items'] ?? response.data['data'] ?? []);
      return data.map((e) => PswApplicationModel.fromMap(e)).toList();
    } on DioException catch (e) {
      throw ServerFailure.fromMap(e.response?.data ?? {});
    }
  }

  @override
  Future<void> cancelApplication(String jobRequestItemId) async {
    try {
      await _dio.post(
        '/api/psw/applications/cancel',
        data: {'jobRequestItemId': jobRequestItemId},
      );
    } on DioException catch (e) {
      throw ServerFailure.fromMap(e.response?.data ?? {});
    }
  }
}
