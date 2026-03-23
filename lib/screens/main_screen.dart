import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_screen.dart';
import 'exos_screen.dart';
import 'planning_screen.dart';
import 'health_screen.dart';
import 'nutrition_screen.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {

  final List<Widget> _screens = const [
    HomeScreen(),
    PlanningScreen(),
    ExosScreen(),
    HealthScreen(),
    NutritionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navigationIndexProvider);

    return Scaffold(
      body: _screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(navigationIndexProvider.notifier).state = index;
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Planning',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center_outlined),
            activeIcon: Icon(Icons.fitness_center),
            label: 'Exos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Santé',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_outlined),
            activeIcon: Icon(Icons.restaurant),
            label: 'Nutrition',
          ),
        ],
      ),
    );
  }
}
