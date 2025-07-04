import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../domain/entities/api_exception.dart';
import '../../logger.dart';

part 'api_client.g.dart';

@RestApi()
@lazySingleton
abstract class ApiClient {
  @factoryMethod
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @GET('{path}')
  Future<dynamic> get(
    @Path('path') String path, {
    @Query('') Map<String, dynamic>? params,
    @Query('extractData') bool extractData = true,
  });

  @POST('{path}')
  Future<dynamic> post(
    @Path('path') String path,
    @Body() Map<String, dynamic> data, {
    @Query('') Map<String, dynamic>? params,
    @Query('extractData') bool extractData = true,
  });
}

// Custom DIO interceptor to handle error responses
class ApiErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logError(
      '${err.requestOptions.method} ${err.requestOptions.path} ${err.message}',
    );

    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      handler.reject(TimeoutException(err.message) as DioException);
      return;
    }

    if (err.type == DioExceptionType.badResponse) {
      if (err.response?.statusCode == 102 ||
          err.response?.statusCode == 401 ||
          err.response?.statusCode == 502) {
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: ApiException(code: err.response?.statusCode),
          ),
        );
        return;
      }

      if (err.response?.data is Map<String, dynamic>) {
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: ApiException(
              code: err.response?.statusCode,
              message:
                  err.response?.data['message'] ?? err.response?.statusMessage,
            ),
          ),
        );
        return;
      }

      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: ApiException(
            code: err.response?.statusCode,
            message: err.response?.statusMessage ?? err.message,
          ),
        ),
      );
      return;
    }

    handler.next(err);
  }
}

// Custom DIO interceptor to handle logging requests and responses
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logDebug('${options.method} ${options.path} ${options.queryParameters}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logDebug(
      'SUCCESS ${response.requestOptions.method} ${response.requestOptions.path} ${response.requestOptions.queryParameters} ${response.data}',
    );

    // Handle extractData parameter
    if (response.requestOptions.extra['extractData'] == true &&
        response.data is Map<String, dynamic> &&
        response.data.containsKey('data')) {
      response.data = response.data['data'];
    }

    handler.next(response);
  }
}

// Helper to setup Dio with the required interceptors
@lazySingleton
class DioProvider {
  Dio provideDio() {
    final dio = Dio();
    dio.interceptors.addAll([LoggingInterceptor(), ApiErrorInterceptor()]);
    return dio;
  }
}
