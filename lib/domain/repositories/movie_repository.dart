import 'package:fpdart/fpdart.dart';

import '../entities/movie.dart';
import '../entities/movie_detail.dart';
import '../local_storage_exception.dart';

abstract class MovieRepository {
  Future<Either<LocalStorageException, List<Movie>>> getTrendingMovies({int page = 1});
  Future<Either<LocalStorageException, List<Movie>>> getNowPlayingMovies({int page = 1});
  Future<Either<LocalStorageException, MovieDetail>> getMovieDetail(int id);
  Future<Either<LocalStorageException, List<Movie>>> searchMovies(String query, {int page = 1});
  Future<Either<LocalStorageException, List<Movie>>> getBookmarkedMovies();
  Future<Either<LocalStorageException, bool>> toggleBookmark(Movie movie);
  Future<Either<LocalStorageException, bool>> isMovieBookmarked(int id);
}
