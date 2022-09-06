import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_database/firebase_database.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import './../models/cart.dart';

class OrderItem {
  final double total;
  final List<CartItem> order;
  final DateTime dateTime;
  final String id;
  OrderItem({
    required this.id,
    required this.order,
    required this.total,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String? _uid;
  List<CartItem> items = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  Orders(this._uid, this._orders);
  final _dbref = FirebaseDatabase.instance.ref().child('orders');

  Future<void> fetchAndSetOrders() async {
    try {
      final orders = await _dbref.child(_uid!).get();
      List<OrderItem> loadedData = [];
      final ordersData = orders.value as Map<dynamic, dynamic>;
      ordersData.forEach((orderId, orderData) {
        loadedData.add(
          OrderItem(
            id: orderId,
            order: setItems(orderData['order']) as List<CartItem>,
            total: orderData['total'].toDouble(),
            dateTime: DateTime.parse(orderData['dateTime']),
          ),
        );
      });
      _orders = loadedData;
      items.clear;
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  List setItems(data) {
    items.clear();
    data
        .map((e) => {
              items.add(CartItem(
                id: e['id'],
                price: e['price'].toDouble(),
                quantity: e['quantity'].toInt(),
                title: e['title'],
              ))
            })
        .toList();
    return items;
  }

  Future<void> addOrder(List<CartItem> order, double total) async {
    var timestamp = DateTime.now();
    var orderId = DateFormat.Hms().format(timestamp);
    try {
      await _dbref.child(_uid!).child(orderId).set({
        'order': order
            .map((e) => {
                  'id': e.id,
                  'title': e.title,
                  'price': e.price,
                  'quantity': e.quantity,
                })
            .toList(),
        'total': total,
        'dateTime': timestamp.toIso8601String(),
      }).then((value) => {
            _orders.insert(
              0,
              OrderItem(
                id: DateTime.now().toString(),
                order: order,
                total: total,
                dateTime: DateTime.now(),
              ),
            ),
            notifyListeners(),
          });
    } catch (e) {
      // print(e);
    }
  }
}
