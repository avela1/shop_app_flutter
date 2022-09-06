import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:shop_app/models/products.dart';

import './../models/cart.dart';

import './../pages/cart_overview_page.dart';

import '../widgets/main_drawer.dart';
import './../widgets/badge.dart';
import './../widgets/products_grid.dart';

// ignore_for_file: constant_identifier_names
enum FiltersOption { AllItems, Favorites }

class ProductOverviewPage extends StatefulWidget {
  const ProductOverviewPage({Key? key}) : super(key: key);

  @override
  State<ProductOverviewPage> createState() => _ProductOverviewPageState();
}

class _ProductOverviewPageState extends State<ProductOverviewPage> {
  var _isFavorite = false;
  var _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Products>(context, listen: false)
        .fetchAndSetProduct()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Queens Shop APP '),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FiltersOption.AllItems,
                child: Text('All Items'),
              ),
              const PopupMenuItem(
                value: FiltersOption.Favorites,
                child: Text('Favorites'),
              )
            ],
            onSelected: (FiltersOption selectedValue) {
              setState(() {
                if (selectedValue == FiltersOption.Favorites) {
                  _isFavorite = true;
                } else {
                  _isFavorite = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              value: cart.itemCount.toString(),
              child: IconButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  CartOverviewPage.routeName,
                ),
                icon: const Icon(Icons.shopping_cart_checkout),
              ),
            ),
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_isFavorite),
    );
  }
}
