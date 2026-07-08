import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import '../models/food_item.dart';

class CalorieNinjaService {
  static const String _apiKey = 'RnHSd217AXzOf33gHsvimw==Q5BoejrdfbAytRU9';
  static const String _baseUrl = 'https://api.calorieninjas.com/v1/nutrition';
  final GoogleTranslator _translator = GoogleTranslator();

  /// Recherche des produits par texte avec traduction FR -> EN -> FR
  Future<List<FoodItem>> searchFood(String query) async {
    if (query.trim().isEmpty) return [];
    
    try {
      // Étape A : Traduire la requête FR -> EN
      final translatedQuery = await _translator.translate(query, from: 'fr', to: 'en');
      final enText = translatedQuery.text;

      // Étape B : Appel API
      final url = Uri.parse('$_baseUrl?query=${Uri.encodeComponent(enText)}');
      final response = await http.get(url, headers: {'X-Api-Key': _apiKey});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List?;
        if (items != null) {
          final List<FoodItem> results = [];
          
          for (var item in items) {
             final enName = item['name'] ?? 'Unknown';
             
             // Étape C : Retraduire EN -> FR
             final frTranslation = await _translator.translate(enName, from: 'en', to: 'fr');
             final frName = frTranslation.text;

             results.add(FoodItem(
               name: _capitalizeFirst(frName),
               calories: ((item['calories'] ?? 0) as num).toDouble(),
               proteines: ((item['protein_g'] ?? 0) as num).toDouble(),
               glucides: ((item['carbohydrates_total_g'] ?? 0) as num).toDouble(),
               lipides: ((item['fat_total_g'] ?? 0) as num).toDouble(),
               fibres: ((item['fiber_g'] ?? 0) as num).toDouble(),
               // L'API ne renvoie pas d'images
             ));
          }
          return results;
        }
      } else {
        print('Erreur CalorieNinjas HTTP ${response.statusCode}: ${response.body}');
      }
      return [];
    } catch (e) {
      print('Erreur CalorieNinjaService (Traduction ou Requête): $e');
      return [];
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}

final calorieNinjaService = CalorieNinjaService();
