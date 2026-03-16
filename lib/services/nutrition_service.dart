import 'package:isar/isar.dart';
import '../models/nutrition.dart';
import 'database_service.dart';

class NutritionService {
  final DatabaseService _db;

  NutritionService(this._db);

  // ─── Nutrition Goal ────────────────────────────────────────────────────────

  Future<NutritionGoal> getGoal() async {
    final goal = await _db.isar.nutritionGoals.where().findFirst();
    if (goal != null) return goal;

    // Créer un objectif par défaut s'il n'existe pas
    final defaultGoal = NutritionGoal();
    await _db.isar.writeTxn(() async {
      await _db.isar.nutritionGoals.put(defaultGoal);
    });
    return defaultGoal;
  }

  Future<void> updateGoal(NutritionGoal goal) async {
    await _db.isar.writeTxn(() async {
      await _db.isar.nutritionGoals.put(goal);
    });
  }

  // ─── Daily Log ─────────────────────────────────────────────────────────────

  Future<DailyNutritionLog> getLogForDate(DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    
    var log = await _db.isar.dailyNutritionLogs
        .filter()
        .dateEqualTo(normalizedDate)
        .findFirst();

    if (log == null) {
      log = DailyNutritionLog()..date = normalizedDate;
      await _db.isar.writeTxn(() async {
        await _db.isar.dailyNutritionLogs.put(log!);
      });
    } else {
      // Charger les liens Isar
      await log.entries.load();
    }

    return log;
  }

  // ─── Meal Entries ──────────────────────────────────────────────────────────

  Future<void> saveMealEntry(MealEntry entry, int dailyLogId) async {
    await _db.isar.writeTxn(() async {
      entry.dailyLogId = dailyLogId;
      await _db.isar.mealEntrys.put(entry);
      
      final log = await _db.isar.dailyNutritionLogs.get(dailyLogId);
      if (log != null) {
        log.entries.add(entry);
        await log.entries.save();
      }
    });
  }

  Future<void> deleteMealEntry(int id, int dailyLogId) async {
    await _db.isar.writeTxn(() async {
      final log = await _db.isar.dailyNutritionLogs.get(dailyLogId);
      if (log != null) {
        final entry = await _db.isar.mealEntrys.get(id);
        if (entry != null) {
          log.entries.remove(entry);
          await log.entries.save();
          await _db.isar.mealEntrys.delete(id);
        }
      }
    });
  }

  // Calcul des totaux pour une liste de MealEntries
  Map<String, int> calculateTotals(List<MealEntry> entries) {
    int kcal = 0;
    int prot = 0;
    int gluc = 0;
    int lip = 0;

    for (var e in entries) {
      kcal += e.calories;
      prot += e.proteines;
      gluc += e.glucides;
      lip += e.lipides;
    }

    return {
      'calories': kcal,
      'proteines': prot,
      'glucides': gluc,
      'lipides': lip,
    };
  }
}
