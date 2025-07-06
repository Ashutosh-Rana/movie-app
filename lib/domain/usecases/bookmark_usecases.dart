import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../entities/movie.dart';
import '../local_storage_exception.dart';
import '../repositories/movie_repository.dart';
import 'usecase.dart';

@injectable
class GetBookmarkedMoviesUseCase implements UseCase<List<Movie>, NoParams> {
  final MovieRepository _repository;

  GetBookmarkedMoviesUseCase(this._repository);

  @override
  Future<Either<LocalStorageException, List<Movie>>> call(NoParams params) {
    return _repository.getBookmarkedMovies();
  }
}

@injectable
class ToggleBookmarkUseCase implements UseCase<bool, Movie> {
  final MovieRepository _repository;

  ToggleBookmarkUseCase(this._repository);

  @override
  Future<Either<LocalStorageException, bool>> call(Movie params) {
    return _repository.toggleBookmark(params);
  }
}

@injectable
class IsMovieBookmarkedUseCase implements UseCase<bool, int> {
  final MovieRepository _repository;

  IsMovieBookmarkedUseCase(this._repository);

  @override
  Future<Either<LocalStorageException, bool>> call(int params) {
    return _repository.isMovieBookmarked(params);
  }
}
