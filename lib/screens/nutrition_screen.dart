import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/nutrition_provider.dart';
import '../models/nutrition.dart';
import 'settings_screen.dart';

class NutritionScreen extends ConsumerStatefulWidget {
  const NutritionScreen({super.key});

  @override
  ConsumerState<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends ConsumerState<NutritionScreen> {
  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedNutritionDateProvider);
    final logAsync = ref.watch(dailyNutritionLogProvider);
    final goalAsync = ref.watch(nutritionGoalProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _showGoalsForm(context, ref),
          ),
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
      body: Column(
        children: [
          // A. Sélecteur de Date
          _buildDateSelector(context, ref, selectedDate),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // B. Dashboard des Objectifs
                  goalAsync.when(
                    data: (goal) => logAsync.when(
                      data: (log) => _buildDashboard(context, goal, log),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, s) => Text('Erreur log: $e'),
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, s) => Text('Erreur goal: $e'),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // C. Journal des Repas
                  logAsync.when(
                    data: (log) => _buildMealList(context, ref, log),
                    loading: () => const SizedBox.shrink(),
                    error: (e, s) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context, WidgetRef ref, DateTime date) {
    final isToday = DateUtils.isSameDay(date, DateTime.now());
    final dateFormat = DateFormat('EEEE d MMMM', 'fr_FR');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Theme.of(context).cardColor.withAlpha(50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              ref.read(selectedNutritionDateProvider.notifier).state = 
                  date.subtract(const Duration(days: 1));
            },
          ),
          Column(
            children: [
              Text(
                isToday ? "Aujourd'hui" : dateFormat.format(date),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              if (!isToday)
                GestureDetector(
                  onTap: () => ref.read(selectedNutritionDateProvider.notifier).state = DateTime.now(),
                  child: Text(
                    "Revenir à aujourd'hui",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              ref.read(selectedNutritionDateProvider.notifier).state = 
                  date.add(const Duration(days: 1));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, NutritionGoal goal, DailyNutritionLog log) {
    // Calcul des totaux
    int totalKcal = 0;
    int totalProt = 0;
    int totalGluc = 0;
    int totalLip = 0;

    for (var entry in log.entries) {
      totalKcal += entry.calories;
      totalProt += entry.proteines;
      totalGluc += entry.glucides;
      totalLip += entry.lipides;
    }

    final kcalRemaining = goal.calories - totalKcal;
    final kcalPercent = (totalKcal / goal.calories).clamp(0.0, 1.0);
    final overLimit = totalKcal > goal.calories;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Jauge Calories
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: kcalPercent,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey.withAlpha(50),
                    color: overLimit ? Colors.redAccent : Theme.of(context).colorScheme.primary,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      kcalRemaining.abs().toString(),
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      overLimit ? 'Kcal en trop' : 'Kcal restantes',
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Macro Jauges
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMacroGauge('Prot', totalProt, goal.proteines, Colors.blueAccent),
                _buildMacroGauge('Gluc', totalGluc, goal.glucides, Colors.orangeAccent),
                _buildMacroGauge('Lip', totalLip, goal.lipides, Colors.redAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroGauge(String label, int current, int target, Color color) {
    final percent = (current / target).clamp(0.0, 1.0);
    return Column(
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            value: percent,
            strokeWidth: 6,
            backgroundColor: Colors.grey.withAlpha(50),
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('$current/${target}g', style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildMealList(BuildContext context, WidgetRef ref, DailyNutritionLog log) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text('Journal des Repas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        _buildMealCard(context, ref, log, MealType.petitDejeuner, 'Petit-déjeuner', Icons.wb_sunny_outlined),
        _buildMealCard(context, ref, log, MealType.dejeuner, 'Déjeuner', Icons.light_mode_outlined),
        _buildMealCard(context, ref, log, MealType.diner, 'Dîner', Icons.nights_stay_outlined),
        _buildMealCard(context, ref, log, MealType.collation, 'Collation', Icons.apple_outlined),
      ],
    );
  }

  Widget _buildMealCard(BuildContext context, WidgetRef ref, DailyNutritionLog log, MealType type, String title, IconData icon) {
    final entries = log.entries.where((e) => e.mealType == type).toList();
    final hasEntries = entries.isNotEmpty;

    int kcal = 0;
    int prot = 0;
    int gluc = 0;
    int lip = 0;
    String notes = '';

    for (var e in entries) {
      kcal += e.calories;
      prot += e.proteines;
      gluc += e.glucides;
      lip += e.lipides;
      if (e.notes != null && e.notes!.isNotEmpty) {
        notes += (notes.isEmpty ? '' : ', ') + e.notes!;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withAlpha(30),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: hasEntries 
          ? Text('$kcal kcal • ${prot}p ${gluc}g ${lip}l\n$notes', maxLines: 2, overflow: TextOverflow.ellipsis)
          : const Text('Aucun aliment saisi'),
        trailing: IconButton(
          icon: Icon(hasEntries ? Icons.edit_outlined : Icons.add_circle_outline),
          onPressed: () => _showMealForm(context, ref, log, type, entries.isNotEmpty ? entries.first : null),
        ),
      ),
    );
  }

  void _showMealForm(BuildContext context, WidgetRef ref, DailyNutritionLog log, MealType type, MealEntry? existing) {
    final kcalController = TextEditingController(text: existing?.calories.toString() ?? '');
    final protController = TextEditingController(text: existing?.proteines.toString() ?? '');
    final glucController = TextEditingController(text: existing?.glucides.toString() ?? '');
    final lipController = TextEditingController(text: existing?.lipides.toString() ?? '');
    final notesController = TextEditingController(text: existing?.notes ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                existing == null ? 'Ajouter ${type.name}' : 'Modifier ${type.name}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                   Expanded(child: _buildNumField(kcalController, 'Calories', 'kcal')),
                   const SizedBox(width: 12),
                   Expanded(child: _buildNumField(protController, 'Protéines', 'g')),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                   Expanded(child: _buildNumField(glucController, 'Glucides', 'g')),
                   const SizedBox(width: 12),
                   Expanded(child: _buildNumField(lipController, 'Lipides', 'g')),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (ex: Poulet, Riz...)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final entry = existing ?? MealEntry();
                  entry.mealType = type;
                  entry.calories = int.tryParse(kcalController.text) ?? 0;
                  entry.proteines = int.tryParse(protController.text) ?? 0;
                  entry.glucides = int.tryParse(glucController.text) ?? 0;
                  entry.lipides = int.tryParse(lipController.text) ?? 0;
                  entry.notes = notesController.text;

                  final service = ref.read(nutritionServiceProvider);
                  await service.saveMealEntry(entry, log.id);
                  
                  // Rafraîchir
                  ref.invalidate(dailyNutritionLogProvider);
                  if (context.mounted) Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Enregistrer'),
              ),
              if (existing != null)
                TextButton(
                  onPressed: () async {
                    final service = ref.read(nutritionServiceProvider);
                    await service.deleteMealEntry(existing.id, log.id);
                    ref.invalidate(dailyNutritionLogProvider);
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text('Supprimer', style: TextStyle(color: Colors.redAccent)),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumField(TextEditingController controller, String label, String suffix) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        border: const OutlineInputBorder(),
      ),
    );
  }

  void _showGoalsForm(BuildContext context, WidgetRef ref) async {
    final goal = await ref.read(nutritionGoalProvider.future);
    if (!context.mounted) return;

    final kcalController = TextEditingController(text: goal.calories.toString());
    final protController = TextEditingController(text: goal.proteines.toString());
    final glucController = TextEditingController(text: goal.glucides.toString());
    final lipController = TextEditingController(text: goal.lipides.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Objectifs Quotidiens',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                   Expanded(child: _buildNumField(kcalController, 'Calories', 'kcal')),
                   const SizedBox(width: 12),
                   Expanded(child: _buildNumField(protController, 'Protéines', 'g')),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                   Expanded(child: _buildNumField(glucController, 'Glucides', 'g')),
                   const SizedBox(width: 12),
                   Expanded(child: _buildNumField(lipController, 'Lipides', 'g')),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  goal.calories = int.tryParse(kcalController.text) ?? goal.calories;
                  goal.proteines = int.tryParse(protController.text) ?? goal.proteines;
                  goal.glucides = int.tryParse(glucController.text) ?? goal.glucides;
                  goal.lipides = int.tryParse(lipController.text) ?? goal.lipides;

                  await ref.read(nutritionServiceProvider).updateGoal(goal);
                  ref.invalidate(nutritionGoalProvider);
                  if (context.mounted) Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Enregistrer'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
