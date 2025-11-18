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
        
        if (data is String) {
          final decoded = json.decode(data);
          if (decoded is List) {
            return decoded.map((item) => RecipeModel.fromJson(item)).toList();
          }
        } else if (data is List) {
          return data.map((item) => RecipeModel.fromJson(item)).toList();
        }
        
        throw FormatException('Invalid response format');
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
    }
  }
}