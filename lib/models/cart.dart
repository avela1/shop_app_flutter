import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  final Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get cartItems {
    return _cartItems;
  }

  int get itemCount {
    return _cartItems.length;
  }

  double get totalAmount {
    var total = 0.0;
    _cartItems.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addToCart(String prodId, String title, double price) {
    if (_cartItems.containsKey(prodId)) {
      _cartItems.update(
        prodId,
        (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
        ),
      );
    } else {
      _cartItems.putIfAbsent(
        prodId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }

    notifyListeners();
  }

  void removeCartItem(String id) {
    _cartItems.remove(id);
    notifyListeners();
  }

  void removeSingleCartItem(String id) {
    if (!_cartItems.containsKey(id)) return;
    if (_cartItems[id]?.quantity == 1) {
      _cartItems.remove(id);
    } else {
      _cartItems.update(
        id,
        (value) => CartItem(
          id: value.id,
          quantity: value.quantity - 1,
          price: value.price,
          title: value.title,
        ),
      );
    }
    notifyListeners();
  }

  void clearCartItems() {
    _cartItems.clear();
    notifyListeners();
  }
}
