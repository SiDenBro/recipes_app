import 'package:recipes_app/domain/entities/recipe_entity.dart';

abstract class RecipeRepository {
  Future<List<RecipeEntity>> getRecipes();
  Future<List<RecipeEntity>> getCachedRecipes();
  Future<void> cacheRecipes(List<RecipeEntity> recipes);
}