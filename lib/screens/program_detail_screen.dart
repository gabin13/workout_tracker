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
              ...widget.program.exercises.map((progEx) {
                final ex = allExercises.firstWhere((e) => e.id == progEx.exerciseId, 
                    orElse: () => Exercise()..nom = 'Exercice inconnu');
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ex.nom, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
              }),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erreur: $err')),
      ),
    );
  }
}
