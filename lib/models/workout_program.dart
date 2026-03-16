import 'package:isar/isar.dart';

part 'workout_program.g.dart';

@collection
class WorkoutProgram {
  Id id = Isar.autoIncrement;

  late String nom;
  List<int> exerciceIds = [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'exerciceIds': exerciceIds,
    };
  }

  static WorkoutProgram fromMap(Map<String, dynamic> map) {
    return WorkoutProgram()
      ..id = map['id'] ?? Isar.autoIncrement
      ..nom = map['nom']
      ..exerciceIds = List<int>.from(map['exerciceIds'] ?? []);
  }
}
