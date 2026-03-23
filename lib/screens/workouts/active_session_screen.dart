import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/scheduled_workout.dart';
import '../../models/workout_program.dart';
import '../../models/exercise.dart';
import '../../models/exercise_history.dart';
import '../../models/personal_record.dart';
import '../../providers/exercise_provider.dart';
import '../../providers/database_provider.dart';

class SetData {
  final TextEditingController weightController;
  final TextEditingController repsController;

  SetData({String weight = '', String reps = ''}) 
    : weightController = TextEditingController(text: weight),
      repsController = TextEditingController(text: reps);

  void dispose() {
    weightController.dispose();
    repsController.dispose();
  }
}

class ActiveExerciseState {
  final ProgramExercise progEx;
  final Exercise exerciseDetails;
  final List<SetData> sets;

  ActiveExerciseState(this.progEx, this.exerciseDetails, this.sets);
}

class ActiveSessionScreen extends ConsumerStatefulWidget {
  final ScheduledWorkout session;
  final WorkoutProgram program;

  const ActiveSessionScreen({
    super.key,
    required this.session,
    required this.program,
  });

  @override
  ConsumerState<ActiveSessionScreen> createState() => _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends ConsumerState<ActiveSessionScreen> {
  bool _isLoading = true;
  List<ActiveExerciseState> _activeExercises = [];

  @override
  void initState() {
    super.initState();
    _initializeSession();
  }

  Future<void> _initializeSession() async {
    // Attendre que les exercices soient chargés
    final exercisesAsync = await ref.read(exercisesProvider.future);

    for (var progEx in widget.program.exercises) {
      final exerciseDetails = exercisesAsync.firstWhere(
        (e) => e.id == progEx.exerciseId,
        orElse: () => Exercise()..nom = 'Exercice Supprimé'..musclePrincipal = '',
      );

      final targetSets = progEx.targetSets ?? 1;
      final targetReps = progEx.targetReps ?? '';

      List<SetData> initialSets = [];
      for (int i = 0; i < targetSets; i++) {
        initialSets.add(SetData(reps: targetReps.toString())); // On pré-remplit les reps cibles si disponibles
      }

      _activeExercises.add(ActiveExerciseState(progEx, exerciseDetails, initialSets));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    for (var ae in _activeExercises) {
      for (var s in ae.sets) {
        s.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _terminerSeance() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Valider la séance ?'),
        content: const Text('Êtes-vous sûr de vouloir terminer et enregistrer cette séance ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Valider', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    final db = ref.read(databaseProvider);
    final now = DateTime.now();

    // 1. Sauvegarder les ExerciseHistory et vérifier les PR
    for (var ae in _activeExercises) {
      List<double> validWeights = [];
      List<int> validReps = [];

      for (var s in ae.sets) {
        final w = double.tryParse(s.weightController.text);
        final r = int.tryParse(s.repsController.text);

        if (w != null && r != null) {
          validWeights.add(w);
          validReps.add(r);
          
          // Vérifier si un nouveau RP est établi
          final existingRecords = await db.getRecordsForExercise(ae.exerciseDetails.id);
          bool isNewPR = false;
          
          if (existingRecords.isEmpty) {
            isNewPR = true;
          } else {
            // Comparer avec les records existants
            final currentMaxWeight = existingRecords.map((e) => e.poidsMax).reduce((a, b) => a > b ? a : b);
            if (w > currentMaxWeight) {
              isNewPR = true;
            }
          }

          if (isNewPR) {
            final newPR = PersonalRecord()
              ..exerciseId = ae.exerciseDetails.id
              ..date = now
              ..poidsMax = w;
            await db.saveRecord(newPR);
          }
        }
      }

      if (validWeights.isNotEmpty) {
        // Préparer la série de la forme "10x50kg, 8x55kg"
        List<String> listSeries = [];
        for (int i = 0; i < validWeights.length; i++) {
          listSeries.add('${validReps[i]}x${validWeights[i]}kg');
        }

        final history = ExerciseHistory()
          ..exerciseId = ae.exerciseDetails.id
          ..date = now
          ..series = listSeries.join(', ');
        await db.saveHistory(history);
      }
    }

    // 2. Marquer la session comme terminée
    widget.session.isCompleted = true;
    await db.saveScheduledSession(widget.session);

    // 3. Retour à l'accueil
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Séance validée avec succès 🎉')),
      );
    }
  }

  void _addSet(ActiveExerciseState activeExercise) {
    setState(() {
      activeExercise.sets.add(SetData());
    });
  }

  void _removeSet(ActiveExerciseState activeExercise, int setIndex) {
    setState(() {
      activeExercise.sets[setIndex].dispose();
      activeExercise.sets.removeAt(setIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.program.nom),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilledButton.icon(
              onPressed: _isLoading ? null : _terminerSeance,
              icon: const Icon(Icons.check),
              label: const Text('Terminer'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _activeExercises.length,
              itemBuilder: (context, index) {
                return _buildExerciseCard(_activeExercises[index]);
              },
            ),
    );
  }

  Widget _buildExerciseCard(ActiveExerciseState ae) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête de l'exercice
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(50),
                  child: Icon(Icons.fitness_center, color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ae.exerciseDetails.nom,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Objectif : ${ae.progEx.targetSets ?? "?"} séries de ${ae.progEx.targetReps ?? "?"} reps',
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Lignes de séries (Série X - Poids - Reps - Corbeille)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ae.sets.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, setIndex) {
                return Row(
                  children: [
                    SizedBox(
                      width: 70,
                      child: Text(
                        'Série ${setIndex + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: ae.sets[setIndex].weightController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Poids',
                          suffixText: 'kg',
                          isDense: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: ae.sets[setIndex].repsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Reps',
                          suffixText: 'x',
                          isDense: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _removeSet(ae, setIndex),
                    ),
                  ],
                );
              },
            ),
            
            const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: () => _addSet(ae),
                icon: const Icon(Icons.add),
                label: const Text('Ajouter une série'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
