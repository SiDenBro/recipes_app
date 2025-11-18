import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipes_app/domain/entities/recipe_entity.dart';

class RecipeCard extends StatelessWidget {
  final RecipeEntity recipe;
  final bool isOffline;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.isOffline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          context.go('/recipe/${recipe.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(context),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isOffline)
                    Row(
                      children: [
                        Icon(Icons.cloud_off, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          'Офлайн',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  if (isOffline) SizedBox(height: 4),
                  Text(
                    recipe.title ?? 'Без названия',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  if (recipe.prepTime != null)
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 16, color: Theme.of(context).textTheme.bodySmall?.color),
                        const SizedBox(width: 4),
                        Text(
                          recipe.prepTime!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.shortText,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    if (recipe.image == null || recipe.image!.isEmpty) {
      return Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color?.withOpacity(0.1) ?? Colors.grey[300],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Icon(
          Icons.fastfood,
          size: 64,
          color: Theme.of(context).iconTheme.color?.withOpacity(0.3) ?? Colors.grey,
        ),
      );
    }

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: CachedNetworkImage(
        imageUrl: recipe.image!,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Theme.of(context).cardTheme.color?.withOpacity(0.1) ?? Colors.grey[300],
          child: Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          height: 150,
          color: Theme.of(context).cardTheme.color?.withOpacity(0.1) ?? Colors.grey[300],
          child: Icon(
            Icons.broken_image,
            size: 64,
            color: Theme.of(context).iconTheme.color?.withOpacity(0.3) ?? Colors.grey,
          ),
        ),
      ),
    );
  }
}