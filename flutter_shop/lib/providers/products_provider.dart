import 'package:flutter/material.dart';
import 'package:flutter_shop/models/http_exception.dart';
import 'product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _itemList = [
//    Product(
//      id: 'p1',
//      title: 'Red Shirt',
//      description: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageUrl:
//      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl:
//      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
  ];

  String _authToken;
  String _userId;

  Products(this._authToken, this._userId, this._itemList);

  List<Product> get items {
    return [..._itemList];
  }

  List<Product> get favItems {
    return _itemList.where((item) => item.isFavourite == true).toList();
  }

  Future<void> fetchAndSetProducts([bool isUser = false]) async {
    final forUser = isUser ? '&orderBy="creatorId"&equalTo="$_userId"' : '';
    final url =
        'https://flutter-app-7f5af.firebaseio.com/products.json?auth=$_authToken$forUser';
    final urlFav =
        'https://flutter-app-7f5af.firebaseio.com/userFavourites/$_userId.json?auth=$_authToken';
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final responseFav = await http.get(urlFav);
      final favData = json.decode(responseFav.body);
      final List<Product> loadedProducts = [];
      if (responseData != null) {
        responseData.forEach((prodId, prodData) {
          loadedProducts.add(Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              imageUrl: prodData['imageUrl'],
              price: prodData['price'],
              isFavourite: favData == null ? false : favData[prodId] ?? false));
        });
      }
      _itemList = loadedProducts;
    } catch (error) {
      throw error;
    }
  }

  Future<void> addItem(Product newProduct) async {
    final url =
        'https://flutter-app-7f5af.firebaseio.com/products.json?auth=$_authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl,
          'creatorId': _userId
        }),
      );
      final id = json.decode(response.body)['name'];
      newProduct.id = id;
      _itemList.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateItem(String productId, Product product) async {
    final url =
        'https://flutter-app-7f5af.firebaseio.com/products/$productId.json?auth=$_authToken';
    final index = _itemList.indexWhere((element) => element.id == productId);
    if (index >= 0) {
      await http.patch(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl
          }));
      _itemList[index] = product;
      notifyListeners();
    }
  }

  Product findById(String id) {
    return _itemList.firstWhere((item) => item.id == id);
  }

  Future<void> delete(String productId) async {
    final deleteIndex =
        _itemList.indexWhere((element) => element.id == productId);
    var deletedProduct = _itemList[deleteIndex];
    _itemList.removeAt(deleteIndex);
    notifyListeners();
    final url =
        'https://flutter-app-7f5af.firebaseio.com/products/$productId.json?auth=$_authToken';
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _itemList.insert(deleteIndex, deletedProduct);
      notifyListeners();
      throw HttpException("Something went wrong not able to Delete!!");
    }
    deletedProduct = null;
  }
}
