import 'dart:math';

import 'package:carehome/core/constants/api.dart';
import 'package:dio/dio.dart';

import '../../../../core/failure/server_failure.dart';
import '../../../../core/network/dio_handler.dart';
import '../models/admin_models.dart';

abstract class AdminRemoteDataSource {
  Future<List<AdminPswVerificationModel>> getPendingVerifications();

  Future<void> approveVerification(String pswId);

  Future<void> rejectVerification(String pswId, String reason);

  Future<List<AdminApplicationModel>> getPendingApplications();

  Future<void> approveApplication(String requestId);

  Future<void> rejectApplication(String requestId);

  Future<List<AdminOfferModel>> getAllOffers();

  Future<void> cancelOffer(String offerId);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final _dio = NetworkDioHandler().dio;

  // ── Verifications ─────────────────────────────────────────────────────────

  @override
  Future<List<AdminPswVerificationModel>> getPendingVerifications() async {
    try {
      final res = await _dio.get(EndPoints.verifyAdminPending);
      final List data = res.data['data'] ?? res.data ?? [];
      return data.map((e) => AdminPswVerificationModel.fromMap(e)).toList();
    } on DioException catch (e) {
      throw ServerFailure.fromMap(e.response?.data ?? {});
    }
  }

  @override
  Future<void> approveVerification(String pswId) async {
    try {
      await _dio.post("api/admin/verifications/$pswId/approve");
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
      final res = await _dio.get(EndPoints.adminApplicationPsw,
          queryParameters: {"status": "Pending"});
      final List data = res.data['data'] ?? res.data ?? [];
      return data.map((e) => AdminApplicationModel.fromMap(e)).toList();
    } on DioException catch (e) {
      throw ServerFailure.fromMap(e.response?.data ?? {});
    }
  }

  @override
  Future<void> approveApplication(String requestId) async {
    try {
      print("------------------------" + requestId);
      await _dio.post(EndPoints.AdminapproveApplication(requestId));
    } on DioException catch (e) {
      throw ServerFailure.fromMap(e.response?.data ?? {});
    }
  }

  @override
  Future<void> rejectApplication(String requestId) async {
    try {
      await _dio.post(EndPoints.AdminrejectApplication(requestId), data: {
        "reason": "You are not qualified"
      }

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
}
