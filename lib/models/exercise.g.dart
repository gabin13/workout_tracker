// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetExerciseCollection on Isar {
  IsarCollection<Exercise> get exercises => this.collection();
}

const ExerciseSchema = CollectionSchema(
  name: r'Exercise',
  id: 2972066467915231902,
  properties: {
    r'imagePath': PropertySchema(
      id: 0,
      name: r'imagePath',
      type: IsarType.string,
    ),
    r'instructions': PropertySchema(
      id: 1,
      name: r'instructions',
      type: IsarType.string,
    ),
    r'musclePrincipal': PropertySchema(
      id: 2,
      name: r'musclePrincipal',
      type: IsarType.string,
    ),
    r'musclesSecondaires': PropertySchema(
      id: 3,
      name: r'musclesSecondaires',
      type: IsarType.stringList,
    ),
    r'nom': PropertySchema(
      id: 4,
      name: r'nom',
      type: IsarType.string,
    ),
    r'notesReglagesMachine': PropertySchema(
      id: 5,
      name: r'notesReglagesMachine',
      type: IsarType.string,
    )
  },
  estimateSize: _exerciseEstimateSize,
  serialize: _exerciseSerialize,
  deserialize: _exerciseDeserialize,
  deserializeProp: _exerciseDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _exerciseGetId,
  getLinks: _exerciseGetLinks,
  attach: _exerciseAttach,
  version: '3.1.0+1',
);

int _exerciseEstimateSize(
  Exercise object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.imagePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.instructions;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.musclePrincipal.length * 3;
  bytesCount += 3 + object.musclesSecondaires.length * 3;
  {
    for (var i = 0; i < object.musclesSecondaires.length; i++) {
      final value = object.musclesSecondaires[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.nom.length * 3;
  {
    final value = object.notesReglagesMachine;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _exerciseSerialize(
  Exercise object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.imagePath);
  writer.writeString(offsets[1], object.instructions);
  writer.writeString(offsets[2], object.musclePrincipal);
  writer.writeStringList(offsets[3], object.musclesSecondaires);
  writer.writeString(offsets[4], object.nom);
  writer.writeString(offsets[5], object.notesReglagesMachine);
}

Exercise _exerciseDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Exercise();
  object.id = id;
  object.imagePath = reader.readStringOrNull(offsets[0]);
  object.instructions = reader.readStringOrNull(offsets[1]);
  object.musclePrincipal = reader.readString(offsets[2]);
  object.musclesSecondaires = reader.readStringList(offsets[3]) ?? [];
  object.nom = reader.readString(offsets[4]);
  object.notesReglagesMachine = reader.readStringOrNull(offsets[5]);
  return object;
}

P _exerciseDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _exerciseGetId(Exercise object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _exerciseGetLinks(Exercise object) {
  return [];
}

void _exerciseAttach(IsarCollection<dynamic> col, Id id, Exercise object) {
  object.id = id;
}

extension ExerciseQueryWhereSort on QueryBuilder<Exercise, Exercise, QWhere> {
  QueryBuilder<Exercise, Exercise, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ExerciseQueryWhere on QueryBuilder<Exercise, Exercise, QWhereClause> {
  QueryBuilder<Exercise, Exercise, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Exercise, Exercise, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterWhereClause> idBetween(
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

extension ExerciseQueryFilter
    on QueryBuilder<Exercise, Exercise, QFilterCondition> {
  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> imagePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imagePath',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> imagePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imagePath',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> imagePathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> imagePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> imagePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> imagePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imagePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> imagePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> imagePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> imagePathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> imagePathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imagePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> imagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      imagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> instructionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'instructions',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      instructionsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'instructions',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> instructionsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'instructions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      instructionsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'instructions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> instructionsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'instructions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> instructionsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'instructions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      instructionsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'instructions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> instructionsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'instructions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> instructionsContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'instructions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> instructionsMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'instructions',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      instructionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'instructions',
        value: '',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      instructionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'instructions',
        value: '',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclePrincipalEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'musclePrincipal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclePrincipalGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'musclePrincipal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclePrincipalLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'musclePrincipal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclePrincipalBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'musclePrincipal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclePrincipalStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'musclePrincipal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclePrincipalEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'musclePrincipal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclePrincipalContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'musclePrincipal',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclePrincipalMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'musclePrincipal',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclePrincipalIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'musclePrincipal',
        value: '',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclePrincipalIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'musclePrincipal',
        value: '',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclesSecondairesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'musclesSecondaires',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclesSecondairesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'musclesSecondaires',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclesSecondairesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'musclesSecondaires',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclesSecondairesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'musclesSecondaires',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclesSecondairesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'musclesSecondaires',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclesSecondairesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'musclesSecondaires',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclesSecondairesElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'musclesSecondaires',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclesSecondairesElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'musclesSecondaires',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclesSecondairesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'musclesSecondaires',
        value: '',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclesSecondairesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'musclesSecondaires',
        value: '',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclesSecondairesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'musclesSecondaires',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclesSecondairesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'musclesSecondaires',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclesSecondairesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'musclesSecondaires',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclesSecondairesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'musclesSecondaires',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclesSecondairesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'musclesSecondaires',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      musclesSecondairesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'musclesSecondaires',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> nomEqualTo(
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

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> nomGreaterThan(
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

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> nomLessThan(
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

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> nomBetween(
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

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> nomStartsWith(
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

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> nomEndsWith(
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

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> nomContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> nomMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nom',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> nomIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nom',
        value: '',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition> nomIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nom',
        value: '',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      notesReglagesMachineIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notesReglagesMachine',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      notesReglagesMachineIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notesReglagesMachine',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      notesReglagesMachineEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notesReglagesMachine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      notesReglagesMachineGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notesReglagesMachine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      notesReglagesMachineLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notesReglagesMachine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      notesReglagesMachineBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notesReglagesMachine',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      notesReglagesMachineStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notesReglagesMachine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      notesReglagesMachineEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notesReglagesMachine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      notesReglagesMachineContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notesReglagesMachine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      notesReglagesMachineMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notesReglagesMachine',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      notesReglagesMachineIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notesReglagesMachine',
        value: '',
      ));
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterFilterCondition>
      notesReglagesMachineIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notesReglagesMachine',
        value: '',
      ));
    });
  }
}

extension ExerciseQueryObject
    on QueryBuilder<Exercise, Exercise, QFilterCondition> {}

extension ExerciseQueryLinks
    on QueryBuilder<Exercise, Exercise, QFilterCondition> {}

extension ExerciseQuerySortBy on QueryBuilder<Exercise, Exercise, QSortBy> {
  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByInstructions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'instructions', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByInstructionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'instructions', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByMusclePrincipal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'musclePrincipal', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByMusclePrincipalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'musclePrincipal', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByNom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByNomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> sortByNotesReglagesMachine() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notesReglagesMachine', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy>
      sortByNotesReglagesMachineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notesReglagesMachine', Sort.desc);
    });
  }
}

extension ExerciseQuerySortThenBy
    on QueryBuilder<Exercise, Exercise, QSortThenBy> {
  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByInstructions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'instructions', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByInstructionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'instructions', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByMusclePrincipal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'musclePrincipal', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByMusclePrincipalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'musclePrincipal', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByNom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByNomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nom', Sort.desc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy> thenByNotesReglagesMachine() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notesReglagesMachine', Sort.asc);
    });
  }

  QueryBuilder<Exercise, Exercise, QAfterSortBy>
      thenByNotesReglagesMachineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notesReglagesMachine', Sort.desc);
    });
  }
}

extension ExerciseQueryWhereDistinct
    on QueryBuilder<Exercise, Exercise, QDistinct> {
  QueryBuilder<Exercise, Exercise, QDistinct> distinctByImagePath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Exercise, Exercise, QDistinct> distinctByInstructions(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'instructions', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Exercise, Exercise, QDistinct> distinctByMusclePrincipal(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'musclePrincipal',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Exercise, Exercise, QDistinct> distinctByMusclesSecondaires() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'musclesSecondaires');
    });
  }

  QueryBuilder<Exercise, Exercise, QDistinct> distinctByNom(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nom', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Exercise, Exercise, QDistinct> distinctByNotesReglagesMachine(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notesReglagesMachine',
          caseSensitive: caseSensitive);
    });
  }
}

extension ExerciseQueryProperty
    on QueryBuilder<Exercise, Exercise, QQueryProperty> {
  QueryBuilder<Exercise, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Exercise, String?, QQueryOperations> imagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagePath');
    });
  }

  QueryBuilder<Exercise, String?, QQueryOperations> instructionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'instructions');
    });
  }

  QueryBuilder<Exercise, String, QQueryOperations> musclePrincipalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'musclePrincipal');
    });
  }

  QueryBuilder<Exercise, List<String>, QQueryOperations>
      musclesSecondairesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'musclesSecondaires');
    });
  }

  QueryBuilder<Exercise, String, QQueryOperations> nomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nom');
    });
  }

  QueryBuilder<Exercise, String?, QQueryOperations>
      notesReglagesMachineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notesReglagesMachine');
    });
  }
}
