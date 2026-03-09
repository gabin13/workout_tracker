import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/scheduled_workout.dart';
import 'database_provider.dart';

final scheduledWorkoutsProvider = FutureProvider<List<ScheduledWorkout>>((ref) async {
  final db = ref.watch(databaseProvider);
  return await db.isar.scheduledWorkouts.where().findAllAsync();
});
