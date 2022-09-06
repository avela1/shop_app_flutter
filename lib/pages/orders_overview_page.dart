import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../models/orders.dart' show Orders;

import './../widgets/order_item.dart';
import '../widgets/main_drawer.dart';

class OrdersOverviewPage extends StatefulWidget {
  const OrdersOverviewPage({Key? key}) : super(key: key);

  static const routeName = "/orders_overview";

  @override
  State<OrdersOverviewPage> createState() => _OrdersOverviewPageState();
}

class _OrdersOverviewPageState extends State<OrdersOverviewPage> {
  var _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Orders>(context, listen: false)
        .fetchAndSetOrders()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderdData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('OrdersOverviewPage')),
      drawer: const MainDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (ctx, i) {
                return OrderItem(
                  orderedItem: orderdData.orders[i],
                );
              },
              itemCount: orderdData.orders.length,
            ),
    );
  }
}
