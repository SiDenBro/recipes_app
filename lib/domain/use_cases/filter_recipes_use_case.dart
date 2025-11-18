import 'package:recipes_app/domain/entities/recipe_entity.dart';

class FilterRecipesUseCase {
  List<RecipeEntity> call({
    required List<RecipeEntity> allRecipes,
    required String searchQuery,
    required bool? hasImage,
    required int? maxPrepTime,
  }) {
    return allRecipes.where((recipe) {
      // Поиск по названию и ингредиентам
      final searchMatch = searchQuery.isEmpty ||
          recipe.title?.toLowerCase().contains(searchQuery.toLowerCase()) == true ||
          recipe.ingredientsOne?.any((ingredient) => 
              ingredient.toLowerCase().contains(searchQuery.toLowerCase())) == true ||
          recipe.ingredientsTwo?.any((ingredient) => 
              ingredient.toLowerCase().contains(searchQuery.toLowerCase())) == true;

      // Фильтр по наличию изображения
      final imageFilterMatch = hasImage == null ||
          (hasImage ? recipe.hasImage : !recipe.hasImage);

      // Фильтр по времени приготовления
      final timeFilterMatch = maxPrepTime == null ||
          (recipe.prepTimeInMinutes != null && 
           recipe.prepTimeInMinutes! <= maxPrepTime);

      return searchMatch && imageFilterMatch && timeFilterMatch;
    }).toList();
  }
}