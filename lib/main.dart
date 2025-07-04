import 'package:flutter/material.dart';

import 'app.dart';
import 'config_main.dart';
import 'di/get_it.dart';
import 'presentation/routes/route_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configMain();
  runApp(MoviesApp(routeGenerator: getIt<RouteGenerator>()));
}
