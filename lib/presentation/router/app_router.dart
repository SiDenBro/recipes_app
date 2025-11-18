import 'package:go_router/go_router.dart';
import 'package:recipes_app/presentation/pages/recipe_detail_page.dart';
import 'package:recipes_app/presentation/pages/recipes_list_page.dart';

class AppRouter {
  static GoRouter get router => _router;

  static final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const RecipesListPage(),
        routes: [
          GoRoute(
            path: 'recipe/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return RecipeDetailPage(recipeId: id);
            },
          ),
        ],
      ),
    ],
  );
}