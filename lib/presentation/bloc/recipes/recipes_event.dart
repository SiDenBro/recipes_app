part of 'recipes_bloc.dart';

abstract class RecipesEvent extends Equatable {
  const RecipesEvent();

  @override
  List<Object> get props => [];
}

class LoadRecipes extends RecipesEvent {}

class RefreshRecipes extends RecipesEvent {}

class FilterRecipes extends RecipesEvent {
  final String searchQuery;
  final bool? hasImage;
  final int? maxPrepTime;

  const FilterRecipes({
    this.searchQuery = '',
    this.hasImage,
    this.maxPrepTime,
  });

  @override
  List<Object> get props => [searchQuery, hasImage ?? false, maxPrepTime ?? 0];
}

class LoadMoreRecipes extends RecipesEvent {}