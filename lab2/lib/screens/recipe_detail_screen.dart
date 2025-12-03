import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/recipe.dart';
import '../models/meal.dart';
import '../services/meal_api_service.dart';
import '../services/favorites_service.dart';

class RecipeDetailScreen extends StatelessWidget {
  final String mealId;
  final Recipe? initialRecipe;

  const RecipeDetailScreen({
    Key? key,
    required this.mealId,
    this.initialRecipe,
  }) : super(key: key);

  Future<Recipe> _loadRecipe() async {
    if (initialRecipe != null) {
      return initialRecipe!;
    }
    return MealApiService().fetchRecipeById(mealId);
  }

  void _launchYouTube(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {

    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritesService = Provider.of<FavoritesService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детален рецепт'),
        actions: [
          FutureBuilder<Recipe>(
            future: _loadRecipe(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                final recipe = snapshot.data!;
                final isFavorite = favoritesService.isFavorite(recipe.idMeal);
                final meal = Meal(
                    idMeal: recipe.idMeal,
                    strMeal: recipe.strMeal,
                    strMealThumb: recipe.strMealThumb
                );

                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    favoritesService.toggleFavorite(meal);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFavorite
                              ? '${recipe.strMeal} отстранет од омилени.'
                              : '${recipe.strMeal} додаден во омилени.',
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink(); // Не покажувај ништо додека се вчитува
            },
          ),
        ],
      ),
      body: FutureBuilder<Recipe>(
        future: _loadRecipe(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Грешка при вчитување на рецептот: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Рецептот не е пронајден.'));
          }

          final recipe = snapshot.data!;
          // ... (остатокот од Widget build)
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    recipe.strMealThumb,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  recipe.strMeal,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const Divider(height: 30),

                const Text(
                  'Инструкции',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.blueGrey),
                ),
                const SizedBox(height: 10),
                Text(
                  recipe.strInstructions,
                  style: const TextStyle(fontSize: 16),
                ),
                const Divider(height: 30),
                const Text(
                  'Состојки',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.blueGrey),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recipe.ingredients.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              recipe.ingredients[index],
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              recipe.measures[index],
                              style: const TextStyle(fontSize: 16, color: Colors.grey),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(height: 30),

                if (recipe.strYoutube != null && recipe.strYoutube!.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: () => _launchYouTube(recipe.strYoutube!),
                    icon: const Icon(Icons.play_circle_fill, color: Colors.red,),
                    label: const Text('Гледај го рецептот на YouTube', style: TextStyle(color: Colors.red),),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}