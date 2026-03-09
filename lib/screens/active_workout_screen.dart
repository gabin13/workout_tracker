import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../models/workout.dart';
import '../models/workout_set.dart';
import '../providers/workout_provider.dart';
import '../providers/database_provider.dart';

class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  ConsumerState<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  Timer? _restTimer;
  int _restSecondsRemaining = 0;
  final int _defaultRestTime = 90;
  
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  void _startRestTimer() {
    _restTimer?.cancel();
    setState(() {
      _restSecondsRemaining = _defaultRestTime;
    });
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_restSecondsRemaining > 0) {
        setState(() {
          _restSecondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeSets = ref.watch(activeWorkoutSetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entraînement en cours'),
        actions: [
          TextButton(
            onPressed: () => _finishWorkout(context, ref),
            child: const Text('Terminer', style: TextStyle(color: Colors.greenAccent)),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
        children: [
          if (_restSecondsRemaining > 0)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.deepPurple.withValues(alpha: 0.2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.timer, color: Colors.deepPurpleAccent),
                  const SizedBox(width: 8),
                  Text(
                    'Repos: ${_restSecondsRemaining ~/ 60}:${(_restSecondsRemaining % 60).toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent),
                  ),
                ],
              ),
            ),
          Expanded(
            child: activeSets.isEmpty
                ? const Center(child: Text('Ajoutez un exercice pour commencer'))
                : ListView.builder(
                    itemCount: activeSets.length,
                    itemBuilder: (context, index) {
                      final set = activeSets[index];
                      // Affichage simplifié
                      return ListTile(
                        leading: CircleAvatar(child: Text('${index + 1}')),
                        title: Text('Exercice ID: ${set.exerciseId}'),
                        subtitle: Text('${set.poids} kg x ${set.repetitions} reps'),
                      );
                    },
                  ),
          ),
        ],
      ),
      Align(
        alignment: Alignment.topCenter,
        child: ConfettiWidget(
          confettiController: _confettiController,
          blastDirection: pi / 2, // vers le bas
          maxBlastForce: 5,
          minBlastForce: 2,
          emissionFrequency: 0.05,
          numberOfParticles: 50,
        ),
      ),
    ],
  ),
  floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSetDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter une série'),
      ),
    );
  }

  void _showAddSetDialog(BuildContext context, WidgetRef ref) {
    final weightCtrl = TextEditingController();
    final repsCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Saisie rapide'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: weightCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Poids (kg)'),
              ),
              TextField(
                controller: repsCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Répétitions'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                final weight = double.tryParse(weightCtrl.text) ?? 0.0;
                final reps = int.tryParse(repsCtrl.text) ?? 0;

                if (weight > 0 && reps > 0) {
                  final newSet = WorkoutSet()
                    ..exerciseId = 1 // Hardcodé pour la démo
                    ..workoutId = 0
                    ..poids = weight
                    ..repetitions = reps
                    ..typeSerie = SetType.normale;
                  
                  ref.read(activeWorkoutSetsProvider.notifier).addSet(newSet);
                  _startRestTimer(); // Lancement du chrono
                  
                  // LOGIQUE DE GAMIFICATION (Simulation Record)
                  // On vérifie le record dans Isar en production, ici on déclenche
                  // pour l'effet Wow en cas de poids > 50kg pour la démo
                  if (weight > 50) {
                     _confettiController.play();
                     ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(
                         content: Text('🎉 NOUVEAU RECORD PERSONNEL !'),
                         backgroundColor: Colors.amber,
                       ),
                     );
                  }

                  Navigator.pop(context);
                }
              },
              child: const Text('Valider'),
            )
          ],
        );
      },
    );
  }

  Future<void> _finishWorkout(BuildContext context, WidgetRef ref) async {
    final activeSets = ref.read(activeWorkoutSetsProvider);
    if (activeSets.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final newWorkout = Workout()
      ..date = DateTime.now()
      ..nom = 'Nouvelle séance'
      ..dureeTotale = 3600; // Simulé : 1 heure

    final db = ref.read(databaseProvider);
    await db.saveWorkout(newWorkout);

    for (var set in activeSets) {
      set.workoutId = newWorkout.id;
      await db.saveWorkoutSet(set);
    }
    
    ref.read(activeWorkoutSetsProvider.notifier).clear();
    ref.invalidate(workoutHistoryProvider); // Rafraîchit l'accueil

    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
