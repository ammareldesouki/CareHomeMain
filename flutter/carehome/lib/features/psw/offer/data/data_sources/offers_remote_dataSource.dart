import 'package:dio/dio.dart';

import '../../../../../core/constants/api.dart';
import '../../../../../core/failure/server_failure.dart';
import '../../../../../core/network/dio_handler.dart';
import '../models/offer_detail_model.dart';
import '../models/offer_list_item_model.dart';

abstract class OffersRemoteDataSource {
  Future<List<OfferListItemModel>> getOffers({
    required int pageNumber,
    required int pageSize,
  });

  Future<OfferDetailModel> getOfferById(String id);
}

class OffersRemoteDataSourceImpl implements OffersRemoteDataSource {
  // Singleton Dio — already has Bearer token set after login
  final Dio _dio = NetworkDioHandler().dio;

  @override
  Future<List<OfferListItemModel>> getOffers({
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      final response = await _dio.get(
        EndPoints.offers,
        queryParameters: {'pageNumber': pageNumber, 'pageSize': pageSize},
      );
      final list = response.data as List<dynamic>;
      return list
          .map((e) => OfferListItemModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) throw ServerFailure.fromMap(data);
      throw ServerFailure(message: e.message ?? 'Failed to load offers');
    }
  }

  @override
  Future<OfferDetailModel> getOfferById(String id) async {
    try {
      final response = await _dio.get(EndPoints.offerById(id));
      return OfferDetailModel.fromMap(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) throw ServerFailure.fromMap(data);
      throw ServerFailure(message: e.message ?? 'Failed to load offer');
    }
  }
}
