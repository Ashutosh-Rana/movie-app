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

import '../core/api/api_call_with_exception.dart' as _i111;
import '../core/api/api_client.dart' as _i424;
import '../core/injection_module.dart' as _i237;
import '../data/data_sources/local/cache_local_data_source.dart' as _i772;
import '../presentation/blocs/bloc_observer.dart' as _i826;
import '../presentation/routes/route_generator.dart' as _i228;

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
    gh.lazySingleton<_i826.MoviesBlocObserver>(
        () => _i826.MoviesBlocObserver());
    gh.lazySingleton<_i772.CacheLocalDataSource>(
        () => _i772.CacheLocalDataSourceImpl(gh<_i497.Directory>()));
    gh.factory<String>(
      () => registerModule.baseUrl,
      instanceName: 'BaseUrl',
    );
    gh.lazySingleton<_i228.RouteGenerator>(() => _i228.RouteGeneratorImpl());
    gh.lazySingleton<_i361.Dio>(
        () => registerModule.dio(gh<String>(instanceName: 'BaseUrl')));
    gh.lazySingleton<_i424.ApiClient>(() => _i424.ApiClient(
          gh<_i361.Dio>(),
          baseUrl: gh<String>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i237.RegisterModule {}
