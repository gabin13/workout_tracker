import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/health_service.dart';

// Provider global pour le service
final healthServiceProvider = Provider((ref) => HealthService());

// FutureProvider pour les données du jour (Pas et Calories)
final todayHealthDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.watch(healthServiceProvider);
  return await service.fetchHealthData();
});
