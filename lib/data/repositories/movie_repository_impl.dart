import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:movies_app/core/api/api_call_with_exception.dart';
import 'package:movies_app/core/enums.dart';
import 'package:movies_app/core/typedefs.dart';
import 'package:movies_app/data/data_sources/local/movie_local_data_source.dart';
import 'package:movies_app/data/data_sources/remote/movie_remote_data_source.dart';
import 'package:movies_app/domain/entities/app_error.dart';
import 'package:movies_app/domain/entities/movie.dart';
import 'package:movies_app/domain/entities/movie_detail.dart';
import 'package:movies_app/domain/repositories/movie_repository.dart';

@LazySingleton(as: MovieRepository)
class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource _remoteDataSource;
  final MovieLocalDataSource _localDataSource;
  final ApiCallWithException _apiCallWithException;

  MovieRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._apiCallWithException,
  );

  @override
  FutureEither<List<Movie>> getTrendingMovies({int page = 1}) async {
    try {
      if (page == 1) {
        final localMovies = await _localDataSource.getTrendingMovies();
        if (localMovies.isNotEmpty) return right(localMovies);
      }

      return _apiCallWithException.call<List<Movie>>(() async {
        final response = await _remoteDataSource.getTrendingMovies(page: page);
        final movies = response.results.map((e) => e.toDomain()).toList();

        if (page == 1) {
          await _localDataSource.cacheTrendingMovies(movies);
        }

        return movies;
      });
    } catch (_) {
      try {
        final fallback = await _localDataSource.getTrendingMovies();
        if (fallback.isNotEmpty) return right(fallback);
      } catch (_) {}

      return left(
        const AppError(
          type: AppErrorType.localStorage,
          error: 'Failed to get trending movies',
        ),
      );
    }
  }

  @override
  FutureEither<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    try {
      final localMovies = await _localDataSource.getNowPlayingMovies(
        page: page,
      );
      if (localMovies.isNotEmpty) return right(localMovies);

      return _apiCallWithException.call<List<Movie>>(() async {
        final response = await _remoteDataSource.getNowPlayingMovies(
          page: page,
        );
        final movies = response.results.map((e) => e.toDomain()).toList();
        await _localDataSource.cacheNowPlayingMovies(movies);
        return movies;
      });
    } catch (_) {
      try {
        final fallback = await _localDataSource.getNowPlayingMovies(page: page);
        if (fallback.isNotEmpty) return right(fallback);
      } catch (_) {}

      return left(
        const AppError(
          type: AppErrorType.localStorage,
          error: 'Failed to get now playing movies',
        ),
      );
    }
  }

  @override
  FutureEither<MovieDetail> getMovieDetail(int id) async {
    try {
      final localDetail = await _localDataSource.getMovieDetail(id);
      if (localDetail != null) {
        final isBookmarked = await _localDataSource.isMovieBookmarked(id);
        return right(localDetail.copyWith(isBookmarked: isBookmarked));
      }

      return _apiCallWithException.call<MovieDetail>(() async {
        final response = await _remoteDataSource.getMovieDetail(id);
        final isBookmarked = await _localDataSource.isMovieBookmarked(id);
        final movieDetail = response.toDomain(isBookmarked: isBookmarked);
        await _localDataSource.cacheMovieDetail(movieDetail);
        return movieDetail;
      });
    } catch (_) {
      try {
        final fallback = await _localDataSource.getMovieDetail(id);
        if (fallback != null) return right(fallback);
      } catch (_) {}

      return left(
        const AppError(
          type: AppErrorType.localStorage,
          error: 'Failed to get movie details',
        ),
      );
    }
  }

  @override
  FutureEither<List<Movie>> searchMovies(String query, {int page = 1}) async {
    if (query.isEmpty) return right([]);

    try {
      final localMovies = await _localDataSource.searchMoviesByTitle(query);
      if (localMovies.length >= 5) return right(localMovies);

      return _apiCallWithException.call<List<Movie>>(() async {
        final response = await _remoteDataSource.searchMovies(
          query,
          page: page,
        );
        final movies = response.results.map((e) => e.toDomain()).toList();
        await _localDataSource.cacheSearchResults(movies);
        return movies;
      });
    } catch (_) {
      try {
        final fallback = await _localDataSource.searchMoviesByTitle(query);
        if (fallback.isNotEmpty) return right(fallback);
      } catch (_) {}

      return left(
        const AppError(
          type: AppErrorType.localStorage,
          error: 'Failed to search movies',
        ),
      );
    }
  }

  @override
  FutureEither<List<Movie>> getBookmarkedMovies() async {
    return _apiCallWithException.call(() async {
      return await _localDataSource.getBookmarkedMovies();
    });
  }

  @override
  FutureEither<bool> toggleBookmark(Movie movie) async {
    return _apiCallWithException.call(() async {
      return await _localDataSource.toggleBookmark(movie);
    });
  }

  @override
  FutureEither<bool> isMovieBookmarked(int id) async {
    return _apiCallWithException.call(() async {
      return await _localDataSource.isMovieBookmarked(id);
    });
  }
}
