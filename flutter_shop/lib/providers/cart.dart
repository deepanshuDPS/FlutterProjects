import 'package:flutter/foundation.dart';

class CartItem {
  final productId;
  final title;
  final price;
  final quantity;

  CartItem({
    @required this.productId,
    @required this.title,
    @required this.price,
    @required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get items {
    return {..._cartItems};
  }

  int get itemCount {
    return _cartItems.length;
  }

  void addItem(String productId, String title, double price) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
          productId,
          (existingItem) => CartItem(
                productId: existingItem.productId,
                title: title,
                price: price,
                quantity: existingItem.quantity + 1,
              ));
    } else {
      _cartItems.putIfAbsent(
          productId,
          () => CartItem(
                productId: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  double get totalPrice {
    var total = 0.0;
    _cartItems.forEach((_, value) {
      total += (value.price * value.quantity);
    });
    return total;
  }

  void removeItem(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void undoItem(String productId) {
    if (!_cartItems.containsKey(productId)) {
      return;
    }
    if (_cartItems[productId].quantity > 1) {
      _cartItems.update(
          productId,
          (existing) => CartItem(
                productId: existing.productId,
                title: existing.title,
                price: existing.price,
                quantity: existing.quantity - 1,
              ));
    } else {
      _cartItems.remove(productId);
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
