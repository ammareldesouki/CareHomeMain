import 'package:carehome/core/constants/api.dart';
import 'package:dio/dio.dart';
import '../../../../../core/failure/server_failure.dart';
import '../../../../../core/network/dio_handler.dart';
import '../models/carehome_application_model.dart';

abstract class CareHomeApplicationRemoteDataSource {
  Future<List<CareHomeApplicationModel>> getApplicationsByOffer(String offerId);

  Future<void> acceptApplication({
    required String shiftId,
    required String jobRequestItemId,
  });

  Future<void> rejectApplication(String jobRequestItemId);
}

class CareHomeApplicationRemoteDataSourceImpl
    implements CareHomeApplicationRemoteDataSource {
  final _dio = NetworkDioHandler().dio;

  @override
  Future<List<CareHomeApplicationModel>> getApplicationsByOffer(
    String offerId,
  ) async {
    try {
      final response = await _dio.get(
          EndPoints.caregetApplicationsByOffer(offerId));
      final List data = response.data is List
          ? response.data
          : (response.data['items'] ?? response.data['data'] ?? []);
      return data.map((e) => CareHomeApplicationModel.fromMap(e)).toList();
    } on DioException catch (e) {
      throw ServerFailure.fromMap(e.response?.data ?? {});
    }
  }

  @override
  Future<void> acceptApplication({
    required String shiftId,
    required String jobRequestItemId,
  }) async {
    try {
      await _dio.post(
        EndPoints.careHomeAcceptApplication,
        data: {'shiftId': shiftId, 'jobRequestItemId': jobRequestItemId},
      );
    } on DioException catch (e) {
      throw ServerFailure.fromMap(e.response?.data ?? {});
    }
  }

  @override
  Future<void> rejectApplication(String jobRequestItemId) async {
    try {
      await _dio.post(
        EndPoints.careHomeRejectApplication,
        data: {'jobRequestItemId': jobRequestItemId},
      );
    } on DioException catch (e) {
      throw ServerFailure.fromMap(e.response?.data ?? {});
    }
  }
}
