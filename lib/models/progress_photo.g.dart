// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_photo.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProgressPhotoCollection on Isar {
  IsarCollection<ProgressPhoto> get progressPhotos => this.collection();
}

const ProgressPhotoSchema = CollectionSchema(
  name: r'ProgressPhoto',
  id: 2551591099620620851,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'imageLocalPath': PropertySchema(
      id: 1,
      name: r'imageLocalPath',
      type: IsarType.string,
    )
  },
  estimateSize: _progressPhotoEstimateSize,
  serialize: _progressPhotoSerialize,
  deserialize: _progressPhotoDeserialize,
  deserializeProp: _progressPhotoDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _progressPhotoGetId,
  getLinks: _progressPhotoGetLinks,
  attach: _progressPhotoAttach,
  version: '3.1.0+1',
);

int _progressPhotoEstimateSize(
  ProgressPhoto object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.imageLocalPath.length * 3;
  return bytesCount;
}

void _progressPhotoSerialize(
  ProgressPhoto object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeString(offsets[1], object.imageLocalPath);
}

ProgressPhoto _progressPhotoDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProgressPhoto();
  object.date = reader.readDateTime(offsets[0]);
  object.id = id;
  object.imageLocalPath = reader.readString(offsets[1]);
  return object;
}

P _progressPhotoDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _progressPhotoGetId(ProgressPhoto object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _progressPhotoGetLinks(ProgressPhoto object) {
  return [];
}

void _progressPhotoAttach(
    IsarCollection<dynamic> col, Id id, ProgressPhoto object) {
  object.id = id;
}

extension ProgressPhotoQueryWhereSort
    on QueryBuilder<ProgressPhoto, ProgressPhoto, QWhere> {
  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProgressPhotoQueryWhere
    on QueryBuilder<ProgressPhoto, ProgressPhoto, QWhereClause> {
  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ProgressPhotoQueryFilter
    on QueryBuilder<ProgressPhoto, ProgressPhoto, QFilterCondition> {
  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterFilterCondition>
      dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterFilterCondition>
      dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterFilterCondition>
      imageLocalPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterFilterCondition>
      imageLocalPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imageLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterFilterCondition>
      imageLocalPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imageLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterFilterCondition>
      imageLocalPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imageLocalPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterFilterCondition>
      imageLocalPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imageLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterFilterCondition>
      imageLocalPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imageLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterFilterCondition>
      imageLocalPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imageLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterFilterCondition>
      imageLocalPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imageLocalPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterFilterCondition>
      imageLocalPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageLocalPath',
        value: '',
      ));
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterFilterCondition>
      imageLocalPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imageLocalPath',
        value: '',
      ));
    });
  }
}

extension ProgressPhotoQueryObject
    on QueryBuilder<ProgressPhoto, ProgressPhoto, QFilterCondition> {}

extension ProgressPhotoQueryLinks
    on QueryBuilder<ProgressPhoto, ProgressPhoto, QFilterCondition> {}

extension ProgressPhotoQuerySortBy
    on QueryBuilder<ProgressPhoto, ProgressPhoto, QSortBy> {
  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterSortBy>
      sortByImageLocalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageLocalPath', Sort.asc);
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterSortBy>
      sortByImageLocalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageLocalPath', Sort.desc);
    });
  }
}

extension ProgressPhotoQuerySortThenBy
    on QueryBuilder<ProgressPhoto, ProgressPhoto, QSortThenBy> {
  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterSortBy>
      thenByImageLocalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageLocalPath', Sort.asc);
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QAfterSortBy>
      thenByImageLocalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageLocalPath', Sort.desc);
    });
  }
}

extension ProgressPhotoQueryWhereDistinct
    on QueryBuilder<ProgressPhoto, ProgressPhoto, QDistinct> {
  QueryBuilder<ProgressPhoto, ProgressPhoto, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<ProgressPhoto, ProgressPhoto, QDistinct>
      distinctByImageLocalPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imageLocalPath',
          caseSensitive: caseSensitive);
    });
  }
}

extension ProgressPhotoQueryProperty
    on QueryBuilder<ProgressPhoto, ProgressPhoto, QQueryProperty> {
  QueryBuilder<ProgressPhoto, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ProgressPhoto, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<ProgressPhoto, String, QQueryOperations>
      imageLocalPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imageLocalPath');
    });
  }
}
