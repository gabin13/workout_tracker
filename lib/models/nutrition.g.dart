// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNutritionGoalCollection on Isar {
  IsarCollection<NutritionGoal> get nutritionGoals => this.collection();
}

const NutritionGoalSchema = CollectionSchema(
  name: r'NutritionGoal',
  id: -6176738821382431484,
  properties: {
    r'calories': PropertySchema(
      id: 0,
      name: r'calories',
      type: IsarType.long,
    ),
    r'glucides': PropertySchema(
      id: 1,
      name: r'glucides',
      type: IsarType.long,
    ),
    r'lipides': PropertySchema(
      id: 2,
      name: r'lipides',
      type: IsarType.long,
    ),
    r'proteines': PropertySchema(
      id: 3,
      name: r'proteines',
      type: IsarType.long,
    )
  },
  estimateSize: _nutritionGoalEstimateSize,
  serialize: _nutritionGoalSerialize,
  deserialize: _nutritionGoalDeserialize,
  deserializeProp: _nutritionGoalDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _nutritionGoalGetId,
  getLinks: _nutritionGoalGetLinks,
  attach: _nutritionGoalAttach,
  version: '3.1.0+1',
);

int _nutritionGoalEstimateSize(
  NutritionGoal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _nutritionGoalSerialize(
  NutritionGoal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.calories);
  writer.writeLong(offsets[1], object.glucides);
  writer.writeLong(offsets[2], object.lipides);
  writer.writeLong(offsets[3], object.proteines);
}

NutritionGoal _nutritionGoalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NutritionGoal();
  object.calories = reader.readLong(offsets[0]);
  object.glucides = reader.readLong(offsets[1]);
  object.id = id;
  object.lipides = reader.readLong(offsets[2]);
  object.proteines = reader.readLong(offsets[3]);
  return object;
}

P _nutritionGoalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _nutritionGoalGetId(NutritionGoal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _nutritionGoalGetLinks(NutritionGoal object) {
  return [];
}

void _nutritionGoalAttach(
    IsarCollection<dynamic> col, Id id, NutritionGoal object) {
  object.id = id;
}

extension NutritionGoalQueryWhereSort
    on QueryBuilder<NutritionGoal, NutritionGoal, QWhere> {
  QueryBuilder<NutritionGoal, NutritionGoal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NutritionGoalQueryWhere
    on QueryBuilder<NutritionGoal, NutritionGoal, QWhereClause> {
  QueryBuilder<NutritionGoal, NutritionGoal, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterWhereClause> idBetween(
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

extension NutritionGoalQueryFilter
    on QueryBuilder<NutritionGoal, NutritionGoal, QFilterCondition> {
  QueryBuilder<NutritionGoal, NutritionGoal, QAfterFilterCondition>
      caloriesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'calories',
        value: value,
      ));
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterFilterCondition>
      caloriesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'calories',
        value: value,
      ));
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterFilterCondition>
      caloriesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'calories',
        value: value,
      ));
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterFilterCondition>
      caloriesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'calories',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterFilterCondition>
      glucidesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'glucides',
        value: value,
      ));
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterFilterCondition>
      glucidesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'glucides',
        value: value,
      ));
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterFilterCondition>
      glucidesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'glucides',
        value: value,
      ));
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterFilterCondition>
      glucidesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'glucides',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterFilterCondition>
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

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterFilterCondition> idBetween(
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

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterFilterCondition>
      lipidesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lipides',
        value: value,
      ));
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterFilterCondition>
      lipidesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lipides',
        value: value,
      ));
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterFilterCondition>
      lipidesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lipides',
        value: value,
      ));
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterFilterCondition>
      lipidesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lipides',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterFilterCondition>
      proteinesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proteines',
        value: value,
      ));
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterFilterCondition>
      proteinesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'proteines',
        value: value,
      ));
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterFilterCondition>
      proteinesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'proteines',
        value: value,
      ));
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterFilterCondition>
      proteinesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'proteines',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension NutritionGoalQueryObject
    on QueryBuilder<NutritionGoal, NutritionGoal, QFilterCondition> {}

extension NutritionGoalQueryLinks
    on QueryBuilder<NutritionGoal, NutritionGoal, QFilterCondition> {}

extension NutritionGoalQuerySortBy
    on QueryBuilder<NutritionGoal, NutritionGoal, QSortBy> {
  QueryBuilder<NutritionGoal, NutritionGoal, QAfterSortBy> sortByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.asc);
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterSortBy>
      sortByCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.desc);
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterSortBy> sortByGlucides() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'glucides', Sort.asc);
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterSortBy>
      sortByGlucidesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'glucides', Sort.desc);
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterSortBy> sortByLipides() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lipides', Sort.asc);
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterSortBy> sortByLipidesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lipides', Sort.desc);
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterSortBy> sortByProteines() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteines', Sort.asc);
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterSortBy>
      sortByProteinesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteines', Sort.desc);
    });
  }
}

extension NutritionGoalQuerySortThenBy
    on QueryBuilder<NutritionGoal, NutritionGoal, QSortThenBy> {
  QueryBuilder<NutritionGoal, NutritionGoal, QAfterSortBy> thenByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.asc);
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterSortBy>
      thenByCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.desc);
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterSortBy> thenByGlucides() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'glucides', Sort.asc);
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterSortBy>
      thenByGlucidesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'glucides', Sort.desc);
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterSortBy> thenByLipides() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lipides', Sort.asc);
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterSortBy> thenByLipidesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lipides', Sort.desc);
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterSortBy> thenByProteines() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteines', Sort.asc);
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QAfterSortBy>
      thenByProteinesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteines', Sort.desc);
    });
  }
}

extension NutritionGoalQueryWhereDistinct
    on QueryBuilder<NutritionGoal, NutritionGoal, QDistinct> {
  QueryBuilder<NutritionGoal, NutritionGoal, QDistinct> distinctByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'calories');
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QDistinct> distinctByGlucides() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'glucides');
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QDistinct> distinctByLipides() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lipides');
    });
  }

  QueryBuilder<NutritionGoal, NutritionGoal, QDistinct> distinctByProteines() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'proteines');
    });
  }
}

extension NutritionGoalQueryProperty
    on QueryBuilder<NutritionGoal, NutritionGoal, QQueryProperty> {
  QueryBuilder<NutritionGoal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NutritionGoal, int, QQueryOperations> caloriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'calories');
    });
  }

  QueryBuilder<NutritionGoal, int, QQueryOperations> glucidesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'glucides');
    });
  }

  QueryBuilder<NutritionGoal, int, QQueryOperations> lipidesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lipides');
    });
  }

  QueryBuilder<NutritionGoal, int, QQueryOperations> proteinesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proteines');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailyNutritionLogCollection on Isar {
  IsarCollection<DailyNutritionLog> get dailyNutritionLogs => this.collection();
}

const DailyNutritionLogSchema = CollectionSchema(
  name: r'DailyNutritionLog',
  id: -3170317180864171937,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _dailyNutritionLogEstimateSize,
  serialize: _dailyNutritionLogSerialize,
  deserialize: _dailyNutritionLogDeserialize,
  deserializeProp: _dailyNutritionLogDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'entries': LinkSchema(
      id: -5556842721210133306,
      name: r'entries',
      target: r'MealEntry',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _dailyNutritionLogGetId,
  getLinks: _dailyNutritionLogGetLinks,
  attach: _dailyNutritionLogAttach,
  version: '3.1.0+1',
);

int _dailyNutritionLogEstimateSize(
  DailyNutritionLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _dailyNutritionLogSerialize(
  DailyNutritionLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
}

DailyNutritionLog _dailyNutritionLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyNutritionLog();
  object.date = reader.readDateTime(offsets[0]);
  object.id = id;
  return object;
}

P _dailyNutritionLogDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dailyNutritionLogGetId(DailyNutritionLog object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailyNutritionLogGetLinks(
    DailyNutritionLog object) {
  return [object.entries];
}

void _dailyNutritionLogAttach(
    IsarCollection<dynamic> col, Id id, DailyNutritionLog object) {
  object.id = id;
  object.entries.attach(col, col.isar.collection<MealEntry>(), r'entries', id);
}

extension DailyNutritionLogByIndex on IsarCollection<DailyNutritionLog> {
  Future<DailyNutritionLog?> getByDate(DateTime date) {
    return getByIndex(r'date', [date]);
  }

  DailyNutritionLog? getByDateSync(DateTime date) {
    return getByIndexSync(r'date', [date]);
  }

  Future<bool> deleteByDate(DateTime date) {
    return deleteByIndex(r'date', [date]);
  }

  bool deleteByDateSync(DateTime date) {
    return deleteByIndexSync(r'date', [date]);
  }

  Future<List<DailyNutritionLog?>> getAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndex(r'date', values);
  }

  List<DailyNutritionLog?> getAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'date', values);
  }

  Future<int> deleteAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'date', values);
  }

  int deleteAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'date', values);
  }

  Future<Id> putByDate(DailyNutritionLog object) {
    return putByIndex(r'date', object);
  }

  Id putByDateSync(DailyNutritionLog object, {bool saveLinks = true}) {
    return putByIndexSync(r'date', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDate(List<DailyNutritionLog> objects) {
    return putAllByIndex(r'date', objects);
  }

  List<Id> putAllByDateSync(List<DailyNutritionLog> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'date', objects, saveLinks: saveLinks);
  }
}

extension DailyNutritionLogQueryWhereSort
    on QueryBuilder<DailyNutritionLog, DailyNutritionLog, QWhere> {
  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension DailyNutritionLogQueryWhere
    on QueryBuilder<DailyNutritionLog, DailyNutritionLog, QWhereClause> {
  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterWhereClause>
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

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterWhereClause>
      dateEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterWhereClause>
      dateNotEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterWhereClause>
      dateGreaterThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [date],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterWhereClause>
      dateLessThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [],
        upper: [date],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterWhereClause>
      dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [lowerDate],
        includeLower: includeLower,
        upper: [upperDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DailyNutritionLogQueryFilter
    on QueryBuilder<DailyNutritionLog, DailyNutritionLog, QFilterCondition> {
  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterFilterCondition>
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

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterFilterCondition>
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

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterFilterCondition>
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

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterFilterCondition>
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

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterFilterCondition>
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

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterFilterCondition>
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
}

extension DailyNutritionLogQueryObject
    on QueryBuilder<DailyNutritionLog, DailyNutritionLog, QFilterCondition> {}

extension DailyNutritionLogQueryLinks
    on QueryBuilder<DailyNutritionLog, DailyNutritionLog, QFilterCondition> {
  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterFilterCondition>
      entries(FilterQuery<MealEntry> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'entries');
    });
  }

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterFilterCondition>
      entriesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'entries', length, true, length, true);
    });
  }

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterFilterCondition>
      entriesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'entries', 0, true, 0, true);
    });
  }

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterFilterCondition>
      entriesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'entries', 0, false, 999999, true);
    });
  }

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterFilterCondition>
      entriesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'entries', 0, true, length, include);
    });
  }

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterFilterCondition>
      entriesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'entries', length, include, 999999, true);
    });
  }

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterFilterCondition>
      entriesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'entries', lower, includeLower, upper, includeUpper);
    });
  }
}

extension DailyNutritionLogQuerySortBy
    on QueryBuilder<DailyNutritionLog, DailyNutritionLog, QSortBy> {
  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterSortBy>
      sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }
}

extension DailyNutritionLogQuerySortThenBy
    on QueryBuilder<DailyNutritionLog, DailyNutritionLog, QSortThenBy> {
  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterSortBy>
      thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension DailyNutritionLogQueryWhereDistinct
    on QueryBuilder<DailyNutritionLog, DailyNutritionLog, QDistinct> {
  QueryBuilder<DailyNutritionLog, DailyNutritionLog, QDistinct>
      distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }
}

extension DailyNutritionLogQueryProperty
    on QueryBuilder<DailyNutritionLog, DailyNutritionLog, QQueryProperty> {
  QueryBuilder<DailyNutritionLog, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailyNutritionLog, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMealEntryCollection on Isar {
  IsarCollection<MealEntry> get mealEntrys => this.collection();
}

const MealEntrySchema = CollectionSchema(
  name: r'MealEntry',
  id: 2136597722614945685,
  properties: {
    r'calories': PropertySchema(
      id: 0,
      name: r'calories',
      type: IsarType.long,
    ),
    r'dailyLogId': PropertySchema(
      id: 1,
      name: r'dailyLogId',
      type: IsarType.long,
    ),
    r'glucides': PropertySchema(
      id: 2,
      name: r'glucides',
      type: IsarType.long,
    ),
    r'lipides': PropertySchema(
      id: 3,
      name: r'lipides',
      type: IsarType.long,
    ),
    r'mealType': PropertySchema(
      id: 4,
      name: r'mealType',
      type: IsarType.byte,
      enumMap: _MealEntrymealTypeEnumValueMap,
    ),
    r'notes': PropertySchema(
      id: 5,
      name: r'notes',
      type: IsarType.string,
    ),
    r'proteines': PropertySchema(
      id: 6,
      name: r'proteines',
      type: IsarType.long,
    )
  },
  estimateSize: _mealEntryEstimateSize,
  serialize: _mealEntrySerialize,
  deserialize: _mealEntryDeserialize,
  deserializeProp: _mealEntryDeserializeProp,
  idName: r'id',
  indexes: {
    r'dailyLogId': IndexSchema(
      id: -1085835977395352951,
      name: r'dailyLogId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dailyLogId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _mealEntryGetId,
  getLinks: _mealEntryGetLinks,
  attach: _mealEntryAttach,
  version: '3.1.0+1',
);

int _mealEntryEstimateSize(
  MealEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _mealEntrySerialize(
  MealEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.calories);
  writer.writeLong(offsets[1], object.dailyLogId);
  writer.writeLong(offsets[2], object.glucides);
  writer.writeLong(offsets[3], object.lipides);
  writer.writeByte(offsets[4], object.mealType.index);
  writer.writeString(offsets[5], object.notes);
  writer.writeLong(offsets[6], object.proteines);
}

MealEntry _mealEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MealEntry();
  object.calories = reader.readLong(offsets[0]);
  object.dailyLogId = reader.readLongOrNull(offsets[1]);
  object.glucides = reader.readLong(offsets[2]);
  object.id = id;
  object.lipides = reader.readLong(offsets[3]);
  object.mealType =
      _MealEntrymealTypeValueEnumMap[reader.readByteOrNull(offsets[4])] ??
          MealType.petitDejeuner;
  object.notes = reader.readStringOrNull(offsets[5]);
  object.proteines = reader.readLong(offsets[6]);
  return object;
}

P _mealEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (_MealEntrymealTypeValueEnumMap[reader.readByteOrNull(offset)] ??
          MealType.petitDejeuner) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _MealEntrymealTypeEnumValueMap = {
  'petitDejeuner': 0,
  'dejeuner': 1,
  'diner': 2,
  'collation': 3,
};
const _MealEntrymealTypeValueEnumMap = {
  0: MealType.petitDejeuner,
  1: MealType.dejeuner,
  2: MealType.diner,
  3: MealType.collation,
};

Id _mealEntryGetId(MealEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _mealEntryGetLinks(MealEntry object) {
  return [];
}

void _mealEntryAttach(IsarCollection<dynamic> col, Id id, MealEntry object) {
  object.id = id;
}

extension MealEntryQueryWhereSort
    on QueryBuilder<MealEntry, MealEntry, QWhere> {
  QueryBuilder<MealEntry, MealEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterWhere> anyDailyLogId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dailyLogId'),
      );
    });
  }
}

extension MealEntryQueryWhere
    on QueryBuilder<MealEntry, MealEntry, QWhereClause> {
  QueryBuilder<MealEntry, MealEntry, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<MealEntry, MealEntry, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterWhereClause> idBetween(
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

  QueryBuilder<MealEntry, MealEntry, QAfterWhereClause> dailyLogIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dailyLogId',
        value: [null],
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterWhereClause> dailyLogIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dailyLogId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterWhereClause> dailyLogIdEqualTo(
      int? dailyLogId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dailyLogId',
        value: [dailyLogId],
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterWhereClause> dailyLogIdNotEqualTo(
      int? dailyLogId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dailyLogId',
              lower: [],
              upper: [dailyLogId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dailyLogId',
              lower: [dailyLogId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dailyLogId',
              lower: [dailyLogId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dailyLogId',
              lower: [],
              upper: [dailyLogId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterWhereClause> dailyLogIdGreaterThan(
    int? dailyLogId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dailyLogId',
        lower: [dailyLogId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterWhereClause> dailyLogIdLessThan(
    int? dailyLogId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dailyLogId',
        lower: [],
        upper: [dailyLogId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterWhereClause> dailyLogIdBetween(
    int? lowerDailyLogId,
    int? upperDailyLogId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'dailyLogId',
        lower: [lowerDailyLogId],
        includeLower: includeLower,
        upper: [upperDailyLogId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MealEntryQueryFilter
    on QueryBuilder<MealEntry, MealEntry, QFilterCondition> {
  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> caloriesEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'calories',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> caloriesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'calories',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> caloriesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'calories',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> caloriesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'calories',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> dailyLogIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dailyLogId',
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition>
      dailyLogIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dailyLogId',
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> dailyLogIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyLogId',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition>
      dailyLogIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailyLogId',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> dailyLogIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailyLogId',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> dailyLogIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailyLogId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> glucidesEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'glucides',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> glucidesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'glucides',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> glucidesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'glucides',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> glucidesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'glucides',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> idBetween(
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

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> lipidesEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lipides',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> lipidesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lipides',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> lipidesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lipides',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> lipidesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lipides',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> mealTypeEqualTo(
      MealType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mealType',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> mealTypeGreaterThan(
    MealType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mealType',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> mealTypeLessThan(
    MealType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mealType',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> mealTypeBetween(
    MealType lower,
    MealType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mealType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> notesContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> notesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> proteinesEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proteines',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition>
      proteinesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'proteines',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> proteinesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'proteines',
        value: value,
      ));
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterFilterCondition> proteinesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'proteines',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MealEntryQueryObject
    on QueryBuilder<MealEntry, MealEntry, QFilterCondition> {}

extension MealEntryQueryLinks
    on QueryBuilder<MealEntry, MealEntry, QFilterCondition> {}

extension MealEntryQuerySortBy on QueryBuilder<MealEntry, MealEntry, QSortBy> {
  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> sortByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.asc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> sortByCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.desc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> sortByDailyLogId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyLogId', Sort.asc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> sortByDailyLogIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyLogId', Sort.desc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> sortByGlucides() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'glucides', Sort.asc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> sortByGlucidesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'glucides', Sort.desc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> sortByLipides() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lipides', Sort.asc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> sortByLipidesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lipides', Sort.desc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> sortByMealType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealType', Sort.asc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> sortByMealTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealType', Sort.desc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> sortByProteines() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteines', Sort.asc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> sortByProteinesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteines', Sort.desc);
    });
  }
}

extension MealEntryQuerySortThenBy
    on QueryBuilder<MealEntry, MealEntry, QSortThenBy> {
  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> thenByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.asc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> thenByCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.desc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> thenByDailyLogId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyLogId', Sort.asc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> thenByDailyLogIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyLogId', Sort.desc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> thenByGlucides() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'glucides', Sort.asc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> thenByGlucidesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'glucides', Sort.desc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> thenByLipides() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lipides', Sort.asc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> thenByLipidesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lipides', Sort.desc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> thenByMealType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealType', Sort.asc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> thenByMealTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealType', Sort.desc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> thenByProteines() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteines', Sort.asc);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QAfterSortBy> thenByProteinesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteines', Sort.desc);
    });
  }
}

extension MealEntryQueryWhereDistinct
    on QueryBuilder<MealEntry, MealEntry, QDistinct> {
  QueryBuilder<MealEntry, MealEntry, QDistinct> distinctByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'calories');
    });
  }

  QueryBuilder<MealEntry, MealEntry, QDistinct> distinctByDailyLogId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyLogId');
    });
  }

  QueryBuilder<MealEntry, MealEntry, QDistinct> distinctByGlucides() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'glucides');
    });
  }

  QueryBuilder<MealEntry, MealEntry, QDistinct> distinctByLipides() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lipides');
    });
  }

  QueryBuilder<MealEntry, MealEntry, QDistinct> distinctByMealType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mealType');
    });
  }

  QueryBuilder<MealEntry, MealEntry, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealEntry, MealEntry, QDistinct> distinctByProteines() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'proteines');
    });
  }
}

extension MealEntryQueryProperty
    on QueryBuilder<MealEntry, MealEntry, QQueryProperty> {
  QueryBuilder<MealEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MealEntry, int, QQueryOperations> caloriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'calories');
    });
  }

  QueryBuilder<MealEntry, int?, QQueryOperations> dailyLogIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyLogId');
    });
  }

  QueryBuilder<MealEntry, int, QQueryOperations> glucidesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'glucides');
    });
  }

  QueryBuilder<MealEntry, int, QQueryOperations> lipidesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lipides');
    });
  }

  QueryBuilder<MealEntry, MealType, QQueryOperations> mealTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mealType');
    });
  }

  QueryBuilder<MealEntry, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<MealEntry, int, QQueryOperations> proteinesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proteines');
    });
  }
}
