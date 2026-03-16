import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/exercise.dart';
import '../models/exercise_history.dart';
import '../providers/database_provider.dart';
import '../providers/history_provider.dart';

class ExerciseDetailScreen extends ConsumerStatefulWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  ConsumerState<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends ConsumerState<ExerciseDetailScreen> {
  late TextEditingController _notesController;
  final List<Map<String, double>> _currentSeries = [];

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.exercise.notesReglagesMachine);
    // Commencer avec une série vide
    _addSerie();
  }

  void _addSerie() {
    setState(() {
      _currentSeries.add({'poids': 0, 'reps': 0});
    });
  }

  void _removeSerie(int index) {
    setState(() {
      _currentSeries.removeAt(index);
    });
  }

  Future<void> _saveSession() async {
    final db = ref.read(databaseProvider);
    
    // 1. Sauvegarder les notes si elles ont changé
    if (_notesController.text != widget.exercise.notesReglagesMachine) {
      widget.exercise.notesReglagesMachine = _notesController.text;
      await db.saveExercise(widget.exercise);
    }

    // 2. Sauvegarder l'historique
    if (_currentSeries.any((s) => (s['poids'] ?? 0) > 0 || (s['reps'] ?? 0) > 0)) {
      final history = ExerciseHistory()
        ..exerciseId = widget.exercise.id
        ..date = DateTime.now()
        ..series = jsonEncode(_currentSeries.where((s) => (s['poids'] ?? 0) > 0).toList());
      
      await db.saveHistory(history);
      ref.invalidate(exerciseHistoryProvider(widget.exercise.id));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Performance enregistrée !')),
        );
        setState(() {
          _currentSeries.clear();
          _addSerie();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(exerciseHistoryProvider(widget.exercise.id));

    return Scaffold(
      appBar: AppBar(title: Text(widget.exercise.nom)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(height: 24),
            const Text('Performance du jour', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            ...List.generate(_currentSeries.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    CircleAvatar(radius: 14, child: Text('${index + 1}')),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Poids (kg)', border: OutlineInputBorder()),
                        onChanged: (val) => _currentSeries[index]['poids'] = double.tryParse(val) ?? 0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Reps', border: OutlineInputBorder()),
                        onChanged: (val) => _currentSeries[index]['reps'] = double.tryParse(val) ?? 0,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                      onPressed: () => _removeSerie(index),
                    ),
                  ],
                ),
              );
            }),
            TextButton.icon(
              onPressed: _addSerie,
              icon: const Icon(Icons.add),
              label: const Text('Ajouter une série'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveSession,
                icon: const Icon(Icons.save),
                label: const Text('Enregistrer la séance'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const Divider(height: 48),
            const Text('Historique', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            historyAsync.when(
              data: (history) {
                if (history.isEmpty) return const Text('Aucun historique pour le moment.');
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final item = history[index];
                    final List<dynamic> series = jsonDecode(item.series);
                    return Card(
                      child: ListTile(
                        title: Text('${item.date.day}/${item.date.month}/${item.date.year}'),
                        subtitle: Text(
                          series.map((s) => '${s['poids']}kg x ${s['reps']}').join(' | '),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Erreur: $err'),
            ),
          ],
        ),
      ),
    );
  }
}
