import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import './../models/products.dart';

import './../pages/add_edit_product_page.dart';

import './../widgets/manage_product_item.dart';
import './../widgets/main_drawer.dart';

class ManageProductPage extends StatelessWidget {
  const ManageProductPage({Key? key}) : super(key: key);

  static const routeName = '/manage_product';

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddEditProductPage.routeName);
            },
          ),
        ],
        title: const Text('Manage Products'),
      ),
      drawer: const MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemBuilder: (_, i) => Column(
            children: [
              const Divider(color: Colors.black),
              ManageProductItem(
                  id: productData.items[i].id,
                  imageUrl: productData.items[i].imageUrl,
                  title: productData.items[i].title),
            ],
          ),
          itemCount: productData.items.length,
        ),
      ),
    );
  }
}
