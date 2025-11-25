class Recipe {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;
  final String strInstructions;
  final String? strYoutube;
  final List<String> ingredients;
  final List<String> measures;

  Recipe({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
    required this.strInstructions,
    this.strYoutube,
    required this.ingredients,
    required this.measures,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    // Екстракција на состојки и мерки (API враќа strIngredient1-20 и strMeasure1-20)
    List<String> ingredients = [];
    List<String> measures = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.isNotEmpty && ingredient.trim() != '') {
        ingredients.add(ingredient);
        measures.add(measure ?? ''); // Measure може да е null/празен
      }
    }

    return Recipe(
      idMeal: json['idMeal'] as String,
      strMeal: json['strMeal'] as String,
      strMealThumb: json['strMealThumb'] as String,
      strInstructions: json['strInstructions'] as String,
      strYoutube: json['strYoutube'] as String?,
      ingredients: ingredients,
      measures: measures,
    );
  }
}