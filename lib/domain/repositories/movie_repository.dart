import 'package:movies_app/core/typedefs.dart';

import '../entities/movie.dart';
import '../entities/movie_detail.dart';

abstract class MovieRepository {
  FutureEither<List<Movie>> getTrendingMovies({int page = 1});
  FutureEither<List<Movie>> getNowPlayingMovies({int page = 1});
  FutureEither<MovieDetail> getMovieDetail(int id);
  FutureEither<List<Movie>> searchMovies(String query, {int page = 1});
  FutureEither<List<Movie>> getBookmarkedMovies();
  FutureEither<bool> toggleBookmark(Movie movie);
  FutureEither<bool> isMovieBookmarked(int id);
}
