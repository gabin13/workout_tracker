import 'dart:io';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/exercise.dart';
import '../models/workout_program.dart';
import '../models/scheduled_workout.dart';
import '../models/exercise_history.dart';
import '../models/personal_record.dart';
import '../models/nutrition.dart';
import '../models/body_measurement.dart';

import '../models/workout.dart';
import '../models/workout_set.dart';

class DatabaseService {
  late Isar isar;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    final dir = await getApplicationDocumentsDirectory();
    try {
      isar = await Isar.open(
        [
          ExerciseSchema,
          WorkoutSchema,
          WorkoutSetSchema,
          ScheduledWorkoutSchema,
          WorkoutProgramSchema,
          ExerciseHistorySchema,
          PersonalRecordSchema,
          NutritionGoalSchema,
          DailyNutritionLogSchema,
          MealEntrySchema,
          BodyMeasurementSchema,
        ],
        directory: dir.path,
      );
    } catch (e) {
      print('Erreur d\'ouverture Isar, suppression de la base: $e');
      // En cas d'incompatibilité de schéma (ex: int -> double), on supprime la base
      final isarFile = File('${dir.path}/default.isar');
      final lockFile = File('${dir.path}/default.isar.lock');
      if (await isarFile.exists()) await isarFile.delete();
      if (await lockFile.exists()) await lockFile.delete();
      
      // On retente l'ouverture
      isar = await Isar.open(
        [
          ExerciseSchema,
          WorkoutSchema,
          WorkoutSetSchema,
          ScheduledWorkoutSchema,
          WorkoutProgramSchema,
          ExerciseHistorySchema,
          PersonalRecordSchema,
          NutritionGoalSchema,
          DailyNutritionLogSchema,
          MealEntrySchema,
          BodyMeasurementSchema,
        ],
        directory: dir.path,
      );
    }
    _isInitialized = true;
    await _autoMapImages();
  }

  Future<void> _autoMapImages() async {
    final exercises = await isar.exercises.where().findAll();
    final Map<String, String> mappings = {
      'développé couché': 'bench-press.gif',
      'bench press': 'bench-press.gif',
      'incliné': 'developpe-incline.gif',
      'mollet': 'calf-raise.gif',
      'calf': 'calf-raise.gif',
      'tirage serré': 'close-grip-row.gif',
      'close grip': 'close-grip-row.gif',
      'latérale': 'lateral-raise.gif',
      'latérales': 'lateral-raise.gif',
      'lateral raise': 'lateral-raise.gif',
      'hack': 'hack-squat.gif',
      'marteau': 'hammer-curl.gif',
      'hammer': 'hammer-curl.gif',
      'adducteur': 'hip-adductor.gif',
      'thrust': 'hip-thrust.gif',
      'poitrine': 'lat-pulldown.gif',
      'vertical': 'lat-pulldown.gif',
      'leg curl': 'leg-curl.gif',
      'leg extension': 'leg-extension.gif',
      'presse': 'leg-press.gif',
      'leg press': 'leg-press.gif',
      'dips': 'dips-machine.gif',
      'pec fly': 'pec-fly.gif',
      'écarté': 'pec-fly.gif',
      'preacher': 'preacher-curl.gif',
      'pupitre': 'preacher-curl.gif',
      'crunch': 'crunch-machine.gif',
      'décliné': 'decline-crunch.gif',
      'militaire': 'shoulder-press.gif',
      'shoulder': 'shoulder-press.gif',
      'triceps': 'triceps-pushdown.gif',
      'horizontal': 'upper-back-row.gif',
      'upper back': 'upper-back-row.gif',
      'dos': 'upper-back-row.gif',
      'extension': 'back-extension.gif',
      'lombaire': 'back-extension.gif',
    };

    await isar.writeTxn(() async {
      for (final ex in exercises) {
        // Remap if empty, or if it points to an old webp/jpg image that was replaced
        if (ex.imagePath == null || ex.imagePath!.isEmpty || !ex.imagePath!.endsWith('.gif')) {
          final nom = ex.nom.toLowerCase();
          String? matchName;
          
          for (final key in mappings.keys) {
            if (nom.contains(key)) {
              matchName = mappings[key];
              break;
            }
          }
          
          if (matchName != null) {
            ex.imagePath = 'assets/exercises/$matchName';
            await isar.exercises.put(ex);
          }
        }
      }
    });
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
      // 1. Supprimer l'exercice lui-même
      await isar.exercises.delete(id);
      
      // 2. Supprimer tout son historique et Records personnels
      await isar.exerciseHistorys.filter().exerciseIdEqualTo(id).deleteAll();
      await isar.personalRecords.filter().exerciseIdEqualTo(id).deleteAll();
      
      // 3. Le retirer de tous les programmes qui l'utilisent
      final programs = await isar.workoutPrograms.where().findAll();
      for (var p in programs) {
        final initialLength = p.exercises.length;
        
        // On crée une NOUVELLE liste pour éviter UnsupportedError (si la liste Isar est en lecture seule)
        // et on utilise un map complet pour contourner le bug Isar de dirty-tracking
        final newExercises = p.exercises
            .where((e) => e.exerciseId != id)
            .map((e) => ProgramExercise.fromMap(e.toMap()))
            .toList();
            
        if (newExercises.length != initialLength) {
          p.exercises = newExercises;
          // Delete + put atomique pour forcer la sauvegarde
          await isar.workoutPrograms.delete(p.id);
          await isar.workoutPrograms.put(p);
        }
      }
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

  /// Force la mise à jour d'un programme en supprimant puis réinsérant l'enregistrement
  /// dans une seule transaction. Contourne le bug Isar v3 où les listes @embedded
  /// modifiées in-place ne sont pas détectées comme "dirty" par le moteur.
  Future<void> forceUpdateProgram(WorkoutProgram program) async {
    await isar.writeTxn(() async {
      await isar.workoutPrograms.delete(program.id);
      await isar.workoutPrograms.put(program);
    });
  }

  Future<void> deleteProgram(int id) async {
    await isar.writeTxn(() async {
      // 1. Supprimer le programme
      await isar.workoutPrograms.delete(id);
      
      // 2. Supprimer les séances planifiées FUTURES liées à ce programme
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      await isar.scheduledWorkouts
          .filter()
          .workoutProgramIdEqualTo(id)
          .datePrevueGreaterThan(today.subtract(const Duration(seconds: 1)))
          .deleteAll();
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

  Future<void> deleteHistory(int id) async {
    await isar.writeTxn(() async {
      await isar.exerciseHistorys.delete(id);
    });
  }

  /// Récupère le log d'un exercice enregistré AUJOURD'HUI (null si aucun)
  Future<ExerciseHistory?> getHistoryForToday(int exerciseId) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final all = await isar.exerciseHistorys
        .filter()
        .exerciseIdEqualTo(exerciseId)
        .dateBetween(startOfDay, endOfDay)
        .findAll();

    return all.isNotEmpty ? all.first : null;
  }

  /// Récupère le dernier log d'un exercice AVANT aujourd'hui (null si aucun)
  Future<ExerciseHistory?> getLastHistoryBefore(int exerciseId, DateTime today) async {
    final startOfToday = DateTime(today.year, today.month, today.day);

    final all = await isar.exerciseHistorys
        .filter()
        .exerciseIdEqualTo(exerciseId)
        .dateLessThan(startOfToday)
        .sortByDateDesc()
        .findAll();

    return all.isNotEmpty ? all.first : null;
  }

  /// Met à jour un log existant (pour éviter les doublons si on revalide)
  Future<void> updateHistory(ExerciseHistory history) async {
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

  Future<List<PersonalRecord>> getAllPersonalRecords() async {
    return await isar.personalRecords.where().findAll();
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

  // ─────────────────────────────────────────────────────────────────────────────
  // HEALTH & MEASUREMENTS
  // ─────────────────────────────────────────────────────────────────────────────

  Future<void> saveMeasurement(BodyMeasurement measurement) async {
    await isar.writeTxn(() async {
      await isar.bodyMeasurements.put(measurement);
    });
  }

  Future<void> deleteMeasurement(int id) async {
    await isar.writeTxn(() async {
      await isar.bodyMeasurements.delete(id);
    });
  }

  Future<List<BodyMeasurement>> getAllMeasurements() async {
    return await isar.bodyMeasurements.where().findAll();
  }

  Future<List<BodyMeasurement>> getWeightHistory(int days) async {
    final threshold = DateTime.now().subtract(Duration(days: days));
    final allMeasurements = await isar.bodyMeasurements.where().findAll();
    final recent = allMeasurements.where((m) => m.date.isAfter(threshold)).toList();
    recent.sort((a, b) => b.date.compareTo(a.date));
    return recent;
  }
}
