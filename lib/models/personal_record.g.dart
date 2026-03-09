// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPersonalRecordCollection on Isar {
  IsarCollection<PersonalRecord> get personalRecords => this.collection();
}

const PersonalRecordSchema = CollectionSchema(
  name: r'PersonalRecord',
  id: -5502306867987183745,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'exerciseId': PropertySchema(
      id: 1,
      name: r'exerciseId',
      type: IsarType.long,
    ),
    r'typeRecord': PropertySchema(
      id: 2,
      name: r'typeRecord',
      type: IsarType.byte,
      enumMap: _PersonalRecordtypeRecordEnumValueMap,
    ),
    r'valeur': PropertySchema(
      id: 3,
      name: r'valeur',
      type: IsarType.double,
    )
  },
  estimateSize: _personalRecordEstimateSize,
  serialize: _personalRecordSerialize,
  deserialize: _personalRecordDeserialize,
  deserializeProp: _personalRecordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _personalRecordGetId,
  getLinks: _personalRecordGetLinks,
  attach: _personalRecordAttach,
  version: '3.1.0+1',
);

int _personalRecordEstimateSize(
  PersonalRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _personalRecordSerialize(
  PersonalRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeLong(offsets[1], object.exerciseId);
  writer.writeByte(offsets[2], object.typeRecord.index);
  writer.writeDouble(offsets[3], object.valeur);
}

PersonalRecord _personalRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PersonalRecord();
  object.date = reader.readDateTime(offsets[0]);
  object.exerciseId = reader.readLong(offsets[1]);
  object.id = id;
  object.typeRecord = _PersonalRecordtypeRecordValueEnumMap[
          reader.readByteOrNull(offsets[2])] ??
      RecordType.maxWeight;
  object.valeur = reader.readDouble(offsets[3]);
  return object;
}

P _personalRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (_PersonalRecordtypeRecordValueEnumMap[
              reader.readByteOrNull(offset)] ??
          RecordType.maxWeight) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PersonalRecordtypeRecordEnumValueMap = {
  'maxWeight': 0,
  'maxReps': 1,
  'estimated1RM': 2,
};
const _PersonalRecordtypeRecordValueEnumMap = {
  0: RecordType.maxWeight,
  1: RecordType.maxReps,
  2: RecordType.estimated1RM,
};

Id _personalRecordGetId(PersonalRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _personalRecordGetLinks(PersonalRecord object) {
  return [];
}

void _personalRecordAttach(
    IsarCollection<dynamic> col, Id id, PersonalRecord object) {
  object.id = id;
}

extension PersonalRecordQueryWhereSort
    on QueryBuilder<PersonalRecord, PersonalRecord, QWhere> {
  QueryBuilder<PersonalRecord, PersonalRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PersonalRecordQueryWhere
    on QueryBuilder<PersonalRecord, PersonalRecord, QWhereClause> {
  QueryBuilder<PersonalRecord, PersonalRecord, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterWhereClause> idBetween(
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

extension PersonalRecordQueryFilter
    on QueryBuilder<PersonalRecord, PersonalRecord, QFilterCondition> {
  QueryBuilder<PersonalRecord, PersonalRecord, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterFilterCondition>
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

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterFilterCondition>
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

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterFilterCondition>
      dateBetween(
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

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterFilterCondition>
      exerciseIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseId',
        value: value,
      ));
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterFilterCondition>
      exerciseIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exerciseId',
        value: value,
      ));
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterFilterCondition>
      exerciseIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exerciseId',
        value: value,
      ));
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterFilterCondition>
      exerciseIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exerciseId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterFilterCondition>
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

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterFilterCondition>
      typeRecordEqualTo(RecordType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeRecord',
        value: value,
      ));
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterFilterCondition>
      typeRecordGreaterThan(
    RecordType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'typeRecord',
        value: value,
      ));
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterFilterCondition>
      typeRecordLessThan(
    RecordType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'typeRecord',
        value: value,
      ));
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterFilterCondition>
      typeRecordBetween(
    RecordType lower,
    RecordType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'typeRecord',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterFilterCondition>
      valeurEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'valeur',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterFilterCondition>
      valeurGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'valeur',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterFilterCondition>
      valeurLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'valeur',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterFilterCondition>
      valeurBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'valeur',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension PersonalRecordQueryObject
    on QueryBuilder<PersonalRecord, PersonalRecord, QFilterCondition> {}

extension PersonalRecordQueryLinks
    on QueryBuilder<PersonalRecord, PersonalRecord, QFilterCondition> {}

extension PersonalRecordQuerySortBy
    on QueryBuilder<PersonalRecord, PersonalRecord, QSortBy> {
  QueryBuilder<PersonalRecord, PersonalRecord, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterSortBy>
      sortByExerciseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseId', Sort.asc);
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterSortBy>
      sortByExerciseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseId', Sort.desc);
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterSortBy>
      sortByTypeRecord() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeRecord', Sort.asc);
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterSortBy>
      sortByTypeRecordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeRecord', Sort.desc);
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterSortBy> sortByValeur() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valeur', Sort.asc);
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterSortBy>
      sortByValeurDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valeur', Sort.desc);
    });
  }
}

extension PersonalRecordQuerySortThenBy
    on QueryBuilder<PersonalRecord, PersonalRecord, QSortThenBy> {
  QueryBuilder<PersonalRecord, PersonalRecord, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterSortBy>
      thenByExerciseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseId', Sort.asc);
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterSortBy>
      thenByExerciseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseId', Sort.desc);
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterSortBy>
      thenByTypeRecord() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeRecord', Sort.asc);
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterSortBy>
      thenByTypeRecordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeRecord', Sort.desc);
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterSortBy> thenByValeur() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valeur', Sort.asc);
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QAfterSortBy>
      thenByValeurDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valeur', Sort.desc);
    });
  }
}

extension PersonalRecordQueryWhereDistinct
    on QueryBuilder<PersonalRecord, PersonalRecord, QDistinct> {
  QueryBuilder<PersonalRecord, PersonalRecord, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QDistinct>
      distinctByExerciseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exerciseId');
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QDistinct>
      distinctByTypeRecord() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'typeRecord');
    });
  }

  QueryBuilder<PersonalRecord, PersonalRecord, QDistinct> distinctByValeur() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'valeur');
    });
  }
}

extension PersonalRecordQueryProperty
    on QueryBuilder<PersonalRecord, PersonalRecord, QQueryProperty> {
  QueryBuilder<PersonalRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PersonalRecord, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<PersonalRecord, int, QQueryOperations> exerciseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exerciseId');
    });
  }

  QueryBuilder<PersonalRecord, RecordType, QQueryOperations>
      typeRecordProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'typeRecord');
    });
  }

  QueryBuilder<PersonalRecord, double, QQueryOperations> valeurProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'valeur');
    });
  }
}
