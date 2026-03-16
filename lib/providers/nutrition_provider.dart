import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/nutrition_service.dart';
import '../models/nutrition.dart';
import 'database_provider.dart';

// Provider pour le service
final nutritionServiceProvider = Provider((ref) {
  final db = ref.watch(databaseProvider);
  return NutritionService(db);
});

// Provider pour la date sélectionnée
final selectedNutritionDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

// Provider pour l'objectif nutritionnel
final nutritionGoalProvider = FutureProvider<NutritionGoal>((ref) async {
  final service = ref.watch(nutritionServiceProvider);
  return await service.getGoal();
});

// Provider pour le log du jour sélectionné
final dailyNutritionLogProvider = FutureProvider<DailyNutritionLog>((ref) async {
  final service = ref.watch(nutritionServiceProvider);
  final date = ref.watch(selectedNutritionDateProvider);
  return await service.getLogForDate(date);
});
