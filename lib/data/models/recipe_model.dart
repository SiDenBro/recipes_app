import 'package:json_annotation/json_annotation.dart';

part 'recipe_model.g.dart';

@JsonSerializable(
  explicitToJson: true,
  createToJson: true,
  includeIfNull: false,
)
class RecipeModel {
  final String id;
  final String? title;
  final String? text;
  final String? image;
  final List<String>? steps;
  
  @JsonKey(name: 'prep_time')
  final String? prepTime;
  
  final String? energy;
  
  @JsonKey(name: 'ingredients_one')
  final List<String>? ingredientsOne;
  
  @JsonKey(name: 'ingredients_two')
  final List<String>? ingredientsTwo;
  
  @JsonKey(name: 'date_added')
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

  // Основной фабричный метод с кастомным парсингом
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

  // Автоматически сгенерированный toJson
  Map<String, dynamic> toJson() => _$RecipeModelToJson(this);

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
          return '${item['title']}: ${item['text']}\n';
        }
        return item.toString();
      }).toList();
      String text = energyList.join('');
      text = text.replaceAll('Б', 'Белки');
      text = text.replaceAll('Ж', 'Жиры');
      text = text.replaceAll('У', 'Углеводы');
      text = text.replaceAll('К', 'Каллории');
      return text;
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

  // Дополнительные удобные методы
  
  RecipeModel copyWith({
    String? id,
    String? title,
    String? text,
    String? image,
    List<String>? steps,
    String? prepTime,
    String? energy,
    List<String>? ingredientsOne,
    List<String>? ingredientsTwo,
    String? dateAdded,
    String? link,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
      image: image ?? this.image,
      steps: steps ?? this.steps,
      prepTime: prepTime ?? this.prepTime,
      energy: energy ?? this.energy,
      ingredientsOne: ingredientsOne ?? this.ingredientsOne,
      ingredientsTwo: ingredientsTwo ?? this.ingredientsTwo,
      dateAdded: dateAdded ?? this.dateAdded,
      link: link ?? this.link,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is RecipeModel &&
        other.id == id &&
        other.title == title &&
        other.text == text &&
        other.image == image &&
        _listEquals(other.steps, steps) &&
        other.prepTime == prepTime &&
        other.energy == energy &&
        _listEquals(other.ingredientsOne, ingredientsOne) &&
        _listEquals(other.ingredientsTwo, ingredientsTwo) &&
        other.dateAdded == dateAdded &&
        other.link == link;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      text,
      image,
      _listHash(steps),
      prepTime,
      energy,
      _listHash(ingredientsOne),
      _listHash(ingredientsTwo),
      dateAdded,
      link,
    );
  }

  static bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null) return false;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static int _listHash<T>(List<T>? list) {
    if (list == null) return 0;
    return Object.hashAll(list);
  }
}