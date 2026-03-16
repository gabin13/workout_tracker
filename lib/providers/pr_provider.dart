import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/personal_record.dart';
import 'database_provider.dart';

final personalRecordsProvider = FutureProvider.family<List<PersonalRecord>, int>((ref, exerciseId) async {
  final db = ref.watch(databaseProvider);
  return db.getRecordsForExercise(exerciseId);
});
