import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:movies_app/domain/entities/local/cache_isar.dart';
import 'package:movies_app/presentation/blocs/bloc_observer.dart';

import 'di/get_it.dart';

Future<void> configMain() async {
  await configureDependencies();

  await Isar.open([CacheIsarSchema], directory: getIt<Directory>().path);

  Bloc.observer = getIt.get<MoviesBlocObserver>();
}
