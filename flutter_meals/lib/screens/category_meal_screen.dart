import 'package:flutter/material.dart';
import '../models/meals.dart';
import '../widgets/meal_item.dart';
import '../dummy_data.dart';

class CategoryMealScreen extends StatefulWidget {
  static final routeName = '/category-meal';

  @override
  _CategoryMealScreenState createState() => _CategoryMealScreenState();
}

class _CategoryMealScreenState extends State<CategoryMealScreen> {
  bool _isInitialize = false;
  String categoryTitle;
  List<Meal> displayMeals;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialize) {
      _isInitialize = true;
      final arguments =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      final categoryId = arguments['id'];
      categoryTitle = arguments['title'];
      displayMeals = DUMMY_MEALS.where((meals) {
        return meals.categories.contains(categoryId);
      }).toList();
    }
  }

  void removeMeal(String mealId) {
    setState(() {
      displayMeals.removeWhere((meal) => mealId == meal.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("$categoryTitle"),
        ),
        body: ListView.builder(
          itemBuilder: (ctx, index) {
            return MealItem(
              mealItem: displayMeals[index],
              removeItem: removeMeal,
            );
          },
          itemCount: displayMeals.length,
        ));
  }
}
