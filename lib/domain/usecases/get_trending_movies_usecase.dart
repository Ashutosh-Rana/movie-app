import 'package:injectable/injectable.dart';
import 'package:movies_app/core/typedefs.dart';

import '../entities/movie.dart';
import '../repositories/movie_repository.dart';
import 'get_now_playing_movies_usecase.dart'; // Import PageParams
import 'usecase.dart';

@injectable
class GetTrendingMoviesUseCase implements UseCase<List<Movie>, PageParams> {
  final MovieRepository _repository;

  GetTrendingMoviesUseCase(this._repository);

  @override
  FutureEither<List<Movie>> call(PageParams params) {
    return _repository.getTrendingMovies(page: params.page);
  }
}
