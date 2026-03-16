import 'package:isar/isar.dart';

part 'personal_record.g.dart';

@collection
class PersonalRecord {
  Id id = Isar.autoIncrement;

  late int exerciseId;
  late double poidsMax;
  late DateTime date;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exerciseId': exerciseId,
      'poidsMax': poidsMax,
      'date': date.toIso8601String(),
    };
  }

  static PersonalRecord fromMap(Map<String, dynamic> map) {
    return PersonalRecord()
      ..id = map['id'] ?? Isar.autoIncrement
      ..exerciseId = map['exerciseId']
      ..poidsMax = map['poidsMax']
      ..date = DateTime.parse(map['date']);
  }
}
