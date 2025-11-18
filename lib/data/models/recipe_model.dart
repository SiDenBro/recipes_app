class RecipeModel {
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

  RecipeModel({
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

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: _parseString(json['id']),
      title: _parseString(json['title']),
      text: _parseString(json['text']),
      image: _parseString(json['image']),
      steps: _parseComplexSteps(json['steps']),
      prepTime: _parseString(json['prep_time']),
      energy: _parseEnergy(json['energy']),
      ingredientsOne: _parseComplexIngredients(json['ingredients_one']),
      ingredientsTwo: _parseComplexIngredients(json['ingredients_two']),
      dateAdded: _parseString(json['date_added']),
      link: _parseString(json['link']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'image': image,
      'steps': steps,
      'prep_time': prepTime,
      'energy': energy,
      'ingredients_one': ingredientsOne,
      'ingredients_two': ingredientsTwo,
      'date_added': dateAdded,
      'link': link,
    };
  }

  // Вспомогательные методы для безопасного парсинга
  static String _parseString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }

  // Парсинг сложной структуры steps
  static List<String>? _parseComplexSteps(dynamic value) {
    if (value == null) return null;
    
    if (value is List) {
      return value.map((step) {
        if (step is String) {
          return step;
        } else if (step is Map<String, dynamic>) {
          // Извлекаем текст из объекта step
          return _parseString(step['text']);
        }
        return '';
      }).where((step) => step.isNotEmpty).toList();
    }
    
    return null;
  }

  // Парсинг energy (может быть строкой или списком объектов)
  static String? _parseEnergy(dynamic value) {
    if (value == null) return null;
    
    if (value is String) {
      return value;
    } else if (value is List) {
      // Если energy - это список объектов, преобразуем в строку
      final energyList = value.map((item) {
        if (item is Map<String, dynamic>) {
          return '${item['title']}: ${item['text']}';
        }
        return item.toString();
      }).toList();
      return energyList.join(', ');
    }
    
    return value.toString();
  }

  // Парсинг сложной структуры ingredients
  static List<String>? _parseComplexIngredients(dynamic value) {
    if (value == null) return null;
    
    if (value is List) {
      return value.map((ingredient) {
        if (ingredient is String) {
          return ingredient;
        } else if (ingredient is Map<String, dynamic>) {
          // Извлекаем title и text из объекта ingredient
          final title = _parseString(ingredient['title']);
          final text = _parseString(ingredient['text']);
          return '$title: $text';
        }
        return ingredient.toString();
      }).where((ingredient) => ingredient.isNotEmpty).toList();
    }
    
    return null;
  }

  @override
  String toString() {
    return 'RecipeModel(id: $id, title: $title)';
  }
}