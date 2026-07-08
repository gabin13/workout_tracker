import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/food_item.dart';

/// Catégories disponibles pour les favoris
const List<String> kMealCategories = [
  'Général',
  'Petit-déjeuner',
  'Repas',
  'Collation',
];

/// Groupes d'aliments disponibles
const Map<String, List<String>> kFoodGroupsByCategory = {
  'Petit-déjeuner': ['Céréales & Graines', 'Laitages', 'Fruits', 'Tartines & Sucré', 'Boissons', 'Divers'],
  'Repas': ['Protéines (Viandes/Poissons)', 'Féculents', 'Légumes', 'Plats préparés', 'Sauces', 'Divers'],
  'Collation': ['Fruits', 'Nutrition Sportive', 'Oléagineux', 'En-cas plaisir', 'Divers'],
  'Général': ['Condiments & Épices', 'Huiles', 'Ingrédients de base', 'Boissons', 'Divers'],
};

List<String> get kFoodGroups {
  return kFoodGroupsByCategory.values.expand((e) => e).toSet().toList();
}

List<String> getFoodGroupsForCategories(List<String> categories) {
  if (categories.isEmpty) return kFoodGroupsByCategory['Général']!;
  final Set<String> groups = {};
  for (final cat in categories) {
    if (kFoodGroupsByCategory.containsKey(cat)) {
      groups.addAll(kFoodGroupsByCategory[cat]!);
    }
  }
  if (groups.isEmpty) return kFoodGroupsByCategory['Général']!;
  return groups.toList();
}

class SqfliteFoodService {
  static final SqfliteFoodService _instance = SqfliteFoodService._internal();
  factory SqfliteFoodService() => _instance;
  SqfliteFoodService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'food_history.db');

    return await openDatabase(
      path,
      version: 5,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE recent_foods (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT UNIQUE,
            calories REAL,
            proteines REAL,
            glucides REAL,
            lipides REAL,
            fibres REAL DEFAULT 0.0,
            last_used_at INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE favorite_foods (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT UNIQUE,
            calories REAL,
            proteines REAL,
            glucides REAL,
            lipides REAL,
            fibres REAL DEFAULT 0.0,
            meal_category TEXT DEFAULT 'Général',
            food_group TEXT DEFAULT 'Divers'
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            "ALTER TABLE favorite_foods ADD COLUMN meal_category TEXT DEFAULT 'Général'",
          );
        }
        if (oldVersion < 3) {
          // Migration : fusionner 'Déjeuner' et 'Dîner' en 'Repas'
          await db.execute(
            "UPDATE favorite_foods SET meal_category = 'Repas' WHERE meal_category IN ('Déjeuner', 'Dîner')",
          );
        }
        if (oldVersion < 4) {
          await db.execute(
            "ALTER TABLE favorite_foods ADD COLUMN food_group TEXT DEFAULT 'Divers'",
          );
        }
        if (oldVersion < 5) {
          await db.execute("ALTER TABLE favorite_foods ADD COLUMN fibres REAL DEFAULT 0.0");
          await db.execute("ALTER TABLE recent_foods ADD COLUMN fibres REAL DEFAULT 0.0");
        }
      },
    );
  }

  // ---------------------------------------------------------------------------
  // RECENT FOODS
  // ---------------------------------------------------------------------------

  Future<List<FoodItem>> getRecentFoods() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'recent_foods',
      orderBy: 'last_used_at DESC',
      limit: 20,
    );

    return List.generate(maps.length, (i) {
      return FoodItem(
        name: maps[i]['name'],
        calories: (maps[i]['calories'] as num?)?.toDouble() ?? 0.0,
        proteines: (maps[i]['proteines'] as num?)?.toDouble() ?? 0.0,
        glucides: (maps[i]['glucides'] as num?)?.toDouble() ?? 0.0,
        lipides: (maps[i]['lipides'] as num?)?.toDouble() ?? 0.0,
        fibres: (maps[i]['fibres'] as num?)?.toDouble() ?? 0.0,
      );
    });
  }

  Future<void> addRecentFood(FoodItem food) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;

    await db.insert(
      'recent_foods',
      {
        'name': food.name,
        'calories': food.calories,
        'proteines': food.proteines,
        'glucides': food.glucides,
        'lipides': food.lipides,
        'fibres': food.fibres ?? 0.0,
        'last_used_at': now,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ---------------------------------------------------------------------------
  // FAVORITE FOODS
  // ---------------------------------------------------------------------------

  Future<List<FoodItem>> getFavoriteFoods() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorite_foods',
      orderBy: 'meal_category ASC, name ASC',
    );

    return List.generate(maps.length, (i) {
      return FoodItem(
        name: maps[i]['name'],
        calories: (maps[i]['calories'] as num?)?.toDouble() ?? 0.0,
        proteines: (maps[i]['proteines'] as num?)?.toDouble() ?? 0.0,
        glucides: (maps[i]['glucides'] as num?)?.toDouble() ?? 0.0,
        lipides: (maps[i]['lipides'] as num?)?.toDouble() ?? 0.0,
        fibres: (maps[i]['fibres'] as num?)?.toDouble() ?? 0.0,
        mealCategory: maps[i]['meal_category'] ?? 'Général',
        foodGroup: maps[i]['food_group'] ?? 'Divers',
      );
    });
  }

  Future<bool> isFavorite(String foodName) async {
    final db = await database;
    final maps = await db.query(
      'favorite_foods',
      where: 'name = ?',
      whereArgs: [foodName],
    );
    return maps.isNotEmpty;
  }

  Future<void> toggleFavorite(FoodItem food) async {
    final db = await database;
    final isFav = await isFavorite(food.name);

    if (isFav) {
      await db.delete(
        'favorite_foods',
        where: 'name = ?',
        whereArgs: [food.name],
      );
    } else {
      await db.insert(
        'favorite_foods',
        {
          'name': food.name,
          'calories': food.calories,
          'proteines': food.proteines,
          'glucides': food.glucides,
          'lipides': food.lipides,
          'fibres': food.fibres ?? 0.0,
          'meal_category': food.mealCategory,
          'food_group': food.foodGroup,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> deleteFavorite(String foodName) async {
    final db = await database;
    await db.delete(
      'favorite_foods',
      where: 'name = ?',
      whereArgs: [foodName],
    );
  }

  /// Met à jour le nom, les macros et/ou la catégorie d'un favori existant
  Future<void> updateFavorite({
    required String originalName,
    required FoodItem updatedFood,
  }) async {
    final db = await database;
    await db.update(
      'favorite_foods',
      {
        'name': updatedFood.name,
        'calories': updatedFood.calories,
        'proteines': updatedFood.proteines,
        'glucides': updatedFood.glucides,
        'lipides': updatedFood.lipides,
        'fibres': updatedFood.fibres ?? 0.0,
        'meal_category': updatedFood.mealCategory,
        'food_group': updatedFood.foodGroup,
      },
      where: 'name = ?',
      whereArgs: [originalName],
    );
  }
}
