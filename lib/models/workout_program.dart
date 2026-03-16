import 'package:isar/isar.dart';

part 'workout_program.g.dart';

@collection
class WorkoutProgram {
  Id id = Isar.autoIncrement;

  late String nom;
  List<int> exerciceIds = [];
}
