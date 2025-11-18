import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:recipes_app/core/widgets/error_widget.dart';
import 'package:recipes_app/core/widgets/recipe_card.dart';
import 'package:recipes_app/core/widgets/search_filter_bar.dart';
import 'package:recipes_app/presentation/bloc/recipes/recipes_bloc.dart';
import 'package:recipes_app/presentation/bloc/theme/theme_bloc.dart';

class RecipesListPage extends StatefulWidget {
  const RecipesListPage({super.key});

  @override
  State<RecipesListPage> createState() => _RecipesListPageState();
}

class _RecipesListPageState extends State<RecipesListPage> {
  final RefreshController _refreshController = RefreshController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Загружаем рецепты при инициализации
    context.read<RecipesBloc>().add(LoadRecipes());
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<RecipesBloc>().add(LoadMoreRecipes());
    }
  }

  void _toggleTheme() {
    context.read<ThemeBloc>().add(ToggleTheme());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Рецепты'),
        actions: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              final isDarkTheme = themeState is ThemeLoaded ? themeState.isDarkTheme : false;
              return IconButton(
                icon: Icon(isDarkTheme ? Icons.light_mode : Icons.dark_mode),
                onPressed: _toggleTheme,
                tooltip: isDarkTheme ? 'Светлая тема' : 'Тёмная тема',
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<RecipesBloc, RecipesState>(
        listener: (context, state) {
          if (state is RecipesError) {
            _refreshController.refreshFailed();
          } else if (state is RecipesLoaded) {
            _refreshController.refreshCompleted();
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              const SearchFilterBar(),
              Expanded(
                child: _buildBody(state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(RecipesState state) {
    if (state is RecipesLoading) {
      return _buildLoading();
    } else if (state is RecipesError) {
      return CustomErrorWidget(
        error: state.error,
        onRetry: () => context.read<RecipesBloc>().add(LoadRecipes()),
      );
    } else if (state is RecipesLoaded) {
      return _buildRecipesList(state);
    } else {
      return const SizedBox();
    }
  }

  Widget _buildLoading() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Card(
            child: SizedBox(
              height: 150,
              child: Row(
                children: [
                  Container(
                    width: 120,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 20,
                            width: 150,
                            color: Theme.of(context).colorScheme.surfaceVariant,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 16,
                            width: 100,
                            color: Theme.of(context).colorScheme.surfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 14,
                            width: double.infinity,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 14,
                            width: 200,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecipesList(RecipesLoaded state) {
    if (state.recipes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off, 
              size: 64, 
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Рецепты не найдены',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return SmartRefresher(
      controller: _refreshController,
      onRefresh: () {
        context.read<RecipesBloc>().add(RefreshRecipes());
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: state.recipes.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.recipes.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final recipe = state.recipes[index];
          
          return AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 300),
            child: RecipeCard(
              recipe: recipe,
              isOffline: state.isOffline,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}