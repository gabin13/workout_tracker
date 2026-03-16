// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_program.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWorkoutProgramCollection on Isar {
  IsarCollection<WorkoutProgram> get workoutPrograms => this.collection();
}

const WorkoutProgramSchema = CollectionSchema(
  name: r'WorkoutProgram',
  id: -6593644939650984875,
  properties: {
    r'exerciceIds': PropertySchema(
      id: 0,
      name: r'exerciceIds',
      type: IsarType.longList,
    ),
    r'nom': PropertySchema(
      id: 1,
      name: r'nom',
      type: IsarType.string,
    )
  },
  estimateSize: _workoutProgramEstimateSize,
  serialize: _workoutProgramSerialize,
  deserialize: _workoutProgramDeserialize,
  deserializeProp: _workoutProgramDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _workoutProgramGetId,
  getLinks: _workoutProgramGetLinks,
  attach: _workoutProgramAttach,
  version: '3.1.0+1',
);

int _workoutProgramEstimateSize(
  WorkoutProgram object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.exerciceIds.length * 8;
  bytesCount += 3 + object.nom.length * 3;
  return bytesCount;
}

void _workoutProgramSerialize(
  WorkoutProgram object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLongList(offsets[0], object.exerciceIds);
  writer.writeString(offsets[1], object.nom);
}

WorkoutProgram _workoutProgramDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WorkoutProgram();
  object.exerciceIds = reader.readLongList(offsets[0]) ?? [];
  object.id = id;
  object.nom = reader.readString(offsets[1]);
  return object;
}

P _workoutProgramDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongList(offset) ?? []) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _workoutProgramGetId(WorkoutProgram object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _workoutProgramGetLinks(WorkoutProgram object) {
  return [];
}

void _workoutProgramAttach(
    IsarCollection<dynamic> col, Id id, WorkoutProgram object) {
  object.id = id;
}

extension WorkoutProgramQueryWhereSort
    on QueryBuilder<WorkoutProgram, WorkoutProgram, QWhere> {
  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WorkoutProgramQueryWhere
    on QueryBuilder<WorkoutProgram, WorkoutProgram, QWhereClause> {
  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterWhereClause> idBetween(
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

extension WorkoutProgramQueryFilter
    on QueryBuilder<WorkoutProgram, WorkoutProgram, QFilterCondition> {
  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      exerciceIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciceIds',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      exerciceIdsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exerciceIds',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      exerciceIdsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exerciceIds',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      exerciceIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exerciceIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      exerciceIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exerciceIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      exerciceIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exerciceIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      exerciceIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exerciceIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      exerciceIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exerciceIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      exerciceIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exerciceIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      exerciceIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exerciceIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
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

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
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

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition> idBetween(
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

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      nomEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      nomGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      nomLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      nomBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nom',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      nomStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      nomEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      nomContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      nomMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nom',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      nomIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nom',
        value: '',
      ));
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      nomIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nom',
        value: '',
      ));
    });
  }
}

extension WorkoutProgramQueryObject
    on QueryBuilder<WorkoutProgram, WorkoutProgram, QFilterCondition> {}

extension WorkoutProgramQueryLinks
    on QueryBuilder<WorkoutProgram, WorkoutProgram, QFilterCondition> {}

extension WorkoutProgramQuerySortBy
    on QueryBuilder<WorkoutProgram, WorkoutProgram, QSortBy> {
  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterSortBy> sortByNom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.asc);
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterSortBy> sortByNomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.desc);
    });
  }
}

extension WorkoutProgramQuerySortThenBy
    on QueryBuilder<WorkoutProgram, WorkoutProgram, QSortThenBy> {
  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterSortBy> thenByNom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.asc);
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterSortBy> thenByNomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.desc);
    });
  }
}

extension WorkoutProgramQueryWhereDistinct
    on QueryBuilder<WorkoutProgram, WorkoutProgram, QDistinct> {
  QueryBuilder<WorkoutProgram, WorkoutProgram, QDistinct>
      distinctByExerciceIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exerciceIds');
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QDistinct> distinctByNom(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nom', caseSensitive: caseSensitive);
    });
  }
}

extension WorkoutProgramQueryProperty
    on QueryBuilder<WorkoutProgram, WorkoutProgram, QQueryProperty> {
  QueryBuilder<WorkoutProgram, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WorkoutProgram, List<int>, QQueryOperations>
      exerciceIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exerciceIds');
    });
  }

  QueryBuilder<WorkoutProgram, String, QQueryOperations> nomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nom');
    });
  }
}
