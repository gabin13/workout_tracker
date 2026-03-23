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
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey[500],
          indicatorColor: Theme.of(context).primaryColor,
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
          const SizedBox(height: 8),
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un exercice...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                filled: true,
                fillColor: Colors.grey[100],
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[500]),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(30)),
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
                  child: Theme(
                    data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
                    child: ChoiceChip(
                      label: Text(muscle),
                      selected: isSelected,
                      selectedColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Theme.of(context).primaryColor : Colors.grey[500],
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: isSelected 
                            ? BorderSide.none 
                            : BorderSide(color: Colors.grey.shade300),
                      ),
                      showCheckmark: false,
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedMuscle = muscle);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 16), // Espacement après la barre/filtre avant les listes
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
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 12, offset: const Offset(0, 6)),
                        ],
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withAlpha(25),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.fitness_center, color: Theme.of(context).primaryColor),
                        ),
                        title: Text(ex.nom, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                        subtitle: Text(ex.musclePrincipal, style: TextStyle(color: Colors.grey[500])),
                        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExerciseDetailScreen(exercise: ex),
                            ),
                          );
                        },
                      ),
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
        child: const Icon(Icons.add_rounded),
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
            padding: const EdgeInsets.only(top: 24),
            itemCount: programs.length,
            itemBuilder: (context, index) {
              final p = programs[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 12, offset: const Offset(0, 6)),
                  ],
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.list_alt, color: Theme.of(context).primaryColor),
                  ),
                  title: Text(p.nom, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                  subtitle: Text('${p.exercises.length} exercice(s)', style: TextStyle(color: Colors.grey[500])),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.red[400]),
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
                ),
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
        child: const Icon(Icons.add_rounded),
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Padding(
          padding: EdgeInsets.only(
            left: 16, right: 16, top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Nouveau Programme', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 16),
              TextField(
                controller: nomCtrl, 
                decoration: InputDecoration(
                  labelText: 'Nom du programme',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Sélectionner des exercices :', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final ex = exercises[index];
                    final isSelected = selectedIds.contains(ex.id);
                    return CheckboxListTile(
                      title: Text(ex.nom, style: const TextStyle(color: Colors.black87)),
                      value: isSelected,
                      activeColor: Theme.of(context).primaryColor,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
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
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
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
                  child: const Text('Créer le programme', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
