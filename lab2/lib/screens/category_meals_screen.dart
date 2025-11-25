// screens/category_meals_screen.dart
import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/meal_api_service.dart';
import '../widgets/meal_grid_item.dart';

class CategoryMealsScreen extends StatefulWidget {
  final String categoryName;

  const CategoryMealsScreen({Key? key, required this.categoryName}) : super(key: key);

  @override
  State<CategoryMealsScreen> createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  final MealApiService _apiService = MealApiService();
  late Future<List<Meal>> _mealsFuture;
  List<Meal> _allMeals = [];
  List<Meal> _filteredMeals = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mealsFuture = _loadInitialMeals();
    _searchController.addListener(_filterMeals);
  }

  Future<List<Meal>> _loadInitialMeals() async {
    final meals = await _apiService.fetchMealsByCategory(widget.categoryName);
    setState(() {
      _allMeals = meals;
      _filteredMeals = meals;
    });
    return meals;
  }

  void _filterMeals() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMeals = _allMeals
          .where((meal) => meal.strMeal.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryName} јадења'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Пребарување на јадења...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Meal>>(
              future: _mealsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Грешка: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Нема пронајдени јадења во оваа категорија.'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _filteredMeals.length,
                  itemBuilder: (context, index) {
                    return MealGridItem(meal: _filteredMeals[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}