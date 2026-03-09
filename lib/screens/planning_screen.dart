import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/scheduled_workout_provider.dart';
import '../models/scheduled_workout.dart';
import '../providers/database_provider.dart';
import '../main.dart'; // Pour accéder au notificationService

class PlanningScreen extends ConsumerStatefulWidget {
  const PlanningScreen({super.key});

  @override
  ConsumerState<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends ConsumerState<PlanningScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<ScheduledWorkout> _getEventsForDay(DateTime day, List<ScheduledWorkout> allScheduled) {
    return allScheduled.where((s) => isSameDay(s.datePrevue, day)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final scheduledAsync = ref.watch(scheduledWorkoutsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planning'),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            tooltip: 'Générateur Récurrent',
            onPressed: () => _showRecurrenceGenerator(context, ref),
          )
        ],
      ),
      body: scheduledAsync.when(
        data: (scheduledList) {
          final eventsList = _selectedDay == null 
              ? <ScheduledWorkout>[] 
              : _getEventsForDay(_selectedDay!, scheduledList);

          return Column(
            children: [
              TableCalendar<ScheduledWorkout>(
                firstDay: DateTime.now().subtract(const Duration(days: 365)),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                eventLoader: (day) => _getEventsForDay(day, scheduledList),
                calendarStyle: CalendarStyle(
                  markerDecoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isEmpty) return const SizedBox();
                    // Différencier par couleur selon "isCompleted"
                    final hasCompleted = events.any((e) => e.isCompleted);
                    return Positioned(
                      bottom: 1,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hasCompleted ? Colors.green : Colors.blueAccent,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: eventsList.length,
                  itemBuilder: (context, index) {
                    final event = eventsList[index];
                    return ListTile(
                      leading: Icon(
                        event.isCompleted ? Icons.check_circle : Icons.schedule,
                        color: event.isCompleted ? Colors.green : Colors.blueAccent,
                      ),
                      title: Text(event.programmeNom),
                      subtitle: const Text('17:30 scheduled'),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
      ),
    );
  }

  void _showRecurrenceGenerator(BuildContext context, WidgetRef ref) {
    final nomProgramCtrl = TextEditingController(text: 'Programme A');
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Générer un cycle (4 sem.)'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomProgramCtrl,
                decoration: const InputDecoration(labelText: 'Nom du Programme'),
              ),
              const SizedBox(height: 8),
              const Text('Ceci créera une séance chaque Lundi pendant 4 semaines, avec rappel.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                final baseDate = DateTime.now();
                // Chercher le prochain Lundi
                int daysToAdd = (DateTime.monday - baseDate.weekday) % 7;
                if (daysToAdd <= 0) daysToAdd += 7; // Semaine pro si déjà passé ou ajd

                final db = ref.read(databaseProvider);
                
                for (int i = 0; i < 4; i++) {
                  final scheduledDate = baseDate.add(Duration(days: daysToAdd + (i * 7)));
                  final sw = ScheduledWorkout()
                    ..programmeNom = nomProgramCtrl.text
                    ..datePrevue = scheduledDate
                    ..isCompleted = false;

                  await db.isar.writeTxn(() async {
                    await db.isar.scheduledWorkouts.put(sw);
                  });

                  // Notification locale à 17h30 (Heure fixée dans le NotificationService)
                  // On donne l'ID basé sur l'ID généré de scheduled workout
                  await notificationService.scheduleWorkoutReminder(
                    sw.id, sw.programmeNom, scheduledDate
                  );
                }
                
                ref.invalidate(scheduledWorkoutsProvider);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Générer'),
            )
          ],
        );
      },
    );
  }
}
