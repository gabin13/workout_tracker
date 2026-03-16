import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/exercise_provider.dart';
import '../providers/program_provider.dart';
import '../models/exercise.dart';
import '../models/workout_program.dart';
import '../providers/database_provider.dart';
import '../shared/constants.dart';
import '../providers/scheduled_workout_provider.dart';
import 'exercise_detail_screen.dart';
import 'program_detail_screen.dart';
import 'settings_screen.dart';

class ExosScreen extends ConsumerStatefulWidget {
  const ExosScreen({super.key});

  @override
  ConsumerState<ExosScreen> createState() => _ExosScreenState();
}

class _ExosScreenState extends ConsumerState<ExosScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercices & Programmes'),
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
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.fitness_center), text: 'Exercices'),
            Tab(icon: Icon(Icons.list_alt), text: 'Programmes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _ExercisesTab(),
          _ProgrammesTab(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sous-onglet Exercices
// ─────────────────────────────────────────────────────────────────────────────
class _ExercisesTab extends ConsumerStatefulWidget {
  const _ExercisesTab();

  @override
  ConsumerState<_ExercisesTab> createState() => _ExercisesTabState();
}

class _ExercisesTabState extends ConsumerState<_ExercisesTab> {
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
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un exercice...',
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
                  return const Center(child: Text('Aucun exercice trouvé.'));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final ex = filtered[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: const Icon(Icons.fitness_center),
                      ),
                      title: Text(ex.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(ex.musclePrincipal),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExerciseDetailScreen(exercise: ex),
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
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_exercise',
        onPressed: () => _showAddExerciseDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddExerciseDialog(BuildContext context, WidgetRef ref) {
    final nomCtrl = TextEditingController();
    String? selectedMuscle;
    final notesCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nouvel Exercice'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nomCtrl, decoration: const InputDecoration(labelText: 'Nom')),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Muscle principal'),
                initialValue: selectedMuscle,
                items: muscleCategories.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                onChanged: (val) => setDialogState(() => selectedMuscle = val),
              ),
              TextField(controller: notesCtrl, decoration: const InputDecoration(labelText: 'Notes / Réglages machine')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () async {
                if (nomCtrl.text.isNotEmpty && selectedMuscle != null) {
                  final ex = Exercise()
                    ..nom = nomCtrl.text
                    ..musclePrincipal = selectedMuscle!
                    ..notesReglagesMachine = notesCtrl.text.isEmpty ? null : notesCtrl.text;
                  await ref.read(databaseProvider).saveExercise(ex);
                  ref.invalidate(exercisesProvider);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sous-onglet Programmes
// ─────────────────────────────────────────────────────────────────────────────
class _ProgrammesTab extends ConsumerWidget {
  const _ProgrammesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programsAsync = ref.watch(workoutProgramsProvider);

    return Scaffold(
      body: programsAsync.when(
        data: (programs) {
          if (programs.isEmpty) {
            return const Center(child: Text('Aucun programme. Créez-en un !'));
          }
          return ListView.builder(
            itemCount: programs.length,
            itemBuilder: (context, index) {
              final p = programs[index];
              return ListTile(
                leading: const Icon(Icons.list_alt, color: Colors.deepPurpleAccent),
                title: Text(p.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${p.exercises.length} exercice(s)'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _confirmDeleteProgram(context, ref, p),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProgramDetailScreen(program: p),
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
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_program',
        onPressed: () => _showAddProgramDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDeleteProgram(BuildContext context, WidgetRef ref, WorkoutProgram program) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ce programme ?'),
        content: const Text('Cela supprimera également toutes les séances planifiées futures pour ce programme.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(databaseProvider).deleteProgram(program.id);
              ref.invalidate(workoutProgramsProvider);
              ref.invalidate(scheduledWorkoutsProvider);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddProgramDialog(BuildContext context, WidgetRef ref) async {
    final exercises = await ref.read(databaseProvider).getAllExercises();
    if (!context.mounted) return;

    final nomCtrl = TextEditingController();
    final List<int> selectedIds = [];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nouveau Programme'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nomCtrl, decoration: const InputDecoration(labelText: 'Nom du programme')),
                const SizedBox(height: 16),
                const Text('Sélectionner des exercices :', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      final ex = exercises[index];
                      final isSelected = selectedIds.contains(ex.id);
                      return CheckboxListTile(
                        title: Text(ex.nom),
                        value: isSelected,
                        onChanged: (val) {
                          setDialogState(() {
                            if (val == true) {
                              selectedIds.add(ex.id);
                            } else {
                              selectedIds.remove(ex.id);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () async {
                if (nomCtrl.text.isNotEmpty && selectedIds.isNotEmpty) {
                  final p = WorkoutProgram()
                    ..nom = nomCtrl.text
                    ..exercises = selectedIds.map((id) => ProgramExercise()..exerciseId = id).toList();
                  await ref.read(databaseProvider).saveProgram(p);
                  ref.invalidate(workoutProgramsProvider);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text('Créer'),
            ),
          ],
        ),
      ),
    );
  }
}
