import 'package:isar/isar.dart';

import '../../../utils/isar_utils.dart';

part 'cache_isar.g.dart';

@collection
class CacheIsar {
  Id get cacheId => IsarUtils.fastHash(key!);
  String? key;
  String? value;
  DateTime? lastFetchTime;
  DateTime? expiryTime;

  @override
  String toString() =>
      'CacheIsar(key: $key, value: $value, lastFetchTime: $lastFetchTime, expiryTime: $expiryTime)';

  //returns true if the cache is invalidated
  bool get isCacheInvalidated =>
      (value == null ||
          lastFetchTime == null ||
          expiryTime == null ||
          value!.isEmpty ||
          expiryTime!.isAfter(DateTime.now()));
}
