import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_database/firebase_database.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import 'product.dart';

class Products with ChangeNotifier {
  final _dbref = FirebaseDatabase.instance.ref();
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  final String? uid;
  Products(this.uid, this._items);

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> fetchAndSetProduct() async {
    try {
      final products = await _dbref.child('products').get();
      final userFavorites =
          await _dbref.child('userFavorites').child(uid!).get();
      final getFavorite = userFavorites.value == null
          ? null
          : userFavorites.value as Map<dynamic, dynamic>;
      List<Product> loadedData = [];
      final productsData = products.value as Map<dynamic, dynamic>;
      productsData.forEach((prodId, prodData) {
        loadedData.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            price: prodData['price'].toDouble(),
            // ignore: unnecessary_null_comparison
            isFavorite:
                getFavorite == null ? false : getFavorite[prodId] ?? false,
          ),
        );
      });
      _items = loadedData;
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> addProduct(Product newProduct) async {
    var dataId = DateFormat.Hms().format(DateTime.now());
    try {
      await _dbref.child('products').child(dataId).set({
        'title': newProduct.title,
        'description': newProduct.description,
        'imageUrl': newProduct.imageUrl,
        'price': newProduct.price,
        'isFavorite': newProduct.isFavorite,
      });
      final product = Product(
        id: dataId,
        title: newProduct.title,
        description: newProduct.description,
        imageUrl: newProduct.imageUrl,
        price: newProduct.price,
        isFavorite: newProduct.isFavorite,
      );
      _items.add(product);
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final updatedProduct = _items.indexWhere((element) => element.id == id);
    try {
      if (updatedProduct >= 0) {
        await _dbref.child('products').child(id).update(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          },
        );
        _items[updatedProduct] = newProduct;
        notifyListeners();
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> deleteProduct(String id) async {
    final isItemExist = _items.indexWhere((element) => element.id == id);
    if (isItemExist != -1) {
      try {
        await _dbref.child('products').child(id).remove();
        _items.removeWhere((element) => element.id == id);
        notifyListeners();
      } catch (e) {
        throw Exception('Error Occured while deleting');
      }
    } else {
      throw Exception('Error Occured while deleting');
    }
    return;
  }

  Product findByID(String id) {
    return _items.firstWhere((element) => id == element.id);
  }
}
