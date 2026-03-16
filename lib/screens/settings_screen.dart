import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/backup_provider.dart';
import '../providers/database_provider.dart';
import '../providers/exercise_provider.dart';
import '../providers/program_provider.dart';
import '../providers/scheduled_workout_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backupService = ref.watch(backupServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Sécurité & Sauvegarde'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.upload_file, color: Colors.blue),
                  title: const Text('Exporter mes données'),
                  subtitle: const Text('Crée une sauvegarde JSON de vos exercices et programmes.'),
                  onTap: () async {
                    try {
                      await backupService.exportToJSON();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Exportation réussie !')),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erreur lors de l\'export: $e')),
                        );
                      }
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.download, color: Colors.blue),
                  title: const Text('Importer des données'),
                  subtitle: const Text('Restaure vos données depuis un fichier JSON.'),
                  onTap: () => _confirmImport(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildSectionHeader('Zone de Danger'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Effacer toutes les données',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              subtitle: const Text('Supprime définitivement tout votre historique. Action irréversible.'),
              onTap: () => _confirmClearAll(context, ref),
            ),
          ),
          const SizedBox(height: 48),
          const Center(
            child: Text(
              'Workout Tracker v1.0.0\nPhase 3 - Data Security',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  void _confirmImport(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Importer des données ?'),
        content: const Text(
            'Attention, l\'importation écrasera toutes vos données actuelles (exercices, programmes, historique). Voulez-vous continuer ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                // On vide d'abord
                await ref.read(databaseProvider).clearAll();
                // Puis on importe
                await ref.read(backupServiceProvider).importFromJSON();
                
                // On rafraîchit tous les providers
                ref.invalidate(exercisesProvider);
                ref.invalidate(workoutProgramsProvider);
                ref.invalidate(scheduledWorkoutsProvider);
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Importation terminée avec succès !')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur lors de l\'import: $e')),
                  );
                }
              }
            },
            child: const Text('Importer'),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tout effacer ?'),
        content: const Text(
            'Êtes-vous sûr de vouloir supprimer définitivement tout votre historique, vos programmes et vos exercices ? Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(databaseProvider).clearAll();
              
              ref.invalidate(exercisesProvider);
              ref.invalidate(workoutProgramsProvider);
              ref.invalidate(scheduledWorkoutsProvider);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Toutes les données ont été effacées.')),
                );
              }
            },
            child: const Text('TOUT EFFACER', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
