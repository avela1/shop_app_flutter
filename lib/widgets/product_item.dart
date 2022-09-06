import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import './../models/cart.dart';
import '../models/product.dart';

import './../pages/product_detail_page.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Product>(context);
    final carts = Provider.of<Cart>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            products.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (ctx, products, child) => IconButton(
              icon: Icon(
                  products.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () => products
                  .toggleIsFavorite(FirebaseAuth.instance.currentUser?.uid),
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              carts.addToCart(products.id, products.title, products.price);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${products.title} is Add To Your Cart'),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      carts.removeSingleCartItem(products.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
        child: GestureDetector(
          onTap: (() => Navigator.of(context)
              .pushNamed(ProductDetailPage.routeName, arguments: products.id)),
          child: Image.network(
            products.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
