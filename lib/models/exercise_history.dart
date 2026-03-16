import 'package:isar/isar.dart';

part 'exercise_history.g.dart';

@collection
class ExerciseHistory {
  Id id = Isar.autoIncrement;

  late int exerciseId;
  late DateTime date;
  late String series;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exerciseId': exerciseId,
      'date': date.toIso8601String(),
      'series': series,
    };
  }

  static ExerciseHistory fromMap(Map<String, dynamic> map) {
    return ExerciseHistory()
      ..id = map['id'] ?? Isar.autoIncrement
      ..exerciseId = map['exerciseId']
      ..date = DateTime.parse(map['date'])
      ..series = map['series'];
  }
}
