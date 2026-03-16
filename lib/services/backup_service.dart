import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:isar/isar.dart';

import 'database_service.dart';
import '../models/exercise.dart';
import '../models/workout_program.dart';
import '../models/scheduled_workout.dart';
import '../models/exercise_history.dart';
import '../models/personal_record.dart';

class BackupService {
  final DatabaseService db;

  BackupService(this.db);

  /// Exporte toutes les données de la base Isar vers un fichier JSON et ouvre le menu de partage.
  Future<void> exportToJSON() async {
    try {
      final exercises = await db.getAllExercises();
      final programs = await db.getAllPrograms();
      final sessions = await db.getAllScheduledSessions();
      
      // Utilisation directe d'isar.collection.where().findAll()
      final histories = await db.isar.exerciseHistorys.where().findAll();
      final records = await db.isar.personalRecords.where().findAll();

      final Map<String, dynamic> backupData = {
        'exercises': exercises.map((e) => e.toMap()).toList(),
        'programs': programs.map((p) => p.toMap()).toList(),
        'sessions': sessions.map((s) => s.toMap()).toList(),
        'histories': histories.map((h) => h.toMap()).toList(),
        'records': records.map((r) => r.toMap()).toList(),
        'version': 3,
        'exportDate': DateTime.now().toIso8601String(),
      };

      final jsonString = jsonEncode(backupData);
      
      final tempDir = await getTemporaryDirectory();
      final dateStr = DateFormat('yyyy-MM-dd_HHmm').format(DateTime.now());
      final file = File('${tempDir.path}/workout_backup_$dateStr.json');
      
      await file.writeAsString(jsonString);
      
      // Utilisation de Share.shareXFiles (vérification du package share_plus 12.0)
      await Share.shareXFiles([XFile(file.path)], text: 'Ma sauvegarde Workout Tracker');
    } catch (e) {
      rethrow;
    }
  }

  /// Importe des données depuis un fichier JSON sélectionné par l'utilisateur.
  Future<void> importFromJSON() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.single.path == null) return;

      final file = File(result.files.single.path!);
      final jsonString = await file.readAsString();
      final Map<String, dynamic> data = jsonDecode(jsonString);

      await db.isar.writeTxn(() async {
        // Import Exercises
        if (data.containsKey('exercises')) {
          final List<dynamic> list = data['exercises'];
          for (var item in list) {
            await db.isar.exercises.put(Exercise.fromMap(item));
          }
        }

        // Import Programs
        if (data.containsKey('programs')) {
          final List<dynamic> list = data['programs'];
          for (var item in list) {
            await db.isar.workoutPrograms.put(WorkoutProgram.fromMap(item));
          }
        }

        // Import Sessions
        if (data.containsKey('sessions')) {
          final List<dynamic> list = data['sessions'];
          for (var item in list) {
            await db.isar.scheduledWorkouts.put(ScheduledWorkout.fromMap(item));
          }
        }

        // Import Histories
        if (data.containsKey('histories')) {
          final List<dynamic> list = data['histories'];
          for (var item in list) {
            await db.isar.exerciseHistorys.put(ExerciseHistory.fromMap(item));
          }
        }

        // Import Records
        if (data.containsKey('records')) {
          final List<dynamic> list = data['records'];
          for (var item in list) {
            await db.isar.personalRecords.put(PersonalRecord.fromMap(item));
          }
        }
      });
    } catch (e) {
      rethrow;
    }
  }
}
