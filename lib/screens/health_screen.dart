import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/health_service.dart';
import '../providers/database_provider.dart';
import '../models/body_measurement.dart';
import 'settings_screen.dart';
import 'health/weight_details_screen.dart';
import 'health/steps_details_screen.dart';
import 'health/calories_details_screen.dart';

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
  BodyMeasurement? _latestMeasurement;

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
    
    if (measurements.isNotEmpty) {
      measurements.sort((a, b) => b.date.compareTo(a.date));
      _latestMeasurement = measurements.first;
      
      // On garde uniquement la dernière mesure pour ce dashboard
    } else {
      _latestMeasurement = null;
    }
    
    if (authorized) {
      final data = await service.fetchHealthData();
      setState(() {
        _isAuthorized = true;
        _healthData = data;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isAuthorized = false;
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
                      onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (_) => const WeightDetailsScreen())).then((_) => _checkPermissionsAndFetch());
                      },
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
                      onTap: _showAddMeasurementDialog, // Garde cette fonction modifiée pour la taille
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
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StepsDetailsScreen())),
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
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CaloriesDetailsScreen())),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
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

  // _buildChartContainer supprimé

  void _showAddMeasurementDialog() {
    final tailleController = TextEditingController(text: _latestMeasurement?.taille?.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ma Taille'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Modifier uniquement votre taille, le poids se modifie sur sa page dédiée.', style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 16),
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
              final taille = double.tryParse(tailleController.text);
              if (taille != null) {
                final bm = BodyMeasurement()
                  ..date = DateTime.now()
                  ..taille = taille
                  ..poids = _latestMeasurement?.poids ?? 0.0; // Conserve le dernier poids connu
                  
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
    Function()? onTap,
  }) {
    return Card(
      elevation: 0,
      color: color.withAlpha((0.1 * 255).toInt()),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: color.withAlpha((0.3 * 255).toInt()), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
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
      ),
    );
  }
}
