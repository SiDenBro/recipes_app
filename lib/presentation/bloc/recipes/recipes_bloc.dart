import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:recipes_app/domain/entities/recipe_entity.dart';
import 'package:recipes_app/domain/use_cases/cache_recipes_use_case.dart';
import 'package:recipes_app/domain/use_cases/filter_recipes_use_case.dart';
import 'package:recipes_app/domain/use_cases/get_cached_recipes_use_case.dart';
import 'package:recipes_app/domain/use_cases/get_recipes_use_case.dart';

part 'recipes_event.dart';
part 'recipes_state.dart';

class RecipesBloc extends Bloc<RecipesEvent, RecipesState> {
  final GetRecipesUseCase getRecipesUseCase;
  final GetCachedRecipesUseCase getCachedRecipesUseCase;
  final CacheRecipesUseCase cacheRecipesUseCase;
  final FilterRecipesUseCase filterRecipesUseCase;

  RecipesBloc({
    required this.getRecipesUseCase,
    required this.getCachedRecipesUseCase,
    required this.cacheRecipesUseCase,
    required this.filterRecipesUseCase,
  }) : super(RecipesInitial()) {
    on<LoadRecipes>(_onLoadRecipes);
    on<RefreshRecipes>(_onRefreshRecipes);
    on<FilterRecipes>(_onFilterRecipes);
    on<LoadMoreRecipes>(_onLoadMoreRecipes);
  }

  List<RecipeEntity> _allRecipes = [];
  List<RecipeEntity> _filteredRecipes = [];

  Future<void> _onLoadRecipes(
    LoadRecipes event,
    Emitter<RecipesState> emit,
  ) async {
    emit(RecipesLoading());
    
    try {
      final recipes = await getRecipesUseCase();
      _allRecipes = recipes;
      _filteredRecipes = recipes;
      
      // Кэшируем рецепты
      await cacheRecipesUseCase(recipes);
      
      emit(RecipesLoaded(
        recipes: _getPaginatedRecipes(0),
        hasMore: recipes.length > 10,
      ));
    } catch (e) {
      // При ошибке пробуем загрузить из кэша
      try {
        final cachedRecipes = await getCachedRecipesUseCase();
        if (cachedRecipes.isNotEmpty) {
          _allRecipes = cachedRecipes;
          _filteredRecipes = cachedRecipes;
          emit(RecipesLoaded(
            recipes: _getPaginatedRecipes(0),
            hasMore: cachedRecipes.length > 10,
            isOffline: true,
          ));
        } else {
          emit(RecipesError(error: e.toString()));
        }
      } catch (_) {
        emit(RecipesError(error: e.toString()));
      }
    }
  }

  Future<void> _onRefreshRecipes(
    RefreshRecipes event,
    Emitter<RecipesState> emit,
  ) async {
    try {
      final recipes = await getRecipesUseCase();
      _allRecipes = recipes;
      _filteredRecipes = recipes;
      
      await cacheRecipesUseCase(recipes);
      
      emit(RecipesLoaded(
        recipes: _getPaginatedRecipes(0),
        hasMore: recipes.length > 10,
      ));
    } catch (e) {
      emit(RecipesError(error: e.toString()));
    }
  }

  void _onFilterRecipes(
    FilterRecipes event,
    Emitter<RecipesState> emit,
  ) {
    if (state is! RecipesLoaded) return;

    _filteredRecipes = filterRecipesUseCase(
      allRecipes: _allRecipes,
      searchQuery: event.searchQuery,
      hasImage: event.hasImage,
      maxPrepTime: event.maxPrepTime,
    );

    final currentState = state as RecipesLoaded;
    
    emit(RecipesLoaded(
      recipes: _getPaginatedRecipes(0),
      hasMore: _filteredRecipes.length > 10,
      isOffline: currentState.isOffline,
    ));
  }

  void _onLoadMoreRecipes(
    LoadMoreRecipes event,
    Emitter<RecipesState> emit,
  ) {
    if (state is! RecipesLoaded) return;

    final currentState = state as RecipesLoaded;
    final currentCount = currentState.recipes.length;
    
    if (currentCount >= _filteredRecipes.length) return;

    final newRecipes = _getPaginatedRecipes(currentCount);
    
    emit(RecipesLoaded(
      recipes: [...currentState.recipes, ...newRecipes],
      hasMore: currentCount + newRecipes.length < _filteredRecipes.length,
      isOffline: currentState.isOffline,
    ));
  }

  List<RecipeEntity> _getPaginatedRecipes(int startIndex) {
    final endIndex = startIndex + 10;
    return _filteredRecipes.sublist(
      startIndex,
      endIndex > _filteredRecipes.length ? _filteredRecipes.length : endIndex,
    );
  }
}