import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:movies_app/presentation/blocs/bloc_observer.dart';

import 'di/get_it.dart';
import 'domain/entities/local/isar_config.dart';

Future<void> configMain() async {
  await configureDependencies();

  // Initialize Isar with both cache and movie schemas
  final isar = await initializeIsar();

  // Register the Isar instance with GetIt
  getIt.registerSingleton<Isar>(isar);

  Bloc.observer = getIt.get<MoviesBlocObserver>();
}
