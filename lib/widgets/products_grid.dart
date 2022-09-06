import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../models/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid(this.isFavorite, {Key? key}) : super(key: key);
  final bool isFavorite;
  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<Products>(context);
    final products =
        isFavorite ? providerData.favoriteItems : providerData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        // create: ((context) => products[i]),
        child: const ProductItem(),
      ),
      itemCount: products.length,
    );
  }
}
