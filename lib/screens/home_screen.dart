import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/program_provider.dart';
import '../providers/scheduled_workout_provider.dart';
import '../providers/exercise_provider.dart';
import '../models/exercise.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduledAsync = ref.watch(scheduledWorkoutsProvider);
    final programsAsync = ref.watch(workoutProgramsProvider);
    final exercisesAsync = ref.watch(exercisesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Dashboard'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── SÉANCE DU JOUR ──────────────────────────────────────────────
            const Text('Ma séance du jour',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            scheduledAsync.when(
              data: (sessions) {
                final today = DateTime.now();
                final todaySession = sessions.where((s) => isSameDay(s.datePrevue, today)).firstOrNull;

                if (todaySession == null) {
                  return _buildNoWorkoutView(context);
                }

                return programsAsync.when(
                  data: (programs) {
                    final program = programs.where((p) => p.id == todaySession.workoutProgramId).firstOrNull;
                    if (program == null) return const Center(child: Text('Programme introuvable.'));

                    return exercisesAsync.when(
                      data: (allExercises) {
                        return _buildTodayWorkoutDetail(context, program, allExercises);
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, _) => Text('Erreur: $err'),
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (err, _) => Text('Erreur: $err'),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Erreur: $err')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoWorkoutView(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          children: [
            Icon(Icons.hotel_class_outlined, size: 64, color: Colors.blueGrey),
            SizedBox(height: 16),
            Text(
              'Repos aujourd\'hui !',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Profitez-en pour bien récupérer ou planifiez votre prochaine séance 🚀',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayWorkoutDetail(BuildContext context, dynamic program, dynamic allExercises) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurpleAccent.shade200, Colors.deepPurpleAccent.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurpleAccent.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('PROGRAMME',
                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 4),
              Text(program.nom,
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.fitness_center, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text('${program.exercises.length} exercices à réaliser',
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text('Détail des exercices',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...program.exercises.map<Widget>((progEx) {
          final exercise = allExercises.firstWhere(
            (e) => e.id == progEx.exerciseId,
            orElse: () => Exercise()..nom = 'Exercice supprimé'..musclePrincipal = 'N/A',
          );

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade100,
                child: const Icon(Icons.check_circle_outline, color: Colors.grey),
              ),
              title: Text(exercise.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(exercise.musclePrincipal),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${progEx.targetSets ?? "?"} séries',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent)),
                  Text('${progEx.targetReps ?? "?"} reps',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
