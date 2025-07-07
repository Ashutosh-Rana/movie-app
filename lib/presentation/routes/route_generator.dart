import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movies_app/presentation/blocs/home/home_bloc.dart';
import 'package:movies_app/presentation/blocs/movie_detail/movie_detail_bloc.dart';
import 'package:movies_app/presentation/blocs/search/search_bloc.dart';
import 'package:movies_app/presentation/routes/route_arguments.dart';
import 'package:movies_app/presentation/routes/routes.dart';
import 'package:movies_app/presentation/screens/home/home_screen.dart';
import 'package:movies_app/presentation/screens/main_screen.dart';
import 'package:movies_app/presentation/screens/movie_detail/movie_detail_screen.dart';
import 'package:movies_app/presentation/screens/search/search_screen.dart';

import '../../di/get_it.dart';

abstract class RouteGenerator {
  Route<dynamic> generateRoute(RouteSettings settings);
}

@LazySingleton(as: RouteGenerator)
class RouteGeneratorImpl implements RouteGenerator {
  @override
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.initial:
      case Routes.main:
        return MaterialPageRoute(
          builder:
              (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<HomeBloc>(create: (_) => getIt<HomeBloc>()),
                  BlocProvider<SearchBloc>(create: (_) => getIt<SearchBloc>()),
                ],
                child: const MainScreen(),
              ),
          settings: settings,
        );

      case Routes.home:
        return MaterialPageRoute(
          builder:
              (context) => BlocProvider<HomeBloc>(
                create: (_) => getIt<HomeBloc>(),
                child: const HomeScreen(),
              ),
          settings: settings,
        );

      case Routes.search:
        return MaterialPageRoute(
          builder:
              (context) => BlocProvider<SearchBloc>(
                create: (_) => getIt<SearchBloc>(),
                child: const SearchScreen(),
              ),
          settings: settings,
        );

      case Routes.movieDetail:
        final arguments = settings.arguments as MovieDetailScreenArgs;
        return MaterialPageRoute(
          builder:
              (context) => BlocProvider(
                create:
                    (_) =>
                        getIt<MovieDetailBloc>()..add(
                          LoadMovieDetailEvent(movieId: arguments.movieId),
                        ),
                child: MovieDetailScreen(movieId: arguments.movieId),
              ),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
