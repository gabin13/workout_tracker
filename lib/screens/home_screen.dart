import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/program_provider.dart';
import '../providers/scheduled_workout_provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduledAsync = ref.watch(scheduledWorkoutsProvider);
    final programsAsync = ref.watch(workoutProgramsProvider);

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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            scheduledAsync.when(
              data: (sessions) {
                final today = DateTime.now();
                final todaySession = sessions.where((s) => isSameDay(s.datePrevue, today)).firstOrNull;

                if (todaySession == null) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text('Aucune séance prévue pour aujourd\'hui.'),
                      ),
                    ),
                  );
                }

                return programsAsync.when(
                  data: (programs) {
                    final program = programs.where((p) => p.id == todaySession.workoutProgramId).firstOrNull;
                    return Card(
                      color: Colors.deepPurpleAccent.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.deepPurpleAccent),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.fitness_center, color: Colors.deepPurpleAccent),
                        title: Text(program?.nom ?? 'Programme inconnu',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${program?.exerciceIds.length ?? 0} exercice(s)'),
                        trailing: ElevatedButton(
                          onPressed: () {
                            // Navigation optionnelle vers le démarrage
                          },
                          child: const Text('GO'),
                        ),
                      ),
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (err, _) => Text('Erreur: $err'),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Erreur: $err')),
            ),
            const SizedBox(height: 32),

            // ─── MES PROGRAMMES ──────────────────────────────────────────────
            const Text('Mes Programmes',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            programsAsync.when(
              data: (programs) {
                if (programs.isEmpty) {
                  return const Text('Aucun programme trouvé.');
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: programs.length,
                  itemBuilder: (context, index) {
                    final p = programs[index];
                    return Card(
                      child: InkWell(
                        onTap: () {
                          // Action au clic si nécessaire
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(p.nom,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 4),
                              Text('${p.exerciceIds.length} exos',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
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
}
