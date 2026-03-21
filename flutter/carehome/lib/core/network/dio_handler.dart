import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api.dart';

class NetworkDioHandler {
  static NetworkDioHandler? _instance;

  factory NetworkDioHandler() {
    _instance ??= NetworkDioHandler._internal(ApiConstat.baseUrl);
    return _instance!;
  }

  /// In-memory token so the very next request (e.g. upload right after signup)
  /// always has `Authorization` even before secure-storage write finishes.
  String? _accessToken;

  NetworkDioHandler._internal(this.baseUrl) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveTimeout: const Duration(seconds: 10),
        connectTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          // 'Authorization': 'Bearer $_accessToken'
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Prefer memory (set synchronously in setAuthToken), then persisted.
          var token = _accessToken?.trim();
          if (token == null || token.isEmpty) {
            token = (await _storage.read(key: 'token'))?.trim();
            // Legacy key used elsewhere in the app (SecureStorageService).
            token ??= (await _storage.read(key: 'access_token'))?.trim();
            if (token != null && token.isNotEmpty) {
              _accessToken = token;
            }
          }

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          log("📩 Api Request : ${options.baseUrl}${options.path}");
          log("📦 Request Data: ${options.data}");
          log("🔐 Auth Header: ${options.headers['Authorization']}");

          handler.next(options);
        },
        onResponse: (response, handler) {
          log("✅ Api Success Response : ${response.data}");
          handler.next(response);
        },
        onError: (error, handler) {
          log("❌ Api Error Path    : ${error.requestOptions.path}");
          log("❌ Api Error Status  : ${error.response?.statusCode}");
          log("❌ Api Error Response: ${error.response?.data}");
          handler.next(error);
        },
      ),
    );
  }

  final String baseUrl;
  late Dio dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? currentUserId;
  String? currentRole;
  String? currentWorkStatus;

  Future<void> setAuthToken(String token) async {
    final t = token.trim();
    if (t.isEmpty) return;
    // Apply immediately so interceptors / uploads never race storage I/O.
    _accessToken = t;
    dio.options.headers['Authorization'] = 'Bearer $t';
    await _storage.write(key: 'token', value: t);
    // Keep in sync with SecureStorageService / legacy reads.
    await _storage.write(key: 'access_token', value: t);
  }

  Future<void> clearAuthToken() async {
    _accessToken = null;
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'access_token');
    dio.options.headers.remove('Authorization');
    currentUserId = null;
    currentRole = null;
    currentWorkStatus = "None";
  }

  void setCurrentUser({
    required String userId,
    required String role,
    required String? workStatus,
  }) {
    currentUserId = userId;
    currentRole = role;
    currentWorkStatus = workStatus;
  }
}