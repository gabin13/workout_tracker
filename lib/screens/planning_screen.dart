import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/scheduled_workout_provider.dart';
import '../providers/program_provider.dart';
import '../providers/database_provider.dart';
import '../models/scheduled_workout.dart';

class PlanningScreen extends ConsumerStatefulWidget {
  const PlanningScreen({super.key});

  @override
  ConsumerState<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends ConsumerState<PlanningScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final scheduledAsync = ref.watch(scheduledWorkoutsProvider);
    final programsAsync = ref.watch(workoutProgramsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Planning')),
      body: scheduledAsync.when(
        data: (scheduledList) {
          return Column(
            children: [
              TableCalendar(
                firstDay: DateTime.now().subtract(const Duration(days: 365)),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _showAssignProgramSheet(context, selectedDay);
                },
                eventLoader: (day) => scheduledList
                    .where((s) => isSameDay(s.datePrevue, day))
                    .toList(),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isEmpty) return const SizedBox();
                    return Positioned(
                      bottom: 1,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: scheduledList
                      .where((s) => _selectedDay != null && isSameDay(s.datePrevue, _selectedDay!))
                      .length,
                  itemBuilder: (context, index) {
                    final events = scheduledList
                        .where((s) => _selectedDay != null && isSameDay(s.datePrevue, _selectedDay!))
                        .toList();
                    final event = events[index];
                    return programsAsync.maybeWhen(
                      data: (programs) {
                        final program = programs.where((p) => p.id == event.workoutProgramId).firstOrNull;
                        return ListTile(
                          leading: Icon(
                            event.isCompleted ? Icons.check_circle : Icons.schedule,
                            color: event.isCompleted ? Colors.green : Colors.deepPurpleAccent,
                          ),
                          title: Text(program?.nom ?? 'Programme inconnu'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _confirmDeleteSession(context, event),
                          ),
                        );
                      },
                      orElse: () => const ListTile(title: Text('Chargement...')),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erreur: $err')),
      ),
    );
  }

  void _showAssignProgramSheet(BuildContext context, DateTime day) async {
    final db = ref.read(databaseProvider);
    final programs = await db.getAllPrograms();

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assigner un programme — ${day.day}/${day.month}/${day.year}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              if (programs.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Aucun programme créé. Rendez-vous dans l\'onglet Exos.'),
                )
              else
                ...programs.map((p) => ListTile(
                      leading: const Icon(Icons.list_alt),
                      title: Text(p.nom),
                      subtitle: Text('${p.exercises.length} exercice(s)'),
                      onTap: () async {
                        final session = ScheduledWorkout()
                          ..datePrevue = day
                          ..workoutProgramId = p.id
                          ..isCompleted = false;
                        await ref.read(databaseProvider).saveScheduledSession(session);
                        ref.invalidate(scheduledWorkoutsProvider);
                        if (ctx.mounted) Navigator.pop(ctx);
                      },
                    )),
            ],
          ),
        );
      },
    );
  }

  void _confirmDeleteSession(BuildContext context, ScheduledWorkout session) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer cette séance ?'),
        content: const Text('Voulez-vous retirer cette séance de votre planning ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(databaseProvider).deleteScheduledSession(session.id);
              ref.invalidate(scheduledWorkoutsProvider);
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
