import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gif_view/gif_view.dart';
import '../models/workout_program.dart';
import '../models/exercise.dart';
import '../providers/database_provider.dart';
import '../providers/exercise_provider.dart';
import '../providers/program_provider.dart';

class ProgramDetailScreen extends ConsumerStatefulWidget {
  final WorkoutProgram program;

  const ProgramDetailScreen({super.key, required this.program});

  @override
  ConsumerState<ProgramDetailScreen> createState() =>
      _ProgramDetailScreenState();
}

class _ProgramDetailScreenState extends ConsumerState<ProgramDetailScreen> {
  late TextEditingController _nameController;
  late List<ProgramExercise> _exercises;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.program.nom);
    // Copie locale profonde des exercices — on ne touche JAMAIS à widget.program.exercises
    _exercises = widget.program.exercises
        .map((e) => ProgramExercise.fromMap(e.toMap()))
        .toList();
  }

  Future<void> _saveProgram({bool showSnackbar = true}) async {
    // Construit un programme neuf à chaque sauvegarde
    final programToSave = WorkoutProgram()
      ..id = widget.program.id
      ..nom = _nameController.text
      ..exercises = _exercises
          .map((e) => ProgramExercise.fromMap(e.toMap()))
          .toList();

    // delete + put atomique pour contourner le dirty-tracking Isar
    await ref.read(databaseProvider).forceUpdateProgram(programToSave);
    ref.invalidate(workoutProgramsProvider);

    if (mounted && showSnackbar) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Programme mis à jour !')));
    }
  }

  Widget _buildExerciseThumbnail(Exercise ex) {
    final path = ex.imagePath;
    if (path == null || path.isEmpty) {
      return Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withAlpha(20),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Icon(
            Icons.fitness_center,
            size: 34,
            color: Theme.of(context).primaryColor.withAlpha(120),
          ),
        ),
      );
    }

    final isGif = path.toLowerCase().endsWith('.gif');

    Widget imageWidget;
    if (path.startsWith('/')) {
      if (isGif) {
        imageWidget = GifView.memory(
          File(path).readAsBytesSync(),
          autoPlay: false,
          fit: BoxFit.contain,
        );
      } else {
        imageWidget = Image.file(File(path), fit: BoxFit.contain);
      }
    } else if (path.startsWith('http')) {
      if (isGif) {
        imageWidget = GifView.network(
          path,
          autoPlay: false,
          fit: BoxFit.contain,
        );
      } else {
        imageWidget = Image.network(path, fit: BoxFit.contain);
      }
    } else {
      if (isGif) {
        imageWidget = GifView.asset(path, autoPlay: false, fit: BoxFit.contain);
      } else {
        imageWidget = Image.asset(path, fit: BoxFit.contain);
      }
    }

    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(14),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: imageWidget,
      ),
    );
  }

  Widget _buildObjectiveField({
    required String initialValue,
    required String hint,
    required ValueChanged<String> onChanged,
    double width = 44,
  }) {
    return SizedBox(
      width: width,
      height: 36,
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 4,
          ),
        ),
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(exercisesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Programme'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveProgram),
        ],
      ),
      body: exercisesAsync.when(
        data: (allExercises) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nom du programme',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Exercices et Objectifs',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(canvasColor: Colors.transparent),
                    child: ReorderableListView.builder(
                      itemCount: _exercises.length,
                      onReorder: (oldIndex, newIndex) async {
                        setState(() {
                          if (newIndex > oldIndex) newIndex -= 1;
                          final item = _exercises.removeAt(oldIndex);
                          _exercises.insert(newIndex, item);

                          for (int i = 0; i < _exercises.length; i++) {
                            _exercises[i].orderIndex = i;
                          }
                        });
                        await _saveProgram(showSnackbar: false);
                      },
                      itemBuilder: (context, index) {
                        final progEx = _exercises[index];
                        final ex = allExercises.firstWhere(
                          (e) => e.id == progEx.exerciseId,
                          orElse: () => Exercise()..nom = 'Exercice inconnu',
                        );

                        return Dismissible(
                          key: ValueKey(
                            'prog_ex_dismiss_${progEx.exerciseId}_$index',
                          ),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withAlpha(50),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                            ),
                          ),
                          onDismissed: (_) async {
                            HapticFeedback.mediumImpact();

                            final removedExercise = ProgramExercise.fromMap(
                              _exercises[index].toMap(),
                            );

                            setState(() {
                              _exercises.removeAt(index);
                              for (int i = 0; i < _exercises.length; i++) {
                                _exercises[i].orderIndex = i;
                              }
                            });

                            await _saveProgram(showSnackbar: false);

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Exercice retiré du programme',
                                  ),
                                  duration: const Duration(seconds: 3),
                                  action: SnackBarAction(
                                    label: 'Annuler',
                                    onPressed: () async {
                                      setState(() {
                                        _exercises.insert(
                                          index,
                                          removedExercise,
                                        );
                                        for (
                                          int i = 0;
                                          i < _exercises.length;
                                          i++
                                        ) {
                                          _exercises[i].orderIndex = i;
                                        }
                                      });
                                      await _saveProgram(showSnackbar: false);
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            key: ValueKey(
                              'prog_ex_${progEx.exerciseId}_$index',
                            ),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(20),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // LEFT: Exercise image thumbnail
                                  _buildExerciseThumbnail(ex),
                                  const SizedBox(width: 14),
                                  // RIGHT: Name + objectives
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Top row: exercise name + drag handle
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                ex.nom,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16,
                                                  color: Colors.black87,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            ReorderableDragStartListener(
                                              index: index,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 4,
                                                ),
                                                child: Icon(
                                                  Icons.drag_handle,
                                                  color: Colors.grey[400],
                                                  size: 22,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        // Objective row
                                        Row(
                                          children: [
                                            _buildObjectiveField(
                                              initialValue:
                                                  progEx.targetSets
                                                      ?.toString() ??
                                                  '',
                                              hint: '–',
                                              width: 44,
                                              onChanged: (val) {
                                                progEx.targetSets =
                                                    int.tryParse(val);
                                              },
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 7,
                                                  ),
                                              child: Text(
                                                'séries',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '×',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 7,
                                                  ),
                                              child: _buildObjectiveField(
                                                initialValue:
                                                    progEx.targetReps ?? '',
                                                hint: '–',
                                                width: 54,
                                                onChanged: (val) {
                                                  progEx.targetReps = val;
                                                },
                                              ),
                                            ),
                                            Text(
                                              'reps',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const Divider(height: 32),
                ElevatedButton.icon(
                  onPressed: () =>
                      _showAddExerciseSelector(context, allExercises),
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter un exercice'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erreur: $err')),
      ),
    );
  }

  void _showAddExerciseSelector(
    BuildContext context,
    List<Exercise> allExercises,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Choisir un exercice',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: allExercises.length,
                    itemBuilder: (context, index) {
                      final ex = allExercises[index];
                      // Optionnel: masquer ceux déjà présents
                      final isAlreadyIn = _exercises.any(
                        (pe) => pe.exerciseId == ex.id,
                      );

                      return ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isAlreadyIn
                                ? Colors.grey.shade100
                                : Theme.of(context).primaryColor.withAlpha(25),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.fitness_center,
                            color: isAlreadyIn
                                ? Colors.grey
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                        title: Text(
                          ex.nom,
                          style: TextStyle(
                            color: isAlreadyIn ? Colors.grey : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          ex.musclePrincipal,
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        trailing: isAlreadyIn
                            ? Icon(
                                Icons.check,
                                color: Theme.of(context).primaryColor,
                              )
                            : null,
                        onTap: isAlreadyIn
                            ? null
                            : () async {
                                setState(() {
                                  final nextOrder = _exercises.length;
                                  final newExercise = ProgramExercise()
                                    ..exerciseId = ex.id
                                    ..orderIndex = nextOrder;
                                  _exercises.add(newExercise);
                                });
                                await _saveProgram(showSnackbar: false);
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Exercice ajouté avec succès',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
