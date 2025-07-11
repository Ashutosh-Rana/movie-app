import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:movies_app/core/typedefs.dart';

import '../entities/movie_detail.dart';
import '../repositories/movie_repository.dart';
import 'usecase.dart';

@injectable
class GetMovieDetailUseCase implements UseCase<MovieDetail, MovieParams> {
  final MovieRepository _repository;

  GetMovieDetailUseCase(this._repository);

  @override
  FutureEither<MovieDetail> call(MovieParams params) {
    return _repository.getMovieDetail(params.id);
  }
}

class MovieParams extends Equatable {
  final int id;

  const MovieParams(this.id);

  @override
  List<Object?> get props => [id];
}
