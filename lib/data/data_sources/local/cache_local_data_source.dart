import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

import '../../../domain/entities/local/cache_isar.dart';

abstract class CacheLocalDataSource {
  Future<void> saveCache(CacheIsar cacheIsar);
  Future<CacheIsar?> getCache({required String key});
  Future<void> deleteCache({required String key});
  Future<void> deleteAllCaches();
}

@LazySingleton(as: CacheLocalDataSource)
class CacheLocalDataSourceImpl implements CacheLocalDataSource {
  final Directory applicationDocumentsDirectory;

  CacheLocalDataSourceImpl(this.applicationDocumentsDirectory);

  @override
  Future<void> saveCache(CacheIsar cacheIsar) async {
    Isar? isar = Isar.getInstance();

    isar?.writeTxnSync(() {
      isar.cacheIsars.putSync(cacheIsar);
    });
  }

  @override
  Future<CacheIsar?> getCache({required String key}) async {
    Isar? isar = Isar.getInstance();

    return isar?.cacheIsars.filter().keyEqualTo(key).findFirstSync();
  }

  @override
  Future<void> deleteCache({required String key}) async {
    Isar? isar = Isar.getInstance();

    isar?.writeTxnSync(() {
      isar.cacheIsars.filter().keyEqualTo(key).deleteFirstSync();
    });
  }

  @override
  Future<void> deleteAllCaches() async {
    Isar? isar = Isar.getInstance();

    isar?.writeTxnSync(() {
      isar.cacheIsars.clearSync();
    });
  }
}
