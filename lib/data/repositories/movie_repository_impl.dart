import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_detail.dart';
import '../../domain/local_storage_exception.dart';
import '../../domain/repositories/movie_repository.dart';
import '../data_sources/local/movie_local_data_source.dart';
import '../data_sources/remote/movie_remote_data_source.dart';

@LazySingleton(as: MovieRepository)
class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource _remoteDataSource;
  final MovieLocalDataSource _localDataSource;

  MovieRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<LocalStorageException, List<Movie>>> getTrendingMovies({int page = 1}) async {
    try {
      // For first page, try to get data from local cache
      if (page == 1) {
        final localMovies = await _localDataSource.getTrendingMovies();

        // If we have recent cached data, return it
        if (localMovies.isNotEmpty) {
          return right(localMovies);
        }
      }

      // Otherwise fetch from API with pagination
      final response = await _remoteDataSource.getTrendingMovies(page: page);
      final movies = response.results.map((model) => model.toDomain()).toList();

      // Cache the results (only for first page)
      if (page == 1) {
        await _localDataSource.cacheTrendingMovies(movies);
      }

      return right(movies);
    } catch (e) {
      if (e is LocalStorageException) {
        return left(e);
      }

      // Try to get any data from local cache as a fallback
      try {
        final localMovies = await _localDataSource.getTrendingMovies();
        if (localMovies.isNotEmpty) {
          return right(localMovies);
        }
      } catch (_) {}

      return left(
        const LocalStorageException(message: 'Failed to get trending movies'),
      );
    }
  }

  @override
  Future<Either<LocalStorageException, List<Movie>>> getNowPlayingMovies({
    int page = 1,
  }) async {
    try {
      // First try to get data from local cache
      final localMovies = await _localDataSource.getNowPlayingMovies(
        page: page,
      );

      // If we have recent cached data, return it
      if (localMovies.isNotEmpty) {
        return right(localMovies);
      }

      // Otherwise fetch from API
      final response = await _remoteDataSource.getNowPlayingMovies(page: page);
      final movies = response.results.map((model) => model.toDomain()).toList();

      // Cache the results
      await _localDataSource.cacheNowPlayingMovies(movies);

      return right(movies);
    } catch (e) {
      if (e is LocalStorageException) {
        return left(e);
      }

      // Try to get any data from local cache as a fallback
      try {
        final localMovies = await _localDataSource.getNowPlayingMovies(
          page: page,
        );
        if (localMovies.isNotEmpty) {
          return right(localMovies);
        }
      } catch (_) {}

      return left(
        const LocalStorageException(
          message: 'Failed to get now playing movies',
        ),
      );
    }
  }

  @override
  Future<Either<LocalStorageException, MovieDetail>> getMovieDetail(
    int id,
  ) async {
    try {
      // First try to get data from local cache
      final localMovieDetail = await _localDataSource.getMovieDetail(id);

      // If we have cached data, return it
      if (localMovieDetail != null) {
        // Check if this movie is bookmarked
        final isBookmarked = await _localDataSource.isMovieBookmarked(id);
        return right(localMovieDetail.copyWith(isBookmarked: isBookmarked));
      }

      // Otherwise fetch from API
      final response = await _remoteDataSource.getMovieDetail(id);
      final isBookmarked = await _localDataSource.isMovieBookmarked(id);
      final movieDetail = response.toDomain(isBookmarked: isBookmarked);

      // Cache the result
      await _localDataSource.cacheMovieDetail(movieDetail);

      return right(movieDetail);
    } catch (e) {
      if (e is LocalStorageException) {
        return left(e);
      }

      // Try to get data from local cache as a fallback
      try {
        final localMovieDetail = await _localDataSource.getMovieDetail(id);
        if (localMovieDetail != null) {
          return right(localMovieDetail);
        }
      } catch (_) {}

      return left(
        const LocalStorageException(message: 'Failed to get movie details'),
      );
    }
  }

  @override
  Future<Either<LocalStorageException, List<Movie>>> searchMovies(
    String query, {
    int page = 1,
  }) async {
    if (query.isEmpty) {
      return right([]);
    }

    try {
      // First try to search in local cache
      final localMovies = await _localDataSource.searchMoviesByTitle(query);

      // If we have sufficient results from cache, use them
      if (localMovies.length >= 5) {
        return right(localMovies);
      }

      // Otherwise fetch from API
      final response = await _remoteDataSource.searchMovies(query, page: page);
      final movies = response.results.map((model) => model.toDomain()).toList();

      // Cache the results
      await _localDataSource.cacheSearchResults(movies);

      return right(movies);
    } catch (e) {
      if (e is LocalStorageException) {
        return left(e);
      }

      // Try to get data from local cache as a fallback
      try {
        final localMovies = await _localDataSource.searchMoviesByTitle(query);
        if (localMovies.isNotEmpty) {
          return right(localMovies);
        }
      } catch (_) {}

      return left(
        const LocalStorageException(message: 'Failed to search movies'),
      );
    }
  }

  @override
  Future<Either<LocalStorageException, List<Movie>>>
  getBookmarkedMovies() async {
    try {
      final bookmarkedMovies = await _localDataSource.getBookmarkedMovies();
      return right(bookmarkedMovies);
    } catch (e) {
      return left(
        e is LocalStorageException
            ? e
            : const LocalStorageException(
              message: 'Failed to get bookmarked movies',
            ),
      );
    }
  }

  @override
  Future<Either<LocalStorageException, bool>> toggleBookmark(
    Movie movie,
  ) async {
    try {
      final result = await _localDataSource.toggleBookmark(movie);
      return right(result);
    } catch (e) {
      return left(
        e is LocalStorageException
            ? e
            : const LocalStorageException(message: 'Failed to toggle bookmark'),
      );
    }
  }

  @override
  Future<Either<LocalStorageException, bool>> isMovieBookmarked(int id) async {
    try {
      final result = await _localDataSource.isMovieBookmarked(id);
      return right(result);
    } catch (e) {
      return left(
        e is LocalStorageException
            ? e
            : const LocalStorageException(
              message: 'Failed to check bookmark status',
            ),
      );
    }
  }
}
