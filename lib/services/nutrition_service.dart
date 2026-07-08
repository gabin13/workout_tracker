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
    final targetMidnight = DateTime(date.year, date.month, date.day);
    final windowStart = targetMidnight.subtract(const Duration(hours: 13));
    final windowEnd = targetMidnight.add(const Duration(hours: 13));

    // Récupérer TOUS les logs dans la fenêtre des fuseaux horaires (25h)
    final logsInWindow = await _db.isar.dailyNutritionLogs
        .filter()
        .dateBetween(windowStart, windowEnd)
        .findAll();

    DailyNutritionLog? bestLog;

    if (logsInWindow.isNotEmpty) {
      // Charger les repas pour voir s'il s'agit du "vrai" log contenant les données
      for (var l in logsInWindow) {
        await l.entries.load();
      }
      
      // Trier pour prioriser :
      // 1. Les logs qui contiennent des repas (pour bypasser les doublons vides)
      // 2. Le log qui correspond exactement à la date (si tous sont vides)
      logsInWindow.sort((a, b) {
        if (a.entries.length != b.entries.length) {
          return b.entries.length.compareTo(a.entries.length); // Plus de repas en premier
        }
        final aExact = a.date == targetMidnight ? 1 : 0;
        final bExact = b.date == targetMidnight ? 1 : 0;
        return bExact.compareTo(aExact); 
      });

      bestLog = logsInWindow.first;
    }

    if (bestLog == null) {
      bestLog = DailyNutritionLog()..date = targetMidnight;
      await _db.isar.writeTxn(() async {
        await _db.isar.dailyNutritionLogs.put(bestLog!);
      });
    }

    return bestLog;
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
  Map<String, double> calculateTotals(List<MealEntry> entries) {
    double kcal = 0;
    double prot = 0;
    double gluc = 0;
    double lip = 0;
    double fib = 0;

    for (var e in entries) {
      kcal += e.calories;
      prot += e.proteines;
      gluc += e.glucides;
      lip += e.lipides;
      fib += e.fibres ?? 0.0;
    }

    return {
      'calories': kcal,
      'proteines': prot,
      'glucides': gluc,
      'lipides': lip,
      'fibres': fib,
    };
  }
}
