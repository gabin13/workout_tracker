import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/health_service.dart';

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

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndFetch();
  }

  Future<void> _checkPermissionsAndFetch() async {
    setState(() => _isLoading = true);
    final service = ref.read(healthServiceProvider);
    
    // Pour simplifier ici, on demande direct si non autorisé
    // En prod on pourrait vérifier l'état avant
    final authorized = await service.requestPermissions();
    
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
        appBar: AppBar(title: const Text('Santé')),
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
        title: const Text('Mon Tableau de Bord Santé'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _checkPermissionsAndFetch,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _checkPermissionsAndFetch,
        child: GridView.count(
          padding: const EdgeInsets.all(16),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildHealthCard(
              title: 'Pas',
              value: _healthData['steps'].toString(),
              unit: '',
              icon: Icons.directions_walk,
              color: Colors.blueAccent,
            ),
            _buildHealthCard(
              title: 'Calories',
              value: _healthData['calories'].toString(),
              unit: 'kcal',
              icon: Icons.local_fire_department,
              color: Colors.orangeAccent,
            ),
            _buildHealthCard(
              title: 'Poids',
              value: _healthData['weight'].toString(),
              unit: 'kg',
              icon: Icons.monitor_weight_outlined,
              color: Colors.greenAccent,
            ),
            _buildHealthCard(
              title: 'Cœur',
              value: _healthData['heartRate'].toString(),
              unit: 'bpm',
              icon: Icons.favorite,
              color: Colors.redAccent,
            ),
          ],
        ),
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
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: color.withOpacity(0.3), width: 1),
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
