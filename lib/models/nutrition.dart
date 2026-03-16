import 'package:isar/isar.dart';

part 'nutrition.g.dart';

enum MealType {
  petitDejeuner,
  dejeuner,
  diner,
  collation,
}

@Collection()
class NutritionGoal {
  Id id = Isar.autoIncrement;

  int calories = 2500;
  int proteines = 150;
  int glucides = 300;
  int lipides = 80;
}

@Collection()
class DailyNutritionLog {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late DateTime date; // Normalisée à minuit

  // On peut utiliser une liste d'IDs ou des IsarLinks
  // Pour rester simple et efficace avec Riverpod :
  final entries = IsarLinks<MealEntry>();
}

@Collection()
class MealEntry {
  Id id = Isar.autoIncrement;

  @Index()
  int? dailyLogId; // Lien manuel ou via IsarLink

  @enumerated
  late MealType mealType;

  int calories = 0;
  int proteines = 0;
  int glucides = 0;
  int lipides = 0;

  String? notes;
}
