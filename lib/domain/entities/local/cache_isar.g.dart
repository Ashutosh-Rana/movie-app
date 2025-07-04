// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCacheIsarCollection on Isar {
  IsarCollection<CacheIsar> get cacheIsars => this.collection();
}

const CacheIsarSchema = CollectionSchema(
  name: r'CacheIsar',
  id: -8419739630078393889,
  properties: {
    r'expiryTime': PropertySchema(
      id: 0,
      name: r'expiryTime',
      type: IsarType.dateTime,
    ),
    r'isCacheInvalidated': PropertySchema(
      id: 1,
      name: r'isCacheInvalidated',
      type: IsarType.bool,
    ),
    r'key': PropertySchema(
      id: 2,
      name: r'key',
      type: IsarType.string,
    ),
    r'lastFetchTime': PropertySchema(
      id: 3,
      name: r'lastFetchTime',
      type: IsarType.dateTime,
    ),
    r'value': PropertySchema(
      id: 4,
      name: r'value',
      type: IsarType.string,
    )
  },
  estimateSize: _cacheIsarEstimateSize,
  serialize: _cacheIsarSerialize,
  deserialize: _cacheIsarDeserialize,
  deserializeProp: _cacheIsarDeserializeProp,
  idName: r'cacheId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _cacheIsarGetId,
  getLinks: _cacheIsarGetLinks,
  attach: _cacheIsarAttach,
  version: '3.1.0+1',
);

int _cacheIsarEstimateSize(
  CacheIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.key;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.value;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _cacheIsarSerialize(
  CacheIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.expiryTime);
  writer.writeBool(offsets[1], object.isCacheInvalidated);
  writer.writeString(offsets[2], object.key);
  writer.writeDateTime(offsets[3], object.lastFetchTime);
  writer.writeString(offsets[4], object.value);
}

CacheIsar _cacheIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CacheIsar();
  object.expiryTime = reader.readDateTimeOrNull(offsets[0]);
  object.key = reader.readStringOrNull(offsets[2]);
  object.lastFetchTime = reader.readDateTimeOrNull(offsets[3]);
  object.value = reader.readStringOrNull(offsets[4]);
  return object;
}

P _cacheIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _cacheIsarGetId(CacheIsar object) {
  return object.cacheId;
}

List<IsarLinkBase<dynamic>> _cacheIsarGetLinks(CacheIsar object) {
  return [];
}

void _cacheIsarAttach(IsarCollection<dynamic> col, Id id, CacheIsar object) {}

extension CacheIsarQueryWhereSort
    on QueryBuilder<CacheIsar, CacheIsar, QWhere> {
  QueryBuilder<CacheIsar, CacheIsar, QAfterWhere> anyCacheId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CacheIsarQueryWhere
    on QueryBuilder<CacheIsar, CacheIsar, QWhereClause> {
  QueryBuilder<CacheIsar, CacheIsar, QAfterWhereClause> cacheIdEqualTo(
      Id cacheId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: cacheId,
        upper: cacheId,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterWhereClause> cacheIdNotEqualTo(
      Id cacheId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: cacheId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: cacheId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: cacheId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: cacheId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterWhereClause> cacheIdGreaterThan(
      Id cacheId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: cacheId, includeLower: include),
      );
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterWhereClause> cacheIdLessThan(
      Id cacheId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: cacheId, includeUpper: include),
      );
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterWhereClause> cacheIdBetween(
    Id lowerCacheId,
    Id upperCacheId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerCacheId,
        includeLower: includeLower,
        upper: upperCacheId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CacheIsarQueryFilter
    on QueryBuilder<CacheIsar, CacheIsar, QFilterCondition> {
  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> cacheIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cacheId',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> cacheIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cacheId',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> cacheIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cacheId',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> cacheIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cacheId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> expiryTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'expiryTime',
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition>
      expiryTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'expiryTime',
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> expiryTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expiryTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition>
      expiryTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expiryTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> expiryTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expiryTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> expiryTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expiryTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition>
      isCacheInvalidatedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCacheInvalidated',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> keyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'key',
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> keyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'key',
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> keyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> keyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> keyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> keyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'key',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> keyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> keyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> keyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> keyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'key',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition>
      lastFetchTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastFetchTime',
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition>
      lastFetchTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastFetchTime',
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition>
      lastFetchTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastFetchTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition>
      lastFetchTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastFetchTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition>
      lastFetchTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastFetchTime',
        value: value,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition>
      lastFetchTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastFetchTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> valueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'value',
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> valueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'value',
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> valueEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> valueGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> valueLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> valueBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> valueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> valueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> valueContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> valueMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'value',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> valueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: '',
      ));
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterFilterCondition> valueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'value',
        value: '',
      ));
    });
  }
}

extension CacheIsarQueryObject
    on QueryBuilder<CacheIsar, CacheIsar, QFilterCondition> {}

extension CacheIsarQueryLinks
    on QueryBuilder<CacheIsar, CacheIsar, QFilterCondition> {}

extension CacheIsarQuerySortBy on QueryBuilder<CacheIsar, CacheIsar, QSortBy> {
  QueryBuilder<CacheIsar, CacheIsar, QAfterSortBy> sortByExpiryTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiryTime', Sort.asc);
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterSortBy> sortByExpiryTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiryTime', Sort.desc);
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterSortBy> sortByIsCacheInvalidated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCacheInvalidated', Sort.asc);
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterSortBy>
      sortByIsCacheInvalidatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCacheInvalidated', Sort.desc);
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterSortBy> sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterSortBy> sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterSortBy> sortByLastFetchTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFetchTime', Sort.asc);
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterSortBy> sortByLastFetchTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFetchTime', Sort.desc);
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterSortBy> sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterSortBy> sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension CacheIsarQuerySortThenBy
    on QueryBuilder<CacheIsar, CacheIsar, QSortThenBy> {
  QueryBuilder<CacheIsar, CacheIsar, QAfterSortBy> thenByCacheId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheId', Sort.asc);
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterSortBy> thenByCacheIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheId', Sort.desc);
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterSortBy> thenByExpiryTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiryTime', Sort.asc);
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterSortBy> thenByExpiryTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiryTime', Sort.desc);
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterSortBy> thenByIsCacheInvalidated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCacheInvalidated', Sort.asc);
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterSortBy>
      thenByIsCacheInvalidatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCacheInvalidated', Sort.desc);
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterSortBy> thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterSortBy> thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterSortBy> thenByLastFetchTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFetchTime', Sort.asc);
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterSortBy> thenByLastFetchTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFetchTime', Sort.desc);
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterSortBy> thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QAfterSortBy> thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension CacheIsarQueryWhereDistinct
    on QueryBuilder<CacheIsar, CacheIsar, QDistinct> {
  QueryBuilder<CacheIsar, CacheIsar, QDistinct> distinctByExpiryTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expiryTime');
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QDistinct> distinctByIsCacheInvalidated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCacheInvalidated');
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QDistinct> distinctByKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QDistinct> distinctByLastFetchTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastFetchTime');
    });
  }

  QueryBuilder<CacheIsar, CacheIsar, QDistinct> distinctByValue(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value', caseSensitive: caseSensitive);
    });
  }
}

extension CacheIsarQueryProperty
    on QueryBuilder<CacheIsar, CacheIsar, QQueryProperty> {
  QueryBuilder<CacheIsar, int, QQueryOperations> cacheIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cacheId');
    });
  }

  QueryBuilder<CacheIsar, DateTime?, QQueryOperations> expiryTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expiryTime');
    });
  }

  QueryBuilder<CacheIsar, bool, QQueryOperations> isCacheInvalidatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCacheInvalidated');
    });
  }

  QueryBuilder<CacheIsar, String?, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<CacheIsar, DateTime?, QQueryOperations> lastFetchTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastFetchTime');
    });
  }

  QueryBuilder<CacheIsar, String?, QQueryOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }
}
