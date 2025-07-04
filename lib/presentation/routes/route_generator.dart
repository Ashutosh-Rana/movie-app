import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:movies_app/presentation/routes/routes.dart';
import 'package:movies_app/presentation/screens/home/home_screen.dart';

abstract class RouteGenerator {
  Route<dynamic> generateRoute(RouteSettings settings);
}

@LazySingleton(as: RouteGenerator)
class RouteGeneratorImpl implements RouteGenerator {
  @override
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
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
