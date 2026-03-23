import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../providers/scheduled_workout_provider.dart';
import '../providers/program_provider.dart';
import '../providers/database_provider.dart';
import '../models/scheduled_workout.dart';
import '../models/workout_program.dart';
import 'settings_screen.dart';

class PlanningScreen extends ConsumerStatefulWidget {
  const PlanningScreen({super.key});

  @override
  ConsumerState<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState extends ConsumerState<PlanningScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final scheduledAsync = ref.watch(scheduledWorkoutsProvider);
    final programsAsync = ref.watch(workoutProgramsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planning'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: scheduledAsync.when(
        data: (scheduledList) {
          return SafeArea(
            child: Column(
              children: [
                // --- CALENDRIER (Haut) ---
                TableCalendar(
                  firstDay: DateTime.now().subtract(const Duration(days: 365)),
                  lastDay: DateTime.now().add(const Duration(days: 365)),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  headerStyle: const HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: const TextStyle(color: Colors.black87),
                    weekendTextStyle: const TextStyle(color: Colors.black87),
                    todayDecoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                    ),
                    todayTextStyle: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                    selectedDecoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    outsideDaysVisible: false,
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  eventLoader: (day) => scheduledList
                      .where((s) => isSameDay(s.datePrevue, day))
                      .toList(),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (events.isEmpty) return const SizedBox();
                      return Positioned(
                        bottom: 6,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.orange, // Accent color
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                
                // --- TITRE AGENDA ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _selectedDay != null 
                          ? 'Programme du ${DateFormat('EEEE d', 'fr_FR').format(_selectedDay!)}'
                          : 'Programme du jour',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // --- VUE AGENDA (Bas) ---
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildAgendaView(context, scheduledList, programsAsync),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erreur: $err')),
      ),
    );
  }

  Widget _buildAgendaView(BuildContext context, List<ScheduledWorkout> scheduledList, AsyncValue<List<WorkoutProgram>> programsAsync) {
    if (_selectedDay == null) return const SizedBox();

    final eventsForDay = scheduledList
        .where((s) => isSameDay(s.datePrevue, _selectedDay!))
        .toList();

    if (eventsForDay.isEmpty) {
      // ÉTAT 2 : Aucune séance
      return Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 40),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Aucune séance prévue',
                style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _showAssignProgramSheet(context, _selectedDay!),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Planifier un programme'),
              ),
            ],
          ),
        ),
      );
    }

    // ÉTAT 1 : Séance prévue
    final event = eventsForDay.first;
    return programsAsync.maybeWhen(
      data: (programs) {
        final program = programs.where((p) => p.id == event.workoutProgramId).firstOrNull;
        if (program == null) return const Text('Programme introuvable');
        
        return Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withAlpha(25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.fitness_center, color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            program.nom.toUpperCase(),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            event.isCompleted ? 'Séance terminée ✅' : '${program.exercises.length} exercices',
                            style: TextStyle(
                              color: event.isCompleted ? Colors.green : Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _confirmDeleteSession(context, event),
                      icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                      label: const Text('Supprimer', style: TextStyle(color: Colors.redAccent)),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () {
                         _showAssignProgramSheet(context, _selectedDay!, eventToDelete: event);
                      },
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Modifier'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      orElse: () => const Center(child: CircularProgressIndicator()),
    );
  }

  void _showAssignProgramSheet(BuildContext context, DateTime day, {ScheduledWorkout? eventToDelete}) async {
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
                        if (eventToDelete != null) {
                           await ref.read(databaseProvider).deleteScheduledSession(eventToDelete.id);
                        }
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
