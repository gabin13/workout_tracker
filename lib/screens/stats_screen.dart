import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/exercise_provider.dart';
import '../providers/pr_provider.dart';
import '../shared/constants.dart';
import 'pr_history_screen.dart';
import 'settings_screen.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  String _searchQuery = '';
  String _selectedMuscle = 'Tous';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(exercisesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Records Personnels (PR)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un record...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                isDense: true,
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          // Filtres par muscle
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: muscleCategories.length + 1,
              itemBuilder: (context, index) {
                final muscle = index == 0 ? 'Tous' : muscleCategories[index - 1];
                final isSelected = _selectedMuscle == muscle;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(muscle),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedMuscle = muscle);
                    },
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          // Liste
          Expanded(
            child: exercisesAsync.when(
              data: (exercises) {
                // Application des filtres
                final filtered = exercises.where((ex) {
                  final matchesSearch = ex.nom.toLowerCase().contains(_searchQuery.toLowerCase());
                  final matchesMuscle = _selectedMuscle == 'Tous' || ex.musclePrincipal == _selectedMuscle;
                  return matchesSearch && matchesMuscle;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text('Aucun exercice trouvé pour ces critères.'),
                  );
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final ex = filtered[index];
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
          ),
        ],
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
