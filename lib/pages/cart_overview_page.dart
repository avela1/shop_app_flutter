import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../widgets/cart_items.dart';

import './../models/orders.dart';
import './../models/cart.dart';

class CartOverviewPage extends StatelessWidget {
  const CartOverviewPage({
    Key? key,
  }) : super(key: key);
  static const routeName = "/cart_overview";

  @override
  Widget build(BuildContext context) {
    final item = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Carts')),
      body: Column(
        children: [
          Card(
            elevation: 6,
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    'Total:-',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Chip(
                    label: Text(
                      '\$ ${item.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  const Spacer(),
                  OrderButton(item: item),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemBuilder: ((context, i) {
                  return CartItems(
                    id: item.cartItems.values.toList()[i].id,
                    title: item.cartItems.values.toList()[i].title,
                    quantity: item.cartItems.values.toList()[i].quantity,
                    price: item.cartItems.values.toList()[i].price,
                    productId: item.cartItems.keys.toList()[i],
                  );
                }),
                itemCount: item.cartItems.values.toList().length),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Cart item;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoding = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.item.totalAmount <= 0 || _isLoding)
          ? null
          : () async {
              setState(() {
                _isLoding = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.item.cartItems.values.toList(),
                widget.item.totalAmount,
              );
              setState(() {
                _isLoding = false;
              });
              widget.item.clearCartItems();
            },
      child: _isLoding
          ? const CircularProgressIndicator()
          : const Text('Order Now'),
    );
  }
}
