import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../models/products.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({Key? key}) : super(key: key);
  static const routeName = '/product_detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findByID(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.network(
              loadedProduct.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Each Price :-  \$ ${loadedProduct.price}',
            style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontFamily: 'Anton'),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              loadedProduct.description,
              softWrap: true,
              style: const TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                fontFamily: 'Lato',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      )),
    );
  }
}
