import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
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
  final Connectivity _connectivity = Connectivity();

  // Check if there is an internet connection
  Future<bool> _hasInternetConnection() async {
    final result = await _connectivity.checkConnectivity();
    // Since checkConnectivity returns List<ConnectivityResult>, check if the list contains any
    // connectivity result other than 'none' (meaning we have some connectivity)
    return result.isNotEmpty && !result.contains(ConnectivityResult.none);
  }

  FutureEither<T> call<T>(Future<T> Function() f, {int retryCount = 0}) async {
    try {
      initialRetryCount ??= retryCount;

      // Check for internet connection before making the call
      final hasInternet = await _hasInternetConnection();
      if (!hasInternet) {
        return Left(
          const AppError(
            type: AppErrorType.network,
            error: 'No internet connection',
          ),
        );
      }

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
    } on DioException catch (e, s) {
      // Handle Dio specific network errors
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.error is SocketException) {
        return _handleException(
          e: e,
          stackTrace: s,
          f: f,
          retryCount: retryCount,
          errorType: AppErrorType.network,
          errorMessage: 'No internet connection',
        );
      }
      return _handleException(
        e: e,
        stackTrace: s,
        f: f,
        retryCount: retryCount,
        errorType: AppErrorType.api,
        errorMessage: 'API error: ${e.message ?? 'Unknown error'}',
        data: e.response?.data,
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

    // Special handling for network errors
    if (errorType == AppErrorType.network) {
      // For network errors, always try at least once more with a delay
      // This helps when internet connection was recently restored
      if (initialRetryCount! >= retryCount) {
        try {
          // Add a short delay to allow network to stabilize if it was just reconnected
          await Future.delayed(const Duration(milliseconds: 500));
          final result = await f();
          return Right(result);
        } catch (_) {
          // If still failing, continue with normal retry logic
          if (retryCount > 0) {
            return call(f, retryCount: retryCount - 1);
          }
        }
      }
    } else if (retryCount > 0) {
      // Normal retry for non-network errors
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
