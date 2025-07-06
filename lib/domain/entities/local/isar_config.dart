import 'package:isar/isar.dart';
import 'package:movies_app/domain/entities/movie.dart';
import 'package:movies_app/domain/entities/movie_detail.dart';
import 'package:path_provider/path_provider.dart';

/// Initialize and configure Isar database
Future<Isar> initializeIsar() async {
  final dir = await getApplicationDocumentsDirectory();

  final isar = await Isar.open([
    MovieSchema,
    MovieDetailSchema,
  ], directory: dir.path);

  return isar;
}
