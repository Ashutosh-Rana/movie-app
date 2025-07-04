import 'package:flutter/material.dart';
import 'package:movies_app/presentation/routes/route_generator.dart';
import 'package:movies_app/presentation/routes/routes.dart';
import 'package:movies_app/utils/snackbar_utils.dart';

import 'presentation/themes/light_theme.dart';

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key, required this.routeGenerator});

  final RouteGenerator routeGenerator;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) => routeGenerator.generateRoute(settings),
      scaffoldMessengerKey: SnackbarUtils.scaffoldMessengerState,
      initialRoute: Routes.home,
      title: 'Movies App',
      themeMode: ThemeMode.light,
      theme: lightTheme,
    );
  }
}
