import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_service.dart';

// Fournit l'accès global au DatabaseService
final databaseProvider = Provider<DatabaseService>((ref) {
  // L'instance doit être initialisée dans le main.dart
  return DatabaseService();
});
