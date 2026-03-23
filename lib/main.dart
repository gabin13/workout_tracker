import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/database_service.dart';
import 'services/notification_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_fonts/google_fonts.dart';

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
      themeMode: ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF2F2F7),
        primaryColor: const Color(0xFF5E5CE6),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5E5CE6),
          brightness: Brightness.light,
          surface: const Color(0xFFF9F9F9),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).apply(
          bodyColor: Colors.black87,
          displayColor: Colors.black87,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0, // Evite l'ombre en scrollant M3
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20),
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Color(0xFF5E5CE6),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF5E5CE6),
          unselectedItemColor: Colors.grey[400],
          elevation: 15,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      home: const MainScreen(),
    );
  }
}
