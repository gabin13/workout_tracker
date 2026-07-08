import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart'; // REQUIRED for Isar QueryBuilder extensions like findFirst()
import '../utils/ux_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../utils/formatters.dart';
import '../providers/nutrition_provider.dart';
import '../models/nutrition.dart';
import 'settings_screen.dart';
import '../providers/database_provider.dart';
import 'nutrition/add_food_screen.dart';

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
                CustomPageRoute(page: const SettingsScreen()),
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
                      error: (e, s) => Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.red.withAlpha(20),
                        child: Text('Erreur Log: $e\n$s', style: const TextStyle(color: Colors.red)),
                      ),
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, s) => Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.red.withAlpha(20),
                      child: Text('Erreur Goal: $e\n$s', style: const TextStyle(color: Colors.red)),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // C. Journal des Repas
                  logAsync.when(
                    data: (log) => _buildMealList(context, ref, log),
                    loading: () => const SizedBox.shrink(),
                    error: (e, s) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Erreur MealList: $e', style: const TextStyle(color: Colors.red)),
                      ),
                    ),
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
    double totalKcal = 0;
    double totalProt = 0;
    double totalGluc = 0;
    double totalLip = 0;
    double totalFib = 0;

    for (var entry in log.entries) {
      totalProt += entry.proteines;
      totalGluc += entry.glucides;
      totalLip += entry.lipides;
      totalFib += entry.fibres ?? 0.0;
    }
    totalKcal = (totalProt * 4.0) + (totalGluc * 4.0) + (totalLip * 9.0);

    final kcalRemaining = goal.calories - totalKcal;
    final kcalPercent = goal.calories > 0 ? (totalKcal / goal.calories).clamp(0.0, 1.0) : 0.0;
    final overLimit = totalKcal > goal.calories;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
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
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: kcalPercent),
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return CircularProgressIndicator(
                        value: value,
                        strokeWidth: 12,
                        backgroundColor: Colors.deepPurpleAccent.withAlpha(30),
                        valueColor: AlwaysStoppedAnimation<Color>(overLimit ? Colors.redAccent : Colors.deepPurpleAccent),
                      );
                    },
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      kcalRemaining.abs().formatMacro(),
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    Text(
                      overLimit ? 'Kcal en trop' : 'Kcal restantes',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
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
                _buildMacroGauge('Fib', totalFib, goal.fibres ?? 30.0, Colors.brown[400]!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroGauge(String label, double current, double target, Color color) {
    final percent = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: percent),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: 5,
                  backgroundColor: color.withAlpha(30),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
          Text('${current.formatMacro()}/${target.formatMacro()}g', style: TextStyle(fontSize: 10, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildMealList(BuildContext context, WidgetRef ref, DailyNutritionLog log) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text('Journal des Repas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        if (log.entries.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.eco_rounded, size: 64, color: Theme.of(context).primaryColor.withAlpha(100)),
                const SizedBox(height: 16),
                const Text(
                  "Votre journée commence ici.\nQu'avez-vous mangé ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        _buildMealCard(context, ref, log, MealType.petitDejeuner, 'Petit-déjeuner', Icons.wb_sunny_outlined),
        _buildMealCard(context, ref, log, MealType.dejeuner, 'Déjeuner', Icons.light_mode_outlined),
        _buildMealCard(context, ref, log, MealType.diner, 'Dîner', Icons.nights_stay_outlined),
        _buildMealCard(context, ref, log, MealType.collation, 'Collations', Icons.apple_outlined),
      ],
    );
  }

  Widget _buildMealCard(BuildContext context, WidgetRef ref, DailyNutritionLog log, MealType type, String title, IconData icon) {
    final entries = log.entries.where((e) => e.mealType == type).toList();
    final hasEntries = entries.isNotEmpty;

    double kcal = 0;
    double prot = 0;
    double gluc = 0;
    double lip = 0;
    double fib = 0;

    for (var e in entries) {
      prot += e.proteines;
      gluc += e.glucides;
      lip += e.lipides;
      fib += e.fibres ?? 0.0;
    }
    kcal = (prot * 4.0) + (gluc * 4.0) + (lip * 9.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            HapticFeedback.selectionClick();
            _showMealDetailsSheet(context, ref, log, type, title, icon);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _getMealColor(type).withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: _getMealColor(type)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 4), 
                      Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).primaryColor)),
                      const SizedBox(height: 4),
                      if (hasEntries)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('${kcal.formatMacro()} kcal • ${entries.length} aliment(s)', style: TextStyle(color: Colors.grey[600]), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'P:${prot.formatMacro()}g • G:${gluc.formatMacro()}g • L:${lip.formatMacro()}g • F:${fib.formatMacro()}g',
                                style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        )
                      else
                        Text('Aucun aliment saisi', style: TextStyle(color: Colors.grey[400])),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.deepPurpleAccent),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.push(
                      context,
                      CustomPageRoute(page: AddFoodScreen(dailyLog: log, mealType: type)),
                    );
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  alignment: Alignment.topRight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getMealColor(MealType type) {
    switch (type) {
      case MealType.petitDejeuner: return Colors.orange;
      case MealType.dejeuner: return Colors.blue;
      case MealType.diner: return Colors.indigo;
      case MealType.collation: return Colors.green;
    }
  }

  void _showMealDetailsSheet(BuildContext context, WidgetRef ref, DailyNutritionLog log, MealType type, String title, IconData icon) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _MealDetailsSheet(log: log, type: type, title: title, icon: icon),
    );
  }

  void _showMealForm(BuildContext context, WidgetRef ref, DailyNutritionLog log, MealType type, MealEntry? existing) {
    final kcalController = TextEditingController(text: existing?.calories.formatMacro() ?? '');
    final protController = TextEditingController(text: existing?.proteines.formatMacro() ?? '');
    final glucController = TextEditingController(text: existing?.glucides.formatMacro() ?? '');
    final lipController = TextEditingController(text: existing?.lipides.formatMacro() ?? '');
    final fibController = TextEditingController(text: existing?.fibres?.formatMacro() ?? '');
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
                   const SizedBox(width: 12),
                   Expanded(child: _buildNumField(fibController, 'Fibres', 'g')),
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
                  entry.calories = double.tryParse(kcalController.text.replaceAll(',', '.')) ?? 0.0;
                  entry.proteines = double.tryParse(protController.text.replaceAll(',', '.')) ?? 0.0;
                  entry.glucides = double.tryParse(glucController.text.replaceAll(',', '.')) ?? 0.0;
                  entry.lipides = double.tryParse(lipController.text.replaceAll(',', '.')) ?? 0.0;
                  entry.fibres = double.tryParse(fibController.text.replaceAll(',', '.')) ?? 0.0;
                  entry.notes = notesController.text;

                  final service = ref.read(nutritionServiceProvider);
                  await service.saveMealEntry(entry, log.id);
                  
                  // Rafraîchir
                  ref.invalidate(dailyNutritionLogProvider);
                  if (context.mounted) Navigator.pop(context);
                },
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
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*[,.]?\d*'))],
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

    final kcalController = TextEditingController(text: goal.calories.formatMacro());
    final protController = TextEditingController(text: goal.proteines.formatMacro());
    final glucController = TextEditingController(text: goal.glucides.formatMacro());
    final lipController = TextEditingController(text: goal.lipides.formatMacro());
    final fibController = TextEditingController(text: (goal.fibres ?? 30.0).formatMacro());

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
                   const SizedBox(width: 12),
                   Expanded(child: _buildNumField(fibController, 'Fibres', 'g')),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  goal.calories = double.tryParse(kcalController.text.replaceAll(',', '.')) ?? goal.calories;
                  goal.proteines = double.tryParse(protController.text.replaceAll(',', '.')) ?? goal.proteines;
                  goal.glucides = double.tryParse(glucController.text.replaceAll(',', '.')) ?? goal.glucides;
                  goal.lipides = double.tryParse(lipController.text.replaceAll(',', '.')) ?? goal.lipides;
                  goal.fibres = double.tryParse(fibController.text.replaceAll(',', '.')) ?? goal.fibres;

                  await ref.read(nutritionServiceProvider).updateGoal(goal);
                  ref.invalidate(nutritionGoalProvider);
                  if (context.mounted) Navigator.pop(context);
                },
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

// -----------------------------------------------------------------------------
// Bottom Sheet des Détails du Repas (Journal Interactif)
// -----------------------------------------------------------------------------
class _MealDetailsSheet extends ConsumerWidget {
  final DailyNutritionLog log;
  final MealType type;
  final String title;
  final IconData icon;

  const _MealDetailsSheet({
    required this.log,
    required this.type,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Écoute des mises à jour en direct depuis le provider
    final dailyLogAsync = ref.watch(dailyNutritionLogProvider);
    final currentLog = dailyLogAsync.value ?? log;
    final entries = currentLog.entries.where((e) => e.mealType == type).toList();

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(240),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(width: 48, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(3))),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            if (entries.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 32.0),
                child: Column(
                  children: [
                    Icon(Icons.restaurant_menu, size: 48, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text("Aucun aliment ajouté.", style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                  ],
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: entries.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, indent: 24, endIndent: 24),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return Dismissible(
                      key: Key('meal_entry_${entry.id}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24),
                        color: Colors.redAccent.withAlpha(40),
                        child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 28),
                      ),
                      onDismissed: (_) async {
                        HapticFeedback.mediumImpact();
                        final service = ref.read(nutritionServiceProvider);
                        await service.deleteMealEntry(entry.id, currentLog.id);
                        ref.invalidate(dailyNutritionLogProvider);
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        title: Text(entry.notes ?? 'Aliment inconnu', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Row(
                            children: [
                              Text('${entry.calories.formatMacro()} kcal', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              const SizedBox(width: 8),
                              _buildMacroTag('P', entry.proteines, Colors.blueAccent),
                              const SizedBox(width: 4),
                              _buildMacroTag('G', entry.glucides, Colors.orangeAccent),
                              const SizedBox(width: 4),
                              _buildMacroTag('L', entry.lipides, Colors.redAccent),
                              const SizedBox(width: 4),
                              _buildMacroTag('F', entry.fibres ?? 0.0, Colors.brown[400]!),
                            ],
                          ),
                        ),
                        trailing: Icon(Icons.edit_outlined, size: 22, color: Theme.of(context).primaryColor),
                        onTap: () {
                           HapticFeedback.selectionClick();
                           _showEditPortionSheet(context, ref, entry, currentLog);
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroTag(String label, double value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Text(
        '$label: ${value.formatMacro()}g',
        style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showEditPortionSheet(BuildContext context, WidgetRef ref, MealEntry entry, DailyNutritionLog log) {
    showModalBottomSheet(
       context: context,
       isScrollControlled: true,
       backgroundColor: Colors.transparent,
       builder: (context) => _EditPortionSheet(entry: entry, dailyLog: log),
    );
  }
}

// -----------------------------------------------------------------------------
// Bottom Sheet d'Edition de Portion (Recalcul)
// -----------------------------------------------------------------------------
class _EditPortionSheet extends ConsumerStatefulWidget {
  final MealEntry entry;
  final DailyNutritionLog dailyLog;

  const _EditPortionSheet({required this.entry, required this.dailyLog});

  @override
  ConsumerState<_EditPortionSheet> createState() => _EditPortionSheetState();
}

class _EditPortionSheetState extends ConsumerState<_EditPortionSheet> {
  late TextEditingController _gramsController;
  int _originalGrams = 100;
  String _baseName = 'Aliment';
  int _grams = 100;
  
  // Macros originelles
  late double _baseKcal;
  late double _baseProt;
  late double _baseGluc;
  late double _baseLip;
  late double _baseFib;

  @override
  void initState() {
    super.initState();
    _baseKcal = widget.entry.calories;
    _baseProt = widget.entry.proteines;
    _baseGluc = widget.entry.glucides;
    _baseLip = widget.entry.lipides;
    _baseFib = widget.entry.fibres ?? 0.0;
    
    // Extraction des grammes via regex
    final regex = RegExp(r'\s*\((\d+)g\)$');
    final notes = widget.entry.notes ?? '';
    final match = regex.firstMatch(notes);
    
    if (match != null) {
      _originalGrams = int.tryParse(match.group(1) ?? '100') ?? 100;
      _baseName = notes.replaceAll(regex, '').trim();
    } else {
      _baseName = notes;
      _originalGrams = 100;
    }
    
    _grams = _originalGrams;
    _gramsController = TextEditingController(text: _grams.toString());
  }

  @override
  void dispose() {
    _gramsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double currentKcal = (_baseKcal * _grams / _originalGrams);
    double currentProt = (_baseProt * _grams / _originalGrams);
    double currentGluc = (_baseGluc * _grams / _originalGrams);
    double currentLip = (_baseLip * _grams / _originalGrams);
    double currentFib = (_baseFib * _grams / _originalGrams);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(240),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 24),
                child: Container(width: 48, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(3)))
              ),
              Text(
                "Modifier $_baseName",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _gramsController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*[,.]?\d*'))],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      labelText: 'Nouvelle Quantité',
                      suffixText: 'g',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _grams = (double.tryParse(val.replaceAll(',', '.')) ?? 0.0).toInt();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMacroIndicator('Kcal', currentKcal, Colors.deepPurpleAccent),
                _buildMacroIndicator('Prot', currentProt, Colors.blueAccent),
                _buildMacroIndicator('Gluc', currentGluc, Colors.orangeAccent),
                _buildMacroIndicator('Lip', currentLip, Colors.redAccent),
                _buildMacroIndicator('Fib', currentFib, Colors.green),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _grams > 0 ? () async {
                final service = ref.read(nutritionServiceProvider);
                
                widget.entry.calories = currentKcal;
                widget.entry.proteines = currentProt;
                widget.entry.glucides = currentGluc;
                widget.entry.lipides = currentLip;
                widget.entry.fibres = currentFib;
                widget.entry.notes = '$_baseName (${_grams}g)';
                
                await service.saveMealEntry(widget.entry, widget.dailyLog.id);
                ref.invalidate(dailyNutritionLogProvider);
                
                if (context.mounted) {
                  HapticFeedback.heavyImpact();
                  Navigator.pop(context); // fermer éditeur
                }
              } : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('Mettre à jour la portion', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildMacroIndicator(String label, double value, Color color) {
    return Column(
      children: [
        Text(value.formatMacro(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
