import 'package:flutter/foundation.dart';
import 'package:flutter_shop/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final orderId;
  final products;
  final amount;
  final dateTime;

  OrderItem({
    @required this.orderId,
    @required this.products,
    @required this.amount,
    @required this.dateTime,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orderItems = [];

  List<OrderItem> get items {
    return [..._orderItems];
  }

  String _authToken;
  String _userId;

  Order(this._authToken, this._userId, this._orderItems);

  Future<void> addOrder(List<CartItem> products, double amount) async {
    final url =
        'https://flutter-app-7f5af.firebaseio.com/orders/$_userId.json?auth=$_authToken';
    final dateTime = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'dateTime': dateTime.toIso8601String(),
          'amount': amount,
          'products': products
              .map((element) => {
                    "productId": element.productId,
                    "title": element.title,
                    "price": element.price,
                    "quantity": element.quantity
                  })
              .toList()
        }),
      );
      final id = json.decode(response.body)['name'];
      _orderItems.add(OrderItem(
        orderId: id,
        products: products,
        amount: amount,
        dateTime: dateTime,
      ));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  /*(orderData['products'] as List<dynamic>).map((item) =>
  CartItem(
  productId:item['productId'],
  price:item['price'] ,
  quantity:item['quantity'] ,
  title:item['title']
  )).toList()*/

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://flutter-app-7f5af.firebaseio.com/orders/$_userId.json?auth=$_authToken';
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];
      responseData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          orderId: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  productId: item['productId'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title']))
              .toList(),
        ));
      });
      _orderItems = loadedOrders.reversed.toList();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
