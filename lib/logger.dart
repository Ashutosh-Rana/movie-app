import 'package:logger/logger.dart';

Logger logger = Logger();

void logInfo(String message) {
  logger.i(message);
}

void logWarning(String message) {
  logger.w(message);
}

void logError(String message, [Object? error, StackTrace? stackTrace]) {
  logger.e(message, error: error, stackTrace: stackTrace, time: DateTime.now());
}

void logDebug(String message) {
  logger.d(message);
}

void logTrace(String message) {
  logger.t(message);
}

void logFatal(String message, [Object? error, StackTrace? stackTrace]) {
  logger.f(message, error: error, stackTrace: stackTrace, time: DateTime.now());
}
