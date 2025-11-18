import 'package:recipes_app/data/models/recipe_model.dart';

class RecipeEntity {
  final String id;
  final String? title;
  final String? text;
  final String? image;
  final List<String>? steps;
  final String? prepTime;
  final String? energy;
  final List<String>? ingredientsOne;
  final List<String>? ingredientsTwo;
  final String? dateAdded;
  final String? link;

  RecipeEntity({
    required this.id,
    this.title,
    this.text,
    this.image,
    this.steps,
    this.prepTime,
    this.energy,
    this.ingredientsOne,
    this.ingredientsTwo,
    this.dateAdded,
    this.link,
  });

  // Удобные геттеры
  String get shortText {
    if (text == null || text!.isEmpty) return '';
    return text!.length > 100 ? '${text!.substring(0, 100)}...' : text!;
  }

  int? get prepTimeInMinutes {
    if (prepTime == null) return null;
    try {
      // Пытаемся извлечь число из строки времени
      final timeString = prepTime!.toLowerCase();
      if (timeString.contains('мин')) {
        final match = RegExp(r'(\d+)\s*мин').firstMatch(timeString);
        if (match != null) return int.tryParse(match.group(1)!);
      }
      return int.tryParse(RegExp(r'\d+').firstMatch(prepTime!)?.group(0) ?? '');
    } catch (_) {
      return null;
    }
  }

  bool get hasImage => image != null && image!.isNotEmpty;

  // Конвертация из модели
  factory RecipeEntity.fromModel(RecipeModel model) {
    return RecipeEntity(
      id: model.id,
      title: model.title,
      text: model.text,
      image: model.image,
      steps: model.steps,
      prepTime: model.prepTime,
      energy: model.energy,
      ingredientsOne: model.ingredientsOne,
      ingredientsTwo: model.ingredientsTwo,
      dateAdded: model.dateAdded,
      link: model.link,
    );
  }

  // Конвертация в модель (для кэширования)
  RecipeModel toModel() {
    return RecipeModel(
      id: id,
      title: title,
      text: text,
      image: image,
      steps: steps,
      prepTime: prepTime,
      energy: energy,
      ingredientsOne: ingredientsOne,
      ingredientsTwo: ingredientsTwo,
      dateAdded: dateAdded,
      link: link,
    );
  }

  // Для поиска
  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    
    final lowerQuery = query.toLowerCase();
    return title?.toLowerCase().contains(lowerQuery) == true ||
        ingredientsOne?.any((ingredient) => ingredient.toLowerCase().contains(lowerQuery)) == true ||
        ingredientsTwo?.any((ingredient) => ingredient.toLowerCase().contains(lowerQuery)) == true;
  }
}