import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/entities/movie_detail.dart';
import '../../../domain/local_storage_exception.dart';

abstract class MovieLocalDataSource {
  Future<List<Movie>> getTrendingMovies();
  Future<List<Movie>> getNowPlayingMovies({int page});
  Future<List<Movie>> getPopularMovies();
  Future<List<Movie>> getRecommendedMovies();
  Future<void> cacheTrendingMovies(List<Movie> movies);
  Future<void> cacheNowPlayingMovies(List<Movie> movies);
  Future<MovieDetail?> getMovieDetail(int id);
  Future<void> cacheMovieDetail(MovieDetail movieDetail);
  Future<List<Movie>> searchMoviesByTitle(String query);
  Future<List<Movie>> getBookmarkedMovies();
  Future<bool> toggleBookmark(Movie movie);
  Future<bool> isMovieBookmarked(int id);
  Future<void> cacheSearchResults(List<Movie> movies);
}

@LazySingleton(as: MovieLocalDataSource)
class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final Isar _isar;

  MovieLocalDataSourceImpl(this._isar);

  @override
  Future<List<Movie>> getTrendingMovies() async {
    try {
      final now = DateTime.now();
      final oneDayAgo = now.subtract(const Duration(days: 1));

      final movies =
          await _isar.movies
              .where()
              .filter()
              .cachedAtGreaterThan(oneDayAgo)
              .sortByIdDesc()
              .limit(20)
              .findAll();

      return movies;
    } catch (e) {
      throw const LocalStorageException(
        message: 'Failed to fetch trending movies from local storage',
      );
    }
  }

  @override
  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    try {
      final now = DateTime.now();
      final oneWeekAgo = now.subtract(const Duration(days: 7));

      final movies =
          await _isar.movies
              .where()
              .filter()
              .cachedAtGreaterThan(oneWeekAgo)
              .sortByReleaseDateDesc()
              .offset((page - 1) * 20)
              .limit(20)
              .findAll();

      return movies;
    } catch (e) {
      throw const LocalStorageException(
        message: 'Failed to fetch now playing movies from local storage',
      );
    }
  }

  @override
  Future<List<Movie>> getPopularMovies() async {
    try {
      final now = DateTime.now();
      final oneDayAgo = now.subtract(const Duration(days: 1));

      final movies =
          await _isar.movies
              .where()
              .filter()
              .cachedAtGreaterThan(oneDayAgo)
              .sortByVoteAverageDesc()
              .limit(20)
              .findAll();

      return movies;
    } catch (e) {
      throw const LocalStorageException(
        message: 'Failed to fetch popular movies from local storage',
      );
    }
  }

  @override
  Future<List<Movie>> getRecommendedMovies() async {
    try {
      final movies =
          await _isar.movies
              .where()
              .filter()
              .isBookmarkedEqualTo(true)
              .sortByIdDesc()
              .findAll();

      return movies;
    } catch (e) {
      throw const LocalStorageException(
        message: 'Failed to fetch recommended movies from local storage',
      );
    }
  }

  @override
  Future<MovieDetail?> getMovieDetail(int id) async {
    try {
      final movieDetail = await _isar.movieDetails.get(id.hashCode);
      return movieDetail;
    } catch (e) {
      throw const LocalStorageException(
        message: 'Failed to fetch movie detail from local storage',
      );
    }
  }

  @override
  Future<List<Movie>> searchMoviesByTitle(String query) async {
    try {
      final movies =
          await _isar.movies
              .where()
              .filter()
              .titleContains(query, caseSensitive: false)
              .or()
              .originalTitleContains(query, caseSensitive: false)
              .limit(30)
              .findAll();

      return movies;
    } catch (e) {
      throw const LocalStorageException(
        message: 'Failed to search movies from local storage',
      );
    }
  }

  @override
  Future<List<Movie>> getBookmarkedMovies() async {
    try {
      final bookmarkedMovies =
          await _isar.movies
              .where()
              .filter()
              .isBookmarkedEqualTo(true)
              .sortByReleaseDateDesc()
              .findAll();

      return bookmarkedMovies;
    } catch (e) {
      throw const LocalStorageException(
        message: 'Failed to fetch bookmarked movies from local storage',
      );
    }
  }

  @override
  Future<bool> toggleBookmark(Movie movie) async {
    try {
      final existingMovie = await _isar.movies.get(movie.isarId);
      final isCurrentlyBookmarked = existingMovie?.isBookmarked ?? false;

      final updatedMovie = movie.copyWith(isBookmarked: !isCurrentlyBookmarked);

      await _isar.writeTxn(() async {
        await _isar.movies.put(updatedMovie);
      });

      return !isCurrentlyBookmarked;
    } catch (e) {
      throw const LocalStorageException(message: 'Failed to toggle bookmark');
    }
  }

  @override
  Future<bool> isMovieBookmarked(int id) async {
    try {
      final movie = await _isar.movies.get(id.hashCode);
      return movie?.isBookmarked ?? false;
    } catch (e) {
      throw const LocalStorageException(
        message: 'Failed to check if movie is bookmarked',
      );
    }
  }

  @override
  Future<void> cacheTrendingMovies(List<Movie> movies) async {
    try {
      await _isar.writeTxn(() async {
        for (var movie in movies) {
          final existingMovie = await _isar.movies.get(movie.isarId);
          final isBookmarked = existingMovie?.isBookmarked ?? false;
          final updatedMovie = movie.copyWith(
            isBookmarked: isBookmarked,
            cachedAt: DateTime.now(),
          );
          await _isar.movies.put(updatedMovie);
        }
      });
    } catch (e) {
      throw const LocalStorageException(
        message: 'Failed to cache trending movies',
      );
    }
  }

  @override
  Future<void> cacheNowPlayingMovies(List<Movie> movies) async {
    try {
      await _isar.writeTxn(() async {
        for (var movie in movies) {
          final existingMovie = await _isar.movies.get(movie.isarId);
          final isBookmarked = existingMovie?.isBookmarked ?? false;
          final updatedMovie = movie.copyWith(
            isBookmarked: isBookmarked,
            cachedAt: DateTime.now(),
          );
          await _isar.movies.put(updatedMovie);
        }
      });
    } catch (e) {
      throw const LocalStorageException(
        message: 'Failed to cache now playing movies',
      );
    }
  }

  @override
  Future<void> cacheMovieDetail(MovieDetail movieDetail) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.movieDetails.put(movieDetail);
      });
    } catch (e) {
      throw const LocalStorageException(
        message: 'Failed to cache movie details',
      );
    }
  }

  @override
  Future<void> cacheSearchResults(List<Movie> movies) async {
    try {
      await _isar.writeTxn(() async {
        for (var movie in movies) {
          final existingMovie = await _isar.movies.get(movie.isarId);
          final isBookmarked = existingMovie?.isBookmarked ?? false;
          final updatedMovie = movie.copyWith(
            isBookmarked: isBookmarked,
            cachedAt: DateTime.now(),
          );
          await _isar.movies.put(updatedMovie);
        }
      });
    } catch (e) {
      throw const LocalStorageException(
        message: 'Failed to cache search results',
      );
    }
  }
}
