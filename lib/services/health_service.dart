import 'package:health/health.dart';

class HealthService {
  final Health _health = Health();

  // Types de données demandés
  final List<HealthDataType> types = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.WEIGHT,
    HealthDataType.HEART_RATE,
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
    final midnight = DateTime(now.year, now.month, now.day);

    Map<String, dynamic> data = {
      'steps': 0,
      'calories': 0,
      'weight': 'N/A',
      'heartRate': 'N/A',
    };

    try {
      // 1. Pas (Aujourd'hui)
      int? steps = await _health.getTotalStepsInInterval(midnight, now);
      data['steps'] = steps ?? 0;

      // 2. Calories (Aujourd'hui)
      // Note: Pour les calories, on récupère les points de données
      List<HealthDataPoint> caloriesData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
        startTime: midnight,
        endTime: now,
      );
      double totalCalories = 0;
      for (var p in caloriesData) {
        if (p.value is NumericHealthValue) {
          totalCalories += (p.value as NumericHealthValue).numericValue;
        }
      }
      data['calories'] = totalCalories.toInt();

      // 3. Poids (Dernier)
      List<HealthDataPoint> weightData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.WEIGHT],
        startTime: now.subtract(const Duration(days: 30)),
        endTime: now,
      );
      if (weightData.isNotEmpty) {
        weightData.sort((a, b) => b.dateTo.compareTo(a.dateTo));
        final val = weightData.first.value;
        if (val is NumericHealthValue) {
          data['weight'] = val.numericValue.toStringAsFixed(1);
        }
      }

      // 4. Fréquence Cardiaque (Dernière)
      List<HealthDataPoint> hrData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.HEART_RATE],
        startTime: now.subtract(const Duration(days: 1)),
        endTime: now,
      );
      if (hrData.isNotEmpty) {
        hrData.sort((a, b) => b.dateTo.compareTo(a.dateTo));
        final val = hrData.first.value;
        if (val is NumericHealthValue) {
          data['heartRate'] = val.numericValue.toInt().toString();
        }
      }
    } catch (e) {
      print('Erreur Fetch Health: $e');
    }

    return data;
  }
}
