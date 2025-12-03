import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/favorites_service.dart';
import '../widgets/meal_grid_item.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoritesService = Provider.of<FavoritesService>(context);
    final favoriteMeals = favoritesService.favoriteMeals;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Омилени Рецепти'),
        automaticallyImplyLeading: false,
      ),
      body: favoriteMeals.isEmpty
          ? const Center(
        child: Text(
          'Немате додадено омилени рецепти.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: favoriteMeals.length,
        itemBuilder: (context, index) {
          return MealGridItem(meal: favoriteMeals[index]);
        },
      ),
    );
  }
}