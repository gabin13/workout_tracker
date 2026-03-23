import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/health_service.dart';

final healthServiceProvider = Provider((ref) => HealthService());

class CaloriesDetailsScreen extends ConsumerStatefulWidget {
  const CaloriesDetailsScreen({super.key});

  @override
  ConsumerState<CaloriesDetailsScreen> createState() => _CaloriesDetailsScreenState();
}

class _CaloriesDetailsScreenState extends ConsumerState<CaloriesDetailsScreen> {
  DateTime _currentWeekStart = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  List<Map<String, dynamic>> _weeklyData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentWeekStart = DateTime(_currentWeekStart.year, _currentWeekStart.month, _currentWeekStart.day);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final service = ref.read(healthServiceProvider);
    
    final data = await service.getCaloriesForWeek(_currentWeekStart);
    setState(() {
      _weeklyData = data;
      _isLoading = false;
    });
  }

  void _previousWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.subtract(const Duration(days: 7));
    });
    _loadData();
  }

  void _nextWeek() {
    final now = DateTime.now();
    final nextWeekStart = _currentWeekStart.add(const Duration(days: 7));
    if (nextWeekStart.isAfter(now)) return;
    
    setState(() {
      _currentWeekStart = nextWeekStart;
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final endOfWeek = _currentWeekStart.add(const Duration(days: 6));
    final String weekLabel = "Du ${_currentWeekStart.day}/${_currentWeekStart.month} au ${endOfWeek.day}/${endOfWeek.month}";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails des Calories'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Navigation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _previousWeek,
                ),
                Text(
                  weekLabel,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _currentWeekStart.add(const Duration(days: 7)).isAfter(DateTime.now()) 
                      ? null 
                      : _nextWeek,
                ),
              ],
            ),
          ),
          
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Calories actives brûlées', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 24),
                        _buildChart(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    double maxY = 500; // Base Max Y
    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < _weeklyData.length; i++) {
        double val = _weeklyData[i]['value'] as double;
        if (val > maxY) maxY = val;
        
        barGroups.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: val,
                color: Colors.orangeAccent,
                width: 22,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxY * 1.2,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(100),
                )
              ),
            ],
          )
        );
    }

    maxY = maxY * 1.2;

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: SizedBox(
          height: 300,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${rod.toY.toInt()} kcal',
                      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
                      if (value.toInt() >= 0 && value.toInt() < 7) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(days[value.toInt()], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        );
                      }
                      return const Text('');
                    },
                  ),
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
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: barGroups,
            ),
          ),
        ),
      ),
    );
  }
}
