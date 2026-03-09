import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/workout_provider.dart';
import 'active_workout_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(workoutHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Tracker'),
        centerTitle: true,
      ),
      body: historyAsync.when(
        data: (workouts) {
          if (workouts.isEmpty) {
            return const Center(
              child: Text(
                'Aucun entraînement enregistré.\nCommencez une nouvelle séance !',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }
          return ListView.builder(
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(workout.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    '${workout.date.day}/${workout.date.month}/${workout.date.year}',
                  ),
                  trailing: Text('${(workout.dureeTotale / 60).floor()} min'),
                  onTap: () {
                    // Voir les détails de la séance
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ActiveWorkoutScreen()),
          );
        },
        icon: const Icon(Icons.play_arrow),
        label: const Text('Démarrer', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
