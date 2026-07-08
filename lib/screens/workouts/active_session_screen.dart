import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gif_view/gif_view.dart';
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
  bool isValidated = false;
  int? savedHistoryId;

  /// Dernière performance enregistrée (avant aujourd'hui)
  ExerciseHistory? lastPerf;

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
  ConsumerState<ActiveSessionScreen> createState() =>
      _ActiveSessionScreenState();
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
    final exercisesAsync = await ref.read(exercisesProvider.future);
    final db = ref.read(databaseProvider);
    final today = DateTime.now();

    for (var progEx in widget.program.exercises) {
      final exerciseDetails = exercisesAsync.firstWhere(
        (e) => e.id == progEx.exerciseId,
        orElse: () => Exercise()
          ..nom = 'Exercice Supprimé'
          ..musclePrincipal = '',
      );

      final targetSets = progEx.targetSets ?? 1;
      final targetReps = progEx.targetReps ?? '';

      // Chercher un log déjà enregistré aujourd'hui pour cet exercice
      final todayLog = await db.getHistoryForToday(progEx.exerciseId);
      // Chercher la dernière perf avant aujourd'hui
      final lastPerf = await db.getLastHistoryBefore(progEx.exerciseId, today);

      List<SetData> initialSets;
      bool wasValidated = false;
      int? historyId;

      if (todayLog != null) {
        // Reconstruire les sets depuis le CSV "10x80kg, 8x75kg"
        final parts = todayLog.series.split(', ');
        initialSets = parts.map((part) {
          // Format attendu : "10x80kg" (reps x poids)
          final match = RegExp(
            r'^(\d+)x(\d+(?:\.\d+)?)kg$',
          ).firstMatch(part.trim());
          if (match != null) {
            return SetData(
              reps: match.group(1) ?? '',
              weight: match.group(2) ?? '',
            );
          }
          return SetData();
        }).toList();
        wasValidated = true;
        historyId = todayLog.id;
      } else {
        // Aucun log du jour : on crée des sets vides avec les cibles
        initialSets = List.generate(
          targetSets,
          (_) => SetData(reps: targetReps.toString()),
        );
      }

      final ae = ActiveExerciseState(progEx, exerciseDetails, initialSets)
        ..isValidated = wasValidated
        ..savedHistoryId = historyId
        ..lastPerf = lastPerf;

      _activeExercises.add(ae);
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
        content: const Text(
          'Êtes-vous sûr de vouloir terminer cette séance ? Assurez-vous d\'avoir validé tous vos exercices.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Valider'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    final db = ref.read(databaseProvider);

    widget.session.isCompleted = true;
    await db.saveScheduledSession(widget.session);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Séance terminée avec succès 🎉')),
      );
    }
  }

  Future<void> _validerExercice(ActiveExerciseState ae) async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();

    List<double> validWeights = [];
    List<int> validReps = [];

    for (var s in ae.sets) {
      final w = double.tryParse(s.weightController.text);
      final r = int.tryParse(s.repsController.text);

      if (w != null && r != null) {
        validWeights.add(w);
        validReps.add(r);

        final existingRecords = await db.getRecordsForExercise(
          ae.exerciseDetails.id,
        );
        bool isNewPR = false;

        if (existingRecords.isEmpty) {
          isNewPR = true;
        } else {
          final currentMaxWeight = existingRecords
              .map((e) => e.poidsMax)
              .reduce((a, b) => a > b ? a : b);
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
          HapticFeedback.heavyImpact();
        }
      }
    }

    if (validWeights.isNotEmpty) {
      final listSeries = <String>[];
      for (int i = 0; i < validWeights.length; i++) {
        listSeries.add('${validReps[i]}x${validWeights[i]}kg');
      }
      final seriesStr = listSeries.join(', ');

      // Anti-doublon : si un log existe déjà aujourd'hui, on le met à jour
      final existingToday = await db.getHistoryForToday(ae.exerciseDetails.id);

      ExerciseHistory history;
      if (existingToday != null) {
        history = existingToday..series = seriesStr;
        await db.updateHistory(history);
      } else {
        history = ExerciseHistory()
          ..exerciseId = ae.exerciseDetails.id
          ..date = now
          ..series = seriesStr;
        await db.saveHistory(history);
      }

      setState(() {
        ae.savedHistoryId = history.id;
        ae.isValidated = true;
      });

      if (mounted) {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ ${ae.exerciseDetails.nom} validé !')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez entrer au moins une série valide.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _annulerExercice(ActiveExerciseState ae) async {
    if (ae.savedHistoryId != null) {
      final db = ref.read(databaseProvider);
      await db.deleteHistory(ae.savedHistoryId!);
      print(
        '---- ISAR: HISTORIQUE SUPPRIMÉ: ID ${ae.savedHistoryId} pour ${ae.exerciseDetails.nom} ----',
      );

      setState(() {
        ae.savedHistoryId = null;
        ae.isValidated = false;
      });
    }
  }

  Widget _buildExerciseThumbnail(Exercise ex) {
    final path = ex.imagePath;
    if (path == null || path.isEmpty) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withAlpha(20),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Icon(
            Icons.fitness_center,
            size: 24,
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
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageWidget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.program.nom),
        actions:
            const [], // Action retirée pour être placée en OutlinedButton en bas
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _activeExercises.length + 1,
              itemBuilder: (context, index) {
                if (index == _activeExercises.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: OutlinedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  HapticFeedback.vibrate();
                                  _terminerSeance();
                                },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Theme.of(context).primaryColor,
                            side: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Terminer la séance',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return _buildExerciseCard(_activeExercises[index]);
              },
            ),
    );
  }

  Widget _buildExerciseCard(ActiveExerciseState ae) {
    // Si l'exercice est validé
    if (ae.isValidated) {
      int validSetsCount = ae.sets
          .where(
            (s) =>
                s.weightController.text.isNotEmpty &&
                s.repsController.text.isNotEmpty,
          )
          .length;
      return Card(
        margin: const EdgeInsets.only(bottom: 24),
        color: Colors.green.shade50.withAlpha(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.green.shade300, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 36),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ae.exerciseDetails.nom,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$validSetsCount séries enregistrées',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => _annulerExercice(ae),
                child: const Text(
                  'Modifier',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Sinon, mode édition
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. En-tête (Header)
            Row(
              children: [
                _buildExerciseThumbnail(ae.exerciseDetails),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    ae.exerciseDetails.nom,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  onPressed: () {
                    // Actions secondaires
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 2. Ligne de titres
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 32,
                    child: Text(
                      'SET',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'PRÉCÉDENT',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 60,
                    child: Text(
                      'KG',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 60,
                    child: Text(
                      'REPS',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // 3. Lignes de séries
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ae.sets.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, setIndex) {
                final prevPerf = _getPreviousPerfForSet(
                  ae.lastPerf?.series,
                  setIndex,
                );
                final prevWeight = prevPerf['weight']!;
                final prevReps = prevPerf['reps']!;
                final prevText = prevWeight == '-'
                    ? '-'
                    : '${prevWeight}kg × $prevReps';

                return AnimatedBuilder(
                  animation: Listenable.merge([
                    ae.sets[setIndex].weightController,
                    ae.sets[setIndex].repsController,
                  ]),
                  builder: (context, child) {
                    final currentWeight =
                        double.tryParse(
                          ae.sets[setIndex].weightController.text,
                        ) ??
                        0;
                    final currentReps =
                        int.tryParse(ae.sets[setIndex].repsController.text) ??
                        0;
                    final pW = double.tryParse(prevWeight) ?? 0;
                    final pR = int.tryParse(prevReps) ?? 0;

                    // Condition de progression (vert si strict supérieur)
                    final isWeightBetter = currentWeight > pW;
                    final isRepsBetter =
                        currentReps > pR && currentWeight >= pW;

                    return Row(
                      children: [
                        // SET
                        SizedBox(
                          width: 32,
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${setIndex + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // PRÉCÉDENT
                        Expanded(
                          child: Text(
                            prevText,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // KG
                        SizedBox(
                          width: 60,
                          child: TextField(
                            controller: ae.sets[setIndex].weightController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: prevWeight != '-' ? prevWeight : '',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor: isWeightBetter
                                  ? Colors.green.withAlpha(30)
                                  : Colors.grey[100],
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isWeightBetter
                                  ? Colors.green[700]
                                  : Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // REPS
                        SizedBox(
                          width: 60,
                          child: TextField(
                            controller: ae.sets[setIndex].repsController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: prevReps != '-' ? prevReps : '',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor: isRepsBetter
                                  ? Colors.green.withAlpha(30)
                                  : Colors.grey[100],
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isRepsBetter
                                  ? Colors.green[700]
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            // 4. Boutons de fin de carte
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => _validerExercice(ae),
                icon: const Icon(Icons.check, size: 20),
                label: const Text(
                  'Valider l\'exercice',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, String> _getPreviousPerfForSet(String? series, int setIndex) {
    if (series == null || series.isEmpty) return {'weight': '-', 'reps': '-'};
    final parts = series.split(', ');
    if (setIndex >= parts.length) return {'weight': '-', 'reps': '-'};
    final match = RegExp(
      r'^(\d+)x(\d+(?:\.\d+)?)kg$',
    ).firstMatch(parts[setIndex].trim());
    if (match != null) {
      final reps = match.group(1) ?? '-';
      final rawWeight = double.tryParse(match.group(2) ?? '') ?? 0;
      final weight = rawWeight == rawWeight.roundToDouble()
          ? rawWeight.round().toString()
          : rawWeight.toString();
      return {'weight': weight, 'reps': reps};
    }
    return {'weight': '-', 'reps': '-'};
  }
}
