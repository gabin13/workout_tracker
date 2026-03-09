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
}
