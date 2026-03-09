import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/workout_provider.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(workoutHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Statistiques & Trophées')),
      body: historyAsync.when(
        data: (workouts) {
          // Calcul simple pour la matrice type GitHub
          final today = DateTime.now();
          final startDate = today.subtract(const Duration(days: 90)); // Sur 3 mois max pour l'exemple

          // Map associant chaque jour à une séance (s'il y en a)
          final Map<DateTime, bool> contributionMap = {};
          for (var i = 0; i <= 90; i++) {
            final iter = startDate.add(Duration(days: i));
            final isSameDay = workouts.any((w) => w.date.year == iter.year && w.date.month == iter.month && w.date.day == iter.day);
            contributionMap[DateTime(iter.year, iter.month, iter.day)] = isSameDay;
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Consistance (3 derniers mois)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7, 
                    mainAxisSpacing: 4, 
                    crossAxisSpacing: 4,
                  ),
                  itemCount: contributionMap.length,
                  itemBuilder: (context, index) {
                    final date = contributionMap.keys.elementAt(index);
                    final workedOut = contributionMap[date] ?? false;
                    return Tooltip(
                      message: "${date.day}/${date.month}",
                      child: Container(
                        decoration: BoxDecoration(
                          color: workedOut ? Colors.deepPurpleAccent : Colors.grey.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(height: 40),
              const Text('Records Personnels (Trophées)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              // TO DO: Afficher les PRs réels ici via le provider spécifique
              const ListTile(
                leading: Icon(Icons.emoji_events, color: Colors.amber),
                title: Text('Bench Press'),
                trailing: Text('100 kg', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const ListTile(
                leading: Icon(Icons.emoji_events, color: Colors.amber),
                title: Text('Squat'),
                trailing: Text('140 kg', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
      ),
    );
  }
}
