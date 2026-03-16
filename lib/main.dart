import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/database_service.dart';
import 'services/notification_service.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'screens/main_screen.dart';

// Services Globaux
final databaseService = DatabaseService();
final notificationService = NotificationService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await databaseService.initialize();
  await notificationService.initialize();
  await initializeDateFormatting('fr_FR', null);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Workout Tracker',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.deepPurpleAccent, // Accent sport
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const MainScreen(),
    );
  }
}
