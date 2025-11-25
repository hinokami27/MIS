import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';
import '../models/recipe.dart';

class MealApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/categories.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final categoriesJson = data['categories'] as List;
      return categoriesJson.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Meal>> fetchMealsByCategory(String categoryName) async {
    final response = await http.get(Uri.parse('$_baseUrl/filter.php?c=$categoryName'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] == null) return [];
      final mealsJson = data['meals'] as List;
      return mealsJson.map((json) => Meal.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load meals for category $categoryName');
    }
  }

  Future<List<Meal>> searchMeals(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/search.php?s=$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] == null) return [];
      final mealsJson = data['meals'] as List;
      return mealsJson.map((json) => Meal.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search meals');
    }
  }


  Future<Recipe> fetchRecipeById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/lookup.php?i=$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final recipeJson = data['meals'][0];
      return Recipe.fromJson(recipeJson);
    } else {
      throw Exception('Failed to load recipe for ID $id');
    }
  }

  Future<Recipe> fetchRandomRecipe() async {
    final response = await http.get(Uri.parse('$_baseUrl/random.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final recipeJson = data['meals'][0];
      return Recipe.fromJson(recipeJson);
    } else {
      throw Exception('Failed to load random recipe');
    }
  }
}