import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/program_provider.dart';
import '../providers/scheduled_workout_provider.dart';
import '../providers/health_provider.dart';
import '../providers/nutrition_provider.dart';
import 'settings_screen.dart';
import 'workouts/active_session_screen.dart';
import 'main_screen.dart'; // Pour le provider d'index
import 'health/steps_details_screen.dart';
import 'health/calories_details_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Dashboard'),
        centerTitle: true,
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- SECTION HAUT : Séance du jour ---
              _buildTopSection(context, ref),
              const SizedBox(height: 16),
              
              // --- SECTION MILIEU : Mini Dashboard Santé ---
              _buildMiddleSection(context, ref),
              const SizedBox(height: 16),

              // --- SECTION BAS : Mini Dashboard Nutrition ---
              _buildBottomSection(context, ref),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. SECTION HAUT : Séance du Jour
  // ---------------------------------------------------------------------------
  Widget _buildTopSection(BuildContext context, WidgetRef ref) {
    final scheduledAsync = ref.watch(scheduledWorkoutsProvider);
    final programsAsync = ref.watch(workoutProgramsProvider);

    return scheduledAsync.when(
      data: (sessions) {
        final today = DateTime.now();
        final todaySession = sessions.where((s) => isSameDay(s.datePrevue, today)).firstOrNull;

        if (todaySession == null) {
          // Jour de repos
          return _buildWorkOutCard(
            context,
            title: 'Jour de repos',
            subtitle: 'Prenez le temps de récupérer',
            icon: Icons.hotel_class_outlined,
            colors: [Colors.blueGrey.shade400, Colors.blueGrey.shade700],
          );
        }

        return programsAsync.when(
          data: (programs) {
            final program = programs.where((p) => p.id == todaySession.workoutProgramId).firstOrNull;
            if (program == null) {
              return _buildWorkOutCard(
                context,
                title: 'Programme introuvable',
                subtitle: '',
                icon: Icons.error_outline,
                colors: [Colors.red.shade400, Colors.red.shade700],
              );
            }

            if (todaySession.isCompleted) {
              return _buildWorkOutCard(
                context,
                title: 'Séance Validée ✅',
                subtitle: program.nom.toUpperCase(),
                icon: Icons.emoji_events,
                colors: [Colors.green.shade400, Colors.green.shade800],
                bottomWidget: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '${program.exercises.length} exercices réalisés',
                    style: const TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
                  ),
                ),
              );
            }

            // Séance prévue
            return _buildWorkOutCard(
              context,
              title: 'Séance du jour',
              subtitle: program.nom.toUpperCase(),
              icon: Icons.fitness_center,
              colors: [Theme.of(context).primaryColor, Colors.indigo],
              bottomWidget: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActiveSessionScreen(
                          session: todaySession,
                          program: program,
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.play_arrow, color: Theme.of(context).primaryColor),
                  label: Text('Démarrer la séance', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 0,
                  ),
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Erreur: $err')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Erreur: $err')),
    );
  }

  Widget _buildWorkOutCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> colors,
    Widget? bottomWidget,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.last.withAlpha(25),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white.withAlpha(200)),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                textAlign: TextAlign.center,
              ),
            ],
            if (bottomWidget != null) bottomWidget,
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. SECTION MILIEU : Dashboard Santé (Pas & Calories Brûlées)
  // ---------------------------------------------------------------------------
  Widget _buildMiddleSection(BuildContext context, WidgetRef ref) {
    final healthDataAsync = ref.watch(todayHealthDataProvider);

    return Column(
      children: [
        // En-tête interactif Santé
        InkWell(
          onTap: () => ref.read(navigationIndexProvider.notifier).state = 3, // Santé
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Text('Santé', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600, fontSize: 18)),
                const Spacer(),
                Icon(Icons.arrow_forward_ios_rounded, color: Theme.of(context).primaryColor, size: 18),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: healthDataAsync.when(
            data: (data) {
              final steps = data['steps'] ?? 0;
              final calories = data['calories'] ?? 0;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
            Expanded(
              flex: 1,
              child: _buildSquareCard(
                context,
                title: 'Pas',
                value: steps.toString(),
                icon: Icons.directions_walk,
                color: Colors.blueAccent,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StepsDetailsScreen())),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: _buildSquareCard(
                context,
                title: 'Brûlées',
                value: '$calories kcal',
                icon: Icons.local_fire_department,
                color: Colors.orangeAccent,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CaloriesDetailsScreen())),
              ),
            ),
          ],
            );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => const Center(child: Icon(Icons.favorite_outline, color: Colors.grey)),
          ),
        ),
      ],
    );
  }

  Widget _buildSquareCard(BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 130,
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
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Positioned(
              right: 12,
              top: 12,
              child: Icon(Icons.chevron_right, color: color.withAlpha(150)),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 40, color: color),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 3. SECTION BAS : Dashboard Nutrition (Calories Consommées)
  // ---------------------------------------------------------------------------
  Widget _buildBottomSection(BuildContext context, WidgetRef ref) {
    final goalAsync = ref.watch(nutritionGoalProvider);
    final logAsync = ref.watch(dailyNutritionLogProvider);

    return Column(
      children: [
        // En-tête Nutrition
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Text('Nutrition', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600, fontSize: 18)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: goalAsync.when(
            data: (goal) {
              return logAsync.when(
                data: (log) {
            // Calculer les calories mangées depuis les meals
            int totalEaten = 0;
            for (var m in log.entries) {
              totalEaten += m.calories;
            }

            final progress = goal.calories > 0 ? (totalEaten / goal.calories) : 0.0;
            final isOver = totalEaten > goal.calories;

            return Container(
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
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                        Row(
                          children: [
                            const Icon(Icons.restaurant, color: Colors.green, size: 28),
                            const SizedBox(width: 8),
                            Text(
                              'Nutrition',
                              style: TextStyle(color: Colors.grey[600], fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                            const Spacer(),
                            Text(
                              '$totalEaten / ${goal.calories} kcal',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isOver ? Colors.redAccent : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress.clamp(0.0, 1.0),
                            minHeight: 8,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isOver ? Colors.redAccent : Colors.green,
                            ),
                          ),
                        ),
                          ],
                        ),
                      ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => const Center(child: Text('Log non trouvé')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => const Center(child: Text('Objectif non défini')),
    ),
    ),
    ],
    );
  }
}
