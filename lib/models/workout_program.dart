import 'package:isar/isar.dart';

part 'workout_program.g.dart';

@embedded
class ProgramExercise {
  late int exerciseId;
  int? targetSets;
  String? targetReps; // String pour gérer des plages comme "8-10"
  int orderIndex = 0; // Nouvel index pour le tri persistant

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
      'targetSets': targetSets,
      'targetReps': targetReps,
      'orderIndex': orderIndex,
    };
  }

  static ProgramExercise fromMap(Map<String, dynamic> map) {
    return ProgramExercise()
      ..exerciseId = map['exerciseId']
      ..targetSets = map['targetSets']
      ..targetReps = map['targetReps']
      ..orderIndex = map['orderIndex'] ?? 0;
  }
}

@collection
class WorkoutProgram {
  Id id = Isar.autoIncrement;

  late String nom;
  List<ProgramExercise> exercises = [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'exercises': exercises.map((e) => e.toMap()).toList(),
    };
  }

  static WorkoutProgram fromMap(Map<String, dynamic> map) {
    final program = WorkoutProgram()
      ..id = map['id'] ?? Isar.autoIncrement
      ..nom = map['nom'];
    
    if (map.containsKey('exercises')) {
      program.exercises = (map['exercises'] as List)
          .map((e) => ProgramExercise.fromMap(e))
          .toList();
    } else if (map.containsKey('exerciceIds')) {
      // Migration legacy : convertit List<int> en List<ProgramExercise>
      program.exercises = (map['exerciceIds'] as List)
          .map((id) => ProgramExercise()..exerciseId = id)
          .toList();
    }
    
    return program;
  }
}
