import 'dart:convert';
import 'dart:io';
import 'package:gif_view/gif_view.dart';
import '../utils/ux_utils.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/exercise.dart';
import '../models/exercise_history.dart';
import '../providers/database_provider.dart';
import '../providers/history_provider.dart';
import '../providers/exercise_provider.dart';
import '../providers/program_provider.dart';
import '../providers/scheduled_workout_provider.dart';
import '../providers/pr_provider.dart';
import 'pr_history_screen.dart';
import '../shared/constants.dart';

class ExerciseDetailScreen extends ConsumerStatefulWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  ConsumerState<ExerciseDetailScreen> createState() =>
      _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends ConsumerState<ExerciseDetailScreen> {
  String _selectedPeriod = '2M';

  double _calculateMaxWeight(String seriesData) {
    double maxW = 0.0;
    try {
      if (seriesData.startsWith('[')) {
        final List<dynamic> decoded = jsonDecode(seriesData);
        for (var s in decoded) {
          final w = double.tryParse(s['poids'].toString()) ?? 0.0;
          if (w > maxW) maxW = w;
        }
        return maxW;
      }
    } catch (_) {}

    final parts = seriesData.split(',');
    for (var p in parts) {
      p = p.trim();
      if (p.isEmpty) continue;
      final xIndex = p.indexOf('x');
      final kgIndex = p.indexOf('kg');
      if (xIndex != -1) {
        final weightStr = (kgIndex != -1 && kgIndex > xIndex)
            ? p.substring(xIndex + 1, kgIndex)
            : p.substring(xIndex + 1);
        final w = double.tryParse(weightStr.trim()) ?? 0.0;
        if (w > maxW) maxW = w;
      }
    }
    return maxW;
  }

  List<Widget> _buildSeriesPills(String seriesData) {
    List<Widget> pills = [];

    try {
      if (seriesData.startsWith('[')) {
        final List<dynamic> decoded = jsonDecode(seriesData);
        for (int i = 0; i < decoded.length; i++) {
          final reps = decoded[i]['reps'];
          final poids = decoded[i]['poids'];
          final poidsVal = double.tryParse(poids.toString()) ?? 0;
          final poidsStr = poidsVal % 1 == 0
              ? poidsVal.toInt().toString()
              : poidsVal.toStringAsFixed(1);
          pills.add(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$reps × ${poidsStr}kg',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
            ),
          );
        }
        return pills;
      }
    } catch (_) {}

    // Fallback pour le format legacy
    final parts = seriesData.split(',');
    for (var p in parts) {
      p = p.trim();
      if (p.isEmpty) continue;
      pills.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            p,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ),
      );
    }
    return pills;
  }

  @override
  Widget build(BuildContext context) {
    final prsAsync = ref.watch(personalRecordsProvider(widget.exercise.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.nom),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showEditExerciseDialog(context),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red[400]),
            onPressed: () => _confirmDeleteExercise(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildPRBanner(context, ref, prsAsync),
          Expanded(child: _buildViewMode(context)),
        ],
      ),
    );
  }

  Widget _buildPRBanner(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<dynamic>> prsAsync,
  ) {
    return prsAsync.when(
      data: (prs) {
        double maxWeight = 0;
        DateTime? prDate;

        for (var pr in prs) {
          if (pr.poidsMax > maxWeight) {
            maxWeight = pr.poidsMax;
            prDate = pr.date;
          }
        }

        final bool hasPR = maxWeight > 0;

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LEFT: PR Card
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CustomPageRoute(
                        page: PRHistoryScreen(
                          exerciseId: widget.exercise.id,
                          exerciseNom: widget.exercise.nom,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.amber.withAlpha(20),
                          Colors.orange.withAlpha(12),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.emoji_events,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Record Personnel',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (hasPR) ...[
                            Text(
                              '${maxWeight.toStringAsFixed(maxWeight % 1 == 0 ? 0 : 1)} kg',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFE6A817),
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (prDate != null)
                              Text(
                                '${prDate.day.toString().padLeft(2, '0')}/${prDate.month.toString().padLeft(2, '0')}/${prDate.year}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                          ] else
                            Text(
                              'Aucun record',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontStyle: FontStyle.italic,
                                fontSize: 14,
                              ),
                            ),
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                'Voir l\'historique',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[400],
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                Icons.chevron_right,
                                size: 14,
                                color: Colors.grey[400],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // RIGHT: GIF Demo
              Expanded(
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: _buildDetailGif(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (e, s) => const SizedBox(),
    );
  }

  Widget _buildDetailGif() {
    final path = widget.exercise.imagePath;
    if (path == null || path.isEmpty) {
      return Center(
        child: Icon(Icons.fitness_center, size: 48, color: Colors.grey[300]),
      );
    }
    final isGif = path.toLowerCase().endsWith('.gif');
    if (path.startsWith('/')) {
      if (isGif) {
        return GifView.memory(
          File(path).readAsBytesSync(),
          autoPlay: true,
          loop: true,
          fit: BoxFit.contain,
        );
      }
      return Image.file(File(path), fit: BoxFit.contain);
    }
    if (path.startsWith('http')) {
      if (isGif) {
        return GifView.network(
          path,
          autoPlay: true,
          loop: true,
          fit: BoxFit.contain,
        );
      }
      return Image.network(path, fit: BoxFit.contain);
    }
    if (isGif) {
      return GifView.asset(
        path,
        autoPlay: true,
        loop: true,
        fit: BoxFit.contain,
      );
    }
    return Image.asset(path, fit: BoxFit.contain);
  }

  Widget _buildViewMode(BuildContext context) {
    final historyAsync = ref.watch(exerciseHistoryProvider(widget.exercise.id));

    return historyAsync.when(
      data: (history) {
        final ascHistory = history.reversed.toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressChart(ascHistory),
              const SizedBox(height: 16),

              const Text(
                'Dernières performances',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              if (history.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Aucun historique pour le moment.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              if (history.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: history.length > 3 ? 3 : history.length,
                  itemBuilder: (context, index) {
                    final item = history[index];
                    final maxW = _calculateMaxWeight(item.series);
                    final maxWStr = maxW % 1 == 0
                        ? maxW.toInt().toString()
                        : maxW.toStringAsFixed(1);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            // Left accent bar
                            Container(
                              width: 4,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withAlpha(180),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(14),
                                  bottomLeft: Radius.circular(14),
                                ),
                              ),
                            ),
                            // Content
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  12,
                                  12,
                                  14,
                                  12,
                                ),
                                child: Row(
                                  children: [
                                    // Date + pills
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today_outlined,
                                                size: 13,
                                                color: Colors.grey[400],
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                '${item.date.day.toString().padLeft(2, '0')}/${item.date.month.toString().padLeft(2, '0')}/${item.date.year}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                  color: Colors.grey[500],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Wrap(
                                            spacing: 5,
                                            runSpacing: 5,
                                            children: _buildSeriesPills(
                                              item.series,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Max weight badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary.withAlpha(18),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '$maxWStr',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 18,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                          ),
                                          Text(
                                            'kg',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              if (history.length > 3) ...[
                const SizedBox(height: 16),
                Center(
                  child: TextButton.icon(
                    onPressed: () => _showFullHistory(context, history),
                    icon: const Icon(Icons.list, size: 18),
                    label: const Text('Voir tout l\'historique'),
                  ),
                ),
              ],
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Erreur: $err')),
    );
  }

  Widget _buildProgressChart(List<ExerciseHistory> ascHistory) {
    if (ascHistory.length < 2) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(Icons.show_chart, color: Colors.grey[400], size: 36),
            const SizedBox(height: 8),
            Text(
              'Continuez à vous entraîner pour débloquer le graphique.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }

    // Filter history by selected period
    final now = DateTime.now();
    final List<ExerciseHistory> filtered;
    if (_selectedPeriod == 'Tout') {
      filtered = ascHistory;
    } else {
      final Duration duration;
      switch (_selectedPeriod) {
        case '1S':
          duration = const Duration(days: 7);
          break;
        case '1M':
          duration = const Duration(days: 30);
          break;
        case '2M':
          duration = const Duration(days: 60);
          break;
        case '3M':
          duration = const Duration(days: 90);
          break;
        case '6M':
          duration = const Duration(days: 180);
          break;
        default:
          duration = const Duration(days: 60);
      }
      final cutoff = now.subtract(duration);
      filtered = ascHistory.where((h) => h.date.isAfter(cutoff)).toList();
    }

    if (filtered.length < 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChartHeader(),
          const SizedBox(height: 12),
          _buildPeriodSelector(),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              'Pas assez de données sur cette période.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
                fontSize: 13,
              ),
            ),
          ),
        ],
      );
    }

    final List<FlSpot> spots = [];
    double minY = double.infinity;
    double maxY = 0;

    for (int i = 0; i < filtered.length; i++) {
      final maxW = _calculateMaxWeight(filtered[i].series);
      spots.add(FlSpot(i.toDouble(), maxW));
      if (maxW < minY) minY = maxW;
      if (maxW > maxY) maxY = maxW;
    }

    if (minY == double.infinity) minY = 0;
    minY = (minY - 5).clamp(0, double.infinity);
    maxY += 5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChartHeader(),
        const SizedBox(height: 12),
        _buildPeriodSelector(),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => Colors.white,
                    tooltipBorder: BorderSide(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                    tooltipBorderRadius: BorderRadius.circular(12),
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final idx = spot.spotIndex;
                        final d = filtered[idx].date;
                        final dateStr =
                            '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
                        final weightVal = spot.y;
                        final weightStr = weightVal % 1 == 0
                            ? weightVal.toInt().toString()
                            : weightVal.toStringAsFixed(1);
                        return LineTooltipItem(
                          '$weightStr kg\n',
                          TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          children: [
                            TextSpan(
                              text: dateStr,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: ((maxY - minY) / 4).clamp(
                    1,
                    double.infinity,
                  ),
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.grey.withAlpha(30), strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= filtered.length)
                          return const SizedBox.shrink();
                        // Only show first and last date
                        if (idx != 0 && idx != filtered.length - 1) {
                          return const SizedBox.shrink();
                        }
                        final d = filtered[idx].date;
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[400],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}kg',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[400],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (filtered.length - 1).toDouble(),
                minY: minY,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    preventCurveOverShooting: true,
                    color: Theme.of(context).colorScheme.primary,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) =>
                          FlDotCirclePainter(
                            radius: 3,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary.withAlpha(50),
                          Theme.of(context).colorScheme.primary.withAlpha(5),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartHeader() {
    return const Text(
      'Progression de la charge',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final periods = ['1M', '2M', '3M', '6M', 'Tout'];
    return Row(
      children: periods.map((p) {
        final isSelected = p == _selectedPeriod;
        return Padding(
          padding: const EdgeInsets.only(right: 6),
          child: GestureDetector(
            onTap: () => setState(() => _selectedPeriod = p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                p,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.grey[600],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showEditExerciseDialog(BuildContext context) {
    final nomCtrl = TextEditingController(text: widget.exercise.nom);
    String? selectedMuscle = widget.exercise.musclePrincipal;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Modifier l\'exercice'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomCtrl,
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Muscle principal',
                ),
                initialValue: selectedMuscle,
                items: muscleCategories
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (val) => setDialogState(() => selectedMuscle = val),
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
                if (nomCtrl.text.isNotEmpty && selectedMuscle != null) {
                  setState(() {
                    widget.exercise.nom = nomCtrl.text;
                    widget.exercise.musclePrincipal = selectedMuscle!;
                  });
                  await ref
                      .read(databaseProvider)
                      .saveExercise(widget.exercise);
                  ref.invalidate(exercisesProvider);
                  // Rafraîchir aussi les stats et programmes car le nom/muscle change
                  ref.invalidate(workoutProgramsProvider);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullHistory(
    BuildContext context,
    List<ExerciseHistory> fullHistory,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text(
                    'Historique Complet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: fullHistory.length,
                itemBuilder: (context, index) {
                  final item = fullHistory[index];
                  final maxW = _calculateMaxWeight(item.series);
                  final maxWStr = maxW % 1 == 0
                      ? maxW.toInt().toString()
                      : maxW.toStringAsFixed(1);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(10),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          // Left accent bar
                          Container(
                            width: 4,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withAlpha(180),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(14),
                                bottomLeft: Radius.circular(14),
                              ),
                            ),
                          ),
                          // Content
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                12,
                                12,
                                14,
                                12,
                              ),
                              child: Row(
                                children: [
                                  // Date + pills
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today_outlined,
                                              size: 13,
                                              color: Colors.grey[400],
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              '${item.date.day.toString().padLeft(2, '0')}/${item.date.month.toString().padLeft(2, '0')}/${item.date.year}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 5,
                                          runSpacing: 5,
                                          children: _buildSeriesPills(
                                            item.series,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Max weight badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary.withAlpha(18),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '$maxWStr',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 18,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                        ),
                                        Text(
                                          'kg',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteExercise(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer l\'exercice ?'),
        content: const Text(
          'Cela supprimera DEFINITIVEMENT tout l\'historique et les records liés, et le retirera de vos programmes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref
                  .read(databaseProvider)
                  .deleteExercise(widget.exercise.id);

              // On rafraîchit tout car l'exercice est partout
              ref.invalidate(exercisesProvider);
              ref.invalidate(workoutProgramsProvider);
              ref.invalidate(scheduledWorkoutsProvider);
              ref.invalidate(personalRecordsProvider(widget.exercise.id));

              if (context.mounted) Navigator.pop(context);
            },
            child: const Text(
              'Supprimer',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
