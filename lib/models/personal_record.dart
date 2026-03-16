import 'package:isar/isar.dart';

part 'personal_record.g.dart';

/// Un record personnel pour un exercice donné.
/// Chaque entrée est indépendante → historique de progression.
@collection
class PersonalRecord {
  Id id = Isar.autoIncrement;

  late int exerciseId;
  late double poidsMax;
  late DateTime date;
}
