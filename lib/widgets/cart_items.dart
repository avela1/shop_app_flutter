import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import './../models/cart.dart';

class CartItems extends StatelessWidget {
  const CartItems(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price,
      required this.productId,
      Key? key})
      : super(key: key);
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String productId;

  @override
  Widget build(BuildContext context) {
    final double total = price * quantity;
    return Dismissible(
      key: ValueKey(id),
      secondaryBackground: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(10),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      background: Container(
        color: Colors.greenAccent,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(10),
        child: const Icon(Icons.exposure_minus_1, color: Colors.red, size: 30),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        if (direction == DismissDirection.endToStart) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Are you sure???'),
              content: const Text(
                  'You are going to delete this item from your cart'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('No')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Yes')),
              ],
            ),
          );
        } else {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Are you sure???'),
              content: const Text(
                  'You are going to remove one item from your cart list'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('No')),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          );
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          Provider.of<Cart>(context, listen: false).removeCartItem(productId);
        } else {
          Provider.of<Cart>(context, listen: false)
              .removeSingleCartItem(productId);
        }
      },
      child: Card(
        elevation: 6,
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                  child: Text(
                '\$ ${price.toStringAsFixed(2)}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              )),
            ),
          ),
          title: Text(title),
          subtitle: Text('Total :- \$ ${total.toStringAsFixed(2)}'),
          trailing: Text('$quantity X'),
        ),
      ),
    );
  }
}
