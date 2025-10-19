class Meal {
  final String id;
  final String name;
  final String imageUrl;

  Meal({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      imageUrl: json['strMealThumb'] ?? '',
    );
  }
}

class MealDetail {
  final String id;
  final String name;
  final String imageUrl;
  final String instructions;
  final List<String> ingredients;

  MealDetail({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.instructions,
    required this.ingredients,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    final ingredients = <String>[];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.isNotEmpty && measure != null && measure.isNotEmpty) {
        ingredients.add('$ingredient - $measure');
      }
    }

    return MealDetail(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      imageUrl: json['strMealThumb'] ?? '',
      instructions: json['strInstructions'] ?? 'No hay instrucciones disponibles.',
      ingredients: ingredients,
    );
  }
}