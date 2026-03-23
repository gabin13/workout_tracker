import 'dart:convert';
import '../utils/ux_utils.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/exercise.dart';
import '../models/exercise_history.dart';
import '../providers/database_provider.dart';
import '../providers/history_provider.dart';
import '../providers/exercise_provider.dart';
import '../providers/program_provider.dart';
import '../providers/scheduled_workout_provider.dart';
import '../providers/pr_provider.dart';
import 'pr_history_screen.dart';
import '../shared/constants.dart';

class ExerciseDetailScreen extends ConsumerStatefulWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  ConsumerState<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends ConsumerState<ExerciseDetailScreen> {
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.exercise.notesReglagesMachine);
  }

  Future<void> _saveNotes() async {
    final db = ref.read(databaseProvider);
    
    // 1. Sauvegarder les notes si elles ont changé
    if (_notesController.text != widget.exercise.notesReglagesMachine) {
      widget.exercise.notesReglagesMachine = _notesController.text;
      await db.saveExercise(widget.exercise);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notes enregistrées !')),
        );
      }
    }
  }

  double _calculateMaxWeight(String seriesData) {
    double maxW = 0.0;
    try {
      if (seriesData.startsWith('[')) {
        final List<dynamic> decoded = jsonDecode(seriesData);
        for (var s in decoded) {
          final w = double.tryParse(s['poids'].toString()) ?? 0.0;
          if (w > maxW) maxW = w;
        }
        return maxW;
      }
    } catch (_) {}

    final parts = seriesData.split(',');
    for (var p in parts) {
      p = p.trim();
      if (p.isEmpty) continue;
      final xIndex = p.indexOf('x');
      final kgIndex = p.indexOf('kg');
      if (xIndex != -1) {
        final weightStr = (kgIndex != -1 && kgIndex > xIndex) 
            ? p.substring(xIndex + 1, kgIndex)
            : p.substring(xIndex + 1);
        final w = double.tryParse(weightStr.trim()) ?? 0.0;
        if (w > maxW) maxW = w;
      }
    }
    return maxW;
  }

  String _formatSeriesDisplay(String seriesData) {
    try {
      if (seriesData.startsWith('[')) {
        final List<dynamic> decoded = jsonDecode(seriesData);
        List<String> formatted = [];
        for (int i = 0; i < decoded.length; i++) {
          formatted.add('Série ${i+1}: ${decoded[i]['reps']}x${decoded[i]['poids']}kg');
        }
        return formatted.join(' | ');
      }
    } catch (_) {}

    final parts = seriesData.split(',');
    List<String> formatted = [];
    for (int i = 0; i < parts.length; i++) {
      formatted.add('Série ${i+1}: ${parts[i].trim()}');
    }
    return formatted.join(' | ');
  }

  @override
  Widget build(BuildContext context) {
    final prsAsync = ref.watch(personalRecordsProvider(widget.exercise.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.nom),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showEditExerciseDialog(context),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red[400]),
            onPressed: () => _confirmDeleteExercise(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildPRBanner(context, ref, prsAsync),
          Expanded(
            child: _buildViewMode(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPRBanner(BuildContext context, WidgetRef ref, AsyncValue<List<dynamic>> prsAsync) {
    return prsAsync.when(
      data: (prs) {
        double maxWeight = 0;
        
        for (var pr in prs) {
          if (pr.poidsMax > maxWeight) {
            maxWeight = pr.poidsMax;
          }
        }

        final bool hasPR = maxWeight > 0;

        return Card(
          margin: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.primaryContainer,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                CustomPageRoute(
                  page: PRHistoryScreen(
                    exerciseId: widget.exercise.id,
                    exerciseNom: widget.exercise.nom,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withAlpha(50),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.emoji_events, color: Colors.amber, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Record Personnel Actuel',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        if (hasPR)
                          Text(
                            '${maxWeight.toStringAsFixed(maxWeight % 1 == 0 ? 0 : 1)} kg',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amber),
                          )
                        else
                          Text('Aucun record établi', style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator())),
      error: (e, s) => const SizedBox(),
    );
  }

  Widget _buildViewMode(BuildContext context) {
    final historyAsync = ref.watch(exerciseHistoryProvider(widget.exercise.id));

    return historyAsync.when(
      data: (history) {
        // history is sorted desc. Let's make an asc list for charting
        final ascHistory = history.reversed.toList();
        
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressChart(ascHistory),
              const SizedBox(height: 24),

              const Text('Réglages / Notes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Ex: Hauteur siège 3, position pieds…',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: _saveNotes,
                  icon: const Icon(Icons.save, size: 18),
                  label: const Text('Enregistrer les notes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const Divider(height: 32),
              
              const Text('Dernières performances', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              if (history.isEmpty) 
                const Text('Aucun historique pour le moment.', style: TextStyle(fontStyle: FontStyle.italic)),
              if (history.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: history.length > 3 ? 3 : history.length,
                  itemBuilder: (context, index) {
                    final item = history[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(30),
                          child: Icon(Icons.history, color: Theme.of(context).colorScheme.primary),
                        ),
                        title: Text('${item.date.day}/${item.date.month}/${item.date.year}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(_formatSeriesDisplay(item.series)),
                      ),
                    );
                  },
                ),
              if (history.length > 3)
                Center(
                  child: TextButton.icon(
                    onPressed: () => _showFullHistory(context, history),
                    icon: const Icon(Icons.list),
                    label: const Text('Voir tout l\'historique'),
                  ),
                ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Erreur: $err')),
    );
  }

  Widget _buildProgressChart(List<ExerciseHistory> ascHistory) {
    if (ascHistory.length < 2) {
      return Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.withAlpha(20),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withAlpha(40)),
        ),
        child: const Column(
          children: [
            Icon(Icons.show_chart, color: Colors.grey, size: 40),
            SizedBox(height: 8),
            Text(
              'Continuez à vous entraîner pour débloquer le graphique de progression.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      );
    }

    final List<FlSpot> spots = [];
    double minX = 0;
    double maxX = (ascHistory.length - 1).toDouble();
    double minY = double.infinity;
    double maxY = 0;

    for (int i = 0; i < ascHistory.length; i++) {
      final maxW = _calculateMaxWeight(ascHistory[i].series);
      spots.add(FlSpot(i.toDouble(), maxW));
      if (maxW < minY) minY = maxW;
      if (maxW > maxY) maxY = maxW;
    }

    if (minY == double.infinity) minY = 0;
    minY = (minY - 5).clamp(0, double.infinity);
    maxY += 5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Progression de la charge', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        Container(
          height: 200,
          padding: const EdgeInsets.fromLTRB(16, 24, 24, 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          ),
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: true, drawVerticalLine: false),
              titlesData: FlTitlesData(
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text('${value.toInt()}kg', style: const TextStyle(fontSize: 10, color: Colors.grey));
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: minX,
              maxX: maxX,
              minY: minY,
              maxY: maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: Theme.of(context).colorScheme.primary,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Theme.of(context).colorScheme.primary.withAlpha(30),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showEditExerciseDialog(BuildContext context) {
    final nomCtrl = TextEditingController(text: widget.exercise.nom);
    String? selectedMuscle = widget.exercise.musclePrincipal;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Modifier l\'exercice'),
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
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () async {
                if (nomCtrl.text.isNotEmpty && selectedMuscle != null) {
                  setState(() {
                    widget.exercise.nom = nomCtrl.text;
                    widget.exercise.musclePrincipal = selectedMuscle!;
                  });
                  await ref.read(databaseProvider).saveExercise(widget.exercise);
                  ref.invalidate(exercisesProvider);
                  // Rafraîchir aussi les stats et programmes car le nom/muscle change
                  ref.invalidate(workoutProgramsProvider);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullHistory(BuildContext context, List<ExerciseHistory> fullHistory) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text('Historique Complet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: fullHistory.length,
                itemBuilder: (context, index) {
                  final item = fullHistory[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(30),
                        child: Icon(Icons.history, color: Theme.of(context).colorScheme.primary),
                      ),
                      title: Text('${item.date.day}/${item.date.month}/${item.date.year}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(_formatSeriesDisplay(item.series)),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteExercise(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer l\'exercice ?'),
        content: const Text(
            'Cela supprimera DEFINITIVEMENT tout l\'historique et les records liés, et le retirera de vos programmes.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(databaseProvider).deleteExercise(widget.exercise.id);
              
              // On rafraîchit tout car l'exercice est partout
              ref.invalidate(exercisesProvider);
              ref.invalidate(workoutProgramsProvider);
              ref.invalidate(scheduledWorkoutsProvider);
              ref.invalidate(personalRecordsProvider(widget.exercise.id));
              
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
