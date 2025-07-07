// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:io' as _i497;

import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:isar/isar.dart' as _i338;

import '../core/api/api_call_with_exception.dart' as _i111;
import '../core/api/api_client.dart' as _i424;
import '../core/injection_module.dart' as _i237;
import '../data/data_sources/local/cache_local_data_source.dart' as _i772;
import '../data/data_sources/local/movie_local_data_source.dart' as _i70;
import '../data/data_sources/remote/movie_remote_data_source.dart' as _i789;
import '../data/data_sources/remote/tmdb_api_client.dart' as _i727;
import '../data/repositories/movie_repository_impl.dart' as _i992;
import '../domain/repositories/movie_repository.dart' as _i897;
import '../domain/usecases/bookmark_usecases.dart' as _i329;
import '../domain/usecases/get_movie_detail_usecase.dart' as _i766;
import '../domain/usecases/get_now_playing_movies_usecase.dart' as _i464;
import '../domain/usecases/get_trending_movies_usecase.dart' as _i752;
import '../domain/usecases/search_movies_usecase.dart' as _i24;
import '../presentation/blocs/bloc_observer.dart' as _i826;
import '../presentation/blocs/home/home_bloc.dart' as _i3;
import '../presentation/blocs/movie_detail/movie_detail_bloc.dart' as _i621;
import '../presentation/blocs/search/search_bloc.dart' as _i402;
import '../presentation/routes/route_generator.dart' as _i228;
import '../utils/deep_link_handler.dart' as _i182;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> $initGetIt({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i497.Directory>(
      () => registerModule.applicationDocumentsDirectory(),
      preResolve: true,
    );
    gh.lazySingleton<_i111.ApiCallWithException>(
        () => _i111.ApiCallWithException());
    gh.lazySingleton<_i424.DioProvider>(() => _i424.DioProvider());
    gh.lazySingleton<_i182.DeepLinkHandler>(() => _i182.DeepLinkHandler());
    gh.lazySingleton<_i826.MoviesBlocObserver>(
        () => _i826.MoviesBlocObserver());
    gh.lazySingleton<_i772.CacheLocalDataSource>(
        () => _i772.CacheLocalDataSourceImpl(gh<_i497.Directory>()));
    gh.factory<String>(
      () => registerModule.baseUrl,
      instanceName: 'BaseUrl',
    );
    gh.lazySingleton<_i70.MovieLocalDataSource>(
        () => _i70.MovieLocalDataSourceImpl(gh<_i338.Isar>()));
    gh.lazySingleton<_i228.RouteGenerator>(() => _i228.RouteGeneratorImpl());
    gh.lazySingleton<_i361.Dio>(
        () => registerModule.dio(gh<String>(instanceName: 'BaseUrl')));
    gh.factory<_i727.TMDBApiClient>(() => _i727.TMDBApiClient(gh<_i361.Dio>()));
    gh.factory<_i789.MovieRemoteDataSource>(
        () => _i789.MovieRemoteDataSourceImpl(gh<_i727.TMDBApiClient>()));
    gh.lazySingleton<_i897.MovieRepository>(() => _i992.MovieRepositoryImpl(
          gh<_i789.MovieRemoteDataSource>(),
          gh<_i70.MovieLocalDataSource>(),
          gh<_i111.ApiCallWithException>(),
        ));
    gh.lazySingleton<_i424.ApiClient>(() => _i424.ApiClient(
          gh<_i361.Dio>(),
          baseUrl: gh<String>(),
        ));
    gh.factory<_i766.GetMovieDetailUseCase>(
        () => _i766.GetMovieDetailUseCase(gh<_i897.MovieRepository>()));
    gh.factory<_i752.GetTrendingMoviesUseCase>(
        () => _i752.GetTrendingMoviesUseCase(gh<_i897.MovieRepository>()));
    gh.factory<_i24.SearchMoviesUseCase>(
        () => _i24.SearchMoviesUseCase(gh<_i897.MovieRepository>()));
    gh.factory<_i329.GetBookmarkedMoviesUseCase>(
        () => _i329.GetBookmarkedMoviesUseCase(gh<_i897.MovieRepository>()));
    gh.factory<_i329.ToggleBookmarkUseCase>(
        () => _i329.ToggleBookmarkUseCase(gh<_i897.MovieRepository>()));
    gh.factory<_i329.IsMovieBookmarkedUseCase>(
        () => _i329.IsMovieBookmarkedUseCase(gh<_i897.MovieRepository>()));
    gh.factory<_i464.GetNowPlayingMoviesUseCase>(
        () => _i464.GetNowPlayingMoviesUseCase(gh<_i897.MovieRepository>()));
    gh.factory<_i402.SearchBloc>(
        () => _i402.SearchBloc(gh<_i24.SearchMoviesUseCase>()));
    gh.factory<_i3.HomeBloc>(() => _i3.HomeBloc(
          gh<_i752.GetTrendingMoviesUseCase>(),
          gh<_i464.GetNowPlayingMoviesUseCase>(),
          gh<_i329.GetBookmarkedMoviesUseCase>(),
        ));
    gh.factory<_i621.MovieDetailBloc>(() => _i621.MovieDetailBloc(
          gh<_i766.GetMovieDetailUseCase>(),
          gh<_i329.ToggleBookmarkUseCase>(),
          gh<_i329.IsMovieBookmarkedUseCase>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i237.RegisterModule {}
