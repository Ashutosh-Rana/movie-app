import 'dart:io' show Platform;

import 'package:injectable/injectable.dart';
import 'package:movies_app/logger.dart';

import '../../../core/api/tmdb_api_client.dart';
import '../../models/movie_detail_model.dart';
import '../../models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<MovieResponse> getTrendingMovies({int page = 1});
  Future<MovieResponse> getNowPlayingMovies({int page = 1});
  Future<MovieDetailModel> getMovieDetail(int id);
  Future<MovieResponse> searchMovies(String query, {int page = 1});
}

@Injectable(as: MovieRemoteDataSource)
class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final TMDBApiClient _apiClient;
  String get _apiToken {
    final token =
        Platform.environment['TMDB_API_TOKEN'] ??
        const String.fromEnvironment('TMDB_API_TOKEN');
    if (token.isEmpty) {
      logWarning(
        'TMDB_API_TOKEN is empty! Please set it in your environment or launch.json',
      );
      return '';
    }
    // Ensure token has Bearer prefix if not already present
    return token.startsWith('Bearer ') ? token : 'Bearer $token';
  }

  MovieRemoteDataSourceImpl(this._apiClient);

  @override
  Future<MovieResponse> getTrendingMovies({int page = 1}) {
    return _apiClient.getTrendingMovies(page: page, token: _apiToken);
  }

  @override
  Future<MovieResponse> getNowPlayingMovies({int page = 1}) {
    return _apiClient.getNowPlayingMovies(page: page, token: _apiToken);
  }

  @override
  Future<MovieDetailModel> getMovieDetail(int id) {
    return _apiClient.getMovieDetail(id: id, token: _apiToken);
  }

  @override
  Future<MovieResponse> searchMovies(String query, {int page = 1}) {
    return _apiClient.searchMovies(query: query, page: page, token: _apiToken);
  }
}
