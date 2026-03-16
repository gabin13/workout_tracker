import 'package:isar/isar.dart';

part 'body_measurement.g.dart';

@collection
class BodyMeasurement {
  Id id = Isar.autoIncrement;

  late DateTime date;
  late double poids;
  double? taille; // en cm
  double? tourBras;
  double? tourTaille;
  double? tourCuisses;
}
