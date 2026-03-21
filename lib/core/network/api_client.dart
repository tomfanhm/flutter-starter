import 'package:dio/dio.dart';

import '../../app/flavors/env_config.dart';
import 'api_exceptions.dart';
import 'auth_interceptor.dart';
import 'logging_interceptor.dart';

class ApiClient {
  ApiClient({Dio? dio}) : _dio = dio ?? _createDefaultDio();

  final Dio _dio;

  Dio get dio => _dio;

  static const int _connectTimeoutMs = 15000;
  static const int _receiveTimeoutMs = 15000;

  static Dio _createDefaultDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.instance.apiBaseUrl,
        connectTimeout: const Duration(milliseconds: _connectTimeoutMs),
        receiveTimeout: const Duration(milliseconds: _receiveTimeoutMs),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(),
      LoggingInterceptor(),
    ]);

    return dio;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
  }) async {
    try {
      return await _dio.post<T>(path, data: data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  ApiException _mapDioException(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        const TimeoutException(),
      DioExceptionType.connectionError => const NetworkException(),
      _ => _mapStatusCode(e.response?.statusCode),
    };
  }

  ApiException _mapStatusCode(int? statusCode) {
    return switch (statusCode) {
      401 => const UnauthorizedException(),
      _ => ServerException(statusCode ?? 0, 'Unexpected error'),
    };
  }
}
