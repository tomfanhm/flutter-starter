import 'dart:developer';

import 'package:dio/dio.dart';

import '../../app/flavors/env_config.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (EnvConfig.instance.enableLogging) {
      log('[REQ] ${options.method} ${options.uri}');
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (EnvConfig.instance.enableLogging) {
      log('[RES] ${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (EnvConfig.instance.enableLogging) {
      log('[ERR] ${err.type} ${err.requestOptions.uri}: ${err.message}');
    }
    handler.next(err);
  }
}
