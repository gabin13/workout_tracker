import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../models/nutrition.dart';
import '../../models/food_item.dart';
import '../../providers/database_provider.dart';
import '../../providers/nutrition_provider.dart';
import '../../services/open_food_facts_service.dart';
import '../../services/calorie_ninjas_service.dart';
import '../../services/sqflite_food_service.dart';
import '../../widgets/nutrition/custom_food_form.dart';
import '../../utils/formatters.dart';

class AddFoodScreen extends ConsumerStatefulWidget {
  final DailyNutritionLog dailyLog;
  final MealType mealType;

  const AddFoodScreen({
    super.key,
    required this.dailyLog,
    required this.mealType,
  });

  @override
  ConsumerState<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends ConsumerState<AddFoodScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<FoodItem> _results = [];
  List<FoodItem> _favoriteFoods = [];
  bool _isLoading = false;
  String? _errorMessage;
  // Expansion par catégorie : true = tout affiché, false = 6 items max
  final Map<String, bool> _expandedCategories = {};

  @override
  void initState() {
    super.initState();
    _loadLocalFoods();
    _searchController.addListener(() {
      if (_searchController.text.isEmpty && mounted) {
        setState(() {
          _results = [];
          _errorMessage = null;
        });
      }
    });
  }

  Future<void> _loadLocalFoods() async {
    final sqfliteService = SqfliteFoodService();
    final favorites = await sqfliteService.getFavoriteFoods();
    if (mounted) {
      setState(() {
        _favoriteFoods = favorites;
      });
    }
  }

  bool _isFav(FoodItem food) {
    return _favoriteFoods.any((f) => f.name.toLowerCase() == food.name.toLowerCase());
  }

  Future<void> _toggleFav(FoodItem food) async {
    HapticFeedback.selectionClick();
    await SqfliteFoodService().toggleFavorite(food);
    _loadLocalFoods();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;
    HapticFeedback.lightImpact();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _results = [];
    });

    final products = await calorieNinjaService.searchFood(query);
    
    setState(() {
      _isLoading = false;
      if (products.isEmpty) {
        _errorMessage = 'Aucun résultat trouvé ou erreur de connexion.';
      } else {
        _results = products;
      }
    });
  }

  Future<void> _openScanner() async {
    HapticFeedback.mediumImpact();
    final barcode = await Navigator.push<String?>(
      context,
      MaterialPageRoute(builder: (context) => const _BarcodeScannerScreen()),
    );

    if (barcode != null && barcode.isNotEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
          _searchController.text = barcode;
        });
      }

      final product = await openFoodFactsService.getProductByBarcode(barcode);
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          if (product != null) {
            _results = [product];
          } else {
            _results = [];
            _errorMessage = 'Code-barres inconnu : $barcode';
          }
        });
    }
  }
}


  void _showCustomFoodForm({FoodItem? initialFood}) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomFoodForm(
        initialFood: initialFood,
        onSave: (newFood) async {
          await SqfliteFoodService().addRecentFood(newFood);
          await _loadLocalFoods();
          
          if (mounted) {
            HapticFeedback.heavyImpact();
            // Ferme tout et rouvre le calculateur avec les nouvelles valeurs
            // Navigator.pop(context); // Déjà fait dans CustomFoodForm
            _showPortionCalculator(newFood);
          }
        },
      ),
    );
  }

  void _showPortionCalculator(FoodItem product) {
    HapticFeedback.selectionClick();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PortionCalculatorSheet(
        product: product,
        onEdit: () => _showCustomFoodForm(initialFood: product),
        onAdd: (double kcal, double prot, double gluc, double lip, double fibres, int grams) async {
          final service = ref.read(nutritionServiceProvider);
          final entry = MealEntry()
            ..dailyLogId = widget.dailyLog.id
            ..mealType = widget.mealType
            ..notes = '${product.name} (${grams}g)'
            ..calories = kcal
            ..proteines = prot
            ..glucides = gluc
            ..lipides = lip
            ..fibres = fibres;
          
          await service.saveMealEntry(entry, widget.dailyLog.id);
          ref.invalidate(dailyNutritionLogProvider);
          
          await SqfliteFoodService().addRecentFood(product);
          await _loadLocalFoods();
          
          if (context.mounted) {
            HapticFeedback.heavyImpact();
            Navigator.pop(context); // fermer la page AddFoodScreen après l'ajout
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Ajouter un aliment'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Barre de recherche
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Rechercher un aliment...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    onSubmitted: _performSearch,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.qr_code_scanner, color: Theme.of(context).primaryColor),
                    onPressed: _openScanner,
                    tooltip: 'Scanner un code-barres',
                  ),
                ),
              ],
            ),
          ),
          
          // Résultats ou Fréquents
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _searchController.text.isEmpty && _results.isEmpty
                    ? _buildLocalFoodsWithManualButton()
                    : _results.isEmpty 
                        ? _buildNoResultsView()
                        : _buildResultsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(_errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
          ),
        const Icon(Icons.search_off, size: 64, color: Colors.grey),
        const SizedBox(height: 16),
        const Text('Aucun aliment trouvé.', style: TextStyle(color: Colors.grey, fontSize: 16)),
        const SizedBox(height: 24),
        _buildManualEntryButton(),
      ],
    );
  }

  Widget _buildLocalFoodsWithManualButton() {
    return Column(
      children: [
        Expanded(child: _buildLocalFoodsSection()),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildManualEntryButton(),
        ),
      ],
    );
  }

  Widget _buildResultsList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _results.length,
            itemBuilder: (context, index) {
              final p = _results[index];
              final isFav = _isFav(p);
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: p.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(p.imageUrl!, width: 50, height: 50, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, size: 40, color: Colors.grey)),
                        )
                      : Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.fastfood, color: Colors.grey),
                        ),
                  title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Text('${p.calories.formatMacro()} kcal', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        const SizedBox(width: 8),
                        _buildMacroTag('P', p.proteines, Colors.blueAccent),
                        const SizedBox(width: 4),
                        _buildMacroTag('G', p.glucides, Colors.orangeAccent),
                        const SizedBox(width: 4),
                        _buildMacroTag('L', p.lipides, Colors.redAccent),
                        const SizedBox(width: 4),
                        _buildMacroTag('F', p.fibres ?? 0.0, Colors.brown[400]!),
                      ],
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(isFav ? Icons.star : Icons.star_border, color: Colors.amber),
                        onPressed: () => _toggleFav(p),
                      ),
                      const Icon(Icons.add_circle, color: Colors.deepPurpleAccent),
                    ],
                  ),
                  onTap: () => _showPortionCalculator(p),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildManualEntryButton(),
        ),
      ],
    );
  }

  Widget _buildManualEntryButton() {
    return _NextGenManualButton(
      onPressed: () => _showCustomFoodForm(),
    );
  }

  Widget _buildLocalFoodsSection() {
    bool hasFavorites = _favoriteFoods.isNotEmpty;
    
    if (_searchController.text.isNotEmpty) {
      return _buildResultsList();
    }

    if (!hasFavorites) return const SizedBox();

    final Map<String, List<FoodItem>> grouped = {};
    if (hasFavorites) {
      for (final food in _favoriteFoods) {
        final categories = food.mealCategory.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty);
        if (categories.isEmpty) {
          grouped.putIfAbsent('Général', () => []).add(food);
        } else {
          for (final cat in categories) {
            grouped.putIfAbsent(cat, () => []).add(food);
          }
        }
      }
    }

    // Ordre d'affichage des catégories
    const categoryOrder = ['Petit-déjeuner', 'Repas', 'Collation', 'Général'];
    final orderedKeys = [
      ...categoryOrder.where((c) => grouped.containsKey(c)),
      ...grouped.keys.where((k) => !categoryOrder.contains(k)),
    ];

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // --- Favoris groupés par catégorie ---
          if (hasFavorites) ...[
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text('Favoris ⭐️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            for (final category in orderedKeys) ...[
              _buildCategorySection(category, grouped[category]!),
            ],
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  Widget _buildCategorySection(String category, List<FoodItem> foods) {
    if (foods.isEmpty) return const SizedBox.shrink();

    // Rendre les couleurs pastel
    final Color baseColor = _getCategoryColor(category);
    final Color pastelBg = baseColor.withAlpha(25);

    // Groupement par foodGroup
    final Map<String, List<FoodItem>> groupedByFamily = {};
    for (var f in foods) {
      final fg = f.foodGroup;
      groupedByFamily.putIfAbsent(fg, () => []).add(f);
    }
    
    // Trier les clés pour un affichage cohérent (ordre kFoodGroups)
    final sortedGroups = groupedByFamily.keys.toList()
      ..sort((a, b) => kFoodGroups.indexOf(a).compareTo(kFoodGroups.indexOf(b)));

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12), // 0.05 opacité environ ~12 alpha
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(width: 6, color: baseColor),
            ),
          ),
          padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0, right: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header de la Card
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(_getCategoryIcon(category), size: 20, color: baseColor),
                    const SizedBox(width: 8),
                    Text(
                      category,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              // Carrousels superposés
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: sortedGroups.where((fg) => groupedByFamily[fg]!.isNotEmpty).map((fg) {
                  final familyFoods = groupedByFamily[fg]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border(left: BorderSide(color: baseColor, width: 4)),
                        ),
                        child: Text(
                          fg.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          int middle = (familyFoods.length / 2).ceil();
                          var row1 = familyFoods.take(middle).toList();
                          var row2 = familyFoods.skip(middle).toList();

                          Widget buildChip(FoodItem food) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onLongPress: () => _showRenameFavoriteDialog(food),
                                child: ActionChip(
                                  backgroundColor: pastelBg,
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                  label: ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 180),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          food.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _buildMacroTag('P', food.proteines, Colors.blueAccent),
                                            const SizedBox(width: 2),
                                            _buildMacroTag('G', food.glucides, Colors.orangeAccent),
                                            const SizedBox(width: 2),
                                            _buildMacroTag('L', food.lipides, Colors.redAccent),
                                            const SizedBox(width: 2),
                                            _buildMacroTag('F', food.fibres ?? 0.0, Colors.brown[400]!),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    _showPortionCalculator(food);
                                  },
                                ),
                              ),
                            );
                          }

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: row1.map(buildChip).toList()),
                                if (row2.isNotEmpty) const SizedBox(height: 8.0),
                                if (row2.isNotEmpty) Row(children: row2.map(buildChip).toList()),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Ouvre l'AlertDialog de renommage et changement de catégorie (long press)
  void _showRenameFavoriteDialog(FoodItem food) {
    HapticFeedback.mediumImpact();
    final nameController = TextEditingController(text: food.name);
    List<String> selectedCategories = food.mealCategory.split(',')
        .map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (selectedCategories.isEmpty) selectedCategories = ['Général'];
    String selectedFoodGroup = food.foodGroup; // NOUVEAU: Groupe d'aliment
    List<String> availableGroups = getFoodGroupsForCategories(selectedCategories);
    if (!availableGroups.contains(selectedFoodGroup)) {
      availableGroups.add(selectedFoodGroup);
    }

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('✏️ Modifier le favori'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              // Sélecteur de catégories de repas
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Associer aux repas :', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13)),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: -4,
                children: kMealCategories.map((cat) {
                  final isSelected = selectedCategories.contains(cat);
                  return FilterChip(
                    label: Text(cat, style: TextStyle(
                      color: isSelected ? _getCategoryColor(cat).withAlpha(200) : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    )),
                    selected: isSelected,
                    onSelected: (selected) {
                      setDialogState(() {
                        if (selected) {
                          selectedCategories.add(cat);
                        } else {
                          selectedCategories.remove(cat);
                          if (selectedCategories.isEmpty) {
                            selectedCategories.add('Général'); // Requis minimum
                          }
                        }
                        availableGroups = getFoodGroupsForCategories(selectedCategories);
                        if (!availableGroups.contains(selectedFoodGroup)) {
                          selectedFoodGroup = availableGroups.first;
                        }
                      });
                    },
                    selectedColor: _getCategoryColor(cat).withAlpha(30),
                    backgroundColor: Colors.grey.shade100,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // NOUVEAU: Sélecteur de famille d'aliment avec Wrap de ChoiceChips
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Famille d\'aliment :', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 13)),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: -4,
                children: availableGroups.map((group) {
                  final isSelected = selectedFoodGroup == group;
                  return ChoiceChip(
                    label: Text(group, style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    )),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setDialogState(() => selectedFoodGroup = group);
                      }
                    },
                    selectedColor: Theme.of(context).primaryColor,
                    backgroundColor: Colors.grey.shade100,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  );
                }).toList(),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () async {
                HapticFeedback.mediumImpact();
                await SqfliteFoodService().deleteFavorite(food.name);
                await _loadLocalFoods();
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Favori supprimé'),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Annuler'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final newName = nameController.text.trim();
                    if (newName.isEmpty) return;
                    final updatedFood = food.copyWith(
                      name: newName,
                      mealCategory: selectedCategories.join(','),
                      foodGroup: selectedFoodGroup, // Ajout du groupe d'aliment
                    );
                    await SqfliteFoodService().updateFavorite(
                      originalName: food.name,
                      updatedFood: updatedFood,
                    );
                    await _loadLocalFoods();
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  child: const Text('Enregistrer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Petit-déjeuner': return Icons.wb_sunny_outlined;
      case 'Repas': return Icons.light_mode_outlined;
      case 'Collation': return Icons.apple_outlined;
      default: return Icons.category_outlined;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Petit-déjeuner': return Colors.orange;
      case 'Repas': return Colors.blue;
      case 'Collation': return Colors.green;
      default: return Colors.grey;
    }
  }

  Widget _buildMacroTag(String label, double value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Text(
        '$label: ${value.formatMacro()}g',
        style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Calculateur de Portion BottomSheet
// -----------------------------------------------------------------------------
class _PortionCalculatorSheet extends StatefulWidget {
  final FoodItem product;
  final Function(double kcal, double prot, double gluc, double lip, double fibres, int grams) onAdd;
  final VoidCallback onEdit; // Ajouté pour ouvrir le formulaire d'édition

  const _PortionCalculatorSheet({required this.product, required this.onAdd, required this.onEdit});

  @override
  State<_PortionCalculatorSheet> createState() => _PortionCalculatorSheetState();
}

class _PortionCalculatorSheetState extends State<_PortionCalculatorSheet> {
  final TextEditingController _gramsController = TextEditingController(text: '100');
  int _grams = 100;

  @override
  void dispose() {
    _gramsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double currentKcal = (widget.product.calories * _grams / 100);
    double currentProt = (widget.product.proteines * _grams / 100);
    double currentGluc = (widget.product.glucides * _grams / 100);
    double currentLip = (widget.product.lipides * _grams / 100);
    double currentFib = ((widget.product.fibres ?? 0.0) * _grams / 100);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(240),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 24),
                child: Container(width: 48, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(3)))
              ),
              Text(
                widget.product.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // Fermer le calculateur
                      widget.onEdit(); // Ouvrir le formulaire d'édition
                    },
                    icon: const Icon(Icons.edit_note, size: 20),
                    label: const Text('Modifier les valeurs nutritionnelles'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      foregroundColor: Colors.deepPurpleAccent,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _gramsController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*[,.]?\d*'))],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      labelText: 'Quantité',
                      suffixText: 'g',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _grams = (double.tryParse(val.replaceAll(',', '.')) ?? 0.0).toInt();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMacroIndicator('Kcal', currentKcal, Colors.deepPurpleAccent),
                _buildMacroIndicator('Prot', currentProt, Colors.blueAccent),
                _buildMacroIndicator('Gluc', currentGluc, Colors.orangeAccent),
                _buildMacroIndicator('Lip', currentLip, Colors.redAccent),
                _buildMacroIndicator('Fib', currentFib, Colors.green),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _grams > 0 ? () {
                widget.onAdd(currentKcal, currentProt, currentGluc, currentLip, currentFib, _grams);
                Navigator.pop(context); // Fermer le TextField sheet
              } : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('Ajouter au repas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildMacroIndicator(String label, double value, Color color) {
    return Column(
      children: [
        Text(value.formatMacro(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Écran du Scanner de Code-Barres
// -----------------------------------------------------------------------------
class _BarcodeScannerScreen extends StatefulWidget {
  const _BarcodeScannerScreen();

  @override
  State<_BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<_BarcodeScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner un Code-Barres'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _controller,
              builder: (context, state, child) {
                switch (state.torchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                  case TorchState.auto:
                  default:
                    return const Icon(Icons.flash_auto, color: Colors.grey);
                }
              },
            ),
            onPressed: () => _controller.toggleTorch(),
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _controller,
              builder: (context, state, child) {
                switch (state.cameraDirection) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                  case CameraFacing.external:
                  default:
                    return const Icon(Icons.camera, color: Colors.grey);
                }
              },
            ),
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
            final String code = barcodes.first.rawValue!;
            HapticFeedback.vibrate();
            _controller.stop();
            Navigator.pop(context, code);
          }
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Bouton d'entrée manuelle
// -----------------------------------------------------------------------------
class _NextGenManualButton extends StatefulWidget {
  final VoidCallback onPressed;
  const _NextGenManualButton({required this.onPressed});

  @override
  State<_NextGenManualButton> createState() => _NextGenManualButtonState();
}

class _NextGenManualButtonState extends State<_NextGenManualButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        HapticFeedback.lightImpact();
        setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.deepPurpleAccent.shade200,
                Theme.of(context).primaryColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withAlpha(50),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.edit_note, color: Colors.white, size: 26),
              SizedBox(width: 10),
              Text(
                'Saisie manuelle',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
