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

  // Простой фабричный метод для создания из JSON
  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: _parseString(json['id']),
      title: _parseString(json['title']),
      text: _parseString(json['text']),
      image: _parseString(json['image']),
      steps: _parseStringList(json['steps']),
      prepTime: _parseString(json['prep_time']),
      energy: _parseString(json['energy']),
      ingredientsOne: _parseStringList(json['ingredients_one']),
      ingredientsTwo: _parseStringList(json['ingredients_two']),
      dateAdded: _parseString(json['date_added']),
      link: _parseString(json['link']),
    );
  }

  // Преобразование в JSON (для кэширования)
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

  static List<String>? _parseStringList(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      return value.map((item) => _parseString(item)).toList();
    }
    return null;
  }

  // Для отладки
  @override
  String toString() {
    return 'RecipeModel(id: $id, title: $title)';
  }
}