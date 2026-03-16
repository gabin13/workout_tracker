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
    r'exercises': PropertySchema(
      id: 0,
      name: r'exercises',
      type: IsarType.objectList,
      target: r'ProgramExercise',
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
  embeddedSchemas: {r'ProgramExercise': ProgramExerciseSchema},
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
  bytesCount += 3 + object.exercises.length * 3;
  {
    final offsets = allOffsets[ProgramExercise]!;
    for (var i = 0; i < object.exercises.length; i++) {
      final value = object.exercises[i];
      bytesCount +=
          ProgramExerciseSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.nom.length * 3;
  return bytesCount;
}

void _workoutProgramSerialize(
  WorkoutProgram object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<ProgramExercise>(
    offsets[0],
    allOffsets,
    ProgramExerciseSchema.serialize,
    object.exercises,
  );
  writer.writeString(offsets[1], object.nom);
}

WorkoutProgram _workoutProgramDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WorkoutProgram();
  object.exercises = reader.readObjectList<ProgramExercise>(
        offsets[0],
        ProgramExerciseSchema.deserialize,
        allOffsets,
        ProgramExercise(),
      ) ??
      [];
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
      return (reader.readObjectList<ProgramExercise>(
            offset,
            ProgramExerciseSchema.deserialize,
            allOffsets,
            ProgramExercise(),
          ) ??
          []) as P;
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
      exercisesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercises',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      exercisesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercises',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      exercisesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercises',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      exercisesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercises',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      exercisesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercises',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      exercisesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'exercises',
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
    on QueryBuilder<WorkoutProgram, WorkoutProgram, QFilterCondition> {
  QueryBuilder<WorkoutProgram, WorkoutProgram, QAfterFilterCondition>
      exercisesElement(FilterQuery<ProgramExercise> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'exercises');
    });
  }
}

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

  QueryBuilder<WorkoutProgram, List<ProgramExercise>, QQueryOperations>
      exercisesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exercises');
    });
  }

  QueryBuilder<WorkoutProgram, String, QQueryOperations> nomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nom');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ProgramExerciseSchema = Schema(
  name: r'ProgramExercise',
  id: 6402339891812254407,
  properties: {
    r'exerciseId': PropertySchema(
      id: 0,
      name: r'exerciseId',
      type: IsarType.long,
    ),
    r'targetReps': PropertySchema(
      id: 1,
      name: r'targetReps',
      type: IsarType.string,
    ),
    r'targetSets': PropertySchema(
      id: 2,
      name: r'targetSets',
      type: IsarType.long,
    )
  },
  estimateSize: _programExerciseEstimateSize,
  serialize: _programExerciseSerialize,
  deserialize: _programExerciseDeserialize,
  deserializeProp: _programExerciseDeserializeProp,
);

int _programExerciseEstimateSize(
  ProgramExercise object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.targetReps;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _programExerciseSerialize(
  ProgramExercise object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.exerciseId);
  writer.writeString(offsets[1], object.targetReps);
  writer.writeLong(offsets[2], object.targetSets);
}

ProgramExercise _programExerciseDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProgramExercise();
  object.exerciseId = reader.readLong(offsets[0]);
  object.targetReps = reader.readStringOrNull(offsets[1]);
  object.targetSets = reader.readLongOrNull(offsets[2]);
  return object;
}

P _programExerciseDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ProgramExerciseQueryFilter
    on QueryBuilder<ProgramExercise, ProgramExercise, QFilterCondition> {
  QueryBuilder<ProgramExercise, ProgramExercise, QAfterFilterCondition>
      exerciseIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseId',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgramExercise, ProgramExercise, QAfterFilterCondition>
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

  QueryBuilder<ProgramExercise, ProgramExercise, QAfterFilterCondition>
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

  QueryBuilder<ProgramExercise, ProgramExercise, QAfterFilterCondition>
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

  QueryBuilder<ProgramExercise, ProgramExercise, QAfterFilterCondition>
      targetRepsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'targetReps',
      ));
    });
  }

  QueryBuilder<ProgramExercise, ProgramExercise, QAfterFilterCondition>
      targetRepsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'targetReps',
      ));
    });
  }

  QueryBuilder<ProgramExercise, ProgramExercise, QAfterFilterCondition>
      targetRepsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetReps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProgramExercise, ProgramExercise, QAfterFilterCondition>
      targetRepsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetReps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProgramExercise, ProgramExercise, QAfterFilterCondition>
      targetRepsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetReps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProgramExercise, ProgramExercise, QAfterFilterCondition>
      targetRepsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetReps',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProgramExercise, ProgramExercise, QAfterFilterCondition>
      targetRepsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'targetReps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProgramExercise, ProgramExercise, QAfterFilterCondition>
      targetRepsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'targetReps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProgramExercise, ProgramExercise, QAfterFilterCondition>
      targetRepsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'targetReps',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProgramExercise, ProgramExercise, QAfterFilterCondition>
      targetRepsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'targetReps',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProgramExercise, ProgramExercise, QAfterFilterCondition>
      targetRepsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetReps',
        value: '',
      ));
    });
  }

  QueryBuilder<ProgramExercise, ProgramExercise, QAfterFilterCondition>
      targetRepsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'targetReps',
        value: '',
      ));
    });
  }

  QueryBuilder<ProgramExercise, ProgramExercise, QAfterFilterCondition>
      targetSetsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'targetSets',
      ));
    });
  }

  QueryBuilder<ProgramExercise, ProgramExercise, QAfterFilterCondition>
      targetSetsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'targetSets',
      ));
    });
  }

  QueryBuilder<ProgramExercise, ProgramExercise, QAfterFilterCondition>
      targetSetsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetSets',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgramExercise, ProgramExercise, QAfterFilterCondition>
      targetSetsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetSets',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgramExercise, ProgramExercise, QAfterFilterCondition>
      targetSetsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetSets',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgramExercise, ProgramExercise, QAfterFilterCondition>
      targetSetsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetSets',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ProgramExerciseQueryObject
    on QueryBuilder<ProgramExercise, ProgramExercise, QFilterCondition> {}
