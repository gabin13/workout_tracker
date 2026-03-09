import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réglages'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Données',
              style: TextStyle(
                color: Colors.deepPurpleAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Exporter les données (JSON)'),
            subtitle: const Text('Sauvegarder la base de données Isar'),
            onTap: () async {
              // TODO: Implémenter l'export complet en JSON
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fonctionnalité d\'export à venir')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Effacer toutes les données', style: TextStyle(color: Colors.red)),
            onTap: () {
              // TODO: Implémenter la suppression totale
            },
          ),
        ],
      ),
    );
  }
}
