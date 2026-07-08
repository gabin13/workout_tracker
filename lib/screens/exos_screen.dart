import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import '../utils/ux_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/exercise_provider.dart';
import '../providers/program_provider.dart';
import '../providers/pr_provider.dart';
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
                CustomPageRoute(page: const SettingsScreen()),
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
        children: const [_ExercisesTab(), _ProgrammesTab()],
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
    final prsAsync = ref.watch(allPersonalRecordsProvider);

    // Construire un map exerciseId -> meilleur poids
    final Map<int, double> bestPrMap = {};
    prsAsync.whenData((prs) {
      for (var pr in prs) {
        if (!bestPrMap.containsKey(pr.exerciseId) ||
            pr.poidsMax > bestPrMap[pr.exerciseId]!) {
          bestPrMap[pr.exerciseId] = pr.poidsMax;
        }
      }
    });

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
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30),
                ),
                isDense: true,
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          // Filtres par muscle
          SizedBox(
            height: 50,
            child: Row(
              children: [
                // Bouton "Tous" fixe
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 4),
                  child: Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(canvasColor: Colors.transparent),
                    child: ChoiceChip(
                      label: const Text('Tous'),
                      selected: _selectedMuscle == 'Tous',
                      selectedColor: Theme.of(
                        context,
                      ).primaryColor.withOpacity(0.1),
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: _selectedMuscle == 'Tous'
                            ? Theme.of(context).primaryColor
                            : Colors.grey[500],
                        fontWeight: _selectedMuscle == 'Tous'
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: _selectedMuscle == 'Tous'
                            ? BorderSide.none
                            : BorderSide(color: Colors.grey.shade300),
                      ),
                      showCheckmark: false,
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedMuscle = 'Tous');
                      },
                    ),
                  ),
                ),
                // Séparateur visuel subtil
                Container(width: 1, height: 24, color: Colors.grey[300]),
                // Filtres muscles scrollables
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 4, right: 12),
                    itemCount: muscleCategories.length,
                    itemBuilder: (context, index) {
                      final muscle = muscleCategories[index];
                      final isSelected = _selectedMuscle == muscle;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(canvasColor: Colors.transparent),
                          child: ChoiceChip(
                            label: Text(muscle),
                            selected: isSelected,
                            selectedColor: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                            backgroundColor: Colors.white,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[500],
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: isSelected
                                  ? BorderSide.none
                                  : BorderSide(color: Colors.grey.shade300),
                            ),
                            showCheckmark: false,
                            onSelected: (selected) {
                              if (selected)
                                setState(() => _selectedMuscle = muscle);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          const SizedBox(
            height: 16,
          ), // Espacement après la barre/filtre avant les listes
          // Liste
          Expanded(
            child: exercisesAsync.when(
              data: (exercises) {
                // Application des filtres
                final filtered = exercises.where((ex) {
                  final matchesSearch = ex.nom.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  );
                  final matchesMuscle =
                      _selectedMuscle == 'Tous' ||
                      ex.musclePrincipal == _selectedMuscle;
                  return matchesSearch && matchesMuscle;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('Aucun exercice trouvé.'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final ex = filtered[index];
                    final bestPr = bestPrMap[ex.id];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CustomPageRoute(
                            page: ExerciseDetailScreen(exercise: ex),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Image part (top half)
                            Expanded(
                              flex: 5,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child: _buildExerciseImage(context, ex),
                              ),
                            ),
                            // Text part (bottom half)
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ex.nom,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (bestPr != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).primaryColor.withAlpha(25),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          '${bestPr % 1 == 0 ? bestPr.toInt() : bestPr.toStringAsFixed(1)} kg',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Theme.of(
                                              context,
                                            ).primaryColor,
                                          ),
                                        ),
                                      )
                                    else
                                      Text(
                                        ex.musclePrincipal,
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 12,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildExerciseImage(BuildContext context, Exercise ex) {
    String? path = ex.imagePath;

    if (path == null || path.isEmpty) {
      return _buildImagePlaceholder(context);
    }

    final isGif = path.toLowerCase().endsWith('.gif');

    // Check if it's a file path
    if (path.startsWith('/')) {
      if (isGif) {
        return GifView.memory(
          File(path).readAsBytesSync(),
          autoPlay: false,
          fit: BoxFit.contain,
        );
      }
      return Image.file(
        File(path),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            _buildImagePlaceholder(context),
      );
    }
    // Check if network
    if (path.startsWith('http')) {
      if (isGif) {
        return GifView.network(path, autoPlay: false, fit: BoxFit.contain);
      }
      return Image.network(
        path,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            _buildImagePlaceholder(context),
      );
    }
    // Default to asset
    if (isGif) {
      return GifView.asset(path, autoPlay: false, fit: BoxFit.contain);
    }
    return Image.asset(
      path,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) =>
          _buildImagePlaceholder(context),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withAlpha(25),
      child: Center(
        child: Icon(
          Icons.fitness_center,
          size: 40,
          color: Theme.of(context).primaryColor.withAlpha(120),
        ),
      ),
    );
  }

  void _showAddExerciseDialog(BuildContext context, WidgetRef ref) {
    final nomCtrl = TextEditingController();
    String? selectedMuscle;
    final notesCtrl = TextEditingController();
    final imagePathCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nouvel Exercice'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomCtrl,
                  decoration: const InputDecoration(labelText: 'Nom'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Muscle principal',
                  ),
                  initialValue: selectedMuscle,
                  items: muscleCategories
                      .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                      .toList(),
                  onChanged: (val) =>
                      setDialogState(() => selectedMuscle = val),
                ),
                TextField(
                  controller: notesCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Notes / Réglages machine',
                  ),
                ),
                TextField(
                  controller: imagePathCtrl,
                  decoration: const InputDecoration(
                    labelText: 'URL de l\'image (optionnel)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nomCtrl.text.isNotEmpty && selectedMuscle != null) {
                  final ex = Exercise()
                    ..nom = nomCtrl.text
                    ..musclePrincipal = selectedMuscle!
                    ..notesReglagesMachine = notesCtrl.text.isEmpty
                        ? null
                        : notesCtrl.text;
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
    final exercisesAsync = ref.watch(exercisesProvider);

    return Scaffold(
      body: programsAsync.when(
        data: (programs) {
          if (programs.isEmpty) {
            return const Center(child: Text('Aucun programme. Créez-en un !'));
          }
          return exercisesAsync.when(
            data: (allExercises) {
              return ListView.builder(
                padding: const EdgeInsets.only(top: 24, bottom: 80),
                itemCount: programs.length,
                itemBuilder: (context, index) {
                  final p = programs[index];

                  // Calcule des métriques
                  int totalSets = 0;
                  Map<String, int> muscleVolume = {};

                  for (var progEx in p.exercises) {
                    final targetSets = progEx.targetSets ?? 3; // Par défaut 3
                    totalSets += targetSets;

                    // Trouver l'exercice pour le muscle
                    final exData = allExercises.firstWhere(
                      (e) => e.id == progEx.exerciseId,
                      orElse: () => Exercise()..musclePrincipal = 'Inconnu',
                    );

                    final muscle = exData.musclePrincipal;
                    muscleVolume[muscle] =
                        (muscleVolume[muscle] ?? 0) + targetSets;
                  }

                  final estimatedDuration = totalSets * 4; // ~4 min par série

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CustomPageRoute(page: ProgramDetailScreen(program: p)),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: 16,
                        left: 16,
                        right: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(15),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // HEADER
                                Row(
                                  children: [
                                    // Miniature
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).primaryColor.withAlpha(20),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.accessibility_new_rounded,
                                        size: 32,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    // Titre & Métriques
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            p.nom.toUpperCase(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black87,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.layers_outlined,
                                                size: 14,
                                                color: Colors.grey[600],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '$totalSets séries',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Icon(
                                                Icons.timer_outlined,
                                                size: 14,
                                                color: Colors.grey[600],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '~$estimatedDuration min',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                // ANALYSE DU VOLUME
                                if (muscleVolume.isNotEmpty) ...[
                                  const SizedBox(height: 20),
                                  Text(
                                    'Répartition musculaire',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: muscleVolume.entries.map((
                                        entry,
                                      ) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8.0,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  entry.key,
                                                  style: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    '${entry.value}',
                                                    style: TextStyle(
                                                      color: Theme.of(
                                                        context,
                                                      ).primaryColor,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          // Bouton Poubelle discret (en haut à droite)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20),
                              color: Colors.grey[400],
                              onPressed: () =>
                                  _confirmDeleteProgram(context, ref, p),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Erreur Exercices: $err')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erreur Programmes: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_program',
        onPressed: () => _showAddProgramDialog(context, ref),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  void _confirmDeleteProgram(
    BuildContext context,
    WidgetRef ref,
    WorkoutProgram program,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ce programme ?'),
        content: const Text(
          'Cela supprimera également toutes les séances planifiées futures pour ce programme.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(databaseProvider).deleteProgram(program.id);
              ref.invalidate(workoutProgramsProvider);
              ref.invalidate(scheduledWorkoutsProvider);
            },
            child: const Text(
              'Supprimer',
              style: TextStyle(color: Colors.white),
            ),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Nouveau Programme',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nomCtrl,
                decoration: InputDecoration(
                  labelText: 'Nom du programme',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sélectionner des exercices :',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
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
                      title: Text(
                        ex.nom,
                        style: const TextStyle(color: Colors.black87),
                      ),
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
                        ..exercises = selectedIds
                            .map((id) => ProgramExercise()..exerciseId = id)
                            .toList();
                      await ref.read(databaseProvider).saveProgram(p);
                      ref.invalidate(workoutProgramsProvider);
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Créer le programme',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
