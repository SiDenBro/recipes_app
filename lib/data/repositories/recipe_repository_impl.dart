import 'package:recipes_app/data/datasources/recipe_local_data_source.dart';
import 'package:recipes_app/data/datasources/recipe_remote_data_source.dart';
import 'package:recipes_app/domain/entities/recipe_entity.dart';
import 'package:recipes_app/domain/repositories/recipe_repository.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;
  final RecipeLocalDataSource localDataSource;

  RecipeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<RecipeEntity>> getRecipes() async {
    try {
      final models = await remoteDataSource.getRecipes();
      final entities = models.map((model) => RecipeEntity.fromModel(model)).toList();
      
      // Кэшируем успешно загруженные данные
      await cacheRecipes(entities);
      
      return entities;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<RecipeEntity>> getCachedRecipes() async {
    final models = await localDataSource.getCachedRecipes();
    return models.map((model) => RecipeEntity.fromModel(model)).toList();
  }

  @override
  Future<void> cacheRecipes(List<RecipeEntity> recipes) async {
    final models = recipes.map((entity) => entity.toModel()).toList();
    await localDataSource.cacheRecipes(models);
  }
}