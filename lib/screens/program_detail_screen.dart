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
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nom du programme',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
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

                    return Container(
                      key: ValueKey('prog_ex_${progEx.exerciseId}_$index'),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 12, offset: const Offset(0, 6)),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
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
                                    Text(ex.nom, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.grey),
                                  onPressed: () {
                                    setState(() {
                                      widget.program.exercises.remove(progEx);
                                    });
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Text('Objectif : ', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                                SizedBox(
                                  width: 40,
                                  child: TextFormField(
                                    initialValue: progEx.targetSets?.toString() ?? '',
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      filled: true,
                                      fillColor: Colors.grey[100],
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                    ),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                    onChanged: (val) {
                                      progEx.targetSets = int.tryParse(val);
                                    },
                                  ),
                                ),
                                const Text(' séries de ', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                                SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    initialValue: progEx.targetReps ?? '',
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      filled: true,
                                      fillColor: Colors.grey[100],
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                    ),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                    onChanged: (val) {
                                      progEx.targetReps = val;
                                    },
                                  ),
                                ),
                                const Text(' reps', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
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
      backgroundColor: Colors.white,
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
                  child: Text('Choisir un exercice', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
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
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isAlreadyIn ? Colors.grey.shade100 : Theme.of(context).primaryColor.withAlpha(25),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.fitness_center, color: isAlreadyIn ? Colors.grey : Theme.of(context).primaryColor),
                        ),
                        title: Text(ex.nom, style: TextStyle(color: isAlreadyIn ? Colors.grey : Colors.black87, fontWeight: FontWeight.bold)),
                        subtitle: Text(ex.musclePrincipal, style: TextStyle(color: Colors.grey[500])),
                        trailing: isAlreadyIn ? Icon(Icons.check, color: Theme.of(context).primaryColor) : null,
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
