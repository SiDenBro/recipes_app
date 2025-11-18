part of 'recipes_bloc.dart';

abstract class RecipesState extends Equatable {
  const RecipesState();

  @override
  List<Object> get props => [];
}

class RecipesInitial extends RecipesState {}

class RecipesLoading extends RecipesState {}

class RecipesLoaded extends RecipesState {
  final List<RecipeEntity> recipes;
  final bool hasMore;
  final bool isOffline;

  const RecipesLoaded({
    required this.recipes,
    required this.hasMore,
    this.isOffline = false,
  });

  @override
  List<Object> get props => [recipes, hasMore, isOffline];
}

class RecipesError extends RecipesState {
  final String error;

  const RecipesError({required this.error});

  @override
  List<Object> get props => [error];
}