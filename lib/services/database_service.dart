import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/exercise.dart';
import '../models/workout.dart';
import '../models/workout_set.dart';
import '../models/scheduled_workout.dart';
import '../models/workout_program.dart';
import '../models/exercise_history.dart';
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
        WorkoutProgramSchema,
        ExerciseHistorySchema,
        PersonalRecordSchema,
      ],
      directory: dir.path,
    );
    _isInitialized = true;
  }

  // ─── Exercises ─────────────────────────────────────────────────────────────

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

  // ─── WorkoutProgram ────────────────────────────────────────────────────────

  Future<List<WorkoutProgram>> getAllPrograms() async {
    return await isar.workoutPrograms.where().findAll();
  }

  Future<void> saveProgram(WorkoutProgram program) async {
    await isar.writeTxn(() async {
      await isar.workoutPrograms.put(program);
    });
  }

  Future<void> deleteProgram(int id) async {
    await isar.writeTxn(() async {
      await isar.workoutPrograms.delete(id);
    });
  }

  // ─── ScheduledWorkout ──────────────────────────────────────────────────────

  Future<List<ScheduledWorkout>> getAllScheduledSessions() async {
    return await isar.scheduledWorkouts.where().findAll();
  }

  Future<void> saveScheduledSession(ScheduledWorkout session) async {
    await isar.writeTxn(() async {
      await isar.scheduledWorkouts.put(session);
    });
  }

  Future<void> deleteScheduledSession(int id) async {
    await isar.writeTxn(() async {
      await isar.scheduledWorkouts.delete(id);
    });
  }

  // ─── ExerciseHistory ───────────────────────────────────────────────────────

  Future<List<ExerciseHistory>> getHistoryForExercise(int exerciseId) async {
    return await isar.exerciseHistorys
        .filter()
        .exerciseIdEqualTo(exerciseId)
        .sortByDateDesc()
        .findAll();
  }

  Future<void> saveHistory(ExerciseHistory history) async {
    await isar.writeTxn(() async {
      await isar.exerciseHistorys.put(history);
    });
  }

  // ─── PersonalRecord ────────────────────────────────────────────────────────

  Future<List<PersonalRecord>> getRecordsForExercise(int exerciseId) async {
    return await isar.personalRecords
        .filter()
        .exerciseIdEqualTo(exerciseId)
        .sortByDateDesc()
        .findAll();
  }

  Future<void> saveRecord(PersonalRecord record) async {
    await isar.writeTxn(() async {
      await isar.personalRecords.put(record);
    });
  }

  Future<void> deleteRecord(int id) async {
    await isar.writeTxn(() async {
      await isar.personalRecords.delete(id);
    });
  }

  // ─── Workouts (legacy — kept for DB compatibility) ────────────────────────

  Future<List<Workout>> getAllWorkouts() async {
    return await isar.workouts.where().sortByDateDesc().findAll();
  }

  // ─── Danger Zone ──────────────────────────────────────────────────────────

  Future<void> clearAll() async {
    await isar.writeTxn(() async {
      await isar.exercises.clear();
      await isar.workoutPrograms.clear();
      await isar.scheduledWorkouts.clear();
      await isar.exerciseHistorys.clear();
      await isar.personalRecords.clear();
      // On garde les tables legacy au cas où
      await isar.workouts.clear();
    });
  }
}
