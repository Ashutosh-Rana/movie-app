import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../local_storage_exception.dart';

abstract class UseCase<Type, Params> {
  Future<Either<LocalStorageException, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
