

import 'package:flutter/foundation.dart';

enum Complexity{
  Simple,
  Challenging,
  Hard
}

enum Affordability{
  Affordable,
  Pricey,
  Luxurious
}

class Meal {

  final String id;
  final List<String> categories;
  final String title;
  final Affordability affordability;
  final Complexity complexity;
  final String imageUrl;
  final int duration;
  final List<String> ingredients;
  final List<String> steps;
  final bool isGlutenFree;
  final bool isVegan;
  final bool isVegetarian;
  final bool isLactoseFree;

  const Meal({@required this.id, @required this.categories, @required this.title, @required this.imageUrl, @required this.ingredients, @required this.steps, @required this.duration, @required this.complexity, @required this.affordability, @required this.isGlutenFree, @required this.isVegan, @required this.isVegetarian, @required this.isLactoseFree});

}