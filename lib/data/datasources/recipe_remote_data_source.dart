import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:recipes_app/data/models/recipe_model.dart';

abstract class RecipeRemoteDataSource {
  Future<List<RecipeModel>> getRecipes();
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final Dio dio;

  RecipeRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<RecipeModel>> getRecipes() async {
    try {
      final response = await dio.get(
        'https://madeindream.com/index.php?route=api/app/getRecipes',
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        // Обрабатываем разные форматы ответа
        List<dynamic> recipesList;
        
        if (data is String) {
          // Если ответ пришел как строка, декодируем JSON
          final decoded = json.decode(data);
          if (decoded is Map<String, dynamic> && decoded.containsKey('news')) {
            recipesList = decoded['news'];
          } else if (decoded is List) {
            recipesList = decoded;
          } else {
            throw FormatException('Invalid response format: expected object with "news" field or array');
          }
        } else if (data is Map<String, dynamic>) {
          // Если ответ уже Map и содержит поле "news"
          if (data.containsKey('news')) {
            recipesList = data['news'];
          } else {
            throw FormatException('Response object does not contain "news" field');
          }
        } else if (data is List) {
          // Если ответ уже массив
          recipesList = data;
        } else {
          throw FormatException('Unknown response format: ${data.runtimeType}');
        }

        // Парсим список рецептов
        return recipesList.map((item) {
          try {
            return RecipeModel.fromJson(item);
          } catch (e) {
            // Логируем ошибку парсинга отдельного элемента, но продолжаем обработку остальных
            //print('Error parsing recipe: $e');
            return RecipeModel(id: 'error', title: 'Error parsing recipe');
          }
        }).where((recipe) => recipe.id != 'error').toList();
        
      } else {
        throw Exception('Failed to load recipes: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection.');
      } else {
        throw Exception('Failed to load recipes: ${e.message}');
      }
    } on FormatException catch (e) {
      throw Exception('Invalid data format from server: ${e.message}');
    }
  }
}