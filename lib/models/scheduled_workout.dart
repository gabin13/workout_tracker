import 'package:isar/isar.dart';

part 'scheduled_workout.g.dart';

@collection
class ScheduledWorkout {
  Id id = Isar.autoIncrement;

  late DateTime datePrevue;
  late String programmeNom;
  bool isCompleted = false;
}
