// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_measurement.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBodyMeasurementCollection on Isar {
  IsarCollection<BodyMeasurement> get bodyMeasurements => this.collection();
}

const BodyMeasurementSchema = CollectionSchema(
  name: r'BodyMeasurement',
  id: -9058319788105540477,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'poids': PropertySchema(
      id: 1,
      name: r'poids',
      type: IsarType.double,
    ),
    r'taille': PropertySchema(
      id: 2,
      name: r'taille',
      type: IsarType.double,
    ),
    r'tourBras': PropertySchema(
      id: 3,
      name: r'tourBras',
      type: IsarType.double,
    ),
    r'tourCuisses': PropertySchema(
      id: 4,
      name: r'tourCuisses',
      type: IsarType.double,
    ),
    r'tourTaille': PropertySchema(
      id: 5,
      name: r'tourTaille',
      type: IsarType.double,
    )
  },
  estimateSize: _bodyMeasurementEstimateSize,
  serialize: _bodyMeasurementSerialize,
  deserialize: _bodyMeasurementDeserialize,
  deserializeProp: _bodyMeasurementDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _bodyMeasurementGetId,
  getLinks: _bodyMeasurementGetLinks,
  attach: _bodyMeasurementAttach,
  version: '3.1.0+1',
);

int _bodyMeasurementEstimateSize(
  BodyMeasurement object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _bodyMeasurementSerialize(
  BodyMeasurement object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeDouble(offsets[1], object.poids);
  writer.writeDouble(offsets[2], object.taille);
  writer.writeDouble(offsets[3], object.tourBras);
  writer.writeDouble(offsets[4], object.tourCuisses);
  writer.writeDouble(offsets[5], object.tourTaille);
}

BodyMeasurement _bodyMeasurementDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BodyMeasurement();
  object.date = reader.readDateTime(offsets[0]);
  object.id = id;
  object.poids = reader.readDouble(offsets[1]);
  object.taille = reader.readDoubleOrNull(offsets[2]);
  object.tourBras = reader.readDoubleOrNull(offsets[3]);
  object.tourCuisses = reader.readDoubleOrNull(offsets[4]);
  object.tourTaille = reader.readDoubleOrNull(offsets[5]);
  return object;
}

P _bodyMeasurementDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _bodyMeasurementGetId(BodyMeasurement object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _bodyMeasurementGetLinks(BodyMeasurement object) {
  return [];
}

void _bodyMeasurementAttach(
    IsarCollection<dynamic> col, Id id, BodyMeasurement object) {
  object.id = id;
}

extension BodyMeasurementQueryWhereSort
    on QueryBuilder<BodyMeasurement, BodyMeasurement, QWhere> {
  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BodyMeasurementQueryWhere
    on QueryBuilder<BodyMeasurement, BodyMeasurement, QWhereClause> {
  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterWhereClause>
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

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterWhereClause> idBetween(
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

extension BodyMeasurementQueryFilter
    on QueryBuilder<BodyMeasurement, BodyMeasurement, QFilterCondition> {
  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
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

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
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

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
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

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
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

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
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

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
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

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      poidsEqualTo(
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

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      poidsGreaterThan(
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

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      poidsLessThan(
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

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      poidsBetween(
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

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      tailleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taille',
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      tailleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taille',
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      tailleEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taille',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      tailleGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taille',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      tailleLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taille',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      tailleBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taille',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      tourBrasIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tourBras',
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      tourBrasIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tourBras',
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      tourBrasEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tourBras',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      tourBrasGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tourBras',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      tourBrasLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tourBras',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      tourBrasBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tourBras',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      tourCuissesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tourCuisses',
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      tourCuissesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tourCuisses',
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      tourCuissesEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tourCuisses',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      tourCuissesGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tourCuisses',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      tourCuissesLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tourCuisses',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      tourCuissesBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tourCuisses',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      tourTailleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tourTaille',
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      tourTailleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tourTaille',
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      tourTailleEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tourTaille',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      tourTailleGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tourTaille',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      tourTailleLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tourTaille',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterFilterCondition>
      tourTailleBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tourTaille',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension BodyMeasurementQueryObject
    on QueryBuilder<BodyMeasurement, BodyMeasurement, QFilterCondition> {}

extension BodyMeasurementQueryLinks
    on QueryBuilder<BodyMeasurement, BodyMeasurement, QFilterCondition> {}

extension BodyMeasurementQuerySortBy
    on QueryBuilder<BodyMeasurement, BodyMeasurement, QSortBy> {
  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy> sortByPoids() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poids', Sort.asc);
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy>
      sortByPoidsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poids', Sort.desc);
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy> sortByTaille() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taille', Sort.asc);
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy>
      sortByTailleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taille', Sort.desc);
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy>
      sortByTourBras() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tourBras', Sort.asc);
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy>
      sortByTourBrasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tourBras', Sort.desc);
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy>
      sortByTourCuisses() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tourCuisses', Sort.asc);
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy>
      sortByTourCuissesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tourCuisses', Sort.desc);
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy>
      sortByTourTaille() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tourTaille', Sort.asc);
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy>
      sortByTourTailleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tourTaille', Sort.desc);
    });
  }
}

extension BodyMeasurementQuerySortThenBy
    on QueryBuilder<BodyMeasurement, BodyMeasurement, QSortThenBy> {
  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy> thenByPoids() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poids', Sort.asc);
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy>
      thenByPoidsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poids', Sort.desc);
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy> thenByTaille() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taille', Sort.asc);
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy>
      thenByTailleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taille', Sort.desc);
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy>
      thenByTourBras() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tourBras', Sort.asc);
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy>
      thenByTourBrasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tourBras', Sort.desc);
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy>
      thenByTourCuisses() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tourCuisses', Sort.asc);
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy>
      thenByTourCuissesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tourCuisses', Sort.desc);
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy>
      thenByTourTaille() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tourTaille', Sort.asc);
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QAfterSortBy>
      thenByTourTailleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tourTaille', Sort.desc);
    });
  }
}

extension BodyMeasurementQueryWhereDistinct
    on QueryBuilder<BodyMeasurement, BodyMeasurement, QDistinct> {
  QueryBuilder<BodyMeasurement, BodyMeasurement, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QDistinct> distinctByPoids() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'poids');
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QDistinct> distinctByTaille() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taille');
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QDistinct>
      distinctByTourBras() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tourBras');
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QDistinct>
      distinctByTourCuisses() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tourCuisses');
    });
  }

  QueryBuilder<BodyMeasurement, BodyMeasurement, QDistinct>
      distinctByTourTaille() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tourTaille');
    });
  }
}

extension BodyMeasurementQueryProperty
    on QueryBuilder<BodyMeasurement, BodyMeasurement, QQueryProperty> {
  QueryBuilder<BodyMeasurement, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BodyMeasurement, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<BodyMeasurement, double, QQueryOperations> poidsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'poids');
    });
  }

  QueryBuilder<BodyMeasurement, double?, QQueryOperations> tailleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taille');
    });
  }

  QueryBuilder<BodyMeasurement, double?, QQueryOperations> tourBrasProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tourBras');
    });
  }

  QueryBuilder<BodyMeasurement, double?, QQueryOperations>
      tourCuissesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tourCuisses');
    });
  }

  QueryBuilder<BodyMeasurement, double?, QQueryOperations>
      tourTailleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tourTaille');
    });
  }
}
