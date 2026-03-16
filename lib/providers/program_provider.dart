import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout_program.dart';
import 'database_provider.dart';

final workoutProgramsProvider = FutureProvider<List<WorkoutProgram>>((ref) async {
  final db = ref.watch(databaseProvider);
  return db.getAllPrograms();
});
