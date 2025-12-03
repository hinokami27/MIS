import 'package:flutter/material.dart';
import '../models/meal.dart';
import 'dart:collection';


class FavoritesService with ChangeNotifier {
  final List<Meal> _favoriteMeals = [];

  UnmodifiableListView<Meal> get favoriteMeals => UnmodifiableListView(_favoriteMeals);

  bool isFavorite(String mealId) {
    return _favoriteMeals.any((meal) => meal.idMeal == mealId);
  }

  void toggleFavorite(Meal meal) {
    final isCurrentlyFavorite = isFavorite(meal.idMeal);

    if (isCurrentlyFavorite) {
      _favoriteMeals.removeWhere((m) => m.idMeal == meal.idMeal);
    } else {
      _favoriteMeals.add(meal);
    }

    notifyListeners();
  }
}