import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/exercise_history.dart';
import 'database_provider.dart';

final exerciseHistoryProvider = FutureProvider.family<List<ExerciseHistory>, int>((ref, exerciseId) async {
  final db = ref.watch(databaseProvider);
  return db.getHistoryForExercise(exerciseId);
});
