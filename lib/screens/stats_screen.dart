import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/exercise_provider.dart';
import '../providers/pr_provider.dart';
import 'pr_history_screen.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(exercisesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Records Personnels (PR)')),
      body: exercisesAsync.when(
        data: (exercises) {
          if (exercises.isEmpty) {
            return const Center(
              child: Text('Aucun exercice trouvé.\nCréez des exercices pour suivre vos records.'),
            );
          }
          return ListView.builder(
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final ex = exercises[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.amber.withValues(alpha: 0.1),
                  child: const Icon(Icons.emoji_events, color: Colors.amber),
                ),
                title: Text(ex.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(ex.musclePrincipal),
                trailing: PrTrailing(exerciseId: ex.id),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PRHistoryScreen(
                        exerciseId: ex.id,
                        exerciseNom: ex.nom,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erreur: $err')),
      ),
    );
  }
}

class PrTrailing extends ConsumerWidget {
  final int exerciseId;

  const PrTrailing({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prsAsync = ref.watch(personalRecordsProvider(exerciseId));

    return prsAsync.when(
      data: (prs) {
        if (prs.isEmpty) return const Icon(Icons.chevron_right);
        
        // Trouver le record max
        double maxWeight = 0;
        for (var pr in prs) {
          if (pr.poidsMax > maxWeight) maxWeight = pr.poidsMax;
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${maxWeight.toStringAsFixed(maxWeight % 1 == 0 ? 0 : 1)} kg',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.amber,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
          ],
        );
      },
      loading: () => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
      error: (err, stack) => const Icon(Icons.error_outline),
    );
  }
}
