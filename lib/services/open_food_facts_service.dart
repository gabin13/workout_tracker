import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_item.dart';

class OpenFoodFactsService {
  static const String _baseUrl = 'https://world.openfoodfacts.org';

  /// Recherche un produit par son code-barres exclusivement (Mobile Scanner)
  Future<FoodItem?> getProductByBarcode(String barcode) async {
    try {
      final url = Uri.parse('$_baseUrl/api/v0/product/$barcode.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1 && data['product'] != null) {
          return _parseOFFJson(data['product']);
        }
      }
      return null;
    } catch (e) {
      print('Erreur OFF getProductByBarcode: $e');
      return null;
    }
  }

  FoodItem _parseOFFJson(Map<String, dynamic> json) {
    final nutriments = json['nutriments'] ?? {};
    
    // OFF utilise parfois energy-kcal_100g, sinon energy_100g (en kJ qu'il faut convertir)
    double cal = (nutriments['energy-kcal_100g'] ?? 0.0).toDouble();
    if (cal == 0.0 && nutriments['energy_100g'] != null) {
      cal = (nutriments['energy_100g'] / 4.184).toDouble();
    }

    return FoodItem(
      barcode: json['_id'], // ou code
      name: json['product_name'] ?? json['product_name_fr'] ?? 'Produit inconnu',
      brand: json['brands'],
      imageUrl: json['image_front_url'] ?? json['image_url'],
      calories: cal,
      proteines: (nutriments['proteins_100g'] ?? 0.0).toDouble(),
      glucides: (nutriments['carbohydrates_100g'] ?? 0.0).toDouble(),
      lipides: (nutriments['fat_100g'] ?? 0.0).toDouble(),
      fibres: (nutriments['fiber_100g'] ?? 0.0).toDouble(),
    );
  }
}

// Provider statique ou instance simple pour l'accès
final openFoodFactsService = OpenFoodFactsService();
