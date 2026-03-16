import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main.dart';
import '../services/database_service.dart';

// Fournit l'accès global au DatabaseService
final databaseProvider = Provider<DatabaseService>((ref) {
  // Retourne l'instance déjà initialisée dans main.dart
  return databaseService;
});
