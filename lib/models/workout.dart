import 'package:isar/isar.dart';

part 'workout.g.dart';

@collection
class Workout {
  Id id = Isar.autoIncrement;

  late DateTime date;
  late String nom;
  
  /// Durée totale en secondes
  int dureeTotale = 0;
}
