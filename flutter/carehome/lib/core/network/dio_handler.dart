import 'dart:developer';

import 'package:dio/dio.dart';

import '../constants/api.dart';

class NetworkDioHandler {
  // ── Singleton ──────────────────────────────────────────────────────────────
  static NetworkDioHandler? _instance;

  factory NetworkDioHandler() {
    _instance ??= NetworkDioHandler._internal(ApiConstat.baseUrl);
    return _instance!;
  }

  NetworkDioHandler._internal(this.baseUrl) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveTimeout: const Duration(seconds: 10),
        connectTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          log("📩 Api Request : ${options.baseUrl}${options.path}");
          log("📦 Request Data: ${options.data}");
          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          log("✅ Api Success Response : ${response.data}");
          return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          log("❌ Api Error Path    : ${error.requestOptions.path}");
          log("❌ Api Error Response: ${error.response?.data}");
          return handler.next(error);
        },
      ),
    );
  }

  final String baseUrl;
  late Dio dio;

  /// Call this once (e.g. in main.dart) if you need to attach a Bearer token
  /// after login.
  void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    dio.options.headers.remove('Authorization');
  }
}