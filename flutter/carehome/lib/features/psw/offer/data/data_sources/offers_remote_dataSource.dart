import 'package:dio/dio.dart';

import '../../../../../core/constants/api.dart';
import '../../../../../core/failure/server_failure.dart';
import '../../../../../core/network/dio_handler.dart';
import '../models/offer_detail_model.dart';
import '../models/offer_list_item_model.dart';

abstract class OffersRemoteDataSource {
  Future<List<OfferListItemModel>> getOffers({
    required int pageIndex,
    required int pageSize,
    String? careHomeId,
    String? search,
    String? sort,
  });

  Future<OfferDetailModel> getOfferById(String id);
}

class OffersRemoteDataSourceImpl implements OffersRemoteDataSource {
  final Dio _dio = NetworkDioHandler().dio;

  @override
  Future<List<OfferListItemModel>> getOffers({
    required int pageIndex,
    required int pageSize,
    String? careHomeId,
    String? search,
    String? sort,
  }) async {
    try {
      final params = <String, dynamic>{
        'PageIndex': pageIndex,
        'PageSize': pageSize,
      };
      if (careHomeId != null) params['CareHomeId'] = careHomeId;
      if (search != null && search.isNotEmpty) params['Search'] = search;
      if (sort != null && sort.isNotEmpty) params['Sort'] = sort;

      final response = await _dio.get(
        EndPoints.offers,
        queryParameters: params,
      );

      // API may return a paginated wrapper or a plain list
      final dynamic body = response.data;
      final List<dynamic> list;
      if (body is List) {
        list = body;
      } else if (body is Map && body.containsKey('data')) {
        list = body['data'] as List<dynamic>;
      } else {
        list = [];
      }

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