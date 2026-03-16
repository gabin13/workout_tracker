import 'package:health/health.dart';

class HealthService {
  final Health _health = Health();

  // Types de données demandés depuis Apple Santé / Google Health Connect
  final List<HealthDataType> types = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
  ];

  // Permissions (Lecture seule ici selon la demande)
  List<HealthDataAccess> get permissions => types.map((e) => HealthDataAccess.READ).toList();

  Future<bool> requestPermissions() async {
    try {
      return await _health.requestAuthorization(types, permissions: permissions);
    } catch (e) {
      print('Erreur Health Permissions: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchHealthData() async {
    final now = DateTime.now();
    // On veut les données d'aujourd'hui depuis minuit
    final midnight = DateTime(now.year, now.month, now.day);

    try {
      // 1. Pas (Aujourd'hui)
      int? steps = await _health.getTotalStepsInInterval(midnight, now);

      // 2. Calories (Aujourd'hui)
      List<HealthDataPoint> caloriesData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
        startTime: midnight,
        endTime: now,
      );
      double totalCalories = 0;
      for (var p in caloriesData) {
        totalCalories += double.tryParse(p.value.toString()) ?? 0.0;
      }

      return {
        'steps': steps ?? 0,
        'calories': totalCalories.toInt(),
      };
    } catch (e) {
      print('Erreur Fetch Health: $e');
      return {
        'steps': 0,
        'calories': 0,
      };
    }
  }

  // Récupération de l'historique des Pas et Calories pour les graphiques (Ex: 7 derniers jours)
  Future<Map<String, List<Map<String, dynamic>>>> fetchWeeklyHistory() async {
    try {
      final now = DateTime.now();
      final lastWeek = now.subtract(const Duration(days: 6));
      final midnightLastWeek = DateTime(lastWeek.year, lastWeek.month, lastWeek.day);

      List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
        types: types,
        startTime: midnightLastWeek,
        endTime: now,
      );

      // Agréger les données par jour
      Map<String, double> dailySteps = {};
      Map<String, double> dailyCals = {};

      for (var p in data) {
        final dateKey = "${p.dateFrom.year}-${p.dateFrom.month.toString().padLeft(2, '0')}-${p.dateFrom.day.toString().padLeft(2, '0')}";
        final value = double.tryParse(p.value.toString()) ?? 0.0;

        if (p.type == HealthDataType.STEPS) {
          dailySteps[dateKey] = (dailySteps[dateKey] ?? 0) + value;
        } else if (p.type == HealthDataType.ACTIVE_ENERGY_BURNED) {
          dailyCals[dateKey] = (dailyCals[dateKey] ?? 0) + value;
        }
      }

      // Convertir en format facile pour fl_chart
      List<Map<String, dynamic>> stepList = [];
      List<Map<String, dynamic>> calList = [];

      for (int i = 0; i < 7; i++) {
        final date = midnightLastWeek.add(Duration(days: i));
        final dateKey = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
        
        stepList.add({'date': date, 'value': dailySteps[dateKey] ?? 0.0});
        calList.add({'date': date, 'value': dailyCals[dateKey] ?? 0.0});
      }

      return {
        'steps': stepList,
        'calories': calList,
      };
    } catch (e) {
      return {'steps': [], 'calories': []};
    }
  }
}
