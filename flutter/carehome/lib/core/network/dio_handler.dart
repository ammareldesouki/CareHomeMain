import 'dart:developer';

import 'package:dio/dio.dart';

import '../constants/api.dart';

class NetworkDioHandler {
  final String baseUrl;

  late Dio dio = Dio(
    BaseOptions(
      baseUrl: this.baseUrl,
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  NetworkDioHandler(this.baseUrl) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          // Do something before request is sent.
          // If you want to resolve the request with custom data,
          // you can resolve a `Response` using `handler.resolve(response)`.
          // If you want to reject the request with a error message,
          // you can reject with a `DioException` using `handler.reject(dioError)`.
          log("📩 Api Request :    ${options.path}");

          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          // Do something with response data.
          // If you want to reject the request with a error message,
          //
          // log(
          //   "✅ Api Success Response : ${response.requestOptions.baseUrl}   ${response.requestOptions.path}",
          // );
          log("✅ Api Success Response : ${response.data}");

          return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          // Do something with response error.
          // If you want to resolve the request with some custom data,
          // you can resolve a `Response` object using `handler.resolve(response)`.

          log("❌ Api Success Response :    ${error.requestOptions.path}");
          log("❌ Api Success Response :    ${error.response?.data}");

          return handler.next(error);
        },
      ),
    );
  }
}
