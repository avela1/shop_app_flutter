import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_database/firebase_database.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleIsFavorite(String? uid) async {
    final oldFavorite = isFavorite;

    final dbref =
        FirebaseDatabase.instance.ref().child('userFavorites').child('$uid');
    try {
      isFavorite = !isFavorite;
      await dbref.update({id: isFavorite});
      notifyListeners();
    } catch (e) {
      isFavorite = oldFavorite;
      notifyListeners();
    }
  }
}
