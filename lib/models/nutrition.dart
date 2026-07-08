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

  double calories = 2500.0;
  double proteines = 150.0;
  double glucides = 300.0;
  double lipides = 80.0;
  double? fibres = 30.0; // default value for goals
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

  double calories = 0.0;
  double proteines = 0.0;
  double glucides = 0.0;
  double lipides = 0.0;
  double? fibres = 0.0;

  String? notes;
}
