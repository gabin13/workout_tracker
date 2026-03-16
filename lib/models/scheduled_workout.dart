import 'package:isar/isar.dart';

part 'scheduled_workout.g.dart';

@collection
class ScheduledWorkout {
  Id id = Isar.autoIncrement;

  late DateTime datePrevue;
  late int workoutProgramId;
  bool isCompleted = false;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'datePrevue': datePrevue.toIso8601String(),
      'workoutProgramId': workoutProgramId,
      'isCompleted': isCompleted,
    };
  }

  static ScheduledWorkout fromMap(Map<String, dynamic> map) {
    return ScheduledWorkout()
      ..id = map['id'] ?? Isar.autoIncrement
      ..datePrevue = DateTime.parse(map['datePrevue'])
      ..workoutProgramId = map['workoutProgramId']
      ..isCompleted = map['isCompleted'] ?? false;
  }
}
