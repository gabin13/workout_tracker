// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_set.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWorkoutSetCollection on Isar {
  IsarCollection<WorkoutSet> get workoutSets => this.collection();
}

const WorkoutSetSchema = CollectionSchema(
  name: r'WorkoutSet',
  id: -5974587475565306185,
  properties: {
    r'exerciseId': PropertySchema(
      id: 0,
      name: r'exerciseId',
      type: IsarType.long,
    ),
    r'poids': PropertySchema(
      id: 1,
      name: r'poids',
      type: IsarType.double,
    ),
    r'repetitions': PropertySchema(
      id: 2,
      name: r'repetitions',
      type: IsarType.long,
    ),
    r'rpe': PropertySchema(
      id: 3,
      name: r'rpe',
      type: IsarType.long,
    ),
    r'typeSerie': PropertySchema(
      id: 4,
      name: r'typeSerie',
      type: IsarType.byte,
      enumMap: _WorkoutSettypeSerieEnumValueMap,
    ),
    r'workoutId': PropertySchema(
      id: 5,
      name: r'workoutId',
      type: IsarType.long,
    )
  },
  estimateSize: _workoutSetEstimateSize,
  serialize: _workoutSetSerialize,
  deserialize: _workoutSetDeserialize,
  deserializeProp: _workoutSetDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _workoutSetGetId,
  getLinks: _workoutSetGetLinks,
  attach: _workoutSetAttach,
  version: '3.1.0+1',
);

int _workoutSetEstimateSize(
  WorkoutSet object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _workoutSetSerialize(
  WorkoutSet object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.exerciseId);
  writer.writeDouble(offsets[1], object.poids);
  writer.writeLong(offsets[2], object.repetitions);
  writer.writeLong(offsets[3], object.rpe);
  writer.writeByte(offsets[4], object.typeSerie.index);
  writer.writeLong(offsets[5], object.workoutId);
}

WorkoutSet _workoutSetDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WorkoutSet();
  object.exerciseId = reader.readLong(offsets[0]);
  object.id = id;
  object.poids = reader.readDouble(offsets[1]);
  object.repetitions = reader.readLong(offsets[2]);
  object.rpe = reader.readLongOrNull(offsets[3]);
  object.typeSerie =
      _WorkoutSettypeSerieValueEnumMap[reader.readByteOrNull(offsets[4])] ??
          SetType.echauffement;
  object.workoutId = reader.readLong(offsets[5]);
  return object;
}

P _workoutSetDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (_WorkoutSettypeSerieValueEnumMap[reader.readByteOrNull(offset)] ??
          SetType.echauffement) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _WorkoutSettypeSerieEnumValueMap = {
  'echauffement': 0,
  'normale': 1,
  'echec': 2,
  'dropSet': 3,
};
const _WorkoutSettypeSerieValueEnumMap = {
  0: SetType.echauffement,
  1: SetType.normale,
  2: SetType.echec,
  3: SetType.dropSet,
};

Id _workoutSetGetId(WorkoutSet object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _workoutSetGetLinks(WorkoutSet object) {
  return [];
}

void _workoutSetAttach(IsarCollection<dynamic> col, Id id, WorkoutSet object) {
  object.id = id;
}

extension WorkoutSetQueryWhereSort
    on QueryBuilder<WorkoutSet, WorkoutSet, QWhere> {
  QueryBuilder<WorkoutSet, WorkoutSet, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WorkoutSetQueryWhere
    on QueryBuilder<WorkoutSet, WorkoutSet, QWhereClause> {
  QueryBuilder<WorkoutSet, WorkoutSet, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterWhereClause> idBetween(
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

extension WorkoutSetQueryFilter
    on QueryBuilder<WorkoutSet, WorkoutSet, QFilterCondition> {
  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition> exerciseIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseId',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition>
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

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition>
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

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition> exerciseIdBetween(
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

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition> idBetween(
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

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition> poidsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'poids',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition> poidsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'poids',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition> poidsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'poids',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition> poidsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'poids',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition>
      repetitionsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repetitions',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition>
      repetitionsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'repetitions',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition>
      repetitionsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'repetitions',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition>
      repetitionsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'repetitions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition> rpeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rpe',
      ));
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition> rpeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rpe',
      ));
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition> rpeEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rpe',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition> rpeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rpe',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition> rpeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rpe',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition> rpeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rpe',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition> typeSerieEqualTo(
      SetType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeSerie',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition>
      typeSerieGreaterThan(
    SetType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'typeSerie',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition> typeSerieLessThan(
    SetType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'typeSerie',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition> typeSerieBetween(
    SetType lower,
    SetType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'typeSerie',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition> workoutIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workoutId',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition>
      workoutIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'workoutId',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition> workoutIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'workoutId',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterFilterCondition> workoutIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'workoutId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WorkoutSetQueryObject
    on QueryBuilder<WorkoutSet, WorkoutSet, QFilterCondition> {}

extension WorkoutSetQueryLinks
    on QueryBuilder<WorkoutSet, WorkoutSet, QFilterCondition> {}

extension WorkoutSetQuerySortBy
    on QueryBuilder<WorkoutSet, WorkoutSet, QSortBy> {
  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> sortByExerciseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseId', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> sortByExerciseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseId', Sort.desc);
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> sortByPoids() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poids', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> sortByPoidsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poids', Sort.desc);
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> sortByRepetitions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repetitions', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> sortByRepetitionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repetitions', Sort.desc);
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> sortByRpe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpe', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> sortByRpeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpe', Sort.desc);
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> sortByTypeSerie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeSerie', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> sortByTypeSerieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeSerie', Sort.desc);
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> sortByWorkoutId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutId', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> sortByWorkoutIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutId', Sort.desc);
    });
  }
}

extension WorkoutSetQuerySortThenBy
    on QueryBuilder<WorkoutSet, WorkoutSet, QSortThenBy> {
  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> thenByExerciseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseId', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> thenByExerciseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseId', Sort.desc);
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> thenByPoids() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poids', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> thenByPoidsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poids', Sort.desc);
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> thenByRepetitions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repetitions', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> thenByRepetitionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repetitions', Sort.desc);
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> thenByRpe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpe', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> thenByRpeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpe', Sort.desc);
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> thenByTypeSerie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeSerie', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> thenByTypeSerieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeSerie', Sort.desc);
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> thenByWorkoutId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutId', Sort.asc);
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QAfterSortBy> thenByWorkoutIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutId', Sort.desc);
    });
  }
}

extension WorkoutSetQueryWhereDistinct
    on QueryBuilder<WorkoutSet, WorkoutSet, QDistinct> {
  QueryBuilder<WorkoutSet, WorkoutSet, QDistinct> distinctByExerciseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exerciseId');
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QDistinct> distinctByPoids() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'poids');
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QDistinct> distinctByRepetitions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'repetitions');
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QDistinct> distinctByRpe() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rpe');
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QDistinct> distinctByTypeSerie() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'typeSerie');
    });
  }

  QueryBuilder<WorkoutSet, WorkoutSet, QDistinct> distinctByWorkoutId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workoutId');
    });
  }
}

extension WorkoutSetQueryProperty
    on QueryBuilder<WorkoutSet, WorkoutSet, QQueryProperty> {
  QueryBuilder<WorkoutSet, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WorkoutSet, int, QQueryOperations> exerciseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exerciseId');
    });
  }

  QueryBuilder<WorkoutSet, double, QQueryOperations> poidsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'poids');
    });
  }

  QueryBuilder<WorkoutSet, int, QQueryOperations> repetitionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repetitions');
    });
  }

  QueryBuilder<WorkoutSet, int?, QQueryOperations> rpeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rpe');
    });
  }

  QueryBuilder<WorkoutSet, SetType, QQueryOperations> typeSerieProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'typeSerie');
    });
  }

  QueryBuilder<WorkoutSet, int, QQueryOperations> workoutIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workoutId');
    });
  }
}
