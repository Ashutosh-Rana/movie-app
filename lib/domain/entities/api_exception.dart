import 'package:equatable/equatable.dart';
import 'package:movies_app/core/enums.dart';

class ApiException extends Equatable implements Exception {
  final int? code;
  final String? message;
  final String? path;
  final ApiMethod? method;
  final Object? requestData;
  final Map<String, dynamic>? responseData;
  final Map<String, dynamic>? queryParams;

  const ApiException({
    this.code,
    this.message,
    this.path,
    this.method,
    this.requestData,
    this.responseData,
    this.queryParams,
  });

  @override
  String toString() =>
      'ApiException(code: $code, message: $message), path: $path, method: ${method?.value}, requestData: $requestData, responseData: $responseData, queryParams: $queryParams';

  @override
  List<Object?> get props => [
    code,
    message,
    path,
    method,
    requestData,
    responseData,
    queryParams,
  ];
}
