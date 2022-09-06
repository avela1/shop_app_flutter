import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../models/auth.dart';

import '../pages/manage_product_page.dart';
import '../pages/orders_overview_page.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: const Text('hello there'),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.shop),
          title: const Text('Shop'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.payment),
          title: const Text('Orders Overview'),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(OrdersOverviewPage.routeName);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.list),
          title: const Text('Manage Product'),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(ManageProductPage.routeName);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Logout'),
          onTap: () {
            Provider.of<Auth>(context, listen: false).logout();
          },
        )
      ]),
    );
  }
}
