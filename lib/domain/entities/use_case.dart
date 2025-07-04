import '../../core/typedefs.dart';

abstract class UseCase<Type, Params> {
  FutureEither<Type> call(Params params);
}

abstract class UseCaseWithNoParams<Type> {
  FutureEither<Type> call();
}
