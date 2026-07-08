class FoodItem {
  final String? barcode;
  final String name;
  final String? brand;
  final String? imageUrl;
  
  // Macros pour 100g
  final double calories;
  final double proteines;
  final double glucides;
  final double lipides;
  final double? fibres;

  /// Catégorie de repas pour les favoris.
  /// Valeurs possibles : 'Petit-déjeuner', 'Déjeuner', 'Dîner', 'Collation', 'Général'
  final String mealCategory;

  /// Groupe d'aliment (Protéines, Féculents, Légumes/Fruits, etc.)
  final String foodGroup;

  FoodItem({
    this.barcode,
    required this.name,
    this.brand,
    this.imageUrl,
    required this.calories,
    required this.proteines,
    required this.glucides,
    required this.lipides,
    this.fibres,
    this.mealCategory = 'Général',
    this.foodGroup = 'Divers',
  });

  /// Crée une copie de l'aliment avec les champs modifiés
  FoodItem copyWith({
    String? name,
    double? calories,
    double? proteines,
    double? glucides,
    double? lipides,
    double? fibres,
    String? mealCategory,
    String? foodGroup,
  }) {
    return FoodItem(
      barcode: barcode,
      name: name ?? this.name,
      brand: brand,
      imageUrl: imageUrl,
      calories: calories ?? this.calories,
      proteines: proteines ?? this.proteines,
      glucides: glucides ?? this.glucides,
      lipides: lipides ?? this.lipides,
      fibres: fibres ?? this.fibres,
      mealCategory: mealCategory ?? this.mealCategory,
      foodGroup: foodGroup ?? this.foodGroup,
    );
  }
}
