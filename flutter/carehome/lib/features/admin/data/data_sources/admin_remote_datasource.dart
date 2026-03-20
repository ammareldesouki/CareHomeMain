import 'package:carehome/core/constants/api.dart';
import 'package:dio/dio.dart';

import '../../../../core/failure/server_failure.dart';
import '../../../../core/network/dio_handler.dart';
import '../models/admin_models.dart';
import '../models/admin_psw_profile_model.dart';

// ── Paginated result wrapper ───────────────────────────────────────────────────
typedef VerificationPageResult = ({
  List<AdminPswVerificationModel> items,
  int totalCount,
  int pageIndex,
  int pageSize,
});

abstract class AdminRemoteDataSource {
  /// GET /api/admin/users/PSW
  /// [verificationStatus] — null means "All" (no filter sent)
  Future<VerificationPageResult> getVerifications({
    String? verificationStatus,
    int pageIndex = 1,
    int pageSize = 10,
    String? search,
    String? sort,
  });

  Future<void> approveVerification(String pswId);
  Future<void> rejectVerification(String pswId, String reason);

  Future<List<AdminApplicationModel>> getPendingApplications();
  Future<void> approveApplication(String requestId);
  Future<void> rejectApplication(String requestId);

  Future<List<AdminOfferModel>> getAllOffers();
  Future<void> cancelOffer(String offerId);

  Future<AdminPswProfileModel> getPswProfile(String pswId);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final _dio = NetworkDioHandler().dio;

  // ── Verifications ─────────────────────────────────────────────────────────

  @override
  Future<VerificationPageResult> getVerifications({
    String? verificationStatus,
    int pageIndex = 1,
    int pageSize = 10,
    String? search,
    String? sort,
  }) async {
    try {
      final params = <String, dynamic>{
        'PageIndex': pageIndex,
        'PageSize': pageSize,
      };
      if (verificationStatus != null && verificationStatus != 'All') {
        params['VerificationStatus'] = verificationStatus;
      }
      if (search != null && search.isNotEmpty) params['Search'] = search;
      if (sort != null && sort.isNotEmpty) params['Sort'] = sort;

      // Endpoint: GET /api/admin/users/PSW
      // Add to EndPoints: static const adminGetPswUsers = 'api/admin/users/PSW';
      final res = await _dio.get(
        EndPoints.verifyAdminPending,
        queryParameters: params,
      );

      final body = res.data as Map<String, dynamic>;
      final List rawData = body['data'] ?? [];
      final totalCount = body['count'] ?? rawData.length;
      final returnedPage = body['pageIndex'] ?? pageIndex;
      final returnedSize = body['pageSize'] ?? pageSize;

      return (
        items: rawData
            .map((e) => AdminPswVerificationModel.fromMap(e))
            .toList(),
        totalCount: totalCount as int,
        pageIndex: returnedPage as int,
        pageSize: returnedSize as int,
      );
    } on DioException catch (e) {
      throw ServerFailure.fromMap(e.response?.data ?? {});
    }
  }

  @override
  Future<void> approveVerification(String pswId) async {
    try {
      await _dio.post('api/admin/verifications/$pswId/approve');
    } on DioException catch (e) {
      throw ServerFailure.fromMap(e.response?.data ?? {});
    }
  }

  @override
  Future<void> rejectVerification(String pswId, String reason) async {
    try {
      await _dio.post(
        EndPoints.verifyAdminReject(pswId),
        data: {'reason': reason},
      );
    } on DioException catch (e) {
      throw ServerFailure.fromMap(e.response?.data ?? {});
    }
  }

  // ── Applications ──────────────────────────────────────────────────────────

  @override
  Future<List<AdminApplicationModel>> getPendingApplications() async {
    try {
      final res = await _dio.get(
        EndPoints.adminApplicationPsw,
        queryParameters: {'status': 'Pending'},
      );
      final List data = res.data['data'] ?? res.data ?? [];
      return data.map((e) => AdminApplicationModel.fromMap(e)).toList();
    } on DioException catch (e) {
      throw ServerFailure.fromMap(e.response?.data ?? {});
    }
  }

  @override
  Future<void> approveApplication(String requestId) async {
    try {
      await _dio.post(EndPoints.AdminapproveApplication(requestId));
    } on DioException catch (e) {
      throw ServerFailure.fromMap(e.response?.data ?? {});
    }
  }

  @override
  Future<void> rejectApplication(String requestId) async {
    try {
      await _dio.post(
        EndPoints.AdminrejectApplication(requestId),
        data: {'reason': 'You are not qualified'},
      );
    } on DioException catch (e) {
      throw ServerFailure.fromMap(e.response?.data ?? {});
    }
  }

  // ── Offers ────────────────────────────────────────────────────────────────

  @override
  Future<List<AdminOfferModel>> getAllOffers() async {
    try {
      final res = await _dio.get(EndPoints.adminGetAllOffers);
      final List data = res.data['data'] ?? res.data ?? [];
      return data.map((e) => AdminOfferModel.fromMap(e)).toList();
    } on DioException catch (e) {
      throw ServerFailure.fromMap(e.response?.data ?? {});
    }
  }

  @override
  Future<void> cancelOffer(String offerId) async {
    try {
      await _dio.delete(EndPoints.adminCancelOffer(offerId));
    } on DioException catch (e) {
      throw ServerFailure.fromMap(e.response?.data ?? {});
    }
  }

  // ── PSW Profile ───────────────────────────────────────────────────────────

  @override
  Future<AdminPswProfileModel> getPswProfile(String pswId) async {
    try {
      final res = await _dio.get(EndPoints.adminPswProfile(pswId));
      return AdminPswProfileModel.fromMap(res.data);
    } on DioException catch (e) {
      throw ServerFailure.fromMap(e.response?.data ?? {});
    }
  }
}