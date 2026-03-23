import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/database_provider.dart';
import '../../models/body_measurement.dart';

class WeightDetailsScreen extends ConsumerStatefulWidget {
  const WeightDetailsScreen({super.key});

  @override
  ConsumerState<WeightDetailsScreen> createState() => _WeightDetailsScreenState();
}

class _WeightDetailsScreenState extends ConsumerState<WeightDetailsScreen> {
  List<BodyMeasurement> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final history = await ref.read(databaseProvider).getWeightHistory(60);
    setState(() {
      _history = history;
      _isLoading = false;
    });
  }

  void _showUpdateDialog() {
    final poidsController = TextEditingController(
      text: _history.isNotEmpty ? _history.first.poids.toString() : '',
    );
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
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
                    'Enregistrer un poids',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Date'),
                    trailing: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setModalState(() => selectedDate = picked);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: poidsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Poids',
                      suffixText: 'kg',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      final poids = double.tryParse(poidsController.text);
                      if (poids != null) {
                        final db = ref.read(databaseProvider);
                        final m = BodyMeasurement()
                          ..date = selectedDate
                          ..poids = poids;
                        
                        // Si l'utilisateur avait une taille précédente, on la garde
                        if (_history.isNotEmpty) {
                          m.taille = _history.first.taille;
                        }
                        
                        await db.saveMeasurement(m);
                        if (context.mounted) Navigator.pop(ctx);
                        _loadData();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Enregistrer'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final double currentWeight = _history.isNotEmpty ? _history.first.poids : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Poids'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Current Weight Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade700.withAlpha(50),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Text('Poids Actuel', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        currentWeight > 0 ? currentWeight.toStringAsFixed(1) : '--',
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent.shade700),
                      ),
                      const SizedBox(width: 8),
                      Text('kg', style: TextStyle(fontSize: 20, color: Colors.greenAccent.shade700)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Add Weight Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showUpdateDialog,
                icon: const Icon(Icons.add),
                label: const Text('Mettre à jour mon poids'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Chart
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Évolution (60 derniers jours)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            _buildChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    if (_history.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: Text('Aucune donnée enregistrée.')),
      );
    }

    // Préparer les données pour le line chart. 
    // Isar nous donne du plus récent au plus ancien (sortByDateDesc ou sort)
    // On doit inverser pour le graph (du plus ancien au plus récent)
    final chartData = _history.reversed.toList();
    
    List<FlSpot> spots = [];
    double minY = double.infinity;
    double maxY = -double.infinity;

    for (int i = 0; i < chartData.length; i++) {
        double val = chartData[i].poids;
        spots.add(FlSpot(i.toDouble(), val));
        if (val < minY) minY = val;
        if (val > maxY) maxY = val;
    }

    if (minY == double.infinity) minY = 0;
    if (maxY == -double.infinity) maxY = 1;

    double range = maxY - minY;
    if (range < 2) range = 2;
    maxY = maxY + (range * 0.1);
    minY = minY > (range * 0.1) ? minY - (range * 0.1) : 0;

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 250,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: FlTitlesData(
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 && value.toInt() < chartData.length) {
                          // Afficher 1 label sur 4 ou 5 selon la taille pour aérer
                          if (chartData.length > 10 && value.toInt() % (chartData.length ~/ 5) != 0) {
                            return const Text('');
                          }
                          DateTime d = chartData[value.toInt()].date;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('${d.day}/${d.month}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          );
                      }
                      return const Text('');
                    },
                    reservedSize: 30,
                  )
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(value.toStringAsFixed(0), style: const TextStyle(fontSize: 10, color: Colors.grey));
                    }
                  )
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: (chartData.length - 1).toDouble() > 0 ? (chartData.length - 1).toDouble() : 0,
              minY: minY,
              maxY: maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: Colors.greenAccent.shade700,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.greenAccent.shade700.withAlpha(30),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
