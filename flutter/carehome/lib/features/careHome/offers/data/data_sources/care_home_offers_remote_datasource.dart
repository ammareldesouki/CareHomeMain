import 'package:carehome/features/careHome/offers/data/models/offer_model.dart';
import 'package:dio/dio.dart';

import '../../../../../core/constants/api.dart';
import '../../../../../core/failure/server_failure.dart';
import '../../../../../core/network/dio_handler.dart';

abstract class CareHomeOffersRemoteDataSource {
  Future<List<CareHomeOfferListItem>> getOffers({
    required String careHomeId,
    int pageNumber = 1,
    int pageSize = 10,
  });

  Future<CareHomeOfferDetail> getOfferById(String id);

  Future<void> createOffer(CreateOfferRequest request);

  Future<void> updateOffer(String id, UpdateOfferRequest request);

  Future<void> deleteOffer(String id);
}

class CareHomeOffersRemoteDataSourceImpl
    implements CareHomeOffersRemoteDataSource {
  // Singleton Dio — Bearer token set after login automatically
  final Dio _dio = NetworkDioHandler().dio;

  @override
  Future<List<CareHomeOfferListItem>> getOffers({
    required String careHomeId,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _dio.get(
        EndPoints.offers,
        queryParameters: {
          'careHomeId': careHomeId,
          'pageNumber': pageNumber,
          'pageSize': pageSize,
        },
      );
      final list = response.data as List<dynamic>;
      return list
          .map((e) => CareHomeOfferListItem.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  @override
  Future<CareHomeOfferDetail> getOfferById(String id) async {
    try {
      final response = await _dio.get(EndPoints.offerById(id));
      return CareHomeOfferDetail.fromMap(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  @override
  Future<void> createOffer(CreateOfferRequest request) async {
    try {
      await _dio.post(EndPoints.offers, data: request.toMap());
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  @override
  Future<void> updateOffer(String id, UpdateOfferRequest request) async {
    try {
      await _dio.put(EndPoints.offerById(id), data: request.toMap());
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  @override
  Future<void> deleteOffer(String id) async {
    try {
      await _dio.delete(EndPoints.offerById(id));
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  void _handleError(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) throw ServerFailure.fromMap(data);
    throw ServerFailure(message: e.message ?? 'Offers request failed');
  }
}
