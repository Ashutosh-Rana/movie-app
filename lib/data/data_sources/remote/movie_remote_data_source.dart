import 'package:injectable/injectable.dart';

import '../../models/movie_detail_model.dart';
import '../../models/movie_model.dart';
import 'tmdb_api_client.dart';

abstract class MovieRemoteDataSource {
  Future<MovieResponse> getTrendingMovies({int page = 1});
  Future<MovieResponse> getNowPlayingMovies({int page = 1});
  Future<MovieDetailModel> getMovieDetail(int id);
  Future<MovieResponse> searchMovies(String query, {int page = 1});
}

@Injectable(as: MovieRemoteDataSource)
class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final TMDBApiClient _apiClient;
  final String _apiToken =
      'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YTI0MzlkODhjNjUzMjE0NDZlZGI2YjBlNmQ4YThlOCIsIm5iZiI6MTc1MTY1MTc2NC40MTY5OTk4LCJzdWIiOiI2ODY4MTViNGJmOWE1Mjk0YTg1MWQyOWUiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.YsnRUF8WIDF9dlC5BUbNOLUhvfK1BTfQ6-YroOgJPcU';

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
