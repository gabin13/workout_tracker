import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/exercise.dart';
import 'database_provider.dart';

final searchTargetProvider = StateProvider<String>((ref) => "");

final exercisesProvider = FutureProvider<List<Exercise>>((ref) async {
  final db = ref.watch(databaseProvider);
  final query = ref.watch(searchTargetProvider);
  
  if (query.isEmpty) {
    return db.getAllExercises();
  } else {
    return db.searchExercises(query);
  }
});
