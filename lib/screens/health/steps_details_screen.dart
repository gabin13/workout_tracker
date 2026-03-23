import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/health_service.dart';

// Provider to get HealthService instance (assuming it's defined elsewhere or we can use a direct provider)
final healthServiceProvider = Provider((ref) => HealthService());

class StepsDetailsScreen extends ConsumerStatefulWidget {
  const StepsDetailsScreen({super.key});

  @override
  ConsumerState<StepsDetailsScreen> createState() => _StepsDetailsScreenState();
}

class _StepsDetailsScreenState extends ConsumerState<StepsDetailsScreen> {
  DateTime _currentWeekStart = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  List<Map<String, dynamic>> _weeklyData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Normalize to midnight
    _currentWeekStart = DateTime(_currentWeekStart.year, _currentWeekStart.month, _currentWeekStart.day);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final service = ref.read(healthServiceProvider);
    
    // We assume permissions were already requested in HealthScreen
    final data = await service.getStepsForWeek(_currentWeekStart);
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
    if (nextWeekStart.isAfter(now)) return; // Don't go to future weeks
    
    setState(() {
      _currentWeekStart = nextWeekStart;
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final endOfWeek = _currentWeekStart.add(const Duration(days: 6));
    final String weekLabel = "Du ${_currentWeekStart.day}/${_currentWeekStart.month} au ${endOfWeek.day}/${endOfWeek.month}";

    double totalSteps = 0;
    for (var d in _weeklyData) {
      totalSteps += (d['value'] as double);
    }
    int averageSteps = _weeklyData.isNotEmpty ? (totalSteps / _weeklyData.length).round() : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails des Pas'),
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
                        // Average Stats
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withAlpha(50),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            children: [
                              const Text('Moyenne de la semaine', style: TextStyle(fontSize: 16, color: Colors.grey)),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    averageSteps.toString(),
                                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('pas/jour', style: TextStyle(fontSize: 16, color: Colors.blueAccent)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Chart
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Activité de la semaine', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 16),
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
    double maxY = 10000; // Base Max Y to show the 8000 line clearly
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
                color: val >= 8000 ? Colors.greenAccent : Colors.blueAccent,
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
          height: 250,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${rod.toY.toInt()} pas',
                      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ),
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: 8000,
                    color: Colors.greenAccent.shade400,
                    strokeWidth: 2,
                    dashArray: [5, 5],
                    label: HorizontalLineLabel(
                      show: true,
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.only(right: 5, bottom: 5),
                      style: const TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold),
                      labelResolver: (line) => 'Objectif 8k',
                    ),
                  ),
                ],
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
