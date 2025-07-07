import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../data/models/movie_detail_model.dart';
import '../../data/models/movie_model.dart';

part 'tmdb_api_client.g.dart';

@RestApi(baseUrl: "https://api.themoviedb.org/3")
@injectable
abstract class TMDBApiClient {
  @factoryMethod
  factory TMDBApiClient(Dio dio) = _TMDBApiClient;

  @GET("/trending/movie/day")
  Future<MovieResponse> getTrendingMovies({
    @Query("language") String language = "en-US",
    @Query("page") int page = 1,
    @Header("Authorization") required String token,
  });

  @GET("/movie/now_playing")
  Future<MovieResponse> getNowPlayingMovies({
    @Query("language") String language = "en-US",
    @Query("page") int page = 1,
    @Header("Authorization") required String token,
  });

  @GET("/movie/{id}")
  Future<MovieDetailModel> getMovieDetail({
    @Path("id") required int id,
    @Query("language") String language = "en-US",
    @Header("Authorization") required String token,
  });

  @GET("/search/movie")
  Future<MovieResponse> searchMovies({
    @Query("query") required String query,
    @Query("include_adult") bool includeAdult = false,
    @Query("language") String language = "en-US",
    @Query("page") int page = 1,
    @Header("Authorization") required String token,
  });
}
