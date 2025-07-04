import 'dart:async';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:movies_app/core/enums.dart';
import 'package:movies_app/core/typedefs.dart';
import 'package:movies_app/domain/entities/api_exception.dart';
import 'package:movies_app/domain/entities/app_error.dart';
import 'package:movies_app/domain/local_storage_exception.dart';
import 'package:movies_app/logger.dart';

@lazySingleton
class ApiCallWithException {
  ApiCallWithException();

  int? initialRetryCount;

  FutureEither<T> call<T>(Future<T> Function() f, {int retryCount = 0}) async {
    try {
      initialRetryCount ??= retryCount;

      final result = await f();

      return Right(result);
    } on SocketException catch (e, s) {
      return _handleException(
        e: e,
        stackTrace: s,
        f: f,
        retryCount: retryCount,
        errorType: AppErrorType.network,
        errorMessage: 'No internet connection',
      );
    } on TimeoutException catch (e, s) {
      return _handleException(
        e: e,
        stackTrace: s,
        f: f,
        retryCount: retryCount,
        errorType: AppErrorType.timeout,
        errorMessage: 'Request timed out',
      );
    } on ApiException catch (e, s) {
      return _handleException(
        e: e,
        stackTrace: s,
        f: f,
        retryCount: retryCount,
        errorType: AppErrorType.api,
        errorMessage: e.message ?? 'ApiException occurred',
        data: e.responseData,
      );
    } on LocalStorageException catch (e, s) {
      return _handleException(
        e: e,
        stackTrace: s,
        f: f,
        retryCount: retryCount,
        errorType: AppErrorType.localStorage,
        errorMessage: e.message ?? 'LocalStorageException occurred',
      );
    } on Exception catch (e, s) {
      logError(e.toString());
      return _handleException(
        e: e,
        stackTrace: s,
        f: f,
        retryCount: retryCount,
        errorType: AppErrorType.unknown,
        errorMessage: 'Unknown error occurred: $e',
      );
    } on Error catch (e, s) {
      logError(e.toString());
      return _handleException(
        e: Exception(e.toString()),
        stackTrace: s,
        f: f,
        retryCount: retryCount,
        errorType: AppErrorType.unknown,
        errorMessage: 'Unknown error occurred: $e',
      );
    } finally {
      initialRetryCount = null;
    }
  }

  Either<AppError, T> syncCall<T>(T Function() f) {
    try {
      return Right(f());
    } on SocketException {
      return const Left(
        AppError(type: AppErrorType.network, error: 'No internet connection'),
      );
    } on TimeoutException {
      return const Left(
        AppError(type: AppErrorType.timeout, error: 'Request timed out'),
      );
    } on ApiException catch (e) {
      return Left(
        AppError(
          type: AppErrorType.api,
          error: e.message ?? 'ApiException occurred',
          statusCode: e.code,
        ),
      );
    } on LocalStorageException catch (e) {
      return Left(
        AppError(
          type: AppErrorType.localStorage,
          error: e.message ?? 'LocalStorageException occurred',
        ),
      );
    } on Exception catch (e) {
      return Left(
        AppError(
          type: AppErrorType.unknown,
          error: 'Unknown error occurred: $e',
        ),
      );
    }
  }

  FutureEither<T> _handleException<T>({
    required Exception e,
    required StackTrace stackTrace,
    required Future<T> Function() f,
    required int retryCount,
    required AppErrorType errorType,
    required String errorMessage,
    Map<String, dynamic>? data,
  }) async {
    // Logging
    logError('ApiCallWithException: ${e.toString()}', e);

    // Retry
    if (retryCount > 0) {
      return call(f, retryCount: retryCount - 1);
    }

    // Return error
    return Left(
      AppError(
        type: errorType,
        error: errorMessage,
        statusCode: e is ApiException ? e.code : null,
        data: data,
      ),
    );
  }
}
