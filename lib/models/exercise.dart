import 'package:isar/isar.dart';

part 'exercise.g.dart';

@collection
class Exercise {
  Id id = Isar.autoIncrement;

  late String nom;
  late String musclePrincipal;
  List<String> musclesSecondaires = [];
  String? instructions;
  String? notesReglagesMachine;
  String? imagePath;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'musclePrincipal': musclePrincipal,
      'musclesSecondaires': musclesSecondaires,
      'instructions': instructions,
      'notesReglagesMachine': notesReglagesMachine,
      'imagePath': imagePath,
    };
  }

  static Exercise fromMap(Map<String, dynamic> map) {
    return Exercise()
      ..id = map['id'] ?? Isar.autoIncrement
      ..nom = map['nom']
      ..musclePrincipal = map['musclePrincipal']
      ..musclesSecondaires = List<String>.from(map['musclesSecondaires'] ?? [])
      ..instructions = map['instructions']
      ..notesReglagesMachine = map['notesReglagesMachine']
      ..imagePath = map['imagePath'];
  }
}
