import 'package:flutter/material.dart';
import 'package:movies_app/di/get_it.dart';
import 'package:movies_app/presentation/routes/route_generator.dart';
import 'package:movies_app/presentation/routes/routes.dart';
import 'package:movies_app/utils/deep_link_handler.dart';
import 'package:movies_app/utils/snackbar_utils.dart';

import 'presentation/navigation/route_observer.dart';
import 'presentation/themes/light_theme.dart';

class MoviesApp extends StatefulWidget {
  const MoviesApp({super.key, required this.routeGenerator});

  final RouteGenerator routeGenerator;

  @override
  State<MoviesApp> createState() => _MoviesAppState();
}

class _MoviesAppState extends State<MoviesApp> {
  final _deepLinkHandler = getIt<DeepLinkHandler>();
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // Initialize deep links after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_navigatorKey.currentContext != null) {
        _deepLinkHandler.initialize(_navigatorKey.currentContext!);
      }
    });
  }

  @override
  void dispose() {
    _deepLinkHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      onGenerateRoute:
          (settings) => widget.routeGenerator.generateRoute(settings),
      scaffoldMessengerKey: SnackbarUtils.scaffoldMessengerState,
      initialRoute: Routes.main,
      title: 'Movies App',
      themeMode: ThemeMode.light,
      theme: lightTheme,
      navigatorObservers: [routeObserver],
    );
  }
}
