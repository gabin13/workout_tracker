import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/exercise_provider.dart';
import '../models/exercise.dart';
import '../providers/database_provider.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(exercisesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bibliothèque d\'Exercices'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => ref.read(searchTargetProvider.notifier).state = value,
              decoration: InputDecoration(
                hintText: 'Rechercher un exercice...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).cardTheme.color,
              ),
            ),
          ),
        ),
      ),
      body: exercisesAsync.when(
        data: (exercises) {
          if (exercises.isEmpty) {
            return const Center(child: Text('Aucun exercice trouvé.'));
          }
          return ListView.builder(
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final ex = exercises[index];
              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.fitness_center),
                ),
                title: Text(ex.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(ex.musclePrincipal),
                onTap: () {
                  // TODO: Ouvrir la vue détaillée de l'exercice
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddExerciseDialog(context, ref);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddExerciseDialog(BuildContext context, WidgetRef ref) {
    final nomCtrl = TextEditingController();
    final muscleCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nouvel Exercice'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomCtrl,
                decoration: const InputDecoration(labelText: 'Nom de l\'exercice'),
              ),
              TextField(
                controller: muscleCtrl,
                decoration: const InputDecoration(labelText: 'Muscle principal'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nomCtrl.text.isNotEmpty && muscleCtrl.text.isNotEmpty) {
                  final ex = Exercise()
                    ..nom = nomCtrl.text
                    ..musclePrincipal = muscleCtrl.text;
                  await ref.read(databaseProvider).saveExercise(ex);
                  // Refresh la liste
                  ref.invalidate(exercisesProvider);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text('Ajouter'),
            )
          ],
        );
      },
    );
  }
}
