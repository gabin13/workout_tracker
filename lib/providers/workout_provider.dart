import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout.dart';
import '../models/workout_set.dart';
import 'database_provider.dart';

// Historique des séances
final workoutHistoryProvider = FutureProvider<List<Workout>>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.getAllWorkouts();
});

// Entraînement en cours
final activeWorkoutProvider = StateProvider<Workout?>((ref) => null);

// Séries de l'entraînement en cours
class ActiveWorkoutSetsNotifier extends StateNotifier<List<WorkoutSet>> {
  ActiveWorkoutSetsNotifier() : super([]);

  // Note: Dans une application réelle on sauvegarde aussi dans Isar
  // en temps réel, ou à la fin de la séance.
  void addSet(WorkoutSet newSet) {
    state = [...state, newSet];
  }

  void removeSet(int index) {
    final newState = [...state];
    newState.removeAt(index);
    state = newState;
  }

  void clear() {
    state = [];
  }
}

final activeWorkoutSetsProvider = StateNotifierProvider<ActiveWorkoutSetsNotifier, List<WorkoutSet>>((ref) {
  return ActiveWorkoutSetsNotifier();
});
