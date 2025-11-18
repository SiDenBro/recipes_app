import 'package:recipes_app/domain/entities/recipe_entity.dart';
import 'package:recipes_app/domain/repositories/recipe_repository.dart';

class CacheRecipesUseCase {
  final RecipeRepository repository;

  CacheRecipesUseCase({required this.repository});

  Future<void> call(List<RecipeEntity> recipes) async {
    await repository.cacheRecipes(recipes);
  }
}