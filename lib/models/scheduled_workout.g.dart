// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_workout.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetScheduledWorkoutCollection on Isar {
  IsarCollection<ScheduledWorkout> get scheduledWorkouts => this.collection();
}

const ScheduledWorkoutSchema = CollectionSchema(
  name: r'ScheduledWorkout',
  id: 561776984270211463,
  properties: {
    r'datePrevue': PropertySchema(
      id: 0,
      name: r'datePrevue',
      type: IsarType.dateTime,
    ),
    r'isCompleted': PropertySchema(
      id: 1,
      name: r'isCompleted',
      type: IsarType.bool,
    ),
    r'workoutProgramId': PropertySchema(
      id: 2,
      name: r'workoutProgramId',
      type: IsarType.long,
    )
  },
  estimateSize: _scheduledWorkoutEstimateSize,
  serialize: _scheduledWorkoutSerialize,
  deserialize: _scheduledWorkoutDeserialize,
  deserializeProp: _scheduledWorkoutDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _scheduledWorkoutGetId,
  getLinks: _scheduledWorkoutGetLinks,
  attach: _scheduledWorkoutAttach,
  version: '3.1.0+1',
);

int _scheduledWorkoutEstimateSize(
  ScheduledWorkout object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _scheduledWorkoutSerialize(
  ScheduledWorkout object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.datePrevue);
  writer.writeBool(offsets[1], object.isCompleted);
  writer.writeLong(offsets[2], object.workoutProgramId);
}

ScheduledWorkout _scheduledWorkoutDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ScheduledWorkout();
  object.datePrevue = reader.readDateTime(offsets[0]);
  object.id = id;
  object.isCompleted = reader.readBool(offsets[1]);
  object.workoutProgramId = reader.readLong(offsets[2]);
  return object;
}

P _scheduledWorkoutDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _scheduledWorkoutGetId(ScheduledWorkout object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _scheduledWorkoutGetLinks(ScheduledWorkout object) {
  return [];
}

void _scheduledWorkoutAttach(
    IsarCollection<dynamic> col, Id id, ScheduledWorkout object) {
  object.id = id;
}

extension ScheduledWorkoutQueryWhereSort
    on QueryBuilder<ScheduledWorkout, ScheduledWorkout, QWhere> {
  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ScheduledWorkoutQueryWhere
    on QueryBuilder<ScheduledWorkout, ScheduledWorkout, QWhereClause> {
  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterWhereClause> idBetween(
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

extension ScheduledWorkoutQueryFilter
    on QueryBuilder<ScheduledWorkout, ScheduledWorkout, QFilterCondition> {
  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterFilterCondition>
      datePrevueEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'datePrevue',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterFilterCondition>
      datePrevueGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'datePrevue',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterFilterCondition>
      datePrevueLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'datePrevue',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterFilterCondition>
      datePrevueBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'datePrevue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterFilterCondition>
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

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterFilterCondition>
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

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterFilterCondition>
      isCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterFilterCondition>
      workoutProgramIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workoutProgramId',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterFilterCondition>
      workoutProgramIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'workoutProgramId',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterFilterCondition>
      workoutProgramIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'workoutProgramId',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterFilterCondition>
      workoutProgramIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'workoutProgramId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ScheduledWorkoutQueryObject
    on QueryBuilder<ScheduledWorkout, ScheduledWorkout, QFilterCondition> {}

extension ScheduledWorkoutQueryLinks
    on QueryBuilder<ScheduledWorkout, ScheduledWorkout, QFilterCondition> {}

extension ScheduledWorkoutQuerySortBy
    on QueryBuilder<ScheduledWorkout, ScheduledWorkout, QSortBy> {
  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterSortBy>
      sortByDatePrevue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'datePrevue', Sort.asc);
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterSortBy>
      sortByDatePrevueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'datePrevue', Sort.desc);
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterSortBy>
      sortByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterSortBy>
      sortByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterSortBy>
      sortByWorkoutProgramId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutProgramId', Sort.asc);
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterSortBy>
      sortByWorkoutProgramIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutProgramId', Sort.desc);
    });
  }
}

extension ScheduledWorkoutQuerySortThenBy
    on QueryBuilder<ScheduledWorkout, ScheduledWorkout, QSortThenBy> {
  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterSortBy>
      thenByDatePrevue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'datePrevue', Sort.asc);
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterSortBy>
      thenByDatePrevueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'datePrevue', Sort.desc);
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterSortBy>
      thenByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterSortBy>
      thenByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterSortBy>
      thenByWorkoutProgramId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutProgramId', Sort.asc);
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QAfterSortBy>
      thenByWorkoutProgramIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutProgramId', Sort.desc);
    });
  }
}

extension ScheduledWorkoutQueryWhereDistinct
    on QueryBuilder<ScheduledWorkout, ScheduledWorkout, QDistinct> {
  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QDistinct>
      distinctByDatePrevue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'datePrevue');
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QDistinct>
      distinctByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompleted');
    });
  }

  QueryBuilder<ScheduledWorkout, ScheduledWorkout, QDistinct>
      distinctByWorkoutProgramId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workoutProgramId');
    });
  }
}

extension ScheduledWorkoutQueryProperty
    on QueryBuilder<ScheduledWorkout, ScheduledWorkout, QQueryProperty> {
  QueryBuilder<ScheduledWorkout, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ScheduledWorkout, DateTime, QQueryOperations>
      datePrevueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'datePrevue');
    });
  }

  QueryBuilder<ScheduledWorkout, bool, QQueryOperations> isCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompleted');
    });
  }

  QueryBuilder<ScheduledWorkout, int, QQueryOperations>
      workoutProgramIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workoutProgramId');
    });
  }
}
