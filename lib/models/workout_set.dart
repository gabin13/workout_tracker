import 'package:isar/isar.dart';

part 'workout_set.g.dart';

enum SetType { echauffement, normale, echec, dropSet }

@collection
class WorkoutSet {
  Id id = Isar.autoIncrement;

  late int workoutId;
  late int exerciseId;
  
  late double poids;
  late int repetitions;

  @enumerated
  SetType typeSerie = SetType.normale;

  /// Optionnel (1 à 10)
  int? rpe;
}
