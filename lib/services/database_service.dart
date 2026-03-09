import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/exercise.dart';
import '../models/workout.dart';
import '../models/workout_set.dart';
import '../models/scheduled_workout.dart';
import '../models/body_measurement.dart';
import '../models/progress_photo.dart';
import '../models/personal_record.dart';

class DatabaseService {
  late Isar isar;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [
        ExerciseSchema, 
        WorkoutSchema, 
        WorkoutSetSchema,
        ScheduledWorkoutSchema,
        BodyMeasurementSchema,
        ProgressPhotoSchema,
        PersonalRecordSchema
      ],
      directory: dir.path,
    );
    _isInitialized = true;
  }

  // --- Exercises ---
  Future<List<Exercise>> getAllExercises() async {
    return await isar.exercises.where().findAll();
  }

  Future<void> saveExercise(Exercise exercise) async {
    await isar.writeTxn(() async {
      await isar.exercises.put(exercise);
    });
  }

  Future<void> deleteExercise(int id) async {
    await isar.writeTxn(() async {
      await isar.exercises.delete(id);
    });
  }

  Future<List<Exercise>> searchExercises(String query) async {
    return await isar.exercises
        .filter()
        .nomContains(query, caseSensitive: false)
        .findAll();
  }

  // --- Workouts ---
  Future<List<Workout>> getAllWorkouts() async {
    return await isar.workouts.where().sortByDateDesc().findAll();
  }

  Future<void> saveWorkout(Workout workout) async {
    await isar.writeTxn(() async {
      await isar.workouts.put(workout);
    });
  }

  Future<void> deleteWorkout(int id) async {
    await isar.writeTxn(() async {
      await isar.workouts.delete(id);
      // Delete associated workout sets
      await isar.workoutSets.filter().workoutIdEqualTo(id).deleteAll();
    });
  }

  // --- Workout Sets ---
  Future<List<WorkoutSet>> getSetsForWorkout(int workoutId) async {
    return await isar.workoutSets
        .filter()
        .workoutIdEqualTo(workoutId)
        .findAll();
  }
  
  Future<List<WorkoutSet>> getSetsForExercise(int exerciseId) async {
    return await isar.workoutSets
        .filter()
        .exerciseIdEqualTo(exerciseId)
        .findAll();
  }

  Future<void> saveWorkoutSet(WorkoutSet set) async {
    await isar.writeTxn(() async {
      await isar.workoutSets.put(set);
    });
  }

  Future<void> deleteWorkoutSet(int id) async {
    await isar.writeTxn(() async {
      await isar.workoutSets.delete(id);
    });
  }
}
