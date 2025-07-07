import 'package:injectable/injectable.dart';
import 'package:movies_app/core/typedefs.dart';

import '../entities/movie.dart';
import '../repositories/movie_repository.dart';
import 'usecase.dart';

@injectable
class GetBookmarkedMoviesUseCase implements UseCaseWithNoParams<List<Movie>> {
  final MovieRepository _repository;

  GetBookmarkedMoviesUseCase(this._repository);

  @override
  FutureEither<List<Movie>> call() {
    return _repository.getBookmarkedMovies();
  }
}

@injectable
class ToggleBookmarkUseCase implements UseCase<bool, Movie> {
  final MovieRepository _repository;

  ToggleBookmarkUseCase(this._repository);

  @override
  FutureEither<bool> call(Movie params) {
    return _repository.toggleBookmark(params);
  }
}

@injectable
class IsMovieBookmarkedUseCase implements UseCase<bool, int> {
  final MovieRepository _repository;

  IsMovieBookmarkedUseCase(this._repository);

  @override
  FutureEither<bool> call(int params) {
    return _repository.isMovieBookmarked(params);
  }
}
