import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/food_item.dart';
import '../../services/sqflite_food_service.dart';

class CustomFoodForm extends StatefulWidget {
  final FoodItem? initialFood;
  final Function(FoodItem) onSave;

  const CustomFoodForm({super.key, this.initialFood, required this.onSave});

  @override
  State<CustomFoodForm> createState() => _CustomFoodFormState();
}

class _CustomFoodFormState extends State<CustomFoodForm> {
  late TextEditingController _nameController;
  late TextEditingController _calController;
  late TextEditingController _protController;
  late TextEditingController _glucController;
  late TextEditingController _lipController;
  late TextEditingController _fibController;
  late List<String> _selectedCategories;
  late String _selectedFoodGroup;
  late List<String> _currentAvailableGroups;

  void _updateAvailableGroups() {
    _currentAvailableGroups = getFoodGroupsForCategories(_selectedCategories);
    if (!_currentAvailableGroups.contains(_selectedFoodGroup)) {
      _selectedFoodGroup = _currentAvailableGroups.first;
    }
  }

  bool _saveAsFavorite = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialFood?.name ?? '');
    _calController = TextEditingController(text: widget.initialFood?.calories.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '') ?? '');
    _protController = TextEditingController(text: widget.initialFood?.proteines.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '') ?? '');
    _glucController = TextEditingController(text: widget.initialFood?.glucides.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '') ?? '');
    _lipController = TextEditingController(text: widget.initialFood?.lipides.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '') ?? '');
    _fibController = TextEditingController(text: widget.initialFood?.fibres?.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '') ?? '');
    if (widget.initialFood != null && widget.initialFood!.mealCategory.isNotEmpty) {
      _selectedCategories = widget.initialFood!.mealCategory.split(',')
          .map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    } else {
      _selectedCategories = ['Général'];
    }
    _selectedFoodGroup = widget.initialFood?.foodGroup ?? 'Divers';
    _updateAvailableGroups();
    if (!_currentAvailableGroups.contains(_selectedFoodGroup)) {
      _currentAvailableGroups.add(_selectedFoodGroup);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _calController.dispose();
    _protController.dispose();
    _glucController.dispose();
    _lipController.dispose();
    _fibController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_nameController.text.isEmpty) return;

    final food = FoodItem(
      name: _nameController.text,
      calories: double.tryParse(_calController.text.replaceAll(',', '.')) ?? 0.0,
      proteines: double.tryParse(_protController.text.replaceAll(',', '.')) ?? 0.0,
      glucides: double.tryParse(_glucController.text.replaceAll(',', '.')) ?? 0.0,
      lipides: double.tryParse(_lipController.text.replaceAll(',', '.')) ?? 0.0,
      fibres: double.tryParse(_fibController.text.replaceAll(',', '.')) ?? 0.0,
      mealCategory: _selectedCategories.join(','),
      foodGroup: _selectedFoodGroup,
    );

    if (_saveAsFavorite) {
      final db = SqfliteFoodService();
      bool alreadyFav = await db.isFavorite(food.name);
      if (!alreadyFav) {
        await db.toggleFavorite(food);
      } else {
        await db.updateFavorite(originalName: food.name, updatedFood: food);
      }
    }

    widget.onSave(food);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          left: 24,
          right: 24,
          top: 24,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(245),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 24),
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              Text(
                widget.initialFood == null ? 'Nouvel aliment' : 'Modifier les valeurs',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Saisie manuelle des valeurs',
                style: TextStyle(color: Colors.grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Nom de l'aliment (obligatoire)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  prefixIcon: const Icon(Icons.restaurant),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildNumericField(_calController, 'Calories', 'kcal', Colors.deepPurpleAccent)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildNumericField(_protController, 'Protéines', 'g', Colors.blueAccent)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildNumericField(_glucController, 'Glucides', 'g', Colors.orangeAccent)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildNumericField(_lipController, 'Lipides', 'g', Colors.redAccent)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildNumericField(_fibController, 'Fibres', 'g', Colors.green)),
                ],
              ),
              const SizedBox(height: 24),

              SwitchListTile(
                title: const Text('⭐ Enregistrer dans mes favoris', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Pour le retrouver facilement plus tard avec ses catégories', style: TextStyle(fontSize: 12)),
                value: _saveAsFavorite,
                activeColor: Theme.of(context).primaryColor,
                contentPadding: EdgeInsets.zero,
                onChanged: (val) {
                  setState(() {
                    _saveAsFavorite = val;
                  });
                },
              ),
              
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: _saveAsFavorite ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text('Associer aux repas :', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: kMealCategories.map((cat) {
                        final isSelected = _selectedCategories.contains(cat);
                        return FilterChip(
                          label: Text(cat, style: TextStyle(
                            color: isSelected ? _getCategoryColor(cat).withAlpha(200) : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          )),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedCategories.add(cat);
                              } else {
                                _selectedCategories.remove(cat);
                                if (_selectedCategories.isEmpty) {
                                  _selectedCategories.add('Général'); // Toujours un default
                                }
                              }
                              _updateAvailableGroups();
                            });
                          },
                          selectedColor: _getCategoryColor(cat).withAlpha(30),
                          backgroundColor: Colors.grey.shade100,
                          checkmarkColor: _getCategoryColor(cat),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text('Famille d\'aliment :', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: -4,
                      children: _currentAvailableGroups.map((group) {
                        final isSelected = _selectedFoodGroup == group;
                        return ChoiceChip(
                          label: Text(group, style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          )),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedFoodGroup = group);
                            }
                          },
                          selectedColor: Theme.of(context).primaryColor,
                          backgroundColor: Colors.grey.shade100,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                  ],
                ) : const SizedBox.shrink(),
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Sauvegarder', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumericField(TextEditingController controller, String label, String suffix, Color color) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*[,.]?\d*'))],
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        labelStyle: TextStyle(color: color.withAlpha(200)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: color, width: 2),
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
}
