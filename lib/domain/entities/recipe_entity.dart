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

  String get shortText {
    if (text == null || text!.isEmpty) return '';
    return text!.length > 100 ? '${text!.substring(0, 100)}...' : text!;
  }

  int? get prepTimeInMinutes {
    if (prepTime == null) return null;
    try {
      return int.tryParse(prepTime!);
    } catch (_) {
      return null;
    }
  }
}