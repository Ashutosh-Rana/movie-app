import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../entities/movie.dart';
import '../local_storage_exception.dart';
import '../repositories/movie_repository.dart';
import 'get_now_playing_movies_usecase.dart'; // Import PageParams
import 'usecase.dart';

@injectable
class GetTrendingMoviesUseCase implements UseCase<List<Movie>, PageParams> {
  final MovieRepository _repository;

  GetTrendingMoviesUseCase(this._repository);

  @override
  Future<Either<LocalStorageException, List<Movie>>> call(PageParams params) {
    return _repository.getTrendingMovies(page: params.page);
  }
}
