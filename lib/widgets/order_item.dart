import 'dart:math';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import './../models/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  const OrderItem({Key? key, required this.orderedItem}) : super(key: key);
  final ord.OrderItem orderedItem;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.orderedItem.total.toStringAsFixed(2),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            subtitle: Text(
              DateFormat('dd/mm/yyyy -> hh:mm')
                  .format(widget.orderedItem.dateTime),
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            trailing: IconButton(
              icon: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),
          if (isExpanded) const Divider(),
          if (isExpanded)
            Container(
              height: min(widget.orderedItem.order.length * 30.0, 100),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: ListView(
                children: widget.orderedItem.order
                    .map((item) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(
                              'Total: ${item.quantity * item.price}',
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
