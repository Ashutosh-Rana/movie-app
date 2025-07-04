import 'package:fpdart/fpdart.dart';
import 'package:movies_app/domain/entities/app_error.dart';

typedef FutureEither<T> = Future<Either<AppError, T>>;
