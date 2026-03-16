import 'package:isar/isar.dart';

part 'scheduled_workout.g.dart';

/// Une séance planifiée : lie une date à un WorkoutProgram.
@collection
class ScheduledWorkout {
  Id id = Isar.autoIncrement;

  late DateTime datePrevue;

  /// FK vers WorkoutProgram.id
  late int workoutProgramId;

  bool isCompleted = false;
}
