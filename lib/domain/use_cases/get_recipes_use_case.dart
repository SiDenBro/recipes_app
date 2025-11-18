import 'package:recipes_app/domain/entities/recipe_entity.dart';
import 'package:recipes_app/domain/repositories/recipe_repository.dart';

class GetRecipesUseCase {
  final RecipeRepository repository;

  GetRecipesUseCase({required this.repository});

  Future<List<RecipeEntity>> call() async {
    return await repository.getRecipes();
  }
}