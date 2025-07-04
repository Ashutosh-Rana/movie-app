import 'package:equatable/equatable.dart';
import 'package:movies_app/core/enums.dart';

class AppError extends Equatable {
  final AppErrorType type;
  final String? error;
  final int? statusCode;
  final Map<String, dynamic>? data;

  const AppError({required this.type, this.error, this.statusCode, this.data});

  @override
  List<Object?> get props => [type, error, statusCode, data];
}
