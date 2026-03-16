import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout_program.dart';
import '../models/exercise.dart';
import '../providers/database_provider.dart';
import '../providers/exercise_provider.dart';
import '../providers/program_provider.dart';

class ProgramDetailScreen extends ConsumerStatefulWidget {
  final WorkoutProgram program;

  const ProgramDetailScreen({super.key, required this.program});

  @override
  ConsumerState<ProgramDetailScreen> createState() => _ProgramDetailScreenState();
}

class _ProgramDetailScreenState extends ConsumerState<ProgramDetailScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.program.nom);
  }

  Future<void> _saveProgram() async {
    widget.program.nom = _nameController.text;
    await ref.read(databaseProvider).saveProgram(widget.program);
    ref.invalidate(workoutProgramsProvider);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Programme mis à jour !')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(exercisesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Programme'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProgram,
          ),
        ],
      ),
      body: exercisesAsync.when(
        data: (allExercises) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom du programme',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Exercices et Objectifs', 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              Theme(
                data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
                child: ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.program.exercises.length,
                  onReorder: (oldIndex, newIndex) async {
                    setState(() {
                      if (newIndex > oldIndex) newIndex -= 1;
                      final item = widget.program.exercises.removeAt(oldIndex);
                      widget.program.exercises.insert(newIndex, item);
                    });
                    // Sauvegarde automatique de l'ordre
                    await ref.read(databaseProvider).saveProgram(widget.program);
                    ref.invalidate(workoutProgramsProvider);
                  },
                  itemBuilder: (context, index) {
                    final progEx = widget.program.exercises[index];
                    final ex = allExercises.firstWhere(
                      (e) => e.id == progEx.exerciseId,
                      orElse: () => Exercise()..nom = 'Exercice inconnu',
                    );

                    return Card(
                      key: ValueKey('prog_ex_${progEx.exerciseId}_$index'),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.drag_handle, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    Text(ex.nom, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      widget.program.exercises.remove(progEx);
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    initialValue: progEx.targetSets?.toString() ?? '',
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Séries à viser',
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                    onChanged: (val) {
                                      progEx.targetSets = int.tryParse(val);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: progEx.targetReps ?? '',
                                    decoration: const InputDecoration(
                                      labelText: 'Reps (ex: 8-10)',
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                    onChanged: (val) {
                                      progEx.targetReps = val;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(height: 32),
              ElevatedButton.icon(
                onPressed: () => _showAddExerciseSelector(context, allExercises),
                icon: const Icon(Icons.add),
                label: const Text('Ajouter un exercice'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
              const SizedBox(height: 32),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erreur: $err')),
      ),
    );
  }

  void _showAddExerciseSelector(BuildContext context, List<Exercise> allExercises) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
                  child: Text('Choisir un exercice', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: allExercises.length,
                    itemBuilder: (context, index) {
                      final ex = allExercises[index];
                      // Optionnel: masquer ceux déjà présents
                      final isAlreadyIn = widget.program.exercises.any((pe) => pe.exerciseId == ex.id);
                      
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.shade100,
                          child: Icon(Icons.fitness_center, color: isAlreadyIn ? Colors.grey : Colors.deepPurpleAccent),
                        ),
                        title: Text(ex.nom, style: TextStyle(color: isAlreadyIn ? Colors.grey : Colors.black)),
                        subtitle: Text(ex.musclePrincipal),
                        trailing: isAlreadyIn ? const Icon(Icons.check, color: Colors.green) : null,
                        onTap: isAlreadyIn ? null : () {
                          setState(() {
                            widget.program.exercises.add(ProgramExercise()..exerciseId = ex.id);
                          });
                          Navigator.pop(context);
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
