import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes_app/domain/entities/recipe_entity.dart';
import 'package:recipes_app/presentation/bloc/recipes/recipes_bloc.dart';

class RecipeDetailPage extends StatelessWidget {
  final String recipeId;

  const RecipeDetailPage({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали рецепта'),
      ),
      body: BlocBuilder<RecipesBloc, RecipesState>(
        builder: (context, state) {
          RecipeEntity? recipe;
          
          if (state is RecipesLoaded) {
            recipe = state.recipes.firstWhere(
              (r) => r.id == recipeId,
              orElse: () => _findRecipeInAllRecipes(context),
            );
          }

          if (recipe == null) {
            return const Center(child: Text('Рецепт не найден'));
          }

          return _buildRecipeDetail(recipe);
        },
      ),
    );
  }

  RecipeEntity _findRecipeInAllRecipes(BuildContext context) {
    final bloc = context.read<RecipesBloc>();
    // Здесь нужно получить доступ к полному списку рецептов из BLoC
    // Для простоты пока возвращаем пустой рецепт
    return RecipeEntity(id: recipeId);
  }

  Widget _buildRecipeDetail(RecipeEntity recipe) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(recipe),
          const SizedBox(height: 16),
          Text(
            recipe.title ?? 'Без названия',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(recipe),
          const SizedBox(height: 16),
          if (recipe.text != null && recipe.text!.isNotEmpty) ...[
            _buildSection('Описание', recipe.text!),
            const SizedBox(height: 16),
          ],
          if (recipe.ingredientsOne != null && recipe.ingredientsOne!.isNotEmpty) ...[
            _buildIngredientsSection('Ингредиенты 1', recipe.ingredientsOne!),
            const SizedBox(height: 16),
          ],
          if (recipe.ingredientsTwo != null && recipe.ingredientsTwo!.isNotEmpty) ...[
            _buildIngredientsSection('Ингредиенты 2', recipe.ingredientsTwo!),
            const SizedBox(height: 16),
          ],
          if (recipe.steps != null && recipe.steps!.isNotEmpty) ...[
            _buildStepsSection(recipe.steps!),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildImage(RecipeEntity recipe) {
    if (recipe.image == null || recipe.image!.isEmpty) {
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.fastfood,
          size: 64,
          color: Colors.grey,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: recipe.image!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[300],
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          height: 200,
          color: Colors.grey[300],
          child: const Icon(
            Icons.broken_image,
            size: 64,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(RecipeEntity recipe) {
    return Row(
      children: [
        if (recipe.prepTime != null) ...[
          _buildInfoItem(Icons.schedule, recipe.prepTime!),
          const SizedBox(width: 16),
        ],
        if (recipe.energy != null) 
          _buildInfoItem(Icons.local_fire_department, recipe.energy!),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildIngredientsSection(String title, List<String> ingredients) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...ingredients.map((ingredient) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(fontSize: 16)),
              Expanded(
                child: Text(
                  ingredient,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildStepsSection(List<String> steps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Шаги приготовления',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...steps.asMap().entries.map((entry) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${entry.key + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  entry.value,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}