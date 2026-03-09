import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
// Providers etc., ignorés pour simplicité visuelle

class EvolutionScreen extends StatefulWidget {
  const EvolutionScreen({super.key});

  @override
  State<EvolutionScreen> createState() => _EvolutionScreenState();
}

class _EvolutionScreenState extends State<EvolutionScreen> {
  final ImagePicker _picker = ImagePicker();
  List<File> _privatePhotos = [];

  // Données mockées pour le Graphe de mensuration
  final List<FlSpot> _weightSpots = [
    const FlSpot(1, 80),
    const FlSpot(2, 79.5),
    const FlSpot(3, 78.8),
    const FlSpot(4, 78.5),
    const FlSpot(5, 78.0),
  ];

  @override
  void initState() {
    super.initState();
    _loadPrivatePhotos();
  }

  Future<void> _loadPrivatePhotos() async {
    final dir = await getApplicationDocumentsDirectory();
    final photoDir = Directory(p.join(dir.path, 'workout_photos'));
    if (await photoDir.exists()) {
      final files = await photoDir.list().toList();
      setState(() {
        _privatePhotos = files.whereType<File>().toList();
      });
    }
  }

  Future<void> _takePhoto() async {
    final xFile = await _picker.pickImage(source: ImageSource.camera);
    if (xFile == null) return;

    final dir = await getApplicationDocumentsDirectory();
    final photoDir = Directory(p.join(dir.path, 'workout_photos'));
    if (!(await photoDir.exists())) {
      await photoDir.create(recursive: true);
    }
    
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final currentPath = p.join(photoDir.path, fileName);
    
    // Deplace du cache vers l'espace local privé de l'app (path_provider)
    final savedFile = await File(xFile.path).copy(currentPath);
    
    setState(() {
      _privatePhotos.add(savedFile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Évolution')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Évolution du Poids (kg)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: true, border: Border.all(color: Colors.white24)),
                lineBarsData: [
                  LineChartBarData(
                    spots: _weightSpots,
                    isCurved: true,
                    color: Colors.deepPurpleAccent,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.deepPurpleAccent.withValues(alpha: 0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Galerie Privée', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.camera_alt), onPressed: _takePhoto),
            ],
          ),
          const SizedBox(height: 8),
          _privatePhotos.isEmpty
              ? const SizedBox(
                  height: 150,
                  child: Center(child: Text('Aucune photo de progression pour le moment.', style: TextStyle(color: Colors.grey))),
                )
              : SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _privatePhotos.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(_privatePhotos[index], width: 140, fit: BoxFit.cover),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
