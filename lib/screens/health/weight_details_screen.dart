import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
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
  String _selectedPeriod = 'S';
  int _currentPageIndex = 0;
  bool _isInitialView = true;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _loadData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final history = await ref.read(databaseProvider).getWeightHistory(365 * 10);
    setState(() {
      _history = history;
      _isLoading = false;
    });
  }

  Future<void> _deleteMeasurement(int id) async {
    await ref.read(databaseProvider).deleteMeasurement(id);
    _loadData();
  }

  String _monthName(int m) {
    const months = ['janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin', 'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.'];
    return months[m - 1];
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
                  const Text('Enregistrer un poids', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
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
                      if (picked != null) setModalState(() => selectedDate = picked);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: poidsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Poids', suffixText: 'kg', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      final poids = double.tryParse(poidsController.text);
                      if (poids != null) {
                        final db = ref.read(databaseProvider);
                        final m = BodyMeasurement()..date = selectedDate..poids = poids;
                        if (_history.isNotEmpty) m.taille = _history.first.taille;
                        await db.saveMeasurement(m);
                        if (context.mounted) Navigator.pop(ctx);
                        _loadData();
                      }
                    },
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

  DateTimeRange _getDateRangeForIndex(int index, String period) {
    DateTime today = DateTime.now();
    DateTime todayMidnight = DateTime(today.year, today.month, today.day);

    if (index == 0 && _isInitialView) {
      DateTime end = todayMidnight;
      DateTime start;
      switch (period) {
        case 'S': start = end.subtract(const Duration(days: 6)); break;
        case 'M': start = end.subtract(const Duration(days: 29)); break;
        case '6M': start = end.subtract(const Duration(days: 179)); break;
        case 'A': start = end.subtract(const Duration(days: 364)); break;
        default: start = end.subtract(const Duration(days: 29));
      }
      return DateTimeRange(start: start, end: end);
    }

    switch (period) {
      case 'S':
        DateTime monday = todayMidnight.subtract(Duration(days: todayMidnight.weekday - 1));
        DateTime targetMonday = monday.subtract(Duration(days: 7 * index));
        return DateTimeRange(start: targetMonday, end: targetMonday.add(const Duration(days: 6)));
      
      case 'M':
        int currentMonth = todayMidnight.month - index;
        int currentYear = todayMidnight.year;
        while (currentMonth <= 0) { currentMonth += 12; currentYear--; }
        DateTime firstDay = DateTime(currentYear, currentMonth, 1);
        DateTime lastDay = DateTime(currentYear, currentMonth + 1, 1).subtract(const Duration(days: 1));
        return DateTimeRange(start: firstDay, end: lastDay);

      case '6M':
        int currentMonth6M = todayMidnight.month - (6 * index);
        int currentYear6M = todayMidnight.year;
        while (currentMonth6M <= 0) { currentMonth6M += 12; currentYear6M--; }
        DateTime lastDay6M = DateTime(currentYear6M, currentMonth6M + 1, 1).subtract(const Duration(days: 1));
        
        int startMonth = currentMonth6M - 5;
        int startYear = currentYear6M;
        while (startMonth <= 0) { startMonth += 12; startYear--; }
        DateTime firstDay6M = DateTime(startYear, startMonth, 1);
        return DateTimeRange(start: firstDay6M, end: lastDay6M);

      case 'A':
        int targetYear = todayMidnight.year - index;
        return DateTimeRange(start: DateTime(targetYear, 1, 1), end: DateTime(targetYear, 12, 31));
        
      default:
        return DateTimeRange(start: todayMidnight.subtract(const Duration(days: 29)), end: todayMidnight);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    DateTimeRange currentRange = _getDateRangeForIndex(_currentPageIndex, _selectedPeriod);
    DateTime periodStartDate = currentRange.start;
    DateTime periodEndDate = currentRange.end;

    final periodData = _history.where((m) {
      DateTime mD = DateTime(m.date.year, m.date.month, m.date.day);
      return !mD.isBefore(periodStartDate) && !mD.isAfter(periodEndDate);
    }).toList();

    double displayWeight = 0;
    double variation = 0;

    if (periodData.isNotEmpty) {
       displayWeight = periodData.first.poids; 
       double oldestInPeriod = periodData.last.poids; 
       variation = displayWeight - oldestInPeriod; 
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spécificités Poids'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: CupertinoSlidingSegmentedControl<String>(
                groupValue: _selectedPeriod,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(100),
                thumbColor: Theme.of(context).colorScheme.surface,
                children: const {
                  'S': Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('S', style: TextStyle(fontWeight: FontWeight.w600))),
                  'M': Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('M', style: TextStyle(fontWeight: FontWeight.w600))),
                  '6M': Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('6M', style: TextStyle(fontWeight: FontWeight.w600))),
                  'A': Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('A', style: TextStyle(fontWeight: FontWeight.w600))),
                },
                onValueChanged: (value) {
                  if (value != null) {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _selectedPeriod = value;
                      _isInitialView = true;
                      _currentPageIndex = 0;
                      if (_pageController.hasClients) {
                        _pageController.jumpToPage(0);
                      }
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('POIDS', style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      periodData.isNotEmpty ? displayWeight.toStringAsFixed(1) : '--',
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(width: 4),
                    const Text('kg', style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.w600)),
                    if (periodData.isNotEmpty && variation != 0) ...[
                      const SizedBox(width: 12),
                      Text(
                        variation > 0 ? "+${variation.toStringAsFixed(1)} kg" : "${variation.toStringAsFixed(1)} kg",
                        style: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.w600, 
                          color: variation > 0 ? Colors.red : Colors.green
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${periodStartDate.day} ${_monthName(periodStartDate.month)} – ${periodEndDate.day} ${_monthName(periodEndDate.month)} ${periodEndDate.year}',
                      style: const TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                    if (!_isInitialView) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          setState(() {
                            _isInitialView = true;
                            _currentPageIndex = 0;
                            if (_pageController.hasClients) {
                              _pageController.jumpToPage(0);
                            }
                          });
                        },
                        child: Text(
                          "Aujourd'hui",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 350,
              child: PageView.builder(
                controller: _pageController,
                reverse: true,
                onPageChanged: (index) {
                  setState(() {
                    _currentPageIndex = index;
                    if (_isInitialView && index != 0) {
                      _isInitialView = false;
                    }
                  });
                  HapticFeedback.selectionClick();
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _buildChartForPage(index),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showUpdateDialog,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Mettre à jour mon poids', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Historique global', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            _buildHistoryList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    if (_history.isEmpty) return const SizedBox.shrink();
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final entry = _history[index];
        return Dismissible(
          key: Key(entry.id.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            _deleteMeasurement(entry.id);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Entrée supprimée')));
          },
          child: Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 8),
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(50),
            child: ListTile(
              leading: const Icon(Icons.monitor_weight_outlined, color: Colors.grey),
              title: Text('${entry.date.day}/${entry.date.month}/${entry.date.year}', style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${entry.poids.toStringAsFixed(1)} kg', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () => _deleteMeasurement(entry.id),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChartForPage(int index) {
    DateTimeRange currentRange = _getDateRangeForIndex(index, _selectedPeriod);
    DateTime periodStartDate = currentRange.start;
    DateTime periodEndDate = currentRange.end;
    int daysThreshold = periodEndDate.difference(periodStartDate).inDays;

    final graphDataRaw = _history.where((m) {
      DateTime mD = DateTime(m.date.year, m.date.month, m.date.day);
      return !mD.isBefore(periodStartDate) && !mD.isAfter(periodEndDate);
    }).toList();
    
    if (graphDataRaw.isEmpty) {
      return const Center(child: Text('Aucune donnée pour cette période.', style: TextStyle(color: Colors.grey)));
    }

    final chartDataRaw = graphDataRaw.reversed.toList();
    final Map<String, BodyMeasurement> dailyMeasurements = {};
    for (final m in chartDataRaw) {
      final dateKey = '${m.date.year}-${m.date.month}-${m.date.day}';
      dailyMeasurements[dateKey] = m;
    }
    final chartData = dailyMeasurements.values.toList();
    
    List<FlSpot> spots = [];
    double minY = double.infinity;
    double maxY = -double.infinity;

    for (int i = 0; i < chartData.length; i++) {
        double val = chartData[i].poids;
        DateTime mDate = DateTime(chartData[i].date.year, chartData[i].date.month, chartData[i].date.day);
        double daysSinceStart = mDate.difference(periodStartDate).inDays.toDouble();
        
        spots.add(FlSpot(daysSinceStart, val));
        
        if (val < minY) minY = val;
        if (val > maxY) maxY = val;
    }

    if (minY == double.infinity) minY = 0;
    if (maxY == -double.infinity) maxY = 1;

    double range = maxY - minY;
    if (range < 2) range = 2;
    maxY = maxY + (range * 0.1);
    minY = minY > (range * 0.1) ? minY - (range * 0.1) : 0;

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value % 1 != 0) return const SizedBox.shrink();
                
                final int dayCounter = value.toInt();
                if (dayCounter < 0 || dayCounter > daysThreshold) return const SizedBox.shrink();
                
                int steps = _selectedPeriod == 'S' ? 1 : (_selectedPeriod == 'M' ? 6 : (_selectedPeriod == '6M' ? 30 : 60));
                
                if (dayCounter % steps != 0 && value != meta.max && value != meta.min) {
                   return const SizedBox.shrink();
                }

                DateTime d = periodStartDate.add(Duration(days: dayCounter));
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('${d.day}/${d.month}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                );
              },
              reservedSize: 30,
            )
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineTouchData: LineTouchData(
          getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
             return spotIndexes.map((index) {
                return TouchedSpotIndicatorData(
                   const FlLine(color: Colors.grey, strokeWidth: 1), 
                   FlDotData(
                      show: true, 
                      getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                        radius: 4, 
                        color: Theme.of(context).colorScheme.primary, 
                        strokeWidth: 2, 
                        strokeColor: Colors.white,
                      )
                   ),
                );
             }).toList();
          },
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (LineBarSpot touchedSpot) => Colors.transparent,
            tooltipPadding: EdgeInsets.zero,
            tooltipMargin: 8,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toStringAsFixed(1)} kg',
                  TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16),
                );
              }).toList();
            },
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: daysThreshold.toDouble(),
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withAlpha(50),
                  Theme.of(context).colorScheme.primary.withAlpha(0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
