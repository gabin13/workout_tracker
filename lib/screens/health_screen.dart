import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/health_service.dart';
import '../providers/database_provider.dart';
import '../models/body_measurement.dart';
import 'settings_screen.dart';
import 'package:fl_chart/fl_chart.dart';

final healthServiceProvider = Provider((ref) => HealthService());

class HealthScreen extends ConsumerStatefulWidget {
  const HealthScreen({super.key});

  @override
  ConsumerState<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends ConsumerState<HealthScreen> {
  bool _isAuthorized = false;
  bool _isLoading = true;
  Map<String, dynamic> _healthData = {};
  Map<String, List<Map<String, dynamic>>> _weeklyData = {};
  BodyMeasurement? _latestMeasurement;
  List<Map<String, dynamic>> _weightHistory = [];

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndFetch();
  }

  Future<void> _checkPermissionsAndFetch() async {
    setState(() => _isLoading = true);
    final service = ref.read(healthServiceProvider);
    final db = ref.read(databaseProvider);
    
    // Pour simplifier ici, on demande direct si non autorisé
    // En prod on pourrait vérifier l'état avant
    final authorized = await service.requestPermissions();
    
    // Récupérer les mesures manuelles
    final measurements = await db.getAllMeasurements();
    List<Map<String, dynamic>> weightHist = [];
    
    if (measurements.isNotEmpty) {
      measurements.sort((a, b) => b.date.compareTo(a.date));
      _latestMeasurement = measurements.first;
      
      // Construire l'historique de poids pour le graph (ex: 7 ou X dernières entrées)
      for (var m in measurements.take(7).toList().reversed) {
        weightHist.add({'date': m.date, 'value': m.poids});
      }
    } else {
      _latestMeasurement = null;
    }
    
    if (authorized) {
      final data = await service.fetchHealthData();
      final weeklyData = await service.fetchWeeklyHistory();
      setState(() {
        _isAuthorized = true;
        _healthData = data;
        _weeklyData = weeklyData;
        _weightHistory = weightHist;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isAuthorized = false;
        _weightHistory = weightHist;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_isAuthorized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Santé'),
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite_outline, size: 100, color: Colors.redAccent),
              const SizedBox(height: 24),
              const Text(
                'Suivi Santé non connecté',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                child: Text(
                  'Connectez-vous à Apple Santé pour voir vos pas, calories et métriques directement ici.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _checkPermissionsAndFetch,
                icon: const Icon(Icons.link),
                label: const Text('Connecter à Apple Santé'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Santé'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _checkPermissionsAndFetch,
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
      body: RefreshIndicator(
        onRefresh: _checkPermissionsAndFetch,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. MESURES CORPORELLES (Local Database) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Mesures Corporelles', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.blueAccent),
                    onPressed: _showAddMeasurementDialog,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildHealthCard(
                      title: 'Poids',
                      value: _latestMeasurement?.poids.toStringAsFixed(1) ?? '--',
                      unit: 'kg',
                      icon: Icons.monitor_weight_outlined,
                      color: Colors.greenAccent.shade700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildHealthCard(
                      title: 'Taille',
                      value: _latestMeasurement?.taille != null ? _latestMeasurement!.taille!.toStringAsFixed(0) : '--',
                      unit: 'cm',
                      icon: Icons.height,
                      color: Colors.purpleAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- 2. IMC ---
              const Text('Indice de Masse Corporelle', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildBMICard(),
              const SizedBox(height: 24),

              // --- 3. ACTIVITÉ (Apple Santé) ---
              const Text('Activité du Jour', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildHealthCard(
                      title: 'Pas',
                      value: _healthData['steps'].toString(),
                      unit: '',
                      icon: Icons.directions_walk,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildHealthCard(
                      title: 'Calories',
                      value: _healthData['calories'].toString(),
                      unit: 'kcal',
                      icon: Icons.local_fire_department,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- 4. GRAPHIQUES D'ÉVOLUTION ---
              const Text('Évolution', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              // Graphique Poids
              if (_weightHistory.isNotEmpty) ...[
                _buildChartContainer(
                  title: 'Évolution du Poids',
                  color: Colors.greenAccent.shade700,
                  data: _weightHistory,
                ),
                const SizedBox(height: 16),
              ],
              // Graphique des Pas
              if (_weeklyData['steps'] != null && _weeklyData['steps']!.isNotEmpty)
                _buildChartContainer(
                  title: 'Pas',
                  color: Colors.blueAccent,
                  data: _weeklyData['steps']!,
                ),
              const SizedBox(height: 16),
              // Graphique des Calories
              if (_weeklyData['calories'] != null && _weeklyData['calories']!.isNotEmpty)
                _buildChartContainer(
                  title: 'Calories',
                  color: Colors.orangeAccent,
                  data: _weeklyData['calories']!,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBMICard() {
    double bmi = 0;
    String status = 'N/A';
    Color statusColor = Colors.grey;

    if (_latestMeasurement != null && _latestMeasurement!.taille != null && _latestMeasurement!.taille! > 0) {
      final hm = _latestMeasurement!.taille! / 100;
      bmi = _latestMeasurement!.poids / (hm * hm);
      
      if (bmi < 18.5) {
        status = 'Insuffisance';
        statusColor = Colors.blue;
      } else if (bmi >= 18.5 && bmi < 25) {
        status = 'Normal';
        statusColor = Colors.green;
      } else if (bmi >= 25 && bmi < 30) {
        status = 'Surpoids';
        statusColor = Colors.orange;
      } else {
        status = 'Obésité';
        statusColor = Colors.red;
      }
    }

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(100),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Mon IMC', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  bmi > 0 ? bmi.toStringAsFixed(1) : '--',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (bmi > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withAlpha(100), width: 1.0),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartContainer({required String title, required Color color, required List<Map<String, dynamic>> data}) {
    // Si toutes les valeurs sont à 0, ne pas afficher le graph ou l'afficher vide avec indication
    if (data.isEmpty) return const SizedBox.shrink();

    bool allZero = data.every((e) => e['value'] == 0);
    List<FlSpot> spots = [];
    double minY = double.infinity;
    double maxY = -double.infinity;

    if (!allZero) {
      for (int i = 0; i < data.length; i++) {
        double val = data[i]['value'] as double;
        spots.add(FlSpot(i.toDouble(), val));
        if (val < minY) minY = val;
        if (val > maxY) maxY = val;
      }
    } else {
      for (int i = 0; i < data.length; i++) {
        spots.add(FlSpot(i.toDouble(), 0));
      }
      minY = 0;
      maxY = 1;
    }

    // Ajuster l'échelle pour que ça respire (spécialement pour le poids où la diff est minime)
    double range = maxY - minY;
    if (range < 2) range = 2; // Éviter une échelle trop plate
    maxY = maxY + (range * 0.1);
    minY = minY > (range * 0.1) ? minY - (range * 0.1) : 0;

    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withAlpha(50), width: 1.0), // Corrected border side
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timeline, color: color, size: 20),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 180,
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
                          if (value.toInt() >= 0 && value.toInt() < data.length) {
                             DateTime d = data[value.toInt()]['date'];
                             final text = '${d.day}/${d.month}';
                             return Padding(
                               padding: const EdgeInsets.only(top: 8.0),
                               child: Text(text, style: const TextStyle(fontSize: 10, color: Colors.grey)),
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
                          if (value == 0) return const SizedBox.shrink();
                          return Text(
                            value >= 1000 ? '${(value/1000).toStringAsFixed(1)}k' : value.toStringAsFixed(0),
                            style: const TextStyle(fontSize: 10, color: Colors.grey)
                          );
                        }
                      )
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: data.isNotEmpty ? (data.length - 1).toDouble() : 0,
                  minY: 0,
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: color,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: color.withAlpha(30),
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
  }

  void _showAddMeasurementDialog() {
    final poidsController = TextEditingController(text: _latestMeasurement?.poids.toString());
    final tailleController = TextEditingController(text: _latestMeasurement?.taille?.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nouvelles mesures'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: poidsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Poids (kg)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tailleController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Taille (cm)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              final poids = double.tryParse(poidsController.text);
              final taille = double.tryParse(tailleController.text);
              
              if (poids != null) {
                final bm = BodyMeasurement()
                  ..date = DateTime.now()
                  ..poids = poids
                  ..taille = taille;
                  
                await ref.read(databaseProvider).saveMeasurement(bm);
                _checkPermissionsAndFetch(); // Refresh
              }
              if (context.mounted) Navigator.pop(ctx);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 0,
      color: color.withAlpha((0.1 * 255).toInt()),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: color.withAlpha((0.3 * 255).toInt()), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                if (unit.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  Text(
                    unit,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
