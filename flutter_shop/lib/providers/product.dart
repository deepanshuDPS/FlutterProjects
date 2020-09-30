import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  String id;
  final String title;
  final String imageUrl;
  final String description;
  final double price;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.imageUrl,
      @required this.description,
      @required this.price,
      this.isFavourite = false});

  void _setFavStatus(bool status) {
    isFavourite = status;
    notifyListeners();
  }

  Future<void> toggleFavouriteState(String authToken, String userId) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url =
        'https://flutter-app-7f5af.firebaseio.com/userFavourites/$userId/$id.json?auth=$authToken';
    try {
      final response = await http.put(url, body: json.encode(isFavourite));
      if (response.statusCode >= 400) _setFavStatus(oldStatus);
    } catch (error) {
      _setFavStatus(oldStatus);
    }
  }
}
