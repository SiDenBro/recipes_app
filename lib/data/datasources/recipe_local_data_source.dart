import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipes_app/data/models/recipe_model.dart';

abstract class RecipeLocalDataSource {
  Future<List<RecipeModel>> getCachedRecipes();
  Future<void> cacheRecipes(List<RecipeModel> recipes);
}

class RecipeLocalDataSourceImpl implements RecipeLocalDataSource {
  static const String _cachedRecipesKey = 'cached_recipes';

  @override
  Future<List<RecipeModel>> getCachedRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_cachedRecipesKey);
    
    if (jsonString == null) {
      return [];
    }
    
    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((item) => RecipeModel.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> cacheRecipes(List<RecipeModel> recipes) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(recipes.map((recipe) => recipe.toJson()).toList());
    await prefs.setString(_cachedRecipesKey, jsonString);
  }
}