import 'package:isar/isar.dart';

part 'personal_record.g.dart';

enum RecordType { maxWeight, maxReps, estimated1RM }

@collection
class PersonalRecord {
  Id id = Isar.autoIncrement;

  late int exerciseId;

  @enumerated
  late RecordType typeRecord;

  late double valeur;
  late DateTime date;
}
