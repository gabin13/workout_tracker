import 'package:isar/isar.dart';

part 'exercise_history.g.dart';

/// Stocke les performances d'un exercice pour une séance donnée.
/// [series] est un tableau JSON : [{"poids":80,"reps":10}, ...]
@collection
class ExerciseHistory {
  Id id = Isar.autoIncrement;

  late int exerciseId;
  late DateTime date;

  /// JSON encodé contenant la liste des séries : [{"poids": X, "reps": Y}]
  late String series;
}
