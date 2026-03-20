import 'package:carehome/features/careHome/offers/data/models/offer_model.dart';
import 'package:dio/dio.dart';

import '../../../../../core/constants/api.dart';
import '../../../../../core/failure/server_failure.dart';
import '../../../../../core/network/dio_handler.dart';

abstract class CareHomeOffersRemoteDataSource {
  Future<OffersPage> getOffers({
    required String careHomeId,
    int pageIndex = 1,
    int pageSize = 10,
    String? search,
    String? sort,
  });

  Future<CareHomeOfferDetail> getOfferById(String id);
  Future<void> createOffer(CreateOfferRequest request);
  Future<void> updateOffer(String id, UpdateOfferRequest request);
  Future<void> deleteOffer(String id);
}

class CareHomeOffersRemoteDataSourceImpl
    implements CareHomeOffersRemoteDataSource {
  final Dio _dio = NetworkDioHandler().dio;

  @override
  Future<OffersPage> getOffers({
    required String careHomeId,
    int pageIndex = 1,
    int pageSize = 10,
    String? search,
    String? sort,
  }) async {
    try {
      final params = <String, dynamic>{
        'CareHomeId': careHomeId,
        'PageIndex': pageIndex,
        'PageSize': pageSize,
      };
      if (search != null && search.isNotEmpty) params['Search'] = search;
      if (sort != null && sort.isNotEmpty) params['Sort'] = sort;

      final response = await _dio.get(
          EndPoints.offers, queryParameters: params);

      final body = response.data;
      final List<dynamic> rawList;
      int totalCount;
      int retPageIndex;
      int retPageSize;

      if (body is Map) {
        rawList = (body['data'] ?? body['items'] ?? []) as List<dynamic>;
        totalCount =
        (body['count'] ?? body['totalCount'] ?? rawList.length) as int;
        retPageIndex = (body['pageIndex'] ?? pageIndex) as int;
        retPageSize = (body['pageSize'] ?? pageSize) as int;
      } else if (body is List) {
        rawList = body;
        totalCount = rawList.length;
        retPageIndex = pageIndex;
        retPageSize = pageSize;
      } else {
        rawList = [];
        totalCount = 0;
        retPageIndex = pageIndex;
        retPageSize = pageSize;
      }

      return OffersPage(
        items: rawList
            .map((e) =>
            CareHomeOfferListItem.fromMap(e as Map<String, dynamic>))
            .toList(),
        totalCount: totalCount,
        pageIndex: retPageIndex,
        pageSize: retPageSize,
      );
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