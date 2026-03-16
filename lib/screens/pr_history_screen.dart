import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/personal_record.dart';
import '../providers/database_provider.dart';
import '../providers/pr_provider.dart';

class PRHistoryScreen extends ConsumerWidget {
  final int exerciseId;
  final String exerciseNom;

  const PRHistoryScreen({
    super.key,
    required this.exerciseId,
    required this.exerciseNom,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prAsync = ref.watch(personalRecordsProvider(exerciseId));

    return Scaffold(
      appBar: AppBar(title: Text('Records — $exerciseNom')),
      body: prAsync.when(
        data: (records) {
          if (records.isEmpty) {
            return const Center(child: Text('Aucun record enregistré.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.emoji_events, color: Colors.amber),
                  title: Text('${record.poidsMax} kg', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Text('${record.date.day}/${record.date.month}/${record.date.year}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () async {
                      await ref.read(databaseProvider).deleteRecord(record.id);
                      ref.invalidate(personalRecordsProvider(exerciseId));
                    },
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erreur: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPRDialog(context, ref),
        label: const Text('Ajouter un PR'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showAddPRDialog(BuildContext context, WidgetRef ref) async {
    final poidsCtrl = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouveau Record Personnel'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: poidsCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Poids (kg)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            StatefulBuilder(
              builder: (context, setState) => ListTile(
                title: const Text('Date du record'),
                subtitle: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => selectedDate = picked);
                  }
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              final poids = double.tryParse(poidsCtrl.text);
              if (poids != null) {
                final record = PersonalRecord()
                  ..exerciseId = exerciseId
                  ..poidsMax = poids
                  ..date = selectedDate;
                await ref.read(databaseProvider).saveRecord(record);
                ref.invalidate(personalRecordsProvider(exerciseId));
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}
